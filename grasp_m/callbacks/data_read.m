function data_read


global grasp_handles
global inst_params
global grasp_env
global status_flags
global grasp_data

text_handle = [];

%Retrieve the <Numors> string
numors_str_in = get(grasp_handles.figure.data_load,'string');

disp('  '); %Blank text to space out text display
disp(['***** Loading data:  ' numors_str_in ' *****']);
disp('  ');

%Special cases: eg. clear etc.
if strcmp(numors_str_in,'<Numors>'); return %i.e do nothing
elseif strcmp(numors_str_in,'0');
    clear_wks_nmbr(status_flags.selector.fw,status_flags.selector.fn);
    disp('  ');
    return %clear worksheet and depth
elseif isempty(numors_str_in); return %i.e do nothing
end

index = data_index(1);

%KEEP THE CURRENT BEAM CENTRE if loading into foreground worksheet
for det=1:inst_params.detectors
    beam_centres.(['cm' num2str(det)]) = grasp_data(index).(['cm' num2str(det)]);
end
%Keep current thickness
thickness = grasp_data(index).thickness{status_flags.selector.fn}; %KEEP THE CURRENT THICKNESSES if loading into foreground worksheet

%Clear worksheet and depth
clear_wks_nmbr(status_flags.selector.fw,status_flags.selector.fn);
status_flags.selector.fd = 1;

%Put old beam centre back into cleared worksheet
if status_flags.selector.fw == 1; %foreground worksheet
    index = data_index(1); %Beam centres and thicknesses are stored with the sample scattering worksheet
    for det = 1:inst_params.detectors
        grasp_data(index).(['cm' num2str(det)]) = beam_centres.(['cm' num2str(det)]);
    end
    grasp_data(index).thickness{status_flags.selector.fn} = thickness;
end


%***** Parse the Numors String for all the avaialible data load options *****
[numor_list, depth_list] = numor_parse(numors_str_in);


%***** Go though the numor list and load the data *****

%Replace the Numors Get It Button with a STOP button
set(grasp_handles.figure.getit,'value',0);
set(grasp_handles.figure.getit,'string','STOP!','foregroundcolor',[0.8 0 0],'callback','set(gcbo,''userdata'',1);');
pause(0.1)

for n = 1:length(numor_list);
    numor = numor_list(n);
    depth = depth_list(n);
    
    index = data_index(status_flags.selector.fw);
    text_handle = grasp_message(['Numor: ' num2str(numor) ' => ' grasp_data(index).name ':' num2str(status_flags.selector.fn) ':' num2str(depth)],1,'main');

    %Prepare the full file name string
    numors_str = [status_flags.fname_extension.shortname num2str(numor,['%.' num2str(inst_params.filename.numeric_length) 'i']) status_flags.fname_extension.extension];
    
    %Full path to file
    file_name_path = fullfile(grasp_env.path.data_dir,numors_str);
    disp(['Loading file:  ' file_name_path]);
    
    %Check for file decompression (using gzip)
    file_name_path = numor_decompress(file_name_path);
    
    %Check for empty file_name_path
    if isempty(file_name_path);
        break
    end
    %Read the file
    fn_string = [inst_params.filename.data_loader '(file_name_path,numor)'];

   
    numor_data = eval(fn_string);
    numor_data.load_string = numors_str_in;
    
    
    
%***** Soft Detector Position Correction - Tube detectors like D22 & d33 *****
if status_flags.calibration.soft_det_cal ~= 0
    if strcmp(grasp_env.inst_option,'D33_Instrument_Comissioning') || strcmp(grasp_env.inst_option,'D33')
        disp('Detector calibration in data_read.m');
        numor_data = d33_rawdata_calibration(numor_data);
    end
end

    if isfield(numor_data,'file_type');
        if strcmp(numor_data.file_type,'single frame');
            
            %Make depth-time parameter for Lionel
            if isfield(numor_data.info,'start_time');
                try
                    if depth ==1;
                        start_time = numor_data.info.start_time;
                        start_date = datenum(numor_data.info.start_date);
                        start_time_seconds = start_date*24*60*60 +  str2num(start_time(1:2))*3600 + str2num(start_time(4:5))*60 + str2num(start_time(7:8));
                    end
                    current_time = numor_data.info.start_time;
                    current_date = datenum(numor_data.info.start_date);
                    current_time_seconds = current_date*24*60*60 + str2num(current_time(1:2))*3600 + str2num(current_time(4:5))*60 + str2num(current_time(7:8));
                    elapsed_time = current_time_seconds - start_time_seconds;
                    numor_data.params1(126) = elapsed_time;
                catch
                end
            end
            
        elseif strcmp(numor_data.file_type,'tof');
           % disp('tof time here in data_read.m 111')
            
            
        elseif strcmp(numor_data.file_type,'kinetic');
           % disp('kin time here in data_read.m 115')
        end
        
    else
        
        %Make depth-time parameter for Lionel
        if isfield(numor_data.info,'start_time');
            try
                if depth ==1;
                    start_time = numor_data.info.start_time;
                    start_date = datenum(numor_data.info.start_date);
                    start_time_seconds = start_date*24*60*60 +  str2num(start_time(1:2))*3600 + str2num(start_time(4:5))*60 + str2num(start_time(7:8));
                end
                current_time = numor_data.info.start_time;
                current_date = datenum(numor_data.info.start_date);
                current_time_seconds = current_date*24*60*60 + str2num(current_time(1:2))*3600 + str2num(current_time(4:5))*60 + str2num(current_time(7:8));
                elapsed_time = current_time_seconds - start_time_seconds;
                numor_data.params1(126) = elapsed_time;
            catch
            end
        end
    end
    
            
            
    
    if not(isfield(numor_data,'n_frames')); numor_data.n_frames = 1; end
        
    %APPEND DATA into storage array - i.e., ADD new loaded contents to previous contents
    
%     %***** Data Parameter Patcher *****
%     if status_flags.data.patch_check ==1; %Patch some parameters
%         for det = 1:inst_params.detectors
%             for n = 1: status_flags.data.number_patches
%                 if not(isempty(status_flags.data.(['patch_parameter' num2str(n)]))) && not(isempty(status_flags.data.(['patch' num2str(n)])))
%                     numor_data.(['params' num2str(det)])(status_flags.data.(['patch_parameter' num2str(n)]),:) = status_flags.data.(['patch' num2str(n)]);
%                 end
%             end
%         end
%     end
    
    
    %Data Type - Temporary catch for the file readers that do not spit out a 'file_type' field
    if not(isfield(numor_data,'file_type'))
        numor_data.file_type = 'single frame';
    end
    
    %Place data
    place_data(numor_data, status_flags.selector.fw, status_flags.selector.fn, depth);
    
    if ishandle(text_handle); delete(text_handle); end

end

disp('******** END DATA LOADING ********'); %Blank text to space out text display
disp('  ');



%Replace the Numors Get It Button back to normal
if ishandle(text_handle); delete(text_handle); end
old_getit_callback = ['main_callbacks(''data_read'')'];
set(grasp_handles.figure.getit,'String','Get It!','CallBack',old_getit_callback,'busyaction','cancel','userdata',0,'foregroundcolor',[0 0 0]);
%***** Delete the Loading Message *****





