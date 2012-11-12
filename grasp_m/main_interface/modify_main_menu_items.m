function modify_main_menu_items(figure_handle)

global grasp_handles
global status_flags
global grasp_env

%***** Menu: File *****
grasp_handles.menu.file.root = uimenu(figure_handle,'label','&File');

%Project
grasp_handles.menu.file.open = uimenu(grasp_handles.menu.file.root,'label','&Open Project...','callback','file_menu(''open'');','separator','off','tag','file_open_project','accelerator','o');
grasp_handles.menu.file.close = uimenu(grasp_handles.menu.file.root,'label','&Close Project','callback','file_menu(''close'');','separator','off','tag','file_close_project');
grasp_handles.menu.file.save = uimenu(grasp_handles.menu.file.root,'label','&Save Project','callback','file_menu(''save'');','separator','off','tag','file_save_data','accelerator','s');
grasp_handles.menu.file.saveas = uimenu(grasp_handles.menu.file.root,'label','Save Project &As','callback','file_menu(''save_as'');','separator','off','tag','file_save_data_as');

%Project Directory
grasp_handles.menu.file.setprojectdir = uimenu(grasp_handles.menu.file.root,'label','Set &Project Directory','separator','on','tag','file_set_data_directory','callback','file_menu(''set_project_dir'');');

%Data Directory
grasp_handles.menu.file.setdir = uimenu(grasp_handles.menu.file.root,'label','Set &Data Directory','separator','on','tag','file_set_data_directory','callback','file_menu(''set_data_dir'');');
grasp_handles.menu.file.setfiledir = uimenu(grasp_handles.menu.file.root,'label','Set File & Data Directory','separator','off','tag','file_set_data_directory2','callback','file_menu(''set_filedata_dir'');');

%Export Image
grasp_handles.menu.file.export_image.root = uimenu(grasp_handles.menu.file.root,'label','&Export Image','callback','','separator','on','tag','file_export_image');
grasp_handles.menu.file.export_image.bmp = uimenu(grasp_handles.menu.file.export_image.root,'label','bmp...','callback','file_menu_image_export(''bmp'');');
grasp_handles.menu.file.export_image.jpg = uimenu(grasp_handles.menu.file.export_image.root,'label','jpg...','callback','file_menu_image_export(''jpg'');');
grasp_handles.menu.file.export_image.png = uimenu(grasp_handles.menu.file.export_image.root,'label','png...','callback','file_menu_image_export(''png'');');
grasp_handles.menu.file.export_image.tiff = uimenu(grasp_handles.menu.file.export_image.root,'label','tiff...','callback','file_menu_image_export(''tif'');');
grasp_handles.menu.file.export_image.eps = uimenu(grasp_handles.menu.file.export_image.root,'label','eps...','callback','file_menu_image_export(''eps'');');
grasp_handles.menu.file.export_image.ai = uimenu(grasp_handles.menu.file.export_image.root,'label','Adobe Illustrator...','callback','file_menu_image_export(''ai'');');
grasp_handles.menu.file.export_image.pdf = uimenu(grasp_handles.menu.file.export_image.root,'label','pdf...','callback','file_menu_image_export(''pdf'');');
grasp_handles.menu.file.export_image.copyclip = uimenu(grasp_handles.menu.file.export_image.root,'label','Copy to Clipboard...','callback','editmenufcn(gcbf,''EditCopyFigure'')');
grasp_handles.menu.file.export_image.jpgmovie = uimenu(grasp_handles.menu.file.export_image.root,'label','jpg movie frames...','callback','file_menu_image_export(''jpg_movie_frames'');');

%Export Data
enable = 'on';
grasp_handles.menu.file.export_data.root = uimenu(grasp_handles.menu.file.root,'label','Export &Data','callback','','separator','on','tag','file_export_data','enable',enable);
%grasp_handles.menu.file.export_data.displaydata = uimenu(grasp_handles.menu.file.export_data.root,'label','Export Display Image:  ILL Raw SANS Format','callback','file_menu(''export_displayimage'');','enable','off'); %Fake 2D ILL Format SANS Data File
grasp_handles.menu.file.export_data.binarydata = uimenu(grasp_handles.menu.file.export_data.root,'label','Export Binary (real*4) Display Image','callback','file_menu(''export_binary'');');
grasp_handles.menu.file.export_data.detector_efficiency = uimenu(grasp_handles.menu.file.export_data.root,'label','Export Detector Efficiency Map','callback','file_menu(''export_efficiency_map'');');
grasp_handles.menu.file.export_data.export_depth_frames = uimenu(grasp_handles.menu.file.export_data.root,'label','Export Depth Frames (ILL Raw Data)','callback','file_menu(''export_depth_frames'');');


%Import Data
enable = 'off';
grasp_handles.menu.file.import_data.root = uimenu(grasp_handles.menu.file.root,'label','Import &Data','callback','','separator','on','tag','file_import_data','enable',enable);
grasp_handles.menu.file.import_data.detector_efficiency = uimenu(grasp_handles.menu.file.import_data.root,'label','Import Detector Efficiency Map','callback','file_menu(''import_efficiency_map'');');

