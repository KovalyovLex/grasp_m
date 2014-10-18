function curve_fit_window_2d

global grasp_env
global status_flags
global grasp_handles

%Check to see if curve fit window is already open
if ishandle(grasp_handles.window_modules.curve_fit2d.window)
    if strcmp(get(grasp_handles.window_modules.curve_fit2d.window,'tag'),'curve_fit_window_2d');
        figure(grasp_handles.window_modules.curve_fit2d.window);
        return
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   432*grasp_env.screen.screen_scaling(1)   919*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.curve_fit2d.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Curve Fit Control - 2D',....
    'NumberTitle', 'off',....
    'Tag','curve_fit_window_2d',....
    'color',grasp_env.background_color,...
    'papertype','A4',....
    'renderer','zbuffer',....
    'menubar','none',....
    'closerequestfcn','curve_fit_2d_callbacks(''delete_curves'');closereq',....
    'resize','off');


%Function selector
uicontrol('units','normalized','Position',[0.02 0.96 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Fitting Function:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.curve_fit2d.fn_selector = uicontrol('units','normalized','Position',[0.28 0.96 0.45 0.02],'ToolTip','Select Fitting Function','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','Tag','2d_fit_function_selector','Visible','on',....
    'String','','value',status_flags.fitter.fn2d,'callback','curve_fit_2d_callbacks(''toggle_fn'');');

%Number of Simultaneous Functions Selector
no_fun_string = '1|2|3';
uicontrol('units','normalized','Position',[0.02 0.92 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['No. of Functions:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol('units','normalized','Position',[0.28 0.92 0.1 0.02],'ToolTip','Number of Simultaneous Functions to Fit','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','Tag','no_functions_selector_2d','Visible','on',....
    'String',no_fun_string,'value',status_flags.fitter.number2d,'callback','curve_fit_2d_callbacks(''number_of_fn'');');

%Resolution Check-Box
uicontrol('units','normalized','Position',[0.52 0.93 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Resolution:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol('units','normalized','Position',[0.78 0.93 0.05 0.02],'ToolTip','Resolution smear model to fit data in 2D - Warning - Makes fitting very slow!','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','Tag','resolution_checkbox_2d','Visible','on',....
    'ForegroundColor', [1 1 1],'BackgroundColor', grasp_env.background_color,'value',status_flags.fitter.include_res_check_2d,'callback','curve_fit_2d_callbacks(''resolution_check'');');


%Multi Beam Check-Box
uicontrol('units','normalized','Position',[0.52 0.91 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['MultiBeam:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol('units','normalized','Position',[0.78 0.91 0.05 0.02],'ToolTip','Use MultiBeam Fitting - Take care you know what you are doing with this!','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','Tag','multibeam_checkbox_2d','Visible','on',....
    'ForegroundColor', [1 1 1],'BackgroundColor', grasp_env.background_color,'value',status_flags.analysis_modules.multi_beam.fit2d_checkbox,'callback','curve_fit_2d_callbacks(''multi_beam_check'');');

%Parameters - mainly updated in curve_fit_window_mod
uicontrol('units','normalized','Position',[0.02 0.87 0.3 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Parameters:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol('units','normalized','Position',[0.36 0.87 0.55 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','left','Style','text','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],...
    'String',['fix             value                err              group']);
%     uicontrol('units','normalized','Position',[0.90 0.87 0.1 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','center','Style','text','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],...
%         'String',['plot'],'tag','depth_fit_plot_string','visible','off');


%Auto Guess Parameters Button
uicontrol('units','normalized','Position',[0.05 0.01 0.2 0.02],'ToolTip','Automatically Guess Starting Parameters from Zoomed Data','String','Auto_Guess','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','fit_auto_guess','Visible','on','CallBack','curve_fit_2d_callbacks(''auto_guess'',''auto_guess'');');
%Point and Click Parameters Button
uicontrol('units','normalized','Position',[0.275 0.01 0.2 0.02],'ToolTip','Point and Click to determine Starting Parameters','String','Point & Click','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','fit_point_click','Visible','on','CallBack','curve_fit_2d_callbacks(''auto_guess'',''point_click'');');
%Fit it Button
uicontrol('units','normalized','Position',[0.5 0.01 0.2 0.02],'ToolTip','Fit It!','String','Fit It!','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','fit_it_now','Visible','on','CallBack','curve_fit_2d_callbacks(''fit_it'');');
%Fit Depth
uicontrol('enable','off','units','normalized','Position',[0.5 0.04 0.2 0.02],'ToolTip','Fit Depth!','String','Fit Depth!','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','depth_fit_it_now','Visible','on','CallBack','depth_fit_control_2d(''depth_fit'');');
%Plot Depth Param
uicontrol('enable','off','units','normalized','Position',[0.725 0.04 0.2 0.02],'ToolTip','Plot Fit Depth!','String','Plot Fit Depth!','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','[plot_fit_depth','Visible','on','CallBack','depth_fit_control_2d(''depth_plot'');');
%Delete Last Fit Button
uicontrol('units','normalized','Position',[0.725 0.01 0.2 0.02],'ToolTip','Delete Last Fit Curve!','String','Del Curve','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','delete_last_curve_fit','Visible','on',...
    'CallBack','curve_fit_2d_callbacks(''delete_curves'');');
%Copy Params to Clipboard
uicontrol('units','normalized','Position',[0.275 0.04 0.2 0.02],'ToolTip','Copy Fit Parameters to Clipboard','String','Copy to Clip','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','fit_clipboard','Visible','on','CallBack','curve_fit_2d_callbacks(''copy_to_clipboard'');');


%Fitted 2D Function & Error Plot
uicontrol('units','normalized','Position',[0.06 0.32 0.4 0.015],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','left','Style','text','String',['Fitted Function:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol('units','normalized','Position',[0.53 0.32 0.4 0.015],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','left','Style','text','String',['Residual: (Data-Fit) / Err_Data'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

%Update the curve fit window
curve_fit_2d_callbacks('build_fn_list');
curve_fit_2d_callbacks('retrieve_fn');
curve_fit_2d_callbacks('update_curve_fit_window');



