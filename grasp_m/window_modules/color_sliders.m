function color_sliders

global grasp_env
global grasp_handles
global status_flags

%***** Open Contour Options Control Window *****

if ishandle(grasp_handles.window_modules.color_sliders.window); delete(grasp_handles.window_modules.color_sliders.window); end

fig_position = [grasp_env.screen.grasp_main_actual_position(1), grasp_env.screen.grasp_main_actual_position(2)*0.5,   307*grasp_env.screen.screen_scaling(1)   210*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.color_sliders.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Color Sliders',....
    'NumberTitle', 'off',....
    'Tag','color_sliders_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','closereq');
handle = grasp_handles.window_modules.color_sliders.window;

    %***** Displayed Color Control *****
    %Color Top slider
    uicontrol(handle,'units','normalized','Position',[0.1,0.88,0.8,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Stretch Top:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'HorizontalAlignment','center');
    grasp_handles.window_modules.color_sliders.top = uicontrol(handle,'units','normalized','Position',[0.1,0.8,0.8,0.06],'ToolTip','Stretch Colour Top','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','slider','Tag','colortop_slider', 'CallBack','color_sliders_callbacks(''stretch_top'');','Value',status_flags.color.top);
    %Color Bottom slider
    uicontrol(handle,'units','normalized','Position',[0.1,0.68,0.8,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Stretch Bottom:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'HorizontalAlignment','center');
    grasp_handles.window_modules.color_sliders.bottom = uicontrol(handle,'units','normalized','Position',[0.1,0.6,0.8,0.06],'ToolTip','Stretch Colour Bottom','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','slider','Tag','colorbottom_slider','CallBack','color_sliders_callbacks(''stretch_bottom'');','Value',status_flags.color.bottom);
    %Color Gamma slider
    uicontrol(handle,'units','normalized','Position',[0.1,0.48,0.8,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Gamma:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'HorizontalAlignment','center');
    grasp_handles.window_modules.color_sliders.gamma = uicontrol(handle,'units','normalized','Position',[0.1,0.4,0.8,0.06],'ToolTip','Stretch Colour Gamma','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','slider','Tag','colorgamma_slider','CallBack','color_sliders_callbacks(''slide_gamma'');','Value',status_flags.color.gamma);
    %Color Reset
    grasp_handles.window_modules.color_sliders.reset = uicontrol(handle,'units','normalized','Position',[0.3,0.1,0.4,0.1],'ToolTip','Reset Colour Palette','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Reset Colour','HorizontalAlignment','center','Tag','color_reset','Visible','on','CallBack','color_sliders_callbacks(''reset'');');


    