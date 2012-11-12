function color_sliders_callbacks(todo)

global status_flags
global grasp_handles

switch todo
    
    case 'stretch_top'
        status_flags.color.top = get(gcbo,'value');
        
    case 'stretch_bottom'
        status_flags.color.bottom = get(gcbo,'value');
        
    case 'slide_gamma'
        status_flags.color.gamma = get(gcbo,'value');
        
    case 'reset'
        status_flags.color.top = 1;
        status_flags.color.bottom = 0;
        status_flags.color.gamma = 0.33;
        
        set(grasp_handles.window_modules.color_sliders.top,'value', status_flags.color.top);
        set(grasp_handles.window_modules.color_sliders.bottom,'value', status_flags.color.bottom);
        set(grasp_handles.window_modules.color_sliders.gamma,'value', status_flags.color.gamma);
        
end

%Apply new colormap
set_colormap


