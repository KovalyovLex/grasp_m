function [inst_config, inst_component] = apex_model_component

inst_config = [];
inst_component = [];

%***** Describe APEX Instrument Configuration *****
%All distance are measured from the sample position.
%i.e. +ve distances in detector direction, -ve distance in source direction
%Wavelength Parameters
inst_config.mono_tof = 'Mono';
inst_config.mono_wav = 6; %Angs
inst_config.mono_dwav = 10; % %FWHM resolution
inst_config.wav_color = [0.3, 0.6, 0.7];
inst_config.wav_modes = {'Mono'};
inst_config.source_size = []; %x,y or diameter.  Calculated later depending on aperture positions
inst_config.col = 5; %Current collimation position
inst_config.max_flux = 1e7; %n /cm2 /s   (at 2.8m, 6angs 10% delta_lambda)
inst_config.max_flux_col = 5; %collimation when max flux
inst_config.max_flux_wav = 6; %Wavelength when max flux
inst_config.max_flux_source_size = [120e-3,60e-3];
inst_config.guide_m = 1; %m value of guides though the instrument


component = 1;

inst_component(component).name = 'Collimation';
inst_component(component).position = 0;
inst_component(component).length = -5; %z
inst_component(component).xydim = {[60e-3, 120e-3]}; %x,y
inst_component(component).drawdim = [0, 120e-3];
inst_component(component).drawcntr = [0, 0];
inst_component(component).color = [1, 0, 0];
component = component +1;

inst_component(component).name = 'Aperture';
inst_component(component).position = -5;
inst_component(component).length = 0;
inst_component(component).xydim = {[60e-3], [50e-3], [40e-3], [30e-3], [20e-3], [10e-3]};
inst_component(component).value = 1;
inst_component(component).drawdim = [0, 100e-3];
inst_component(component).drawcntr = [0, 0];
inst_component(component).color = [1, 1, 0];
component = component +1;


inst_component(component).name = 'Attenuator';
inst_component(component).position = -5;
inst_component(component).length = -0;
inst_component(component).xydim = {[60e-3, 120e-3]}; %x,y
inst_component(component).drawdim = [0, 120e-3];
inst_component(component).drawcntr = [0, 0];
inst_component(component).color = [0.6, 0.6, 1];
component = component +1;

inst_component(component).name = 'Monitor';
inst_component(component).position = -5.1;
inst_component(component).length = -0.1;
inst_component(component).xydim = {[60e-3, 120e-3]}; %x,y
inst_component(component).drawdim = [0, 120e-3];
inst_component(component).drawcntr = [0, 0];
inst_component(component).color = [0.6, 0.6, 0];
component = component +1;

inst_component(component).name = 'Selector:';
inst_component(component).position = -5.2;
inst_component(component).length = -0.4;
inst_component(component).xydim = {[40e-3, 45e-3]}; %x,y
inst_component(component).drawdim = [0, 300e-3];
inst_component(component).drawcntr = [0, -120e-3];
inst_component(component).color = [0.3, 0.6, 0.7];
inst_component(component).parameters.wavelength = 6;
inst_component(component).parameters.delta_wavelength = 10;
component = component +1;

inst_component(component).name = 'Guide: Source Guide';
inst_component(component).position = -5.7;
inst_component(component).length = -1;
inst_component(component).xydim = {[120e-3, 60e-3]}; %x,y
inst_component(component).drawdim = [0, 55e-3];
inst_component(component).drawcntr = [0, 0];
inst_component(component).color = [1, 0, 0];
component = component +1;


%Describe Secondary Spectrometer from sample forwards
%Tube geometry
inst_config.tube_diameter = 0.4; %m internal diameter
inst_config.tube_length = 5.2; %m

%Rear Detector (1)
inst_component(component).name = 'Detector 1: Rear';
inst_component(component).position = 5;
inst_component(component).parameters.position_max = 5;
inst_component(component).parameters.position_min = 0.1;
inst_component(component).pannels = 1;
inst_component(component).pannel1.name = 'Rear';
inst_component(component).pannel1.relative_position = 0;
inst_component(component).pannel1.length = 0.1;
inst_component(component).pannel1.xydim = {[0.2, 0.2]}; %x,y
inst_component(component).pannel1.drawdim = [0.2, 0.2];
inst_component(component).pannel1.drawcntr = [0,0];
inst_component(component).pannel1.color = [0 1 0];
inst_component(component).pannel1.parameters.pixels = [500,500]; %x,y
inst_component(component).pannel1.parameters.pixel_size = [0.4e-3, 0.4e-3]; %x,y
inst_component(component).pannel1.parameters.centre = [250.5,250.5]; %x,y pixels
inst_component(component).pannel1.parameters.centre_translation = [0 0]; %m
inst_component(component).pannel1.parameters.centre_translation_max = [0, 0]; %x,y %m
inst_component(component).pannel1.parameters.centre_translation_min = [-0.4, 0]; %x,y %m
inst_component(component).pannel1.parameters.shaddow_mask = [];
inst_component(component).pannel1.parameters.beam_stop_mask = [];
inst_component(component).pannel1.parameters.opening = [0 0];
component = component +1;

