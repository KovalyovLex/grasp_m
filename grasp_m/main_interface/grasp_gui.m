function grasp_gui

%Builds the main Grasp GUI

global grasp_env
global grasp_handles
global status_flags

%***** Draw main user interface *****
%Calcualte figure positioning based upon the default position.
grasp_env.screen.grasp_main_actual_position = figure_position(grasp_env.screen.grasp_main_default_position,grasp_env.screen.grasp_main_toolbar_overhead);
grasp_env.screen.screen_scaling = grasp_env.screen.grasp_main_actual_position(3:4)./grasp_env.screen.grasp_main_default_position(3:4);

grasp_handles.figure.grasp_main = figure(....
    'units','pixels',....
    'Position',[grasp_env.screen.grasp_main_actual_position],....
    'Name',[grasp_env.grasp_name ' V' grasp_env.grasp_version ' - ' grasp_env.project_title],...
    'Tag','grasp_main',....
    'NumberTitle','off',....
    'color',grasp_env.background_color,....
    'inverthardcopy','on',....
    'papertype','A4',....
    'menubar','none',....
    'PaperPosition',[0.65625 1.84375 6.9375 8],....
    'PaperPositionMode','auto',...
    'resize','on',....
    'closerequestfcn','file_menu(''exit'');',....
    'windowbuttonmotionfcn','live_coords');

%***** Worksheet Display and Load selector *****
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.01,0.286,0.49,0.074],'HorizontalAlignment','right','Style','frame','BackgroundColor', grasp_env.background_color,'ForegroundColor', [1 1 1]);
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.02,0.32,0.11,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Foreground:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.02,0.3,0.11,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','& Data Load:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

%Group Worksheets Check Box
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.225,0.28,0.065,0.020],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Group:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.wks_group_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.36,0.277,0.03,0.025],'tooltip','Group Worksheet Numbers','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','group_worksheets_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'callback','main_callbacks(''wks_group'');');
grasp_handles.figure.dpth_group_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.45,0.277,0.03,0.025],'tooltip','Group Worksheet Depths','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','group_depth_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'callback','main_callbacks(''dpth_group'');');

%Foreground Worksheet Selector
grasp_handles.figure.fore_wks = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.16,0.31,0.13,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'tooltip',['Select Worksheet Type' char(13) char(10) 'e.g. Foreground, Background or Cadmium Scattering Data'],'Style','Popup','Tag','worksheet','String','xxxx','Value',1,'CallBack','main_callbacks(''foreground_wks'');'); %Callback also sets flag to refresh axes
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.17,0.35,0.10,0.020],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Worksheet:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%Foreground Number Selector
grasp_handles.figure.fore_nmbr = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.30,0.31,0.08,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'tooltip',['Select Worksheet Number'],'Style','Popup','Tag','number','String','1','CallBack','main_callbacks(''foreground_nmbr'');','Value',1); %Callback also sets flag to refresh axes
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.295,0.35,0.08,0.020],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Number:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%Foreground Depth Selector
grasp_handles.figure.fore_dpth = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.39,0.31,0.1,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'tooltip',['Worksheet Depth :' char(13) char(10) 'Many Files Stored Individually Making Up a Single Measurement'],'Style','Popup','Tag','depth','String','1','CallBack','main_callbacks(''foreground_dpth'');','Value',1); %Callback also sets flag to refresh axes
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.39,0.35,0.06,0.020],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Depth:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

gx = 0.03; gy = 0.24; %Group Postions (normalized);
%Background Worksheet selector
grasp_handles.figure.background_context.root = uicontextmenu;
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx-0.01,gy,0.11,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Background:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'uicontextmenu',grasp_handles.figure.background_context.root);
%Subtract CheckBox
grasp_handles.figure.back_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.105,gy,0.03,0.025],'tooltip','Subtract Sample Background','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','subtract_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''subtract_check'');');
%Worksheet Selector
grasp_handles.figure.back_wks = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.13,gy,0.13,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','worksheet_subtract','String','yyyy','CallBack','main_callbacks(''background_wks'');');
%Number Selector
grasp_handles.figure.back_nmbr = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.27,gy,0.08,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','number_subtract','String','1','CallBack','main_callbacks(''background_nmbr'');','Value',1);
%Depth Selector
grasp_handles.figure.back_dpth = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.36,gy,0.1,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','depth_subtract','String','1','CallBack','main_callbacks(''background_dpth'');','Value',1);

