function display_param_list

global inst_params
global grasp_env
global displayimage
global grasp_handles

if ishandle(grasp_handles.window_modules.param_list); delete(grasp_handles.window_modules.param_list); grasp_handles.window_modules.param_list = []; end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2), grasp_env.screen.grasp_main_actual_position(3) grasp_env.screen.grasp_main_actual_position(4)+grasp_env.screen.grasp_main_toolbar_overhead];
grasp_handles.window_modules.param_list = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Data Parameters' ,....
    'NumberTitle', 'off',....
    'Resize','on',....
    'Tag','param_list_window',...
    'color',grasp_env.background_color,....
    'menubar','none',...
    'closerequestfcn','display_param_list_callbacks(''close'');closereq;');    

x1 = 0.01; y1 = 0.95;
column_length = 42; row_spacing = 0.022; column_spacing = 0.33;

row = 1; column =1;
for  n = 1:128
    %Find the text, 'num_str' and 'param_str'
    param_str = inst_params.vector_names{n};
    param_value_str = deblank(num2str(displayimage.params1(n)));
    uicontrol('units','normalized','Position',[(x1+((column-1)*column_spacing)),(y1-((row-1)*row_spacing)),0.04,0.02],'fontname',grasp_env.font,'fontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String',num2str(n),'BackgroundColor', grasp_env.background_color.*[1, 0, 0], 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[(x1+0.05+((column-1)*column_spacing)),(y1-((row-1)*row_spacing)),0.3,0.02],'fontname',grasp_env.font,'fontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text',...
        'String',param_str,'BackgroundColor', grasp_env.background_color*0.9, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[(x1+0.17+((column-1)*column_spacing)),(y1-((row-1)*row_spacing)),0.12,0.02],'fontname',grasp_env.font,'fontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String',param_value_str,'BackgroundColor', grasp_env.background_color*0.9, 'ForegroundColor', [0.95,0.85,0.66]);

    if row > column_length
        row = 1; column = column +1;
    else
        row = row+1;
    end
end

