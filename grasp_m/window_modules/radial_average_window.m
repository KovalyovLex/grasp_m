function radial_average_window


global grasp_env
global grasp_handles
global status_flags


%***** Open Radial Average Window Window *****

if isfield(grasp_handles.window_modules.radial_average,'window')
    if ishandle(grasp_handles.window_modules.radial_average.window);
        delete(grasp_handles.window_modules.radial_average.window);
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   265*grasp_env.screen.screen_scaling(1)   312*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.radial_average.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Averaging',....
    'NumberTitle', 'off',....
    'Tag','radialav_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','radial_average_callbacks(''close'');closereq;');

handle = grasp_handles.window_modules.radial_average.window;

%Radial Average I vs. q Button & Bin
grasp_handles.figure.window_modules.radial_average.q_bin_context.root = uicontextmenu;
uicontrol(handle,'units','normalized','Position',[0.05 0.85 0.3 0.05],'tooltip','Perform ''Radial Average'' : I vs. |q|','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','I vs. |q|','HorizontalAlignment','center','Tag','i_q_button','Visible','on','CallBack','radial_average_callbacks(''averaging_control'',''radial_q'');',....
    'uicontextmenu',grasp_handles.figure.window_modules.radial_average.q_bin_context.root);
grasp_handles.figure.window_modules.radial_average.q_bin_context.pixels = uimenu(grasp_handles.figure.window_modules.radial_average.q_bin_context.root,'label','Pixels','callback','radial_average_callbacks(''q_bin_pixels'');');
grasp_handles.figure.window_modules.radial_average.q_bin_context.absolute.root = uimenu(grasp_handles.figure.window_modules.radial_average.q_bin_context.root,'label','Absolute');
grasp_handles.figure.window_modules.radial_average.q_bin_context.absolute.linear = uimenu(grasp_handles.figure.window_modules.radial_average.q_bin_context.absolute.root,'label','Linear','callback','radial_average_callbacks(''q_bin_absolute'',''linear'');');
grasp_handles.figure.window_modules.radial_average.q_bin_context.absolute.log10 = uimenu(grasp_handles.figure.window_modules.radial_average.q_bin_context.absolute.root,'label','Log10','callback','radial_average_callbacks(''q_bin_absolute'',''log10'');');
grasp_handles.figure.window_modules.radial_average.q_bin_context.resolution = uimenu(grasp_handles.figure.window_modules.radial_average.q_bin_context.root,'label','Resolution','callback','radial_average_callbacks(''q_bin_resolution'');');

