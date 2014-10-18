function live_coords

global status_flags
global displayimage
global grasp_handles
global inst_params

%Numeric display format
if strcmp(status_flags.normalization.status,'none'); format_str = '%3.0f'; else format_str = '%1.2f'; end
%Display position for live co-ords
position = [0,0.98,0.4,0.02];
%default live co-ords text
text = '';

%Current active axis
det = status_flags.display.active_axis;

%Get current mouse position over figure
co_ord=get(grasp_handles.displayimage.(['axis' num2str(det)]),'CurrentPoint');


%Where are these coordinates in pixels (also imposes boundry conditions)
if strcmp(status_flags.axes.current,'p');
    if co_ord(1,1) >= 1 && co_ord(1,1) <= inst_params.(['detector' num2str(det)]).pixels(1) && co_ord(1,2) >= 1 && co_ord(1,2) <= inst_params.(['detector' num2str(det)]).pixels(2)
        x_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,1) - co_ord(1,1));
        [temp, x_index] = min(x_difference);
        y_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,2) - co_ord(1,2));
        [temp, y_index] = min(y_difference);
        pixel_value = displayimage.(['data' num2str(det)])(y_index,x_index);
        pixel_raw_value = displayimage.(['raw_counts' num2str(det)])(y_index,x_index);
        pixel_x = displayimage.(['qmatrix' num2str(det)])(1,x_index,1); pixel_y = displayimage.(['qmatrix' num2str(det)])(y_index,1,2);
        text = [' x:' num2str(pixel_x) ' y:' num2str(pixel_y) '  N: ' num2str(pixel_raw_value,format_str) '  I: ' num2str(pixel_value,format_str)];
    else
        text = ['Not over active figure (' num2str(det) ')'];
    end
    
elseif strcmp(status_flags.axes.current,'q');
    if co_ord(1,1) >= min(displayimage.(['qmatrix' num2str(det)])(1,:,3)) && co_ord(1,1) <= max(displayimage.(['qmatrix' num2str(det)])(1,:,3)) && co_ord(1,2) >= min(displayimage.(['qmatrix' num2str(det)])(:,1,4)) && co_ord(1,2) <= max(displayimage.(['qmatrix' num2str(det)])(:,1,4))
        x_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,3) - co_ord(1,1));
        [temp, x_index] = min(x_difference);
        y_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,4) - co_ord(1,2));
        [temp, y_index] = min(y_difference);
        pixel_value = displayimage.(['data' num2str(det)])(y_index,x_index);
        pixel_raw_value = displayimage.(['raw_counts' num2str(det)])(y_index,x_index);
        qx = displayimage.(['qmatrix' num2str(det)])(1,x_index,3); qy = displayimage.(['qmatrix' num2str(det)])(y_index,1,4);
        modq = displayimage.(['qmatrix' num2str(det)])(y_index,x_index,5);
        text = [' Qx:' num2str(qx,'%3.2g') ' Qy:' num2str(qy,'%3.2g') ' Mod_Q: ' num2str(modq,'%3.2g') '  N: ' num2str(pixel_raw_value,format_str) '  I: ' num2str(pixel_value,format_str)];
    else
        text = ['Not over active figure (' num2str(det) ')'];
    end
    
    
elseif strcmp(status_flags.axes.current,'t');
    if co_ord(1,1) >= min(displayimage.(['qmatrix' num2str(det)])(1,:,7)) && co_ord(1,1) <= max(displayimage.(['qmatrix' num2str(det)])(1,:,7)) && co_ord(1,2) >= min(displayimage.(['qmatrix' num2str(det)])(:,1,8)) && co_ord(1,2) <= max(displayimage.(['qmatrix' num2str(det)])(:,1,8))
        x_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,7) - co_ord(1,1));
        [temp, x_index] = min(x_difference);
        y_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,8) - co_ord(1,2));
        [temp, y_index] = min(y_difference);
        pixel_value = displayimage.(['data' num2str(det)])(y_index,x_index);
        pixel_raw_value = displayimage.(['raw_counts' num2str(det)])(y_index,x_index);
        two_theta_x = displayimage.(['qmatrix' num2str(det)])(1,x_index,7); two_theta_y = displayimage.(['qmatrix' num2str(det)])(y_index,1,8);
        mod_two_theta = displayimage.(['qmatrix' num2str(det)])(y_index,x_index,9);
        text = [' 2thx:' num2str(co_ord(1,1),'%3.2g') ' 2thy:' num2str(co_ord(1,2),'%3.2g') ' Mod_2th: ' num2str(mod_two_theta,'%3.2g')  '  N: ' num2str(pixel_raw_value,format_str) '  I: ' num2str(pixel_value,format_str)];
    else
        text = ['Not over active figure (' num2str(det) ')'];
    end
    
end

set(grasp_handles.figure.live_coords,'string',text,'position',position);

