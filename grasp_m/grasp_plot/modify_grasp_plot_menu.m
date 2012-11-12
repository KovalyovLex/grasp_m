function grasp_plot_handles = modify_grasp_plot_menu(grasp_plot_handles)

%***** MENU's *****
%Menu: File
handle = uimenu(grasp_plot_handles.figure,'label','&File');

%Export Graphics
handle2 = uimenu(handle,'label','&Export Image');
    uimenu(handle2,'label','bmp...','callback','grasp_plot_image_export(''bmp'');');
    uimenu(handle2,'label','jpg...','callback','grasp_plot_image_export(''jpg'');');
    uimenu(handle2,'label','png...','callback','grasp_plot_image_export(''png'');');
    uimenu(handle2,'label','tiff...','callback','grasp_plot_image_export(''tif'');');
    uimenu(handle2,'label','eps...','callback','grasp_plot_image_export(''eps'');');
    uimenu(handle2,'label','Adobe Illustrator...','callback','grasp_plot_image_export(''ai'');');
    uimenu(handle2,'label','PDF...','callback','grasp_plot_image_export(''pdf'');');
    uimenu(handle2,'label','Copy to Clipboard...','callback','grasp_plot_image_export(''clipboard'');');

%Export Data
handle3 = uimenu(handle,'label','Export &Data','separator','on');
    uimenu(handle3,'label','Export Data','callback','grasp_plot_menu_callbacks(''export_data'');');
    uimenu(handle3,'label','Export &Fit Curves','separator','off','callback','grasp_plot_menu_callbacks(''export_fit_curves'');');

handle4 = uimenu(handle3,'label','Export Options');
    grasp_plot_handles.grasp_plot_menu.export_options.ascii = uimenu(handle4,'label','ASCII Columns','callback','grasp_plot_menu_callbacks(''options_ascii'');');
    grasp_plot_handles.grasp_plot_menu.export_options.auto_filename = uimenu(handle4,'label','Auto FileName(RunNumber)','callback','grasp_plot_menu_callbacks(''options_auto_filename'');');
    grasp_plot_handles.grasp_plot_menu.export_options.colum_labels = uimenu(handle4,'label','Column Labels','callback','grasp_plot_menu_callbacks(''options_column_labels'');');
    grasp_plot_handles.grasp_plot_menu.export_options.data_history = uimenu(handle4,'label','Data History','callback','grasp_plot_menu_callbacks(''options_data_history'');');
    grasp_plot_handles.grasp_plot_menu.export_options.resolution = uimenu(handle4,'label','Include q-resolution','callback','grasp_plot_menu_callbacks(''options_q_resolution'');');
    grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_root = uimenu(handle4,'label','q-resolution format');
    grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_fwhm = uimenu(grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_root,'label','fwhm','callback','grasp_plot_menu_callbacks(''options_q_format'',''fwhm'');');
    grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_hwhm = uimenu(grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_root,'label','hwhm','callback','grasp_plot_menu_callbacks(''options_q_format'',''hwhm'');');
    grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_sigma = uimenu(grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_root,'label','sigma','callback','grasp_plot_menu_callbacks(''options_q_format'',''sigma'');');

    grasp_plot_handles.grasp_plot_menu.export_options.illg = uimenu(handle4,'label','ILL SANS g******.100 format','callback','grasp_plot_menu_callbacks(''options_illg'');');


%Print
uimenu(handle,'label','P&age Setup...','callback','pagesetupdlg','separator','on');
uimenu(handle,'label','Print Set&up...','callback','filemenufcn(gcbf,''FilePrintSetup'')');
uimenu(handle,'label','&Quick Print...','callback','grasp_plot_image_export(''prn'');');
uimenu(handle,'label','&Page Layout Print...','callback','output_figure(''sub'')');

%Exit
uimenu(handle,'label','&Exit','callback','closereq','separator','on');

%Analysis Menu
handle = uimenu(grasp_plot_handles.figure,'label','&Analysis');
handle2 = uimenu(handle,'label','&Curve Fit','callback','grasp_plot_fit_window');
handle2 = uimenu(handle,'label','&Average Fit Parameters','callback','grasp_plot_fit_callbacks(''average_fit_params'');');
handle2 = uimenu(handle,'label','&Calculate Average & Moments','callback','grasp_plot_callbacks(''moments'');');
handle2 = uimenu(handle,'label','Show q Resolution (FWHM x-bars)');
grasp_plot_handles.grasp_plot_menu.analysis.show_res_on = uimenu(handle2,'label','On','callback','grasp_plot_menu_callbacks(''show_q_resolution'',''on'')');
grasp_plot_handles.grasp_plot_menu.analysis.show_res_off = uimenu(handle2,'label','Off','callback','grasp_plot_menu_callbacks(''show_q_resolution'',''off'')');
uimenu(handle,'label',['Re-bin Curves'],'callback','grasp_plot_callbacks(''re_bin_curves'');');
uimenu(handle,'label',['Re-bin Parameters'],'callback','rebin_window');


%Menu: Curve Edit
grasp_plot_handles.curve_tools_menu = uimenu(grasp_plot_handles.figure,'label','&Curve Tools');
    %grasp_plot_handles.erase_curves_menu = uimenu(handle,'label','&Erase Curves','tag','erase_curve');
    %grasp_plot_handles.merge_curves_menu = uimenu(handle,'label','&Merge Curves');
    %grasp_plot_handles.merge_all_menu = uimenu(handle,'label','&All Curves','callback','grasp_plot_callbacks(''merge_curves'')');
    %grasp_plot_handles.rescale_curve = uimenu(handle,'label','&Rescale Curve','callback','grasp_plot_callbacks(''rescale_curve'');');
%handle3_2 = uimenu(handle3,'label','&Choose Curves','callback','curve_regroup_v2');
%handle4 = uimenu(handle_plot,'label','&Mathematical Operations');%,'callback','curve_math');
%handle4_1 = uimenu(handle4,'label','&In Curves','callback','curve_math(''curves'')');
%handle4_2 = uimenu(handle4,'label','&Factor','callback','curve_math(''factor'')');

%Update Menu ticks
%grasp_plot_menu_callbacks