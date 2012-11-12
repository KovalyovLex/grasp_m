function fll_spot_angle_average_window

global grasp_env

h=findobj('Tag','spot_angle_average_window'); %Check to see if window is already open
if isempty(h) %i.e. if no window exists.
        fig_position = [grasp_env.screen.grasp_main_actual_position(1)*0.9, grasp_env.screen.grasp_main_actual_position(2)*0.5,   250*grasp_env.screen.screen_scaling(1)   250*grasp_env.screen.screen_scaling(2)];

    figure_handle = figure(....
        'units','pixels',....
        'Position',fig_position,....
        'Name','FLL Spot Angle Average Calculator',....
        'NumberTitle', 'off',....
        'Tag','spot_angle_average_window',....
        'Color',grasp_env.background_color,....
        'menubar','none',....
        'resize','off');
  
    %Choose Spot Pairs
    uicontrol('units','normalized','Position',[0.42,0.75,0.45,0.10],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
        'string','Choose Spot Pairs','callBack','fll_spot_angle_average_callbacks(''choose_spot_pairs'');');    

    %Fit Box Width
    uicontrol('units','normalized','Position',[0.1,0.5,0.3,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Box Width:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    uicontrol('units','normalized','Position',[0.42,0.6,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','x','HorizontalAlignment','center','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    uicontrol('units','normalized','Position',[0.67,0.6,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','y','HorizontalAlignment','center','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    
    uicontrol('units','normalized','Position',[0.42,0.5,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','10','HorizontalAlignment','center','Tag','spot_angle_average_box_x','Visible','on');
    uicontrol('units','normalized','Position',[0.67,0.5,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','10','HorizontalAlignment','center','Tag','spot_angle_average_box_y','Visible','on');
    
    %Average Angle Beta
    uicontrol('units','normalized','Position',[0.1,0.25,0.3,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Beta Average:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    uicontrol('units','normalized','Position',[0.42,0.35,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Beta','HorizontalAlignment','center','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    uicontrol('units','normalized','Position',[0.67,0.35,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','Err_Beta','HorizontalAlignment','center','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1 1 1]);
    
    uicontrol('units','normalized','Position',[0.42,0.25,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','','HorizontalAlignment','center','Tag','spot_angle_average_beta','Visible','on');
    uicontrol('units','normalized','Position',[0.67,0.25,0.2,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','','HorizontalAlignment','center','Tag','spot_angle_average_errbeta','Visible','on');
else 
    figure(h)
end


