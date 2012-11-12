function [inst_config, inst_component] = ess_model_component;

inst_config = [];
inst_component = [];

%***** Describe D33 Instrument Configuration *****
%All distance are measured from the sample position.
%i.e. +ve distances in detector direction, -ve distance in source direction
%Wavelength Parameters
inst_config.mono_tof = 'Mono';
inst_config.mono_wav = 6; %Angs
inst_config.mono_dwav = 10; % %FWHM resolution
inst_config.wav_color = [0.3, 0.6, 0.7];
inst_config.wav_modes = {'Mono' 'TOF'};
inst_config.tof_wav_min = 2;
inst_config.tof_wav_max = 20;
inst_config.source_size = []; %x,y or diameter.  Calculated later depending on aperture positions
inst_config.col = 6; %Current collimation position
inst_config.tof_resolution_setting = 1;
inst_config.chopper_spacing = []; %current chopper spacing
inst_config.chopper_resolution =[]; %current resolution on rear detector
inst_config.chopper_resolution_front =[]; %current resolution on front detector
inst_config.max_flux = 4.1e7; %n /cm2 /s
inst_config.max_flux_col = 2.8; %collimation when max flux
inst_config.max_flux_wav = 6; %Wavelength when max flux
inst_config.max_flux_source_size = [30e-3,30e-3];
inst_config.guide_m = 1; %m value of guides though the instrument

%Flux scaler calculation based on the same BRIGHTNESS as D22
%i.e. 1e8 [(flux) / [40*55 (guide)/1.4(col)]]  * [30x30(guide) /2.8(col)];




inst_component(1).name = 'Collimation';
inst_component(1).position = 0;
inst_component(1).length = -6; %z
inst_component(1).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(1).drawdim = [0, 50e-3];
inst_component(1).drawcntr = [0, 0];
inst_component(1).color = [1, 0, 0];

