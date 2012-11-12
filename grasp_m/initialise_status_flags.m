function initialise_status_flags(to_do)

if nargin < 1; to_do = ' '; end

%Sets up the general Grasp status parameters, e.g. position of selectors, color map etc.
%stored in 'status_flags'.  %Some of these parameters may be over written by subsequent grasp.ini
%or project load

global status_flags
global inst_params

%Rebin (complex) Parameters
status_flags.analysis_modules.rebin.bin_spacing = 'linear';
status_flags.analysis_modules.rebin.n_bins = 500;
status_flags.analysis_modules.rebin.regroup_bands = [0,1];
status_flags.analysis_modules.rebin.dii_power = 2;
status_flags.analysis_modules.rebin.dqq_power = 2;

%Resolution Control
status_flags.resolution_control.wavelength_check = 1;
status_flags.resolution_control.wavelength_type = 1; %1 = Triangular, 2 = Top-Hat (e.g. D33 TOF)
status_flags.resolution_control.divergence_check = 1;
status_flags.resolution_control.divergence_type = 1; %1 = Geometric, 2 = Measured Beam Shape
status_flags.resolution_control.aperture_check = 1;
status_flags.resolution_control.aperture_size = [10e-3]; %m (10mm) Single figure denotes circular
status_flags.resolution_control.pixelation_check = 1;
status_flags.resolution_control.binning_check = 1;
status_flags.resolution_control.show_kernels_check = 0;
status_flags.resolution_control.convolution_type = 1;
status_flags.resolution_control.fwhmwidth = 1; %extent to which convolution kernel goes out.
status_flags.resolution_control.finesse = 31;  %finesse (number of points) over the concolution kernel - should be ODD number


%Polarisation & Analysis Optimisation Utility
status_flags.pa_optimise.pa_3he_pol = 0.75; % [%] polarisation
status_flags.pa_optimise.pa_3he_opacity_max = 100; %Opacity [bar cm angs]
status_flags.pa_optimise.pa_3he_pressure = 0.2; %Pressure [bar]
status_flags.pa_optimise.pa_3he_pathlength = 15; %Path Length [cm]
status_flags.pa_optimise.pa_3he_wavelength = 6; %Wavelength [angs]
status_flags.pa_optimise.pa_3he_optimum = 0; %Opacity [bar cm angs]
status_flags.pa_optimise.pa_3he_t1 = 200; %Decay time, t1 [hrs]
status_flags.pa_optimise.pa_3he_time_max = 1000; %Plot time max
status_flags.pa_optimise.pa_3he_time_max = 1000; %Plot time max

status_flags.pa_optimise.pa_efficiency_wks = 1; %Worksheet number for FR check
status_flags.pa_optimise.pa_efficiency_nmbr = 1; %Worksheet depth for FR check

status_flags.pa_optimise.fp_av = [1 0];
status_flags.pa_optimise.fa_av = [1 0];
status_flags.pa_optimise.efficiencies.absolute_time = 0;

%Polarisation & Analysis Efficiencies [value, err_value]
status_flags.pa_optimise.parameters.p = [1 0];
status_flags.pa_optimise.parameters.fp = [1 0];
status_flags.pa_optimise.parameters.fa = [1 0];
status_flags.pa_optimise.parameters.opacity = [30 0];
status_flags.pa_optimise.parameters.p0 = [0.75 0];
status_flags.pa_optimise.parameters.t1 = [200 0];
status_flags.pa_optimise.parameters.t0 = [3 0];
status_flags.pa_optimise.phi_time_max = 120; %5 days

status_flags.calibration.pa_chk = 0; 







%Parameter Patcher
status_flags.data.number_patches = 5;
for n = 1:status_flags.data.number_patches
    status_flags.data.(['patch_parameter' num2str(n)]) = [];
    status_flags.data.(['patch' num2str(n)]) = [];
    status_flags.data.(['rep_mod' num2str(n)]) = 0;
end
status_flags.data.patch_check = 0;





%Worksheet selector positions
status_flags.selector.fw = 1;
status_flags.selector.fn = 1;
status_flags.selector.fd = 1;
status_flags.selector.bw = 2;
status_flags.selector.bn = 1;
status_flags.selector.bd = 1;
status_flags.selector.b_check = 0;
status_flags.selector.cw = 3;
status_flags.selector.cn = 1;
status_flags.selector.cd = 1;
status_flags.selector.c_check = 0;
status_flags.selector.ngroup = 1;
status_flags.selector.dgroup = 1;
status_flags.selector.fdpth_max = 0;
status_flags.selector.bdpth_max = 1;
status_flags.selector.cdpth_max = 1;

