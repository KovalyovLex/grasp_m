function tool_callbacks(to_do,option)

global status_flags
global grasp_handles
global displayimage
global inst_params

if nargin<2; option = []; end

figure(grasp_handles.figure.grasp_main)


switch to_do
    
    case 'toggle_image_render'
        if strcmp(status_flags.display.render,'flat');
            status = 'interp';
        elseif strcmp(status_flags.display.render,'interp');
            status = 'faceted';
        elseif strcmp(status_flags.display.render,'faceted');
            status = 'flat';
        end
        menu_callbacks('image_render',status);

    case 'pan'
        pan(grasp_handles.figure.grasp_main);
        
    case 'rescale'
        
        %Find which detector plot to rescale
        temp = get(gca,'userdata');
        if isfield(temp,'detector');
            det = temp.detector;
        else
            return
        end
        
        %Determine max coordinates from the q_matrix
        if strcmp(status_flags.axes.current,'p')
            xmin = min(displayimage.(['qmatrix' num2str(det)])(1,:,1)); xmax = max(displayimage.(['qmatrix' num2str(det)])(1,:,1));
            ymin = min(displayimage.(['qmatrix' num2str(det)])(:,1,2)); ymax = max(displayimage.(['qmatrix' num2str(det)])(:,1,2));
        elseif strcmp(status_flags.axes.current,'q')
            xmin = min(displayimage.(['qmatrix' num2str(det)])(1,:,3)); xmax = max(displayimage.(['qmatrix' num2str(det)])(1,:,3));
            ymin = min(displayimage.(['qmatrix' num2str(det)])(:,1,4)); ymax = max(displayimage.(['qmatrix' num2str(det)])(:,1,4));
        elseif strcmp(status_flags.axes.current,'t')
            xmin = min(displayimage.(['qmatrix' num2str(det)])(1,:,7)); xmax = max(displayimage.(['qmatrix' num2str(det)])(1,:,7));
            ymin = min(displayimage.(['qmatrix' num2str(det)])(:,1,8)); ymax = max(displayimage.(['qmatrix' num2str(det)])(:,1,8));
        end
        zoomed_out_axis = [xmin,xmax,ymin,ymax];
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),zoomed_out_axis);
        zoom(grasp_handles.figure.grasp_main,'reset');
        view(2);
        
    case 'manual_scale'
        
        %Find which detector plot to rescale
        temp = get(gca,'userdata');
        if isfield(temp,'detector');
            det = temp.detector;
        else
            return
        end
        
        old_axis_lim = axis(grasp_handles.displayimage.(['axis' num2str(det)]));
        new_axis_lim=inputdlg(({'x_min','x_max','y_min','y_max'}),'Enter Axes Limits',[1],{num2str(old_axis_lim(1)),num2str(old_axis_lim(2)),num2str(old_axis_lim(3)),num2str(old_axis_lim(4))});
        if not(isempty(new_axis_lim));
            xmin = str2num(new_axis_lim{1});
            xmax = str2num(new_axis_lim{2});
            ymin = str2num(new_axis_lim{3});
            ymax = str2num(new_axis_lim{4});
            if isempty(xmin) | isempty(xmax) | isempty(ymin) | isempty(ymax)
                beep
                disp('Please Enter Sensible (i.e. Numeric) Axis Limits!');
                return
            end
            %if xmin <1; xmin = 1; end
            %if xmax > inst_params.det_size(1); xmax = inst_params.det_size(1); end
            %if ymin <1; ymin =1; end
            %if ymax > inst_params.det_size(2); ymax = inst_params.det_size(2); end
            axis(grasp_handles.displayimage.(['axis' num2str(det)]),[xmin,xmax,ymin,ymax]);
        end
        
    case 'poke_scale'
        %Find which detector plot to rescale
        temp = get(gca,'userdata');
        if isfield(temp,'detector');
            det = temp.detector;
        else
            return
        end
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),option);

        
    case 'pixel_q_axes'
        %Rescale axis according to axis change
        axis_lims = current_axis_limits;
        
        %Toggle the current_axis type , p > q > t
        if strcmp(status_flags.axes.current,'p');
            if sum((abs(axis_lims.det1.q))) ~=0
                status_flags.axes.current = 'q';
            else
                status_flags.axes.current = 'p';
            end
        elseif strcmp(status_flags.axes.current,'q')
            if sum(abs(axis_lims.det1.theta2)) ~=0
                status_flags.axes.current = 't';
            else
                status_flags.axes.current = 'p';
            end
        elseif strcmp(status_flags.axes.current,'t')
            status_flags.axes.current = 'p';
        end
        
        for det = 1:inst_params.detectors
            
            if strcmp(status_flags.axes.current,'p');
                new_axis_lims = axis_lims.(['det' num2str(det)]).pixels;
                %Error check for non increasing axis limits eg. [1 1 1 1]
                if new_axis_lims(1) == new_axis_lims(2);
                    new_axis_lims(1) = 1;
                    new_axis_lims(2) = inst_params.(['detector' num2str(det)]).pixels(1);
                end
                if new_axis_lims(3) == new_axis_lims(4);
                    new_axis_lims(3) = 1;
                    new_axis_lims(4) = inst_params.(['detector' num2str(det)]).pixels(2);
                end
            elseif strcmp(status_flags.axes.current,'q')
                new_axis_lims = axis_lims.(['det' num2str(det)]).q;
            elseif strcmp(status_flags.axes.current,'t')
                new_axis_lims = axis_lims.(['det' num2str(det)]).theta2;
            end
            
            %Error check for non increasing axis limits, eg. [1 1 1 1]
            if new_axis_lims(1) == new_axis_lims(2);
                new_axis_lims(1) = new_axis_lims(1)-eps; 
                new_axis_lims(2) = new_axis_lims(2)+eps;
            end
            if new_axis_lims(3) == new_axis_lims(4);
                new_axis_lims(3) = new_axis_lims(3)-eps; 
                new_axis_lims(4) = new_axis_lims(4)+eps;
            end
            
            axis(grasp_handles.displayimage.(['axis' num2str(det)]),new_axis_lims);
            %zoom(grasp_handles.figure.grasp_main,'reset');
        end
        grasp_update
        
end
