function output = box_callbacks(to_do,option)

if nargin<2; option = ''; end
if nargin<1; to_do = ''; end
output = [];

global status_flags
global grasp_handles
global displayimage
global grasp_data
global inst_params
global last_result

global box_intensities

switch to_do
    
    case 'retrieve_box_coords'
        %Retrieves the box coords from the status_flags structure
        %and modifies them if necessary according to q-lock - or other box
        %moving features

        %find current beam centre
        cm = current_beam_centre;

        coords = status_flags.analysis_modules.boxes.(['coords' num2str(option)]); %where option is the box number
        %Rebuild Masks if necessary (i.e. for Q-lock with wavelength)
        if status_flags.analysis_modules.boxes.q_lock_chk  == 1;
            %Modify coordinates according to wavelength and reference wavelength
            lambda_ref = status_flags.analysis_modules.boxes.q_lock_wav_ref;
            lambda_now = displayimage.params1(inst_params.vectors.wav);
            
            
            if status_flags.analysis_modules.boxes.q_lock_box_size_chk  == 0;
                %Simple box movement - box gets larger as it goes out
                %R1 = (coords(1) * lambda_now/lambda_ref); %new outer radius
                %R2 = (coords(2) * lambda_now/lambda_ref); %new inner radius
                if coords(1) ~=0;
                    delta_x1 = (coords(1)-cm.det1.cm_pixels(1)) * lambda_now/lambda_ref;
                    coords(1) = delta_x1 + cm.det1.cm_pixels(1);
                end
                if coords(2) ~=0;
                    delta_x2 = (coords(2)-cm.det1.cm_pixels(1)) * lambda_now/lambda_ref;
                    coords(2) = delta_x2 + cm.det1.cm_pixels(1);
                end
                if coords(3) ~=0;
                    delta_y1 = (coords(3)-cm.det1.cm_pixels(2)) * lambda_now/lambda_ref;
                    coords(3) = delta_y1 + cm.det1.cm_pixels(2);
                end
                if coords(4) ~=0;
                    delta_y2 = (coords(4)-cm.det1.cm_pixels(2)) * lambda_now/lambda_ref;
                    coords(4) = delta_y2 + cm.det1.cm_pixels(2);
                end
                
                
            elseif status_flags.analysis_modules.boxes.q_lock_box_size_chk == 1;
                %'Constant' box size 
                x_width = coords(2)-coords(1); y_width = coords(4)-coords(3);
                delta_mean_x = (((coords(1)+coords(2))/2) - cm.det1.cm_pixels(1)) * lambda_now/lambda_ref;
                delta_mean_y = (((coords(4)+coords(3))/2) - cm.det1.cm_pixels(2)) * lambda_now/lambda_ref;
                if coords(1) ~=0;
                    coords(1) = delta_mean_x + cm.det1.cm_pixels(1) - x_width/2;
                end
                if coords(2) ~=0;
                    coords(2) = delta_mean_x + cm.det1.cm_pixels(1) + x_width/2;
                end
                if coords(3) ~=0;
                    coords(3) = delta_mean_y + cm.det1.cm_pixels(2) - y_width/2;
                end
                if coords(4) ~=0;
                    coords(4) = delta_mean_y + cm.det1.cm_pixels(2) + y_width/2;
                end
            end
        end
        
        if status_flags.analysis_modules.boxes.t2t_lock_chk ==1 ;
            
            %Modify coordinates according to san angle and reference san angle
            angle_ref = status_flags.analysis_modules.boxes.(['t2t_lock_angle_ref' num2str(option)]);
            angle_now = displayimage.params1(inst_params.vectors.san);
            delta_2theta = 2*(angle_now - angle_ref); %This is the required angular shift of the box
            
            if coords(1) ~=0 && coords(2) ~=0;
                if coords(1) < cm.det1.cm_pixels(1);
                    
                else
                    delta_2theta = -delta_2theta;
                end
                
                x1_angle = displayimage.qmatrix1(1,round(coords(1)),7);
                x1_angle = x1_angle + delta_2theta;
                %Find the cloeset pixel this corresponds to on the detector
                temp = find(displayimage.qmatrix1(1,:,7)>=x1_angle);
                x1 = displayimage.qmatrix1(1,temp(1),1);
                
                x2_angle = displayimage.qmatrix1(1,round(coords(2)),7);
                x2_angle = x2_angle + delta_2theta;
                %Find the cloeset pixel this corresponds to on the detector
                temp = find(displayimage.qmatrix1(1,:,7)>=x2_angle);
                x2 = displayimage.qmatrix1(1,temp(1),1);
                
                
                %if status_flags.analysis_modules.boxes.t2t_lock_box_size_chk == 1; %Scale sector opening with box position
                %    coords(4) = coords(4) * mean(coords(1),coords(2))/mean(R1,R2);
                %    
                %end
                coords(1) = x1;
                coords(2) = x2;
            end
            
        end
        output = round(coords);
        return
        
       
    case 'q_lock_box_size_chk'
        status_flags.analysis_modules.boxes.q_lock_box_size_chk = get(gcbo,'value');
        box_callbacks;
        
    case 'q_lock_chk'
        status_flags.analysis_modules.boxes.q_lock_chk = get(gcbo,'value');
        status_flags.analysis_modules.boxes.t2t_lock_chk = 0;
        box_callbacks;
        
    case 't2t_lock_box_size_chk'
        status_flags.analysis_modules.boxes.t2t_lock_box_size_chk = get(gcbo,'value');
        box_callbacks;
        
    case 't2t_lock_chk'
        status_flags.analysis_modules.boxes.t2t_lock_chk = get(gcbo,'value');
        status_flags.analysis_modules.boxes.q_lock_chk = 0;
        box_callbacks;
       
        
    case 'scan_box_check'
        box = get(gcbo,'userdata');
        status_flags.analysis_modules.boxes.scan_boxes_check(box) = get(gcbo,'value');
        
    case 'x1'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.boxes,['coords' num2str(box)]);
            coords(1) = temp;
            status_flags.analysis_modules.boxes = setfield(status_flags.analysis_modules.boxes,['coords' num2str(box)],coords);
        end
        status_flags.analysis_modules.boxes.q_lock_wav_ref = displayimage.params1(inst_params.vectors.wav);
        status_flags.analysis_modules.boxes.(['t2t_lock_angle_ref' num2str(box)]) = displayimage.params1(inst_params.vectors.san);
        
    case 'x2'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.boxes,['coords' num2str(box)]);
            coords(2) = temp;
            status_flags.analysis_modules.boxes = setfield(status_flags.analysis_modules.boxes,['coords' num2str(box)],coords);
        end
        status_flags.analysis_modules.boxes.q_lock_wav_ref = displayimage.params1(inst_params.vectors.wav);
        status_flags.analysis_modules.boxes.(['t2t_lock_angle_ref' num2str(box)]) = displayimage.params1(inst_params.vectors.san);
        
    case 'y1'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.boxes,['coords' num2str(box)]);
            coords(3) = temp;
            status_flags.analysis_modules.boxes = setfield(status_flags.analysis_modules.boxes,['coords' num2str(box)],coords);
        end
        status_flags.analysis_modules.boxes.q_lock_wav_ref = displayimage.params1(inst_params.vectors.wav);
        status_flags.analysis_modules.boxes.(['t2t_lock_angle_ref' num2str(box)]) = displayimage.params1(inst_params.vectors.san);
        
    case 'y2'
        box = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            coords = getfield(status_flags.analysis_modules.boxes,['coords' num2str(box)]);
            coords(4) = temp;
            status_flags.analysis_modules.boxes = setfield(status_flags.analysis_modules.boxes,['coords' num2str(box)],coords);
        end
        status_flags.analysis_modules.boxes.q_lock_wav_ref = displayimage.params1(inst_params.vectors.wav);
        status_flags.analysis_modules.boxes.(['t2t_lock_angle_ref' num2str(box)]) = displayimage.params1(inst_params.vectors.san);

    case 'clear_box'
        box = get(gcbo,'userdata');
        coords =[0,0,0,0,1]; %Empty box coordinates.  5th coordinate is the detector number
        status_flags.analysis_modules.boxes = setfield(status_flags.analysis_modules.boxes,['coords' num2str(box)],coords);
        status_flags.analysis_modules.boxes.q_lock_wav_ref = displayimage.params1(inst_params.vectors.wav);
        status_flags.analysis_modules.boxes.(['t2t_lock_angle_ref' num2str(box)]) = displayimage.params1(inst_params.vectors.san);

    case 'clear_all'
        for box = 1:6
            coords = [0,0,0,0,1]; %Empty box coordinates
            status_flags.analysis_modules.boxes = setfield(status_flags.analysis_modules.boxes,['coords' num2str(box)],coords);
        end
        status_flags.analysis_modules.boxes.q_lock_wav_ref = displayimage.params1(inst_params.vectors.wav);
        status_flags.analysis_modules.boxes.(['t2t_lock_angle_ref' num2str(box)]) = displayimage.params1(inst_params.vectors.san);

    case 'parameter'
        temp = str2num(get(grasp_handles.window_modules.box.parameter,'string'));
        if not(isempty(temp));
            if temp >= 0 && temp <=128;
                status_flags.analysis_modules.boxes.parameter = temp;
            end
        end

    case 'box_color'
        color_string = get(grasp_handles.window_modules.box.box_color,'string');
        position = get(grasp_handles.window_modules.box.box_color,'value');
        color = color_string{position};
        status_flags.analysis_modules.boxes.box_color = color;

    case 'grab_coords'
        box = get(gcbo,'userdata');
        det = status_flags.display.active_axis;
        ax_lims = current_axis_limits;
        ax_lims = ax_lims.(['det' num2str(det)]).pixels;
        status_flags.analysis_modules.boxes = setfield(status_flags.analysis_modules.boxes,['coords' num2str(box)],[ax_lims, det]);
        
        %Keep a record of the scan-box reference SAN angle
        status_flags.analysis_modules.boxes.scan_boxes_angle0(box) = displayimage.(['params' num2str(det)])(inst_params.vectors.san);
        status_flags.analysis_modules.boxes.q_lock_wav_ref = displayimage.params1(inst_params.vectors.wav);
        status_flags.analysis_modules.boxes.(['t2t_lock_angle_ref' num2str(box)]) = displayimage.params1(inst_params.vectors.san);

        
    case 'close'
        %Delete old boxes
        temp = find(ishandle(grasp_handles.window_modules.box.sketch_handles));
        delete(grasp_handles.window_modules.box.sketch_handles(temp));
        grasp_handles.window_modules.box.sketch_handles = [];
        grasp_handles.window_modules.box.window = [];
        return


    case 'sum_box_chk'
        status_flags.analysis_modules.boxes.sum_box_chk = not(status_flags.analysis_modules.boxes.sum_box_chk);
        
    case 'box_nrm_chk'
        status_flags.analysis_modules.boxes.box_nrm_chk = not(status_flags.analysis_modules.boxes.box_nrm_chk);
        
    case 'build_the_masks'
        
        
        %NEED TO INCLUDE USER AND INSTRUMENT MASKS HERE!
        
        box_masks = []; box_number = []; active_boxes = [];
        %Make empty sum_masks for all detectors
        for det = 1:inst_params.detectors
            sum_mask.(['det' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
        end
        
        box_history = ['Box Coordinates:  x1 x2 y1 y2'];
        %Make logical box masks only for valid boxes
        for box = 1:6
            %            coords = status_flags.analysis_modules.boxes.(['coords' num2str(box)]);
            coords = box_callbacks('retrieve_box_coords',box);
           
            %disp(['Box ' num2str(box) ' coordinates ' num2str(coords(1:4)) ' on detector ' num2str(coords(5))]);
            det = coords(5); %Detector number we are dealing with
            box_masks.(['box' num2str(box)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
            box_area = (coords(2)-coords(1))*(coords(4)-coords(3));
            
            if box_area>0;
                active_boxes = [active_boxes, box];
                box_masks.(['box' num2str(box)])(coords(3):coords(4),coords(1):coords(2)) = 1;
                
                %Include Current Mask conditions in the box
                box_masks.(['box' num2str(box)]) = box_masks.(['box' num2str(box)]).*displayimage.(['mask' num2str(det)]);
                
                box_history =  [box_history, {[num2str(coords(1)) ' ' num2str(coords(2)) ' ' num2str(coords(3)) ' ' num2str(coords(4))]}];
            end
            sum_mask.(['det' num2str(det)]) = or(sum_mask.(['det' num2str(det)]),box_masks.(['box' num2str(box)]));
        end
        
        for det = 1:inst_params.detectors
            sum_mask.(['det' num2str(det)]) = double(sum_mask.(['det' num2str(det)])); %Otherwise it comes out as a logical
        end
        %disp(['Active Boxes are:  ' num2str(active_boxes)]);
        
        output.box_mask =  box_masks;
        output.active_boxes = active_boxes;
        output.sum_mask = sum_mask;
        output.box_history = box_history;
        
        
    case 'box_it'

        %Turn off updating
        remember_display_params_status = status_flags.command_window.display_params; %Turn off command window parameter update for the boxing
        if strcmp(status_flags.analysis_modules.boxes.display_refresh,'on');
            status_flags.command_window.display_params=1;
            status_flags.display.refresh = 1;
        else
            status_flags.command_window.display_params=0;
            status_flags.display.refresh = 0;
        end
        
        masks = box_callbacks('build_the_masks');
        box_masks = masks.box_mask;
        active_boxes = masks.active_boxes;
        sum_mask = masks.sum_mask;
        box_history = masks.box_history;
        
        %Churn through the depth and extract box-sums
        index = data_index(status_flags.selector.fw);
        foreground_depth = status_flags.selector.fdpth_max - grasp_data(index).sum_allow;
        depth_start = status_flags.selector.fd; %remember the initial foreground depth
        
        %Check if using depth max min
        if status_flags.selector.depth_range_chk == 1;
            dstart = status_flags.selector.depth_range_min;
            if status_flags.selector.depth_range_max > foreground_depth;
                dend = foreground_depth;
            else
                dend = status_flags.selector.depth_range_max;
            end
        else
            dstart = 1; dend = foreground_depth;
        end
       
        
        disp(['Extracting Box intensities through depth']);
        box_intensities = [];
        for n = dstart:dend
            message_handle = grasp_message(['Extracting Box intensities Depth: ' num2str(n) ' of ' num2str(foreground_depth)]);
            status_flags.selector.fd = n+grasp_data(index).sum_allow;
            main_callbacks('depth_scroll'); %Scroll all linked depths and update
            
            %Rebuild Masks if necessary (i.e. for Q-lock with wavelength)
            if status_flags.analysis_modules.sector_boxes.q_lock_chk  == 1 || status_flags.analysis_modules.sector_boxes.t2t_lock_chk ==1;
                masks = box_callbacks('build_the_masks');
                box_masks = masks.box_mask;
                active_boxes = masks.active_boxes;
                sum_mask = masks.sum_mask;
                box_history = masks.box_history;
            end
            
            %Get the box intensities
            if status_flags.analysis_modules.boxes.sum_box_chk == 1;  %Summed Boxes
                %Loop though the detectors each with their sum mask
                box_pixels = 0; box_sum = 0; box_sum_error = 0;
                for det = 1:inst_params.detectors
                    %All boxes summed
                    box_pixels = box_pixels + sum(sum(sum_mask.(['det' num2str(det)])));
                    box_sum = box_sum + sum(sum(displayimage.(['data' num2str(det)]).* sum_mask.(['det' num2str(det)])));
                    box_sum_error = sqrt(box_sum_error.^2 + (sum(sum((displayimage.(['error' num2str(det)]).*sum_mask.(['det' num2str(det)])).^2))));
                end
                %Normalise if required
                if status_flags.analysis_modules.boxes.box_nrm_chk ==1;
                    box_sum = box_sum / box_pixels;
                    box_sum_error = box_sum_error / box_pixels;
                end
                box_sum_list = [box_sum, box_sum_error]; %Accumulate the sum list
            
            else %Individual boxes
                box_sum_list = [];
                for m = 1:length(active_boxes)
                    box = active_boxes(m);
                    coords = status_flags.analysis_modules.boxes.(['coords' num2str(box)]);
                    det = coords(5);
                    mask = box_masks.(['box' num2str(box)]);
                    %Normalise if required
                    if status_flags.analysis_modules.boxes.box_nrm_chk ==1;
                        box_pixels = sum(sum(mask));
                    else
                        box_pixels = 1;
                    end
                    
                    box_sum = (sum(sum(displayimage.(['data' num2str(det)]) .* mask)))/box_pixels;
                    box_sum_error = (sqrt(sum(sum((displayimage.(['error' num2str(det)]) .* mask).^2))))/box_pixels;
                    box_sum_list = [box_sum_list, box_sum, box_sum_error];
                end
            end

            if status_flags.analysis_modules.boxes.parameter == 0;
                parameter = n; %depth
                box_param_name = 'depth';
            else
                parameter = displayimage.params1(status_flags.analysis_modules.boxes.parameter);
                box_param_name = inst_params.vector_names{status_flags.analysis_modules.boxes.parameter};
                if iscell(box_param_name); %If name exists then remove it's cell nature
                    box_param_name = box_param_name{1};
                end
            end
            box_intensities = [box_intensities; [n, parameter, box_sum_list]];
        end
        
        status_flags.selector.fd = depth_start;
        main_callbacks('depth_scroll'); %Scroll all linked depths and update
        delete(message_handle);

        %Dislplay results on screen
        disp(' ');
        disp(['Depth #,     Parameter(' num2str(status_flags.analysis_modules.boxes.parameter) '),     Counts,     Err_Counts, .......']);
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
        disp(' ');

        %***** Plot Box intensity vs. parameter ****
        l = size(box_intensities);
        plotdata = box_intensities(:,2:l(2));
        column_format = 'x';
        temp = size(plotdata);
        for n = 1:(temp(2)/2); column_format = [column_format, 'ye']; end
        if status_flags.analysis_modules.boxes.box_nrm_chk ==1; y_string = ' \\ Pixel'; else y_string = []; end

        
        
        
        
        plot_params = struct(....
            'plot_type','plot',....
            'hold_graph','off',....
            'plot_title',['Box Sum'],....
            'x_label',(['Parameter ' num2str(status_flags.analysis_modules.boxes.parameter) ', ' box_param_name]),....
            'y_label',['Box ' displayimage.units y_string],....
            'legend_str',['#' num2str(displayimage.params1(128))],....
            'params',displayimage.params1,....
            'parsub',displayimage.subtitle,....
            'export_data',plotdata,....
            'export_column_format',column_format,....
            'column_labels',[box_param_name char(9) 'I' char(9) 'Err_I']);
            
        local_history = displayimage.history; %This will actually be the history of the last file
        local_history = [local_history, {['***** Analysis *****']}];
        local_history = [local_history, {['Box Intensity vs. Parameter ' num2str(status_flags.analysis_modules.boxes.parameter)]}];
        local_history = [local_history, box_history];
        
        plot_params.history = local_history;
        grasp_plot(plotdata,column_format,plot_params);
        
        last_result = plotdata;
        
        
end


%Update displayed box window option
if status_flags.analysis_modules.boxes.q_lock_chk == 1; %q-lock
    set(grasp_handles.window_modules.box.q_lock_box_size,'visible','on');
    set(grasp_handles.window_modules.box.t2t_lock_box_size,'visible','off');
else
    set(grasp_handles.window_modules.box.q_lock_box_size,'visible','off');
    %set(grasp_handles.window_modules.box.t2t_lock_box_size,'visible','off');
end

if status_flags.analysis_modules.boxes.t2t_lock_chk == 1; %theta-2theta lock
    set(grasp_handles.window_modules.box.t2t_lock_box_size,'visible','off'); %NOT USED AT THE MOMENT
    set(grasp_handles.window_modules.box.q_lock_box_size,'visible','off');
else
    set(grasp_handles.window_modules.box.t2t_lock_box_size,'visible','off');
end
set(grasp_handles.window_modules.box.q_lock,'value',status_flags.analysis_modules.boxes.q_lock_chk);
set(grasp_handles.window_modules.box.t2t_lock,'value',status_flags.analysis_modules.boxes.t2t_lock_chk);


%Update displayed parameters
for box = 1:6
    %coords = getfield(status_flags.analysis_modules.boxes,['coords' num2str(box)]);
    coords = box_callbacks('retrieve_box_coords',box);
    handle = getfield(grasp_handles.window_modules.box,['coords' num2str(box)]);
    set(handle(1),'string',num2str(coords(1)));
    set(handle(2),'string',num2str(coords(2)));
    set(handle(3),'string',num2str(coords(3)));
    set(handle(4),'string',num2str(coords(4)));
    set(handle(5),'string',num2str(coords(5)));
    
end
set(grasp_handles.window_modules.box.sum_box_chk,'value',status_flags.analysis_modules.boxes.sum_box_chk);
set(grasp_handles.window_modules.box.box_nrm_chk,'value',status_flags.analysis_modules.boxes.box_nrm_chk);
set(grasp_handles.window_modules.box.parameter,'string',num2str(status_flags.analysis_modules.boxes.parameter));
if status_flags.analysis_modules.boxes.parameter ==0; string = 'Depth';
else string = inst_params.vector_names{status_flags.analysis_modules.boxes.parameter};
end
set(grasp_handles.window_modules.box.parameter_string,'string',string);
%Delete old boxes
temp = find(ishandle(grasp_handles.window_modules.box.sketch_handles));
delete(grasp_handles.window_modules.box.sketch_handles(temp));
grasp_handles.window_modules.box.sketch_handles = [];

box_color = status_flags.analysis_modules.boxes.box_color;
if not(strcmp(box_color,'(none)'));
    if strcmp(box_color,'white'); box_color = [0.99,0.99,0.99]; end %to get around the invert hard copy problem


    for box = 1:6
        %coords = getfield(status_flags.analysis_modules.boxes,['coords' num2str(box)]);
        coords = box_callbacks('retrieve_box_coords',box);

        ax = grasp_handles.displayimage.(['axis' num2str(coords(5))]);

        %Check if using a scanning box & transform coordinates
        if status_flags.analysis_modules.boxes.scan_boxes_check(box) ==1;
            angle_now = displayimage.params(inst_params.vectors.san);
            angle0 = status_flags.analysis_modules.boxes.scan_boxes_angle0(box);
            coords = dynamic_box_coords(coords,angle0, angle_now);
        end

        corners(1,:) = [coords(1),coords(3)];
        corners(2,:) = [coords(1),coords(4)];
        corners(3,:) = [coords(2),coords(4)];
        corners(4,:) = [coords(2),coords(3)];
        corners(5,:) = corners(1,:); %close the box

        %Make Box vectors list
        drawvectors = [];
        for n = 1:(length(corners)-1)
            drawvectors(n,:) = [corners(n,1),corners((n+1),1),corners(n,2),corners((n+1),2)];
        end

        %Convert coordinates from pixels to q or two theta
        if strcmp(status_flags.axes.current,'q') | strcmp(status_flags.axes.current,'t')
            x_pixel_strip = displayimage.qmatrix(1,:,1);
            y_pixel_strip = displayimage.qmatrix(:,1,2);
            if strcmp(status_flags.axes.current,'q')
                %Look up q values from qmatrix
                x_axes_strip = displayimage.qmatrix(1,:,3);
                y_axes_strip = displayimage.qmatrix(:,1,4);
            elseif strcmp(status_flags.axes.current,'t')
                %Look up 2theta values from qmatrix
                x_axes_strip = displayimage.qmatrix(1,:,7);
                y_axes_strip = displayimage.qmatrix(:,1,8);
            end
            %Interpolate new co-ordinates in the current axes
            drawvectors(:,1:2) = interp1(x_pixel_strip,x_axes_strip,drawvectors(:,1:2),'spline');
            drawvectors(:,3:4) = interp1(y_pixel_strip,y_axes_strip,drawvectors(:,3:4),'spline');
        end

        %Specify z-height of the lines for the 3D plot
        %Set them to the max of the display range
        z_height = status_flags.display.z_max.det1;
        z_height = z_height * ones(size(drawvectors(:,1:2)));

        %Draw
        handles = line(drawvectors(:,1:2),drawvectors(:,3:4),z_height,'color',box_color,'linewidth',status_flags.display.linewidth,'parent',ax,'tag','strip_sketch');
        grasp_handles.window_modules.box.sketch_handles = [grasp_handles.window_modules.box.sketch_handles, handles];
    end
end

end


function coords = dynamic_box_coords(coords,angle0, angle_now)

global displayimage

%Recalculate dynamic box mask
disp('Re-calculating dynamic box coordinates')
disp(['Old Coords:  ' num2str(coords)]);

delta_2theta = 2*(angle_now - angle0); %This is the required angular shift of the box
disp(['Box Delta 2 Theta: ' num2str(delta_2theta)]);

%Nominal box pixel centre
x_centre_pixel0 = mean([coords(1),coords(2)]);
%Nominal box angle centre
x_centre_2theta0 = mean([displayimage.qmatrix(1,coords(1),7), displayimage.qmatrix(1,coords(2),7)]);
%new box angle centre
x_centre_2theta_now = x_centre_2theta0 + delta_2theta;
%Find the cloesett pixel this corresponds to on the detector
temp = find(displayimage.qmatrix(1,:,7)>=x_centre_2theta_now);

if not(isempty(temp))
    x_centre_pixel_now = displayimage.qmatrix(1,temp(1),1);
    delta_x_coord = x_centre_pixel_now - x_centre_pixel0;
    coords(1) = floor(coords(1) + delta_x_coord);
    coords(2) = floor(coords(2) + delta_x_coord);
    disp(['New Coords:  ' num2str(coords)]);
else
    coords = [1,1,1,1]; %i.e. equivalent to a non defined box
end


end