%Transmissions
status_flags.transmission.ts_number = 1;
status_flags.transmission.ts_depth = 1;
status_flags.transmission.ts_lock = 0;
status_flags.transmission.te_number = 1;
status_flags.transmission.te_depth = 1;
status_flags.transmission.te_lock = 0;

%Beam centre
status_flags.beamcentre.cm_number = 1;
status_flags.beamcentre.cm_depth = 1;
status_flags.beamcentre.cm_lock = 0;

%Current axes
status_flags.axes.current = 'p';
status_flags.axes.xlim = [];
status_flags.axes.ylim = [];



switch to_do
    case 'reset_essential'
        %Quit after partial re-initialisation of some status_flags after project close
        return
end


status_flags.transmission.thickness_correction = 'on';


%Data Normalization parameters
status_flags.normalization.standard_monitor = 10000000; %standard monitor (counts)
status_flags.normalization.standard_time = 1; %standard time (seconds)
status_flags.normalization.standard_detector = 1; %Standard detector counts norm upscaler
status_flags.normalization.status = 'mon';
status_flags.normalization.detwin = [1,1,1,1]; %x1, x2, y1, y2
status_flags.normalization.auto_atten = 'on'; %auto attenuator correction
status_flags.normalization.count_scaler = 'off'; %Count up/down scaler
status_flags.normalization.standard_count_scaler = 1;
status_flags.normalization.param = 126;
status_flags.deadtime.status = 'on'; %auto deadtime correction

status_flags.nomalization.d33_total_tof_dist = 19.9;


%Parameter Survey
status_flags.parameter_survey.parameter = 65;

%Calculation options
status_flags.q.det = 'detcalc'; 

%Save settings
status_flags.file.save_sub_figures = 1; %Default is to save subfigures

%Data file extensions
status_flags.fname_extension.shortname=inst_params.filename.lead_string;
status_flags.fname_extension.extension=inst_params.filename.extension_string;

%Raw tube data load
status_flags.fname_extension.raw_tube_data_load = 0;  %Load raw data, not calibrated data on D33

%Calibration settings
status_flags.calibration.method = 'none'; %options are 'water' or 'beam'
status_flags.calibration.calibrate_check = 0;
status_flags.calibration.solid_angle_check = 1;
status_flags.calibration.flux_col_check = 1;
status_flags.calibration.det_eff_check = 1;
status_flags.calibration.det_eff_nmbr = 1;
status_flags.calibration.scalar_check = 1;
status_flags.calibration.xsection_check = 1;
status_flags.calibration.volume_normalize_check = 1;
status_flags.calibration.solid_angle_check = 1;
status_flags.calibration.beam_flux_check = 1;
status_flags.calibration.beam_worksheet = 6;
status_flags.calibration.beam_number = 1;
status_flags.calibration.beam_depth = 1;
status_flags.calibration.sample_area = 1;
%status_flags.calibration.sample_thickness = 0.1;
status_flags.calibration.standard_area = 1;
status_flags.calibration.standard_thickness = 0.1;
status_flags.calibration.soft_det_cal = 0; %soft tube calibration flag on/off (D22, D33)
status_flags.calibration.d22_tube_angle_check = 1; %Angular dependent D22 tube efficiency correction

%Color control
status_flags.color.swap = 0;
status_flags.color.top = 1;
status_flags.color.bottom = 0;
status_flags.color.gamma = 0.33;
status_flags.color.map = 'jet';
status_flags.color.invert = 0;
status_flags.color.swap = 0;

