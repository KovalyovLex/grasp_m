function grasp
%inst_in declares the default instrument

%Declare functions that are only used by callbacks - Required for Runtime

%***** Root Directory *****
%#function ploterr
%#function initialise_status_flags
%#function initialise_grasp_handles
%#function initialise_environment_params
%#function grasp_startup
%#function grasp_ini
%#function grasp

%***** /Callbacks *****
%#function calibration_callbacks
%#function calibration_window
%#function data_menu_callbacks
%#function data_read
%#function file_menu
%#function file_menu_image_export
%#function inst_menu_callbacks
%#function main_callbacks
%#function menu_callbacks
%#function tool_callbacks

%***** /colormaps *****
%#function army1
%#function army2
%#function aubergine
%#function barbie
%#function bathtime
%#function blueberry
%#function blues
%#function blush
%#function damson
%#function grass
%#function harrier
%#function pond
%#function wolves

%***** /data *****
%#function add_worksheet
%#function clear_wks_nmbr
%#function clear_wks_nmbr_dpth
%#function d22_paralax_correction
%#function d33_model_data_read
%#function data_index
%#function direct_beam_calibration
%#function water_calibration
%#function divide_detector_efficiency
%#function get_mask
%#function ill_sans_1ddata_write
%#function initialise_data_arrays
%#function insert_data_depth
%#function numor_decompress
%#function numor_parse
%#function place_data
%#function raw_read_ansto_sans
%#function raw_read_d22d11_old
%#function raw_read_ill_sans
%#function raw_read_ill_nexus
%#function raw_read_ill_nexus_d33
%#function raw_read_jaea_highres
%#function raw_read_jaea_sansu
%#function raw_read_nist_sans
%#function raw_read_ornl_sans
%#function raw_read_sinq_sans1
%#function raw_read_frm2_mira
%#function raw_read_hzb_v4
%#function raw_save
%#function retrieve_data
%#function update_last_saved_project
%#function withdraw_data_depth

%**** /sans_instrument *****
%#function d33_rawdata_calibration

%**** /display ****
%#function about_grasp
%#function circle
%#function collect_points
%#function current_axis_limits
%#function display_param_list
%#function display_param_list_callbacks
%#function display_params
%#function figure_position
%#function grasp_gui
%#function grasp_movie
%#function grasp_update
%#function hide_gui
%#function hide_stuff
%#function initialise_2d_plots
%#function live_coords
%#function grasp_message
%#function modify_main_menu_items
%#function modify_main_tool_items
%#function output_figure
%#function screen_scaling
%#function selector_build
%#function selector_build_values
%#function set_colormap
%#function update_beam_centre
%#function update_data_summary
%#function update_display_options
%#function update_menus
%#function update_selectors
%#function update_transmissions
%#function update_window_options

%**** /grasp_changer ****
%#function grasp_changer_gui
%#function grasp_changer_gui_callbacks
%#function update_grasp_changer

%***** /grasp_plot *****
%#function grasp_plot
%#function grasp_plot_callbacks
%#function grasp_plot_fit_callbacks
%#function grasp_plot_fit_window
%#function grasp_plot_image_export
%#function grasp_plot_menu_callbacks
%#function modify_grasp_plot_menu
%#function modify_grasp_plot_toolbar
%#function pseudo_fn

%***** /grasp_script *****
%#function fit2d
%#function fit2d_spots
%#function fit1d

%***** /instrument *****
%#function initialise_instrument_params

%***** /math ***** 
%#function err_acos
%#function err_add
%#function err_asin
%#function err_cos
%#function err_divide
%#function err_ln
%#function err_multiply
%#function err_power
%#function err_sin
%#function err_sub
%#function err_tan
%#function err_sum
%#function gauss_kernel
%#function mf_dfdp_grasp
%#function mf_lsqr_grasp
%#function rand_gauss


