function main_callbacks(to_do,option)

global status_flags
global grasp_handles
global grasp_data
global displayimage
global inst_params
global grasp_env

%1 = foreground, background
%2 = det_efficiency
%3 = masks
%4 = direct
%5 = trans
%6 = waters
%7 = water transmissions
%8 = water direct beam
%9 = calbration mask

% Worksheet types -used to decide what to display in menus etc.
% 1 = sample scattering
% 2 = sample background
% 3 = sample cadmium
% 4 = sample transmission
% 5 = sample empty transmission
% 6 = sample empty beam transmission
% 7 = sample mask
% 101 = calibration scattering
% 102 = calibration background
% 103 = calibration cadmium
% 104 = calibration transmission
% 105 = calibration empty transmission
% 106 = calibration empty beam transmission
% 107 = calibration mask
% 99 = detector efficiency map


switch to_do
    case 'averaging_display_refresh'
        if strcmp(status_flags.analysis_modules.radial_average.display_update,'off');
            status_flags.analysis_modules.radial_average.display_update = 'on';
        else
            status_flags.analysis_modules.radial_average.display_update = 'off';
        end
        set(grasp_handles.menu.file.preferences.averaging_depth_update,'checked',status_flags.analysis_modules.radial_average.display_update);
        
        
    case 'sectors_display_refresh'
        if strcmp(status_flags.analysis_modules.sector_boxes.display_refresh,'off');
            status_flags.analysis_modules.sector_boxes.display_refresh = 'on';
        else
            status_flags.analysis_modules.sector_boxes.display_refresh = 'off';
        end
        set(grasp_handles.menu.file.preferences.sector_box_update,'checked',status_flags.analysis_modules.sector_boxes.display_refresh);
        
    case 'boxes_display_refresh'
        if strcmp(status_flags.analysis_modules.boxes.display_refresh,'off');
            status_flags.analysis_modules.boxes.display_refresh = 'on';
        else
            status_flags.analysis_modules.boxes.display_refresh = 'off';
        end
        set(grasp_handles.menu.file.preferences.box_update,'checked',status_flags.analysis_modules.boxes.display_refresh);
        
        
    case 'depth_min'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp)); status_flags.selector.depth_range_min = temp; end
        
    case 'depth_max'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp)); status_flags.selector.depth_range_max = temp; end
            
    case 'depth_range_chk'
        status_flags.selector.depth_range_chk = get(gcbo,'value');
        hide_stuff;
        
    case 'raw_tube_data_load'
        status_flags.fname_extension.raw_tube_data_load = get(gcbo,'value');
        status_flags.calibration.soft_det_cal = 0;
        hide_stuff;
    
    case 'pa_correct'
        status_flags.calibration.pa_chk = get(gcbo,'value');
        grasp_update;
      
    case 'detector_on'
        det = get(gcbo,'userdata');
        disp(['Switching Detector ' num2str(det) ' ON']);
        status_flags.display.(['axis' num2str(det) '_onoff']) = 1;
        grasp_update;
        
    case 'detector_off'
        det = get(gcbo,'userdata');
        disp(['Switching Detector ' num2str(det) ' OFF']);
        status_flags.display.(['axis' num2str(det) '_onoff']) = 0;
        grasp_update;
        
    case 'all_panels_on'
        for det = 2:inst_params.detectors
            disp(['Switching Detector ' num2str(det) ' ON']);
            status_flags.display.(['axis' num2str(det) '_onoff']) = 1;
        end
        grasp_update;
        
    case 'all_panels_off'
        for det = 2:inst_params.detectors
            disp(['Switching Detector ' num2str(det) ' OFF']);
            status_flags.display.(['axis' num2str(det) '_onoff']) = 0;
        end
        grasp_update;
        
        
    case 'active_axis'
        status_flags.display.active_axis = option;
        %Set the active axis color indicator
        for det = 1:inst_params.detectors
            if det == status_flags.display.active_axis;
                box_color = grasp_env.displayimage.active_axis_color;
                %Bring active axis to foreground
                children = get(grasp_handles.figure.grasp_main,'children');
                active_axis = grasp_handles.displayimage.(['axis' num2str(det)]);
                temp = find(children == active_axis);
                children(temp) = [];
                children = [active_axis; children];
                set(grasp_handles.figure.grasp_main,'children',children);
                
            else
                box_color = grasp_env.displayimage.inactive_axis_color;
            end
            
            if status_flags.display.axis_box == 1; box_status = 'on'; else  box_status = 'off'; end
            set(grasp_handles.displayimage.(['axis' num2str(det)]),'box',box_status,'xcolor',box_color,'ycolor',box_color,'zcolor',box_color);
            %axis titles
            if isfield(grasp_handles.displayimage,['axis_xtitle' num2str(det)]);
                if ishandle(grasp_handles.displayimage.(['axis_xtitle' num2str(det)]))
                    set(grasp_handles.displayimage.(['axis_xtitle' num2str(det)]),'color',box_color);
                end
            end
            if isfield(grasp_handles.displayimage,['axis_ytitle' num2str(det)]);
                if ishandle(grasp_handles.displayimage.(['axis_ytitle' num2str(det)]))
                    set(grasp_handles.displayimage.(['axis_ytitle' num2str(det)]),'color',box_color);
                end
            end
        end
        
        %Update anything that might change simply with a change of active axis
        %displayed beam centre
        update_beam_centre
        update_window_options
        

    case 'foreground_wks'
        %update status flags with selector position
        selector_position = get(gcbo,'value');
        userdata = get(gcbo,'userdata');
        status_flags.selector.fw = userdata(selector_position);
        if status_flags.selector.fw ==4 || status_flags.selector.fw ==5 || status_flags.selector.fw ==6 || status_flags.selector.fw == 8; %transmission worksheets.
            main_callbacks('active_axis',1); %Reset active axis to the main detector to avoid accidental beam centres on D33 panels.
        end
        main_callbacks('update_worksheet');
        
        
    case 'update_worksheet'
        
        %Reset the depth back to 1
        status_flags.selector.fd = 1;
        status_flags.selector.bd = 1;
        status_flags.selector.cd = 1;
        %Reset the transmission depth back to 1
        status_flags.transmission.ts_depth = 1;
        status_flags.transmission.te_depth = 1;

        %Rebuild background & cadmium selector
        selector_build

        %selector_build_values('fore');
        selector_build_values; %all

        %Hide certain selectors, buttons etc.
        grasp_update


    case 'background_wks'
        %update status flags with selector position
        selector_position = get(gcbo,'value');
        userdata = get(gcbo,'userdata');
        status_flags.selector.bw = userdata(selector_position);

        %Modify last_displayed data
        index = data_index(status_flags.selector.fw);
        grasp_data(index).last_displayed(1) = status_flags.selector.bw;

        %Rebuild background & cadmium selector
        selector_build
        %selector_build_values('back');
        selector_build_values; %all
        grasp_update


    case 'cadmium_wks'
        %update status flags with selector position
        selector_position = get(gcbo,'value');
        userdata = get(gcbo,'userdata');
        status_flags.selector.cw = userdata(selector_position);

        %Modify last_displayed data
        index = data_index(status_flags.selector.fw);
        grasp_data(index).last_displayed(2) = status_flags.selector.cw;

        %Rebuild background & cadmium selector
        selector_build
        %selector_build_values('cadmium');
        selector_build_values; %all
        grasp_update

    case 'wks_group'
        status_flags.selector.ngroup = get(gcbo,'value');
        if status_flags.selector.ngroup == 0;
            status_flags.transmission.ts_lock = 0;
            status_flags.transmission.te_lock = 0;
            status_flags.beamcentre.cm_lock = 0;
        end
        main_callbacks('update_number'); %Done in a different routine so can be called from elsewhere

        
    case 'dpth_group'
        status_flags.selector.dgroup = get(gcbo,'value');
        %Set all depths to equal that of the foreground (if possible);
        main_callbacks('update_depths'); %Done in a different routine so can be called from elsewhere
        
        
    case 'foreground_nmbr'
        status_flags.selector.fn = get(grasp_handles.figure.fore_nmbr,'value');
        main_callbacks('update_number'); %Done in a different routine so can be called from elsewhere

        
    case 'update_number'

        %Check if selector numbers are grouped
        if status_flags.selector.ngroup == 1;
            status_flags.selector.bn = status_flags.selector.fn;
            status_flags.selector.cn = status_flags.selector.fn;
            if status_flags.transmission.ts_lock == 0; status_flags.transmission.ts_number = status_flags.selector.fn; end
            if status_flags.transmission.te_lock == 0; status_flags.transmission.te_number = status_flags.selector.fn; end
            if status_flags.beamcentre.cm_lock == 0; status_flags.beamcentre.cm_number = status_flags.selector.fn; end
            status_flags.display.mask.number = status_flags.selector.fn;
        end

        %Reset the depth back to 1
        status_flags.selector.fd = 1;
        status_flags.selector.bd = 1;
        status_flags.selector.cd = 1;
        %Reset the transmission depth back to 1
        status_flags.transmission.ts_depth = 1;
        status_flags.transmission.te_depth = 1;
        
        %selector_build_values('fore');
        selector_build_values; %all
        
        grasp_update
        
    case 'foreground_dpth'
        status_flags.selector.fd = get(grasp_handles.figure.fore_dpth,'value');
        main_callbacks('update_depths'); %Done in a different routine so can be called from elsewhere
        
        
    case 'update_depths'
        %Check if selector depths are grouped
        if status_flags.selector.dgroup == 1;

            %Check if sufficient background depths exist
            if status_flags.selector.fd <= status_flags.selector.bdpth_max;
                status_flags.selector.bd = status_flags.selector.fd;
            end

            %Check if sufficient cadmium depths exist
            if status_flags.selector.fd <= status_flags.selector.cdpth_max;
                status_flags.selector.cd = status_flags.selector.fd;
            end

            %Check if sufficient transmission depths exist
            if status_flags.selector.fw >= 1 && status_flags.selector.fw <= 6;
                %Foreground, Background, Cadmium, Transmission & Empty beam types
                ts_worksheet = 4; te_worksheet = 5;
            elseif status_flags.selector.fw >= 101 && status_flags.selector.fw <= 106
                %Water & Water transmission types
                ts_worksheet = 104; te_worksheet = 105;
            elseif status_flags.selector.fw >= 10 && status_flags.selector.fw <= 19; %PA Worksheets
                ts_worksheet = 5; te_worksheet = 5;
            else
                ts_worksheet = 4; te_worksheet = 5;
            end

            %Update Transmission Depth
            nmbr = status_flags.transmission.ts_number;
            
            index = data_index(ts_worksheet);
            ts_dpth = size(grasp_data(index).trans{nmbr},1);
            sum_allow = grasp_data(index).sum_allow;
            if status_flags.selector.fd <= (ts_dpth +sum_allow)
                status_flags.transmission.ts_depth = status_flags.selector.fd;
            end
            
            index = data_index(te_worksheet);
            te_dpth = size(grasp_data(index).trans{nmbr},1);
            sum_allow = grasp_data(index).sum_allow;
            if status_flags.selector.fd <= (te_dpth + sum_allow)
                status_flags.transmission.te_depth = status_flags.selector.fd;
            end
            
            %Update Beam Centre Depth
            index = data_index(1); %Beam centres are stored with the scattering data
            cm_dpth = size(grasp_data(index).cm1{nmbr}.cm_pixels,1);
            sum_allow = grasp_data(index).sum_allow;
            if status_flags.selector.fd <= (cm_dpth + sum_allow);
                status_flags.beamcentre.cm_depth = status_flags.selector.fd;
            end
        end
        grasp_update
        
        
    case 'background_nmbr'
        if status_flags.selector.ngroup ~=1;
            %Should only be able to get here if the selector numbers are NOT grouped
            %therefore don't modify any of the other selector positions
            status_flags.selector.bn = get(grasp_handles.figure.back_nmbr,'value');

            %Reset the depth back to 1
            status_flags.selector.fd = 1;
            status_flags.selector.bd = 1;
            status_flags.selector.cd = 1;
            %Reset the transmission depth back to 1
            status_flags.transmission.ts_depth = 1;
            status_flags.transmission.te_depth = 1;

            %selector_build_values('fore');
            selector_build_values; %all
        end
        grasp_update

    case 'background_dpth'
        %Should only be able to get here if the selector depths are NOT grouped
        %therefore don't modify any of the other selector positions
        status_flags.selector.bd = get(grasp_handles.figure.back_dpth,'value');
        grasp_update


    case 'cadmium_nmbr'
        if status_flags.selector.ngroup ~=1;
            %Should only be able to get here if the selector numbers are NOT grouped
            %therefore don't modify any of the other selector positions
            status_flags.selector.cn = get(grasp_handles.figure.cad_nmbr,'value');

            %Reset the depth back to 1
            status_flags.selector.fd = 1;
            status_flags.selector.bd = 1;
            status_flags.selector.cd = 1;
            %Reset the transmission depth back to 1
            status_flags.transmission.ts_depth = 1;
            status_flags.transmission.te_depth = 1;

            %selector_build_values('fore');
            selector_build_values; %all
        end
        grasp_update

    case 'cadmium_dpth'
        %Should only be able to get here if the selector depths are NOT grouped
        %therefore don't modify any of the other selector positions
        status_flags.selector.cd = get(grasp_handles.figure.cad_dpth,'value');
        grasp_update
        
        
    case 'subtract_check'
        status_flags.selector.b_check = not(status_flags.selector.b_check);
        grasp_update

    case 'cadmium_check'
        status_flags.selector.c_check = not(status_flags.selector.c_check);
        grasp_update

    case 'data_read'
        data_read;
        selector_build_values('fore');
        grasp_update;
        
    case 'numor_plus'
        numor_str = get(grasp_handles.figure.data_load,'string');
        numor = str2num(numor_str);
        l = size(numor);
        if not(isempty(numor)) & l(2) ==1; %i.e. only do it if it was a single numor
            numor_str = num2str(numor+option);
            set(grasp_handles.figure.data_load,'string',numor_str);
            main_callbacks('data_read');
        elseif l(2) ~=1;
            disp(' ');
            disp('The ''+'' and ''-'' buttons only work...');
            disp('...with a single numor in the load field ...obviously!');
            disp(' ');
        end
        
    case 'data_read_on_enter'
        if strcmp(get(grasp_handles.figure.grasp_main,'currentcharacter'),char(13));
            main_callbacks('data_read'); %Executes the reading routines detailed below
        end
        
    case 'log'
        status_flags.display.log = not(status_flags.display.log);
        grasp_update
        
    case 'ts_number'
        if status_flags.selector.ngroup ~=1;
            status_flags.transmission.ts_number = get(gcbo,'value'); %only allow to change if not grouped
        end
        grasp_update;
        
    case 'te_number'
        if status_flags.selector.ngroup ~=1;
            status_flags.transmission.te_number = get(gcbo,'value'); %only allow to change if not grouped
        end
        grasp_update;
        
        
    case 'transmission_calc'
        
        det = status_flags.display.active_axis; %Current active detector
        
        %***** Get current axis coordinates *****
        axis_limits  = current_axis_limits;
        axis_lims = axis_limits.(['det' num2str(status_flags.display.active_axis)]).pixels; %x,y
        axis_lims = round(axis_lims); %for indexing the data array
        
        %Determine if there are a depth of transmissions to do
        index = data_index(status_flags.selector.fw); %index to data array
        sum_allow = grasp_data(index).sum_allow;
        nmbr = status_flags.selector.fn; %worksheet number
        foreground_depth = status_flags.selector.fdpth_max - sum_allow;
        background_depth = status_flags.selector.bdpth_max - sum_allow;
        
        %***** Scroll though transmission depth *****
        for depth = 1:foreground_depth
            status_flags.selector.fd = depth + sum_allow;
            main_callbacks('depth_scroll'); %Scroll all linked depths and update
            
            %***** Get Data as Indicated by the selectors *****
            %Note: This has to be done from the raw data here: can't use 'get_selector_result'
            
            %***** Get transmission data (NUMERATOR) *****
            transimage = retrieve_data('fore'); %foreground data, and flag - determines if data is 'data' or masks etc.
            transimage = normalize_data(transimage);
            
            %***** Get direct beam data (DENOMINATOR) *****
            directimage = retrieve_data('back'); %foreground data, and flag - determines if data is 'data' or masks etc.
            directimage = normalize_data(directimage);
            
            %***** Calculate Transmission *****
            disp(['Calculating transmission:  Window:  X: ' num2str(axis_lims(1:2)) '   Y: ' num2str(axis_lims(3:4))]);
            t = sum(sum(transimage.(['data' num2str(det)])(axis_lims(3):axis_lims(4),axis_lims(1):axis_lims(2))));
            t_err = sqrt(sum(sum(transimage.(['error' num2str(det)])(axis_lims(3):axis_lims(4),axis_lims(1):axis_lims(2)).^2)));
            d = sum(sum(directimage.(['data' num2str(det)])(axis_lims(3):axis_lims(4),axis_lims(1):axis_lims(2))));
            d_err = sqrt(sum(sum(directimage.(['error' num2str(det)])(axis_lims(3):axis_lims(4),axis_lims(1):axis_lims(2)).^2)));
            [trans,err_trans] = err_divide(t,t_err,d,d_err);
            percent_error = (err_trans/trans)*100;
            disp(['Transmission:  ' num2str(trans) ' +- ' num2str(err_trans) '  (' num2str(percent_error) '%)']);
            
            
            %***** Find where to poke the calculated transmission value *****
            %Transmissions live with the transmission worksheets
            %Poke Transmission back into Transmission array
            
            grasp_data(index).trans{nmbr}(depth,:) = [trans, err_trans];
            
        end
        
        %update grasp
        grasp_update
        

    case 'ts'
        trans_str = get(grasp_handles.figure.trans_ts,'string');
        ts = str2num(trans_str);
        err_ts = 0;  %Because value entered manually, err_ts = 0
        if isempty(ts); ts = 1; end %Error check on non numeric input

        %Poke Transmission back into Transmission array
        index = data_index(4); %Worksheet index
        sum_allow = grasp_data(index).sum_allow;
        depth = status_flags.selector.fd-sum_allow; %Worksheet depth
        nmbr = status_flags.selector.fn; %worksheet number
        
        if depth ==0; %If sum, the replace all transmissions though depth
            for d = 1:status_flags.selector.fdpth_max
                grasp_data(index).trans{nmbr}(d,:) = [ts, err_ts];
            end
        else
            grasp_data(index).trans{nmbr}(depth,:) = [ts, err_ts];
        end
        grasp_update

    case 'te'
        trans_str = get(grasp_handles.figure.trans_te,'string');
        te = str2num(trans_str);
        err_te = 0;  %Because value entered manually, err_te = 0
        if isempty(te); te = 1; end %Error check on non numeric input

        %Poke Transmission back into Transmission array
        index = data_index(5); %Worksheet index
        sum_allow = grasp_data(index).sum_allow;
        depth = status_flags.selector.fd-sum_allow; %Worksheet depth
        nmbr = status_flags.selector.fn; %worksheet number
        
        if depth ==0;
            for d = 1:status_flags.selector.fdpth_max
                grasp_data(index).trans{nmbr}(d,:) = [te, err_te];
            end
        else
            grasp_data(index).trans{nmbr}(depth,:) = [te, err_te];
        end
        grasp_update

    case 'ts_lock'
        status_flags.transmission.ts_lock = not(status_flags.transmission.ts_lock);
        %If unlocking, set Ts values to something valid
        if status_flags.transmission.ts_lock ==0;
            status_flags.transmission.ts_number = status_flags.selector.fn;
            status_flags.transmission.ts_depth = 1;
        end
        grasp_update

    case 'te_lock'
        status_flags.transmission.te_lock = not(status_flags.transmission.te_lock);
        %If unlocking, set Te values to something valid
        if status_flags.transmission.te_lock == 0;
            status_flags.transmission.te_number = status_flags.selector.fn;
            status_flags.transmission.te_depth = 1;
        end
        grasp_update
        
    case 'sample_thickness'
        thickness_str = get(grasp_handles.figure.thickness,'string');
        thickness = str2num(thickness_str);
        if isempty(thickness); thickness = 0.1; end %Error check on non numeric input

        %Poke Thickness back into array - Sample Thickness lives with the
        %samples worksheet
        index = data_index(1); %Samples worksheet index
        number = status_flags.selector.fn; %worksheet number
        depth = status_flags.selector.fd;
        depth = depth-grasp_data(index).sum_allow;
        
        if depth > grasp_data(index).dpth{number}; depth = 1; end %Check that there are enough cm depths in the foreground worksheet
        
        %Correct depths for SUM worksheets
        if depth ==0; %i.e. sum, then replace thickness in all depths
            for d = 1:status_flags.selector.fdpth_max
                grasp_data(index).thickness{number}(d) = thickness;
            end
        else
            grasp_data(index).thickness{number}(depth) = thickness;
        end
        
        grasp_update

    case 'grouped_z_check'
        status_flags.display.grouped_z_scale = get(gcbo,'value');
        if status_flags.display.grouped_z_scale == 0; %Also set the manual z-check off
            status_flags.display.manualz.check = 0;
            set(grasp_handles.figure.manualz_chk,'value',status_flags.display.grouped_z_scale);
        end
        set(grasp_handles.figure.grouped_z_chk,'value',status_flags.display.grouped_z_scale);
        grasp_update;
        
    case 'manual_z_check'
        status_flags.display.manualz.check = get(gcbo,'value');
        if status_flags.display.manualz.check ==1;
            %Also set the grouped z-scale check on
            status_flags.display.grouped_z_scale = 1;
            set(grasp_handles.figure.grouped_z_chk,'value',status_flags.display.grouped_z_scale);
            
            %Calcualte new manual limits based on current max and min
            status_flags.display.manualz.min = inf; status_flags.display.manualz.max = -inf;
            for det = 1:inst_params.detectors
                if status_flags.display.z_max.(['det' num2str(det)]) > status_flags.display.manualz.max; status_flags.display.manualz.max = status_flags.display.z_max.(['det' num2str(det)]); end
                if status_flags.display.z_min.(['det' num2str(det)]) < status_flags.display.manualz.min; status_flags.display.manualz.min = status_flags.display.z_min.(['det' num2str(det)]); end
            end
        end
        grasp_update
        
    case 'zmin'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.display.manualz.min = temp;
        end
        grasp_update
        
    case 'zmax'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.display.manualz.max = temp;
        end
        grasp_update

    case 'image'
        status_flags.display.image = not(status_flags.display.image);
        grasp_update;

    case 'contour'
        status_flags.display.contour = not(status_flags.display.contour);
        grasp_update

    case 'smooth'
        status_flags.display.smooth.check = not(status_flags.display.smooth.check);
        grasp_update;
        
    case 'cm_lock'
        status_flags.beamcentre.cm_lock = not(status_flags.beamcentre.cm_lock);
        if status_flags.beamcentre.cm_lock ==0; status_flags.beamcentre.cm_number = status_flags.selector.fn; end
        grasp_update;
        
    case 'cm_x'
        cx = str2num(get(gcbo,'string')); %New x-coordinate entered manually.
        if isempty(cx); cx = inst_params.det_size(1)/2; end %in case rubbish is entered into edit box

        %Poke the new value into the cm store
        %Find the pointers and type of the current displayed worksheet
        number = status_flags.beamcentre.cm_number;
        depth = status_flags.beamcentre.cm_depth;
        index = data_index(1); %Beam centres are stored with the sample scattering worksheet
        %Current active axis
        det = status_flags.display.active_axis;
        depth = depth-grasp_data(index).sum_allow;
        %Correct depths for SUM worksheets
        if depth > grasp_data(index).dpth{number}; depth = 1; end %Check that there are enough cm depths in the foreground worksheet
        if depth ==0; %If Sum the replace all beam centres though depth
            depth =1;
