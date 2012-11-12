function sector_box_callbacks(to_do)

if nargin<1; to_do = ''; end

global status_flags
global grasp_handles
global displayimage
global grasp_data
global inst_params

global box_intensities

switch to_do
    
    case 'r1'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)]);
            coords(1) = temp;
            status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)],coords);
        end
        
    case 'r2'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)]);
            coords(2) = temp;
            status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)],coords);
        end
        
        
    case 'theta'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)]);
            coords(3) = temp;
            status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)],coords);
        end
        
        
    case 'delta_theta'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)]);
            coords(4) = temp;
            status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)],coords);
        end
        
    case 'gamma'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)]);
            coords(5) = temp;
            status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)],coords);
        end
        
    case 'gamma_angle'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)]);
            coords(6) = temp;
            status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)],coords);
        end
        
    case 'clear_box'
        box = get(gcbo,'userdata');
        coords = [1,1,1,1,1,0]; %Empty box coordinates
        status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)],coords);
        
    case 'clear_all'
        for box = 1:6
            coords = [1,1,1,1,1,0]; %Empty box coordinates
            status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)],coords);
        end
        
    case 'parameter'
        temp = str2num(get(grasp_handles.window_modules.sector_box.parameter,'string'));
        if not(isempty(temp));
            if temp >= 0 && temp <=128;
                status_flags.analysis_modules.sector_boxes.parameter = temp;
            end
        end
        
    case 'box_color'
        color_string = get(grasp_handles.window_modules.sector_box.box_color,'string');
        position = get(grasp_handles.window_modules.sector_box.box_color,'value');
        color = color_string{position};
        status_flags.analysis_modules.sector_boxes.box_color = color;
        
    case 'grab_coords'
        box = get(gcbo,'userdata');
        coords(1) = status_flags.analysis_modules.sectors.outer_radius;
        coords(2) = status_flags.analysis_modules.sectors.inner_radius;
        %coords(3) = status_flags.analysis_modules.sectors.theta;
        coords(4) = status_flags.analysis_modules.sectors.delta_theta;
        coords(5) = status_flags.analysis_modules.sectors.anisotropy;
        coords(6) = status_flags.analysis_modules.sectors.anisotropy_angle;
        
        for n = 1:status_flags.analysis_modules.sectors.mirror_sectors %loop though the number of mirror sectors
            coords(3) = status_flags.analysis_modules.sectors.theta + (360/status_flags.analysis_modules.sectors.mirror_sectors)* (n-1);
            status_flags.analysis_modules.sector_boxes = setfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box+(n-1))],coords);
        end
        %Draw box
        
    case 'close'
        
        %Delete old boxes
        temp = find(ishandle(grasp_handles.window_modules.sector_box.sketch_handles));
        delete(grasp_handles.window_modules.sector_box.sketch_handles(temp));
        grasp_handles.window_modules.sector_box.sketch_handles = [];
        grasp_handles.window_modules.sector_box.window = [];
        %Turn off the Use Sector in Radial Average
        status_flags.analysis_modules.radial_average.sector_mask_chk =0;
        if isfield(grasp_handles.window_modules.radial_average,'sector_mask_chk')
            if ishandle(grasp_handles.window_modules.radial_average.sector_mask_chk)
                set(grasp_handles.window_modules.radial_average.sector_mask_chk,'value',status_flags.analysis_modules.radial_average.sector_mask_chk);
            end
        end
        return
        
        
    case 'sum_box_chk'
        status_flags.analysis_modules.sector_boxes.sum_box_chk = not(status_flags.analysis_modules.sector_boxes.sum_box_chk);
        
    case 'box_nrm_chk'
        status_flags.analysis_modules.sector_boxes.box_nrm_chk = not(status_flags.analysis_modules.sector_boxes.box_nrm_chk);
        
    case 'box_it'
        
        %Turn off command window parameter update for the boxing
        remember_display_params_status = status_flags.command_window.display_params;
        status_flags.command_window.display_params= 0;
        status_flags.display.refresh = 0; %Turn off the 2D display for speed
        
        box_masks = []; active_boxes = [];
        %Make empty sum_masks for all detectors
        for det = 1:inst_params.detectors
            sum_mask.(['det' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
        end
        
        box_history = ['Sector Box Coordinates:  R1 R2 Theta DTheta g gTheta'];
        %Make logical box masks only for valid boxes
        for box = 1:6
            coords = status_flags.analysis_modules.sector_boxes.(['coords' num2str(box)]);
            disp(['SectorBox ' num2str(box) ' coordinates ' num2str(coords)]);
            if (coords(1) ~= coords(2)) && (coords(4) ~=0)
                active_boxes = [active_boxes, box];
                box_mask.(['box' num2str(box)]) = sector_callbacks('build_sector_mask', [coords(1),coords(2),coords(3),coords(4),1,coords(5),coords(6)]);
                %Add to the sum mask
                for det = 1:inst_params.detectors
                    sum_mask.(['det' num2str(det)]) = or(sum_mask.(['det' num2str(det)]),box_mask.(['box' num2str(box)]).(['det' num2str(det)]));
                end
                box_history =  [box_history, {[num2str(coords(1)) ' ' num2str(coords(2)) ' ' num2str(coords(3)) ' ' num2str(coords(4)) ' ' num2str(coords(5)) ' ' num2str(coords(6))]}];
            end
        end
        %Convert sum_mask_logical to double
        for det = 1:inst_params.detectors
            sum_mask.(['det' num2str(det)]) = double(sum_mask.(['det' num2str(det)])); %Otherwise it comes out as a logical
                         %figure
                         %pcolor(sum_mask.(['det' num2str(det)]))
        end
        
        disp(['Active Boxes are:  ' num2str(active_boxes)]);
        
        %Churn through the depth and extract box-sums
        index = data_index(status_flags.selector.fw);
        foreground_depth = status_flags.selector.fdpth_max - grasp_data(index).sum_allow;
        depth_start = status_flags.selector.fd; %remember the initial foreground depth
        
        disp(['Extracting SectorBox intensities through depth']);
        box_intensities = [];
        for n = 1:foreground_depth
            message_handle = grasp_message(['Extracting SectorBox intensities Depth: ' num2str(n) ' of ' num2str(foreground_depth)]);
            status_flags.selector.fd = n+grasp_data(index).sum_allow;
            main_callbacks('depth_scroll'); %Scroll all linked depths and update
            
            %Get the box intensities
            if status_flags.analysis_modules.sector_boxes.sum_box_chk == 1; %Summed Boxes
                %Loop though the detectors each with their sum mask
                %Note: this is different to Square Boxes as Sector Boxes are allowed to span between detectors
                box_pixels = 0; box_sum = 0; box_sum_error = 0;
                for det = 1:inst_params.detectors
                    %All boxes summed
                    box_pixels = box_pixels + sum(sum(sum_mask.(['det' num2str(det)])));
                    box_sum = box_sum + sum(sum(displayimage.(['data' num2str(det)]).* sum_mask.(['det' num2str(det)])));
                    box_sum_error = sqrt(box_sum_error.^2 + (sum(sum((displayimage.(['error' num2str(det)]).*sum_mask.(['det' num2str(det)])).^2))));
                end
                %Normalise if required
                if status_flags.analysis_modules.sector_boxes.box_nrm_chk ==1;
                    box_sum = box_sum / box_pixels;
                    box_sum_error = box_sum_error / box_pixels;
                end
                box_sum_list = [box_sum, box_sum_error]; %Accumulate the sum list
                
            else %Individual Boxes
                box_sum_list = [];
                for m = 1:length(active_boxes)
                    box = active_boxes(m);
                    
                    %Loop though the detectors
                    %Note: this is different to Square Boxes as Sector Boxes are allowed to span between detectors
                    box_pixels = 0; box_sum = 0; box_sum_error = 0;
                    for det = 1:inst_params.detectors
                        mask = box_mask.(['box' num2str(box)]).(['det' num2str(det)]);
                        box_pixels = box_pixels + sum(sum(box_mask.(['box' num2str(box)]).(['det' num2str(det)])));
                        box_sum = box_sum + sum(sum(displayimage.(['data' num2str(det)]) .* mask));
                        box_sum_error = sqrt(box_sum_error.^2 + sum(sum(   ((displayimage.(['error' num2str(det)]) .* mask).^2)  )));
                    end
                    %Normalise if required
                    if status_flags.analysis_modules.sector_boxes.box_nrm_chk ==1;
                        box_sum = box_sum / box_pixels;
                        box_sum_error = box_sum_error / box_pixels;
                    end
                    box_sum_list = [box_sum_list, box_sum, box_sum_error];
                end
            end
            
            if status_flags.analysis_modules.sector_boxes.parameter == 0;
                parameter = n; %depth
                box_param_name = 'depth';
            else
                parameter = displayimage.params1(status_flags.analysis_modules.sector_boxes.parameter);
                box_param_name = inst_params.vector_names{status_flags.analysis_modules.sector_boxes.parameter};
                if iscell(box_param_name); %If name exists then remove it's cell nature
                    box_param_name = box_param_name{1};
                end

            end
            box_intensities(n,:) = [n, parameter, box_sum_list];
        end
        
        status_flags.selector.fd = depth_start;
        main_callbacks('depth_scroll'); %Scroll all linked depths and update
        delete(message_handle);
        
        %Dislplay results on screen
        disp(' ');
        disp(['Depth #,     Parameter(' num2str(status_flags.analysis_modules.sector_boxes.parameter) '),     Counts,     Err_Counts, .......']);
        l = size(box_intensities);
        for n = 1:l(1);
            disp_string = [];
            for m = 1:l(2);
                disp_string = [disp_string num2str(box_intensities(n,m),'%6.6g') '   ' char(9)];
            end
            disp(disp_string);
        end
        
        %Turn on command window parameter update for the boxing
        status_flags.command_window.display_params = remember_display_params_status;
        %Turn on the 2D display
        status_flags.display.refresh = 1;
        disp(' ')
        
        
        %***** Plot Box intensity vs. parameter ****
        l = size(box_intensities);
        plotdata = box_intensities(:,2:l(2));
        column_format = 'x';
        temp = size(plotdata);
        for n = 1:(temp(2)/2); column_format = [column_format, 'ye']; end
        if status_flags.analysis_modules.sector_boxes.box_nrm_chk ==1; y_string = ' \\ Pixel'; else y_string = []; end
        
        plot_params = struct(....
            'plot_type','plot',....
            'hold_graph','off',....
            'plot_title',['Box Sum'],....
            'x_label',(['Parameter ' num2str(status_flags.analysis_modules.sector_boxes.parameter) ', ' box_param_name]),....
            'y_label',['Box ' displayimage.units y_string],....
            'legend_str',['#' num2str(displayimage.params1(128))],....
            'params',displayimage.params1,....
            'parsub',displayimage.subtitle,....
            'export_data',plotdata,....
            'column_labels',[box_param_name char(9) 'I' char(9) 'Err_I']);
        
        local_history = displayimage.history; %This will actually be the history of the last file
        local_history = [local_history, {['***** Analysis *****']}];
        local_history = [local_history, {['Sector Box Intensity vs. Parameter ' num2str(status_flags.analysis_modules.sector_boxes.parameter)]}];
        local_history = [local_history, box_history];
        
        plot_params.history = local_history;
        grasp_plot(plotdata,column_format,plot_params);
        
        last_result = plotdata;
end


%Update displayed parameters
for box = 1:6
    coords = getfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(box)]);
    handle = getfield(grasp_handles.window_modules.sector_box,['coords' num2str(box)]);
    set(handle(1),'string',num2str(coords(1)));
    set(handle(2),'string',num2str(coords(2)));
    set(handle(3),'string',num2str(coords(3)));
    set(handle(4),'string',num2str(coords(4)));
    set(handle(5),'string',num2str(coords(5)));
    set(handle(6),'string',num2str(coords(6)));
    