%Display control
status_flags.display.grouped_z_scale  = 1; %If multiple detectors 1 = all same z_scale, 0 = independent z_scales
status_flags.display.render = 'interp';
status_flags.display.image = 1;
status_flags.display.contour = 0;
status_flags.display.log = 0;
status_flags.display.zscale = 'Log Z';
status_flags.display.manualz.check = 0;
status_flags.display.manualz.min = 0;
status_flags.display.manualz.max = 100;
%status_flags.display.manualz.enterflag = 0;
status_flags.display.mask.check = 1;
status_flags.display.mask.number = 1;
status_flags.display.imask.check = 1;
status_flags.display.rotate.check = 0;
status_flags.display.rotate.angle = 0;
status_flags.display.flipud = 0;
status_flags.display.fliplr = 0;
status_flags.display.title = 1;
status_flags.display.colorbar = 1;
status_flags.display.axes = 1;
status_flags.display.linestyle = ':';
status_flags.display.linewidth = 1;
status_flags.display.markersize = 3;
status_flags.display.invert_hardcopy = 1;
status_flags.display.axis_box = 1;
status_flags.display.smooth.check = 0;
status_flags.display.smooth.kernel = 'Box 3x3';
status_flags.display.smooth.kerneldata = ones(3,3)./(3.*3);
status_flags.display.refresh = 1; %1 = on, 0 = off
status_flags.display.active_axis = 1;
status_flags.display.axis1_onoff = 1;
status_flags.display.axis2_onoff = 1;
status_flags.display.axis3_onoff = 1;
status_flags.display.axis4_onoff = 1;
status_flags.display.axis5_onoff = 1;
status_flags.display.axis6_onoff = 1;
status_flags.display.axis7_onoff = 1;
status_flags.display.axis8_onoff = 1;
status_flags.display.axis9_onoff = 1;
status_flags.display.axis10_onoff = 1;


%Command window events
status_flags.command_window.display_params = 1;

%Contour properties
status_flags.contour.color = 'k'; %black linespec
status_flags.contour.current_style = 1;
status_flags.contour.auto_levels = [2,5,8,10,15,20,35,50,75,100];
status_flags.contour.auto_levels_index = 3;
status_flags.contour.contour_max = 100;
status_flags.contour.contour_min = 0;
status_flags.contour.contour_interval = 10;
status_flags.contour.percent_abs = 2;
status_flags.contour.contours_string = '';
status_flags.contour.current_levels_list = [];




%Curve fitter parameters
status_flags.fitter.fn2d = 1; %This stores the last fit function that was used between successive opening and closing of the fit window.
status_flags.fitter.fn1d = 1;
status_flags.fitter.number2d = 1; %Number of simultaneous functions
status_flags.fitter.number1d = 1;
status_flags.fitter.curve_number1d = 1; %Curve number to fit
status_flags.fitter.include_res_check = 0;  %Include divergence resolution in 1D fitting
status_flags.fitter.delete_curves_check = 0;
status_flags.fitter.res1d_option = 'on'; %Show include resolution buttons
status_flags.fitter.flag = 1;  %This is a flag to turn on and off the resolution convolution used during the high res convolution
status_flags.fitter.simultaneous_check = 0; %Whether to fit all displayed curves simultaneously with the same function

%Grasp Plot Resolution Control
status_flags.resolution_fit.all_check = 1;


%Subfigure options
status_flags.subfigure.show_resolution = 'off';
status_flags.subfigure.export.column_labels = 'on';
status_flags.subfigure.export.data_history = 'on';
status_flags.subfigure.export.include_resolution = 'on';
status_flags.subfigure.export.resolution_format = 'sigma';  %fwhm, hwhm or sigma'
status_flags.subfigure.export.format = 'ascii'; %ascii, illg
status_flags.subfigure.export.auto_filename = 'on';


%Radial Average Window
status_flags.analysis_modules.radial_average.q_bin_pixels = 1;
status_flags.analysis_modules.radial_average.q_bin_absolute = 0.001;
status_flags.analysis_modules.radial_average.q_bin_resolution = 2;
status_flags.analysis_modules.radial_average.q_bin_absolute_scale = 'linear';
status_flags.analysis_modules.radial_average.q_bin_units = 'pixels';

status_flags.analysis_modules.radial_average.theta_bin_pixels = 1;
status_flags.analysis_modules.radial_average.theta_bin_absolute = 0.01;
status_flags.analysis_modules.radial_average.theta_bin_resolution = 2;
status_flags.analysis_modules.radial_average.theta_bin_absolute_scale = 'linear';
status_flags.analysis_modules.radial_average.theta_bin_units = 'pixels';

status_flags.analysis_modules.radial_average.azimuth_bin_absolute = 1;
status_flags.analysis_modules.radial_average.azimuth_bin_units = 'absolute';

status_flags.analysis_modules.radial_average.sector_mask_chk = 0;
status_flags.analysis_modules.radial_average.strip_mask_chk = 0;

status_flags.analysis_modules.radial_average.single_depth_radio = 0; %0 = single, 1= depth

status_flags.analysis_modules.radial_average.depth_frame_start = 1;
status_flags.analysis_modules.radial_average.depth_frame_end = 1;

status_flags.analysis_modules.radial_average.direct_to_file = 0;
status_flags.analysis_modules.radial_average.d33_tof_combine = 0;

