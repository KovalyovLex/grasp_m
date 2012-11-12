function axis_lims = current_axis_limits(limits)

%Returns the current axis limits in all options, pixels, q and 2theta
%for all detectors
%Output structure looks like:   axis_lims.det1.pixels
%                                        .det1.q
%                                        .det1.theta2

global grasp_handles
global status_flags
global displayimage
global inst_params


axis_lims = [];
current_axis_units = status_flags.axes.current;

%loop though the detectors
for det = 1:inst_params.detectors
    if nargin ==0;
    %Retrieve current axis limits from axis
    xlims = get(grasp_handles.displayimage.(['axis' num2str(det)]),'xlim');
    ylims = get(grasp_handles.displayimage.(['axis' num2str(det)]),'ylim');
    else
        xlims = limits(1:2);
        ylims = limits(3:4);
    end
    
    %Now re-convert the given axis limits back to all units, pixels, q, 2theta
    if strcmp(current_axis_units,'p');
        x1_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,1) - xlims(1));
        [temp, x1_index] = min(x1_difference);
        x2_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,1) - xlims(2));
        [temp, x2_index] = min(x2_difference);
        
        y1_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,2) - ylims(1));
        [temp, y1_index] = min(y1_difference);
        y2_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,2) - ylims(2));
        [temp, y2_index] = min(y2_difference);
        
    elseif strcmp(current_axis_units,'q');
        x1_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,3) - xlims(1));
        [temp, x1_index] = min(x1_difference);
        x2_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,3) - xlims(2));
        [temp, x2_index] = min(x2_difference);
        
        y1_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,4) - ylims(1));
        [temp, y1_index] = min(y1_difference);
        y2_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,4) - ylims(2));
        [temp, y2_index] = min(y2_difference);
        
    elseif strcmp(current_axis_units,'t');
        x1_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,7) - xlims(1));
        [temp, x1_index] = min(x1_difference);
        x2_difference = abs(displayimage.(['qmatrix' num2str(det)])(1,:,7) - xlims(2));
        [temp, x2_index] = min(x2_difference);
        
        y1_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,8) - ylims(1));
        [temp, y1_index] = min(y1_difference);
        y2_difference = abs(displayimage.(['qmatrix' num2str(det)])(:,1,8) - ylims(2));
        [temp, y2_index] = min(y2_difference);
    end
    
    axis_lims.(['det' num2str(det)]).pixels = [displayimage.(['qmatrix' num2str(det)])(1,x1_index,1), displayimage.(['qmatrix' num2str(det)])(1,x2_index,1), displayimage.(['qmatrix' num2str(det)])(y1_index,1,2), displayimage.(['qmatrix' num2str(det)])(y2_index,1,2)];
    axis_lims.(['det' num2str(det)]).q = [displayimage.(['qmatrix' num2str(det)])(1,x1_index,3), displayimage.(['qmatrix' num2str(det)])(1,x2_index,3), displayimage.(['qmatrix' num2str(det)])(y1_index,1,4), displayimage.(['qmatrix' num2str(det)])(y2_index,1,4)];;
    axis_lims.(['det' num2str(det)]).theta2 = [displayimage.(['qmatrix' num2str(det)])(1,x1_index,7), displayimage.(['qmatrix' num2str(det)])(1,x2_index,7), displayimage.(['qmatrix' num2str(det)])(y1_index,1,8), displayimage.(['qmatrix' num2str(det)])(y2_index,1,8)];;
        
end