%             for d = 1:status_flags.selector.fdpth_max
%                 %check if filling down depths - if previously didn't exist
%                 %then need a corresponding cy to set.
%                 grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels
%                 asdasd
%                 
%                 grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels(d,1) = cx;
%             end
%         else
        end
                    grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels(depth,1) = cx;

        grasp_update
        
    case 'cm_y'
        cy = str2num(get(gcbo,'string')); %New x-coordinate entered manually.
        if isempty(cy); cy = inst_params.det_size(2)/2; end %in case rubbish is entered into edit box
        
        %Poke the new value into the cm store
        %Find the pointers and type of the current displayed worksheet
        number = status_flags.beamcentre.cm_number;
        depth = status_flags.beamcentre.cm_depth;
        index = data_index(1); %Beam centres are stored with the sample scattering worksheet
        %Current active axis
        det = status_flags.display.active_axis;
        %Correct depths for SUM worksheets
        depth = depth-grasp_data(index).sum_allow;
        if depth > grasp_data(index).dpth{number}; depth = 1; end %Check that there are enough cm depths in the foreground worksheet
        if depth ==0;  %If Sum the replace all beam centres though depth
%             for d = 1:status_flags.selector.fdpth_max
%                 %check if filling down depths - if previously didn't exist
%                 %then need a corresponding cy to set.
%                 grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels(d,2) = cy;
%             end
%         else
depth = 1;
        end
                    grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels(depth,2) = cy;

        grasp_update
        
    case 'cm_poke'
        %Poke the new value into the cm store
        %Find the pointers and type of the current displayed worksheet
        number = status_flags.beamcentre.cm_number;
        depth = status_flags.beamcentre.cm_depth;
        index = data_index(1); %Beam centres are stored with the sample scattering worksheet
        %Correct depths for SUM worksheets
        depth = depth-grasp_data(index).sum_allow;
        
        if depth > grasp_data(index).dpth{number}; depth = 1; end %Check that there are enough cm depths in the foreground worksheet
        if depth ==0; depth = 1; end %incase the worksheet was already on 'sum'
        
        %Current active axis
        det = status_flags.display.active_axis;
        grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels(depth,1) = option.cx;
        grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels(depth,2) = option.cy;
        grasp_update
        
        