%***** /sans_instrument_model *****
%#function ansto_quokka_model_component
%#function d11_model_component
%#function d22_model_component
%#function d33_ill_sans_data_write
%#function d33_model_component
%#function d33_model_data_write
%#function d33_parameters
%#function d33_rebin
%#function ff_cadmium
%#function ff_cryostat_ox7t
%#function ff_empty_cell
%#function ff_guinier
%#function ff_porod
%#function ff_mag_porod
%#function ff_ribosome
%#function ff_sphere
%#function ff_vortex
%#function ff_vortex_rock
%#function ff_water
%#function ff_water_cell
%#function isalmost
%#function isodd
%#function nist_ng3_model_component
%#function nist_ng7_model_component
%#function ornl_cg2_model_component
%#function ornl_cg3_model_component
%#function sans_instrument_model
%#function sans_instrument_model_build_q_matrix
%#function sans_instrument_model_callbacks
%#function sans_instrument_model_flux_col_wav
%#function sans_instrument_model_flux_col_wav
%#function sinq_sans1_model_component
%#function sinq_sans2_model_component

%***** /sans_math *****
%#function average_error
%#function build_q_matrix
%#function centre_of_mass
%#function current_beam_centre
%#function current_transmission
%#function get_selector_result
%#function normalize_data
%#function rebin
%#function standard_data_correction
%#function divide_data_correction
%#function transmission_thickness_correction

%***** /user_modules/fll_math *****
%#function fll_angle_between_spots
%#function fll_angle_callbacks
%#functionn fll_angle_window
%#function fll_anisotropy_calculate_window
%#function fll_anisotropy_callbacks
%#function fll_beam_centre_callbacks
%#function fll_beam_centre_window
%#function fll_callbacks
%#function fll_rapid_beam_centre_callbacks
%#function fll_rapid_beam_centre_window
%#function fll_spot_angle_average_callbacks
%#function fll_spot_angle_average_window
%#function fll_window
%***** Other User Modules *****
%#function tof_calculator_window
%#function tof_calculator_callbacks
%***** D33 User Modules *****
%#function d33_chopper_settings
%#function d33_chopper_time_distance
%#function d33_chopper_time_distance_callbacks

%***** /window_modules *****
%#function ancos2_callbacks
%#function ancos2_pseudo_fn
%#function ancos2_window
%#function box_callbacks
%#function box_window
%#function contour_options_callbacks
%#function contour_options_window
%#function color_sliders
%#function color_sliders_callbacks
%#function curve_fit_2d_callbacks
%#function curve_fit_window_2d
%#function detector_efficiency_callbacks
%#function detector_efficiency_window
%#function mask_edit_callbacks
%#function mask_edit_window
%#function pseudo_fn2d
%#function radial_average_callbacks
%#function radial_average_window
%#function rundex_callbacks
%#function rundex_window
%#function sector_box_callbacks
%#function sector_box_window
%#function sector_callbacks
%#function sector_window
%#function strips_callbacks
%#function strips_window
%#function pa_optimise_window
%#function pa_efficiencies_window
%#function pa_combined_efficiency
%#function pa_correct
%#function parameter_patch_window
%#function parameter_patch_callbacks
%#function resolution_control_window
%#function resolution_control_callbacks
%#function rebin_window
%#function rebin_callbacks




global grasp_env
global grasp_handles

%***** Grasp Version Number ******
grasp_env.grasp_version = '6.60';
grasp_env.grasp_version_date = '11th October 2012';
grasp_env.grasp_name = 'GRASP';


%***** Check to see if window is already open *****
h=findobj('Tag','grasp_main');
if not(isempty(h));
    disp('GRASP is already running');
    figure(h);
else
    
    initialise_environment_params
    grasp_ini     %Load any user_configurable data from grasp.ini
    initialise_instrument_params
    initialise_status_flags
    grasp_ini     %Load any user_configurable data from grasp.ini

    %Instrument startup define by command line if supplied
    if nargin == 1; grasp_env.inst = inst_in; end;

    
    %Build Grasp GUI
    grasp_gui

    %Initialise Grasp Handles
    initialise_grasp_handles
    
    %Initialise Data Arrays
    initialise_data_arrays

    %Build selector menus
    selector_build;
    selector_build_values('all');
    
    %Initialise 2D plots
    initialise_2d_plots

    %Grasp main update loop
    grasp_update

    %Make a first store of the 'last_saved' project
    update_last_saved_project
end

if isdeployed
    about_grasp
    pause(2)
    if ishandle(grasp_handles.window_modules.about_grasp) %Check it is still there.
        close(grasp_handles.window_modules.about_grasp);
        grasp_handles.window_modules.about_grasp=[];
    end
end
% change default instrument to d22
inst_menu_callbacks('change','ILL_d22','d22');

