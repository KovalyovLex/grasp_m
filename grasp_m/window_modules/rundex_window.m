function rundex_window

global grasp_env
global grasp_handles

%***** Open Rundex Window *****

if ishandle(grasp_handles.window_modules.rundex.window); delete(grasp_handles.window_modules.rundex.window); end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   265*grasp_env.screen.screen_scaling(1)   192*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.rundex.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Rundex' ,....
    'NumberTitle', 'off',....
    'Tag','rundex_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','rundex_callbacks(''close'');closereq;');

%Numor1
uicontrol('units','normalized','Position',[0.05 0.8 0.5 0.10],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Numor1:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.rundex.numor1 = uicontrol('units','normalized','Position',[0.6 0.8 0.3 0.10],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','000000','HorizontalAlignment','left','Tag','rundex_numor1','Visible','on');
%Numor2
uicontrol('units','normalized','Position',[0.05 0.65 0.5 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Numor2:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.rundex.numor2 = uicontrol('units','normalized','Position',[0.6 0.65 0.3 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','000000','HorizontalAlignment','left','Tag','rundex_numor2','Visible','on');
%Numor Skip
uicontrol('units','normalized','Position',[0.05 0.5 0.5 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Skip:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.rundex.skip = uicontrol('units','normalized','Position',[0.6 0.5 0.3 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','rundex_skip','Visible','on');
%Params
uicontrol('units','normalized','Position',[0.05 0.35 0.5 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Additional Params:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.rundex.params = uicontrol('units','normalized','Position',[0.6 0.35 0.3 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','rundex_params','Visible','on');

uicontrol('units','normalized','Position',[0.15 0.1 0.3 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Do_It!','HorizontalAlignment','center','Tag','rundex_doit','Visible','on',...
    'CallBack','rundex_callbacks(''rundex'');');

uicontrol('units','normalized','Position',[0.55 0.1 0.3 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Param List!','HorizontalAlignment','center',...
    'Tag','param_list_button','Visible','on','CallBack','display_param_list','enable','on');


















