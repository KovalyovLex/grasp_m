function contour_options_window

global grasp_env
global grasp_handles
global status_flags

%***** Open Contour Options Control Window *****

if ishandle(grasp_handles.window_modules.contour_options.window); delete(grasp_handles.window_modules.contour_options.window); end

fig_position = [grasp_env.screen.grasp_main_actual_position(1), grasp_env.screen.grasp_main_actual_position(2)*0.5,   307*grasp_env.screen.screen_scaling(1)   210*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.contour_options.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Contour Levels',....
    'NumberTitle', 'off',....
    'Tag','contour_options_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','closereq');
handle = grasp_handles.window_modules.contour_options.window;

gx = 0.0; gy = 0.; %Group Positions (normalized);
%Auto contour levels
uicontrol(handle,'units','normalized','Position',[gx+0.1 gy+0.8 0.15 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Auto:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
levels_string = num2str(status_flags.contour.auto_levels(1));
for n = 2:length(status_flags.contour.auto_levels)
    levels_string = [levels_string '|' num2str(status_flags.contour.auto_levels(n))];
end
uicontrol(handle,'units','normalized','Position',[gx+0.45 gy+0.8 0.2 0.11],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','auto_contour_selector','String',levels_string,'Value',status_flags.contour.auto_levels_index,...
    'CallBack','contour_options_callbacks(''contour_auto'');');

%Linear Intervals
uicontrol(handle,'units','normalized','Position',[gx+0.1 gy+0.6 0.15 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Min:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[gx+0.3 gy+0.6 0.15 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Max:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[gx+0.5 gy+0.6 0.20 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Interval:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[gx+0.1 gy+0.5 0.15 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','Tag','min_contour_level','String',num2str(status_flags.contour.contour_min),...
    'callback','contour_options_callbacks(''contour_min'');');
uicontrol(handle,'units','normalized','Position',[gx+0.3 gy+0.5 0.15 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','Tag','max_contour_level','String',num2str(status_flags.contour.contour_max),...
    'callback','contour_options_callbacks(''contour_max'');');
uicontrol(handle,'units','normalized','Position',[gx+0.5 gy+0.5 0.15 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','Tag','contour_interval','String',num2str(status_flags.contour.contour_interval),...
    'callback','contour_options_callbacks(''contour_interval'');');

%Comma separated
uicontrol(handle,'units','normalized','Position',[gx+0.1 gy+0.3 0.45 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Comma Separated:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[gx+0.1 gy+0.2 0.55 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','horizontalalignment','left','Tag','user_defined_contours','String',status_flags.contour.contours_string,...
    'callback','contour_options_callbacks(''contour_string'');');

%Contour selector radiobuttons
if status_flags.contour.current_style == 1; setting = 1;
else setting = 0; end
uicontrol(handle,'units','normalized','Position',[gx+0.8 gy+0.8 0.09 0.1],'ToolTip','','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','Tag','contour_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],...
    'value',setting,'callback','contour_options_callbacks(''radio_buttons'',1);');
if status_flags.contour.current_style == 2; setting = 1;
else setting = 0; end
uicontrol(handle,'units','normalized','Position',[gx+0.8 gy+0.5 0.09 0.1],'ToolTip','','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','Tag','contour_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],...
    'value',setting,'callback','contour_options_callbacks(''radio_buttons'',2);');
if status_flags.contour.current_style == 3; setting = 1;
else setting = 0; end
uicontrol(handle,'units','normalized','Position',[gx+0.8 gy+0.2 0.09 0.1],'ToolTip','','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','Tag','contour_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],...
    'value',setting,'callback','contour_options_callbacks(''radio_buttons'',3);');

%Contour units radiobuttons
uicontrol(handle,'units','normalized','Position',[gx+0 gy+0.05 0.15 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String',['Abs:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[gx+0.3 gy+0.05 0.15 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String',['%:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
if status_flags.contour.percent_abs == 2; setting = 1;
else setting = 0; end
uicontrol(handle,'units','normalized','Position',[gx+0.18 gy+0.07 0.09 0.1],'ToolTip','','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','Tag','contour_units_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],...
    'value',setting,'callback','contour_options_callbacks(''contour_units'',2);');
if status_flags.contour.percent_abs == 1; setting = 1;
else setting = 0; end
uicontrol(handle,'units','normalized','Position',[gx+0.48 gy+0.07 0.09 0.1],'ToolTip','','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','Tag','contour_units_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],...
    'value',setting,'callback','contour_options_callbacks(''contour_units'',1);');

   