end

set(grasp_handles.window_modules.sector_boxes.sum_box_chk,'value',status_flags.analysis_modules.sector_boxes.sum_box_chk);
set(grasp_handles.window_modules.sector_box.box_nrm_chk,'value',status_flags.analysis_modules.sector_boxes.box_nrm_chk);
set(grasp_handles.window_modules.sector_box.parameter,'string',num2str(status_flags.analysis_modules.sector_boxes.parameter));
if status_flags.analysis_modules.sector_boxes.parameter ==0; string = 'Depth';
else
    string = inst_params.vector_names{status_flags.analysis_modules.sector_boxes.parameter};
    if iscell(string); %If name exists then remove it's cell nature
        string = string{1};
    end
    
end
set(grasp_handles.window_modules.sector_box.parameter_string,'string',string);

%Delete old boxes
temp = find(ishandle(grasp_handles.window_modules.sector_box.sketch_handles));
delete(grasp_handles.window_modules.sector_box.sketch_handles(temp));
grasp_handles.window_modules.sector_box.sketch_handles = [];

box_color = status_flags.analysis_modules.sector_boxes.box_color;
if not(strcmp(box_color,'(none)'));
    if strcmp(box_color,'white'); box_color = [0.99,0.99,0.99]; end %to get around the invert hard copy problem
    
    for det = 1:inst_params.detectors
        for box = 1:6
            coords = status_flags.analysis_modules.sector_boxes.(['coords' num2str(box)]);
            cm = displayimage.cm.(['det' num2str(det)]);
            params = displayimage.(['params' num2str(det)]);
            
            %Find current detector distance for particular detector pannel
            det_current = params(inst_params.vectors.det); %Default unless otherwise
            if strcmp(status_flags.q.det,'detcalc');
                if isfield(inst_params.vectors,'detcalc')
                    if not(isempty(inst_params.vectors.detcalc));
                        det_current = params(inst_params.vectors.detcalc);
                    end
                end
            end
            if isfield(inst_params.vectors,'det_pannel');
                det_current = params(inst_params.vectors.det_pannel);
            end
            
            %Keep a memory of the main detector(1) Det
            if det ==1; det1det = det_current; end
            
            %For conical radius scaling of multiple detectors
            warning off
            eff_outer_radius = coords(1) * det_current / det1det;
            eff_inner_radius = coords(2) * det_current / det1det;
            warning on
            
            
            
            
            
            
            if isfield(inst_params.vectors,'ox') %for D33 pannels
            cx_eff = cm.cm_pixels(1) - ((params(inst_params.vectors.ox) - cm.cm_translation(1))/inst_params.detector1.pixel_size(1));
            else
                cx_eff = cm.cm_pixels(1) - (cm.cm_translation(1)/inst_params.detector1.pixel_size(1));
            end
            if isfield(inst_params.vectors,'oy') %for D33 pannels
            cy_eff = cm.cm_pixels(2) - ((params(inst_params.vectors.oy) - cm.cm_translation(2))/inst_params.detector1.pixel_size(1));
            else
                cy_eff = cm.cm_pixels(2) - (cm.cm_translation(2)/inst_params.detector1.pixel_size(1));
            end
            
            %Draw new sectors
            sector_handles = circle(det,eff_outer_radius,....
                eff_inner_radius,....
                cx_eff,cy_eff,....
                coords(3)-coords(4)/2,....
                coords(3)+coords(4)/2,....
                status_flags.analysis_modules.sector_boxes.box_color,....
                coords(5),....
                coords(6));
            grasp_handles.window_modules.sector_box.sketch_handles = [grasp_handles.window_modules.sector_box.sketch_handles; sector_handles];
        end
    end
end
