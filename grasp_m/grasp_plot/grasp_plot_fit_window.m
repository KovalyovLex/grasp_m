function grasp_plot_fit_window

global grasp_env
global grasp_handles
global status_flags


%***** Open 1D Curve Fit Window *****
if ishandle(grasp_handles.window_modules.curve_fit1d.window)
    if strcmp(get(grasp_handles.window_modules.curve_fit1d.window,'tag'),'curve_fit_window');
        figure(grasp_handles.window_modules.curve_fit1d.window)
        return
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3)-450*grasp_env.screen.screen_scaling(1), grasp_env.screen.grasp_main_actual_position(2)+grasp_env.screen.grasp_main_actual_position(4)-800*grasp_env.screen.screen_scaling(2),   450*grasp_env.screen.screen_scaling(1)   800*grasp_env.screen.screen_scaling(2)];
    grasp_handles.window_modules.curve_fit1d.window = figure(....
        'units','pixels',....
        'Position',fig_position,....
        'Name','Curve Fit Control',....
        'NumberTitle', 'off',....
        'Tag','curve_fit_window',....
        'color',grasp_env.sub_figure_background_color,....
        'papertype','A4',....
        'renderer','zbuffer',....
        'menubar','none',....
        'closerequestfcn','closereq',....
        'resize','off');

    %Curve Number
    uicontrol('units','normalized','Position',[0.52 0.9 0.25 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Curve Number:'],'BackgroundColor', grasp_env.sub_figure_background_color, 'ForegroundColor', [1 1 1]);
    grasp_handles.window_modules.curve_fit1d.curve_number = uicontrol('units','normalized','Position',[0.78 0.9 0.1 0.03],'ToolTip','Select Curve to Fit','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','Popup','Tag','curve_fit_selector','Value',1,'string','1','callback','grasp_plot_fit_callbacks(''curve_number'');');
    
    %Fit All Curves Simultaneously
    uicontrol('units','normalized','Position',[0.52 0.86 0.25 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Fit All Curves:'],'BackgroundColor', grasp_env.sub_figure_background_color, 'ForegroundColor', [1 1 1]);
    grasp_handles.window_modules.simultaneous_curves = uicontrol('units','normalized','Position',[0.78 0.865 0.05 0.03],'ToolTip','Fit All Curves Simultaneously','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','Value',status_flags.fitter.simultaneous_check,'BackgroundColor', grasp_env.sub_figure_background_color,'callback','grasp_plot_fit_callbacks(''simultaneous_fit_check'');');
    
    %Smear for Instrument Resolution
    uicontrol('units','normalized','Position',[0.02 0.86 0.25 0.03],'Tag','fit_resolution_text','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Include Resolution:'],'BackgroundColor', grasp_env.sub_figure_background_color, 'ForegroundColor', [1 1 1],'Visible',status_flags.fitter.res1d_option);
    uicontrol('units','normalized','Position',[0.28 0.865 0.038,0.028],'Tag','fit_resolution_div_check','ToolTip','Enable / Disable Model Smearing to Instrument Resolution','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','Visible',status_flags.fitter.res1d_option,'value',status_flags.fitter.include_res_check,'BackgroundColor', grasp_env.sub_figure_background_color,'callback','grasp_plot_fit_callbacks(''include_resolution_check'');');

    %Resolution control centre button
   % uicontrol('units','normalized','Position',[0.32 0.865 0.25,0.028],'ToolTip','Open Resolution Control Centre','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','pushbutton','string','Resolution Control','Visible',status_flags.fitter.res1d_option,'callback','grasp_plot_resolution_control_window;');
    
    
    %Function selector
    uicontrol('units','normalized','Position',[0.02 0.95 0.25 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Fitting Function:'],'BackgroundColor', grasp_env.sub_figure_background_color, 'ForegroundColor', [1 1 1]);
    grasp_handles.window_modules.curve_fit1d.fn_selector = uicontrol('units','normalized','Position',[0.28 0.95 0.35 0.03],'ToolTip','Select Fitting Function','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','Tag','fit_function_selector','Visible','on',....
        'String',' ','value',status_flags.fitter.fn1d,'callback','grasp_plot_fit_callbacks(''toggle_fn'');');

    %Simultaneous Functions Selector
    no_fun_string = '1|2|3|4';
    uicontrol('units','normalized','Position',[0.02 0.9 0.25 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['No. of Functions:'],'BackgroundColor', grasp_env.sub_figure_background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.28 0.9 0.1 0.03],'ToolTip','Number of Simultaneous Functions to Fit','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','Tag','no_functions_selector','Visible','on',....
        'String',no_fun_string,'value',status_flags.fitter.number1d,'callback','grasp_plot_fit_callbacks(''number_of_fn'');');

    %Parameters - mainly updated in curve_fit_window_mod
    uicontrol('units','normalized','Position',[0.02 0.80 0.3 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String',['Parameters:'],'BackgroundColor', grasp_env.sub_figure_background_color, 'ForegroundColor', [1 1 1]);
    uicontrol('units','normalized','Position',[0.35 0.80 0.55 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','center','Style','text','BackgroundColor', grasp_env.sub_figure_background_color, 'ForegroundColor', [1 1 1],...
        'String',['fix       value          err           function']);

    %Auto Guess Parameters Button
    uicontrol('units','normalized','Position',[0.05 0.02 0.2 0.03],'ToolTip','Automatically Guess Starting Parameters from Zoomed Data','String','Auto_Guess','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','fit_auto_guess','Visible','on','CallBack','grasp_plot_fit_callbacks(''auto_guess'',''auto_guess'');');
    %Point and Click Parameters Button
    uicontrol('units','normalized','Position',[0.275 0.02 0.2 0.03],'ToolTip','Point and Click to determine Starting Parameters','String','Point & Click','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','fit_point_click','Visible','on','CallBack','grasp_plot_fit_callbacks(''auto_guess'',''point_click'');');
    %Fit it Button
    uicontrol('units','normalized','Position',[0.5 0.02 0.2 0.03],'ToolTip','Fit It!','String','Fit It!','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','fit_it_now','Visible','on','CallBack','grasp_plot_fit_callbacks(''fit_it'');');
    %Delete Last Fit Button
    uicontrol('units','normalized','Position',[0.725 0.02 0.2 0.03],'ToolTip','Delete Last Fit Curve!','String','Del Curve','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','delete_last_curve_fit','Visible','on',...
        'CallBack','grasp_plot_fit_callbacks(''delete_curves'');');
    %Delete curve on/off button
    uicontrol('units','normalized','Position',[0.93 0.02 0.04 0.03],'ToolTip','Delete Curve Off/On','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','value',status_flags.fitter.delete_curves_check,'Visible','on','BackgroundColor', grasp_env.sub_figure_background_color,'CallBack','grasp_plot_fit_callbacks(''delete_onoff_check'');');
    
    
    %Copy Params to Clipboard Button
    uicontrol('units','normalized','Position',[0.725 0.06 0.2 0.03],'ToolTip','Copy Fit Parameters to Clipboard','String','Copy to Clip','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','pushbutton','Tag','fit_clipboard','Visible','on','CallBack','grasp_plot_fit_callbacks(''copy_to_clipboard'');');

    
    %Build the list of fitting functions
    grasp_plot_fit_callbacks('build_curve_number');
    grasp_plot_fit_callbacks('build_fn_list'); %update the current list of functions
    grasp_plot_fit_callbacks('retrieve_fn'); %update the current function
    grasp_plot_fit_callbacks('update_curve_fit_window');

