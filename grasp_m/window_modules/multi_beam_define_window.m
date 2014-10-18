function multi_beam_define_window

global grasp_env
global status_flags
global grasp_handles

%Check to see if curve fit window is already open
if ishandle(grasp_handles.window_modules.multi_beam.window)
    if strcmp(get(grasp_handles.window_modules.multi_beam.window,'tag'),'multi_beam_window');
        figure(grasp_handles.window_modules.multi_beam.window);
        return
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   432*grasp_env.screen.screen_scaling(1)   919*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.multi_beam.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Multi-Beam Control',....
    'NumberTitle', 'off',....
    'Tag','multi_beam_window',....
    'color',grasp_env.background_color,...
    'papertype','A4',....
    'renderer','zbuffer',....
    'menubar','none',....
    'closerequestfcn','closereq',....
    'resize','off');


%Number of Beams Selector
number_beams_string = '1|9|25|49';
uicontrol('units','normalized','Position',[0.02 0.96 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['# Beams:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.multi_beam.beams_selector = uicontrol('units','normalized','Position',[0.28 0.96 0.15 0.02],'ToolTip','Define Number of Beams','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','Tag','number_beams_selector','Visible','on',....
     'String',number_beams_string,'value',status_flags.analysis_modules.multi_beam.number_beams_index,'callback','multi_beam_callbacks(''number_beams'');');

%Auto Beam Mask
uicontrol('units','normalized','Position',[0.5 0.96 0.15 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Auto Mask:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.multi_beam.automask_check = uicontrol('units','normalized','Position',[0.66 0.96 0.05 0.02],'ToolTip','Auto-Mask Beams','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','Visible','on',....
     'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'value',status_flags.analysis_modules.multi_beam.auto_mask_check,'callback','multi_beam_callbacks(''auto_mask_check'');');

%Scale function to Beam Intensity
uicontrol('units','normalized','Position',[0.5 0.93 0.15 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['I0 Beam:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.multi_beam.beamscale_check = uicontrol('units','normalized','Position',[0.66 0.93 0.05 0.02],'ToolTip','Scale fit function to individual Beam I0','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','Visible','on',....
     'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'value',status_flags.analysis_modules.multi_beam.beam_scale_check,'callback','multi_beam_callbacks(''beam_scale_check'');');

 
%mask radius (pixels)
uicontrol('units','normalized','Position',[0.72 0.96 0.05 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['r:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.multi_beam.automask_check = uicontrol('units','normalized','Position',[0.78 0.96 0.08 0.02],'ToolTip','Auto-Mask Beams','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','Visible','on',....
     'string',num2str(status_flags.analysis_modules.multi_beam.auto_mask_radius),'callback','multi_beam_callbacks(''auto_mask_radius'');');

 
%Auto Guess Parameters Button
uicontrol('units','normalized','Position',[0.05 0.01 0.2 0.02],'ToolTip','Clear All Box & Beam Center Coordinates','String','Clear Beams','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','','Visible','on','CallBack','multi_beam_callbacks(''clear_beams'');');

 
%Build the Beam Centers & Boxs List for the number of beams
multi_beam_callbacks('build_beams_list');



