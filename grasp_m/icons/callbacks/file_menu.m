function button = file_menu(to_do,options)

global grasp_env
global grasp_handles
global displayimage
global inst_params
global status_flags
global last_saved
global grasp_data

%attachment_name = []; %This is the sup_figure attachment file name loaded with the main project
button = [];

switch to_do
    %***** File>Open Menu *****
    case 'open'
        
        [fname, directory] = uigetfile([grasp_env.path.project_dir '*.mat'],'Open File');
        
        if fname ~=0
            %button = file_menu('close');  %Flag returns whether the close previous project was canceled.
            if not(strcmp(button,'Cancel')) %i.e. it wasn't cancelled during the previous close project
                
                grasp_version = grasp_env.grasp_version;
                grasp_version_date = grasp_env.grasp_version_date;
                grasp_name = grasp_env.grasp_name;
                grasp_screen = grasp_env.screen;
                
                %Open saved Grasp project
                load([directory fname]);
                
                %Replace some of the project parameters with those relevant to the current system
                grasp_env.project_title = fname;
                grasp_env.path.project_dir = directory;
                grasp_env.grasp_version = grasp_version;
                grasp_env.grasp_version_date = grasp_version_date;
                grasp_env.grasp_name = grasp_name;
                grasp_env.screen = grasp_screen;
                
                %Check for any new missing parameters due to Grasp update
                if not(isfield(status_flags.calibration,'det_eff_nmbr')); status_flags.calibration.det_eff_nmbr = 1; end
                if not(isfield(status_flags,'resolution_control')); %Added in V6.30
                    %Resolution Control
                    status_flags.resolution_control.wavelength_check = 1;
                    status_flags.resolution_control.divergence_check = 1;
                    status_flags.resolution_control.divergence_type = 1; %1 = Geometric, 2 = Measured Beam Shape
                    status_flags.resolution_control.aperture_check = 1;
                    status_flags.resolution_control.aperture_size = [10e-3]; %m (10mm) Single figure denotes circular
                    status_flags.resolution_control.pixelation_check = 1;
                    status_flags.resolution_control.binning_check = 1;
                    status_flags.resolution_control.show_kernels_check = 0;
                    status_flags.resolution_control.convolution_type = 1;
                    status_flags.resolution_control.fwhmwidth = 1; %extent to which convolution kernel goes out.
                    status_flags.resolution_control.finesse = 31;  %finesse (number of points) over the concolution kernel - should be ODD number
                end
                if not(isfield(status_flags.resolution_control,'wavelength_type')); status_flags.resolution_control.wavelength_type = 1; end
                if not(isfield(status_flags.analysis_modules.radial_average,'direct_to_file')); status_flags.analysis_modules.radial_average.direct_to_file = 0; end
                if not(isfield(status_flags.fitter,'delete_curves_check')); status_flags.fitter.delete_curves_check = 0; end

                %Rebin (complex) parameters
                if not(isfield(status_flags.analysis_modules,'rebin'));
                    status_flags.analysis_modules.rebin.bin_spacing = 'linear';
                    status_flags.analysis_modules.rebin.n_bins = 500;
                    status_flags.analysis_modules.rebin.regroup_bands = [0,1];
                    status_flags.analysis_modules.rebin.dii_power = 2;
                    status_flags.analysis_modules.rebin.dqq_power = 2;
                end
                
                %D33 tof combine
                if not(isfield(status_flags.analysis_modules.radial_average,'d33_tof_combine'))
                    status_flags.analysis_modules.radial_average.d33_tof_combine = 0;
                end
                
                %Depth frame start & end
                if not(isfield(status_flags.analysis_modules.radial_average,'depth_frame_start'))
                    status_flags.analysis_modules.radial_average.depth_frame_start = 1;
                    status_flags.analysis_modules.radial_average.depth_frame_start = 1;
                end
                
                temp = findstr(grasp_env.project_title,'.mat'); %Check to stop '.mat's' propogating though project_title
                if not(isempty(temp)); grasp_env.project_title = grasp_env.project_title(1:temp-1); end
                
                %Active axis on/off
                if not(isfield(status_flags.display,'axis1_onoff'));
                    status_flags.display.axis1_onoff = 1;
                    status_flags.display.axis2_onoff = 1;
                    status_flags.display.axis3_onoff = 1;
                    status_flags.display.axis4_onoff = 1;
                    status_flags.display.axis5_onoff = 1;
                    status_flags.display.axis6_onoff = 1;
                    status_flags.display.axis7_onoff = 1;
                    status_flags.display.axis8_onoff = 1;
                    status_flags.display.axis9_onoff = 1;
                    status_flags.display.axis10_onoff = 1;
                end
                
                %PA Corrections
                if not(isfield(status_flags,'figure.pa_chk'))
                    status_flags.calibration.pa_chk = 0;
                end
                
                %Detector position soft-calibration
                if not(isfield(status_flags,'soft_det_cal'))
                    status_flags.calibration.soft_det_cal = 0;
                end
                
                %Raw tube data load
                if not(isfield(status_flags.fname_extension,'raw_tube_data_load'))
                    status_flags.fname_extension.raw_tube_data_load = 0;
                end
                
                
                %Rebuild background & cadmium selector
                selector_build
                selector_build_values; %all
                initialise_2d_plots
                update_last_saved_project
                grasp_update
                
                
                %rescale to the saved axes limits
                %file_xlims = status_flags.axes.xlim;
                %file_ylims = status_flags.axes.ylim;
                %set(grasp_handles.displayimage.axis,'xlim',file_xlims);
                %set(grasp_handles.displayimage.axis,'ylim',file_ylims);
                
                %Now load any attachment figures that should be there also
                if not(isempty(attachment_figures));
                    for n = 1:length(attachment_figures);
                        %[project_dir attachment_name{n} '.fig']
                        test_exist = dir([directory attachment_figures{n} '.fig']);
                        if not(isempty(test_exist));
                            disp('Opening Project Attachment Figures');
                            warning off
                            uiopen([directory attachment_figures{n} '.fig'],1);
                            %Correct the handles stored in the saved figure
                            grasp_plot_handles = get(gcf,'userdata');
                            grasp_plot_handles.figure = gcf;
                            set(gcf,'userdata',grasp_plot_handles);
                            warning on
                            %                             %If 2D fit window, then update fitted conturs
                            %                             temp = findstr(attachment_2df{n},'_2Df');
                            %                             if not(isempty(temp)); fit2d_callbacks('update_fit_contours'); end
                        else
                            disp('Project Attachment Figures appear to be missing');
                        end
                    end
                end
            end
        end
        
    case 'close'
        
        %****** Check if to save data ********************
        %Compare each element in 'last_saved' to see if anything has changed
        current_project = struct(....
            'grasp_env',grasp_env,....
            'inst_params',inst_params,....
            'status_flags',status_flags,....
            'grasp_data',grasp_data);
        %Check if to save current project
        if ~isequal(current_project,last_saved)
            button = questdlg('Save Changes?','Close Project:','Cancel');
            if strcmp(button,'Yes')
                file_menu('save'); %Save project
            elseif strcmp(button,'Cancel');
                return
            end
        end
        
        %Close Window Modules
        file_menu('close_window_modules');

        %Close Grasp Changer Window
        if ishandle(grasp_handles.grasp_changer.window);
            close(grasp_handles.grasp_changer.window);
            grasp_handles.grasp_changer.window = [];
        end
        
        %Close any output figures
        %i = findobj('tag','grasp_plot');
        %if ishandle(i)
        %    close(i);
        %end
        
        
        %Reinitialise all program workspaces & variables
        %initialise_environment_params
        grasp_env.project_title = 'UNTITLED';
        
        initialise_status_flags('reset_essential');
        %initialise_environment_params
        %grasp_ini
        initialise_instrument_params;
        %initialise_grasp_handles
        initialise_data_arrays;
        selector_build;
        selector_build_values('all');
        grasp_update;
        update_last_saved_project;
        tool_callbacks('rescale');
        
    case 'save'
        if strcmp(grasp_env.project_title,'UNTITLED')
            file_menu('save_as');
        else
            raw_save(grasp_env.path.project_dir, grasp_env.project_title);
        end
        
    case 'save_as'
        if strcmp(grasp_env.project_title,'UNTITLED')
            fname = [num2str(displayimage.params1(128))]; %Suggest a file name based on numor range
        else
            fname = grasp_env.project_title;
        end
        start_string = [grasp_env.path.project_dir fname '.mat'];
        [fname, directory] = uiputfile(start_string,'Save Project');
        if fname == 0
        else
            grasp_env.project_title = fname; grasp_env.path.project_dir = directory;
            raw_save(grasp_env.path.project_dir, grasp_env.project_title);
            temp = findstr(grasp_env.project_title,'.mat'); %Check to stop '.mat's' propogating though project_title
            if not(isempty(temp)); grasp_env.project_title = grasp_env.project_title(1:temp-1); end
            grasp_update;
        end
        
    case 'set_project_dir'
        pathname = uigetdir(grasp_env.path.project_dir,'Please select your Project directory');
        if pathname ~= 0;
            grasp_env.path.project_dir = [pathname filesep];
        end
        
        
        
    case 'set_data_dir'
        pathname = uigetdir(grasp_env.path.data_dir,'Please select your SANS data directory');
        if pathname ~= 0;
            grasp_env.path.data_dir = [pathname filesep];
        end
        
    case 'set_filedata_dir'
        
        if isunix; temp = fullfile(grasp_env.path.data_dir,'*.*');
        else temp = fullfile(grasp_env.path.data_dir,'*.*'); end
        
        [fname, pathname] = uigetfile(temp,'Please select a SANS data file to set directory and to set any filename extensions');
        if fname ~= 0;
            grasp_env.path.data_dir = pathname;
            
            %See if there is an extension, e.g. for HMI, SINQ & NIST
            [fname,extension] = strtok(fname,'.');
            status_flags.fname_extension.extension = deblank(extension);
            set(grasp_handles.figure.data_ext,'string',status_flags.fname_extension.extension);
            
            %Strip the ShortName part from the total filename, e.g. for HMI, SINQ, NIST, Strip the e.g. xxx1234.dat
            i = find(double(fname)<48 | double(fname)>57); %Find the NON numeric ASCII codes (and numbers between non numeric codes).
            if not(isempty(i));
                status_flags.fname_extension.shortname = deblank(fname(1:max(i)));
                fname = fname((max(i)+1):length(fname)); %Keep the left over fname but.
            else
                status_flags.fname_extension.shortname = [];
            end
            set(grasp_handles.figure.data_lead,'string',status_flags.fname_extension.shortname);
            
