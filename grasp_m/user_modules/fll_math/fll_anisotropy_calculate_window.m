function fll_anisotropy_calculate_window

global grasp_env

h=findobj('Tag','anisotropy_calculate_window'); %Check to see if window is already open
if isempty(h) %i.e. if no window exists.
        fig_position = [grasp_env.screen.grasp_main_actual_position(1)*0.9, grasp_env.screen.grasp_main_actual_position(2)*0.5,   450*grasp_env.screen.screen_scaling(1)   350*grasp_env.screen.screen_scaling(2)];

    figure_handle = figure(....
        'units','pixels',....
        'Position',fig_position,....
        'Name','FLL Anisotropy Calculator' ,....
        'NumberTitle', 'off',....
        'Tag','anisotropy_calculate_window',....
        'Color',grasp_env.background_color,....
        'menubar','none',....
        'resize','off');
    
    decrement = 0.08; ypos = 0.80;
    
    %Headings
    uicontrol('units','normalized','Position',[0.19,ypos+decrement,0.1,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','x','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.34,ypos+decrement,0.1,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','Err x','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.49,ypos+decrement,0.1,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','y','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.64,ypos+decrement,0.1,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','Err y','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    
    
    %Spots
    for spot = 1:6
        uicontrol('units','normalized','Position',[0.09,ypos-((spot-1)*decrement),0.09,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
            'String',['Spot ' num2str(spot)],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
        uicontrol('units','normalized','Position',[0.22,ypos-((spot-1)*decrement),0.13,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag',['anisotropy_s' num2str(spot) 'x'],'Visible','on');
        uicontrol('units','normalized','Position',[0.37,ypos-((spot-1)*decrement),0.13,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag',['anisotropy_s' num2str(spot) 'ex'],'Visible','on');
        uicontrol('units','normalized','Position',[0.52,ypos-((spot-1)*decrement),0.13,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag',['anisotropy_s' num2str(spot) 'y'],'Visible','on');
        uicontrol('units','normalized','Position',[0.67,ypos-((spot-1)*decrement),0.13,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag',['anisotropy_s' num2str(spot) 'ey'],'Visible','on');
        uicontrol('units','normalized','Position',[0.82,ypos-((spot-1)*decrement),0.1,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
            'string','Load','callBack','fll_anisotropy_callbacks(''load_spot'');','userdata',spot);    
        
    end
    
    %Measurement Angle
        uicontrol('units','normalized','Position',[0.55,ypos-((spot+1.5)*decrement),0.25,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
            'String','Measurement Angle','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.82,ypos-((spot+1.5)*decrement),0.1,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit',...
            'string','0','tag','anisotropy_angle','callBack','fll_anisotropy_callbacks(''angle_edit'');');    

    
    %Beam Centre
    uicontrol('units','normalized','Position',[0.03,ypos-((spot)*decrement),0.15,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String',['Beam Centre'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.22,ypos-((spot)*decrement),0.13,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag',['anisotropy_cx'],'Visible','on');
    uicontrol('units','normalized','Position',[0.52,ypos-((spot)*decrement),0.13,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag',['anisotropy_cy'],'Visible','on');
    uicontrol('units','normalized','Position',[0.82,ypos-((spot)*decrement),0.1,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
        'string','Load','callBack','fll_anisotropy_callbacks(''load_cm'');');    
    
    %Clear Spots Button
    uicontrol('units','normalized','Position',[0.05,ypos-((spot+1.5)*decrement),0.15,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
        'string','Clear Spots','callBack','fll_anisotropy_callbacks(''clear_spots'');');    
    
    
    %Plot X2 Y2 button
    uicontrol('units','normalized','Position',[0.25,ypos-((spot+1.5)*decrement),0.2,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
        'string','Plot X2 Y2','callBack','fll_anisotropy_callbacks(''plot_x2y2'');');    
    
    
    %Auto Spots Fit
    uicontrol('units','normalized','Position',[0.05,ypos-((spot+3)*decrement),0.15,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
        'string','Auto Spots','callBack','fll_anisotropy_callbacks(''anisotropy_auto_spots_fit'');');    

    uicontrol('units','normalized','Position',[0.27,ypos-((spot+3)*decrement),0.08,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','10','HorizontalAlignment','left','Tag','anisotropy_auto_box_x','Visible','on');
    uicontrol('units','normalized','Position',[0.37,ypos-((spot+3)*decrement),0.08,0.07],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','10','HorizontalAlignment','left','Tag','anisotropy_auto_box_y','Visible','on');

    
end

   
   