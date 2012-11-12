function [inst_config, inst_component] = ansto_quokka_model_component

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
inst_config.col = 6.87; %Current collimation position
inst_config.max_flux = 1e8; %n /cm2 /s
inst_config.max_flux_col = 3.87; %collimation when max flux
inst_config.max_flux_wav = 6; %Wavelength when max flux
inst_config.max_flux_source_size = [50e-3,50e-3];
inst_config.guide_m = 1; %m value of guides though the instrument

n = 0;
%Note:  Sinq_SANS1 guide size is 50x50mm  BUT, each collimator section has
%a 48x48mm square aperture at the beginning

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = 0;
inst_component(n).length = -0.87; %z
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -0.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -0.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -2.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -2.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -4.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -4.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -6.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -6.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -8.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -8.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -10.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -10.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -12.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -12.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -14.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -14.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -16.87;
inst_component(n).length = 0;
inst_component(n).xydim = {[50e-3]};
inst_component(n).value = 1;
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Collimation';
inst_component(n).position = -16.87;
inst_component(n).length = -2;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];

n=n+1;
inst_component(n).name = 'Aperture';
inst_component(n).position = -18.87;
inst_component(n).length = -0.1;
inst_component(n).xydim = {[5e-3], [10e-3], [20e-3], [30e-3], [40e-3], [50e-3], [50e-3, 50e-3], [2.5e-3, 50e-3], [5e-3, 50e-3], [10e-3, 50e-3]};
inst_component(n).value = 7
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 1, 0];

n=n+1;
inst_component(n).name = 'Attenuator';
inst_component(n).position = -18.97;
inst_component(n).length = -0.1;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [0.6, 0.6, 1];

n=n+1;
inst_component(n).name = 'Monitor';
inst_component(n).position = -19.07;
inst_component(n).length = -0.1;
inst_component(n).xydim = {[100e-3, 100e-3]}; %x,y
inst_component(n).drawdim = [0, 100e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [0.6, 0.6, 0];


n=n+1;
inst_component(n).name = 'Selector:';
inst_component(n).position = -19.17;
inst_component(n).length = -0.5;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 300e-3];
inst_component(n).drawcntr = [0, -120e-3];
inst_component(n).color = [0.3, 0.6, 0.7];
inst_component(n).parameters.wavelength = 6;
inst_component(n).parameters.delta_wavelength = 10;

n=n+1;
inst_component(n).name = 'Guide: Source Guide';
inst_component(n).position = -19.67;
inst_component(n).length = -1;
inst_component(n).xydim = {[50e-3, 50e-3]}; %x,y
inst_component(n).drawdim = [0, 50e-3];
inst_component(n).drawcntr = [0, 0];
inst_component(n).color = [1, 0, 0];


%Describe Secondary Spectrometer from sample forwards
%Tube geometry
inst_config.tube_diameter = 2; %m internal diameter
inst_config.tube_length = 22; %m

%Rear Detector (1) 
n=n+1;
inst_component(n).name = 'Detector 1: Rear';
inst_component(n).position = 3;
inst_component(n).parameters.position_max = 21;
inst_component(n).parameters.position_min = 1;
inst_component(n).pannels = 1;
inst_component(n).pannel1.name = 'Rear';
inst_component(n).pannel1.relative_position = 0;
inst_component(n).pannel1.length = 0.1;
inst_component(n).pannel1.xydim = {[0.96, 0.96]}; %x,y
inst_component(n).pannel1.drawdim = [0.96, 0.96];
inst_component(n).pannel1.drawcntr = [0,0];
inst_component(n).pannel1.color = [0 1 0];
inst_component(n).pannel1.parameters.pixels = [192,192]; %x,y
inst_component(n).pannel1.parameters.pixel_size = [5.08e-3, 5.08e-3]; %x,y
inst_component(n).pannel1.parameters.centre = [96.5,96.5]; %x,y pixels
inst_component(n).pannel1.parameters.centre_translation = [0 0]; %m
inst_component(n).pannel1.parameters.shaddow_mask = [];
inst_component(n).pannel1.parameters.beam_stop_mask = [];
inst_component(n).pannel1.parameters.opening = [0 0];