%Import / Export Masks
enable = 'on';
grasp_handles.menu.file.masks_data.root = uimenu(grasp_handles.menu.file.root,'label','&Mask: Import / Export','callback','','separator','on','tag','file_export_data','enable',enable);
grasp_handles.menu.file.masks_data.mask_export = uimenu(grasp_handles.menu.file.masks_data.root,'label','Export Mask...','callback','file_menu(''save_mask'');');
grasp_handles.menu.file.masks_data.mask_import = uimenu(grasp_handles.menu.file.masks_data.root,'label','Import Mask...','callback','file_menu(''import_mask'');');


%Import Data
%grasp_handles.menu.file.import_data.root = uimenu(grasp_handles.menu.file.root,'label','Import Data','callback','','separator','on','tag','file_import_data');
%grasp_handles.menu.file.import_data.mask = uimenu(grasp_handles.menu.file.import_data.root,'label','Import Mask...','callback','file_menu(''import_mask'');'); 

%Add Worksheet number
grasp_handles.menu.file.workheet.root = uimenu(grasp_handles.menu.file.root,'label','Worksheets','callback','','separator','on','tag','file_worksheets');
grasp_handles.menu.file.workheet.addwks = uimenu(grasp_handles.menu.file.workheet.root,'label','Add Worksheet Number...','callback','add_worksheet;'); 

%Print
%uimenu(handle,'label','P&age Setup...','callback','pagedlg','separator','on','tag','file_page_setup');
%uimenu(handle,'label','Print Set&up...','callback','filemenufcn(gcbf,''FilePrintSetup'')','tag','file_print_setup');
grasp_handles.menu.file.quickprint = uimenu(grasp_handles.menu.file.root,'label','&Quick Print...','callback','file_menu_image_export prn','separator','on','tag','file_print');
enable = 'on';
grasp_handles.menu.file.pagelayoutprint = uimenu(grasp_handles.menu.file.root,'label','&Page Layout Print...','callback','output_figure','tag','file_layout_print','enable',enable);

%Preferences
grasp_handles.menu.file.preferences.root = uimenu(grasp_handles.menu.file.root,'label','Preferences...','separator','on','tag','file_preferences');
%Show resolution in output figures
grasp_handles.menu.file.preferences.show_resolution = uimenu(grasp_handles.menu.file.preferences.root,'checked',status_flags.subfigure.show_resolution,'label','Show Resolution in Figures','callback','file_menu(''show_resolution'');');

%Preferences: Font
grasp_handles.menu.file.preferences.font = uimenu(grasp_handles.menu.file.preferences.root,'label','Font & Font Size','callback','file_menu(''uisetfont'');');
%Preferences: Line Style
grasp_handles.menu.file.preferences.linestyle.root = uimenu(grasp_handles.menu.file.preferences.root,'label','Line Style');
grasp_handles.menu.file.preferences.linestyle.none = uimenu(grasp_handles.menu.file.preferences.linestyle.root,'label','None','callback','file_menu(''line_style'',''none'');','checked','off','tag','linestyle_menu');
grasp_handles.menu.file.preferences.linestyle.solid = uimenu(grasp_handles.menu.file.preferences.linestyle.root,'label','Solid -','callback','file_menu(''line_style'',''solid'');','checked','off','tag','linestyle_menu');
grasp_handles.menu.file.preferences.linestyle.dotted = uimenu(grasp_handles.menu.file.preferences.linestyle.root,'label','Dotted :','callback','file_menu(''line_style'',''dotted'');','checked','off','tag','linestyle_menu');
grasp_handles.menu.file.preferences.linestyle.dashdot = uimenu(grasp_handles.menu.file.preferences.linestyle.root,'label','Dash-Dot -.','callback','file_menu(''line_style'',''dashdot'');','checked','off','tag','linestyle_menu');
grasp_handles.menu.file.preferences.linestyle.dashed = uimenu(grasp_handles.menu.file.preferences.linestyle.root,'label','Dashed --','callback','file_menu(''line_style'',''dashed'');','checked','off','tag','linestyle_menu');

%Preferences: LineWidth
grasp_handles.menu.file.preferences.linewidth.root = uimenu(grasp_handles.menu.file.preferences.root,'label','Line Width');
linewidth_handles = [];
for linewidth = 1:1:10
    handle = uimenu(grasp_handles.menu.file.preferences.linewidth.root,'label',num2str(linewidth),'callback','file_menu(''linewidth'');','checked','off','userdata',linewidth,'tag','linewidth_menu');
    linewidth_handles = setfield(linewidth_handles,['width' num2str(linewidth)],handle);
end
grasp_handles.menu.file.preferences.linewidth.width = linewidth_handles;

%Preference:  Marker Size
grasp_handles.menu.file.preferences.markersize.root = uimenu(grasp_handles.menu.file.preferences.root,'label','Marker Size');
marker_size_handles = [];
for markersize = 1:1:10
    handel = uimenu(grasp_handles.menu.file.preferences.markersize.root,'label',num2str(markersize),'callback','file_menu(''markersize'');','checked','off','userdata',markersize,'tag','markersize_menu');
    marker_size_handles = setfield(marker_size_handles,['markersize' num2str(markersize)],handel);