%Sectors Window
status_flags.analysis_modules.sectors.inner_radius = 10;
status_flags.analysis_modules.sectors.outer_radius = 20;
status_flags.analysis_modules.sectors.theta = 0;
status_flags.analysis_modules.sectors.delta_theta = 20;
status_flags.analysis_modules.sectors.mirror_sectors = 1;
status_flags.analysis_modules.sectors.mirror_sectors_max = 12;
status_flags.analysis_modules.sectors.sector_color = 'white';
status_flags.analysis_modules.sectors.anisotropy = 1;
status_flags.analysis_modules.sectors.anisotropy_angle = 0;


%Strips
status_flags.analysis_modules.strips.strip_cx = [64];
status_flags.analysis_modules.strips.strip_cy = [64];
status_flags.analysis_modules.strips.theta = 0;
status_flags.analysis_modules.strips.length = [30];
status_flags.analysis_modules.strips.width = [10];
status_flags.analysis_modules.strips.strips_color = 'white';

%Boxes
status_flags.analysis_modules.boxes.parameter = 65;
status_flags.analysis_modules.boxes.sum_box_chk = 0;
status_flags.analysis_modules.boxes.box_nrm_chk = 0;
status_flags.analysis_modules.boxes.box_color = 'red';
status_flags.analysis_modules.boxes.scan_boxes_check = [0,0,0,0,0,0];
status_flags.analysis_modules.boxes.scan_boxes_angle0 = [0,0,0,0,0,0];

status_flags.analysis_modules.boxes.coords1 = [1,1,1,1,1]; %The 5th coordinate is the detector number
status_flags.analysis_modules.boxes.coords2 = [1,1,1,1,1];
status_flags.analysis_modules.boxes.coords3 = [1,1,1,1,1];
status_flags.analysis_modules.boxes.coords4 = [1,1,1,1,1];
status_flags.analysis_modules.boxes.coords5 = [1,1,1,1,1];
status_flags.analysis_modules.boxes.coords6 = [1,1,1,1,1];

%Reflectivity Toolkit
status_flags.analysis_modules.reflectivity.ymin = 60;
status_flags.analysis_modules.reflectivity.ymax = 70;


%Sector Boxes
status_flags.analysis_modules.sector_boxes.parameter = 65;
status_flags.analysis_modules.sector_boxes.sum_box_chk = 0;
status_flags.analysis_modules.sector_boxes.box_nrm_chk = 0;
status_flags.analysis_modules.sector_boxes.box_color = 'red';

status_flags.analysis_modules.sector_boxes.coords1 = [1,1,1,1,1,0,1]; %R1, R2, Thta, DThta, g, gThta,  Detector number (7th)
status_flags.analysis_modules.sector_boxes.coords2 = [1,1,1,1,1,0,1];
status_flags.analysis_modules.sector_boxes.coords3 = [1,1,1,1,1,0,1];
status_flags.analysis_modules.sector_boxes.coords4 = [1,1,1,1,1,0,1];
status_flags.analysis_modules.sector_boxes.coords5 = [1,1,1,1,1,0,1];
status_flags.analysis_modules.sector_boxes.coords6 = [1,1,1,1,1,0,1];


%Ancos2
status_flags.analysis_modules.ancos2.start_radius = 6;
status_flags.analysis_modules.ancos2.end_radius = 30;
status_flags.analysis_modules.ancos2.radius_width = 1;
status_flags.analysis_modules.ancos2.radius_step = 1;
status_flags.analysis_modules.ancos2.phase_lock = 0;
status_flags.analysis_modules.ancos2.phase_angle = 0;
status_flags.analysis_modules.ancos2.color = 'white';

%Detector Efficiency Calculator
status_flags.analysis_modules.det_eff.split_line = 45;
status_flags.analysis_modules.det_eff.split_method = 1; %first on the dropdown list;

%Reduction Angorithm
status_flags.algorithm = 'standard';


%Grasp Changer
status_flags.grasp_changer.number_configs = 3;
status_flags.grasp_changer.number_samples = 10;
status_flags.grasp_changer.designation = {'sample'};
status_flags.grasp_changer.transmission_config = 1;
status_flags.grasp_changer.transmission_window1 = [];
status_flags.grasp_changer.transmission_window2= [];
status_flags.grasp_changer.transmission_window3 = [];
status_flags.grasp_changer.calibrate_check = 1;
status_flags.grasp_changer.auto_mask_check = 1;

