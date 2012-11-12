function sans_instrument_model_callbacks(todo)

global d33_handles
global inst_config
global inst_model_params
global sample_config
global background_config
global cadmium_config
global inst_component
global grasp_env

%some constants
g = -9.8;
h = 6.626076*(10^-34); %Plank's Constant
m_n = 1.674929*(10^-27); %Neutron Rest Mass



if nargin <1; todo = ['']; end

%***** Callback functions ******
switch todo
    
    case 'change_subtitle'
        inst_model_params.subtitle = get(gcbo,'string');
        
    
    case 'export_2d_data'
        disp('Exporting D33, D22 or D11 data')
        %Find numor from lastnumor file
        fid = fopen([grasp_env.path.project_dir filesep 'lastnumor.txt']);
        if fid == -1; %No 'lastnumber' file exists - create a new one.
            fid = fopen([grasp_env.path.project_dir filesep 'lastnumor.txt'],'w+')
            fprintf(fid,'%s \n','0');
            fclose(fid); %close
            fid = fopen([grasp_env.path.project_dir filesep 'lastnumor.txt']); % and reopen
        end
        text = fgetl(fid);
        lastnumor = str2num(text);
        %Pad numor out with correct number of zeros
        numor = lastnumor+1;
        fclose(fid);
        fid = fopen([grasp_env.path.project_dir filesep 'lastnumor.txt'],'w+');
        fprintf(fid,'%s \n',num2str(numor));
        fclose(fid);

        set(d33_handles.numor,'visible','on','string',num2str(numor));
       
        if strcmp(inst_config.inst,'ILL_d22') || strcmp(inst_config.inst,'ILL_d11')
            
            for n = 1:length(inst_component);
                if findstr(inst_component(n).name,'Detector') %Find detector component
                    for m = 1:inst_component(n).pannels %Loop though detector pannels
                        pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                        if isfield(pannel_struct,'detector_data'); %check that there is some data to export
                            params = zeros(128,1);
                            params(53) = inst_config.mono_wav; %wav
                            params(54) = inst_config.mono_dwav/100; %delta_wav
                            params(19) = inst_component(n).position; %det
                            params(26) = inst_component(n).position; %det_calc
                            params(58) = inst_config.col; %col
                            params(3) = inst_model_params.measurement_time *10; %time 10ths seconds 10 = 1second
                            params(5) = inst_model_params.monitor(1); %Beam monitor
                            params(55) = pannel_struct.parameters.pixel_size(1)*1e3; params(56) = pannel_struct.parameters.pixel_size(2)*1e3;
                            parsub = inst_model_params.subtitle;
                            
                            %Model Parameters
                            if isfield(sample_config.model(sample_config.model_number),'san')
                                if not(isempty(sample_config.model(sample_config.model_number).san));
                                    params(65) = sample_config.model(sample_config.model_number).san;
                                end
                            end
                            if isfield(sample_config.model(sample_config.model_number),'phi')
                                if not(isempty(sample_config.model(sample_config.model_number).phi))
                                    params(102) = sample_config.model(sample_config.model_number).phi;
                                end
                            end

                            %Detector data
                            detector_mask = pannel_struct.parameters.beam_stop_mask .* pannel_struct.parameters.shaddow_mask;
                            if (strcmp(inst_model_params.det_image,'Detector_Image'))
                                export_data = pannel_struct.detector_data(:,:,inst_model_params.det_image_tof_frame).*detector_mask;
                                temp = find(isnan(detector_mask));
                                export_data(temp) = 0;
                            elseif strcmp(inst_model_params.det_image,'Direct_Beam');
                                export_data(:,:) = pannel_struct.detector_beam(:,:);
                            end
                            detector_data = export_data;
                            
                            directory = [grasp_env.path.project_dir filesep];
                            d33_ill_sans_data_write(detector_data,params,parsub,numor,directory,flag);
                        else
                        end
                    end
                end
            end
            
            
        elseif strcmp(inst_config.inst,'ILL_d33')
            disp('Exporting D33 data')
            det = 0; data = [];
            
            %Could be Mono (single wavelength, single frame) or TOF (many wavelength bins, many detector frames)
            data.n_frames = length(inst_config.tof_wavs);
            
            %Prepare detector data and paramters for export
            for n = 1:length(inst_component);
                if findstr(inst_component(n).name,'Detector') %Find detector component
                    for m = 1:inst_component(n).pannels %Loop though detector pannels
                        pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                        det = det +1;
                        
                        %Parameters
                        data.(['params' num2str(det)]) = zeros(128,data.n_frames);
                        
                        %Put the correct wavelength
                        for p = 1:data.n_frames;
                            data.(['params' num2str(det)])(53,p) = inst_config.tof_wavs(p); %wav
                        end
                        %Put the correct resolution for each detector
                        if strcmp(inst_config.mono_tof,'TOF');
                            if strcmpi(pannel_struct.name,'Rear')
                                res = inst_config.chopper_resolution /100;
                            else
                                res = inst_config.chopper_resolution_front /100;
                            end
                        else
                            res = inst_config.mono_dwav/100; %delta_wav (fraction, e.g. 0.1 = 10%)
                        end
                        data.(['params' num2str(det)])(54,:) = res; %delta_wav (fraction, e.g. 0.1 = 10%)

                        data.(['params' num2str(det)])(19,:) = inst_component(n).position; %det
                        data.(['params' num2str(det)])(18,:) = inst_component(n).position + pannel_struct.relative_position; %real pannel Det
                        
                        %Pannel opening parameters, ox(21), oy(22) (mm)
                        data.(['params' num2str(det)])(21,:) = pannel_struct.parameters.opening(1)*1000; %ox - pannel opening (horz)
                        data.(['params' num2str(det)])(22,:) = pannel_struct.parameters.opening(2)*1000 ; %oy - pannel opening (vertical)
                        
                        
                        data.(['params' num2str(det)])(26,:) = inst_component(n).position; %det_calc
                        data.(['params' num2str(det)])(58,:) = inst_config.col; %col
                        data.(['params' num2str(det)])(3,:) = inst_model_params.measurement_time; %time seconds

                        data.(['params' num2str(det)])(5,:) = inst_model_params.monitor; %beam monitor
                        data.(['params' num2str(det)])(55,:) = pannel_struct.parameters.pixel_size(1)*1e3;
                        data.(['params' num2str(det)])(56,:) = pannel_struct.parameters.pixel_size(2)*1e3;
                        
                        %Model Parameters
                        if isfield(sample_config.model(sample_config.model_number),'san')
                            if not(isempty(sample_config.model(sample_config.model_number).san))
                                data.(['params' num2str(det)])(65,:) = sample_config.model(sample_config.model_number).san;
                            else
                                data.(['params' num2str(det)])(65,:) = 0;
                            end
                        end
                        if isfield(sample_config.model(sample_config.model_number),'phi')
                            if not(isempty(sample_config.model(sample_config.model_number).phi))
                                data.(['params' num2str(det)])(102,:) = sample_config.model(sample_config.model_number).phi;
                            else
                                data.(['params' num2str(det)])(102,:) = 0;
                            end
                        end
                        
                        
                        %Detector data
                        pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                        detector_mask = pannel_struct.parameters.beam_stop_mask .* pannel_struct.parameters.shaddow_mask;
                        export_data = [];
                        if (strcmp(inst_model_params.det_image,'Detector_Image'))
                            for depth = 1:size(pannel_struct.detector_data,3)
                                export_data(:,:,depth) = pannel_struct.detector_data(:,:,depth).*detector_mask;
                            end
                            temp = find(isnan(export_data));
                            export_data(temp) = 0;
                            %Direct Beam Data
                        elseif strcmp(inst_model_params.det_image,'Direct_Beam');
                            for depth = 1:size(pannel_struct.detector_data,3)
                                export_data(:,:,depth) = pannel_struct.detector_beam(:,:,depth);
                            end
                            temp = find(isnan(export_data));
                            export_data(temp) = 0;
                        end
                        data.(['data' num2str(det)]) = export_data;
                    end
                    
                end
            end
            
            %Some additional parameters
            data.subtitle = inst_model_params.subtitle;
            data.numor = numor;
            data.start_date_time = datestr(now);
            data.end_date_time = datestr(now);
            numor_str = num2str(numor,'%.6i');
            
            file_numor_path = [grasp_env.path.project_dir filesep numor_str];
            
            %Write D33 data structure to file
            d33_model_data_write(file_numor_path,data);
        end
        %Remove run number
        pause(1)
        set(d33_handles.numor,'visible','off');
        
        
    case 'smearing_itterations'
        pos = get(gcbo,'value');
        userdata = get(gcbo,'userdata');
        inst_model_params.smearing = str2num(userdata{pos});
        
    case 'poissonian_noise_check'
        inst_model_params.poissonian_noise_check = get(gcbo,'value');
        
        
    case 'measurement_time'
        time_str = get(gcbo,'string');
        time = str2num(time_str);
        if not(isempty(time));
            inst_model_params.measurement_time = time;
        end
        set(d33_handles.measurement_time_edit,'string',num2str(inst_model_params.measurement_time));
        
    case 'sample_thickness'
        thickness_str = get(gcbo,'string');
        thickness = str2num(thickness_str);
        if not(isempty(thickness));
            inst_model_params.sample_thickness = thickness;
        end
        set(d33_handles.sample_thickness_edit,'string',num2str(inst_model_params.sample_thickness));
        
    case 'sample_area'
        area_str = get(gcbo,'string');
        area = str2num(area_str);
        if not(isempty(area));
            inst_model_params.sample_area = area;
        end
        set(d33_handles.sample_area_edit,'string',num2str(inst_model_params.sample_area));
    
    case 'auto_calculate_button'
        if inst_model_params.auto_calculate ==1;
            inst_model_params.auto_calculate =0;
        else
            inst_model_params.auto_calculate =1;
        end
        
    case 'col_length_popup'
        cols = get(gcbo,'string');
        value = get(gcbo,'value');
        inst_config.col = str2num(cols{value});
        
    case 'selector_wavelength'
        wav_str = get(gcbo,'string');
        temp = str2num(wav_str);
        if not(isempty(temp));
            inst_config.mono_wav = temp(1);
        end
        
    case 'selector_wavelength_res'
        wav_str = get(gcbo,'string');
        temp = str2num(wav_str);
        if not(isempty(temp));
            inst_config.mono_dwav = temp(1);
        end
        
    case 'det_slider'
        slider = get(gcbo,'value');
        component_number =  get(gcbo,'userdata');
        span = inst_component(component_number).parameters.position_max - inst_component(component_number).parameters.position_min;
        new_position = slider* span + inst_component(component_number).parameters.position_min;
        
        %find all other detectors & check for collision
        for n = 1:length(inst_component);
            if findstr(inst_component(n).name,'Detector')
                if n ~= component_number;
                    if inst_component(component_number).position > inst_component(n).position
                        if (new_position - inst_component(n).position)  < inst_component(component_number).parameters.min_approach;
                            new_position = inst_component(n).position +  inst_component(component_number).parameters.min_approach;
                        end
                    else
                        if inst_component(n).position- new_position < inst_component(component_number).parameters.min_approach;
                            new_position = inst_component(n).position - inst_component(component_number).parameters.min_approach;
                        end
                    end
                end
            end
        end
        inst_component(component_number).position = new_position;
        
    case 'det_edit'
        new_position = str2num(get(gcbo,'string'));
        component_number =  get(gcbo,'userdata');
        if not(isempty(new_position));
            %find all other detectors & check for collision
            for n = 1:length(inst_component);
                if findstr(inst_component(n).name,'Detector')
                    if n ~= component_number;
                        if inst_component(component_number).position > inst_component(n).position
                            if (new_position - inst_component(n).position)  < inst_component(component_number).parameters.min_approach;
                                new_position = inst_component(n).position +  inst_component(component_number).parameters.min_approach;
                            end
                        else
                            if inst_component(n).position- new_position < inst_component(component_number).parameters.min_approach;
                                new_position = inst_component(n).position - inst_component(component_number).parameters.min_approach;
                            end
                        end
                    end
                end
            end
            inst_component(component_number).position = new_position;
        end
        
    case 'app_popup'
        component = get(gcbo,'userdata');
        value = get(gcbo,'value');
        inst_component(component).value = value;
        
        
    case 'det_offset_edit'
        temp = get(gcbo,'userdata');
        component_number = temp(1); pannel_number = temp(2);
        pannel_struct = getfield(inst_component(component_number),['pannel' num2str(pannel_number)]);
        
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            if temp >= pannel_struct.parameters.centre_translation_min(1) && temp <= pannel_struct.parameters.centre_translation_max(1);
                pannel_struct.parameters.centre_translation(1) = temp;
            end
        end
        %Put the modified pannel structur back into the instrument component
        inst_component(component_number) = setfield(inst_component(component_number),['pannel' num2str(pannel_number)], pannel_struct);
        
        
        
        
    case 'det_offset_slider'
        temp = get(gcbo,'userdata');
        component_number = temp(1); pannel_number = temp(2);
        slider = get(gcbo,'value');
        
        pannel_struct = getfield(inst_component(component_number),['pannel' num2str(pannel_number)]);
        
        span = pannel_struct.parameters.centre_translation_max(1) - pannel_struct.parameters.centre_translation_min(1);
        translation  = slider * span + pannel_struct.parameters.centre_translation_min(1);
        pannel_struct.parameters.centre_translation(1) = translation;
        inst_component(component_number) = setfield(inst_component(component_number),['pannel' num2str(pannel_number)], pannel_struct);

        
    case 'pannel_edit'
        temp = get(gcbo,'userdata');
        component_number = temp(1); pannel_number = temp(2);
        pannel_struct = getfield(inst_component(component_number),['pannel' num2str(pannel_number)]);
        
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            if findstr(pannel_struct.name,'Left');
                if temp >= pannel_struct.parameters.opening_max && temp <= pannel_struct.parameters.opening_min;
                    pannel_struct.parameters.opening(1) = temp;
                end
            elseif findstr(pannel_struct.name,'Right');
                if temp <= pannel_struct.parameters.opening_max && temp >= pannel_struct.parameters.opening_min;
                    pannel_struct.parameters.opening(1) = temp;
                end
            elseif findstr(pannel_struct.name,'Top');
                if temp <= pannel_struct.parameters.opening_max && temp >= pannel_struct.parameters.opening_min;
                    pannel_struct.parameters.opening(2) = temp;
                end
            elseif findstr(pannel_struct.name,'Bottom');
                if temp >= pannel_struct.parameters.opening_max && temp <= pannel_struct.parameters.opening_min;
                    pannel_struct.parameters.opening(2) = temp;
                end
            end
        end
        
        %Put the modified pannel structur back into the instrument component
        inst_component(component_number) = setfield(inst_component(component_number),['pannel' num2str(pannel_number)], pannel_struct);
        
    case 'pannel_slider'
        temp = get(gcbo,'userdata');
        component_number = temp(1); pannel_number = temp(2);
        slider = get(gcbo,'value');
        
        pannel_struct = getfield(inst_component(component_number),['pannel' num2str(pannel_number)]);
        
        if findstr(pannel_struct.name,'Left');
            dimension = 1;
            slider = 1-slider;
            inverter = -1;
        elseif findstr(pannel_struct.name,'Right');
            dimension = 1;
            inverter = 1;
        elseif findstr(pannel_struct.name,'Top');
            dimension = 2;
            inverter = 1;
        elseif findstr(pannel_struct.name,'Bottom');
            dimension = 2;
            slider = 1-slider;
            inverter = -1;
        end
        
        span = pannel_struct.parameters.opening_max - pannel_struct.parameters.opening_min;
        opening  = slider * span + pannel_struct.parameters.opening_min;
        pannel_struct.parameters.opening(dimension) = opening;
        inst_component(component_number) = setfield(inst_component(component_number),['pannel' num2str(pannel_number)], pannel_struct);
        
        %Checked for grouped opening & modify all pannels
        for n = 1:length(inst_component);
            if findstr(inst_component(n).name,'Detector');
                for m = 1:inst_component(n).pannels
                    pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]);
                    if strcmp(pannel_struct.name,'Top')
                        pannel_group_check = inst_component(n).pannel_group;
                    end
                end
            end
        end
        
        
        if pannel_group_check ==1;
            for m = 1:inst_component(n).pannels
                pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]);
                if findstr(pannel_struct.name,'Left');
                    pannel_struct.parameters.opening(1) = -opening*inverter;
                elseif findstr(pannel_struct.name,'Right');
                    pannel_struct.parameters.opening(1) = opening*inverter;
                elseif findstr(pannel_struct.name,'Top');
                    pannel_struct.parameters.opening(2) = opening*inverter;
                elseif findstr(pannel_struct.name,'Bottom');
                    pannel_struct.parameters.opening(2) = -opening*inverter;
                end
                %Put the modified pannel structur back into the instrument component
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct);
            end
        end
        
        
    case 'pannel_group_check'
        temp = get(gcbo,'userdata');
        component_number = temp(1); pannel_number = temp(2);
        inst_component(component_number).pannel_group = get(gcbo,'value');
        pannel_struct = getfield(inst_component(component_number),['pannel' num2str(pannel_number)]);
        opening = pannel_struct.parameters.opening; %use opening(2) (y axis) if Top is controlling.
        
        if inst_component(component_number).pannel_group ==1; %then top pannel becomes the master controller
            for pannel = 1:inst_component(component_number).pannels
                pannel_struct = getfield(inst_component(component_number),['pannel' num2str(pannel)]);
                if findstr(pannel_struct.name,'Left');
                    pannel_struct.parameters.opening(1) = -opening(2);
                elseif findstr(pannel_struct.name,'Right');
                    pannel_struct.parameters.opening(1) = opening(2);
                elseif findstr(pannel_struct.name,'Top');
                    pannel_struct.parameters.opening(2) = opening(2);
                elseif findstr(pannel_struct.name,'Bottom');
                    pannel_struct.parameters.opening(2) = -opening(2);
                end
                %Put the modified pannel structur back into the instrument component
                inst_component(component_number) = setfield(inst_component(component_number),['pannel' num2str(pannel)], pannel_struct);
            end
        else
            return
        end
        
    case 'build_scattering_model'
        %Delete previous parameter input boxes (if exist);
        if not(isempty(d33_handles.scattering_model_gui));
            delete(d33_handles.scattering_model_gui);
            d33_handles.scattering_model_gui = [];
        end
        dy = 0;
        for n = 1:length(sample_config.model(sample_config.model_number).pnames)
            string= sample_config.model(sample_config.model_number).pnames{n};
            structname = sample_config.model(sample_config.model_number).structname{n};
            value = getfield(sample_config.model(sample_config.model_number),structname);
            handle1 = uicontrol('units','normalized','Position',[0.33   0.3+dy   0.06    0.018],'ForegroundColor',inst_model_params.foreground_color,'HorizontalAlignment','right','BackgroundColor',inst_model_params.background_color,'Style','text','string',string,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
            handle2 = uicontrol('units','normalized','Position',[0.4   0.3+dy    0.03   0.018],'Style','edit','tag',['sans_instrument_model_ff_param_' structname],'string',num2str(value),'userdata',structname, 'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'callback','sans_instrument_model_callbacks(''modify_model_parameter'')');
            d33_handles.scattering_model_gui = [d33_handles.scattering_model_gui, handle1, handle2];
            dy = dy -0.025;
        end
        return
        
    case 'build_background_model'
        %Delete previous parameter input boxes (if exist);
        if not(isempty(d33_handles.background_model_gui));
            delete(d33_handles.background_model_gui);
            d33_handles.background_model_gui = [];
        end
        dy = 0;
        for n = 1:length(background_config.model(background_config.model_number).pnames)
            string= background_config.model(background_config.model_number).pnames{n};
            structname = background_config.model(background_config.model_number).structname{n};
            value = getfield(background_config.model(background_config.model_number),structname);
            handle1 = uicontrol('units','normalized','Position',[0.53   0.3+dy   0.06    0.018],'ForegroundColor',inst_model_params.foreground_color,'HorizontalAlignment','right','BackgroundColor',inst_model_params.background_color,'Style','text','string',string,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
            %handle2 = uicontrol('units','normalized','Position',[0.6   0.3+dy    0.03   0.018],'Style','edit','tag',['sans_instrument_model_ff_param_' structname],'string',num2str(value),'userdata',structname, 'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'callback','sans_instrument_model_callbacks(''modify_model_parameter'')');
            d33_handles.background_model_gui = [d33_handles.background_model_gui, handle1, handle2];
            dy = dy -0.025;
        end
        return
   
    case 'build_cadmium_model'
        %Delete previous parameter input boxes (if exist);
        if not(isempty(d33_handles.cadmium_model_gui));
            delete(d33_handles.cadmium_model_gui);
            d33_handles.cadmium_model_gui = [];
        end
        dy = 0;
        for n = 1:length(cadmium_config.model(cadmium_config.model_number).pnames)
            string= cadmium_config.model(cadmium_config.model_number).pnames{n};
            structname = cadmium_config.model(cadmium_config.model_number).structname{n};
            value = getfield(cadmium_config.model(cadmium_config.model_number),structname);
            handle1 = uicontrol('units','normalized','Position',[0.53   0.3+dy   0.06    0.018],'ForegroundColor',inst_model_params.foreground_color,'HorizontalAlignment','right','BackgroundColor',inst_model_params.background_color,'Style','text','string',string,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
            %handle2 = uicontrol('units','normalized','Position',[0.6   0.3+dy    0.03   0.018],'Style','edit','tag',['sans_instrument_model_ff_param_' structname],'string',num2str(value),'userdata',structname, 'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'callback','sans_instrument_model_callbacks(''modify_model_parameter'')');
            d33_handles.background_model_gui = [d33_handles.cadmium_model_gui, handle1, handle2];
            dy = dy -0.025;
        end
        return
        
        
        
    case 'modify_model_parameter'
        structname = get(gcbo,'userdata');
        string = get(gcbo,'string');
        temp = str2num(string);
        if not(isempty(temp));
            sample_config.model(sample_config.model_number) = setfield(sample_config.model(sample_config.model_number),structname,temp);
        end
        
    case 'change_scattering_model'
        sample_config.model_number = get(gcbo,'value');
        sans_instrument_model_callbacks('build_scattering_model');
        
    case 'change_background_model'
        background_config.model_number = get(gcbo,'value');
        sans_instrument_model_callbacks('build_background_model');
        
    case 'change_cadmium_model'
        cadmium_config.model_number = get(gcbo,'value');
        sans_instrument_model_callbacks('build_cadmium_model');
        
    case 'hold_images_check'
        inst_model_params.hold_images_check = get(gcbo,'value');
        if inst_model_params.hold_images_check ==1;
            enable = 'on';
        else
            enable = 'off';
            inst_model_params.hold_count = 1;
        end
        set(d33_handles.hold_image_stagger_check,'enable',enable);
        return
        
    case 'hold_images_stagger'
        inst_model_params.hold_stagger_plots = get(gcbo,'value');
        return
        
    case 'tof_lambda_min'
        wav_str = get(gcbo,'string');
        temp = str2num(wav_str);
        if not(isempty(temp));
            inst_config.tof_wav_min = temp;
        end
        inst_model_params.det_image_tof_frame = 1; %Reset the tof 2D frame selector
        inst_model_params.monitor = 0;
        
    case 'tof_lambda_max'
        wav_str = get(gcbo,'string');
        temp = str2num(wav_str);
        if not(isempty(temp));
            inst_config.tof_wav_max = temp;
        end
        inst_model_params.det_image_tof_frame = 1; %Reset the tof 2D frame selector
        inst_model_params.monitor = 0;
        
    case 'tof_res'
        inst_config.tof_resolution_setting = get(gcbo,'value');
        inst_model_params.det_image_tof_frame = 1; %Reset the tof 2D frame selector
        inst_model_params.monitor = 0; %Reset the beam monitor counter
        
    case 'mono_tof'
        value = get(gcbo,'value');
        string = get(gcbo,'string');
        inst_config.mono_tof = string{value};
        inst_model_params.det_image_tof_frame = 1; %Reset the tof 2D frame selector
        inst_model_params.monitor = 0; %Reset the beam monitor counter
        
    case 'det_image_log_check'
        inst_model_params.det_image_log_check = get(gcbo,'value');
        sans_instrument_model_callbacks('plot_2D'); %refresh the 2D display
        return
        
    case 'det_image_popup'
        string = get(gcbo,'string');
        value = get(gcbo,'value');
        inst_model_params.det_image = string{value};
        sans_instrument_model_callbacks('plot_2D'); %refresh the 2D display
        return
        
    case 'det_image_tof_wav'
        inst_model_params.det_image_tof_frame = get(gcbo,'value');
        sans_instrument_model_callbacks('plot_2D'); %refresh the 2D display
        return
        
    case 'plot_2D'
        
        %***** Update 2D Detector Display *****
        qdepth = [];
        if strcmp(inst_model_params.det_image,'Mod_q'); qdepth = 5;
        elseif strcmp(inst_model_params.det_image,'Mod_q'); qdepth = 5;
        elseif strcmp(inst_model_params.det_image,'q_x'); qdepth = 3;
        elseif strcmp(inst_model_params.det_image,'q_y'); qdepth = 4;
        elseif strcmp(inst_model_params.det_image,'q_Angle'); qdepth = 6;
        elseif strcmp(inst_model_params.det_image,'Solid_Angle'); qdepth = 10;
        end
        %Search for max and min z-scale
        z_max_store = 0; z_min_store = 1e20;
        for n = 1:length(inst_component);
            if findstr(inst_component(n).name,'Detector') %Find detector component
                for m = 1:inst_component(n).pannels %Loop though detector pannels
                    pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                    
                    if not(isfield(pannel_struct,'qmatrix')); return; end; %Jump out if nothing has been calculated yet
                    
                    detector_mask = pannel_struct.parameters.beam_stop_mask .* pannel_struct.parameters.shaddow_mask;
                    if not(isempty(qdepth)); %Allocate q-matrix field
                        display_data = pannel_struct.qmatrix(:,:,qdepth,inst_model_params.det_image_tof_frame);
                    elseif (strcmp(inst_model_params.det_image,'Detector_Image'))
                        %Detector data
                        display_data = pannel_struct.detector_data(:,:,inst_model_params.det_image_tof_frame);
                    elseif strcmp(inst_model_params.det_image,'Direct_Beam');
                        display_data = zeros(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1));
                        if length(inst_config.source_size) ==1; %i.e. circular source
                            temp = find(pannel_struct.qmatrix(:,:,9,inst_model_params.det_image_tof_frame)<=inst_config.divergence_x_fwhm/2);
                            display_data(temp) = 1;
                        else %i.e. rectangular source
                            temp = find(pannel_struct.qmatrix(:,:,7,inst_model_params.det_image_tof_frame)<=inst_config.divergence_x_fwhm/2 & pannel_struct.qmatrix(:,:,7,inst_model_params.det_image_tof_frame)>=-inst_config.divergence_x_fwhm/2 & pannel_struct.qmatrix(:,:,8,inst_model_params.det_image_tof_frame)<=inst_config.divergence_y_fwhm/2 & pannel_struct.qmatrix(:,:,8,inst_model_params.det_image_tof_frame)>=-inst_config.divergence_y_fwhm/2);
                            display_data(temp) = 1;
                        end
                    end
                    temp = max(max(display_data.*detector_mask));
                    if temp > z_max_store; z_max_store = temp; end
                    temp = min(min(display_data));
                    if temp < z_min_store; z_min_store = temp; end
                end
            end
        end
        %Update 2D display
        for n = 1:length(inst_component);
            if findstr(inst_component(n).name,'Detector') %Find detector component
                for m = 1:inst_component(n).pannels %Loop though detector pannels
                    pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                    detector_mask = pannel_struct.parameters.beam_stop_mask .* pannel_struct.parameters.shaddow_mask;
                    if not(isempty(qdepth)); %Allocate q-matrix field
                        display_data = pannel_struct.qmatrix(:,:,qdepth,inst_model_params.det_image_tof_frame).*detector_mask;
                    elseif (strcmp(inst_model_params.det_image,'Detector_Image'))
                        display_data = pannel_struct.detector_data(:,:,inst_model_params.det_image_tof_frame).*detector_mask;
                    elseif strcmp(inst_model_params.det_image,'Direct_Beam');
                        display_data = zeros(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1));
                        if length(inst_config.source_size) ==1; %i.e. circular source
                            temp = find(pannel_struct.qmatrix(:,:,9,inst_model_params.det_image_tof_frame)<=inst_config.divergence_x_fwhm/2);
                            display_data(temp) = 1;
                        else %i.e. rectangular source
                            temp = find(pannel_struct.qmatrix(:,:,7,inst_model_params.det_image_tof_frame)<=inst_config.divergence_x_fwhm/2 & pannel_struct.qmatrix(:,:,7,inst_model_params.det_image_tof_frame)>=-inst_config.divergence_x_fwhm/2 & pannel_struct.qmatrix(:,:,8,inst_model_params.det_image_tof_frame)<=inst_config.divergence_y_fwhm/2 & pannel_struct.qmatrix(:,:,8,inst_model_params.det_image_tof_frame)>=-inst_config.divergence_y_fwhm/2);
                            display_data(temp) = 1;
                        end
                        display_data = display_data.*pannel_struct.parameters.shaddow_mask;
                    end
                    z_lims = [z_min_store,z_max_store];
                    if inst_model_params.det_image_log_check ==1 && isempty(qdepth);
                        warning off
                        display_data = log10(display_data);
                        z_lims(1) = z_lims(1)+eps; z_lims(2) = z_lims(2)+2*eps;
                        z_lims = log10(z_lims);
                        warning on
                    end
                    set(pannel_struct.pcolor_2d_handle,'cdata',display_data);
                    z_lims = sort(real(z_lims));
                    if z_lims(1) == z_lims(2);
                        z_lims(1) = z_lims(1)-eps;
                        z_lims(2) = z_lims(2)+eps;
                    end
                    
                    set(pannel_struct.pcolor_axes_2d_handle,'clim',z_lims);
                end
            end
        end
        return
end



%***** Update Wavelength Object Visibility *****
if strcmp(inst_config.mono_tof,'Mono')
    mono_visible = 'on'; tof_visible = 'off';
elseif strcmp(inst_config.mono_tof,'TOF')
    mono_visible = 'off'; tof_visible = 'on';
end

for n = 1:length(inst_config.wav_modes)
    if strfind(inst_config.wav_modes{n},'Mono');
        set(d33_handles.wavelength_text1,'visible',mono_visible);
        set(d33_handles.wavelength_edit,'visible',mono_visible,'string',num2str(inst_config.mono_wav));
        set(d33_handles.wavelength_text2,'visible',mono_visible);
        set(d33_handles.wavelength_res_edit,'visible',mono_visible,'string',num2str(inst_config.mono_dwav));
    elseif strfind(inst_config.wav_modes{n},'TOF');
        
        set(d33_handles.tof_text1,'visible',tof_visible);
        set(d33_handles.tof_min_edit,'visible',tof_visible);
        set(d33_handles.tof_text2,'visible',tof_visible);
        set(d33_handles.tof_max_edit,'visible',tof_visible);
        set(d33_handles.tof_text3,'visible',tof_visible);
        set(d33_handles.tof_res_popup,'visible',tof_visible);
        set(d33_handles.tof_spacing_text,'visible',tof_visible);
        set(d33_handles.tof_resolution_rear_text,'visible',tof_visible);
        set(d33_handles.tof_resolution_front_text,'visible',tof_visible);
        
        set(d33_handles.detector_image_tof_wav,'visible',tof_visible);
    end
end
%Set chopper text visibility
for n = 1:length(inst_component);
    if findstr(inst_component(n).name,'Chopper:')
        chopper_number_str = strtok(inst_component(n).name,'Chopper: ');
        chopper_number = str2num(chopper_number_str);
        temp = getfield(d33_handles,['chopper' num2str(chopper_number) 'text']);
        set(temp,'visible',tof_visible);
    end
end


%Update Collimation Selector position
cols = get(d33_handles.col_length_popup,'string');
for n = 1:length(cols);
    if strcmp(cols{n},num2str(inst_config.col)); value = n; end
end
set(d33_handles.col_length_popup,'value',value);

%Update auto Calculate button
if inst_model_params.auto_calculate ==1;
    string = 'Auto : On'; color = [0 1 0];
else
    string = 'Auto : Off'; color = [1 0 0];
end
set(d33_handles.auto_calculate_button,'string',string,'backgroundcolor',color);

%***** Loop though the instrument components and update their status *****
for n = 1:length(inst_component);
    if findstr(inst_component(n).name,'Collimation')
        if abs(single(inst_component(n).position+inst_component(n).length)) <= single(inst_config.col);
            color = inst_model_params.col_in_color;
        else
            color = inst_model_params.col_out_color;
        end
        set(inst_component(n).handle,'facecolor',color);
    end
    
    if findstr(inst_component(n).name,'Aperture')
        if abs(inst_component(n).position) == inst_config.col;
            status = 'on';
        else
            status = 'off';
            inst_component(n).value = 1; %reset aperture to default
        end
        set(inst_component(n).ui_handle,'enable',status);
        set(inst_component(n).ui_handle,'value',inst_component(n).value);
    end
    
    if findstr(inst_component(n).name,'Detector')
        %Update slider positions
        slider_handle =  inst_component(n).gui_handle_slider;
        position = inst_component(n).position;
        position_max = inst_component(n).parameters.position_max;
        position_min = inst_component(n).parameters.position_min;
        slider = (position-position_min)/ (position_max - position_min);
        set(slider_handle,'value',slider);
        
        %Update edit box positions
        editbox_handle =  inst_component(n).gui_handle_editbox;
        set(editbox_handle,'string',num2str(position));
        
        %Update Graphic
        pannels = inst_component(n).pannels; %no. pannels making up the detector
        for m = 1:pannels
            pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]);
            %Side View
            graphic_handle = pannel_struct.draw_handle_side_view;
            %Update component graphic position
            graphic_position = get(graphic_handle,'Position');
            graphic_position(1) = position+pannel_struct.relative_position;
            if findstr(pannel_struct.name,'Top');
                graphic_position(2) = pannel_struct.parameters.opening(2);
            end
            if findstr(pannel_struct.name,'Bottom');
                graphic_position(2) = pannel_struct.parameters.opening(2) - pannel_struct.parameters.pixels(2)*pannel_struct.parameters.pixel_size(2);
            end
            set(graphic_handle,'Position', graphic_position);
            
            %Front View
            if isfield(pannel_struct,'pannel_slider_handle');
                slider_handle = pannel_struct.pannel_slider_handle;
                edit_handle = pannel_struct.pannel_editbox_handle;
                if not(isempty(slider_handle))
                    
                    opening = pannel_struct.parameters.opening;
                    if findstr(pannel_struct.name,'Left');
                        %update slider & editbox
                        slider = (opening(1) - pannel_struct.parameters.opening_min) / (pannel_struct.parameters.opening_max - pannel_struct.parameters.opening_min);
                        slider = 1-slider;
                        set(slider_handle,'value',slider);
                        set(edit_handle,'string',num2str(opening(1)));
                        %redraw graphic
                        handle = pannel_struct.draw_handle_front_view;
                        graphic_position = get(handle,'position');
                        graphic_position(1) = opening(1) - pannel_struct.parameters.pixels(1)*pannel_struct.parameters.pixel_size(1);
                        set(handle,'position',graphic_position);
                    elseif findstr(pannel_struct.name,'Right');
                        %update slider & editbox
                        slider = (opening(1) - pannel_struct.parameters.opening_min) / (pannel_struct.parameters.opening_max - pannel_struct.parameters.opening_min);
                        set(slider_handle,'value',slider);
                        set(edit_handle,'string',num2str(opening(1)));
                        %redraw graphic
                        handle = pannel_struct.draw_handle_front_view;
                        graphic_position = get(handle,'position');
                        graphic_position(1) = opening(1);
                        set(handle,'position',graphic_position);
                    elseif findstr(pannel_struct.name,'Top');
                        %update slider & editbox
                        slider = (opening(2) - pannel_struct.parameters.opening_min) / (pannel_struct.parameters.opening_max - pannel_struct.parameters.opening_min);
                        set(slider_handle,'value',slider);
                        set(edit_handle,'string',num2str(opening(2)));
                        %redraw graphic
                        handle = pannel_struct.draw_handle_front_view;
                        graphic_position = get(handle,'position');
                        graphic_position(2) = opening(2);
                        set(handle,'position',graphic_position);
                    elseif findstr(pannel_struct.name,'Bottom');
                        %update slider & editbox
                        slider = (opening(2) - pannel_struct.parameters.opening_min) / (pannel_struct.parameters.opening_max - pannel_struct.parameters.opening_min);
                        slider = 1-slider;
                        set(slider_handle,'value',slider);
                        set(edit_handle,'string',num2str(opening(2)));
                        %redraw graphic
                        handle = pannel_struct.draw_handle_front_view;
                        graphic_position = get(handle,'position');
                        graphic_position(2) = opening(2) - pannel_struct.parameters.pixels(2)*pannel_struct.parameters.pixel_size(2);
                        set(handle,'position',graphic_position);
                    
                    elseif findstr(pannel_struct.name,'Rear')
                        %update slider & editbox
                        slider = (pannel_struct.parameters.centre_translation(1) - pannel_struct.parameters.centre_translation_min(1)) / (pannel_struct.parameters.centre_translation_max(1) - pannel_struct.parameters.centre_translation_min(1));
                        set(slider_handle,'value',slider);
                        set(edit_handle,'string',num2str(pannel_struct.parameters.centre_translation(1)));
                        %redraw graphic
                        handle = pannel_struct.draw_handle_front_view;
                        graphic_position = get(handle,'position');
                        graphic_position(1) = -pannel_struct.xydim{1}(1)/2 - pannel_struct.parameters.centre_translation(1);
                        set(handle,'position',graphic_position);
                        
                    end
                end
            end
        end
    end
end

%***** BEGIN TOF, SCATERING & RESOLUTION CALCULATIONS *****
if inst_model_params.auto_calculate ==1 || strcmp(todo,'single_shot_calculate');
    
    set(d33_handles.thinking,'visible','on'); pause(0.5)
    
    %Find some required parameters
    for n = 1:length(inst_component);
        if findstr(inst_component(n).name,'Detector 1');
            det1_index = n;
            inst_config.longest_det = inst_component(det1_index).position;
        end
        if findstr(inst_component(n).name,'Detector 2');
            det2_index = n;
            inst_config.shortest_det = inst_component(det2_index).position;
        end
        if findstr(inst_component(n).name,'Chopper: 4');
            last_chop_index = n;
        end
    end
    
    %*****Calculate TOF Parameters if Required *****
    if strcmp(inst_config.mono_tof,'TOF');
        inst_config.last_chopper_sample_length = -inst_component(last_chop_index).position;
        inst_config.chopper_opening = inst_component(last_chop_index).parameters.opening;
        max_chopper_spacing = inst_config.chopper_spacing_matrix(1);
        
        disp(' ')
        disp(['TOF Wavelength lambda_min = ' num2str(inst_config.tof_wav_min) ' (�),  lambda_max = ' num2str(inst_config.tof_wav_max) ' (�)']);
        disp(['Last chopper - Sample distance = ' num2str(inst_config.last_chopper_sample_length) ' (m)']);
        disp(['Sample - Max Detector distance = ' num2str(inst_config.longest_det) ' (m)']);
        inst_config.chopper_total_tof = inst_config.longest_det + inst_config.last_chopper_sample_length + inst_config.chopper_spacing_offset_matrix(inst_config.tof_resolution_setting)+inst_config.chopper_spacing_matrix(inst_config.tof_resolution_setting)/2;
        disp(['Total TOF distance = ' num2str(inst_config.chopper_total_tof) ' (m)']);
        
        temp = get(d33_handles.tof_res_popup,'string');
        inst_config.chopper_pair = temp{inst_config.tof_resolution_setting};
        inst_config.chopper_spacing = inst_config.chopper_spacing_matrix(inst_config.tof_resolution_setting);
        disp(['Resolution Controlling Chopper Pair:  ' inst_config.chopper_pair ',  Separation:  ' num2str(inst_config.chopper_spacing) ' (m)']);
        
        %Rear detector resolution
        inst_config.chopper_resolution = 100* (inst_config.chopper_spacing_matrix(inst_config.tof_resolution_setting) / inst_config.chopper_total_tof);
        disp(['Nominal Rear Detector Resolution  (delta_d / d) (delta_lambda / lambda) = ' num2str(inst_config.chopper_resolution) ' (%)']);
        
        %Front detector resolution
        det_separation = inst_config.longest_det - inst_config.shortest_det;
        inst_config.chopper_resolution_front = 100* (inst_config.chopper_spacing_matrix(inst_config.tof_resolution_setting) / (inst_config.chopper_total_tof-det_separation));
        disp(['Nominal Front Detector Resolution  (delta_d / d) (delta_lambda / lambda) = ' num2str(inst_config.chopper_resolution_front) ' (%)']);
        
        h = 6.626076*(10^-34); %Plank's Constant
        m_n = 1.674929*(10^-27); %Neutron Rest Mass
        inst_config.chopper_f1_freq = h./(m_n.* inst_config.chopper_total_tof.*inst_config.tof_wav_max*10^-10);
        disp(['Maximum F1 chopper frequency = ' num2str(inst_config.chopper_f1_freq) ' [Hz],  (' num2str(inst_config.chopper_f1_freq*60) ' [RPM])']);
        
        inst_config.chopper_required_opening = inst_config.chopper_resolution * 360/100;
        disp(['Required chopper opening window = ' num2str(inst_config.chopper_required_opening) ' [Degrees],  [' num2str(inst_config.chopper_opening) ' Avaliable]']);
        
        inst_config.chopper_multiplier_max1 = floor((inst_config.chopper_opening ./ inst_config.chopper_required_opening));
        disp(['Max chopper frequency multiplication due to Chopper Opening ' num2str(inst_config.chopper_opening) ' degrees  = ' num2str(inst_config.chopper_multiplier_max1)]);
        
        
        inst_config.chopper_multiplier_max2 = floor(inst_config.chopper_total_tof / max_chopper_spacing);
        disp(['Max chopper frequency multiplication due to frame overlap within choppers  = ' num2str(inst_config.chopper_multiplier_max2)]);
        
        inst_config.chopper_multiplier_max = min(inst_config.chopper_multiplier_max1, inst_config.chopper_multiplier_max2);
        disp(['Overall Maximum frequency multiplication possible = ' num2str(inst_config.chopper_multiplier_max)]);
        
        inst_config.chopper_fn_freq = inst_config.chopper_f1_freq * inst_config.chopper_multiplier_max;
        disp(['N x F1 chopper frequency required for maximum multiplication [Hz]:  N = ' num2str(inst_config.chopper_multiplier_max) ',  N x F1 = ' num2str(inst_config.chopper_fn_freq) ' [Hz] ,' num2str(inst_config.chopper_fn_freq*60) ' [RPM])']);
        disp(' ')
        
        %Update displayed TOF objects
        set(d33_handles.tof_spacing_text,'string',[num2str(inst_config.chopper_spacing) ' [m]']);
        set(d33_handles.tof_resolution_rear_text,'string',[num2str(round(inst_config.chopper_resolution*10)/10) ' [%] (Rear)']);
        set(d33_handles.tof_resolution_front_text,'string',[num2str(round(inst_config.chopper_resolution_front*10)/10) ' [%] (Front)']);
        
        for n = 1:length(inst_component);
            if findstr(inst_component(n).name,'Chopper:')
                chopper_number_str = strtok(inst_component(n).name,'Chopper: ');
                chopper_number = str2num(chopper_number_str);
                temp = getfield(d33_handles,['chopper' num2str(chopper_number) 'text']);
                
                if findstr(inst_config.chopper_pair,chopper_number_str);
                    string = ['N=' num2str(inst_config.chopper_multiplier_max) char(10) 'NxF1 =' num2str(inst_config.chopper_fn_freq) '[Hz]'];
                else
                    string = ['F1=' num2str(inst_config.chopper_f1_freq) '[Hz]'];
                end
                set(temp,'string',string);
            end
        end
        
    end
    
    
    
    %***** Calculate the required BeamStop size, BeamStop mask(Pixels) and DIVERGENCE *****
    %Find the guide size at the guide/col boundary
    for n = 1:length(inst_component);
        if findstr(inst_component(n).name,'Collimation') & single(inst_config.col) == -single(inst_component(n).position + inst_component(n).length);
            guide_size = inst_component(n).xydim{1};
            inst_config.source_size = guide_size;
        end
    end
    %Check if there is an aperture instead of open guide
    for n = 1:length(inst_component);
        if findstr(inst_component(n).name,'Aperture') & single(inst_config.col) == -single(inst_component(n).position);
            aperture_size = inst_component(n).xydim{inst_component(n).value};
            %Check which is smaller, Aperture or Open Guide
            if length(aperture_size) == 2; %Rectangular
                inst_config.source_size(1) = min(guide_size(1), aperture_size(1));
                inst_config.source_size(2) = min(guide_size(2), aperture_size(2));
            elseif length(aperture_size) == 1; %Circular
                if aperture_size(1) <= guide_size(1) && aperture_size(1) <= guide_size(2); %i.e. circular aperture is smaller than both guide dimensions
                    inst_config.source_size = aperture_size; %a single dimension here means to keep circular profile
                else
                    inst_config.source_size(1) = min(guide_size(1), aperture_size(1));
                    inst_config.source_size(2) = min(guide_size(2), aperture_size(1));
                end
            end
        end
    end
    
    %Divergence
    if length(inst_config.source_size) ==1; %Circular
        disp(['Circular Entrance Aperture, ' num2str(inst_config.source_size*1000) ' [mm] Diameter at Collimation ' num2str(inst_config.col) ' [m]']);
        inst_config.divergence_mean_fwhm = (180/pi)*2*atan((inst_config.source_size/2) / inst_config.col);
        inst_config.divergence_x_fwhm = inst_config.divergence_mean_fwhm;
        inst_config.divergence_y_fwhm = inst_config.divergence_mean_fwhm;
    else %Rectangular or Square
        disp(['Rectangular Entrance Aperture, x ' num2str(inst_config.source_size(1)*1000) ' mm   y, ' num2str(inst_config.source_size(2)*1000) ' [mm] at Collimation ' num2str(inst_config.col) ' [m]']);
        inst_config.divergence_mean_fwhm = (180/pi)*2*atan((mean(inst_config.source_size)/2) / inst_config.col);
        inst_config.divergence_x_fwhm = (180/pi)*2*atan((inst_config.source_size(1)/2) / inst_config.col);
        inst_config.divergence_y_fwhm = (180/pi)*2*atan((inst_config.source_size(2)/2) / inst_config.col);
    end
    
    
    
    
    %***** Build Wavelength list to calculate scattering at depending on Mono or TOF mode *****
    if strcmp(inst_config.mono_tof,'Mono')
        disp(['Monochromatic mode @ ' num2str(inst_config.mono_wav) ' [angs], Resolution ' num2str(inst_config.mono_dwav) ' [%]']);
        tof_wavs = inst_config.mono_wav;
    elseif strcmp(inst_config.mono_tof,'TOF')
        %For TOF mode, calcualte Wavs to calcualte 'n' wavelengths, separated by the resolution
        wav = inst_config.tof_wav_min;
        tof_wavs = [inst_config.tof_wav_min];
        while tof_wavs < inst_config.tof_wav_max;
            wav = wav + (wav*inst_config.chopper_resolution/100)*1.25;  %This way generates Wavs separated by delta lambda.  The x n just reduces the number of wav bins
            %wav = wav + (inst_config.tof_wav_max - inst_config.tof_wav_min)/30; %This just generates 10 equaly spaced wavs
            tof_wavs = [tof_wavs, wav];
        end
        disp(['TOF mode.  Calculating Scattering for wavelengths ' num2str(inst_config.tof_wav_min) ' to ' num2str(inst_config.tof_wav_max) ' [�]']);
    end
    %Keep a store of the wavelength bins
    inst_config.tof_wavs = tof_wavs;
    
    %Update the wavelength channel selector for the 2D display
    set(d33_handles.detector_image_tof_wav,'string',num2cell(tof_wavs),'value',inst_model_params.det_image_tof_frame);
    
    
    
    %Generate the beam stop mask
    beam_patch_fwidth = inst_config.source_size * inst_config.longest_det / inst_config.col; %m
    disp(['Required beam stop size (x,y) => ' num2str(beam_patch_fwidth*1000) ' [mm]']);
    disp(' ');
    for n = 1:length(inst_component);
        if findstr(inst_component(n).name,'Detector') %Find detector component
            for m = 1:inst_component(n).pannels %Loop though detector pannels
                pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                pannel_struct.parameters.beam_stop_mask = ones(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1)); %clear the mask
                if findstr(pannel_struct.name,'Rear');
                    beam_patch_pixel_width = beam_patch_fwidth ./ pannel_struct.parameters.pixel_size ; %pixels
                    beam_stop_width_pixels = beam_patch_pixel_width * 1.5; %Multiply by 1.25 to be safe.
                    beam_stop_centre_translation_pixels = pannel_struct.parameters.centre_translation ./ pannel_struct.parameters.pixel_size;
                    beam_stop_coords = [floor(pannel_struct.parameters.centre(1)-beam_stop_width_pixels(1)/2 + beam_stop_centre_translation_pixels(1)), ceil(pannel_struct.parameters.centre(1)+beam_stop_width_pixels(1)/2 + beam_stop_centre_translation_pixels(1)), floor(pannel_struct.parameters.centre(2)-beam_stop_width_pixels(2)/2 + beam_stop_centre_translation_pixels(2)), ceil(pannel_struct.parameters.centre(2)+beam_stop_width_pixels(2)/2 + beam_stop_centre_translation_pixels(2))]; %x1, x2, y1, y2

                    
%                     %Make a Gravity Drop to the effective beam stop position
%                     lambda = tof_wavs(1);
%                     detector_info.position = inst_component(n).position + pannel_struct.relative_position;
%                     drop = 0.5*g*(detector_info.position^2)*(m_n^2)*((lambda*1e-10)^2)/(h^2);
%                     beam_stop_coords(3:4) = beam_stop_coords(3:4)  + round(drop./pannel_struct.parameters.pixel_size(2));
                    %Check beamstop coords do not go over size of detector
                    if beam_stop_coords(1) <1 ; beam_stop_coords(1) = 1; end
                    if beam_stop_coords(3) <1 ; beam_stop_coords(3) = 1; end
                    if beam_stop_coords(2) >pannel_struct.parameters.pixels(1) ; beam_stop_coords(2) = pannel_struct.parameters.pixels(1); end
                    if beam_stop_coords(4) >pannel_struct.parameters.pixels(2) ; beam_stop_coords(4) = pannel_struct.parameters.pixels(2); end
                    pannel_struct.parameters.beam_stop_mask(beam_stop_coords(3):beam_stop_coords(4), beam_stop_coords(1):beam_stop_coords(2)) = NaN; %Mask out 1.5x beam patch
                end
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
                
            end
        end
    end
    
    
    
    
    %***** Build all q-matricies for all wavelengths *****
    detector_counter = 0;
    for n = 1:length(inst_component);
        if findstr(inst_component(n).name,'Detector') %Find detector component
            detector_counter = detector_counter+1;
            for m = 1:inst_component(n).pannels %Loop though detector pannels

                pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                
                %Current Detector Pannel Parameters
                detector_info.pixels = pannel_struct.parameters.pixels;
                detector_info.pixel_size = pannel_struct.parameters.pixel_size;
                detector_info.centre = pannel_struct.parameters.centre; %This gets modified to include a gravity drop
                detector_info.nominal_centre = pannel_struct.parameters.centre; %without gravity drop
                detector_info.centre_translation = pannel_struct.parameters.centre_translation;
                detector_info.opening = pannel_struct.parameters.opening;
                detector_info.position = inst_component(n).position + pannel_struct.relative_position;
                
                
                
                pannel_struct.detector_data = zeros(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1),length(tof_wavs));
                
                
                
                for o = 1:length(tof_wavs); %Loop though TOF wavelengths
                
                    %wavelength
                    if strcmp(inst_config.mono_tof,'Mono')
                        lambda = inst_config.mono_wav;
                        dlambda_lambda = inst_config.mono_dwav /100;
                    elseif strcmp(inst_config.mono_tof,'TOF')
                        lambda = tof_wavs(o);
                        if findstr(inst_component(n).name,'Front')
                            res = inst_config.chopper_resolution_front;
                        else
                            res = inst_config.chopper_resolution;
                        end
                        dlambda_lambda = res/100;
                    end

