function sector_window

global grasp_env
global grasp_handles
global status_flags

%***** Open Sector Window *****

if ishandle(grasp_handles.window_modules.sector.window); delete(grasp_handles.window_modules.sector.window); end

fig_position = [grasp_env.screen.grasp_main_actual_position(1), grasp_env.screen.grasp_main_actual_position(2)*0.5,   265*grasp_env.screen.screen_scaling(1)   312*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.sector.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Sectors' ,....
    'NumberTitle', 'off',....
    'Tag','sector_window',...
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','sector_callbacks(''close'');closereq');

handle = grasp_handles.window_modules.sector.window;

%Inner radius
uicontrol(handle,'units','normalized','Position',[0.07,0.85,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Inner Radius:','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.sector.inner_radius = uicontrol(handle,'units','normalized','Position',[0.35,0.85,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.sectors.inner_radius),'HorizontalAlignment','left','Visible','on','CallBack','sector_callbacks(''inner_radius'');');

%Outer Radius
uicontrol(handle,'units','normalized','Position',[0.07,0.73,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Outer Radius:','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.sector.outer_radius = uicontrol(handle,'units','normalized','Position',[0.35,0.73,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.sectors.outer_radius),'HorizontalAlignment','left','Visible','on','CallBack','sector_callbacks(''outer_radius'');');

%Theta
uicontrol(handle,'units','normalized','Position',[0.07,0.54,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Theta:','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.sector.theta = uicontrol(handle,'units','normalized','Position',[0.35,0.54,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.sectors.theta),'HorizontalAlignment','left','Visible','on','CallBack','sector_callbacks(''theta'');');

%Delta Theta
uicontrol(handle,'units','normalized','Position',[0.07,0.42,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','DeltaTheta:','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.sector.delta_theta = uicontrol(handle,'units','normalized','Position',[0.35,0.42,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.sectors.delta_theta),'HorizontalAlignment','left','Tag','sector_deltatheta','Visible','on','CallBack','sector_callbacks(''delta_theta'');');

%Anisotropy & Anisotropy angle
enable = 'off';
uicontrol(handle,'units','normalized','Position',[0.07,0.26,0.25,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Anisotropy:','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.sector.anisotropy = uicontrol(handle,'units','normalized','Position',[0.35,0.26,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.sectors.anisotropy),'HorizontalAlignment','left','Visible','on','CallBack','sector_callbacks(''anisotropy'');','enable',enable);
uicontrol(handle,'units','normalized','Position',[0.53,0.26,0.15,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Angle:','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.sector.anisotropy_angle = uicontrol(handle,'units','normalized','Position',[0.7,0.26,0.16,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.sectors.anisotropy_angle),'HorizontalAlignment','left','Visible','on','CallBack','sector_callbacks(''anisotropy_angle'');','enable',enable);


%Quick Angles +30 +45 +60 +90
uicontrol(handle,'units','normalized','Position',[0.55,0.58,0.1,0.06],'string','+30','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','sector_theta_plus30','Visible','on','Value',0,...
    'CallBack','sector_callbacks(''angle_plus'',30);');
uicontrol(handle,'units','normalized','Position',[0.67,0.58,0.1,0.06],'string','+45','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','sector_theta_plus45','Visible','on','Value',0,...
    'CallBack','sector_callbacks(''angle_plus'',45);');
uicontrol(handle,'units','normalized','Position',[0.55,0.50,0.1,0.06],'string','+60','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','sector_theta_plus60','Visible','on','Value',0,...
    'CallBack','sector_callbacks(''angle_plus'',60);');
uicontrol(handle,'units','normalized','Position',[0.67,0.50,0.1,0.06],'string','+90','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','sector_theta_plus90','Visible','on','Value',0,...
    'CallBack','sector_callbacks(''angle_plus'',90);');

%Mirror Sectors
number_of_sectors_string = '1';
for n = 2:status_flags.analysis_modules.sectors.mirror_sectors_max
    number_of_sectors_string = [number_of_sectors_string '|' num2str(n)];
end
uicontrol(handle,'units','normalized','Position',[0.65, 0.9,0.3,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Mirror Sectors:','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.sector.mirror_sectors = uicontrol(handle,'units','normalized','Position',[0.7,0.85,0.25,0.06],'HorizontalAlignment','center','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','number_of_sectors',...
    'String',number_of_sectors_string,'CallBack','sector_callbacks(''mirror_sectors'');','Value',status_flags.analysis_modules.sectors.mirror_sectors);

%Sector Plotting Colour
sector_color_list_string = {'(none)','white','black','red','green','blue','cyan','magenta','yellow'};
uicontrol(handle,'units','normalized','Position',[0.65,0.75,0.3,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Sector Colour:','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1]);
for n = 1:length(sector_color_list_string);
    if strcmp(status_flags.analysis_modules.sectors.sector_color,sector_color_list_string{n})
        value = n;
    end
end
grasp_handles.window_modules.sector.sector_color = uicontrol(handle,'units','normalized','Position',[0.7,0.68,0.25,0.08],'HorizontalAlignment','center','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','sector_colour',...
    'String',sector_color_list_string,'CallBack','sector_callbacks(''color'');','Value',value);

%********* Sector Analysis Buttons *********
%Averaging, Radial and azimuthal
uicontrol(handle,'units','normalized','Position',[0.525,0.1,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Averaging','HorizontalAlignment','center','Tag','boxfox_button','Visible','on','CallBack','sector_callbacks(''radial_average'');');
%Sector Box
uicontrol(handle,'units','normalized','Position', [0.2,0.1,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Sector Boxes','HorizontalAlignment','center','Tag','sectfoxbutton','Visible','on','CallBack','sector_box_window','enable','on');

%Refresh & draw the sectors
sector_callbacks;