%     case 'cm_theta'
%         ctheta = str2num(get(gcbo,'string')); %New x-coordinate entered manually.
%         if isempty(ctheta); ctheta = 0; end %in case rubbish is entered into edit box
%         cm = current_beam_centre('ctheta',ctheta);
%         grasp_update

    case 'cm_calc'
        %Current active detector
        det = status_flags.display.active_axis;
        
        %***** Get current axis coordinates *****
        axis_limits  = current_axis_limits;
        axis_lims = axis_limits.(['det' num2str(status_flags.display.active_axis)]).pixels; %x,y
        axis_lims = round(axis_lims); %for indexing the data array

        %Determine if there are a depth of beam centres to do
        index = data_index(1); %Beam centres are stored with the sample scattering worksheet
        number = status_flags.beamcentre.cm_number;
        sum_allow = grasp_data(index).sum_allow;
        depth_max = status_flags.selector.fdpth_max - sum_allow;
        
        %Clear All Previous Beam Centres
        grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels = [0 0];
        grasp_data(index).(['cm' num2str(det)]){number}.cm_translation = [0 0];
        %grasp_data(index).(['cm' num2str(det)]){number}.cm_sigma_pixels = [0 0];
        grasp_data(index).(['cm' num2str(det)]){number}.x_kernel_x = [];
        grasp_data(index).(['cm' num2str(det)]){number}.x_kernel_weight = [];
        grasp_data(index).(['cm' num2str(det)]){number}.y_kernel_y = [];
        grasp_data(index).(['cm' num2str(det)]){number}.y_kernel_weight = [];
        

        %Check what foreground worksheet is displayed:
        %if transmissions & beams then do beamcentre depth
        %otherwise just do single beam centre of what's displayed
        
        if displayimage.type ==4 || displayimage.type == 5 || displayimage.type == 6 || displayimage.type == 8;
            grasp_data(index).(['cm' num2str(det)]){number}.x_kernel_q = [];
            grasp_data(index).(['cm' num2str(det)]){number}.y_kernel_q = [];
            grasp_data(index).(['cm' num2str(det)]){number}.x_kernel_x = [];
            grasp_data(index).(['cm' num2str(det)]){number}.y_kernel_y = [];
            grasp_data(index).(['cm' num2str(det)]){number}.x_kernel_weight = [];
            grasp_data(index).(['cm' num2str(det)]){number}.y_kernel_weight = [];
            
            %***** Scroll though depth and calculate beam centre *****
            for depth = 1:depth_max
                
                status_flags.selector.fd = depth + sum_allow;
                main_callbacks('depth_scroll'); %Scroll all linked depths and update
                
                %Retrieve the data to do the centre of mass
                cm_matrix = displayimage.(['data' num2str(det)])(axis_lims(3):axis_lims(4),axis_lims(1):axis_lims(2));
                
                %Calculate centre of mass of the matrix array
                cm = centre_of_mass(cm_matrix,[axis_lims]);
                disp(['Depth: ' num2str(depth)]);
                disp(['Centre of Mass:  Cx = ' num2str(cm.cm(1)) ' , Cy = ' num2str(cm.cm(2))]);
                %disp(['Sigma (Beam Width):  Sigma_x = ' num2str(cm.sigma_pixels(1)) ' , Sigma_y = ' num2str(cm.sigma_pixels(2))]);
                
                %Poke cm back into storage
                grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels(depth,:) = cm.cm;
                
                %Also need to store any detector pannel translation information if it exists
                cm_params = displayimage.(['params' num2str(status_flags.display.active_axis)]);
                 
                if strcmp(grasp_env.inst,'ILL_d33')
                    if strcmp(grasp_env.inst_option,'D33_Model_Data')
                        ox = cm_params(inst_params.vectors.ox);
                        oy = cm_params(inst_params.vectors.oy);
                    elseif strcmp(grasp_env.inst_option,'D33');
                          %det = 1 ;  Rear
                          %det = 2 ;  Right
                          %det = 3 ;  Left
                          %det = 4 ;  Bottom
                          %det = 5 ;  Top
                          if det == 1;
                              ox = 0; oy = 0;
                          elseif det == 2;
                              ox = cm_params(inst_params.vectors.oxr);
                              oy = 0;
                          elseif det == 3;
                              ox = cm_params(inst_params.vectors.oxl);
                              oy = 0;
                          elseif det == 4;
                              ox = 0;
                              oy = cm_params(inst_params.vectors.oyb);
                          elseif det == 5;
                              ox = 0;
                              oy = cm_params(inst_params.vectors.oyt);
                          end
                    elseif strcmp(grasp_env.inst_option,'D33_Instrument_Commissioning')
                        ox = inst_params.(['detector' num2str(status_flags.display.active_axis)]).nominal_det_translation(1);
                        oy = inst_params.(['detector' num2str(status_flags.display.active_axis)]).nominal_det_translation(2);
                    end
                else
                    ox = inst_params.(['detector' num2str(status_flags.display.active_axis)]).nominal_det_translation(1);
                    oy = inst_params.(['detector' num2str(status_flags.display.active_axis)]).nominal_det_translation(2);
                end
                
                grasp_data(index).(['cm' num2str(det)]){number}.cm_translation(depth,:) = [ox, oy];
                disp(['Panel Translations:  Ox = ' num2str(ox) ' , Oy = ' num2str(oy)]);
                
                %Only store the cm sigma widths if it was done for a proper direct
                %beam or transmission worksheet - that way the resolution doesn't
                %get screwed if simply take the CM of the foreground scattering as
                %a rough centre of mass
                %grasp_data(index).(['cm' num2str(det)]){number}.cm_sigma_pixels(depth,:) = cm.sigma_pixels;
                
                %Store the direct beam NORMALIZED kernel shape for resolution use after
                sdet = cm_params(inst_params.vectors.det); %Default, unless otherwise
                if strcmp(status_flags.q.det,'detcalc');
                    if isfield(inst_params.vectors,'detcalc')
                        if not(isempty(inst_params.vectors.detcalc));
                            sdet = cm_params(inst_params.vectors.detcalc);
                        end
                    end
                end
                lambda = cm_params(inst_params.vectors.wav);
                pixelsize = 1e-3*inst_params.(['detector' num2str(det)]).pixel_size;
                
                temp_x = find(isfinite(cm.x_kernel_x)); %Clip to only points zoomed in on
                temp_y = find(isfinite(cm.y_kernel_y)); %Clip to only points zoomed in on
                
                two_theta_x = atan(cm.x_kernel_x(temp_x) .*pixelsize(1) ./sdet);
                grasp_data(index).(['cm' num2str(det)]){number}.x_kernel_q(depth,:) = (4*pi/lambda).*sin(two_theta_x/2);
                two_theta_y = atan(cm.y_kernel_y(temp_y) .*pixelsize(2) ./sdet);
                grasp_data(index).(['cm' num2str(det)]){number}.y_kernel_q(depth,:) = (4*pi/lambda).*sin(two_theta_y/2);
                grasp_data(index).(['cm' num2str(det)]){number}.x_kernel_x(depth,:) = cm.x_kernel_x(temp_x);
                grasp_data(index).(['cm' num2str(det)]){number}.x_kernel_weight(depth,:) = cm.x_kernel_weight(temp_x);
                grasp_data(index).(['cm' num2str(det)]){number}.y_kernel_y(depth,:) = cm.y_kernel_y(temp_y);
                grasp_data(index).(['cm' num2str(det)]){number}.y_kernel_weight(depth,:) = cm.y_kernel_weight(temp_y);
            end
            
        else
            
            %Retrieve the data to do the centre of mass
            cm_matrix = displayimage.(['data' num2str(det)])(axis_lims(3):axis_lims(4),axis_lims(1):axis_lims(2));

            %Calculate centre of mass of the matrix array
            cm = centre_of_mass(cm_matrix,[axis_lims]);
            
            disp(['Centre of Mass:  Cx = ' num2str(cm.cm(1)) ' , Cy = ' num2str(cm.cm(2))]);
            %disp(['Sigma (Beam Width):  Sigma_x = ' num2str(cm.sigma_pixels(1)) ' , Sigma_y = ' num2str(cm.sigma_pixels(2))]);
            
            %Poke cm back into storage
            grasp_data(index).(['cm' num2str(det)]){number}.cm_pixels(1,:) = cm.cm;
            
                %Also need to store any detector pannel translation information if it exists
                cm_params = displayimage.(['params' num2str(status_flags.display.active_axis)]);
                 
                if strcmp(grasp_env.inst,'ILL_d33')
                    if strcmp(grasp_env.inst_option,'D33_Model_Data')
                        ox = cm_params(inst_params.vectors.ox);
                        oy = cm_params(inst_params.vectors.oy);
                    elseif strcmp(grasp_env.inst_option,'D33');
                          %det = 1 ;  Rear
                          %det = 2 ;  Right
                          %det = 3 ;  Left
                          %det = 4 ;  Bottom
                          %det = 5 ;  Top
                          if det == 1;
                              ox = 0; oy = 0;
                          elseif det == 2;
                              ox = cm_params(inst_params.vectors.oxr);
                              oy = 0;
                          elseif det == 3;
                              ox = cm_params(inst_params.vectors.oxl);
                              oy = 0;
                          elseif det == 4;
                              ox = 0;
                              oy = cm_params(inst_params.vectors.oyb);
                          elseif det == 5;
                              ox = 0;
                              oy = cm_params(inst_params.vectors.oyt);
                          end
                    elseif strcmp(grasp_env.inst_option,'D33_Instrument_Commissioning');
                        ox = 0; oy = 0;
                    end
                else
                    ox = inst_params.(['detector' num2str(status_flags.display.active_axis)]).nominal_det_translation(1);
                    oy = inst_params.(['detector' num2str(status_flags.display.active_axis)]).nominal_det_translation(2);
                end
            grasp_data(index).(['cm' num2str(det)]){number}.cm_translation(1,:) = [ox, oy];
            disp(['Panel Translations:  Ox = ' num2str(ox) ' , Oy = ' num2str(oy)]);

            
            
            %delete any sigma widths if cm wasn't done for proper beam worksheet
            %if isfield(grasp_data(index).(['cm' num2str(det)]){number},'cm_sigma_pixels')
            %    grasp_data(index).(['cm' num2str(det)]){number} = rmfield(grasp_data(index).(['cm' num2str(det)]){number},'cm_sigma_pixels');
            %end
        end
        grasp_update;
        

    case 'cm_number'
        if status_flags.selector.ngroup ~=1;
            status_flags.beamcentre.cm_number = get(gcbo,'value');
        end
        grasp_update;

    case 'mask_check'
        status_flags.display.mask.check = not(status_flags.display.mask.check);
        grasp_update;
        
    case 'mask_number'
        if status_flags.selector.ngroup ~=1;
            status_flags.display.mask.number = get(gcbo,'value');
        end
        grasp_update;

    case 'soft_det_cal_check'
        status_flags.calibration.soft_det_cal = get(gcbo,'value');
        grasp_update

    case 'rotate'
        status_flags.display.rotate.check = not(status_flags.display.rotate.check);
        grasp_update

    case 'rotate_angle'
        status_flags.display.rotate.angle = str2num(get(grasp_handles.figure.rotate_angle,'string'));
        if isempty(status_flags.display.rotate.angle); status_flags.display.rotate.angle =0; end
        grasp_update

    case 'depth_scroll'
        
        main_callbacks('update_depths');
      