%             %For FRM2_Mira Strip the ShortName part from the total filename
%             if strcmp(grasp_env.inst,'FRM2_Mira')
%                 temp = findstr(fname,'_');
%                 status_flags.fname_extension.shortname = deblank(fname(1:temp(length(temp))));
%                 fname = fname((temp(length(temp))+1):length(fname));
%                 set(grasp_handles.figure.data_lead,'string',status_flags.fname_extension.shortname);
%             end
            
%             %For Julich, find the numeric part between the first two '_'
%             if strcmp(grasp_env.inst,'Julich_KWS2')
%                 i = findstr(fname,'_');
%                 fname = fname(i(1)+1:i(2)-1);
%             end
            
%             %For ORNL find the last numeric part after 'scan'
%             if strcmp(grasp_env.inst,'ORNL_CG2');
%                 i = findstr(fname,'_');
%                 status_flags.fname_extension.shortname = fname(1:max(i));
%                 set(grasp_handles.figure.data_lead,'string',status_flags.fname_extension.shortname);
%                 fname = fname(max(i)+1:length(fname));
%             end
            
            i = find(double(fname)>47 & double(fname)<58); %Find the numeric ASCII codes.
            fname = fname(i);
            set(grasp_handles.figure.data_load,'string',fname);
        end
        
        
        
    case 'save_mask'
        %Retrieve current mask
        for det = 1:inst_params.detectors
            mask = displayimage.(['mask' num2str(det)]);
            mask = flipud(mask); %Flip mask first to write in the same order as Rons
            
            %Convert logical mask back to Ron type mask
            %Convert to logical mask (1's and 0's)
            i = find(mask==1); mask(i) = 46;
            i = find(mask==0); mask(i) = 35;
            
            [fname, directory] = uiputfile([grasp_env.path.project_dir 'mask.msk'],'Save Mask');
            if fname ~= 0
                working_data_dir = directory;
                if isempty(findstr('.',fname)); fname = [fname '.msk']; end %Make sure extension '.msk' is included
                
                fid=fopen([directory fname],'w'); %Open File
                disp(['Exporting Mask to: ' directory fname]);
                
                %Two lines of header
                time = fix(clock);
                textstring = [fname ' Created by ' grasp_env.grasp_name ' V' grasp_env.grasp_version ' ' date ' ' num2str(time(4)) ':' num2str(time(5)) ':' num2str(time(6))];
                fprintf(fid,'%s \n',textstring);
                
                textstring = ['   ' num2str(inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1))];
                fprintf(fid,'%s \n',textstring);
                %Mask data
                for n = 1:inst_params.(['detector' num2str(det)]).pixels(2)
                    line = mask(n,:);
                    textstring = char(line);
                    fprintf(fid,'%s \n',textstring);
                end
                %Footer
                textstring = ' DETECTOR VIEWED FROM SAMPLE ';
                fprintf(fid,'%s \n',textstring);
                
                %Close File
                fclose(fid);
            end
        end
        
