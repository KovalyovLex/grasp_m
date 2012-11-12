function strip_mask = strips_callbacks(to_do,options)

if nargin<2; options =[]; end
if nargin<1; to_do =''; end

global grasp_handles
global status_flags
global displayimage
global inst_params


pixelsize_x = inst_params.detector1.pixel_size(1)/1000; %x-pixel size in m
pixelsize_y = inst_params.detector1.pixel_size(2)/1000; %y-pixel size in m
pixel_anisotropy = pixelsize_x / pixelsize_y;

strip_mask = []; %dummy value for when not used

switch to_do
    
    case 'plot_strip_mask'
        strip_mask = strips_callbacks('build_strip_mask');
        for det = 1:inst_params.detectors;
            figure
            pcolor(strip_mask.(['det' num2str(det)])); axis equal; axis tight
        end
        
    case 'strip_cx'
        temp = str2num(get(grasp_handles.window_modules.strips.strip_cx,'string'));
        if not(isempty(temp)); status_flags.analysis_modules.strips.strip_cx = temp; end
        
    case 'strip_cy'
        temp = str2num(get(grasp_handles.window_modules.strips.strip_cy,'string'));
        if not(isempty(temp)); status_flags.analysis_modules.strips.strip_cy = temp; end
        
    case 'strip_theta'
        temp = str2num(get(grasp_handles.window_modules.strips.strip_theta,'string'));
        if not(isempty(temp)); status_flags.analysis_modules.strips.theta = temp; end
        status_flags.analysis_modules.strips.theta = check_angle(status_flags.analysis_modules.strips.theta);
        
    case 'angle_plus'
        status_flags.analysis_modules.strips.theta = status_flags.analysis_modules.strips.theta + options;
        status_flags.analysis_modules.strips.theta = check_angle(status_flags.analysis_modules.strips.theta);
        
    case 'strip_width'
        temp = str2num(get(grasp_handles.window_modules.strips.strip_width,'string'));
        if not(isempty(temp)); status_flags.analysis_modules.strips.width = temp; end
        
    case 'strip_length'
        temp = str2num(get(grasp_handles.window_modules.strips.strip_length,'string'));
        if not(isempty(temp)); status_flags.analysis_modules.strips.length = temp; end
        
    case 'strip_color'
        color_string = get(grasp_handles.window_modules.strips.strip_color,'string');
        position = get(grasp_handles.window_modules.strips.strip_color,'value');
        color = color_string{position};
        status_flags.analysis_modules.strips.strips_color = color;
        
    case 'grab_cm'
        cm = current_beam_centre;
        status_flags.analysis_modules.strips.strip_cx = cm.det1.cm_pixels(1);
        status_flags.analysis_modules.strips.strip_cy = cm.det1.cm_pixels(2);
        
    case 'close'
        %Delete old strips
        temp = find(ishandle(grasp_handles.window_modules.strips.sketch_handles));
        delete(grasp_handles.window_modules.strips.sketch_handles(temp));
        grasp_handles.window_modules.sector.strips_handles = [];
        grasp_handles.window_modules.strips.window = [];
        return
        
    case 'radial_average'
        status_flags.analysis_modules.radial_average.strip_mask_chk = 1;
        radial_average_window;
        return
        
    case 'build_strip_mask'
        message_handle = grasp_message(['Building Strip Mask - can be slow for large strips']);

        strip_cx = status_flags.analysis_modules.strips.strip_cx;
        strip_cy = status_flags.analysis_modules.strips.strip_cy;
        cm0 =  displayimage.cm.det1;
        
        %***** Build Strip Mask *****
        for det = 1:inst_params.detectors
            strip_mask.(['det' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
            strip_mask.(['det' num2str(det) '_strip_length']) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
            
            cm = displayimage.cm.(['det' num2str(det)]);
            params = displayimage.(['params' num2str(det)]);
            
            %Pixel distances from Beam Centre
            if isfield(inst_params.vectors,'ox')
                cx_eff = cm.cm_pixels(1) + strip_cx - cm0.cm_pixels(1) - ((params(inst_params.vectors.ox) - cm.cm_translation(1))/inst_params.detector1.pixel_size(1));
            else
                cx_eff = cm.cm_pixels(1) + strip_cx - cm0.cm_pixels(1);
            end
            
            if isfield(inst_params.vectors,'oy')
                cy_eff = cm.cm_pixels(2) +strip_cy - cm0.cm_pixels(2) - ((params(inst_params.vectors.oy) - cm.cm_translation(2))/inst_params.detector1.pixel_size(1));
            else
                cy_eff = cm.cm_pixels(2) +strip_cy - cm0.cm_pixels(2);
            end
            
            %Generate a coordinate matrix of the strip
            [strip_matrix_y, strip_matrix_x] = meshgrid(1:status_flags.analysis_modules.strips.width,1:status_flags.analysis_modules.strips.length);
            %Shift strip centre to centre of strip_matrix;
            strip_matrix_x = strip_matrix_x - status_flags.analysis_modules.strips.length/2 + 0.5;
            strip_matrix_y = strip_matrix_y - status_flags.analysis_modules.strips.width/2 + 0.5;
            
            %Rotate
            [th,r] = cart2pol(strip_matrix_x,strip_matrix_y);
            th = th + status_flags.analysis_modules.strips.theta*pi/180;
            [strip_matrix_y_rot,strip_matrix_x_rot] = pol2cart(th,r);
            
            %Shift box to real centre
            strip_matrix_x_eff = strip_matrix_x_rot + cx_eff;
            strip_matrix_y_eff = strip_matrix_y_rot + cy_eff;
            
            [det_y,det_x] = meshgrid(1:inst_params.(['detector' num2str(det)]).pixels(2),1:inst_params.(['detector' num2str(det)]).pixels(1));
            
            x1 = floor(strip_matrix_x_eff); y1= floor(strip_matrix_y_eff);
            x2 = ceil(strip_matrix_x_eff); y2= ceil(strip_matrix_y_eff);
            for n = 1:numel(strip_matrix_x_eff)
                temp = find(det_x == x1(n) & det_y == y1(n), 1);
                if not(isempty(temp));
                    strip_mask.(['det' num2str(det)])(y1(n),x1(n)) = 1;
                    strip_mask.(['det' num2str(det) '_strip_length'])(y1(n),x1(n)) =strip_matrix_x(n);
                end
                temp = find(det_x == x2(n) & det_y == y2(n), 1);
                if not(isempty(temp));
                    strip_mask.(['det' num2str(det)])(y2(n),x2(n)) = 1;
                    strip_mask.(['det' num2str(det) '_strip_length'])(y2(n),x2(n)) =strip_matrix_x(n);
                end
                temp = find(det_x == x1(n) & det_y == y2(n), 1);
                if not(isempty(temp));
                    strip_mask.(['det' num2str(det)])(y2(n),x1(n)) = 1;
                    strip_mask.(['det' num2str(det) '_strip_length'])(y2(n),x1(n)) =strip_matrix_x(n);
                end
                temp = find(det_x == x2(n) & det_y == y1(n), 1);
                if not(isempty(temp));
                    strip_mask.(['det' num2str(det)])(y1(n),x2(n)) = 1;
                    strip_mask.(['det' num2str(det) '_strip_length'])(y1(n),x2(n)) =strip_matrix_x(n);
                end
            end
        end
        delete(message_handle)
        
    case 'i_strip'
        
        %Take a copy of the history to modify though this process
        local_history = displayimage.history;
        local_history = [local_history, {['***** Analysis *****']}];
        local_history = [local_history, {['Strip Bin: 1 pixel']}];
        local_history = [local_history, {['Strip c_x: ' num2str(status_flags.analysis_modules.strips.strip_cx)]}];
        local_history = [local_history, {['Strip c_y: ' num2str(status_flags.analysis_modules.strips.strip_cy)]}];
        local_history = [local_history, {['Strip Angle: ' num2str(status_flags.analysis_modules.strips.theta)]}];
        local_history = [local_history, {['Strip Width: ' num2str(status_flags.analysis_modules.strips.width)]}];
        local_history = [local_history, {['Strip Length: ' num2str(status_flags.analysis_modules.strips.length)]}];
        
        %Build Strip Mask
        strip_mask = strips_callbacks('build_strip_mask');

        %Extract all the pixels and their position along the strip
        strip_intensity = [];
        for det = 1:inst_params.detectors
            temp1 = strip_mask.(['det' num2str(det) '_strip_length'])(logical(strip_mask.(['det' num2str(det)])));
            temp2 = displayimage.(['data' num2str(det)])(logical(strip_mask.(['det' num2str(det)])));
            temp3 = displayimage.(['error' num2str(det)])(logical(strip_mask.(['det' num2str(det)])));
            if not(isempty(temp1)) && not(isempty(temp2))
                strip_intensity = [strip_intensity; temp1, temp2, temp3];
            end
        end
        %sort
        strip_intensity = sortrows(strip_intensity,1);
        
        %Rebin along strip length
        bin_edges = -(status_flags.analysis_modules.strips.length/2):1:(status_flags.analysis_modules.strips.length/2);
        strip_intensity = rebin(strip_intensity,bin_edges);  %Strip Position, I, err I,  junk, number_points
        
        
        %***** Plot and Export Results *****
        plottitle = 'Strip Average';
        x_label = ['l (pixels)'];
        y_label = [displayimage.units];
        column_format = 'xye';
        
        plotdata = strip_intensity(:,1:3);
        exportdata = plotdata;
        
        %***** Plot I vs Strip Dimension ****
        column_format = 'xye';
        plot_params = struct(....
            'plot_type','plot',....
            'hold_graph','off',....
            'plot_title',plottitle,....
            'x_label',x_label,....
            'y_label',y_label,....
            'legend_str',['#' num2str(displayimage.params1(128))],....
            'params',displayimage.params1,....
            'parsub',displayimage.subtitle,....
            'export_data',exportdata,....
            'info',displayimage.info);
        plot_params.history = local_history;
        grasp_plot(plotdata,column_format,plot_params);
end



%Update the window items
set(grasp_handles.window_modules.strips.strip_cx,'string',num2str(status_flags.analysis_modules.strips.strip_cx));
set(grasp_handles.window_modules.strips.strip_cy,'string',num2str(status_flags.analysis_modules.strips.strip_cy));
set(grasp_handles.window_modules.strips.strip_theta,'string',num2str(status_flags.analysis_modules.strips.theta));
set(grasp_handles.window_modules.strips.strip_width,'string',num2str(status_flags.analysis_modules.strips.width));
set(grasp_handles.window_modules.strips.strip_length,'string',num2str(status_flags.analysis_modules.strips.length));


%Delete old strips
temp = find(ishandle(grasp_handles.window_modules.strips.sketch_handles));
delete(grasp_handles.window_modules.strips.sketch_handles(temp));
grasp_handles.window_modules.strips.sketch_handles = [];

%Draw new strips
strip_color = status_flags.analysis_modules.strips.strips_color;
if not(strcmp(strip_color,'(none)'));
    if strcmp(strip_color,'white'); strip_color = [0.99,0.99,0.99]; end %to get around the invert hard copy problem
    
    strip_length = status_flags.analysis_modules.strips.length;
    strip_width = status_flags.analysis_modules.strips.width;
    strip_theta = status_flags.analysis_modules.strips.theta;
    
    strip_cx = status_flags.analysis_modules.strips.strip_cx;
    strip_cy = status_flags.analysis_modules.strips.strip_cy;

    cm0 =  displayimage.cm.det1;

    for det = 1:inst_params.detectors
        cm = displayimage.cm.(['det' num2str(det)]);
        params = displayimage.(['params' num2str(det)]);

        %Pixel distances from Beam Centre
        if isfield(inst_params.vectors,'ox')
            cx_eff = cm.cm_pixels(1) + strip_cx - cm0.cm_pixels(1) - ((params(inst_params.vectors.ox) - cm.cm_translation(1))/inst_params.detector1.pixel_size(1));
        else
            cx_eff = cm.cm_pixels(1) + strip_cx - cm0.cm_pixels(1);
        end
        
        if isfield(inst_params.vectors,'oy')
            cy_eff = cm.cm_pixels(2) +strip_cy - cm0.cm_pixels(2) - ((params(inst_params.vectors.oy) - cm.cm_translation(2))/inst_params.detector1.pixel_size(1));
        else
            cy_eff = cm.cm_pixels(2) +strip_cy - cm0.cm_pixels(2);
        end
 
        %Co-ords of Principle Corners.
        corners(1,:) = [strip_width/2,strip_length/2];
        corners(2,:) = [strip_width/2,-strip_length/2];
        corners(3,:) = [-strip_width/2,-strip_length/2];
        corners(4,:) = [-strip_width/2,strip_length/2];
        
        %Rotate Principle Corners
        [th,r] = cart2pol(corners(:,1),corners(:,2));
        th = th - strip_theta*pi/180;
        [x,y] = pol2cart(th,r);
        
        %Correct for pixel anisotropy
        y = y* pixel_anisotropy;
        
        %Shift to Box Centre
        x = x + cx_eff; y = y + cy_eff;
        corners(:,1) = x; corners(:,2) = y;
        
        %Close the Box.
        corners(5,:) = corners(1,:);
        
        %Make Box vectors list
        drawvectors = [];
        for n = 1:(length(corners)-1)
            drawvectors(n,:) = [corners(n,1),corners((n+1),1),corners(n,2),corners((n+1),2)];
        end
        
        %Specify z-height of the lines for the 3D plot
        %Set them to the max of the display range
        z_height = status_flags.display.z_max.det1;
        z_height = z_height * ones(size(drawvectors(:,1:2)));
        
        %Convert coordinates from pixels to q or two theta
        if strcmp(status_flags.axes.current,'q') | strcmp(status_flags.axes.current,'t')
            x_pixel_strip = displayimage.qmatrix1(1,:,1);
            y_pixel_strip = displayimage.qmatrix1(:,1,2);
            if strcmp(status_flags.axes.current,'q')
                %Look up q values from qmatrix
                x_axes_strip = displayimage.qmatrix1(1,:,3);
                y_axes_strip = displayimage.qmatrix1(:,1,4);
            elseif strcmp(status_flags.axes.current,'t')
                %Look up 2theta values from qmatrix
                x_axes_strip = displayimage.qmatrix1(1,:,7);
                y_axes_strip = displayimage.qmatrix1(:,1,8);
            end
            %Interpolate new co-ordinates in the current axes
            drawvectors(:,1:2) = interp1(x_pixel_strip,x_axes_strip,drawvectors(:,1:2),'spline');
            drawvectors(:,3:4) = interp1(y_pixel_strip,y_axes_strip,drawvectors(:,3:4),'spline');
        end
        
        
        %Draw
        main_axis_handle = grasp_handles.displayimage.(['axis' num2str(det)]);
        handles = line(drawvectors(:,1:2),drawvectors(:,3:4),z_height,'color',strip_color,'linewidth',status_flags.display.linewidth,'parent',main_axis_handle,'tag','strip_sketch');
        grasp_handles.window_modules.strips.sketch_handles = [grasp_handles.window_modules.strips.sketch_handles, handles];
    end
    
    
end



function theta = check_angle(theta)

while theta < 0
    theta = theta + 360;
end
while theta >= 360
    theta = theta - 360;
end