%         %Check if selector depths are grouped
%         if status_flags.selector.dgroup == 1;
% 
%             %Check if sufficient depths exist
%             if status_flags.selector.fd <= status_flags.selector.bdpth_max;
%                 status_flags.selector.bd = status_flags.selector.fd;
%             end
% 
%             %Check if sufficient depths exist
%             if status_flags.selector.fd <= status_flags.selector.cdpth_max;
%                 status_flags.selector.cd = status_flags.selector.fd;
%             end
% 
%             %Check if sufficient depths exist
%             if status_flags.selector.fw >= 1 && status_flags.selector.fw <=8;
%                 %Foreground, Background, Cadmium, Transmission & Empty beam types
%                 ts_worksheet = 4; te_worksheet = 5;
%             elseif status_flags.selector.fw >= 101 && status_flags.selector.fw == 107
%                 %Water & Water transmission types
%                 ts_worksheet = 104; te_worksheet = 105;
%             elseif status_flags.selector.fw >= 10 && status_flags.selector.fw <= 19; %PA FR Check
%                 ts_worksheet = 4; te_worksheet = 5;
%             else
%                 ts_worksheet = 4; te_worksheet = 5;
%             end
% 
%             nmbr = status_flags.selector.fn;
% 
%             index = data_index(ts_worksheet);
%             ts_dpth = size(grasp_data(index).trans{nmbr},1);
%             sum_allow = grasp_data(index).sum_allow;
%             if status_flags.selector.fd <= (ts_dpth +sum_allow)
%                 status_flags.transmission.ts_depth = status_flags.selector.fd;
%             end
%             
%             index = data_index(te_worksheet);
%             te_dpth = size(grasp_data(index).trans{nmbr},1);
%             sum_allow = grasp_data(index).sum_allow;
%             if status_flags.selector.fd <= (te_dpth + sum_allow)
%                 status_flags.transmission.te_depth = status_flags.selector.fd;
%             end
%             
%             %Update Beam Centre Depth
%             index = data_index(1); %Beam centres are stored with the scattering data
%             cm_dpth = size(grasp_data(index).cm1{nmbr}.cm_pixels,1);
%             sum_allow = grasp_data(index).sum_allow;
%             if status_flags.selector.fd <= (cm_dpth + sum_allow);
%                 status_flags.beamcentre.cm_depth = status_flags.selector.fd;
%             end
%         end
%         
%         status_flags.transmission.ts_depth
%         
%         grasp_update
%         
%         pause(0.5)
%         
%         %pause(0.1)
        
    case 'calibrate_check'
        status_flags.calibration.calibrate_check = not(status_flags.calibration.calibrate_check);
        if status_flags.calibration.calibrate_check == 1;
            calibration_window;
        end
        grasp_update

    case 'fname_extension'
        status_flags.fname_extension.extension = get(gcbo,'string');
        
    case 'fname_shortname'
        status_flags.fname_extension.shortname = get(gcbo,'string');
        
            


       
        
        


end