gx = 0.03; gy = 0.19; %Group Postions (normalized);
%Cadmium Worksheet selector
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx-0.01,gy,0.11,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Cadmium:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%Subtract CheckBox
grasp_handles.figure.cad_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.105,gy,0.03,0.025],'tooltip','Subtract Cadmium Background','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','cadmium_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''cadmium_check'');');
%Worksheet Selector
grasp_handles.figure.cad_wks = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.13,gy,0.13,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','worksheet_cadmium','String','zzzz','CallBack','main_callbacks(''cadmium_wks'');');
%Number Selector
grasp_handles.figure.cad_nmbr = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.27,gy,0.08,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','number_cadmium','String','1','CallBack','main_callbacks(''cadmium_nmbr'');','Value',1);
%Depth Selector
grasp_handles.figure.cad_dpth = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.36,gy,0.1,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','depth_cadmium','String','1','CallBack','main_callbacks(''cadmium_dpth'');','Value',1);


%***** Data Load *****
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.02,0.1,0.11,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Numor(s):','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
tooltip_string = ['Enter Data Numor(s):' char(13) char(10)....
    'Options:' char(13) char(10) '''>''   - Sum  Numors Into Single Depth' char(13) char(10)...
    ''':''    - Store Numors Incrementaly in Depth' char(13) char(10)....
    '''+''   - Sum Individual Numors' char(13) char(10)....
    ''',''    - Store Invdividual Numors Incrementaly in Depth' char(13) char(10)....
    '''(n;s)'' - Used after Numor [eg. 12345(5;2)].  Sum ''n'' Numors ' char(13) char(10)....
    '           Skipping Every ''s''. Can be combined with '',''' char(13) char(10)....
    '''{n;s}'' - Used after Numor [eg. 12345{5;2}].  Store ''n'' Numors in Depth ' char(13) char(10)....
    '           Skipping Every ''s''. Can be combined with '','''];
%Data Load Line + Return Callback to execute data read
grasp_handles.figure.data_load = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.135,0.1,0.34,0.03],'tooltip',tooltip_string,'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','<Numors>','HorizontalAlignment','left','Tag','data_load','Visible','on','callback','main_callbacks(''data_read_on_enter'')');

%Extra Extension window for HMI & NIST
tooltip_string = 'Enter file extension: e.g. ''001'' or ''ASC'' for HMI or NIST data';
%if strcmp(inst,'V4_HMI_64') | strcmp(inst,'V4_HMI_128') | strcmp(inst,'NIST_ng7') | strcmp(inst,'d22_rawdata'); visible = 'on'; else visible = 'off'; end
visible = 'on';
grasp_handles.figure.data_ext = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.48,0.1,0.06,0.03],'tooltip',tooltip_string,'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','.001','HorizontalAlignment','right','Tag','data_load_extension','Visible',visible,'callback','main_callbacks(''fname_extension'')');

%Extra SortName for NIST
tooltip_string = 'Enter file short name, e.g. ''ABC'', for NIST ASCII data';
%if strcmp(inst,'NIST_ng7'); visible = 'on'; else visible = 'off'; end
visible = 'on';
grasp_handles.figure.data_lead_text = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.02,0.14,0.11,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Title:','BackgroundColor', grasp_env.background_color, 'tag', 'data_load_shortname_text','ForegroundColor', [1 1 1],'visible',visible);
grasp_handles.figure.data_lead = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.135,0.14,0.25,0.03],'tooltip',tooltip_string,'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','ABC','HorizontalAlignment','right','Tag','data_load_shortname','Visible',visible,'callback','main_callbacks(''fname_shortname'')');

%Increment and Getit
grasp_handles.figure.numor_plus = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.165,0.072,0.02,0.02],'tooltip','Increment Numor and Get It','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','+','HorizontalAlignment','center','Tag','increment_get_it','Visible','on','CallBack','main_callbacks(''numor_plus'',1);');
%Decrement and Getit
grasp_handles.figure.numor_minus = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.135,0.072,0.02,0.02],'tooltip','Decrement Numor and Get It','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','-','HorizontalAlignment','center','Tag','decrement_get_it','Visible','on','CallBack','main_callbacks(''numor_plus'',-1);');
%Data Get-it button
grasp_handles.figure.getit = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.395,0.07,0.08,0.025],'tooltip','Load Data into Selected Worksheet','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Get It!','HorizontalAlignment','center','Tag','numor_get_it','Visible','on','CallBack','main_callbacks(''data_read'')','userdata','0');
%D33 Raw Data Import
grasp_handles.figure.raw_tube_data_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.5,0.072,0.03,0.025],'ToolTip','D33: Raw Detector Data Load','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.fname_extension.raw_tube_data_load,'callback','main_callbacks(''raw_tube_data_load'');');