%                     %Make a Gravity Drop to the effective beam centre
%                     drop = 0.5*g*(detector_info.position^2)*(m_n^2)*((lambda*1e-10)^2)/(h^2);
%                     detector_info.centre = detector_info.nominal_centre;
%                     detector_info.centre(2) = detector_info.nominal_centre(2) + (drop/detector_info.pixel_size(2));
                    pannel_struct.qmatrix(:,:,:,o) = sans_instrument_model_build_q_matrix(detector_info,lambda);

                    
                    %***** Generate Scattering Data *****
                    sample_data = zeros(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1));
                    background_data = zeros(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1));
                    cadmium_data = zeros(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1));
                    
                    
                    for p = 1:inst_model_params.smearing
                        
                        %wavelength Distribution TOF mode
                        if strcmp(inst_config.mono_tof,'TOF')
                            %disp('TOF Wavelength Top-Hat Distribution')
                            %Make a matrix of random wavelengths with a SQUARE distribution
                            delta_lambda = lambda * dlambda_lambda;
                            delta_wav = ((rand(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1)) - 0.5) * delta_lambda);
                            wav_matrix = delta_wav + lambda; %Use this in build_q_matrix
                            
                        elseif strcmp(inst_config.mono_tof,'Mono')
                            %disp('Mono Wavelength Gaussian Distribution')
                            %NEW VERSION:  Make a matrix of random wavelengths with a Gaussian distribution (Based on Matlab's RANDN fn.)
                            %Generate values from a normal distribution with mean 1 and standard deviation 2. e.g:  r = 1 + 2.*randn(100,1);
                            delta_lambda_sigma  = (lambda * dlambda_lambda) / 2.3548;
                            wav_matrix = lambda + delta_lambda_sigma.* randn(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1));
                            
                        end
                        
                        
                        %Make a matrix of random delta_theta's with a SQUARE distribution
                        delta_theta_x_matrix = (rand(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1))-0.5) * inst_config.divergence_x_fwhm;
                        delta_theta_y_matrix = (rand(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1))-0.5) * inst_config.divergence_y_fwhm;
                        
                        %***** Uncomment below to force zero divergence *****
                        %delta_theta_x_matrix = zeros(size(delta_theta_x_matrix));
                        %delta_theta_y_matrix = zeros(size(delta_theta_y_matrix));
                        
                        %Generate the 'real' q matrix that has statistical variations to account for wavelength resolution and divergence
                        
                        real_q_matrix = sans_instrument_model_build_q_matrix(detector_info,wav_matrix,delta_theta_x_matrix, delta_theta_y_matrix); %Used by some of the model functions, eg. Flux Lattice
                        q = real_q_matrix(:,:,5);  %This is just the mod_q from above q_matrix
                        
                        
                        %Calcualte the Model Scattering Intensity
                        fn_eval = sample_config.model(sample_config.model_number).fn_eval;
                        P = eval(fn_eval);
                        sample_data = sample_data + P;
                        
                        %Calculate the Model Background Intensity
                        fn_eval = background_config.model(background_config.model_number).fn_eval;
                        P = eval(fn_eval);
                        background_data = background_data + P;
                        
                        %Calculate the Model Blocked Beam Intensity Intensity
                        fn_eval = cadmium_config.model(cadmium_config.model_number).fn_eval;
                        P = eval(fn_eval);
                        cadmium_data = cadmium_data + P;
                       
                        
                    end
                    sample_data = sample_data/inst_model_params.smearing; %This is a pure scattering crosssection
                    background_data = background_data/inst_model_params.smearing; %This is a pure scattering crosssection
                    cadmium_data = cadmium_data/inst_model_params.smearing; %This is a pure scattering crosssection
                    
                    
                    %Scale ff_model to model real SANS data
                    if strcmp(inst_config.inst,'ILL_d22');
                        flux_lambda_col = d22_flux_col_wav(inst_config.col, lambda, dlambda_lambda,'selector');
                    elseif strcmp(inst_config.inst,'ILL_d33');
                        if strcmp(inst_config.mono_tof,'Mono');
                            kernel_shape = 'selector';
                            res_temp = dlambda_lambda;
                        else
                            kernel_shape = 'double_chopper';
                            res_temp = inst_config.chopper_resolution/100;
                        end
                        
                      flux_lambda_col = d22_flux_col_wav(inst_config.col, lambda, res_temp,kernel_shape);
                    elseif strcmp(inst_config.inst,'ILL_d11');
                        flux_lambda_col = d22_flux_col_wav(inst_config.col, lambda, dlambda_lambda,'selector');
                    else
                        flux_lambda_col = sans_instrument_model_flux_col_wav(inst_config.max_flux,inst_config.max_flux_col,inst_config.max_flux_wav,inst_config.col,lambda); %Flux guess for particualar lambda and collimation
                    end
                    
                    
                    I0 = flux_lambda_col * inst_model_params.measurement_time * inst_model_params.sample_area;
                    
                
                    %Final Total Scattering
                    total_sample_scattering = sample_data .* I0 .* inst_model_params.sample_thickness .* real_q_matrix(:,:,10);
                    total_background_scattering = background_data .* I0 .* inst_model_params.sample_thickness .* real_q_matrix(:,:,10);
                    total_cadmium_scattering = cadmium_data .* I0 .* inst_model_params.sample_thickness .* real_q_matrix(:,:,10);
                    pannel_struct.detector_data(:,:,o) = total_sample_scattering+total_background_scattering+total_cadmium_scattering;
                    
                    
                    
                    
                    %Add poissonian noise to simulate real statistical noise
                    %Take sqrt counts as the error.  This should be +- this
                    %should be distributed +- about the point.  Then add a
                    %random error between -error to + error to the point
                    if inst_model_params.poissonian_noise_check ==1;
                        %Local copy of current detector data without poissonian stats
                        current_data_copy1 = pannel_struct.detector_data(:,:,o);
                        current_data_copy2 = pannel_struct.detector_data(:,:,o);

                        errors_magnitude = sqrt(current_data_copy1);
                        rand_matrix = rand(size(current_data_copy1)); %between 0 and 1
                        rand_matrix = (rand_matrix -0.5)*2; %between -1 and 1
                        errors = errors_magnitude .* rand_matrix;
                        
                        %Add the usual poisonian stat errors
                        current_data_copy1 = abs(current_data_copy1 + errors);
                        
                        %Find intensities <=1 and generate probability of count or not to avoid staitistics problems for sparse counts
                        sparce_pixels = find(current_data_copy2<=1);
                        for sparce_counter = 1:length(sparce_pixels);
                            alive_probability = current_data_copy2(sparce_pixels(sparce_counter)); %i.e. a number below 1
                            if rand <= alive_probability
                                current_data_copy1(sparce_pixels(sparce_counter)) = 1;
                            else
                                current_data_copy1(sparce_pixels(sparce_counter)) = 0;
                            end
                        end
                        %Put back the poisonian noised data
                        pannel_struct.detector_data(:,:,o) = current_data_copy1;
                    end
                    
                    %Display Total Detector Counts
                    %Retrieve Mask
                    if not(isempty(pannel_struct.parameters.shaddow_mask));
                        detector_mask = pannel_struct.parameters.beam_stop_mask .* pannel_struct.parameters.shaddow_mask;
                    else
                        detector_mask = pannel_struct.parameters.beam_stop_mask;
                    end
                    temp = find(isnan(detector_mask)); detector_mask(temp)=0; %Convert Nan's to zeros
                    temp = sum(sum(pannel_struct.detector_data(:,:,o).*detector_mask));
                    disp(' ')
                    disp(['Total Detector[' num2str(detector_counter) '] Counts (Scattering) = ' num2str(temp)]);
                    disp(['Detector[' num2str(detector_counter) '] Count Rate (Scattering) = ' num2str(temp / inst_model_params.measurement_time,'%1.6g') ' (n/s)']);
                    

                    warning off
                    %***** Direct Beam Data *****
                    direct_beam = zeros(size(pannel_struct.detector_data(:,:,o)));
                    if length(inst_config.source_size) ==1; %i.e. circular source
                        temp = find(pannel_struct.qmatrix(:,:,9,o)<=inst_config.divergence_x_fwhm/2);
                        direct_beam(temp) = 1;
                    else %i.e. rectangular source
                        temp = find(pannel_struct.qmatrix(:,:,7,o)<=inst_config.divergence_x_fwhm/2 & pannel_struct.qmatrix(:,:,7,o)>=-inst_config.divergence_x_fwhm/2 & pannel_struct.qmatrix(:,:,8,o)<=inst_config.divergence_y_fwhm/2 & pannel_struct.qmatrix(:,:,8,o)>=-inst_config.divergence_y_fwhm/2);
                        direct_beam(temp) = 1;
                    end
                    temp =sum(sum(direct_beam));
                    direct_beam = I0* direct_beam / temp;
                    pannel_struct.detector_beam(:,:,o) = direct_beam;
                    
                    %Add poissonian noise to simulate real statistical noise
                    %Take sqrt counts as the error.  This should be +- this
                    %should be distributed +- about the point.  Then add a
                    %random error between -error to + error to the point
                    if inst_model_params.poissonian_noise_check ==1;
                        errors = sqrt(pannel_struct.detector_beam(:,:,o));
                        rand_matrix = rand(size(pannel_struct.detector_beam(:,:,o))); %between 0 and 1
                        rand_matrix = (rand_matrix -0.5)*2; %between -1 and 1
                        errors = errors .* rand_matrix;
                        pannel_struct.detector_beam(:,:,o) = (pannel_struct.detector_beam(:,:,o) + errors);
                    end

                    
                    temp = sum(sum(pannel_struct.detector_beam(:,:,o)));
                    disp(' ')
                    disp(['Total Detector[' num2str(detector_counter) '] Counts (Direct Beam) = ' num2str(temp)]);
                    disp(['Detector[' num2str(detector_counter) '] Count Rate (Direct Beam) = ' num2str(temp / inst_model_params.measurement_time,'%1.6g') ' (n/s)']);
                    disp(' ')
                    warning on 
                    
                    %Beam monitor parameter
                    inst_model_params.monitor(o) = inst_config.max_flux * 10e-6 * inst_model_params.measurement_time;
                end
                
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
        end
    end
    
    
    %***** Build Shadow Masks Based on qmatrix angles *****
    %Make empty shadow masks for all detectors
    for n = 1:length(inst_component)
        if findstr(inst_component(n).name,'Detector');
            for m = 1:inst_component(n).pannels
                pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                pannel_struct.parameters.shaddow_mask = ones(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1));
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
        end
    end
    %Loop though the detectors, find relative shadows & determine which detector is in front of another.
    wav_index = 1; %Doesn't matter what wavelenght goes in here as should not be using Q, only ANGLE
    for n = 1:length(inst_component)
        if findstr(inst_component(n).name,'Detector');
            for m = 1:inst_component(n).pannels
                pannel_struct1 = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry;
                
                %Loop though the rest of the detectors to compare shadows.
                for nn = n:length(inst_component)
                    for mm = 1:inst_component(nn).pannels
                        pannel_struct2 = getfield(inst_component(nn),['pannel' num2str(mm)]); %pannel_struct describes the pannel geometry
                        
                        %Only compare if pannels are different
                        if n ~= nn || m ~= mm
                            %Modify pannel order to compare pannel infront with pannel behind
                            pannel_1_position = inst_component(n).position + pannel_struct1.relative_position;
                            pannel_2_position = inst_component(nn).position + pannel_struct2.relative_position;
                            if pannel_1_position >= pannel_2_position
                                two_theta_y_min = min(min(pannel_struct2.qmatrix(:,:,8,wav_index)));
                                two_theta_y_max = max(max(pannel_struct2.qmatrix(:,:,8,wav_index)));
                                two_theta_x_min = min(min(pannel_struct2.qmatrix(:,:,7,wav_index)));
                                two_theta_x_max = max(max(pannel_struct2.qmatrix(:,:,7,wav_index)));
                                
                                temp = find(pannel_struct1.qmatrix(:,:,8,wav_index) >= two_theta_y_min & pannel_struct1.qmatrix(:,:,8,wav_index) <= two_theta_y_max & pannel_struct1.qmatrix(:,:,7,wav_index) <= two_theta_x_max & pannel_struct1.qmatrix(:,:,7,wav_index) >= two_theta_x_min);
                                pannel_struct1.parameters.shaddow_mask(temp) = NaN;
                                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct1); %Set the modified pannel struct back to the inst_component structure
                            elseif pannel_1_position < pannel_2_position
                                two_theta_y_min = min(min(pannel_struct1.qmatrix(:,:,8,wav_index)));
                                two_theta_y_max = max(max(pannel_struct1.qmatrix(:,:,8,wav_index)));
                                two_theta_x_min = min(min(pannel_struct1.qmatrix(:,:,7,wav_index)));
                                two_theta_x_max = max(max(pannel_struct1.qmatrix(:,:,7,wav_index)));
                                
                                temp = find(pannel_struct2.qmatrix(:,:,8,wav_index) >= two_theta_y_min & pannel_struct2.qmatrix(:,:,8,wav_index) <= two_theta_y_max & pannel_struct2.qmatrix(:,:,7,wav_index) <= two_theta_x_max & pannel_struct2.qmatrix(:,:,7,wav_index) >= two_theta_x_min);
                                pannel_struct2.parameters.shaddow_mask(temp) = NaN;
                                inst_component(nn) = setfield(inst_component(nn),['pannel' num2str(mm)], pannel_struct2); %Set the modified pannel struct back to the inst_component structure
                            end
                        end
                    end
                end
            end
        end
    end
    %***** Update the 2D Display *****
    sans_instrument_model_callbacks('plot_2D'); %refresh the 2D display
    
    %Calcualte curve hold and stagger properties
    if inst_model_params.hold_stagger_plots ==1 && inst_model_params.hold_images_check ==1;
        inst_model_params.hold_count = inst_model_params.hold_count +1;
    end
    stagger = 10^inst_model_params.hold_count/10;
    
    %***** Plot Q Boundaries *****
    q_max_store = 0; q_min_store = 999999;
    for n = 1:length(inst_component);
        if findstr(inst_component(n).name,'Detector') %Find detector component
            for m = 1:inst_component(n).pannels %Loop though detector pannels
                pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                
                %Determine q-max and q-min for each detector (at the shortest and longest wavelengths in tof mode)
                wav_min_index = 1; wav_max_index = length(tof_wavs);
                detector_mask = pannel_struct.parameters.beam_stop_mask .* pannel_struct.parameters.shaddow_mask;
                pannel_struct.qmax = max(max(pannel_struct.qmatrix(:,:,5,wav_min_index).*detector_mask));
                pannel_struct.qmin = min(min(pannel_struct.qmatrix(:,:,5,wav_max_index).*detector_mask));
                if pannel_struct.qmax > q_max_store; q_max_store = pannel_struct.qmax; end
                if pannel_struct.qmin < q_min_store; q_min_store = pannel_struct.qmin; end
                %Plot q boundaries
                xdat  = [pannel_struct.qmin,pannel_struct.qmax];
                ydat = [1,1]*inst_model_params.hold_count;
                if isfield(pannel_struct,'q_boundary_handle');
                    if inst_model_params.hold_images_check ==0;
                        if ishandle(pannel_struct.q_boundary_handle);
                            delete(pannel_struct.q_boundary_handle);
                            pannel_struct.q_boundary_handle = [];
                        end
                    end
                else
                    pannel_struct.q_boundary_handle = [];
                end
                hold(d33_handles.q_boundaries,'on');
                temp = plot(d33_handles.q_boundaries,xdat,ydat*inst_model_params.hold_count,'-x','color',pannel_struct.color./inst_model_params.hold_count);
                pannel_struct.q_boundary_handle = [pannel_struct.q_boundary_handle, temp];
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
        end
    end
    disp(['q-min = ' num2str(q_min_store) ' ansg-1,    q-max = ' num2str(q_max_store) ' angs-1,     dynamic q-range = ' num2str(round(q_max_store/q_min_store))]);
    disp(' ')
    disp(' ')
    disp(' ')
    
    %***** Plot 1D Re-binned IQ data *****
    for n = 1:length(inst_component);
        if findstr(inst_component(n).name,'Detector') %Find detector component
            for m = 1:inst_component(n).pannels %Loop though detector pannels
                pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                
                %Clear Old Plot if required
                if isfield(pannel_struct,'plot_1d_handle');
                    if inst_model_params.hold_images_check ==0;
                        if ishandle(pannel_struct.plot_1d_handle);
                            delete(pannel_struct.plot_1d_handle);
                            pannel_struct.plot_1d_handle = [];
                        end
                    end
                else
                    pannel_struct.plot_1d_handle = [];
                end
                
                for o = 1:length(tof_wavs);
                    %Extract and sort data
                    plot_data = [];
                    detector_mask = pannel_struct.parameters.beam_stop_mask .* pannel_struct.parameters.shaddow_mask;
                    plot_data(:,1)= reshape(pannel_struct.qmatrix(:,:,5,o).*detector_mask,numel(pannel_struct.qmatrix(:,:,5,o)),1);
                    plot_data(:,2)= reshape(pannel_struct.detector_data(:,:,o).*detector_mask, numel(pannel_struct.detector_data(:,:,o)),1);
                    plot_data = sortrows(plot_data);
                    
                    %Rebin data to sensible q-bins
                    plot_data(:,3) = sqrt(plot_data(:,2));
                    bin_edges = [min(plot_data(:,1)):(max(plot_data(:,1))-min(plot_data(:,1)))/100:max(plot_data(:,1))];
                    binned_det = d33_rebin(plot_data,bin_edges);
                    
                    %Plot
                    if not(isempty(binned_det)) %Check for empty data
                        hold(d33_handles.scatter_data,'on');
                        temp = errorbar(d33_handles.scatter_data,binned_det(:,1),binned_det(:,2)*stagger,binned_det(:,3)*stagger,'color',pannel_struct.color./inst_model_params.hold_count,'marker','.');
                        pannel_struct.plot_1d_handle = [pannel_struct.plot_1d_handle, temp];
                    end
                end
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
        end
    end
    
    
    %***** Plot Resolutions *****
    for n = 1:length(inst_component);
        if findstr(inst_component(n).name,'Detector')
            for m = 1:inst_component(n).pannels
                pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]); %pannel_struct describes the pannel geometry
                detector_mask = pannel_struct.parameters.beam_stop_mask .* pannel_struct.parameters.shaddow_mask;
                
                %Clear Old Plot if Required
                if isfield(pannel_struct,'plot_res_theta_handle');
                    if ishandle(pannel_struct.plot_res_theta_handle); delete(pannel_struct.plot_res_theta_handle); end
                else
                    pannel_struct.plot_res_theta_handle = [];
                end
                
                %Clear Old Plot if Required
                if isfield(pannel_struct,'plot_res_wav_theta_handle');
                    if ishandle(pannel_struct.plot_res_wav_theta_handle);
                        delete(pannel_struct.plot_res_wav_theta_handle);
                        pannel_struct.plot_res_wav_theta_handle = [];
                    end
                else
                    pannel_struct.plot_res_wav_theta_handle = [];
                end
                
                %Clear Old Plot if Required
                if isfield(pannel_struct,'plot_res_q_handle');
                    if ishandle(pannel_struct.plot_res_q_handle); delete(pannel_struct.plot_res_q_handle); end
                else
                    pannel_struct.plot_res_q_handle = [];
                end
                
                
                for o = 1:length(tof_wavs)
                    
                    %Wavelength Reoslution
                    if strcmp(inst_config.mono_tof,'Mono')
                        dlambda_lambda = inst_config.mono_dwav /100;
                    elseif strcmp(inst_config.mono_tof,'TOF')
                        dlambda_lambda = inst_config.chopper_resolution/100;
                    end
                    %Plot
                    hold(d33_handles.inst_resolution,'on');
                    temp = plot(d33_handles.inst_resolution,[q_min_store; q_max_store],[dlambda_lambda; dlambda_lambda],'-','color',inst_config.wav_color);
                    pannel_struct.plot_res_wav_theta_handle = [pannel_struct.plot_res_wav_theta_handle, temp];
                    
                    %Divergence Delta_theta / theta
                    dtheta_theta = [];
                    dtheta_theta(:,1)  = reshape((pannel_struct.qmatrix(:,:,5,o).*detector_mask),numel(pannel_struct.qmatrix(:,:,5,o).*detector_mask),1);
                    dtheta_theta(:,2) = inst_config.divergence_mean_fwhm ./ reshape((pannel_struct.qmatrix(:,:,9,o).*detector_mask),numel(pannel_struct.qmatrix(:,:,9,o).*detector_mask),1);
                    dtheta_theta = sortrows(dtheta_theta);
                    
                    %Plot
                    hold(d33_handles.inst_resolution,'on');
                    pannel_struct.plot_res_theta_handle = plot(d33_handles.inst_resolution,dtheta_theta(:,1),dtheta_theta(:,2),'-','color',pannel_struct.color);
                    pannel_struct.plot_res_theta_handle = [pannel_struct.plot_res_theta_handle,temp];
                    
                    %Overall resolution,  delta_q / q - Only display in Mono mode
                    if strcmp(inst_config.mono_tof,'Mono')
                        dqq = sqrt(dlambda_lambda.^2 + dtheta_theta(:,2).^2);
                        q = dtheta_theta(:,1);
                        
                        %Plot
                        hold(d33_handles.inst_resolution,'on');
                        pannel_struct.plot_res_q_handle = plot(d33_handles.inst_resolution,q,dqq,'y-');
                    end
                    
                end
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
        end
    end
    
    
    set(d33_handles.thinking,'visible','off');
    set(d33_handles.numor,'visible','off');
    
end