%     case 'export_displayimage'
%         
%         [fname, directory] = uiputfile([grasp_env.path.project_dir '000000'],'Export Display Image');
%         
%         if fname ~=0
%             grasp_env.path.project_dir = directory;
%             numor = str2num(fname);
%             
%             l = size(displayimage.parsub);
%             parsub = rot90([displayimage.parsub blanks(80-l(2))],2);
%             if isempty(numor); numor = 0; end
%             ill_sans_data_write(displayimage.data,displayimage.params,parsub,numor,directory);
%             ill_sans_data_write(displayimage.error,displayimage.params,parsub,numor,directory,1); %the flag '1' signifies to use the '.err' extension for error data
%         end
        
    case 'export_binary'
        
        [fname, directory] = uiputfile([grasp_env.path.project_dir '000000'],'Export Display Image');
        
        if fname ~=0
            grasp_env.path.project_dir = directory;
            fname = [directory fname];
            fid = fopen([fname '.dat'],'wb');
            fwrite(fid,displayimage.data1,'real*4');
            fclose(fid)
            fid = fopen([fname '.err'],'wb');
            fwrite(fid,displayimage.error1,'real*4');
            fclose(fid);
        end
        
    case 'export_efficiency_map'
        
        index = data_index(99); %Index to the det efficiency worksheet
        
        for det = 1:inst_params.detectors
            
            eff_data = grasp_data(index).(['data' num2str(det)]){1};
            eff_err_data = grasp_data(index).(['error' num2str(det)]){1};
            
            if isfield(grasp_env.path,'grasp_root')
                path_name = grasp_env.path.grasp_root;
            else
                path_name = 'c:\'
            end
            uisave({'eff_data', 'eff_err_data'} ,[path_name 'detector_efficiency_det' num2str(det) '_' grasp_env.inst grasp_env.inst_option]);
        end

        
    case 'export_depth_frames'
        
        first_file_str = '000001';
        first_file_numor = [];
        while isempty(first_file_numor)
            disp('Please enter a numeric Start File Numor and Directoy');
            [first_file_str, directory] = uiputfile([grasp_env.path.project_dir first_file_str],'Export Depth Frames (Raw Data)');
            first_file_numor = str2num(first_file_str);
        end
       
        index = data_index(status_flags.selector.fw);
        number = status_flags.selector.fn;
        depth = grasp_data(index).dpth{number};
        
        depth_data = grasp_data(index).data1{number};
        depth_params = grasp_data(index).params1{number};
        depth_parsub = grasp_data(index).subtitle{number};
        
        for n = 1:depth
            numor = first_file_numor + n -1;
            disp(['Exporting Depth Frame ' num2str(n) ' as Raw Data to file: ' num2str(numor)]);
            ill_sans_data_write(depth_data(:,:,n),depth_params(:,n),depth_parsub{n},numor,directory);
        end
        
        
    case 'import_efficiency_map'
        eff_fname = ['detector_efficiency_' grasp_env.inst grasp_env.inst_option '.mat'];
        [fname, pathname] = uigetfile(eff_fname,'Import Detector Efficiency File');
        
        eff_data = load([pathname fname]);
        
        index = data_index(99); %Index to the det efficiency worksheet
        data(index).data{1}(:,:,1) = eff_data.eff_data;
        data(index).error{1}(:,:,1) = eff_data.eff_err_data;
        
        
    case 'import_mask'
        [fname, directory] = uigetfile([grasp_env.path.project_dir '*.msk'],'Browse File & Directory');
        if fname ~= 0
            grasp_env.path.project_dir = directory;
            
            %Read Mask File
            mask = get_mask([directory fname]); %This returns a logical mask made from an imported Ron mask
            
            %Check what to do if multiple detectors
            if inst_params.detectors >1; 
                beep
                disp('HELP:  What to do for multiple detectors in file_menu ~ line312');
                return
            end
            det = 1;
            
            %Put the mask into the right mask worksheet
            mask_number = status_flags.display.mask.number;
            index = data_index(7);
            
            %Replace the mask data
            grasp_data(index).(['data' num2str(det)]){mask_number}(:,:) = mask;
            grasp_update
        end
        
    case 'exit'
        button = file_menu('close');
        if not(strcmp(button,'Cancel'))
            
            %Close Main Window
            set(grasp_handles.figure.grasp_main,'CloseRequestFcn','closereq');
            close(grasp_handles.figure.grasp_main);
            
            %Close window Modules
            file_menu('close_window_modules');
            %Close All Sub Figures
            i = findobj('tag','plot_result');
            close(i);
        end
        
        
        
        
    case 'close_window_modules'
        
        %Close Window Modules
        window_module_names = fieldnames(grasp_handles.window_modules);
        n= length(window_module_names);
        for n = 1:n
            window_module_sub_names = getfield(grasp_handles.window_modules,window_module_names{n});
            if isfield(window_module_sub_names,'window');
                if ishandle(window_module_sub_names.window)
                    close(window_module_sub_names.window);
                end
            end
        end
        
    case 'show_resolution'
        if strcmp(status_flags.subfigure.show_resolution,'on');
            status_flags.subfigure.show_resolution = 'off';
        else
            status_flags.subfigure.show_resolution = 'on';
        end
        set(gcbo,'checked',status_flags.subfigure.show_resolution);
        
    case 'uisetfont'
        fontstruct = uisetfont('Set GRASP Font & Size');
        if isstruct(fontstruct)
            i = findobj('fontsize',grasp_env.fontsize);
            grasp_env.fontsize = fontstruct.FontSize;
            set(i,'fontsize',grasp_env.fontsize);
            %Set New Font
            i = findobj('fontname',grasp_env.font);
            grasp_env.font = fontstruct.FontName;
            set(i,'fontname',grasp_env.font);
        end
        
    case 'line_style'
        if strcmp(options,'none'); status_flags.display.linestyle = '';
        elseif strcmp(options,'solid'); status_flags.display.linestyle = '-';
        elseif strcmp(options,'dotted'); status_flags.display.linestyle = ':';
        elseif strcmp(options,'dashdot'); status_flags.display.linestyle = '-.';
        else strcmp(options,'dashed'); status_flags.display.linestyle = '--';
        end
        update_menus
        
        
    case 'linewidth'
        status_flags.display.linewidth = get(gcbo,'userdata');
        update_menus
        
    case 'markersize'
        status_flags.display.markersize = get(gcbo,'userdata');
        update_menus
        
    case 'invert_hardcopy'
        status_flags.display.invert_hardcopy = not(status_flags.display.invert_hardcopy);
        update_menus
        
    case 'save_sub_figures'
        status_flags.file.save_sub_figures = not(status_flags.file.save_sub_figures);
        update_menus
        
end


