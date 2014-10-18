function strips_window

global grasp_env
global grasp_handles
global status_flags

%***** Open Strip Window *****
if ishandle(grasp_handles.window_modules.strips.window); delete(grasp_handles.window_modules.strips.window); end

fig_position = [grasp_env.screen.grasp_main_actual_position(1), grasp_env.screen.grasp_main_actual_position(2)*0.5,   265*grasp_env.screen.screen_scaling(1)   312*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.strips.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Strips' ,....
    'NumberTitle', 'off',....
    'Tag','strips_window',...
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','strips_callbacks(''close'');closereq');

handle = grasp_handles.window_modules.strips.window;

%Strip Centre
uicontrol(handle,'units','normalized','Position',[0.02,0.85,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Strip Centre:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.strips.strip_cx = uicontrol(handle,'units','normalized','Position',[0.30,0.85,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',0,'HorizontalAlignment','left','Tag','strip_centre_x','Visible','on','CallBack','strips_callbacks(''strip_cx'');');
grasp_handles.window_modules.strips.strip_cy = uicontrol(handle,'units','normalized','Position',[0.47,0.85,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',0,'HorizontalAlignment','left','Tag','strip_centre_y','Visible','on','CallBack','strips_callbacks(''strip_cy'');');
uicontrol(handle,'units','normalized','Position',[0.7,0.85,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Grab Beam Centre','HorizontalAlignment','center','Tag','strip_grab_cm','Visible','on',...
    'CallBack','strips_callbacks(''grab_cm'');');

%Strip Theta
uicontrol(handle,'units','normalized','Position',[0.02,0.54,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Theta:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.strips.strip_theta = uicontrol(handle,'units','normalized','Position',[0.3,0.54,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.strips.theta),'HorizontalAlignment','left','Tag','strip_angle','Visible','on','CallBack','strips_callbacks(''strip_theta'');');

%Quick Angles
uicontrol(handle,'units','normalized','Position',[0.50,0.58,0.1,0.06],'string','+30','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','strip_theta_plus30','Visible','on','Value',0,...
    'CallBack','strips_callbacks(''angle_plus'',30);');
uicontrol(handle,'units','normalized','Position',[0.62,0.58,0.1,0.06],'string','+45','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','strip_theta_plus45','Visible','on','Value',0,...
    'CallBack','strips_callbacks(''angle_plus'',45);');
uicontrol(handle,'units','normalized','Position',[0.50,0.50,0.1,0.06],'string','+60','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','strip_theta_plus60','Visible','on','Value',0,...
    'CallBack','strips_callbacks(''angle_plus'',60);');
uicontrol(handle,'units','normalized','Position',[0.62,0.50,0.1,0.06],'string','+90','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','strip_theta_plus90','Visible','on','Value',0,...
    'CallBack','strips_callbacks(''angle_plus'',90);');

%Strip Dimensions
default_length = 20; default_width = 5;
if isempty(status_flags.analysis_modules.strips.length);  status_flags.analysis_modules.strips.length = default_length; end
if isempty(status_flags.analysis_modules.strips.width);  status_flags.analysis_modules.strips.width = default_width; end

uicontrol(handle,'units','normalized','Position',[0.02,0.73,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Strip Dim:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.strips.strip_length = uicontrol(handle,'units','normalized','Position',[0.3,0.73,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.strips.length),'HorizontalAlignment','left','Tag','strip_dim_x','Visible','on','CallBack','strips_callbacks(''strip_length'');');
grasp_handles.window_modules.strips.strip_width = uicontrol(handle,'units','normalized','Position',[0.47,0.73,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.strips.width),'HorizontalAlignment','left','Tag','strip_dim_y','Visible','on','CallBack','strips_callbacks(''strip_width'');');

%Strip Plotting Colour
strip_color_list_string = {'(none)','white','black','red','green','blue','cyan','magenta','yellow'};
for n = 1:length(strip_color_list_string);
    if strcmp(status_flags.analysis_modules.strips.strips_color,strip_color_list_string{n})
        value = n;
    end
end
uicontrol(handle,'units','normalized','Position',[0.65,0.75,0.3,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Strip Colour:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.strips.strip_color = uicontrol(handle,'units','normalized','Position',[0.7,0.68,0.25,0.08],'HorizontalAlignment','right','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','strip_colour',...
    'String',strip_color_list_string,'CallBack','strips_callbacks(''strip_color'');','Value',value);

%Show strip mask checkbox
grasp_handles.window_modules.strips.plot_strip_mask = uicontrol(handle,'units','normalized','Position',[0.3,0.34,0.3,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Plot Strip Mask','HorizontalAlignment','center','Visible','on','CallBack','strips_callbacks(''plot_strip_mask'');');



%********* Strip Analysis Buttons *********
%I vs Pixel
uicontrol(handle,'units','normalized','Position',[0.2,0.18,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','I vs. Pixel','HorizontalAlignment','center','Tag','strip_i_parallel','Visible','on','CallBack','strips_callbacks(''i_strip'');');
%Averaging, Radial and azimuthal
uicontrol(handle,'units','normalized','Position',[0.525,0.18,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Averaging','HorizontalAlignment','center','Tag','boxfox_button','Visible','on','CallBack','strips_callbacks(''radial_average'');');
%I vs TwoTheta_x
uicontrol(handle,'units','normalized','Position',[0.2,0.10,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','I vs. 2ThX','HorizontalAlignment','center','Tag','strip_i_2thx','Visible','on','CallBack','strips_callbacks(''i_2thx'');');
%I vs TwoTheta_y
uicontrol(handle,'units','normalized','Position',[0.525,0.10,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','I vs. 2ThY','HorizontalAlignment','center','Tag','strip_i_2thy','Visible','on','CallBack','strips_callbacks(''i_2thy'');');
%I vs Mod TwoTheta_x
uicontrol(handle,'units','normalized','Position',[0.2,0.02,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','I vs. |2ThX|','HorizontalAlignment','center','Tag','strip_i_2thx','Visible','on','CallBack','strips_callbacks(''i_mod_2thx'');');
%I vs Mod TwoTheta_y
uicontrol(handle,'units','normalized','Position',[0.525,0.02,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','I vs. |2ThY|','HorizontalAlignment','center','Tag','strip_i_2thy','Visible','on','CallBack','strips_callbacks(''i_mod_2thy'');');



strips_callbacks;