end
grasp_handles.menu.file.preferences.markersize.markersize = marker_size_handles;

%Preferences:  Invert HardCopy Print
visible = 'off';
grasp_handles.menu.file.preferences.inverthard = uimenu(grasp_handles.menu.file.preferences.root,'label','Invert Hard Copy (BW => WB)','checked','off','tag','invert_hardcopy','callback','file_menu(''invert_hardcopy'');','visible',visible);
%Preferences:  Save Sub_Figures
grasp_handles.menu.file.preferences.save_subfigure = uimenu(grasp_handles.menu.file.preferences.root,'label','Save Sub_Figures in Project','checked','off','tag','save_sub_figures','callback','file_menu(''save_sub_figures'');','enable','on');

%Exit
grasp_handles.menu.file.exit = uimenu(grasp_handles.menu.file.root,'label','&Exit','separator','on','callback','file_menu(''exit'');');



%***** Menu: Display *****
grasp_handles.menu.display.root = uimenu(figure_handle,'label','&Display');
%Image Render
grasp_handles.menu.display.render.root = uimenu(grasp_handles.menu.display.root,'label','Image &Render','tag','render_menu');
grasp_handles.menu.display.render.flat = uimenu(grasp_handles.menu.display.render.root,'label','&flat','tag','render_flat','callback','menu_callbacks(''image_render'',''flat'');','accelerator','0');
grasp_handles.menu.display.render.interp = uimenu(grasp_handles.menu.display.render.root,'label','&interp','tag','render_interp','callback','menu_callbacks(''image_render'',''interp'');','accelerator','9');
grasp_handles.menu.display.render.faceted = uimenu(grasp_handles.menu.display.render.root,'label','&faceted','tag','render_faceted','callback','menu_callbacks(''image_render'',''faceted'');','accelerator','8');

%Palette
grasp_handles.menu.display.colormap.root = uimenu(grasp_handles.menu.display.root,'label','&Colour Map','tag','color_menu');
colormaps = {'hsv','hot','cool','jet','harrier','spring','summer','autumn','winter','gray','bone','copper','pink',...
        'bathtime','blues','barbie','damson','aubergine','blueberry','grass','pond','army1','army2','wolves'};
