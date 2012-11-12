function grasp_changer_gui

global grasp_handles
global grasp_env
global status_flags

%Switch on Background subtractions
status_flags.selector.b_check = 1;
status_flags.selector.c_check = 1;
grasp_update

%Delete old grasp changer window
if ishandle(grasp_handles.grasp_changer.window);
    delete(grasp_handles.grasp_changer.window);
end

%Calcualate Optimal Grasp_Changer position
temp = size(grasp_env.screen.screen_size);
screens = temp(1);%find number of screens
if screens >1; screen = 2; else screen = 1; end
fig_position = figure_position([grasp_env.screen.grasp_main_default_position(1), grasp_env.screen.grasp_main_default_position(2), 1600, 960],20,screen);

grasp_handles.grasp_changer.window = figure(....
    'units','pixels',....
    'position', fig_position,....
    'Name','Changer GRASP',....
    'NumberTitle', 'off',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','grasp_changer_gui_callbacks(''close'');closereq;');
handle = grasp_handles.grasp_changer.window;

trans_check_handles = []; trans_calc_handles = []; clear_data_handles = [];
for config = 1:status_flags.grasp_changer.number_configs
    x0 = 0.015; dx = 0.23; Dx = (config-1)*dx;

    %Config title
    uicontrol(handle,'units','normalized','Position',[x0+0.1+Dx 0.92 0.1 0.03],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize * 1.5,'HorizontalAlignment','left','Style','text','String',['Configuration ' num2str(config)],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    config_subtitle_handle = uicontrol(handle,'units','normalized','Position',[x0+0.1+Dx 0.89 0.1 0.03],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String',['Det, Col, Wav'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_subtitle'],    config_subtitle_handle);
    
    %Config Beam Centre
    uicontrol(handle,'units','normalized','Position',[x0+0.1+Dx 0.05 0.08 0.02],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Beam Centre #' num2str(config)],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol(handle,'units','normalized','Position',[x0+0.1+Dx 0.035 0.02 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Cx: '],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    cx_handle = uicontrol(handle,'units','normalized','Position',[x0+0.12+Dx 0.035 0.02 0.02],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['xx']);
    uicontrol(handle,'units','normalized','Position',[x0+0.15+Dx 0.035 0.02 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Cy: '],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    cy_handle = uicontrol(handle,'units','normalized','Position',[x0+0.17+Dx 0.035 0.02 0.02],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['yy']);
    grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_cx'],cx_handle);
    grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['config' num2str(config) '_cy'],cy_handle);
    
    %Config Beam Centre window
    uicontrol(handle,'units','normalized','Position',[x0+0.03+Dx 0.01 0.08 0.015],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String',['Det Window: '],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    det_window_handle = uicontrol(handle,'units','normalized','Position',[x0+0.12+Dx 0.01 0.07 0.015],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['xx']);
    grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,['det_window_handle' num2str(config)],det_window_handle);

    %Clear Configuration
    clear_handle  = uicontrol(handle,'units','normalized','Position',[x0+0.1+Dx 0.86 0.08 0.015],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','pushbutton','String',['Clear Config #' num2str(config)],'userdata',config,'callback','grasp_changer_gui_callbacks(''clear_config_data'')');
    clear_data_handles = [clear_data_handles, clear_handle];
    
    %Column titles
    if config ==1;
        %Number of Samples
        grasp_handles.grasp_changer.number_samples = uicontrol(handle,'units','normalized','Position',[x0+0.00+Dx 0.86 0.03 0.02],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','String',num2str(status_flags.grasp_changer.number_samples),'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'callback','grasp_changer_gui_callbacks(''number_samples'')');
        %Sample Number
        uicontrol(handle,'units','normalized','Position',[x0+0.00+Dx 0.84 0.03 0.015],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','No. #','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
        %Sample Thickness
        uicontrol(handle,'units','normalized','Position',[x0+0.03+Dx 0.84 0.055 0.015],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Thickness (cm)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
        %Sample Thickness fill down button
        uicontrol(handle,'units','normalized','Position',[x0+0.045+Dx 0.82 0.012 0.015],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','pushbutton','String','>','tooltipstring','Fill Down','userdata',config,'callback','grasp_changer_gui_callbacks(''filldown_thickness'');');

        %Designation
        uicontrol(handle,'units','normalized','Position',[x0+0.25+Dx 0.84 0.05 0.015],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Designation','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

    end
    %Scattering Numor
    uicontrol(handle,'units','normalized','Position',[x0+0.1+Dx 0.84 0.05 0.015],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Scattering #','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    %Transmission Numor
    uicontrol(handle,'units','normalized','Position',[x0+0.16+Dx 0.84 0.05 0.015],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Trans #','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

    %Transmission Check box
    if config == status_flags.grasp_changer.transmission_config; value = 1; else value = 0; end
    trans_check_handle = uicontrol(handle,'units','normalized','Position',[x0+0.20+Dx 0.84 0.02 0.015],'value',value,'userdata',config,'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','string', '','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1],'callback','grasp_changer_gui_callbacks(''transmission_config'')');
    trans_check_handles = [trans_check_handles, trans_check_handle];
    %Transmission Calc Button
    trans_calc_handle =  uicontrol(handle,'units','normalized','Position',[x0+0.215+Dx 0.84 0.012 0.015],'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','pushbutton','String','T','tooltipstring','Calculate Transmissions values for Samples and Empty Cell','userdata',config,'callback','grasp_changer_gui_callbacks(''transmission_calc'')');
    trans_calc_handles =  [trans_calc_handles, trans_calc_handle];
    
end
grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,'trans_check_handles',trans_check_handles);
grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,'trans_calc_handles',trans_calc_handles);
grasp_handles.grasp_changer = setfield(grasp_handles.grasp_changer,'clear_data_handles',clear_data_handles);

%Calibrate Tick Box
grasp_handles.grasp_changer.calibrate_check = uicontrol(handle,'units','normalized','Position',[x0+0.1 0.10 0.13 0.015],'value',status_flags.grasp_changer.calibrate_check,'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','string', 'Calibrate Data to Empty Beam','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1],'callback','grasp_changer_gui_callbacks(''calibrate_check'')');

%Auto Mask Tick Box
grasp_handles.grasp_changer.auto_mask_handles = uicontrol(handle,'units','normalized','Position',[x0+0.1 0.08 0.06 0.015],'tooltip','Automatically Cuts q data beneith beamstop','value',status_flags.grasp_changer.auto_mask_check,'FontName',grasp_env.font,'FontWeight','bold','FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','string', 'Auto Mask','BackgroundColor',grasp_env.background_color, 'ForegroundColor', [1 1 1],'callback','grasp_changer_gui_callbacks(''auto_mask_check'')');


grasp_changer_gui_callbacks('configure_grasp_changer_from_classic_grasp'); %Build the sample numors based on the contents of conventional grasp
grasp_changer_gui_callbacks('build_boxes');

grasp_update