inst_component(2).name = 'Aperture';
inst_component(2).position = -6;
inst_component(2).length = 0;
inst_component(2).xydim = {[50e-3], [40e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
inst_component(2).value = 1;
inst_component(2).drawdim = [0, 100e-3];
inst_component(2).drawcntr = [0, 0];
inst_component(2).color = [1, 1, 0];

inst_component(11).name = 'Guide: Casemat Wall';
inst_component(11).position = -6;
inst_component(11).length = -1;
inst_component(11).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(11).drawdim = [0, 30e-3];
inst_component(11).drawcntr = [0, 0];
inst_component(11).color = [1, 0, 0];

inst_component(12).name = 'Attenuator';
inst_component(12).position = -7;
inst_component(12).length = -0.2;
inst_component(12).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(12).drawdim = [0, 30e-3];
inst_component(12).drawcntr = [0, 0];
inst_component(12).color = [0.6, 0.6, 1];

inst_component(13).name = 'Monitor';
inst_component(13).position = -7.2;
inst_component(13).length = -0.1;
inst_component(13).xydim = {[100e-3, 100e-3]}; %x,y
inst_component(13).drawdim = [0, 100e-3];
inst_component(13).drawcntr = [0, 0];
inst_component(13).color = [0.6, 0.6, 0];

inst_component(14).name = 'Chopper: 4';
inst_component(14).position = -7.3;
inst_component(14).length = 0;
inst_component(14).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(14).drawdim = [0, 800e-3];
inst_component(14).drawcntr = [0, -350e-3];
inst_component(14).color = [0, 0.6, 0];
inst_component(14).parameters.tof_lambda_min =2;
inst_component(14).parameters.tof_lambda_max = 20;
inst_component(14).parameters.opening = 110;

inst_component(15).name = 'Guide: Chopper43';
inst_component(15).position = -7.3;
inst_component(15).length = -0.7;
inst_component(15).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(15).drawdim = [0, 30e-3];
inst_component(15).drawcntr = [0, 0];
inst_component(15).color = [1, 0, 0];

inst_component(16).name = 'Chopper: 3';
inst_component(16).position = -8;
inst_component(16).length = 0;
inst_component(16).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(16).drawdim = [0, 800e-3];
inst_component(16).drawcntr = [0, -350e-3];
inst_component(16).color = [0, 0.6, 0];
inst_component(16).parameters.opening = 110;

inst_component(17).name = 'Guide: Chopper32';
inst_component(17).position = -8;
inst_component(17).length = -1.4;
inst_component(17).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(17).drawdim = [0, 30e-3];
inst_component(17).drawcntr = [0, 0];
inst_component(17).color = [1, 0, 0];

inst_component(18).name = 'Chopper: 2';
inst_component(18).position = -9.4;
inst_component(18).length = 0;
inst_component(18).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(18).drawdim = [0, 800e-3];
inst_component(18).drawcntr = [0, -350e-3];
inst_component(18).color = [0, 0.6, 0];
inst_component(18).parameters.opening = 110;

inst_component(19).name = 'Guide: Chopper21';
inst_component(19).position = -9.4;
inst_component(19).length = -2.8;
inst_component(19).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(19).drawdim = [0, 30e-3];
inst_component(19).drawcntr = [0, 0];
inst_component(19).color = [1, 0, 0];

inst_component(20).name = 'Chopper: 1';
inst_component(20).position = -12.2;
inst_component(20).length = 0;
inst_component(20).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(20).drawdim = [0, 800e-3];
inst_component(20).drawcntr = [0, -350e-3];
inst_component(20).color = [0, 0.6, 0];
inst_component(20).parameters.opening = 110;

inst_component(21).name = 'Guide: Selector Copper1';
inst_component(21).position = -12.2;
inst_component(21).length = -0.3;
inst_component(21).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(21).drawdim = [0, 30e-3];
inst_component(21).drawcntr = [0, 0];
inst_component(21).color = [1, 0, 0];

inst_component(22).name = 'Selector:';
inst_component(22).position = -12.5;
inst_component(22).length = -0.4;
inst_component(22).xydim = {[30e-3, 30e-3]}; %x,y
inst_component(22).drawdim = [0, 300e-3];
inst_component(22).drawcntr = [0, -120e-3];
inst_component(22).color = [0.3, 0.6, 0.7];
inst_component(22).parameters.wavelength = 6;
inst_component(22).parameters.delta_wavelength = 10;

inst_component(23).name = 'Guide: Source Guide';
inst_component(23).position = -12.9;
inst_component(23).length = -1;
inst_component(23).xydim = {[45e-3, 35e-3]}; %x,y
inst_component(23).drawdim = [0, 30e-3];
inst_component(23).drawcntr = [0, 0];
inst_component(23).color = [1, 0, 0];

%Describe Secondary Spectrometer from sample forwards
%Tube geometry
inst_config.tube_diameter = 1.4; %m internal diameter
inst_config.tube_length = 7; %m
inst_config.bank_separation = 0.185; %m

%Rear Detector (1)
inst_component(24).name = 'Detector 1: Rear';
inst_component(24).position = 6;
inst_component(24).parameters.position_max = 6;
inst_component(24).parameters.position_min = 6;
inst_component(24).parameters.min_approach = 0.5075; %m
inst_component(24).pannels = 1;
inst_component(24).pannel1.name = 'Rear';
inst_component(24).pannel1.relative_position = 0;
inst_component(24).pannel1.length = 0.1;
inst_component(24).pannel1.xydim = {[0.64, 0.64]}; %x,y
inst_component(24).pannel1.drawdim = [0.64, 0.64];
inst_component(24).pannel1.drawcntr = [0,0];
inst_component(24).pannel1.color = [0 1 0];
inst_component(24).pannel1.parameters.pixels = [320,320]; %x,y
inst_component(24).pannel1.parameters.pixel_size = [2e-3, 2e-3]; %x,y
inst_component(24).pannel1.parameters.centre = [160.5,160.5]; %x,y pixels
inst_component(24).pannel1.parameters.centre_translation = [0 0]; %m
inst_component(24).pannel1.parameters.shaddow_mask = [];
inst_component(24).pannel1.parameters.beam_stop_mask = [];
inst_component(24).pannel1.parameters.opening = [0 0];

%Front Detector - 4 pannels.
inst_component(25).name = 'Detector 2: Front';
inst_component(25).position = 2;
inst_component(25).parameters.position_max = 2;
inst_component(25).parameters.position_min = 2;
inst_component(25).parameters.min_approach = 0.5075; %m
inst_component(25).pannels = 4;
inst_component(25).pannel_group = 1;
%Left
inst_component(25).pannel1.name = 'Left';
inst_component(25).pannel1.relative_position = +inst_config.bank_separation/2;
inst_component(25).pannel1.length = 0.1;
inst_component(25).pannel1.xydim = {[0.16, 0.64]}; %x,y
inst_component(25).pannel1.drawdim = [0.16, 0.64];
inst_component(25).pannel1.drawcntr = [0,0];
inst_component(25).pannel1.color = [0.4 0 1];
inst_component(25).pannel1.parameters.pixels = [80, 320]; %x,y
inst_component(25).pannel1.parameters.pixel_size = [2e-3, 2e-3]; %x,y
inst_component(25).pannel1.parameters.centre = [40.5,160.5]; %x,y pixels This would be the beam centre if the detector was translated into the direct beam by the distance below
inst_component(25).pannel1.parameters.centre_translation = [+0.08 0]; %m
inst_component(25).pannel1.parameters.shaddow_mask = [];
inst_component(25).pannel1.parameters.beam_stop_mask = [];
inst_component(25).pannel1.parameters.opening_min = +0.2; %m
inst_component(25).pannel1.parameters.opening_max = -0.3325; %m
inst_component(25).pannel1.parameters.opening = [-0.32, 0]; %x,y %m %Beam centre line to inner edge of the detector bank
%Right
inst_component(25).pannel2.name = 'Right';
inst_component(25).pannel2.relative_position = +inst_config.bank_separation/2;
inst_component(25).pannel2.length = 0.1;
inst_component(25).pannel2.xydim = {[0.16, 0.64]}; %x,y
inst_component(25).pannel2.drawdim = [0.16, 0.64];
inst_component(25).pannel2.drawcntr = [0,0];
inst_component(25).pannel2.color = [0.2 0 1];
inst_component(25).pannel2.parameters.pixels = [80, 320]; %x,y
inst_component(25).pannel2.parameters.pixel_size = [2e-3, 2e-3]; %x,y
inst_component(25).pannel2.parameters.centre = [40.5,160.5]; %x,y pixels
inst_component(25).pannel2.parameters.centre_translation = [-0.08 0]; %m
inst_component(25).pannel2.parameters.shaddow_mask = [];
inst_component(25).pannel2.parameters.beam_stop_mask = [];
inst_component(25).pannel2.parameters.opening_min = -0.2; %m
inst_component(25).pannel2.parameters.opening_max = +0.3325; %m
inst_component(25).pannel2.parameters.opening = [+0.32, 0]; %x,y %m %Beam centre line to inner edge of the detector bank
%Top
inst_component(25).pannel3.name = 'Top';
inst_component(25).pannel3.relative_position = -inst_config.bank_separation/2;
inst_component(25).pannel3.length = 0.1;
inst_component(25).pannel3.xydim = {[0.64, 0.16]}; %x,y
inst_component(25).pannel3.drawdim = [0.64, 0.16];
inst_component(25).pannel3.drawcntr = [0,0];
inst_component(25).pannel3.color = [0.8 0 1];
inst_component(25).pannel3.parameters.pixels = [320,80]; %x,y
inst_component(25).pannel3.parameters.pixel_size = [2e-3, 2e-3]; %x,y
inst_component(25).pannel3.parameters.centre = [160.5,40.5]; %x,y pixels
inst_component(25).pannel3.parameters.centre_translation = [0 -0.08]; %m
inst_component(25).pannel3.parameters.shaddow_mask = [];
inst_component(25).pannel3.parameters.beam_stop_mask = [];
inst_component(25).pannel3.parameters.opening_min = -0.2; %m
inst_component(25).pannel3.parameters.opening_max = 0.3325; %m
inst_component(25).pannel3.parameters.opening = [0, 0.32]; %x,y %m %Beam centre line to inner edge of the detector bank
%Bottom
inst_component(25).pannel4.name = 'Bottom';
inst_component(25).pannel4.relative_position = -inst_config.bank_separation/2;
inst_component(25).pannel4.length = 0.1;
inst_component(25).pannel4.xydim = {[0.64, 0.16]}; %x,y
inst_component(25).pannel4.drawdim = [0.64, 0.16];
inst_component(25).pannel4.drawcntr = [0,0];
inst_component(25).pannel4.color = [0.6 0 1];
inst_component(25).pannel4.parameters.pixels = [320,80]; %x,y
inst_component(25).pannel4.parameters.pixel_size = [2e-3, 2e-3]; %x,y
inst_component(25).pannel4.parameters.centre = [160.5,40.5]; %x,y pixels
inst_component(25).pannel4.parameters.centre_translation = [0 +0.08]; %m
inst_component(25).pannel4.parameters.shaddow_mask = [];
inst_component(25).pannel4.parameters.beam_stop_mask = [];
inst_component(25).pannel4.parameters.opening_min = +0.2; %m
inst_component(25).pannel4.parameters.opening_max = -0.3325; %m
inst_component(25).pannel4.parameters.opening = [0, -0.32]; %x,y %m %Beam centre line to inner edge of the detector bank