%***** Displayed Processing Check Boxes *****
gx = 0.82; gy = 0.70; %Group Postions (normalized);
%Log
grasp_handles.figure.logz_context.root = uicontextmenu;
grasp_handles.figure.logz_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'ToolTip','Log Display z-Data','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','image_log','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'callback','main_callbacks(''log'');');
grasp_handles.figure.logz_string = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','string',' : Log Z','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'uicontextmenu',grasp_handles.figure.logz_context.root);

%Grouped ZMin Zmax Range
gy = gy-0.03;
grasp_handles.figure.grouped_z_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Grouped z-Scale between detectors','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','BackgroundColor', grasp_env.background_color, 'value',status_flags.display.grouped_z_scale ,...
    'foregroundcolor',[1 1 1],'callback','main_callbacks(''grouped_z_check'');');
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','string',' : Grouped Z Scale','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize);

%ZMin Zmax Range
gy = gy-0.03;
grasp_handles.figure.manualz_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Manual z-Scale : Enter z-min and z-max Display Range','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','manual_z_check','BackgroundColor', grasp_env.background_color, 'value',0,...
    'foregroundcolor',[1 1 1],'callback','main_callbacks(''manual_z_check'');');
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','string',' : Manual Z Scale','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize);
grasp_handles.figure.manualz_min = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','position',[gx,gy-0.03,0.08,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','string','0','Tag','manual_zmin', 'callback','main_callbacks(''zmin'');','horizontalalignment','right','visible','off');
grasp_handles.figure.manualz_max = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','position',[gx+0.09,gy-0.03,0.08,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','string','1','Tag','manual_zmax', 'callback','main_callbacks(''zmax'');','horizontalalignment','right','visible','off');

%Image Plot Type
gy = gy-0.06;
grasp_handles.figure.image_context.root = uicontextmenu;
grasp_handles.figure.image_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Colour Display Image','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','image_display_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''image'');');
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','string',' : Image','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'uicontextmenu',grasp_handles.figure.image_context.root);



%Contour Plot Type
gy = gy-0.03;
grasp_handles.figure.contour_context.root = uicontextmenu;
grasp_handles.figure.contour_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Contour Display Image','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','contour_display_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''contour'');');
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','string',' : Contour','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'uicontextmenu',grasp_handles.figure.contour_context.root);

%Apply Smoothing to Display
gy = gy-0.03;
grasp_handles.figure.smooth_context.root = uicontextmenu;
grasp_handles.figure.smooth_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Smooth Image (Display Only)','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','smooth_display_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''smooth'');');
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','string',' : Smooth','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'uicontextmenu',grasp_handles.figure.smooth_context.root);


%Display Rotate
% gy = gy-0.03;
% grasp_handles.figure.rotate_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Rotate Image (Display Only)','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','rotate_display_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''rotate'');');
% uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','string',' : Rotate','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize);
% grasp_handles.figure.rotate_angle = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','position',[gx+0.12,gy,0.05,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','string','0','Tag','rotate_display_angle', 'callback','main_callbacks(''rotate_angle'');','horizontalalignment','right','visible','on');
%Composite Mask Button
gy = gy-0.06;
grasp_handles.figure.mask_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Mask Data','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','mask_composite_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''mask_check'');');
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','string',' : Mask','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize);
grasp_handles.figure.mask_nmbr = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.12,gy,0.05,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','popup','String','1','HorizontalAlignment','center','Tag','disp_mask_number','value',1,'CallBack','main_callbacks(''mask_number'');','visible','on');
%Calibrate On/Off
gy = gy-0.03;
grasp_handles.figure.calibrate_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Calibrate Data : See Calibration Settings','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','calibrate_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''calibrate_check'');');
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','style','text','string',' : Calibrate','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize);
%PA Corrections On/Off
gy = gy-0.03;
grasp_handles.figure.pa_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','Polarisation & Analysis Spin-Leakage Corrections','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''pa_correct'');','visible','on');
grasp_handles.figure.pa_chk_text = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','style','text','string',' : PA Correct','HorizontalAlignment','left','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'visible','on');

