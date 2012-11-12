function sector_box_window

global grasp_env
global grasp_handles
global status_flags

%***** Open Strip Window *****
if ishandle(grasp_handles.window_modules.sector_box.window); delete(grasp_handles.window_modules.sector_box.window); end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+265*grasp_env.screen.screen_scaling(1), grasp_env.screen.grasp_main_actual_position(2)*0.5,   265*grasp_env.screen.screen_scaling(1)   312*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.sector_box.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Sector Boxes' ,....
    'NumberTitle', 'off',....
    'Tag','sectbox_window',...
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','sector_box_callbacks(''close'');closereq');

handle = grasp_handles.window_modules.sector_box.window;

%Saved Boxes
uicontrol(handle,'units','normalized','Position',[0.01,0.90,0.95,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Box:   R1        R2       Thta      DThta       g      gThta','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

for sect = 1:6
    ypos = 0.83 - ((sect-1)*0.08);
    coords = getfield(status_flags.analysis_modules.sector_boxes,['coords' num2str(sect)]);
      
    handle1 = uicontrol(handle,'units','normalized','Position',[0.10,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(1)),'HorizontalAlignment','left','Visible','on','userdata',sect,'CallBack','sector_box_callbacks(''r1'');');
    handle2 = uicontrol(handle,'units','normalized','Position',[0.24,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(2)),'HorizontalAlignment','left','Visible','on','userdata',sect,'CallBack','sector_box_callbacks(''r2'');');
    handle3 = uicontrol(handle,'units','normalized','Position',[0.38,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(3)),'HorizontalAlignment','left','Visible','on','userdata',sect,'CallBack','sector_box_callbacks(''theta'');');
    handle4 = uicontrol(handle,'units','normalized','Position',[0.52,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(4)),'HorizontalAlignment','left','Visible','on','userdata',sect,'CallBack','sector_box_callbacks(''delta_theta'');');
    handle5 = uicontrol(handle,'units','normalized','Position',[0.66,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(5)),'HorizontalAlignment','left','Visible','on','userdata',sect,'CallBack','sector_box_callbacks(''gamma'');');
    handle6 = uicontrol(handle,'units','normalized','Position',[0.80,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(6)),'HorizontalAlignment','left','Visible','on','userdata',sect,'CallBack','sector_box_callbacks(''gamma_angle'');');
    
    grasp_handles.window_modules.sector_box = setfield(grasp_handles.window_modules.sector_box,['coords' num2str(sect)],[handle1, handle2, handle3, handle4, handle5, handle6]);
    uicontrol(handle,'units','normalized','Position',[0.02,ypos,0.06,0.06],'tooltip','Grab Box Coordinates','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'string',num2str(sect),'Style','pushbutton','Visible','on','Value',0,'CallBack','sector_box_callbacks(''grab_coords'');','userdata',sect,'buttondownfcn','sector_box_callbacks(''clear_box'');');
end

%Sector Box against parameter?
uicontrol(handle,'units','normalized','Position',[0.02,0.30,0.30,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','horizontalalignment','right','String','Ref. Parameter:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.sector_box.parameter = uicontrol(handle,'units','normalized','Position',[0.35,0.31,0.15,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.sector_boxes.parameter),'HorizontalAlignment','left','Tag','sectbox_parameter','Visible','on','callback','sector_box_callbacks(''parameter'');');
grasp_handles.window_modules.sector_box.parameter_string = uicontrol(handle,'units','normalized','Position',[0.2,0.23,0.3,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'horizontalalignment','right','Style','text','tag','sectbox_param_string','String','','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [0.2 1 0.20]);

uicontrol('units','normalized','Position',[0.2,0.17,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Param List!','HorizontalAlignment','left',...
    'Tag','param_list_button','Visible','on','CallBack','display_param_list','enable','on');

%Sector Box It!
uicontrol('units','normalized','Position',[0.65,0.05,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Do It!','HorizontalAlignment','center','Tag','sectfox_button','Visible','on','CallBack','sector_box_callbacks(''box_it'');');

%Normalise by box size
grasp_handles.window_modules.sector_box.box_nrm_chk = uicontrol('units','normalized','position',[0.6,0.23,0.29,0.1],'tooltip','Normalise Boxes - Counts / Pixel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','String','Box_Norm','HorizontalAlignment','left','Tag','sectbox_norm_check','Visible','on','value',status_flags.analysis_modules.sector_boxes.box_nrm_chk,'callback','sector_box_callbacks(''box_nrm_chk'');','BackgroundColor', grasp_env.background_color,'ForegroundColor', [1 1 1]);

%Sum all Boxes
grasp_handles.window_modules.sector_boxes.sum_box_chk = uicontrol('units','normalized','Position',[0.6,0.3,0.29,0.1],'tooltip','Sum All Boxes for Foxing','FontName',grasp_env.font,'FontSize',grasp_env.fontsize, 'Style','checkbox','String','Sum_Boxes','HorizontalAlignment','left','Tag','sectbox_sum_check','Visible','on','value',status_flags.analysis_modules.sector_boxes.sum_box_chk,'callback','sector_box_callbacks(''sum_box_chk'');','BackgroundColor', grasp_env.background_color,'ForegroundColor', [1 1 1]);

%Reset boxes
uicontrol('units','normalized','Position',[0.3,0.05,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Clear Boxes','HorizontalAlignment','left','Tag','clear_boxbutton','Visible','on','callback','sector_box_callbacks(''clear_all'');');

%Sector Box Plotting Colour
box_color_list_string = {'(none)','white','black','red','green','blue','cyan','magenta','yellow'};
for n = 1:length(box_color_list_string);
    if strcmp(status_flags.analysis_modules.sector_boxes.box_color,box_color_list_string{n})
        value = n;
    end
end
grasp_handles.window_modules.sector_box.box_color = uicontrol(handle,'units','normalized','Position',[0.02,0.03,0.25,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','box_colour','String',box_color_list_string,'CallBack','sector_box_callbacks(''box_color'');','Value',value);

%Update any sectors to be drawn
sector_box_callbacks