function fll_window

global grasp_env
global grasp_handles
global displayimage
global inst_params

h=findobj('Tag','fll_window'); %Check to see if window is already open
if isempty(h) %i.e. if no window exists.

    fig_position = [grasp_env.screen.grasp_main_actual_position(1)*0.9, grasp_env.screen.grasp_main_actual_position(2)*0.5,   450*grasp_env.screen.screen_scaling(1)   250*grasp_env.screen.screen_scaling(2)];

    grasp_handles.window_modules.fll_window.window = figure(....
        'units','pixels',....
        'Position',fig_position,....
        'Name','Flux_Line_Lattice!',....
        'NumberTitle', 'off',....
        'Tag','fll_window',....
        'Color',grasp_env.background_color,....
        'menubar','none',....
        'resize','off');

    %Find some current parameters, if they exist
    wavelength = displayimage.params1(inst_params.vectors.wav);
    if wavelength ==0; wavelength =10; end %in case there is no data
    det_distance = displayimage.params1(inst_params.vectors.det);
    if det_distance == 0; det_distance = 17.6; end %in case there is no data
   
    
    
    %Widgets
    uicontrol('units','normalized','Position',[0.22,0.78,0.15,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','< == >','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.03,0.85,0.2,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','Field (G)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.38,0.85,0.16,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','d (microns)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.47,0.78,0.2,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','< == >','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.72,0.85,0.1,0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','q (A-1)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.905,0.89,0.05,0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text',...
        'String','Sqr','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.35,0.6,0.2,0.10],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text',...
        'String','a0 (microns)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

    uicontrol('units','normalized','Position',[0.1,0.8,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','fll_B','Visible','on','CallBack','fll_callbacks(''1'');');
    uicontrol('units','normalized','Position',[0.4,0.8,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','fll_d','Visible','on','CallBack','fll_callbacks(''2'');');
    uicontrol('units','normalized','Position',[0.4,0.55,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','fll_a0','Visible','on','CallBack','fll_callbacks(''3'');');
    uicontrol('units','normalized','Position',[0.7,0.8,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String','0','HorizontalAlignment','left','Tag','fll_q','Visible','on','CallBack','fll_callbacks(''4'');');
    uicontrol('units','normalized','Position',[0.92,0.82,0.04,0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','fll_symmetry','BackgroundColor', [0.2,0.2,0.2], 'ForegroundColor', [1,1,1],'value',0,'CallBack','fll_callbacks(''5'');');

    %Two theta calculator
    uicontrol('units','normalized','Position',[0.1,0.3,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(wavelength),'HorizontalAlignment','left','Tag','fll_wav','Visible','on','CallBack','fll_callbacks(''1'');');
    uicontrol('units','normalized','Position',[0.4,0.3,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','0','HorizontalAlignment','left','Tag','fll_2theta','Visible','on');

    uicontrol('units','normalized','Position',[0.07,0.38,0.28,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text',...
        'String','Wavelength (Angs)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.36,0.38,0.28,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text',...
        'String','Two theta (Degs)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

    %Pixel counter
    uicontrol('units','normalized','Position',[0.1,0.06,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(det_distance),'HorizontalAlignment','left','Tag','fll_det','Visible','on','CallBack','fll_callbacks(''1'');');
    uicontrol('units','normalized','Position',[0.4,0.06,0.15,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','0','HorizontalAlignment','left','Tag','fll_detpixels','Visible','on');

    uicontrol('units','normalized','Position',[0.07,0.15,0.28,0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text',...
        'String','Detector distance (m)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.36,0.14,0.28,0.08],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text',...
        'String','FLL position (pixels)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
else
    figure(h)
end