%D33 Tube Calibration On/Off
gy = gy-0.03;
grasp_handles.figure.detcal_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy,0.03,0.025],'tooltip','D33 Detector Tube Calibration','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','d33_soft_det_cal_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'CallBack','main_callbacks(''soft_det_cal_check'');','visible','on');
grasp_handles.figure.detcal_chk_text = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.035,gy,0.14,0.025],'style','text','style','text','string',' : D33 Tube Cal','HorizontalAlignment','left','Tag','d33_soft_det_cal_text','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'visible','on');




%***** Display Beam Centre *****
gx = 0.57; gy = 0.16; %Group Postions (normalized);
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.07,gy,0.2,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Beam Centre:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%Beam Centre Number Selector
grasp_handles.figure.beamcentre_nmbr = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy-0.06,0.06,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','popup','String','1','HorizontalAlignment','left','Tag','beam_centre_number','Visible','on','CallBack','main_callbacks(''cm_number'')');
%Bx
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.07,gy-0.03,0.08,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','c_x:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.beamcentre_cx = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.07,gy-0.06,0.08,0.03],'tooltip','Beam Centre x-Value','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','x','HorizontalAlignment','center','Tag','beam_centrex','Visible','on','CallBack','main_callbacks(''cm_x'');');
%By
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.155,gy-0.03,0.08,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','c_y:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.beamcentre_cy = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.155,gy-0.06,0.08,0.03],'tooltip','Beam Centre y-Value','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','x','HorizontalAlignment','center','Tag','beam_centrey','Visible','on','CallBack','main_callbacks(''cm_y'');');
%B_theta or gamma as Giovanna calls it
grasp_handles.figure.beamcentre_ctheta_text = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.24,gy-0.03,0.08,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','c_?:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'tag','beam_centre_angle_text','visible','off');
grasp_handles.figure.beamcentre_ctheta = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.24,gy-0.06,0.08,0.03],'tooltip','Beam Centre ?-Value','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','x','HorizontalAlignment','right','Tag','beam_centre_angle','Visible','on','CallBack','main_callbacks(''cm_theta'');','visible','off');
%Centre of Mass Lock Value
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.33,gy-0.02,0.045,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Lock:','tag','cm_lock_text','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.beamcentre_lock_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.34,gy-0.055,0.03,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'tooltip','Lock Beam Centre at Current Value for all Worksheets','Style','checkbox','Tag','cm_lock','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'callback','main_callbacks(''cm_lock'');');
%Centre of Mass Button
grasp_handles.figure.beamcentre_calc = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.07,gy-0.09,0.12,0.025],'ToolTip',['Find Centre of Mass of Displayed Area'],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Centre Calc','HorizontalAlignment','center','Tag','centremassbutton','Visible','on','CallBack','main_callbacks(''cm_calc'')');



%***** Transmission Value *****
gx = 0.57; gy = 0.35; %Group Postions (normalized);

%Sample thickness edit box
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.3,gy,0.12,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','Thickness (cm):','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.thickness = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.3,gy-0.04,0.08,0.03],'tooltip',['Sample Thickness (mm):'],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','x','HorizontalAlignment','center','Visible','on','callback','main_callbacks(''sample_thickness'');');

%Ts
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.07,gy,0.06,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','T_s:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.trans_ts_nmbr = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy-0.04,0.06,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','popup','String','1','HorizontalAlignment','left','Tag','ts_number','Visible','on','CallBack','main_callbacks(''ts_number'')');
grasp_handles.figure.trans_ts = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.07,gy-0.04,0.08,0.03],'tooltip',['Sample-only Transmission Value, Ts:' char(13) char(10) 'i.e. Compare Through Beam for Sample+Holder vs. Holder'],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','x','HorizontalAlignment','center','Tag','ts_indicator','Visible','on','callback','main_callbacks(''ts'');');
%Te
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.07,gy-0.07,0.06,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','T_e:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.trans_te_nmbr = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx,gy-0.11,0.06,0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','popup','String','1','HorizontalAlignment','left','Tag','te_number','Visible','on','CallBack','main_callbacks(''te_number'')');
grasp_handles.figure.trans_te = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.07,gy-0.11,0.08,0.03],'tooltip',['Sample Holder Transmission Value, Te:' char(13) char(10) 'i.e. Compare Through Beam for Sample Holder vs. Direct Beam'],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','x','HorizontalAlignment','center','Tag','te_indicator','Visible','on','callback','main_callbacks(''te'');');
%Ts lock
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.155,gy,0.06,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','tag','ts_lock_text','Style','text','String','Lock:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.trans_tslock_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.17,gy-0.035,0.03,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','ts_lock','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'ToolTipString','Lock Transmission (Ts) at Current Value for all Worksheets','callback','main_callbacks(''ts_lock'');');
%Te Lock
uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.155,gy-0.07,0.06,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','tag','te_lock_text','Style','text','String','Lock:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.trans_telock_chk = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.17,gy-0.105,0.03,0.025],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','te_lock','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',0,'ToolTipString','Lock Transmission (Te) at Current Value for all Worksheets','callback','main_callbacks(''te_lock'');');

