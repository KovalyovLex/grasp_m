function [inst_config, inst_component] = d11_model_component;

inst_config = [];
inst_component = [];

%***** Describe D1 Instrument Configuration *****
%All distance are measured from the sample position.
%i.e. +ve distances in detector direction, -ve distance in source direction
%Wavelength Parameters
inst_config.mono_tof = 'Mono';
inst_config.mono_wav = 6; %Angs
inst_config.mono_dwav = 10; % %FWHM resolution
inst_config.wav_color = [0.3, 0.6, 0.7];
inst_config.wav_modes = {'Mono'};
inst_config.source_size = []; %x,y or diameter.  Calculated later depending on aperture positions
inst_config.col = 8; %Current collimation position
inst_config.max_flux = 1e8; %n /cm2 /s
inst_config.max_flux_col = 1.5; %collimation when max flux
inst_config.max_flux_wav = 6; %Wavelength when max flux
inst_config.max_flux_source_size = [45e-3,50e-3];
inst_config.guide_m = 0.65; %m value of guides though the instrument

inst_component(1).name = 'Collimation';
inst_component(1).position = 0;
inst_component(1).length = -1.5; %z
inst_component(1).xydim = {[40e-3, 55e-3]}; %x,y
inst_component(1).drawdim = [0, 55e-3];
inst_component(1).drawcntr = [0, 0];
inst_component(1).color = [1, 0, 0];

