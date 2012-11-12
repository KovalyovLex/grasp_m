function rundex_callbacks(to_do)

global grasp_handles
global grasp_env
global inst_params
global status_flags

switch to_do
    
    case 'close'
        grasp_handles.window_modules.rundex.window = [];
        
    case 'rundex'
        
        %Retrieve Parameters Back From Rundex Window
        numor1 = str2num(get(grasp_handles.window_modules.rundex.numor1,'string'));
        numor2 = str2num(get(grasp_handles.window_modules.rundex.numor2,'string'));
        skip = str2num(get(grasp_handles.window_modules.rundex.skip,'string'));
        extra = str2num(get(grasp_handles.window_modules.rundex.params,'string'));
        if numor2 ==0; numor2 = numor1; end
        
        %***** Open text file for output *****
        fname = '*.dex';
        start_string = [grasp_env.path.project_dir fname];
        [fname, directory] = uiputfile(start_string,'Save Rundex As:');
        
        if fname == 0
            write_file_flag = 0;
        else
            if isempty(findstr(fname,'.dex')); fname = [fname '.dex']; end
            grasp_env.path.project_dir = directory;
            fid=fopen([directory fname],'w');
            write_file_flag = 1;
        end
        
        %***** Two lines of header *****
        time = fix(clock);
        textstring = ['Rundex Directory File Listing:'];
        if write_file_flag == 1; fprintf(fid,'%s',[textstring char(13) char(10)]); end
        textstring = ['Created by ' grasp_env.grasp_name  ';  Date ' num2str(time(3)) '/' num2str(time(2)) '/' num2str(time(1)) '; Time ' num2str(time(4)) ':' num2str(time(5)) ':' num2str(time(6))];
        if write_file_flag == 1; fprintf(fid,'%s',[textstring char(13) char(10)]); fprintf(fid,'%s',[char(13) char(10)]); end
        
        %***** Header text *******
        disp_string = ['Run     User       Title                   Det     Col     Wav     Time    Monitor   DetSum    Det/s     '];
        %Now add aditional user params names
        if extra > 0
            len = length(extra);
            for m = 1:len
                disp_string = [disp_string char(inst_params.vector_names{extra(m)}) blanks(8-length(char(inst_params.vector_names{extra(m)})))];
            end
        end
        
        disp(' ');
        disp(disp_string); %Write to Screen
        if write_file_flag ==1; fprintf(fid,'%s',[disp_string char(13) char(10)]); end %Write to file
        
        %***** Search though Numors *****
        last_col = []; last_det = []; last_att = []; last_wav = []; last_dtr = []; col_app_str = ' ';
        for numor = numor1:skip:numor2
            
            %Prepare the full file name string
            numors_str = [status_flags.fname_extension.shortname num2str(numor,['%.' num2str(inst_params.filename.numeric_length) 'i']) status_flags.fname_extension.extension];
            %Full path to file
            file_name_path = fullfile(grasp_env.path.data_dir,numors_str);
            disp(' ')
            disp(['Loading file:  ' file_name_path]);
            
            %Check for file decompression (using gzip)
            file_name_path = numor_decompress(file_name_path);
            
            %Read the file
            if not(isempty(file_name_path))
                fn_string = [inst_params.filename.data_loader '(file_name_path,''rundex'')'];
                numor_data = eval(fn_string);
                param = numor_data.params1;
                
                %Collimation change notification
                new_col = param(inst_params.vectors.col);
                if not(isempty(last_col))
                    if last_col ~= new_col;
                        
                        col_app_str = ' ';
                        if isfield(inst_params.vectors,'col_app')
                            if param(inst_params.vectors.col_app) == 0; col_app_str = 'R';
                            else col_app_str = 'C';
                            end
                        end
                        disp_string = ['Collimation Change from ' num2str(last_col) ' (m)   >  ' num2str(new_col) ' (m) ' col_app_str];
                        fprintf(fid,'%s',[char(13) char(10)]);
                        fprintf(fid,'%s',[disp_string char(13) char(10)]);
                        fprintf(fid,'%s',[char(13) char(10)]);
                    end
                end
                last_col = new_col;
                
                %Attentuator change notification
                new_att = param(inst_params.vectors.att_type);
                if not(isempty(last_att))
                    if last_att ~= new_att;
                        disp_string = ['Attenuator Change from Att# ' num2str(last_att) '  >  Att# ' num2str(new_att)];
                        fprintf(fid,'%s',[char(13) char(10)]);
                        fprintf(fid,'%s',[disp_string char(13) char(10)]);
                        fprintf(fid,'%s',[char(13) char(10)]);
                    end
                end
                last_att = new_att;
                
                %Detector Distance change notification
                new_det = param(inst_params.vectors.det);
                if not(isempty(last_det))
                    if last_det ~= new_det;
                        disp_string = ['Detector Distance Change from ' num2str(last_det) ' (m)  >  ' num2str(new_det) ' (m)'];
                        fprintf(fid,'%s',[char(13) char(10)]);
                        fprintf(fid,'%s',[disp_string char(13) char(10)]);
                        fprintf(fid,'%s',[char(13) char(10)]);
                    end
                end
                last_det = new_det;
                
                %DTR change notification
                if isfield(inst_params.vectors,'dtr');
                    new_dtr = param(inst_params.vectors.dtr);
                    if not(isempty(last_dtr))
                        if last_dtr ~= new_dtr;
                            disp_string = ['Detector Translation (DTR) Change from ' num2str(last_dtr) ' (m)  >  ' num2str(new_dtr) ' (m)'];
                            fprintf(fid,'%s',[char(13) char(10)]);
                            fprintf(fid,'%s',[disp_string char(13) char(10)]);
                            fprintf(fid,'%s',[char(13) char(10)]);
                        end
                    end
                    last_dtr = new_dtr;
                end
                
                
                %Wavelength change notification
                %Needs to be a bit more sensitive as wavelength wanders a bit
                new_wav = param(inst_params.vectors.wav);
                if not(isempty(last_wav))
                    if last_wav < new_wav*0.9 || last_wav > new_wav*1.1;
                        disp_string = ['Wavelength Change from ' num2str(last_wav) ' (�)  >  ' num2str(new_wav) ' (�)'];
                        fprintf(fid,'%s',[char(13) char(10)]);
                        fprintf(fid,'%s',[disp_string char(13) char(10)]);
                        fprintf(fid,'%s',[char(13) char(10)]);
                    end
                end
                last_wav = new_wav;
                if abs(param(inst_params.vectors.by)) > 99; trans_flag = 'T';
                else trans_flag = ' ';
                end
                
                
                
                if isfield(numor_data.info,'user'); user = numor_data.info.user; else user = '        '; end
                user = [user '                    ']; user = user(1:7); %pad then truncate
                
                title = numor_data.subtitle; title= [title '                                 ']; title = title(1:18);
                
                
                %Numor, title, monitor, monitor/s
                disp_string = [num2str(numor) blanks(8-length(num2str(numor)))]; %Numor
                disp_string = [disp_string user '   ']; %User
                disp_string = [disp_string title '   ']; %Title
                disp_string = [disp_string ' ' trans_flag '  '];
                
                disp_string = [disp_string num2str(param(inst_params.vectors.det),'%6.1f') blanks(8-length(num2str(param(inst_params.vectors.det),'%6.1f')))]; %Det
                
                %Find which col_app
                if isfield(inst_params.vectors,'col_app')
                    if param(inst_params.vectors.col_app) == 0; col_app_str = 'R';
                    elseif param(inst_params.vectors.col_app) ==1; col_app_str = 'C';
                    else col_app_str = ' ';
                    end
                end
                disp_string = [disp_string num2str(param(inst_params.vectors.col),'%6.1f')  col_app_str blanks(7-length(num2str(param(inst_params.vectors.col),'%6.1f')))]; %Col
                disp_string = [disp_string num2str(param(inst_params.vectors.wav),'%6.1f') blanks(8-length(num2str(param(inst_params.vectors.wav),'%6.1f')))]; %Wav
                disp_string = [disp_string num2str(param(inst_params.vectors.time)) blanks(8-length(num2str(param(inst_params.vectors.time))))]; %Time
                disp_string = [disp_string num2str(param(inst_params.vectors.monitor)) blanks(10-length(num2str(param(inst_params.vectors.monitor))))]; %Monitor
                disp_string = [disp_string num2str(param(inst_params.vectors.array_counts)) blanks(10-length(num2str(param(inst_params.vectors.array_counts))))]; %DetSum
                disp_string = [disp_string num2str(param(inst_params.vectors.array_counts)/param(inst_params.vectors.time),'%6.1f') blanks(10-length(num2str(param(inst_params.vectors.array_counts)/param(inst_params.vectors.time),'%6.1f')))]; %Det Rate
                %Now add aditional user params
                if extra > 0
                    len = length(extra);
                    for m = 1:len
                        disp_string = [disp_string num2str(param(extra(m)),'%6.1f') blanks(8-length(num2str(param(extra(m)),'%6.1f')))];
                    end
                end
                
            else %in case of failure to load file
                disp_string = [num2str(numor) '  :  Error Finding or Loading File'];
            end
            
            disp(disp_string); %Write to Screen
            if write_file_flag == 1; fprintf(fid,'%s',[disp_string char(13) char(10)]); end%Write to file
        end
        %Close File
        if write_file_flag == 1; fclose(fid); end
end