%Calculate Transmission Button
grasp_handles.figure.trans_tscalc = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[gx+0.21,gy-0.04,0.085,0.025],'ToolTip',['Calculate Transmission' char(13) 'of Displayed Area'],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Trans Calc','HorizontalAlignment','center','Tag','trans_calc_button','Visible','on','CallBack','main_callbacks(''transmission_calc'');');

%***** Norm Indicator *****
color = [1 1 1]; backcolor = [0.8 0 0];
grasp_handles.figure.norm_indicator = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.77 0.96 0.23 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','Style','text','HorizontalAlignment','center',...
    'String','xxxxxxx','BackgroundColor',backcolor,'ForegroundColor', color,'tag','norm_indicator');

%***** Display Instrument ******
grasp_handles.figure.inst_indicator = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.77,0.98,0.23,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','center','Style','text',...
    'String','Inst','tag','inst_string','BackgroundColor', [0.1 0.5 0.3] ,'ForegroundColor', [1 1 1]);

%***** Live Coords and Pixel Value Indicator *****
grasp_handles.figure.live_coords = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0,0.98,0.2,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*0.9,'Style','text','HorizontalAlignment','center',...
    'String','','BackgroundColor',[0.1 0.4 0.4],'ForegroundColor',[1 1 1],'tag','live_coords');

%***** Credits ******
temp = clock;
grasp_handles.figure.credits = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.5,0.01,0.5,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
    'String',[grasp_env.grasp_name ' V' grasp_env.grasp_version ' (c)' num2str(temp(1)) '.  e-mail: dewhurst@ill.fr  '],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);


%***** Data summary *****
panel_color = [0.3,0.2,0.2];
panel_fontsize = grasp_env.fontsize * 0.9;
grasp_handles.figure.data_summary_panel.context = uicontextmenu;
grasp_handles.figure.data_summary_panel.root = uipanel(grasp_handles.figure.grasp_main,....
    'position',[0.8,0.735,0.19,0.22],....
    'backgroundcolor',panel_color,....
    'bordertype','beveledout',....
    'uicontextmenu',grasp_handles.figure.data_summary_panel.context);

for n =1:10
    uimenu(grasp_handles.figure.data_summary_panel.context,'label',num2str(n),'callback','');
end

%Summary title
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.90,0.98,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Foreground Data Summary:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%wav
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.80,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Wav:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.wav = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.21,0.80,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%col
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.72,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Col:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.col = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.21,0.72,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%det
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.51,0.72,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Det:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.det = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.71,0.72,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%bx
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.64,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Bx:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.bx = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.71,0.64,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%by
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.51,0.64,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','By:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.by = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.21,0.64,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%Att
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.56,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Att #:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.att_type = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.21,0.56,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%Att Status
grasp_handles.figure.data_summary_panel.att_status = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.30,0.56,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%Changer Pos
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.46,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Ch #:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.chpos = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.21,0.46,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%Str
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.51,0.46,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Str:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.str = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.71,0.46,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%San
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.36,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','San:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.san = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.21,0.36,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%Phi
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.51,0.36,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Phi:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.phi = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.71,0.36,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%Sht
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.28,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Sht:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.sht = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.21,0.28,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%Trs
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.31,0.28,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Trs:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.trs = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.51,0.28,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%Sdi
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.61,0.28,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Sdi:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.sdi = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.81,0.28,0.18,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%T_reg
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.01,0.18,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Treg:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.treg = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.21,0.18,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
%T_smpl
uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.51,0.18,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','Tsmpl:','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.data_summary_panel.temp = uicontrol(grasp_handles.figure.data_summary_panel.root,'units','normalized','Position',[0.71,0.18,0.2,0.08],'FontName',grasp_env.font,'FontSize',panel_fontsize,'HorizontalAlignment','left','Style','text','String','xxxx','BackgroundColor', panel_color, 'ForegroundColor', [1 1 1]);


%Modify Default Menu and Tool Items
modify_main_menu_items(grasp_handles.figure.grasp_main);
modify_main_tool_items(grasp_handles.figure.grasp_main);
