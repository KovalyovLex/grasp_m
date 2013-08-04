function initialise_grasp_handles

%Initialises the Grasp handles structure.  Most of these are just added
%on the fly as needed.  Others, that are required straight away, even if
%just empty can be declared and initialised here

global grasp_handles
global inst_params

for det = 1:inst_params.detectors
    grasp_handles.displayimage.(['image' num2str(det)]) = [];
end
grasp_handles.displayimage.colorbar =[];
grasp_handles.displayimage.axis = [];


grasp_handles.window_modules.rebin.window = [];

grasp_handles.window_modules.resolution_control_window.window = [];

grasp_handles.window_modules.contour_options.window = [];
grasp_handles.window_modules.color_sliders.window = [];
grasp_handles.window_modules.mask_edit.window = [];
grasp_handles.window_modules.detector_efficiency.window = [];
grasp_handles.window_modules.rundex.window = [];
grasp_handles.window_modules.radial_average.window = [];
grasp_handles.window_modules.sector.window = [];
grasp_handles.window_modules.sector.sketch_handles = [];
grasp_handles.window_modules.strips.window = [];
grasp_handles.window_modules.strips.sketch_handles = [];
grasp_handles.window_modules.box.window = [];
grasp_handles.window_modules.box.sketch_handles = [];
grasp_handles.window_modules.reflectivity.window = [];
grasp_handles.window_modules.sector_box.window = [];
grasp_handles.window_modules.sector_box.sketch_handles = [];
grasp_handles.window_modules.calibration.window = [];
grasp_handles.window_modules.param_list = [];
grasp_handles.window_modules.about_grasp = [];
grasp_handles.window_modules.ancos2.window = [];
grasp_handles.window_modules.pa_tools.optimise_window = [];
grasp_handles.window_modules.pa_tools.efficiencies_window = [];
grasp_handles.window_modules.parameter_patch_window = [];


grasp_handles.window_modules.calibration.beam.wks = [];
grasp_handles.window_modules.calibration.beam.nmbr = [];
grasp_handles.window_modules.calibration.beam.dpth = [];
grasp_handles.window_modules.calibration.det_eff_nmbr = [];
grasp_handles.window_modules.calibration.water.cal_scalar_value = [];
grasp_handles.window_modules.calibration.water.cal_scalar_units = [];
grasp_handles.window_modules.calibration.water.cal_xsection = [];


grasp_handles.window_modules.curve_fit1d.window = [];
grasp_handles.window_modules.curve_fit2d.window = [];
grasp_handles.window_modules.curve_fit1d.res_window = [];

%Grasp Changer
grasp_handles.grasp_changer.window = [];

%User Modules
grasp_handles.user_modules.rheo_anisotropy.window = [];
grasp_handles.user_modules.rheo_anisotropy.sketch_handles = [];

