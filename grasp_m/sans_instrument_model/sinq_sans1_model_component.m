function [inst_config, inst_component] = sinq_sans1_model_component

inst_config = [];
inst_component = [];

%***** Describe D22 Instrument Configuration *****
%All distance are measured from the sample position.
%i.e. +ve distances in detector direction, -ve distance in source direction
%Wavelength Parameters
inst_config.mono_tof = 'Mono';
inst_config.mono_wav = 6; %Angs
inst_config.mono_dwav = 10; % %FWHM resolution
inst_config.wav_color = [0.3, 0.6, 0.7];
inst_config.wav_modes = {'Mono'};
inst_config.source_size = []; %x,y or diameter.  Calculated later depending on aperture positions
inst_config.col = 6; %Current collimation position
inst_config.max_flux = 1e7; %n /cm2 /s
inst_config.max_flux_col = 2; %collimation when max flux
inst_config.max_flux_wav = 6; %Wavelength when max flux
inst_config.max_flux_source_size = [48e-3,48e-3];
inst_config.guide_m = 1; %m value of guides though the instrument

%Note:  Sinq_SANS1 guide size is 50x50mm  BUT, each collimator section has
%a 48x48mm square aperture at the beginning
inst_component(1).name = 'Collimation';
inst_component(1).position = 0;
inst_component(1).length = -2; %z
inst_component(1).xydim = {[48e-3, 48e-3]}; %x,y
inst_component(1).drawdim = [0, 48e-3];
inst_component(1).drawcntr = [0, 0];
inst_component(1).color = [1, 0, 0];

inst_component(2).name = 'Collimation';
inst_component(2).position = -2;
inst_component(2).length = -1;
inst_component(2).xydim = {[48e-3, 48e-3]}; %x,y
inst_component(2).drawdim = [0, 48e-3];
inst_component(2).drawcntr = [0, 0];
inst_component(2).color = [1, 0, 0];

inst_component(3).name = 'Collimation';
inst_component(3).position = -3;
inst_component(3).length = -1.5;
inst_component(3).xydim = {[48e-3, 48e-3]}; %x,y
inst_component(3).drawdim = [0, 48e-3];
inst_component(3).drawcntr = [0, 0];
inst_component(3).color = [1, 0, 0];

inst_component(4).name = 'Collimation';
inst_component(4).position = -4.5;
inst_component(4).length = -1.5;
inst_component(4).xydim = {[48e-3, 48e-3]}; %x,y
inst_component(4).drawdim = [0, 48e-3];
inst_component(4).drawcntr = [0, 0];
inst_component(4).color = [1, 0, 0];

inst_component(5).name = 'Collimation';
inst_component(5).position = -6;
inst_component(5).length = -2;
inst_component(5).xydim = {[48e-3, 48e-3]}; %x,y
inst_component(5).drawdim = [0, 48e-3];
inst_component(5).drawcntr = [0, 0];
inst_component(5).color = [1, 0, 0];

inst_component(6).name = 'Collimation';
inst_component(6).position = -8;
inst_component(6).length = -3;
inst_component(6).xydim = {[48e-3, 48e-3]}; %x,y
inst_component(6).drawdim = [0, 48e-3];
inst_component(6).drawcntr = [0, 0];
inst_component(6).color = [1, 0, 0];

inst_component(7).name = 'Collimation';
inst_component(7).position = -11;
inst_component(7).length = -4;
inst_component(7).xydim = {[48e-3, 48e-3]}; %x,y
inst_component(7).drawdim = [0, 48e-3];
inst_component(7).drawcntr = [0, 0];
inst_component(7).color = [1, 0, 0];

inst_component(8).name = 'Collimation';
inst_component(8).position = -15;
inst_component(8).length = -3;
inst_component(8).xydim = {[48e-3, 48e-3]}; %x,y
inst_component(8).drawdim = [0, 48e-3];
inst_component(8).drawcntr = [0, 0];
inst_component(8).color = [1, 0, 0];

inst_component(9).name = 'Attenuator';
inst_component(9).position = -18;
inst_component(9).length = -0.1;
inst_component(9).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(9).drawdim = [0, 55e-3];
inst_component(9).drawcntr = [0, 0];
inst_component(9).color = [0.6, 0.6, 1];

inst_component(10).name = 'Aperture';
inst_component(10).position = -18;
inst_component(10).length = -0.1;
inst_component(10).xydim = {[20e-3], [30e-3], [20e-3,40e-3]};
inst_component(10).value = 1;
inst_component(10).drawdim = [0, 100e-3];
inst_component(10).drawcntr = [0, 0];
inst_component(10).color = [1, 1, 0];

inst_component(11).name = 'Monitor';
inst_component(11).position = -18.1;
inst_component(11).length = -0.1;
inst_component(11).xydim = {[100e-3, 100e-3]}; %x,y
inst_component(11).drawdim = [0, 100e-3];
inst_component(11).drawcntr = [0, 0];
inst_component(11).color = [0.6, 0.6, 0];

inst_component(12).name = 'Guide: to Selector';
inst_component(12).position = -18.2;
inst_component(12).length = -3;
inst_component(12).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(12).drawdim = [0, 50e-3];
inst_component(12).drawcntr = [0, 0];
inst_component(12).color = [1, 0, 0];

inst_component(13).name = 'Selector:';
inst_component(13).position = -21.2;
inst_component(13).length = -0.4;
inst_component(13).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(13).drawdim = [0, 300e-3];
inst_component(13).drawcntr = [0, -120e-3];
inst_component(13).color = [0.3, 0.6, 0.7];
inst_component(13).parameters.wavelength = 6;
inst_component(13).parameters.delta_wavelength = 10;

inst_component(14).name = 'Guide: Source Guide';
inst_component(14).position = -21.6;
inst_component(14).length = -1;
inst_component(14).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(14).drawdim = [0, 50e-3];
inst_component(14).drawcntr = [0, 0];
inst_component(14).color = [1, 0, 0];


%Describe Secondary Spectrometer from sample forwards
%Tube geometry
inst_config.tube_diameter = 2.4; %m internal diameter
inst_config.tube_length = 20; %m

%Rear Detector (1) 
%SANS_I detector can also translate like D22 up to 40cm (opposite direction
%to D22)
inst_component(15).name = 'Detector 1: Rear';
inst_component(15).position = 6;
inst_component(15).parameters.position_max = 20.4;
inst_component(15).parameters.position_min = 1.4;
inst_component(15).pannels = 1;
inst_component(15).pannel1.name = 'Rear';
inst_component(15).pannel1.relative_position = 0;
inst_component(15).pannel1.length = 0.1;
inst_component(15).pannel1.xydim = {[0.960, 0.960]}; %x,y
inst_component(15).pannel1.drawdim = [0.960, 0.960];
inst_component(15).pannel1.drawcntr = [0,0];
inst_component(15).pannel1.color = [0 1 0];
inst_component(15).pannel1.parameters.pixels = [128,128]; %x,y
inst_component(15).pannel1.parameters.pixel_size = [7.5e-3, 7.5e-3]; %x,y
inst_component(15).pannel1.parameters.centre = [64.5,64.5]; %x,y pixels
inst_component(15).pannel1.parameters.centre_translation = [0 0]; %m
inst_component(15).pannel1.parameters.shaddow_mask = [];
inst_component(15).pannel1.parameters.beam_stop_mask = [];
inst_component(15).pannel1.parameters.opening = [0 0];

