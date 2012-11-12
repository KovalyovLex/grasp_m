function box_window

global grasp_env
global grasp_handles
global status_flags

%***** Open Strip Window *****
if ishandle(grasp_handles.window_modules.box.window); delete(grasp_handles.window_modules.box.window); grasp_handles.window_modules.box.window = []; end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+265*2*grasp_env.screen.screen_scaling(1), grasp_env.screen.grasp_main_actual_position(2)*0.5,   265*grasp_env.screen.screen_scaling(1)   312*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.box.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Boxes' ,....
    'NumberTitle', 'off',....
    'Tag','box_window',...
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','box_callbacks(''close'');closereq');

handle = grasp_handles.window_modules.box.window;

%Saved Boxes
uicontrol(handle,'units','normalized','Position',[0.01,0.90,0.95,0.06],'FontName',grasp_env.font,'horizontalalignment','left','FontSize',grasp_env.fontsize,'Style','text','String','Box:    x1       x2       y1       y2       Scan Box','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

for box = 1:6
    ypos = 0.83 - ((box-1)*0.08);
    coords = getfield(status_flags.analysis_modules.boxes,['coords' num2str(box)]);
      
    %Coordinates
    handle1 = uicontrol(handle,'units','normalized','Position',[0.10,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(1)),'HorizontalAlignment','left','Visible','on','userdata',box,'CallBack','box_callbacks(''x1'');');
    handle2 = uicontrol(handle,'units','normalized','Position',[0.24,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(2)),'HorizontalAlignment','left','Visible','on','userdata',box,'CallBack','box_callbacks(''x2'');');
    handle3 = uicontrol(handle,'units','normalized','Position',[0.38,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(3)),'HorizontalAlignment','left','Visible','on','userdata',box,'CallBack','box_callbacks(''y1'');');
    handle4 = uicontrol(handle,'units','normalized','Position',[0.52,ypos,0.13,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(coords(4)),'HorizontalAlignment','left','Visible','on','userdata',box,'CallBack','box_callbacks(''y2'');');
        
    grasp_handles.window_modules.box = setfield(grasp_handles.window_modules.box,['coords' num2str(box)],[handle1, handle2, handle3, handle4]);
    
    %Grab Coords
    uicontrol(handle,'units','normalized','Position',[0.02,ypos,0.06,0.06],'tooltip','Grab Box Coordinates','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Visible','on','Value',0,'string',num2str(box),'CallBack','box_callbacks(''grab_coords'');','userdata',box,'buttondownfcn','box_callbacks(''clear_box'');');

    %Scan Box
    enable = 'off';
    uicontrol(handle,'units','normalized','Position',[0.70,ypos,0.06,0.06],'tooltip','Scan Box with Angle','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Visible','on','Value',status_flags.analysis_modules.boxes.scan_boxes_check(box),'CallBack','box_callbacks(''scan_box_check'');','userdata',box,'buttondownfcn','box_callbacks('''');','enable',enable);
end

%Box against parameter?
uicontrol(handle,'units','normalized','Position',[0.02,0.30,0.30,0.06],'fontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Ref. Parameter:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.box.parameter = uicontrol(handle,'units','normalized','Position',[0.35,0.31,0.15,0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.boxes.parameter),'HorizontalAlignment','left','Tag','box_parameter','Visible','on','callback','box_callbacks(''parameter'');');
grasp_handles.window_modules.box.parameter_string = uicontrol(handle,'units','normalized','Position',[0.2,0.23,0.3,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','tag','box_param_string','String','','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [0.2 1 0.20]);

%Alternative drop-down parameter list
%build parameter list popup
%     temp = size(inst_params.fparams);
%     param_list_string = [];
%     for n = 1:temp(1);
%         param_list_string = [param_list_string, num2str(n), ':  ', inst_params.fparams(n,:), '|'];
%     end
%     uicontrol('units','normalized','Position',[0.65,0.8,0.35,0.1],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize*0.8,'Style','popup','String',param_list_string,'HorizontalAlignment','left','Tag','box_parameter','Visible','on','callback','box_callbacks(''box_parameter'');');




%Param List
uicontrol(handle,'units','normalized','Position',[0.2,0.17,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Param List!','HorizontalAlignment','center','Tag','param_list_button','Visible','on','CallBack','display_param_list','enable','on');

%Box It!
uicontrol(handle,'units','normalized','Position',[0.65,0.05,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Do It!','HorizontalAlignment','center','Tag','boxfox_button','Visible','on','callback','box_callbacks(''box_it'');');

%Normalise by box size
grasp_handles.window_modules.box.box_nrm_chk = uicontrol(handle,'units','normalized','position',[0.6,0.23,0.29,0.1],'tooltip','Normalise Boxes - Counts / Pixel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize, 'Style','checkbox','String','Box_Norm','HorizontalAlignment','left','Tag','box_norm_check','Visible','on','value',status_flags.analysis_modules.boxes.box_nrm_chk,'BackgroundColor', grasp_env.background_color,'ForegroundColor', [1 1 1],'callback','box_callbacks(''box_nrm_chk'');');

%Sum all Boxes
grasp_handles.window_modules.box.sum_box_chk = uicontrol(handle,'units','normalized','Position',[0.6,0.3,0.29,0.1],'tooltip','Sum All Boxes','FontName',grasp_env.font,'FontSize',grasp_env.fontsize, 'Style','checkbox','String','Sum_Boxes','HorizontalAlignment','left','Tag','box_sum_check','Visible','on','value',status_flags.analysis_modules.boxes.sum_box_chk,'BackgroundColor', grasp_env.background_color,'ForegroundColor', [1 1 1],'callback','box_callbacks(''sum_box_chk'');');

%Clear Boxes
uicontrol(handle,'units','normalized','Position',[0.3,0.05,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Clear Boxes','HorizontalAlignment','center','Tag','clear_boxbutton','Visible','on','callback','box_callbacks(''clear_all'');');

%Box Plotting Colour
box_color_list_string = {'(none)','white','black','red','green','blue','cyan','magenta','yellow'};
for n = 1:length(box_color_list_string);
    if strcmp(status_flags.analysis_modules.boxes.box_color,box_color_list_string{n})
        value = n;
    end
end
grasp_handles.window_modules.box.box_color = uicontrol(handle,'units','normalized','Position',[0.02,0.03,0.25,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','box_colour','String',box_color_list_string,'CallBack','box_callbacks(''box_color'');','Value',value);


%Update boxes
box_callbacks;
