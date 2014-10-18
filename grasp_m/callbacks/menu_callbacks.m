function menu_callbacks(to_do,option)

global status_flags
global grasp_handles
global inst_params

switch to_do
    
    case 'show_minor_detectors'
        if strcmp(status_flags.display.show_minor_detectors,'off');
            status_flags.display.show_minor_detectors = 'on';
            set(gcbo,'checked','on')
        else
            status_flags.display.show_minor_detectors = 'off';
            set(gcbo,'checked','off')
        end
        grasp_update
        
    
    case 'graphic_update'
        status_flags.display.refresh = not(status_flags.display.refresh);
        update_menus;
        
    case 'parameter_display'
        status_flags.command_window.display_params = not(status_flags.command_window.display_params); %Turn off the 2D display for speed
        update_menus;
        
    case 'image_render'
        status_flags.display.render = option;
        grasp_update;
        
    case 'palette'
        status_flags.color.map = option;
        set_colormap;
        update_menus

    case 'color_invert'
        if status_flags.color.invert == 1;
            status_flags.color.invert = 0;
            set(grasp_handles.menu.display.colormap.invert,'checked','off');
        else
            status_flags.color.invert = 1;
            set(grasp_handles.menu.display.colormap.invert,'checked','on');
        end
        set_colormap
        
    case 'color_swap'
        if status_flags.color.swap == 1;
            status_flags.color.swap = 0;
            set(grasp_handles.menu.display.colormap.swap,'checked','off');
        else
            status_flags.color.swap = 1;
            set(grasp_handles.menu.display.colormap.swap,'checked','on');
        end
        set_colormap

     case 'z_scale'
         status_flags.display.zscale = option;
         if not(strcmp(option,'Z'));
             %replace Log Z button with other scaling option
             str = [' : ' option];
             set(grasp_handles.figure.logz_string,'string',str);
             status_flags.display.log = 1; %i.e. switch on the newly selected option
         else
             status_flags.display.log = not(status_flags.display.log); 
         end
         grasp_update
         
%     case 'palette'
%         status_flags.color.map = get(gcbo,'label');
%         palette_mod;
% 
%     case 'palette_invert'
%         status_flags.color.invert = not(status_flags.color.invert);
%         if status_flags.color.invert ==1;
%             set(gcbo,'checked','on');
%         else
%             set(gcbo,'checked','off');
%         end
%         palette_mod;

    case 'palette_swap'
        status_flags.color.swap = not(status_flags.color.swap);
        if status_flags.color.swap ==1;
            set(gcbo,'checked','on');
        else
            set(gcbo,'checked','off');
        end
        palette_mod;

    case 'contour_color'
        status_flags.contour.color = get(gcbo,'userdata');
        status_flags.display.contour = 1; %Switch on contours
        grasp_update

    case 'square_zoom'
        active_axis = status_flags.display.active_axis;
        pixel_size = inst_params.(['detector' num2str(active_axis)]).pixel_size; %[x, y]
        ax = axis(grasp_handles.displayimage.(['axis' num2str(active_axis)]));
%        width(1) = ax(2)-ax(1);width(2) = ax(4)-ax(3);wmax = max(width);
        width(1) = (ax(2)-ax(1))*pixel_size(1); %mm
        width(2) = (ax(4)-ax(3))*pixel_size(2); %mm
        wmax = max(width); %Take the largest mm
        xdif = (wmax - width(1))/pixel_size(1);ydif = (wmax - width(2))/pixel_size(2);
        new_axis = ([ax(1)-(xdif/2),ax(2)+(xdif/2),ax(3)-(ydif/2),ax(4)+(ydif/2)]);
        axis(grasp_handles.displayimage.(['axis' num2str(active_axis)]),new_axis);

    case 'show_hide_title'
        status_flags.display.title = not(status_flags.display.title);
        if status_flags.display.title ==1; status = 'on'; else status = 'off'; end
        set(grasp_handles.figure.subtitle ,'visible',status);
        set(grasp_handles.menu.display.showtitle, 'checked',status);
        
    case 'show_color_bar'
        status_flags.display.colorbar = not(status_flags.display.colorbar);
        if status_flags.display.colorbar ==1; visible ='on'; else visible = 'off'; end
        set(grasp_handles.displayimage.colorbar,'visible',visible);
        %Colorbar tick
        if status_flags.display.colorbar == 1; status = 'on'; else status = 'off'; end
        set(grasp_handles.menu.display.showcolorbar,'checked',status);
        
    case 'show_graph_axes'
        status_flags.display.axes = not(status_flags.display.axes);
        grasp_update
        
    case 'show_axis_box'
        status_flags.display.axis_box = not(status_flags.display.axis_box);
        if status_flags.display.axis_box == 1; box_status = 'on'; else box_status = 'off'; end
        for det = 1:inst_params.detectors;
            set(grasp_handles.displayimage.(['axis' num2str(det)]),'box',box_status);
        end
        %Axis box tick
        set(grasp_handles.menu.display.axis_box,'checked',box_status);
        
    case 'flip_ud'
        status_flags.display.flipud = not(status_flags.display.flipud);
        grasp_update

    case 'flip_lr'
        status_flags.display.fliplr = not(status_flags.display.fliplr);
        grasp_update
        
    case 'smooth_kernel'
        status_flags.display.smooth.kernel =get(gcbo,'label');
        status_flags.display.smooth.kerneldata = get(gcbo,'userdata');
        status_flags.display.smooth.check = 1; %Switch on smoothing
        grasp_update
        
    case 'qsetup_det'
        status_flags.q.det = option;
        grasp_update
        
    case 'algorithm'
        status_flags.algorithm = option;
        grasp_update
        

        
        
        
end