grasp_handles.window_modules.radial_average.q_bin_text = uicontrol(handle,'units','normalized','Position',[0.4 0.85 0.35 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Radial Bin (pxl):','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.radial_average.q_bin = uicontrol(handle,'units','normalized','Position',[0.8 0.85 0.16 0.06],'tooltip','Re-Bin Size in the Radial Direction (pixels)','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','center','Tag','radial_bin','Visible','on','callback','radial_average_callbacks(''q_bin'');');

%Radial Average I vs. |2Theta| Button & Bin
grasp_handles.figure.window_modules.radial_average.theta_bin_context.root = uicontextmenu;
uicontrol(handle,'units','normalized','Position',[0.05 0.73 0.3 0.05],'tooltip','Perform ''Radial Average'' : I vs. |2th|','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','I vs. |2th|','HorizontalAlignment','center','Tag','i_2theta_button','Visible','on','CallBack','radial_average_callbacks(''averaging_control'',''radial_theta'');',....
    'uicontextmenu',grasp_handles.figure.window_modules.radial_average.theta_bin_context.root);
grasp_handles.figure.window_modules.radial_average.theta_bin_context.pixels = uimenu(grasp_handles.figure.window_modules.radial_average.theta_bin_context.root,'label','Pixels','callback','radial_average_callbacks(''theta_bin_pixels'');');
grasp_handles.figure.window_modules.radial_average.theta_bin_context.absolute.root = uimenu(grasp_handles.figure.window_modules.radial_average.theta_bin_context.root,'label','Absolute');
grasp_handles.figure.window_modules.radial_average.theta_bin_context.absolute.linear = uimenu(grasp_handles.figure.window_modules.radial_average.theta_bin_context.absolute.root,'label','Linear','callback','radial_average_callbacks(''theta_bin_absolute'',''linear'');');
grasp_handles.figure.window_modules.radial_average.theta_bin_context.absolute.log10 = uimenu(grasp_handles.figure.window_modules.radial_average.theta_bin_context.absolute.root,'label','Log10','callback','radial_average_callbacks(''theta_bin_absolute'',''log10'');');
grasp_handles.figure.window_modules.radial_average.theta_bin_context.resolution = uimenu(grasp_handles.figure.window_modules.radial_average.theta_bin_context.root,'label','Resolution','callback','radial_average_callbacks(''theta_bin_resolution'');');

grasp_handles.window_modules.radial_average.theta_bin_text = uicontrol(handle,'units','normalized','Position',[0.4 0.73 0.35 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Radial Bin (pxl):','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.radial_average.theta_bin = uicontrol(handle,'units','normalized','Position',[0.8 0.73 0.16 0.06],'tooltip','Re-Bin Size in the Radial Direction (pixels)','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','center','Tag','radial_bin_2theta','Visible','on','callback','radial_average_callbacks(''averaging_control'',''theta_bin'');');

%Asimuthal Average Button & Bin
grasp_handles.figure.window_modules.radial_average.azimuth_bin_context.root = uicontextmenu;
uicontrol(handle,'units','normalized','Position',[0.05 0.61 0.3 0.05],'tooltip','Perform ''Azimuthal Average'' : I vs. xi Around the Detector','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','I vs. xi','HorizontalAlignment','center','Tag','i_theta_button','Visible','on','CallBack','radial_average_callbacks(''averaging_control'',''azimuthal'');',....
    'uicontextmenu',grasp_handles.figure.window_modules.radial_average.azimuth_bin_context.root);
grasp_handles.figure.window_modules.radial_average.azimuth_bin_context.absolute = uimenu(grasp_handles.figure.window_modules.radial_average.azimuth_bin_context.root,'label','Absolute','callback','radial_average_callbacks(''azimuth_bin_absolute'');');
%grasp_handles.figure.window_modules.radial_average.azimuth_bin_context.smart = uimenu(grasp_handles.figure.window_modules.radial_average.azimuth_bin_context.root,'label','Smart','callback','radial_average_callbacks(''azimuth_bin_smart'');');
grasp_handles.window_modules.radial_average.azimuth_bin_text = uicontrol(handle,'units','normalized','Position',[0.4 0.61 0.35 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Smart Angle Bin (deg):','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.radial_average.azimuth_bin = uicontrol(handle,'units','normalized','Position',[0.8 0.61 0.16 0.06],'tooltip','Re-Bin Size in Angle (degrees).  Note: Min Value Depends on the Sector Minimum Radius','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','2','HorizontalAlignment','center','Tag','angular_bin','Visible','on','callback','radial_average_callbacks(''azimuth_bin'');');

%Use Sector Mask.
uicontrol(handle,'units','normalized','Position',[0.25 0.49 0.5 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Use Sector Mask:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.radial_average.sector_mask_chk = uicontrol(handle,'units','normalized','Position',[0.9 0.49 0.068 0.06],'tooltip','Use Data Defined by Sector','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','sect_mask_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],....
    'value',status_flags.analysis_modules.radial_average.sector_mask_chk,....
    'callback','radial_average_callbacks(''sector_mask_chk'');');

%Use Strip Mask.
uicontrol(handle,'units','normalized','Position',[0.25 0.39 0.5 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Use Strip Mask:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.radial_average.strip_mask_chk = uicontrol(handle,'units','normalized','Position',[0.9 0.39 0.068 0.06],'tooltip','Use Data Defined by Strip','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','strip_mask_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],....
    'value',status_flags.analysis_modules.radial_average.strip_mask_chk,....
    'callback','radial_average_callbacks(''strip_mask_chk'');');

% %Use Ellipse Mask.
% uicontrol(handle,'units','normalized','Position',[0.25 0.29 0.5 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Use Ellipse Mask:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
% grasp_handles.window_modules.radial_average.ellipse_mask_chk = uicontrol(handle,'units','normalized','Position',[0.9 0.29 0.068 0.06],'tooltip','Use Data Defined by Ellipse','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','ellipse_mask_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],....
%     'value',status_flags.analysis_modules.radial_average.ellipse_mask_chk,....
%     'callback','radial_average_callbacks(''ellipse_mask_chk'');');

%Single or Depth
uicontrol(handle,'units','normalized','position',[0.1 0.27 0.4 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Single or Depth','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1]);
grasp_handles.window_modules.radial_average.radio_single = uicontrol(handle,'units','normalized','position',[0.15 0.18 0.07 0.05],'tooltip','Average Current Worksheet : Number : Depth Only','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','Tag','rad_av_single_depth','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],....
    'callback','radial_average_callbacks(''single_radio'')');
grasp_handles.window_modules.radial_average.radio_depth = uicontrol(handle,'units','normalized','position',[0.3 0.18 0.07 0.05],'tooltip','Average Entire Depth of Current Worksheet : Number','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','Tag','rad_av_single_depth','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],....
    'callback','radial_average_callbacks(''depth_radio'')');

%Direct to File
uicontrol(handle,'units','normalized','Position',[0.63 0.22 0.25 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Direct to File:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.radial_average.direct_to_file_check = uicontrol(handle,'units','normalized','Position',[0.90 0.22 0.068 0.05],'tooltip','Output Averaging Direct to File','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'visible','on',....
    'value',status_flags.analysis_modules.radial_average.direct_to_file,'callback','radial_average_callbacks(''direct_to_file_check'');');

%Depth TOF Combine
if status_flags.analysis_modules.radial_average.single_depth_radio == 0; visible = 'off'; else visible = 'on'; end
grasp_handles.window_modules.radial_average.depth_combine_text = uicontrol(handle,'units','normalized','Position',[0.35 0.15 0.53 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Depth (eg. TOF) Rebin:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'visible',visible);
grasp_handles.window_modules.radial_average.depth_combine_check = uicontrol(handle,'units','normalized','Position',[0.90 0.15 0.068 0.05],'tooltip','Combine TOF Data to Single I vs. Q Curve','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'visible','on',....
    'value',status_flags.analysis_modules.radial_average.d33_tof_combine,'callback','radial_average_callbacks(''d33_tof_combine_check'');','visible',visible);

%Frame Start & End
if status_flags.analysis_modules.radial_average.single_depth_radio == 0; visible = 'off'; else visible = 'on'; end
grasp_handles.window_modules.radial_average.frame_startend_text = uicontrol(handle,'units','normalized','position',[0.1 0.07 0.4 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Frame Start & End','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'visible',visible);
grasp_handles.window_modules.radial_average.frame_start = uicontrol(handle,'units','normalized','Position',[0.5 0.07 0.16 0.06],'tooltip','Depth Frame # Stat','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.radial_average.depth_frame_start),'HorizontalAlignment','center','Visible',visible,'callback','radial_average_callbacks(''depth_frame_start'');');
grasp_handles.window_modules.radial_average.frame_end = uicontrol(handle,'units','normalized','Position',[0.7 0.07 0.16 0.06],'tooltip','Depth Frame # End','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.radial_average.depth_frame_end),'HorizontalAlignment','center','Visible',visible,'callback','radial_average_callbacks(''depth_frame_end'');');



%Refresh the window
radial_average_callbacks
