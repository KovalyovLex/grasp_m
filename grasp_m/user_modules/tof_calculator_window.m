function tof_calculator_window

global grasp_env

h=findobj('Tag','tof_calculator_window'); %Check to see if window is already open
if isempty(h) %i.e. if no window exists.
   
   figure_handle = figure(....
       'units','normalized',....
       'Position',[0.3731    0.0392-(0.218/grasp_env.screen.screen_scaling(1) - 0.218)    0.152    0.218],....
       'Name','TOF Calcualtor' ,....
       'NumberTitle', 'off',....
       'Tag','tof_calculator_window',....
       'Color',grasp_env.background_color,....
       'menubar','none',....
       'resize','off');
  
   
   %TOF Distance
   uicontrol('units','normalized','Position',[0.01,0.8,0.4,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','TOF Distance [m]:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
   uicontrol('units','normalized','Position',[0.42,0.8,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','10','HorizontalAlignment','center','Visible','on','tag','tof_calculator_dist','callback','tof_calculator_callbacks(''distance_edit'');');

   %Wavelength
   uicontrol('units','normalized','Position',[0.01,0.6,0.4,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Wavelength [angs]:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
   uicontrol('units','normalized','Position',[0.42,0.6,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','6','HorizontalAlignment','center','Visible','on','tag','tof_calculator_wav','callback','tof_calculator_callbacks(''wav_edit'');');
   
   %TOF time
   uicontrol('units','normalized','Position',[0.6,0.6,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','TOF [s]:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
   uicontrol('units','normalized','Position',[0.77,0.6,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','center','Visible','on','tag','tof_calculator_time','callback','tof_calculator_callbacks(''time_edit'');');

   %Derived quantities
   %Neutron Velocity
   uicontrol('units','normalized','Position',[0.05,0.3,0.4,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Velocity [m/s]:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
   uicontrol('units','normalized','Position',[0.47,0.3,0.3,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','0','HorizontalAlignment','center','Visible','on','tag','tof_calculator_velocity');
   
   
   
   %Derived quantities
   %Frequency
   uicontrol('units','normalized','Position',[0.05,0.2,0.4,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Frequency [Hz]:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
   uicontrol('units','normalized','Position',[0.47,0.2,0.3,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','0','HorizontalAlignment','center','Visible','on','tag','tof_calculator_freq');




else
    figure(h)
end

tof_calculator_callbacks('distance_edit');
   