grasp_handles.menu.display.colormap.map =[];
grasp_handles.figure.image_context.map_handles = [];
status_flags.color.color_maps = [];
for n = 1:length(colormaps);
   callback_string = ['menu_callbacks(''palette'',''' colormaps{n} ''');'];
   h=uimenu(grasp_handles.menu.display.colormap.root,'label',colormaps{n},'tag','color_menu_item','callback',callback_string);
   grasp_handles.menu.display.colormap.map = [grasp_handles.menu.display.colormap.map, h];

   i = uimenu(grasp_handles.figure.image_context.root,'label',colormaps{n},'callback',callback_string);
   grasp_handles.figure.image_context.map_handles = [grasp_handles.figure.image_context.map_handles, i];
   
   status_flags.color.color_maps{n} = colormaps{n};
end


%Palette Invert and Swap Options
grasp_handles.menu.display.colormap.invert = uimenu(grasp_handles.menu.display.colormap.root,'label','Invert UD','tag','color_menu_other','separator','on','callback','menu_callbacks(''color_invert'');');
grasp_handles.menu.display.colormap.swap = uimenu(grasp_handles.menu.display.colormap.root,'label','Swap LR','tag','color_menu_other','callback','menu_callbacks(''color_swap'');');

%Color sliders
grasp_handles.menu.display.color_sliders = uimenu(grasp_handles.menu.display.root,'label','&Colour Sliders Tool','tag','color_sliders','callback','color_sliders');


%display I, log10(I), sqrt(I) or asinh(I)
grasp_handles.menu.display.zscale.root = uimenu(grasp_handles.menu.display.root,'label','Z Scale Option');
%log10
grasp_handles.menu.display.zscale.logz = uimenu(grasp_handles.menu.display.zscale.root,'label','Log Z','callback','menu_callbacks(''z_scale'',''Log Z'');');
grasp_handles.figure.logz_context.logz = uimenu(grasp_handles.figure.logz_context.root,'label','Log Z','callback','menu_callbacks(''z_scale'',''Log Z'')');
%sqrt
grasp_handles.menu.display.zscale.sqrtz = uimenu(grasp_handles.menu.display.zscale.root,'label','Sqrt Z','callback','menu_callbacks(''z_scale'',''Sqrt Z'');');
grasp_handles.figure.logz_context.sqrtz = uimenu(grasp_handles.figure.logz_context.root,'label','Sqrt Z','callback','menu_callbacks(''z_scale'',''Sqrt Z'');');
%asinh
grasp_handles.menu.display.zscale.asinhz = uimenu(grasp_handles.menu.display.zscale.root,'label','Asinh Z','callback','menu_callbacks(''z_scale'',''Asinh Z'');');
grasp_handles.figure.logz_context.asinhz = uimenu(grasp_handles.figure.logz_context.root,'label','Asinh Z','callback','menu_callbacks(''z_scale'',''Asinh Z'');');

%Contour Options
enable = 'on';
levels = [2,5,8,10,15,20,35,50,75,100];
contour_options = struct('current_style',1,'auto_levels',levels,'auto_levels_index',3,'contour_max',100,'contour_min',0,'contour_interval',10,'percent_abs',2,'contours_string','','current_levels_list',[]);
grasp_handles.menu.display.contourlevels = uimenu(grasp_handles.menu.display.root,'label','Contour &Levels','callback','contour_options_window','accelerator','l','userdata',contour_options,'tag','contour_menu','enable',enable);
%Contour Colors
grasp_handles.menu.display.contourcolors.root = uimenu(grasp_handles.menu.display.root,'label','Contour Colo&rs');
colors = {'white','black','red','green','blue','cyan','magenta','yellow','Color Map'};
color_linespec = {'w','k','r','g','b','c','m','y','x'};

grasp_handles.menu.display.contourcolors.colors =[];
grasp_handles.figure.contour_context.color = [];
for n = 1:length(colors);
    %display menu item
   h = uimenu(grasp_handles.menu.display.contourcolors.root,'label',colors{n},'tag','contour_color','userdata',color_linespec{n},'callback','menu_callbacks(''contour_color'');');
   grasp_handles.menu.display.contourcolors.colors  = [grasp_handles.menu.display.contourcolors.colors, h];
   %context menu item
    i = uimenu(grasp_handles.figure.contour_context.root,'label',colors{n},'tag','contour_color','userdata',color_linespec{n},'callback','menu_callbacks(''contour_color'');');
    grasp_handles.figure.contour_context.color = [grasp_handles.figure.contour_context.color, i];
end

%Smoothing Kernels
grasp_handles.menu.display.smoothkernel.root = uimenu(grasp_handles.menu.display.root,'label','Smoothing &Kernel');
kernel_name = {'Box 3x3','Box 5x5','Box 7x7','Gauss 1pxl FWHM','Gauss 2pxl FWHM','Gauss 3pxl FWHM','Gauss 4pxl FWHM', 'Gauss 5pxl FWHM'};
gauss1 = gauss_kernel(1);
gauss2 = gauss_kernel(2);
gauss3 = gauss_kernel(3);
gauss4 = gauss_kernel(4);
gauss5 = gauss_kernel(5);
kernel_data = {ones(3,3)./(3.*3),ones(5,5)./(5.*5),ones(7,7)./(7.*7),gauss1,gauss2,gauss3,gauss4,gauss5};
grasp_handles.menu.display.smoothkernel.kernel = [];
grasp_handles.figure.smooth_context.smooth = [];
for n = 1:length(kernel_name);
    %display menu item
    h = uimenu(grasp_handles.menu.display.smoothkernel.root,'label',kernel_name{n},'tag','smooth_kernel','userdata',kernel_data{n},'callback','menu_callbacks(''smooth_kernel'');');
    %context menu item
    i = uimenu(grasp_handles.figure.smooth_context.root,'label',kernel_name{n},'tag','smooth_kernel','userdata',kernel_data{n},'callback','menu_callbacks(''smooth_kernel'');');
    grasp_handles.menu.display.smoothkernel.kernel = [grasp_handles.menu.display.smoothkernel.kernel, h];
    grasp_handles.figure.smooth_context.smooth = [grasp_handles.figure.smooth_context.smooth, i];
end

%Flip LR & UD Display Image (ONLY dislpay image - do not operate on flipped data)
grasp_handles.menu.display.flip.root = uimenu(grasp_handles.menu.display.root,'label','Flip Display Image');
grasp_handles.menu.display.flip.updown = uimenu(grasp_handles.menu.display.flip.root,'label','Flip Up/Down','tag','flip_ud','callback','menu_callbacks(''flip_ud'');');
grasp_handles.menu.display.flip.lr = uimenu(grasp_handles.menu.display.flip.root,'label','Flip Left/Right','tag','flip_lr','callback','menu_callbacks(''flip_lr'');');

%Zoom Options
grasp_handles.menu.display.zoom.root = uimenu(grasp_handles.menu.display.root,'label','&Zoom Options','tag','zoom_options');
grasp_handles.menu.display.zoom.square = uimenu(grasp_handles.menu.display.zoom.root,'label','Square Zoom','tag','square_zoom','accelerator','1','callback','menu_callbacks(''square_zoom'');');
grasp_handles.menu.display.zoom.manual = uimenu(grasp_handles.menu.display.zoom.root,'label','Manually Set Axes','tag','man_set_axis','accelerator','2','callback','tool_callbacks(''manual_scale'');');

%Show / Hide Graph Title
grasp_handles.menu.display.showtitle = uimenu(grasp_handles.menu.display.root,'label','Show Graph Title','tag','show_graph_title','accelerator','','checked','off','callback','menu_callbacks(''show_hide_title'');');

%Show / Hide Color Bar
grasp_handles.menu.display.showcolorbar = uimenu(grasp_handles.menu.display.root,'label','Show Colour Bar','tag','show_color_bar','accelerator','','checked','off','callback','menu_callbacks(''show_color_bar'');');

%Show / Hide Graph Axes
grasp_handles.menu.display.showaxes = uimenu(grasp_handles.menu.display.root,'label','Show Graph Axes','tag','show_graph_axes','accelerator','','checked','off','callback','menu_callbacks(''show_graph_axes'');');

%Show / Hide Axis box
grasp_handles.menu.display.axis_box = uimenu(grasp_handles.menu.display.root,'label','Show Axis Box','tag','show_graph_axes','accelerator','','checked','off','callback','menu_callbacks(''show_axis_box'');');

%Grasp Depth Movie
grasp_handles.menu.display.movie = uimenu(grasp_handles.menu.display.root,'label','Depth &Movie','tag','movie_menu','callback','grasp_movie','accelerator','f');

%Text Parameters display On/Off
grasp_handles.menu.display.parameter_display = uimenu(grasp_handles.menu.display.root,'separator','on','label','Parameters Text Display On/Off','callback','menu_callbacks(''parameter_display'');');

%Graphic Update On/Off
grasp_handles.menu.display.graphic_update = uimenu(grasp_handles.menu.display.root,'label','Graphic Update On/Off','callback','menu_callbacks(''graphic_update'');');




%***** Analysis Menu Items *****
%Menu: Analysis
grasp_handles.menu.analysis.root = uimenu(figure_handle,'label','&Analysis ','tag','analysis_menu');
%Launch Grasp Changer
enable = 'on';
grasp_handles.menu.analysis.algorithm.root = uimenu(grasp_handles.menu.analysis.root,'label','&Grasp Changer Window','callback','grasp_changer_gui','enable','on','accelerator','g','enable',enable);
%Reduction Algorithm
grasp_handles.menu.analysis.algorithm.root = uimenu(grasp_handles.menu.analysis.root,'label','&Reduction Algorithm','callback','','enable','on');
grasp_handles.menu.analysis.algorithm.standard = uimenu(grasp_handles.menu.analysis.algorithm.root,'label','Standard: Sample, Background, Cadmium','callback','menu_callbacks(''algorithm'',''standard'');','enable','on');
%grasp_handles.menu.analysis.algorithm.subtract = uimenu(grasp_handles.menu.analysis.algorithm.root,'label','Subtract: Sample - Background','callback','');
%grasp_handles.menu.analysis.algorithm.add = uimenu(grasp_handles.menu.analysis.algorithm.root,'label','Add: Sample + Background','callback','');
enable = 'on';
grasp_handles.menu.analysis.algorithm.divide = uimenu(grasp_handles.menu.analysis.algorithm.root,'label','Divide: Sample / Background  : Be aware of artifacts for sparse data','callback','menu_callbacks(''algorithm'',''divide'');','enable',enable);
enable = 'off';
grasp_handles.menu.analysis.algorithm.multiply = uimenu(grasp_handles.menu.analysis.algorithm.root,'label','Multiply: Sample * Background','callback','menu_callbacks(''algorithm'',''multiply'');','enable','off');


%Radial & Azimuthal Average
grasp_handles.menu.analysis.averaging = uimenu(grasp_handles.menu.analysis.root,'label','&Averaging: Radial & Azimuthal','callback','radial_average_window','accelerator','r','enable','on');
%Ancos2
enable = 'on';
grasp_handles.menu.analysis.ancos2 = uimenu(grasp_handles.menu.analysis.root,'label','&Ancos2: Anisotropic Azimuthal Averaging','callback','ancos2_window','accelerator','t','tag','ancos2','enable',enable);
%Sectors
grasp_handles.menu.analysis.sectors = uimenu(grasp_handles.menu.analysis.root,'label','&Sectors & Ellipses','callback','sector_window','accelerator','a','tag','sectors','enable','on');
%Ellipse
%grasp_handles.menu.analysis.ellipse = uimenu(grasp_handles.menu.analysis.root,'label','&Ellipse','callback','ellipse_window','accelerator','e','enable','off');
%Boxes
grasp_handles.menu.analysis.boxes = uimenu(grasp_handles.menu.analysis.root,'label','&Boxes','callback','box_window','accelerator','b','enable','on');
%Sector Boxes
enable = 'on';
grasp_handles.menu.analysis.sector_boxes = uimenu(grasp_handles.menu.analysis.root,'label','&Sector Boxes','callback','sector_box_window','enable',enable);
%Strips
enable = 'on';
grasp_handles.menu.analysis.strips = uimenu(grasp_handles.menu.analysis.root,'label','S&trips','callback','strips_window','accelerator','z','enable',enable);
%X and Y projections
%enable = 'off';
%grasp_handles.menu.analysis.projections = uimenu(grasp_handles.menu.analysis.root,'label','Projections (x y)','callback','projection_window','accelerator','v','enable',enable);
%Reflectivity Toolkit
enable = 'off';
grasp_handles.menu.analysis.reflectivity = uimenu(grasp_handles.menu.analysis.root,'label','Reflectivity Toolkit','callback','reflectivity_window','accelerator','r','enable',enable);

%2D curve fitting 
enable = 'on';
grasp_handles.menu.analysis.fit2d = uimenu(grasp_handles.menu.analysis.root,'label','&2D Curve Fit','callback','curve_fit_window_2d','accelerator','q','enable',enable);
%Background Shifter
enable = 'off';
grasp_handles.menu.analysis.backshift = uimenu(grasp_handles.menu.analysis.root,'label','Background Shifter','callback','background_shifter_window','accelerator','','enable',enable);
%Mask Editor
grasp_handles.menu.analysis.masked = uimenu(grasp_handles.menu.analysis.root,'label','&Mask Editor','callback','mask_edit_window','accelerator','m','enable','on');
%Calibration Options
enable = 'on';
grasp_handles.menu.analysis.calibration = uimenu(grasp_handles.menu.analysis.root,'label','&Calibration Options','callback','calibration_window(1)','accelerator','k','enable',enable);
%Detector efficiency calculator
enable = 'on';
grasp_handles.menu.analysis.deteffcalc = uimenu(grasp_handles.menu.analysis.root,'label','&Detector Efficiency Calculator','callback','detector_efficiency_window','accelerator','w','enable',enable);
%Polarisation & Analysis Tools
enable = 'on';
%PA Root
grasp_handles.menu.analysis.pa_root = uimenu(grasp_handles.menu.analysis.root,'label','Polarisation & Analysis Tools','enable',enable);
%PA Optimise
grasp_handles.menu.analysis.pa_3he_optimise = uimenu(grasp_handles.menu.analysis.pa_root,'label','3He Cell Optimisation','callback','pa_optimise_window','enable',enable);
%PA Efficiencies Calculator
grasp_handles.menu.analysis.pa_efficiencies = uimenu(grasp_handles.menu.analysis.pa_root,'label','PA Efficiencies Calculator','callback','pa_efficiencies_window','enable',enable);






%***** Instrument Menu Items *****
%Menu: Instrument
grasp_handles.menu.instrument.root = uimenu(figure_handle,'label','&Instrument','tag','instrument_menu');
%Instrument setup
grasp_handles.menu.instrument.inst.root = uimenu(grasp_handles.menu.instrument.root,'label','&Instrument','tag','inst_selector');

for n = 1:length(grasp_env.availaible_instruments);
    inst_str = grasp_env.availaible_instruments{n};
    if iscell(inst_str);
        %Make root menu to instrument
        inst_root_str = inst_str{1};
        grasp_handles.menu.instrument.inst.([inst_root_str '_root']) = uimenu(grasp_handles.menu.instrument.inst.root,'label',inst_root_str,'tag','inst_menu');
        %Loop though the inst options
        for m = 2:length(inst_str);
            inst_str2 = inst_str{m};
            disp(['inst_menu_callbacks(change,' inst_root_str ',' inst_str2 ')']);
            grasp_handles.menu.instrument.inst.([inst_str2]) = uimenu(grasp_handles.menu.instrument.inst.([inst_root_str '_root']),'label',inst_str2,'tag','inst_menu','callback',['inst_menu_callbacks(''change'',''' inst_root_str ''',''' inst_str2 ''');'],'checked','off');
        end
    else
        grasp_handles.menu.instrument.inst.([inst_str]) = uimenu(grasp_handles.menu.instrument.inst.root,'label',inst_str,'tag','inst_menu','callback',['inst_menu_callbacks(''change'',''' inst_str ''');'],'checked','off');
    end
end
    
%Q Parameters
grasp_handles.menu.instrument.qsetup.root= uimenu(grasp_handles.menu.instrument.root,'label','&QSetup');
grasp_handles.menu.instrument.qsetup.det = uimenu(grasp_handles.menu.instrument.qsetup.root,'tag','qsetupdet','label','Use DET -> q','callback','menu_callbacks(''qsetup_det'',''det'')');
grasp_handles.menu.instrument.qsetup.detcalc = uimenu(grasp_handles.menu.instrument.qsetup.root,'tag','qsetupdet','label','Use DET+TABLE OFFSET (DETCALC) -> q','callback','menu_callbacks(''qsetup_det'',''detcalc'')');

%uimenu(handle,'label','&Setup','callback','inst_setup_window');
grasp_handles.menu.instrument.paramlist = uimenu(grasp_handles.menu.instrument.root,'label','&Data Parameter List','callback','display_param_list','enable','on');
grasp_handles.menu.instrument.instparams = uimenu(grasp_handles.menu.instrument.root,'label','Instrument &Parameters','callback','display_instrument_params','enable','off');

%SANS instrument model
grasp_handles.menu.instrument.sans_instrument_model = uimenu(grasp_handles.menu.instrument.root,'label','SANS Instrument Model','callback',['inst_menu_callbacks(''sans_instrument_model'');']);


%***** Data Menu Items ******
grasp_handles.menu.data.root = uimenu(figure_handle,'label','&Data','tag','data_menu');
%Windet
enable = 'on';
grasp_handles.menu.data.windet = uimenu(grasp_handles.menu.data.root,'label','&Windet','callback','data_menu_callbacks(''windet'');','accelerator','d','enable',enable);
%Pixel Pick
enable = 'on';
grasp_handles.menu.data.pixpick = uimenu(grasp_handles.menu.data.root,'label','&Pixel Pick','callback','data_menu_callbacks(''pixel_pick'');','accelerator','p','enable',enable);
%Rundex
enable = 'on';
grasp_handles.menu.data.rundex = uimenu(grasp_handles.menu.data.root,'label','&Rundex','callback','rundex_window','enable',enable);
%Extract Parameter
enable = 'on';
grasp_handles.menu.data.extract_parameter = uimenu(grasp_handles.menu.data.root,'label','&Parameter Survey','callback','data_menu_callbacks(''extract_parameter'')','enable',enable);
%Data Map
%enable = 'off';
%grasp_handles.menu.data.datamap = uimenu(grasp_handles.menu.data.root,'label','Data &Map','callback','data_map_window','enable',enable);
%Data Normalization
enable = 'on';
grasp_handles.menu.data.normalization.root = uimenu(grasp_handles.menu.data.root,'label','Data Normalization:','enable',enable);
grasp_handles.menu.data.normalization.none = uimenu(grasp_handles.menu.data.normalization.root,'label','None: Absolute Counts','tag','data_norm','userdata','none','callback','data_menu_callbacks(''normalization'',''none'');');
grasp_handles.menu.data.normalization.stdmon = uimenu(grasp_handles.menu.data.normalization.root,'label','Standard Monitor','tag','data_norm','userdata','mon','callback','data_menu_callbacks(''normalization'',''mon'');');
grasp_handles.menu.data.normalization.stdtime = uimenu(grasp_handles.menu.data.normalization.root,'label','Standard Time','tag','data_norm','userdata','time','callback','data_menu_callbacks(''normalization'',''time'');');
grasp_handles.menu.data.normalization.totaldet = uimenu(grasp_handles.menu.data.normalization.root,'label','Total Detector Counts','tag','data_norm','userdata','det','callback','data_menu_callbacks(''normalization'',''det'');');
grasp_handles.menu.data.normalization.detwin = uimenu(grasp_handles.menu.data.normalization.root,'label','Window Detector Counts','tag','data_norm','userdata','detwin','callback','data_menu_callbacks(''normalization'',''detwin'');');
grasp_handles.menu.data.normalization.param = uimenu(grasp_handles.menu.data.normalization.root,'label','Parameter: #','tag','data_norm','userdata','parameter','callback','data_menu_callbacks(''normalization'',''parameter'');');
grasp_handles.menu.data.normalization.beamwks = uimenu(grasp_handles.menu.data.normalization.root,'label','Empty Beam Worksheet/Monitor','userdata','emptybeam','tag','data_norm','callback','data_menu_callbacks(''normalization'',''emptybeam'');','enable','off');

%Global Dead Time 
enable = 'on';
grasp_handles.menu.data.deadtime.root = uimenu(grasp_handles.menu.data.root,'label','Deadtime Correction','tag','global_deadtime','enable',enable);
grasp_handles.menu.data.deadtime.on = uimenu(grasp_handles.menu.data.deadtime.root,'label','On','tag','global_deadtime_on','checked','off','callback','data_menu_callbacks(''deadtime_toggle'',''on'');');
grasp_handles.menu.data.deadtime.off = uimenu(grasp_handles.menu.data.deadtime.root,'label','Off','tag','global_deadtime_off','checked','off','callback','data_menu_callbacks(''deadtime_toggle'',''off'');');

%Flat Sample, High q Transmission correction
enable = 'on';
grasp_handles.menu.data.transmission.root = uimenu(grasp_handles.menu.data.root,'label','Transmission Thickness Correction [Flat Sample @ High Q]','tag','thickness_transmission','enable',enable);
grasp_handles.menu.data.transmission.on = uimenu(grasp_handles.menu.data.transmission.root,'label','On','tag','thickness_transmission_on','checked','off','callback','data_menu_callbacks(''thickness_transmission_toggle'',''on'');');
grasp_handles.menu.data.transmission.off = uimenu(grasp_handles.menu.data.transmission.root,'label','Off','tag','thickness_transmission_off','checked','off','callback','data_menu_callbacks(''thickness_transmission_toggle'',''off'');');

%Auto Attenuator Correction
enable = 'on';
grasp_handles.menu.data.attenuator.root = uimenu(grasp_handles.menu.data.root,'label','Auto Attenuator Correction','tag','auto_attenuator','enable',enable);
grasp_handles.menu.data.attenuator.on = uimenu(grasp_handles.menu.data.attenuator.root,'label','On','tag','auto_atten_on','checked','off','callback','data_menu_callbacks(''auto_atten_toggle'',''on'');');
grasp_handles.menu.data.attenuator.off = uimenu(grasp_handles.menu.data.attenuator.root,'label','Off','tag','auto_atten_off','checked','off','callback','data_menu_callbacks(''auto_atten_toggle'',''off'');');

%General Count Scaler
enable = 'on';
grasp_handles.menu.data.count_scaler.root = uimenu(grasp_handles.menu.data.root,'label','Count Scaler','enable',enable);
grasp_handles.menu.data.count_scaler.on = uimenu(grasp_handles.menu.data.count_scaler.root,'label','On','checked','off','callback','data_menu_callbacks(''count_scaler_toggle'',''on'');');
grasp_handles.menu.data.count_scaler.off = uimenu(grasp_handles.menu.data.count_scaler.root,'label','Off','checked','off','callback','data_menu_callbacks(''count_scaler_toggle'',''off'');');


%Set Normalization standards
enable = 'on';
grasp_handles.menu.data.normalization.set_root = uimenu(grasp_handles.menu.data.root,'label','Set Normalization Constants & Deadtime','enable',enable);
grasp_handles.menu.data.normalization.set_stdmon = uimenu(grasp_handles.menu.data.normalization.set_root,'label','Set Standard &Monitor','callback','data_menu_callbacks(''set_std_mon'');');
grasp_handles.menu.data.normalization.set_stdtime = uimenu(grasp_handles.menu.data.normalization.set_root,'label','Set Standard &Time','callback','data_menu_callbacks(''set_std_time'');');
grasp_handles.menu.data.normalization.set_detscalar = uimenu(grasp_handles.menu.data.normalization.set_root,'label','Set Standard Detector &Upscaler','callback','data_menu_callbacks(''set_std_detup'');');
grasp_handles.menu.data.normalization.set_detwin = uimenu(grasp_handles.menu.data.normalization.set_root,'label','Set Standard &Detector Window','callback','data_menu_callbacks(''set_std_detwin'');');
grasp_handles.menu.data.normalization.set_param = uimenu(grasp_handles.menu.data.normalization.set_root,'label','Set Normalization Parameter #','callback','data_menu_callbacks(''set_std_param'');');
grasp_handles.menu.data.normalization.set_count_scaler = uimenu(grasp_handles.menu.data.normalization.set_root,'label','Set Count Scaler','callback','data_menu_callbacks(''set_std_count_scaler'');');
grasp_handles.menu.data.normalization.set_tof_dist = uimenu(grasp_handles.menu.data.normalization.set_root,'label','Set D33 TOF Distance (TOTAL)','callback','data_menu_callbacks(''set_d33_tof_dist'');');



%grasp_handles.menu.data.normalization.set_deadtime = uimenu(grasp_handles.menu.data.normalization.set_root,'label','Set &Deadtime','callback','data_menu_callbacks(''set_deadtime'');');

enable = 'on';
grasp_handles.menu.data.data_patch = uimenu(grasp_handles.menu.data.root,'label','&Real-time Parameter Patch','callback','parameter_patch_window','enable',enable);

%Resolution Control
enable = 'on';
grasp_handles.menu.data.resolution_control = uimenu(grasp_handles.menu.data.root,'label','&Resolution Control Centre','callback','resolution_control_window','enable',enable);



%***** Add UserModules to the Menu: COMPILED VERSION - HARD-WIRED IN *****
grasp_handles.menu.user_modules.root = uimenu(figure_handle,'label','&User Modules','tag','user_menu');
uimenu(grasp_handles.menu.user_modules.root,'label','&FLL Window','callback','fll_window','enable','on');
uimenu(grasp_handles.menu.user_modules.root,'label','&FLL Angle Calculator','callback','fll_angle_window','enable','on');
uimenu(grasp_handles.menu.user_modules.root,'label','&FLL Spot Angle Average Calculator','callback','fll_spot_angle_average_window','enable','on');
uimenu(grasp_handles.menu.user_modules.root,'label','&FLL Beam Centre Calculator','callback','fll_beam_centre_window','enable','on');
uimenu(grasp_handles.menu.user_modules.root,'label','&FLL Rapid Beam Centre Calculator','callback','fll_rapid_beam_centre_window','enable','on');
uimenu(grasp_handles.menu.user_modules.root,'label','&FLL Anisotropy Calculator','callback','fll_anisotropy_calculate_window','enable','on');

uimenu(grasp_handles.menu.user_modules.root,'separator','on','label','&TOF Calculator','callback','tof_calculator_window','enable','on');
uimenu(grasp_handles.menu.user_modules.root,'separator','on','label','&D33 Chopper Time-Distance Calculator','callback','d33_chopper_time_distance','enable','on');

uimenu(grasp_handles.menu.user_modules.root,'label','&Launch auto fitting','callback','fitting_tool','enable','on');

%***** About Grasp *****
grasp_handles.menu.about_grasp.root = uimenu(figure_handle,'label','Help');
grasp_handles.menu.about_grasp.about_grasp = uimenu(grasp_handles.menu.about_grasp.root,'label','About GRASP','callback','about_grasp');