inst_component(2).name = 'Aperture';
inst_component(2).position = -1.5;
inst_component(2).length = 0;
inst_component(2).xydim = {[36.5e-3,40e-3], [50e-3, 55e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
inst_component(2).value = 1;
inst_component(2).drawdim = [0, 100e-3];
inst_component(2).drawcntr = [0, 0];
inst_component(2).color = [1, 1, 0];

inst_component(3).name = 'Collimation';
inst_component(3).position = -1.5;
inst_component(3).length = -1;
inst_component(3).xydim = {[31.5e-3, 35e-3]}; %x,y
inst_component(3).drawdim = [0, 55e-3];
inst_component(3).drawcntr = [0, 0];
inst_component(3).color = [1, 0, 0];

inst_component(4).name = 'Collimation';
inst_component(4).position = -2.5;
inst_component(4).length = -1.5;
inst_component(4).xydim = {[34.87e-3, 38.74e-3]}; %x,y
inst_component(4).drawdim = [0, 55e-3];
inst_component(4).drawcntr = [0, 0];
inst_component(4).color = [1, 0, 0];

inst_component(6).name = 'Collimation';
inst_component(6).position = -4;
inst_component(6).length = -1.5;
inst_component(6).xydim = {[39.95e-3, 44.39e-3]}; %x,y
inst_component(6).drawdim = [0, 55e-3];
inst_component(6).drawcntr = [0, 0];
inst_component(6).color = [1, 0, 0];

inst_component(7).name = 'Aperture';
inst_component(7).position = -5.5;
inst_component(7).length = 0;
inst_component(7).xydim = {[50e-3,80e-3], [50e-3, 55e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
inst_component(7).value = 1;
inst_component(7).drawdim = [0, 100e-3];
inst_component(7).drawcntr = [0, 0];
inst_component(7).color = [1, 1, 0];

inst_component(8).name = 'Collimation';
inst_component(8).position = -5.5;
inst_component(8).length = -2.5;
inst_component(8).xydim = {[45e-3, 50e-3]}; %x,y
inst_component(8).drawdim = [0, 55e-3];
inst_component(8).drawcntr = [0, 0];
inst_component(8).color = [1, 0, 0];

inst_component(9).name = 'Collimation';
inst_component(9).position = -8;
inst_component(9).length = -2.5;
inst_component(9).xydim = {[45e-3, 50e-3]}; %x,y
inst_component(9).drawdim = [0, 55e-3];
inst_component(9).drawcntr = [0, 0];
inst_component(9).color = [1, 0, 0];

inst_component(10).name = 'Aperture';
inst_component(10).position = -10.5;
inst_component(10).length = 0;
inst_component(10).xydim = {[50e-3,80e-3], [50e-3, 55e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
inst_component(10).value = 1;
inst_component(10).drawdim = [0, 100e-3];
inst_component(10).drawcntr = [0, 0];
inst_component(10).color = [1, 1, 0];

inst_component(11).name = 'Collimation';
inst_component(11).position = -10.5;
inst_component(11).length = -3;
inst_component(11).xydim = {[45e-3, 50e-3]}; %x,y
inst_component(11).drawdim = [0, 55e-3];
inst_component(11).drawcntr = [0, 0];
inst_component(11).color = [1, 0, 0];

inst_component(12).name = 'Collimation';
inst_component(12).position = -13.5;
inst_component(12).length = -3;
inst_component(12).xydim = {[45e-3, 50e-3]}; %x,y
inst_component(12).drawdim = [0, 55e-3];
inst_component(12).drawcntr = [0, 0];
inst_component(12).color = [1, 0, 0];

inst_component(13).name = 'Collimation';
inst_component(13).position = -16.5;
inst_component(13).length = -4;
inst_component(13).xydim = {[45e-3, 50e-3]}; %x,y
inst_component(13).drawdim = [0, 55e-3];
inst_component(13).drawcntr = [0, 0];
inst_component(13).color = [1, 0, 0];

inst_component(14).name = 'Aperture';
inst_component(14).position = -20.5;
inst_component(14).length = 0;
inst_component(14).xydim = {[50e-3,80e-3], [50e-3, 55e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
inst_component(14).value = 1;
inst_component(14).drawdim = [0, 100e-3];
inst_component(14).drawcntr = [0, 0];
inst_component(14).color = [1, 1, 0];

inst_component(15).name = 'Collimation';
inst_component(15).position = -20.5;
inst_component(15).length = -7.5;
inst_component(15).xydim = {[45e-3, 50e-3]}; %x,y
inst_component(15).drawdim = [0, 55e-3];
inst_component(15).drawcntr = [0, 0];
inst_component(15).color = [1, 0, 0];

inst_component(16).name = 'Collimation';
inst_component(16).position = -28;
inst_component(16).length = -6;
inst_component(16).xydim = {[45e-3, 50e-3]}; %x,y
inst_component(16).drawdim = [0, 55e-3];
inst_component(16).drawcntr = [0, 0];
inst_component(16).color = [1, 0, 0];

inst_component(17).name = 'Collimation';
inst_component(17).position = -34;
inst_component(17).length = -6.5;
inst_component(17).xydim = {[45e-3, 50e-3]}; %x,y
inst_component(17).drawdim = [0, 55e-3];
inst_component(17).drawcntr = [0, 0];
inst_component(17).color = [1, 0, 0];

inst_component(18).name = 'Aperture';
inst_component(18).position = -40.5;
inst_component(18).length = 0;
inst_component(18).xydim = {[35e-3,55e-3], [30e-3]};
inst_component(18).value = 1;
inst_component(18).drawdim = [0, 100e-3];
inst_component(18).drawcntr = [0, 0];
inst_component(18).color = [1, 1, 0];

inst_component(19).name = 'Attenuator';
inst_component(19).position = -40.5;
inst_component(19).length = -0.2;
inst_component(19).xydim = {[30e-3, 50e-3]}; %x,y
inst_component(19).drawdim = [0, 55e-3];
inst_component(19).drawcntr = [0, 0];
inst_component(19).color = [0.6, 0.6, 1];

inst_component(20).name = 'Monitor';
inst_component(20).position = -40.7;
inst_component(20).length = -0.1;
inst_component(20).xydim = {[100e-3, 100e-3]}; %x,y
inst_component(20).drawdim = [0, 100e-3];
inst_component(20).drawcntr = [0, 0];
inst_component(20).color = [0.6, 0.6, 0];

inst_component(21).name = 'Selector:';
inst_component(21).position = -40.8;
inst_component(21).length = -0.4;
inst_component(21).xydim = {[30e-3, 50e-3]}; %x,y
inst_component(21).drawdim = [0, 300e-3];
inst_component(21).drawcntr = [0, -120e-3];
inst_component(21).color = [0.3, 0.6, 0.7];
inst_component(21).parameters.wavelength = 6;
inst_component(21).parameters.delta_wavelength = 10;

inst_component(22).name = 'Guide: Source Guide';
inst_component(22).position = -41.2;
inst_component(22).length = -5;
inst_component(22).xydim = {[30e-3, 50e-3]}; %x,y
inst_component(22).drawdim = [0, 55e-3];
inst_component(22).drawcntr = [0, 0];
inst_component(22).color = [1, 0, 0];


%Describe Secondary Spectrometer from sample forwards
%Tube geometry
inst_config.tube_diameter = 2.2; %m internal diameter
inst_config.tube_length = 40; %m

%Rear Detector (1)
inst_component(23).name = 'Detector 1: Rear';
inst_component(23).position = 6;
inst_component(23).parameters.position_max = 39;
inst_component(23).parameters.position_min = 1.2;
inst_component(23).pannels = 1;
inst_component(23).pannel1.name = 'Rear';
inst_component(23).pannel1.relative_position = 0;
inst_component(23).pannel1.length = 0.3;
inst_component(23).pannel1.xydim = {[0.96, 0.96]}; %x,y
inst_component(23).pannel1.drawdim = [0.96, 0.96];
inst_component(23).pannel1.drawcntr = [0,0];
inst_component(23).pannel1.color = [0 1 0];
inst_component(23).pannel1.parameters.pixels = [128,128]; %x,y
inst_component(23).pannel1.parameters.pixel_size = [7.5e-3, 7.5e-3]; %x,y
inst_component(23).pannel1.parameters.centre = [64.5,64.5]; %x,y pixels
inst_component(23).pannel1.parameters.centre_translation = [0 0]; %m
inst_component(23).pannel1.parameters.shaddow_mask = [];
inst_component(23).pannel1.parameters.beam_stop_mask = [];
inst_component(23).pannel1.parameters.opening = [0 0];

