function grasp_changer_gui_callbacks(todo,option)

if nargin <2; option = []; end

global grasp_handles
global grasp_env
global status_flags
global grasp_data
global inst_params
global displayimage

switch todo
    
    case 'auto_mask_check'
        status_flags.grasp_changer.auto_mask_check = not(status_flags.grasp_changer.auto_mask_check);
        update_grasp_changer
        grasp_update
        
        
    case 'iq_all'
        list_number = get(gcbo,'userdata');
        %'sample' is actually the list number, and not necessarily the depth number of the sample to average
        %find actually how many sample designations there were in the list before this one
        temp = find(ismember(status_flags.grasp_changer.designation(1:list_number),'sample'));
        temp2 = size(temp);
        depth = temp2(2); %This is the 'real' sample number
        for config = 1:status_flags.grasp_changer.number_configs
            grasp_changer_gui_callbacks('iq',[config, depth]);
        end
        
        
    case 'iq_config'
        config = get(gcbo,'userdata');
        %find how many real 'samples' are designated
        temp = find(ismember(status_flags.grasp_changer.designation,'sample'));
        temp2 = size(temp);
        last_sample = temp2(2);
        for depth = 1:last_sample
            grasp_changer_gui_callbacks('iq',[config, depth]);
        end
        
        
        
    case 'filldown_thickness'
        disp('filldown')
        %find how many real 'samples' are designated
        temp = find(ismember(status_flags.grasp_changer.designation,'sample'));
        temp2 = size(temp);
        last_sample = temp2(2);
        %Get the first sample thickness and copy it down
        index_samples = data_index(1); %Index to the samples worksheet
        thickness = grasp_data(index_samples).thickness{1}(1);
        
        grasp_data(index_samples).thickness{1}(1:last_sample) = thickness;
        grasp_update
        
        
        
    case 'enter_thickness'
        sample = get(gcbo,'userdata');
        thickness_str = get(gcbo,'string');
        thickness = str2num(thickness_str);
        if not(isempty(thickness))
            %'sample' is actually the list number, and not necessarily the depth number of the sample to average
            %find actually how many sample designations there were in the list before this one
            temp = find(ismember(status_flags.grasp_changer.designation(1:sample),'sample'));
            temp2 = size(temp);
            depth = temp2(2); %This is the 'real' sample number
            index_samples = data_index(1); %Index to the samples worksheet
            
            %Replace this thickness in all the Worksheets used by Grasp changer
            for wks = 1:status_flags.grasp_changer.number_configs
                grasp_data(index_samples).thickness{wks}(depth) = thickness;
            end
            grasp_update
        end
        
    case 'calibrate_check'
        status_flags.grasp_changer.calibrate_check = not(status_flags.grasp_changer.calibrate_check);
        update_grasp_changer
        grasp_update
        
    case 'clear_config_data'
        config = get(gcbo,'userdata');
        disp(['Clearing Configuration #' num2str(config) ' Data']);
        
        %***** Clear worksheet and depth *****
        wks_types = [1,2,3,4,5,6]; %i.e. Samples, Empty, Cd, SampleT, EmptyT, EB
        for wks = wks_types;
            index = data_index(wks);
            clear_wks_nmbr(index,config);
        end
        
        main_callbacks('update_worksheet'); %Update the selectors
        grasp_update
        
        
    case 'transmission_calc'
        %Can get here by two routes. Either the T (calculate transmissions
        %AND beam centre) or C (only calcualte beam centre)
        %This means that empty cell or empty beam has been allocated.
        
        config = get(gcbo,'userdata');
        CT_option = get(gcbo,'string');  %'C' or 'T'
        
        axis_lims = [1, inst_params.detector1.pixels, 1, inst_params.detector1.pixels]; %Just in case it doesn't get defined below
        
        %Calcualte Beam centre (all cases);
        if not(isempty(find(ismember(status_flags.grasp_changer.designation,'empty cell')))) && not(isempty(find(ismember(status_flags.grasp_changer.designation,'empty beam'))))
            
            %Auto-define Transmission & Beam Centre window.
            %Set to display empty beam worksheet
            %worksheet
            status_flags.command_window.display_params = 0; %turn off command window update
            status_flags.selector.fw = 6; %Set to display empty beam
            main_callbacks('update_worksheet');
            %number
            status_flags.selector.fn = config;
            main_callbacks('update_number'); %Done in a different routine so can be called from elsewhere
            
            %Beam Centre
            %Make a first guess of the beam centre based on centre of mass of the entire detector image
            cm_matrix = displayimage.data1;
            [cm] = centre_of_mass(cm_matrix,[1 inst_params.detector1.pixels(1) 1 inst_params.detector1.pixels(2)]);
            
            %Now zoom tight over beam centre
            beam_window = inst_params.guide_size.* 2./(inst_params.detector1.pixel_size*1e-3); %50% larger than beam - this is approx what the beamstop is
            axis_lims = [cm.cm(1) - beam_window(1)/2, cm.cm(1) + beam_window(1)/2, cm.cm(2) - beam_window(2)/2, cm.cm(2)+beam_window(2)/2];
            axis_lims = round(axis_lims);
            status_flags.grasp_changer = setfield(status_flags.grasp_changer,['transmission_window' num2str(config)], axis_lims);
            
            %Just check that these limits are still within the detector
            temp = find(axis_lims<1); if not(isempty(temp)); axis_lims(temp) =1; end
            temp = find(axis_lims(1:2)>inst_params.detector1.pixels(1)); if not(isempty(temp)); axis_lims(temp) = inst_params.detector1.pixels(1); end
            temp = find(axis_lims(3:4)>inst_params.detector1.pixels(2)); if not(isempty(temp)); axis_lims(temp) = inst_params.detector1.pixels(2); end
            tool_callbacks('poke_scale',axis_lims);
            
            %             %Create Auto Mask based on this beamstop size
            %             if status_flags.grasp_changer.auto_mask_check ==1;
            %                 mask_index = data_index(7); %Sample masks
            %                 data(mask_index).data{config}(axis_lims(3):axis_lims(4),axis_lims(1):axis_lims(2)) = 0;
            %             end
            
            
            
            
            %Now re-calculate beam centre
            main_callbacks('cm_calc');
            
            if strcmp(CT_option,'T');
                %Empty Cell transmission
                %worksheet
                status_flags.selector.fw = 5; %Set to display empty cell transmission
                main_callbacks('update_worksheet');
                %number
                status_flags.selector.fn = config;
                main_callbacks('update_number'); %Done in a different routine so can be called from elsewhere
                %'Press' the Trans Calc Button
                main_callbacks('transmission_calc')
            end
        end
        
        %Sample Transmissions - require sample & empty cell designations
        if strcmp(CT_option,'T')
            
            if not(isempty(find(ismember(status_flags.grasp_changer.designation,'sample')))) && not(isempty(find(ismember(status_flags.grasp_changer.designation,'empty cell'))))
                tool_callbacks('poke_scale',axis_lims);
                %worksheet
                status_flags.selector.fw = 4; %Set to display sample transmissions
                main_callbacks('update_worksheet');
                %number
                status_flags.selector.fn = config;
                main_callbacks('update_number'); %Done in a different routine so can be called from elsewhere
                %'Press' the Trans Calc Button
                main_callbacks('transmission_calc')
            end
            status_flags.command_window.display_params = 1; %turn on command window update
            
            %Return to grasp_changer window
            figure(grasp_handles.grasp_changer.window);
        end
        
        
    case 'configure_grasp_changer_from_classic_grasp'
        
        %find the largest number of filled depths in worksheet numbers 1:configs
        index = 1; %Sample scattering worksheets
        configs = status_flags.grasp_changer.number_configs;
        temp = [];
        for n = 1:configs; temp = [temp, grasp_data(index).dpth{n}]; end
        [max_samples, max_config] = max(temp);
        
        status_flags.grasp_changer.number_samples = 0;
        %If Background & cadmium subtract are ticked then allocate space for them in grasp_changer first
        if status_flags.selector.b_check == 1;
            status_flags.grasp_changer.number_samples = status_flags.grasp_changer.number_samples +1;
            status_flags.grasp_changer.designation{status_flags.grasp_changer.number_samples} = 'empty cell';
        end
        
        if status_flags.selector.c_check == 1;
            status_flags.grasp_changer.number_samples = status_flags.grasp_changer.number_samples +1;
            status_flags.grasp_changer.designation{status_flags.grasp_changer.number_samples} = 'cadmium';
            status_flags.grasp_changer.number_samples = status_flags.grasp_changer.number_samples +1;
            status_flags.grasp_changer.designation{status_flags.grasp_changer.number_samples} = 'empty beam';
        end
        
        %Check if the I0 beam has data, if so, allocate space in Grasp Changer
        index= data_index(8);
        temp = sum(sum(sum(grasp_data(index).data1{1})));
        if temp ~=0;
            status_flags.grasp_changer.number_samples = status_flags.grasp_changer.number_samples +1;
            status_flags.grasp_changer.designation{status_flags.grasp_changer.number_samples} = 'i0 beam';
        end
        
        %Update the number of samples boxes to be availaible in grasp_changer
        %Auto allocate the designation based upon the conventional Grasp worksheets
        for sample = 1:max_samples;
            status_flags.grasp_changer.number_samples = status_flags.grasp_changer.number_samples +1;
            status_flags.grasp_changer.designation{status_flags.grasp_changer.number_samples} = 'sample';
        end
        
        %Lock the transmissions to the correct configuration
        status_flags.transmission.ts_number = status_flags.grasp_changer.transmission_config;
        status_flags.transmission.te_number = status_flags.grasp_changer.transmission_config;
        status_flags.transmission.ts_lock = 1;
        status_flags.transmission.te_lock = 1;
        
        
        
        
    case 'load_numor'
        userdata = get(gcbo,'userdata');
        config = userdata(2); start_sample = userdata(1);
        load_string = get(gcbo,'string');
        
        %***** Do a pre_parse and build the load strings for sample, empty cell, cadmium etc. *****
        %find how many numors to load
        open_bracket = findstr(load_string,'{'); close_bracket = findstr(load_string,'}');
        if not(isempty(open_bracket));
            first_numor = str2num(load_string(1:open_bracket-1));
            if isempty(first_numor); return; end
            number_samples_str = load_string(open_bracket+1:close_bracket-1);
            number_samples = str2num(number_samples_str);
            if isempty(number_samples); return; end
        else
            number_samples = 1; %default
            first_numor = str2num(load_string);
            if isempty(first_numor); return; end
        end
        
        %Don't use the usual Data Load ('data_read') rountine
        %The load string for grasp_changer should be much less complicated than the usual grasp load strings so
        %Load individual numors and poke directly into the correct memory address.
        
        sample = start_sample;
        numor_counter = 1;
        while numor_counter <=number_samples;
            depth = 0; worksheet = [];
            
            %Check multiple sample load does not exceed allocated grasp changer # samples
            if sample <= length(status_flags.grasp_changer.designation);
            
            %Now work out where to put it
            if strcmp(option,'scattering');
                if strcmp(status_flags.grasp_changer.designation{sample},'sample')
                    worksheet = 1;
                    %Need to count up where this lies in the conventional Grasp worksheet depth
                    %i.e. how many 'samples' are before this one
                    for n = 1:sample-1;
                        if strcmp(status_flags.grasp_changer.designation{n},'sample'); depth = depth +1; end
                    end
                elseif strcmp(status_flags.grasp_changer.designation{sample},'empty cell')
                    worksheet = 2;
                elseif strcmp(status_flags.grasp_changer.designation{sample},'cadmium')
                    worksheet = 3;
                end
                
            elseif strcmp(option,'transmission');
                if strcmp(status_flags.grasp_changer.designation{sample},'sample')
                    worksheet = 4;
                    %Need to count up where this lies in the conventional Grasp worksheet depth
                    %i.e. how many 'samples' are before this one
                    for n = 1:sample-1
                        if strcmp(status_flags.grasp_changer.designation{n},'sample'); depth = depth +1; end
                    end
                elseif strcmp(status_flags.grasp_changer.designation{sample},'empty cell')
                    worksheet = 5;
                elseif strcmp(status_flags.grasp_changer.designation{sample},'empty beam')
                    worksheet = 6;
                elseif strcmp(status_flags.grasp_changer.designation{sample},'i0 beam')
                    worksheet = 8;
                end
            end
            
            else break; %Jump out of the while loop if insuficient number of Grasp changer samples
                
            end
            
            
            
            %Check for special cases, e.g. 0 - clear worksheet depth instead
            if first_numor ==0;
                depth = depth +1;
                %Withdraw the current worksheet contents & discard
                junk_data = withdraw_data_depth(worksheet,config,depth);
                %replace with an empty worksheet
                %I have chosen not to leave the worsheet collapsed as this
                %would upset the current changer table.
                
                insert_data = [];
                
                for det = 1:inst_params.detectors
                    insert_data.(['data' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
                    insert_data.(['error' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
                    insert_data.(['params' num2str(det)]) = zeros(128,1);
                end
                insert_data.thickness = 0.1;
                insert_data.subtitle = 'Empty Space';
                insert_data.load_string = ['<Numors>'];
                insert_data.info.start_date = ['**-**-**']; %Start Date
                insert_data.info.start_time = ['**-**-**']; %Start Time
                insert_data.info.end_date = ['**-**-**']; %End Date
                insert_data.info.end_time = ['**-**-**']; %End Time
                insert_data.info.user = [' ']; %User Name
                
                insert_data_depth(worksheet,config,depth,insert_data);
               
                main_callbacks('update_worksheet'); %Update the selectors
                grasp_update
                
                return
            end
            
            
            
            %Read & Place data file if found somewhere to put it
            if not(isempty(worksheet));
                depth = depth +1;
                %Read the data from file
                numor = first_numor + (numor_counter-1);
                disp(['Loading Numor #' num2str(numor) ' into worksheet ' num2str(worksheet) ', number ' num2str(config) ', depth ' num2str(depth)]);
                
                
                
                
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
                fn_string = [inst_params.filename.data_loader '(file_name_path)'];
                numor_data = eval(fn_string);
                numor_data.load_string = num2str(numor);
                if not(isfield(numor_data,'n_frames')); numor_data.n_frames = 1; end
                
                %Clear Previous Depth Contents
                clear_wks_nmbr_dpth(worksheet,config,depth);
                %APPEND DATA into storage array - i.e., ADD new loaded contents to previous contents
                place_data(numor_data, worksheet, config, depth);
                
                
                %                 [numor_data, numor_params, numor_parsub,data_info,error_data] = get_numor(grasp_env.path.data_dir,numor);
                %                 %Place data in correct worksheet and depth
                %                 place_data(worksheet,config,depth,numor_data,numor_params,numor_parsub,num2str(numor),data_info,error_data);
                numor_counter = numor_counter +1;
            end
            sample = sample+1;
        end
        main_callbacks('update_worksheet'); %Update the selectors
        grasp_update
        
        %             %Auto Calculate Beam Centre
        %             main_callbacks('cm_calc')
        
        
    case 'close'
        grasp_handles.grasp_changer.window = [];
        
        
    case 'iq'
        if isempty(option);
            %Get the sample and config number
            temp = get(gcbo,'userdata');
            sample_list_number = temp(1); config = temp(2);
            
            %'sample' is actually the list number, and not necessarily the depth number of the sample to average
            %find actually how many sample designations there were in the list before this one
            temp = find(ismember(status_flags.grasp_changer.designation(1:sample_list_number),'sample'));
            temp2 = size(temp); depth = temp2(2);
        else
            config = option(1);
            depth = option(2);
        end
        
        %Rescale the main Grasp display just to be prety
        axis_lims = [1,inst_params.detector1.pixels(1),1,inst_params.detector1.pixels(1)];
        tool_callbacks('poke_scale',axis_lims);
        
        
        %worksheet
        status_flags.command_window.display_params = 0; %turn off command window update
        status_flags.selector.fw = 1; %Set to display samples
        main_callbacks('update_worksheet');
        
        %Index to data storage arrays for samples worksheet.
        index = data_index(status_flags.selector.fw);
        
        
        %Check if current config and depth are valid
        if depth <= grasp_data(index).dpth{config};
            
            %number
            status_flags.selector.fn = config;
            main_callbacks('update_number'); %Done in a different routine so can be called from elsewhere
            
            status_flags.selector.fd = depth + grasp_data(index).sum_allow;
            status_flags.command_window.display_params = 1; %turn on command window update
            main_callbacks('update_depths');
            
            transmission_window = getfield(status_flags.grasp_changer,['transmission_window' num2str(config)]);
            %Prepare Temporary AutoMask based on beamstop size
            if status_flags.grasp_changer.auto_mask_check ==1 && not(isempty(transmission_window));
                disp('Auto masking data for Grasp Changer')
                mask_index = data_index(7); %Sample masks
                main_grasp_mask = grasp_data(mask_index).data1{config};
                grasp_data(mask_index).data1{config}(transmission_window(3):transmission_window(4),transmission_window(1):transmission_window(2)) = 0;
                status_flags.command_window.display_params = 0;
                grasp_update
            end
            
            radial_average_callbacks('radial_q','on');
            
            %Put old Grasp mask back
            if status_flags.grasp_changer.auto_mask_check ==1 && not(isempty(transmission_window));
                grasp_data(mask_index).data{config} = main_grasp_mask;
                grasp_update
                status_flags.command_window.display_params = 1;
            end
            
        end
        
        %return to the grasp changer window
        figure(grasp_handles.grasp_changer.window)
        
        
    case 'transmission_config'
        config = get(gcbo,'userdata');
        status_flags.grasp_changer.transmission_config = config;
        update_grasp_changer;
        %Flip Grasp Main to these transmission values and lock.
        status_flags.transmission.ts_number = config;
        status_flags.transmission.te_number = config;
        status_flags.transmission.ts_lock = 1;
        status_flags.transmission.te_lock = 1;
        grasp_update;
        
        
        
    case 'designation_change'
        
        %Get the current designation and data for this sample
        sample = get(gcbo,'userdata'); %sample list number
        previous_designation = status_flags.grasp_changer.designation{sample};
        new_designation = option;
        
        %Check previous and new designation are not the same, otherwise do nothing
        if strcmp(previous_designation, new_designation); return
        else
            %Loop through the configurations
            for config = 1:status_flags.grasp_changer.number_configs
                
                %Find indicies to the source (old) and destination worksheets (new)
                %Index to source source worksheet
                depth_old = 1; scatter_index_old =[]; trans_index_old = []; %Unless over-written below
                if strcmp(previous_designation,'sample'); %Then find which depth this corresponds to
                    %if sample>1;
                    temp = find(ismember(status_flags.grasp_changer.designation(1:sample),'sample'));
                    temp2 = size(temp); depth_old = temp2(2);
                    %end
                    scatter_index_old = data_index(1); trans_index_old = data_index(4);
                elseif strcmp(previous_designation,'empty cell'); scatter_index_old = data_index(2); trans_index_old = data_index(5);
                elseif strcmp(previous_designation,'cadmium'); scatter_index_old =data_index(3);
                elseif strcmp(previous_designation,'empty beam'); trans_index_old = data_index(6);
                elseif strcmp(previous_designation,'i0 beam'); trans_index_old = data_index(8);
                end
                
                %Index to destination worksheet
                depth_new = 1; trans_index_new = []; scatter_index_new =[]; %Unless over-written below
                if strcmp(new_designation,'sample'); %Then find which depth this corresponds to
                    %if sample>1;
                    temp = find(ismember(status_flags.grasp_changer.designation(1:sample),'sample'));
                    temp2 = size(temp); depth_new = temp2(2)+1;
                    %end
                    scatter_index_new = data_index(1); trans_index_new = data_index(4);
                elseif strcmp(new_designation,'empty cell'); scatter_index_new = data_index(2); trans_index_new = data_index(5);
                elseif strcmp(new_designation,'cadmium'); scatter_index_new =data_index(3);
                elseif strcmp(new_designation,'empty beam'); trans_index_new = data_index(6);
                elseif strcmp(new_designation,'i0 beam'); trans_index_new = data_index(8);
                end
                
                
                
                %If there can only be file in the destination (e.g. Empty Beam, I0 Beam, Cadmium,
                %Empty Cell, then withdraw the previous contents and ask what to do with it.
                if strcmp(new_designation,'empty beam') || strcmp(new_designation,'i0 beam') || strcmp(new_designation,'cadmium') ||  strcmp(new_designation,'empty cell');
                    
                    %Check there was already a previous designation of this type
                    temp = find(ismember(status_flags.grasp_changer.designation,new_designation));
                    if not(isempty(temp))
                        
                        %Ask what to do with the previous contents (only ask for the first config then do the same for the rest)
                        if config ==1;
                            %Get the scattering and transmission numor to display in dialog before actually withdrawing it from the array
                            if isempty(scatter_index_new)
                                scatter_str = 'N/A';
                            else
                                scatter_str = num2str(grasp_data(scatter_index_new).params1{config}(128));
                            end
                            if isempty(trans_index_new)
                                trans_str = 'N/A';
                            else
                                trans_str =  num2str(grasp_data(trans_index_new).params1{config}(128));
                            end
                            button =  questdlg(['This operation will over-write the previous worksheet of type:  ' new_designation char(10)....
                                'Scattering:  #' scatter_str '   Transmission:  #' trans_str],....
                                'What to do with previous designation data?','Discard','Store as Sample','Cancel','Discard');
                        end
                        if strcmp(button,'Discard'); %Do nothing and throw away previous data
                        elseif strcmp(button,'Store as Sample')
                            %see below
                        elseif strcmp(button,'Cancel') || isempty(button)
                            return
                        end
                        
                        %Withdraw data from Destination Worksheet
                        %Scattering
                        if not(isempty(scatter_index_new));
                            if not(isempty(scatter_index_new));
                                scattering_destination_data = withdraw_data_depth(scatter_index_new,config,depth_new);
                            end
                        else
                            scattering_destination_data = create_empty_worksheet_depth;
                        end
                        %Transmission
                        if not(isempty(trans_index_new));
                            if not(isempty(trans_index_new));
                                transmission_destination_data = withdraw_data_depth(trans_index_new,config,depth_new);
                            end
                        else
                            transmission_destination_data = create_empty_worksheet_depth;
                        end
                        
                        
                        if strcmp(button,'Store as Sample');
                            if config ==1; %only do this the first loop around
                                status_flags.grasp_changer.number_samples = status_flags.grasp_changer.number_samples +1;
                                status_flags.grasp_changer.designation{status_flags.grasp_changer.number_samples} = 'sample';
                                %Find actual number of real samples in the samples list
                                temp = find(ismember(status_flags.grasp_changer.designation,'sample'));
                                temp2 = size(temp); last_sample_depth = temp2(2);
                            end
                            
                            %Put the previous destination data back in the samples worksheet
                            %Scattering
                            if not(isempty(scatter_index_old))
                                insert_data_depth(1,config,last_sample_depth,scattering_destination_data)
                            end
                            %Transmission
                            if not(isempty(trans_index_old))
                                insert_data_depth(4,config,last_sample_depth,transmission_destination_data)
                            end
                        end
                    end
                end
                
                
                
                %Withdraw data from Source Worksheet
                %Scattering
                if not(isempty(scatter_index_old));
                    if not(isempty(scatter_index_old));
                        scattering_source_data = withdraw_data_depth(scatter_index_old,config,depth_old);
                    end
                else
                    scattering_source_data = create_empty_worksheet_depth;
                end
                %Transmission
                if not(isempty(trans_index_old));
                    if not(isempty(trans_index_old));
                        transmission_source_data = withdraw_data_depth(trans_index_old,config,depth_old);
                    end
                else
                    transmission_source_data = create_empty_worksheet_depth;
                end
                
                %Now swap the data arround
                %Put the source data into the destination worksheet
                %Scattering
                if not(isempty(scatter_index_new))
                    insert_data_depth(scatter_index_new,config,depth_new,scattering_source_data)
                end
                %Transmission
                if not(isempty(trans_index_new))
                    insert_data_depth(trans_index_new,config,depth_new,transmission_source_data)
                end
            end
            
            %Sort out the designation list
            %Find the previous designation of this type to remove
            if strcmp(new_designation,'empty beam') || strcmp(new_designation,'i0 beam') || strcmp(new_designation,'cadmium') ||  strcmp(new_designation,'empty cell');
                temp = find(ismember(status_flags.grasp_changer.designation,new_designation));
                if not(isempty(temp))
                    status_flags.grasp_changer.designation{temp} = 'not defined';
                end
            end
            status_flags.grasp_changer.designation{sample} = new_designation;
            
            %Finally, OPTIONAL, remove the 'not defined' cells
            temp = not(ismember(status_flags.grasp_changer.designation,'not defined'));
            status_flags.grasp_changer.designation = status_flags.grasp_changer.designation(temp);
            status_flags.grasp_changer.number_samples = length(status_flags.grasp_changer.designation);
            
        end
        
        grasp_changer_gui_callbacks('build_boxes');
        update_grasp_changer
        main_callbacks('update_worksheet'); %Update the selectors
        grasp_update
        
        
        
        
    case 'number_samples'
        if isempty(option)
            temp = str2num(get(gcbo,'string'));
            if not(isempty(temp))
                if temp>=1 && temp <=26;
                    status_flags.grasp_changer.number_samples = round(temp);
                end
            end
        else status_flags.grasp_changer.number_samples = option;
            
        end
        grasp_changer_gui_callbacks('build_boxes');
        update_grasp_changer
        
        
    case 'build_boxes'
        %Builds the full Grasp Changer list of samples, transmission boxes etc.
        
        %Delete previous boxes, designations etc before re-build
        for config = 1:status_flags.grasp_changer.number_configs
            %Delete Scattering boxes
            if isfield(grasp_handles.grasp_changer,['config' num2str(config) '_scatter']);
                handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_scatter']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer =setfield(grasp_handles.grasp_changer,['config' num2str(config) '_scatter'],[]);
            end
            %Delete Transmission boxes
            if isfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans']);
                handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans'],[]);
            end
            %Delete Sample Number
            if isfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_number']);
                handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_number']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_number'],[]);
            end
            %Delete Designation
            if isfield(grasp_handles.grasp_changer,['config' num2str(config) '_designation']);
                handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_designation']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_designation'],[]);
            end
            %Delete IQ button
            if isfield(grasp_handles.grasp_changer,['config' num2str(config) '_iq']);
                handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_iq']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_iq'],[]);
            end
            %Delete ALL IQ button
            if isfield(grasp_handles.grasp_changer,['all_iq']);
                handles = getfield(grasp_handles.grasp_changer,['all_iq']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['all_iq'],[]);
            end
            %Delete CONFIG IQ button
            if isfield(grasp_handles.grasp_changer,['config_iq']);
                handles = getfield(grasp_handles.grasp_changer,['config_iq']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config_iq'],[]);
            end
            %Delete previous designations
            if status_flags.grasp_changer.number_samples<= length(status_flags.grasp_changer.designation);
                status_flags.grasp_changer.designation = status_flags.grasp_changer.designation(1:status_flags.grasp_changer.number_samples);
            end
            %Delete previous transmission values
            if isfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans_value_handle']);
                handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans_value_handle']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans_value_handle'],[]);
            end
            %Delete previous thicknesses
            if isfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_thickness']);
                handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_thickness']);
                if ishandle(handles); delete(handles); end
                grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_thickness'],[]);
            end
        end
        
        iq_config_handle = [];
        for config = 1:status_flags.grasp_changer.number_configs
            x0=0.015; dx = 0.23; Dx = (config-1)*dx;
            
            %Build Scattering Boxes
            y0 = 0.82; dy = -0.03;
            
            %Declare some empty handles
            sample_number_handle = []; sample_thickness_handle = []; designation_handle = [];
            scatter_handle = []; trans_handle = []; trans_value_handle = [];
            iq_handle = []; iq_all_handle = [];
            
            for n = 1:status_flags.grasp_changer.number_samples
                if config ==1;
                    %Sample Number
                    handle = uicontrol(grasp_handles.grasp_changer.window,'tag','changer_sample_number','units','normalized','Position',[x0+0.00+Dx y0+n*dy-0.01 0.03 0.025],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String',num2str(n),'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
                    sample_number_handle = [sample_number_handle, handle];
                    
                    %Sample Thickness
                    handle = uicontrol(grasp_handles.grasp_changer.window,'tag','changer_sample_thickness','units','normalized','Position',[x0+0.040+Dx y0+n*dy 0.02 0.02],'FontName',grasp_env.font,'FontWeight','normal','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','edit','String','N/A','userdata',n,'callback','grasp_changer_gui_callbacks(''enter_thickness'')');
                    sample_thickness_handle = [sample_thickness_handle,handle];
                    
                    %Designation
                    grasp_handles.grasp_changer.designation_context_root = uicontextmenu;
                    if n <= length(status_flags.grasp_changer.designation);
                        designation_string = status_flags.grasp_changer.designation{n};
                    else
                        designation_string = 'sample';
                        status_flags.grasp_changer.designation{n} = designation_string;
                    end
                    handle = uicontrol(grasp_handles.grasp_changer.window,'tag','changer_designation','units','normalized','Position',[x0+0.25+Dx y0+n*dy 0.06 0.025],'FontName',grasp_env.font,'FontWeight','normal','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',designation_string,'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]*0.7,'uicontextmenu',grasp_handles.grasp_changer.designation_context_root);
                    designation_handle = [designation_handle,handle];
                    uimenu(grasp_handles.grasp_changer.designation_context_root,'userdata',n,'label','Sample','callback','grasp_changer_gui_callbacks(''designation_change'',''sample'')');
                    uimenu(grasp_handles.grasp_changer.designation_context_root,'userdata',n,'label','Empty Cell','callback','grasp_changer_gui_callbacks(''designation_change'',''empty cell'')');
                    uimenu(grasp_handles.grasp_changer.designation_context_root,'userdata',n,'label','Cadmium','callback','grasp_changer_gui_callbacks(''designation_change'',''cadmium'')');
                    uimenu(grasp_handles.grasp_changer.designation_context_root,'userdata',n,'label','Empty beam','callback','grasp_changer_gui_callbacks(''designation_change'',''empty beam'')');
                    uimenu(grasp_handles.grasp_changer.designation_context_root,'userdata',n,'label','I0 Beam Intensity','callback','grasp_changer_gui_callbacks(''designation_change'',''i0 beam'')');
                end
                
                %Scattering numor
                handle = uicontrol(grasp_handles.grasp_changer.window,'tag','changer_sample_box','units','normalized','Position',[x0+0.1+Dx y0+n*dy 0.05 0.02],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','edit','String','','userdata',[n, config],'callback','grasp_changer_gui_callbacks(''load_numor'',''scattering'');');
                scatter_handle = [scatter_handle, handle];
                
                %Transmission numor
                handle = uicontrol(grasp_handles.grasp_changer.window,'tag','changer_sample_trans','units','normalized','Position',[x0+0.16+Dx y0+n*dy 0.05 0.02],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','edit','String','','userdata',[n,config],'callback','grasp_changer_gui_callbacks(''load_numor'',''transmission'');');
                trans_handle = [trans_handle, handle];
                
                %Transmission Value
                handle = uicontrol(grasp_handles.grasp_changer.window,'tag','transmission_value','units','normalized','Position',[x0+0.215+Dx y0+n*dy 0.025 0.025],'FontName',grasp_env.font,'FontWeight','normal','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','xx','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
                trans_value_handle = [trans_value_handle, handle];
                
                %IQ
                if strcmp(status_flags.grasp_changer.designation{n},'sample');
                    visible_status = 'on';
                else
                    visible_status = 'off';
                end
                handle = uicontrol(grasp_handles.grasp_changer.window,'units','normalized','Position',[x0+0.085+Dx y0+n*dy+0.005 0.012 0.015],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','pushbutton','string', 'IQ','userdata',[n,config],'callback','grasp_changer_gui_callbacks(''iq'')','enable',visible_status);
                iq_handle = [iq_handle, handle];
                
                %All IQ
                if config == status_flags.grasp_changer.number_configs; %last config
                    handle = uicontrol(grasp_handles.grasp_changer.window,'units','normalized','Position',[x0+0.25+Dx y0+n*dy+0.005 0.04 0.015],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','pushbutton','string', ['#' num2str(n) '  IQ'],'userdata',n,'callback','grasp_changer_gui_callbacks(''iq_all'')');
                    iq_all_handle = [iq_all_handle, handle];
                end
                
                %Config IQ
                if n == status_flags.grasp_changer.number_samples; %Last sample
                    handle = uicontrol(grasp_handles.grasp_changer.window,'units','normalized','Position',[x0+0.085+Dx y0+n*dy+0.005+dy 0.04 0.015],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','pushbutton','string', ['Cnfg ' num2str(config) '  IQ'],'userdata',config,'callback','grasp_changer_gui_callbacks(''iq_config'')');
                    iq_config_handle = [iq_config_handle, handle];
                end
            end
            
            %Build the stored handle structures
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_designation'],designation_handle);
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_number'],sample_number_handle);
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_thickness'],sample_thickness_handle);
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_scatter'],scatter_handle);
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans'],trans_handle);
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_iq'],iq_handle);
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['all_iq'],iq_all_handle);
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config_iq'],iq_config_handle);
            grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans_value_handle'],trans_value_handle);
        end
end
