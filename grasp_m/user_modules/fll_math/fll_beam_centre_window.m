function fll_beam_centre_window

global grasp_env

h=findobj('Tag','beam_centre_window'); %Check to see if window is already open
if isempty(h) %i.e. if no window exists.
   fig_position = [grasp_env.screen.grasp_main_actual_position(1)*0.9, grasp_env.screen.grasp_main_actual_position(2)*0.5,   450*grasp_env.screen.screen_scaling(1)   250*grasp_env.screen.screen_scaling(2)];

   figure_handle = figure(....
       'units','pixels',....
       'Position',fig_position,....
       'Name','Beam_Centre_Calculator' ,....
       'NumberTitle', 'off',....
       'Tag','beam_centre_window',....
       'Color',grasp_env.background_color,....
       'menubar','none',....
       'resize','off');
   

   %Text
   uicontrol('units','normalized','Position',[0.09,0.74,0.09,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
       'String','Spot 1','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   uicontrol('units','normalized','Position',[0.09,0.61,0.09,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','Spot 2','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   uicontrol('units','normalized','Position',[0.09,0.43,0.09,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','Spot 3','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   uicontrol('units','normalized','Position',[0.09,0.30,0.09,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','Spot 4','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

     uicontrol('units','normalized','Position',[0.001,0.17,0.18,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','Beam Centre','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   uicontrol('units','normalized','Position',[0.19,0.83,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','x','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
      uicontrol('units','normalized','Position',[0.53,0.83,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','y','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   uicontrol('units','normalized','Position',[0.37,0.83,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','Err x','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
   uicontrol('units','normalized','Position',[0.71,0.83,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','Err y','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
	uicontrol('units','normalized','Position',[0.88,0.83,0.1,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
      'String','Capture','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

%Boxes
   uicontrol('units','normalized','Position',[0.22,0.76,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','x1','Visible','on');
   uicontrol('units','normalized','Position',[0.37,0.76,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','dx1','Visible','on');
   uicontrol('units','normalized','Position',[0.22,0.63,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','x2','Visible','on');
   uicontrol('units','normalized','Position',[0.37,0.63,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','dx2','Visible','on');
   uicontrol('units','normalized','Position',[0.56,0.76,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','y1','Visible','on');
   uicontrol('units','normalized','Position',[0.71,0.76,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','dy1','Visible','on');
   uicontrol('units','normalized','Position',[0.56,0.63,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','y2','Visible','on');
   uicontrol('units','normalized','Position',[0.71,0.63,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','dy2','Visible','on');
   uicontrol('units','normalized','Position',[0.22,0.45,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','x3','Visible','on');
   uicontrol('units','normalized','Position',[0.37,0.45,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','dx3','Visible','on');
   uicontrol('units','normalized','Position',[0.22,0.32,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','x4','Visible','on');
   uicontrol('units','normalized','Position',[0.37,0.32,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','dx4','Visible','on');
   uicontrol('units','normalized','Position',[0.56,0.45,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','y3','Visible','on');
   uicontrol('units','normalized','Position',[0.71,0.45,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','dy3','Visible','on');
   uicontrol('units','normalized','Position',[0.56,0.32,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','y4','Visible','on');
   uicontrol('units','normalized','Position',[0.71,0.32,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','dy4','Visible','on');


   uicontrol('units','normalized','Position',[0.22,0.19,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','x0','Visible','on');
   uicontrol('units','normalized','Position',[0.56,0.19,0.13,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','y0','Visible','on');
   uicontrol('units','normalized','Position',[0.27 0.05 0.45 0.08],'ToolTip','','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
      'string','Calculate','callback','fll_beam_centre_callbacks(''centre_calc'')');
   uicontrol('units','normalized','Position',[0.88 0.765 0.1 0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
      'string','Load','callBack','fll_beam_centre_callbacks(''load'',1);');    
   uicontrol('units','normalized','Position',[0.88 0.64 0.1 0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
      'string','Load','callBack','fll_beam_centre_callbacks(''load'',2);');
   uicontrol('units','normalized','Position',[0.88 0.46 0.1 0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
      'string','Load','callBack','fll_beam_centre_callbacks(''load'',3);');    
   uicontrol('units','normalized','Position',[0.88 0.33 0.1 0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton',...
      'string','Load','callBack','fll_beam_centre_callbacks(''load'',4);');
else
    figure(h)
end

   
   