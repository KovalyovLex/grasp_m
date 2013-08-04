function rheo_anisotropy_window

global grasp_env
global grasp_handles
global status_flags

%***** Open rheo anisotropy Window *****

if ishandle(grasp_handles.user_modules.rheo_anisotropy.window);
    delete(grasp_handles.user_modules.rheo_anisotropy.window);
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   265*grasp_env.screen.screen_scaling(1)   332*grasp_env.screen.screen_scaling(2)];
grasp_handles.user_modules.rheo_anisotropy.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','rheo_anisotropy',....
    'NumberTitle', 'off',....
    'Tag','rheo_anisotropy_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','rheo_anisotropy_callbacks(''rheo_anisotropy_window_close'');closereq;');
figure_handle = grasp_handles.user_modules.rheo_anisotropy.window;

   %rheo_anisotropy Do it
   grasp_handles.user_modules.rheo_anisotropy.rheo_anisotropy_button = uicontrol(figure_handle,'units','normalized','Position',[0.05 0.85 0.5 0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Rheo_anisotropy!','HorizontalAlignment','Center','Tag','rheo_anisotropy_button','Visible','on','CallBack','rheo_anisotropy_callbacks(''rheo_anisotropy_it'');');

   %rheo_anisotropy binning parameters 
   uicontrol(figure_handle,'units','normalized','Position',[0.05 0.7 0.4 0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Radius:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   
   %Radius
%   uicontrol(figure_handle,'units','normalized','Position',[0.35 0.6 0.16 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','Radius','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   grasp_handles.user_modules.rheo_anisotropy.radius = uicontrol(figure_handle,'units','normalized','Position',[0.32 0.7 0.16 0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.user_modules.rheo_anisotropy.radius),'HorizontalAlignment','right','Tag','rheo_radius','Visible','on','callback','rheo_anisotropy_callbacks(''radius'');');
   
   %End
%   uicontrol(figure_handle,'units','normalized','Position',[0.53 0.6 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','End:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%   grasp_handles.user_modules.rheo_anisotropy.end_radius = uicontrol(figure_handle,'units','normalized','Position',[0.53 0.5 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.user_modules.rheo_anisotropy.end_radius),'HorizontalAlignment','right','Tag','rheo_end_radius','Visible','on','callback','rheo_anisotropy_callbacks(''end'');');
   
   %Width   
   uicontrol(figure_handle,'units','normalized','Position',[0.05 0.45 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','Width:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   grasp_handles.user_modules.rheo_anisotropy.radius_width = uicontrol(figure_handle,'units','normalized','Position',[0.32 0.45 0.15 0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.user_modules.rheo_anisotropy.radius_width),'HorizontalAlignment','right','Tag','rheo_radius_width','Visible','on','callback','rheo_anisotropy_callbacks(''width'');');
   
   %Step
%   uicontrol(figure_handle,'units','normalized','Position',[0.77 0.4 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','Step:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%   grasp_handles.user_modules.rheo_anisotropy.radius_step = uicontrol(figure_handle,'units','normalized','Position',[0.77 0.3 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.user_modules.rheo_anisotropy.radius_step),'HorizontalAlignment','right','Tag','rheo_radius_step','Visible','on','callback','rheo_anisotropy_callbacks(''step'');');
   
   %Lock Fit Phase Angle
   uicontrol(figure_handle,'units','normalized','Position',[0.053 0.3 0.4 0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Phase Lock:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   grasp_handles.user_modules.rheo_anisotropy.phase_lock_check = uicontrol(figure_handle,'units','normalized','Position',[0.35 0.3 0.068 0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','ac2_lock_cos_phase','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.user_modules.rheo_anisotropy.phase_lock,...
       'callback','rheo_anisotropy_callbacks(''phase_lock'');');
   grasp_handles.user_modules.rheo_anisotropy.phase_lock_angle = uicontrol(figure_handle,'units','normalized','Position',[0.5 0.3 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.user_modules.rheo_anisotropy.phase_angle),'HorizontalAlignment','right','Tag','rheo_phase','Visible','off','callback','rheo_anisotropy_callbacks(''phase_angle'');');
   
   
   %Af Do it
%   grasp_handles.user_modules.rheo_anisotropy.Af_button = uicontrol(figure_handle,'units','normalized','Position',[0.05 0.85 0.3 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Af','HorizontalAlignment','Center','Tag','Af_button','Visible','on','CallBack','Af_callbacks(''Af_do_it'');');

% position: left bottom width height
      
    %Plot Af button
    uicontrol('units','normalized','Position',[0.65 0.85 0.25 0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
        'string','Plot Af','callBack','rheo_anisotropy_callbacks(''plot_Af'');');    
 
   
    %Radius for Af
%   uicontrol(figure_handle,'units','normalized','Position',[0.55 0.78 0.18 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','radius_Af:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%   grasp_handles.user_modules.rheo_anisotropy.radius_Af = uicontrol(figure_handle,'units','normalized','Position',[0.75 0.78 0.2 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.user_modules.rheo_anisotropy.radius_Af),'HorizontalAlignment','right','Tag','rheo_radius_Af','Visible','on','callback','rheo_anisotropy_callbacks(''radius_Af'');');
 
    %binning for Af
   uicontrol(figure_handle,'units','normalized','Position',[0.05 0.60 0.18 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','binning_Af:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   grasp_handles.user_modules.rheo_anisotropy.binning_Af = uicontrol(figure_handle,'units','normalized','Position',[0.32 0.60 0.16 0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.user_modules.rheo_anisotropy.binning_Af),'HorizontalAlignment','right','Tag','rheo_binning_Af','Visible','on','callback','rheo_anisotropy_callbacks(''binning_Af'');');
 
   
   %Af or results against parameter?
    uicontrol(figure_handle,'units','normalized','Position',[0.03,0.05,0.30,0.06],'fontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Ref. Parameter:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.user_modules.rheo_anisotropy.parameter = uicontrol(figure_handle,'units','normalized','Position',[0.25,0.05,0.15,0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.user_modules.rheo_anisotropy.parameter),'HorizontalAlignment','left','Tag','parameter','Visible','on','callback','rheo_anisotropy_callbacks(''parameter'');');
grasp_handles.user_modules.rheo_anisotropy.parameter_string = uicontrol(figure_handle,'units','normalized','Position',[0.4,0.05,0.3,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','tag','param_string','String','','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [0.2 1 0.20]);




%Param List
uicontrol(figure_handle,'units','normalized','Position',[0.65,0.05,0.3,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','String','Param List!','HorizontalAlignment','center','Tag','param_list_button','Visible','on','CallBack','display_param_list','enable','on');

   
     
   
   
   %Sector Plotting Colour
   sector_color_list_string = {'(none)','white','black','red','green','blue','cyan','magenta','yellow'};
   for n = 1:length(sector_color_list_string);
       if strcmp(status_flags.user_modules.rheo_anisotropy.color,sector_color_list_string{n})
           value = n;
       end
   end
   uicontrol('units','normalized','Position',[0.053,0.13,0.4,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Colour:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   grasp_handles.user_modules.rheo_anisotropy.color = uicontrol('units','normalized','Position',[0.35,0.13,0.22,0.1],'HorizontalAlignment','center','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','Popup','Tag','rheo_anisotropy_colour',...
       'String',sector_color_list_string,'CallBack','rheo_anisotropy_callbacks(''color'');','Value',value);

%Update the schematic annuli
rheo_anisotropy_callbacks;