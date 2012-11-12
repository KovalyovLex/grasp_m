function mask_edit_window

global grasp_env
global grasp_handles
global status_flags

%***** Open Mask Editor Window *****

if ishandle(grasp_handles.window_modules.mask_edit.window); delete(grasp_handles.window_modules.mask_edit.window); end

%tool_callbacks('rescale');  %Reset the current display
zoom off; %Switch off zoom mode
%Set the Display Options 'mask' check to on.
status_flags.display.mask.check = 1;

fig_position = [grasp_env.screen.grasp_main_actual_position(1), grasp_env.screen.grasp_main_actual_position(2)*0.5,   320*grasp_env.screen.screen_scaling(1)   240*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.mask_edit.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Mask Editor' ,....
    'NumberTitle', 'off',....
    'Tag','mask_edit_window',....
    'color',grasp_env.background_color,...
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','mask_edit_callbacks(''close'');closereq');

handle = grasp_handles.window_modules.mask_edit.window;

%Mask Point
uicontrol(handle,'units','normalized','Position',[0.01,0.72,0.15,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Point:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.mask_edit.pointx = uicontrol(handle,'units','normalized','Position',[0.17,0.75,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','point_mask_x','Visible','on');
grasp_handles.window_modules.mask_edit.pointy = uicontrol(handle,'units','normalized','Position',[0.28,0.75,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','point_mask_y','Visible','on');
uicontrol(handle,'units','normalized','Position',[0.40,0.75,0.05,0.075],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','+','Tag','point_mask_add','Visible','on','Value',0,'CallBack','mask_edit_callbacks(''point'',0)');
uicontrol(handle,'units','normalized','Position',[0.46,0.75,0.05,0.075],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','-','Tag','point_mask_remove','Visible','on','Value',0,'CallBack','mask_edit_callbacks(''point'',1)');

%Mask Line
uicontrol(handle,'units','normalized','Position',[0.01,0.57,0.15,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Lines:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.mask_edit.line = uicontrol(handle,'units','normalized','Position',[0.17,0.6,0.43,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','x1','HorizontalAlignment','left','Tag','line_mask','Visible','on');
uicontrol(handle,'units','normalized','Position',[0.62,0.6,0.05,0.075],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','+','Tag','line_mask_add','Visible','on','Value',0,'CallBack','mask_edit_callbacks(''line'',0)');
uicontrol(handle,'units','normalized','Position',[0.68,0.6,0.05,0.075],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','-','Tag','line_mask_remove','Visible','on','Value',0,'CallBack','mask_edit_callbacks(''line'',1)');

%Mask Box
uicontrol(handle,'units','normalized','Position',[0.01,0.42,0.15,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Box:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.mask_edit.boxx1 = uicontrol(handle,'units','normalized','Position',[0.17,0.45,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','box_mask_xmin','Visible','on');
grasp_handles.window_modules.mask_edit.boxx2 = uicontrol(handle,'units','normalized','Position',[0.28,0.45,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','box_mask_xmax','Visible','on');
grasp_handles.window_modules.mask_edit.boxy1 = uicontrol(handle,'units','normalized','Position',[0.39,0.45,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','box_mask_ymin','Visible','on');
grasp_handles.window_modules.mask_edit.boxy2 = uicontrol(handle,'units','normalized','Position',[0.50,0.45,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','box_mask_ymax','Visible','on');
uicontrol(handle,'units','normalized','Position',[0.62,0.45,0.05,0.075],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','+','Tag','box_mask_add','Visible','on','Value',0,'CallBack','mask_edit_callbacks(''box'',0)');
uicontrol(handle,'units','normalized','Position',[0.68,0.45,0.05,0.075],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','-','Tag','box_mask_remove','Visible','on','Value',0,'CallBack','mask_edit_callbacks(''box'',1)');

%Mask Circle
%find current beam centre
centre = current_beam_centre;
centre = centre.det1.cm_pixels;
uicontrol(handle,'units','normalized','Position',[0.01,0.27,0.15,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Circle:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.mask_edit.cx = uicontrol(handle,'units','normalized','Position',[0.17,0.3,0.14,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(centre(1)),'HorizontalAlignment','left','Tag','circle_mask_cx','Visible','on','callback','');
grasp_handles.window_modules.mask_edit.cy = uicontrol(handle,'units','normalized','Position',[0.32,0.3,0.14,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(centre(2)),'HorizontalAlignment','left','Tag','circle_mask_cy','Visible','on','callback','');
grasp_handles.window_modules.mask_edit.radius = uicontrol(handle,'units','normalized','Position',[0.47,0.3,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','10','HorizontalAlignment','left','Tag','circle_mask_radius','Visible','on','callback','mask_edit_callbacks(''crad'');');
uicontrol(handle,'units','normalized','Position',[0.62,0.3,0.05,0.075],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','+','Tag','circle_mask_add','Visible','on','Value',0,'CallBack','mask_edit_callbacks(''circle'',0)');
uicontrol(handle,'units','normalized','Position',[0.68,0.3,0.05,0.075],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','-','Tag','circle_mask_remove','Visible','on','Value',0,'CallBack','mask_edit_callbacks(''circle'',1)');

%Sketch Mask
uicontrol(handle,'units','normalized','Position',[0.78,0.75,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Sketch','HorizontalAlignment','center','Tag','sketch_mask_button','Visible','on','CallBack','mask_edit_callbacks(''sketch'',0)');
%Clear Mask
uicontrol(handle,'units','normalized','Position',[0.78,0.6,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Clear','HorizontalAlignment','center','Tag','mask_clear','Visible','on',...
    'CallBack','mask_edit_callbacks(''clear_mask'');');
%Grab Beam Centre
uicontrol(handle,'units','normalized','Position',[0.78,0.3,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Grab Centre','HorizontalAlignment','center','Tag','cm_grab_mask','Visible','on',...
    'CallBack','mask_edit_callbacks(''grab_cm'');');

