function fll_rapid_beam_centre_window

global grasp_env

h=findobj('Tag','fll_rapid_beam_centre_window'); %Check to see if window is already open
if isempty(h) %i.e. if no window exists.
   fig_position = [grasp_env.screen.grasp_main_actual_position(1)*0.9, grasp_env.screen.grasp_main_actual_position(2)*0.5,  250*grasp_env.screen.screen_scaling(1)   250*grasp_env.screen.screen_scaling(2)];

   figure_handle = figure(....
       'units','pixels',....
       'Position',fig_position,....
       'Name','Rapid Beam Centre Calculator' ,....
       'NumberTitle', 'off',....
       'Tag','fll_rapid_beam_centre_window',....
       'Color',grasp_env.background_color,....
       'menubar','none',....
       'resize','off');
   
   %Choose Spot Pairs
   uicontrol('units','normalized','Position',[0.42,0.75,0.45,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
       'string','Choose 2 Spot Pairs','callBack','fll_rapid_beam_centre_callbacks(''take4'');');    
   
   %Fit Box Width
   uicontrol('units','normalized','Position',[0.1,0.5,0.3,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Box Width:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
   uicontrol('units','normalized','Position',[0.42,0.6,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','x','HorizontalAlignment','center','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
   uicontrol('units','normalized','Position',[0.67,0.6,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','y','HorizontalAlignment','center','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
   
   uicontrol('units','normalized','Position',[0.42,0.5,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','10','HorizontalAlignment','center','Tag','fll_rapid_beamcentre_box_x','Visible','on');
   uicontrol('units','normalized','Position',[0.67,0.5,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','10','HorizontalAlignment','center','Tag','fll_rapid_beamcentre_box_y','Visible','on');
   
   
   %Fitted Beam Centre
    uicontrol('units','normalized','Position',[0,0.25,0.4,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Fitted Beam Centre:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    uicontrol('units','normalized','Position',[0.42,0.35,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','C_x','HorizontalAlignment','center','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    uicontrol('units','normalized','Position',[0.67,0.35,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','C_y','HorizontalAlignment','center','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    
    uicontrol('units','normalized','Position',[0.42,0.25,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','','HorizontalAlignment','center','Tag','rapid_x0','Visible','on');
    uicontrol('units','normalized','Position',[0.67,0.25,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','','HorizontalAlignment','center','Tag','rapid_y0','Visible','on');
else
    figure(h)
end

   