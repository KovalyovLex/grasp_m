function initialise_instrument_params

global grasp_env
global inst_params
inst_params = [];


%Make a default set of param.vectors based on D11/D22 enough to make grasp work
%These then get over-written or double-named in the instrument description below
%These are param.vectors that Grasp always expects to find some mention of

%General Measurement Parameters
param_vectors.numor = [];
param_vectors.counts = [];
param_vectors.time = [];
param_vectors.array_counts = [];
param_vectors.monitor = [];
param_vectors.monitor1 = [];
param_vectors.monitor2 = [];

%Neutron Parameters
param_vectors.wav = [];
param_vectors.deltawav = [];

%Collimation, Attenuation & Polarisation Parameters
param_vectors.col = [];
param_vectors.att_type = [];
param_vectors.att_status = [];

%Sample Movements & Sample Environment
param_vectors.san = [];
param_vectors.phi = [];
param_vectors.trs = [];
param_vectors.sdi = [];
param_vectors.sht = [];
param_vectors.str = [];
param_vectors.chpos = [];

param_vectors.temp = [];
param_vectors.treg = [];
param_vectors.tset = [];
param_vectors.field = [];


%Detector Parameters
param_vectors.detcalc = [];
param_vectors.det = [];
param_vectors.dan = [];
param_vectors.dtr = [];

param_vectors.by = [];
param_vectors.bx = [];

param_vectors.pixel_x = [];
param_vectors.pixel_y = [];


%List all available instruments:  Menus are built from this declaration
grasp_env.availaible_instruments = [{[{'ILL_d11'} {'d11_nexus'} {'new_d11'} {'old_d11'}]} {[{'ILL_d22'} {'d22'} {'d22_nexus'} {'d22_Jan2004_to_Oct2010'} {'d22_Pre2004'} {'d22_rawdata'} {'d22_BERSANS_Treated_Data'}]} {[{'ILL_d33'} {'D33'} {'D33_Instrument_Commissioning'}]} {[{'LLB'} {'PAXY_BF3_Detector'} {'PAXY_Monoblock_Detector'} {'TPA'}]} {[{'SINQ_PSI'} {'SINQ_sans_I'} {'SINQ_sans_II'}]} {[{'NIST_NCNR'} {'NIST_ng3'} {'NIST_ng7'}]} {[{'ORNL_cg2'} {'old_detector192y'} {'new_detector256y'}]} {'ORNL_cg3'} {'ANSTO_quokka'} {[{'JAEA_sansu'} {'JAEA_sansu'} {'JAEA_sansu_hres'}]} {[{'FRM2_Mira'} {'data128x128'} {'data256x256'}]} {[{'FRM2_SANS1'} {'SANS1'}]} {[{'HZB_V4'} {'V4_NewDetector2012'} {'V4_128'} {'V4_64'}]} {'ISIS_SANS_2D'}];


disp(['Initialising Instrument: ' grasp_env.inst ' Option: ' grasp_env.inst_option]);

switch grasp_env.inst
    
    case 'LLB'
        
        if strcmp(grasp_env.inst_option,'PAXY_BF3_Detector')
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 4;
            inst_params.filename.lead_string = 'XY';
            inst_params.filename.extension_string = '.32';
            inst_params.filename.data_loader = 'grasp_paxy_read_wrapper';
            
            inst_params.guide_size = [30e-3,25e-3];  %mm x y
            inst_params.wav_range = [3 40];
            
            inst_params.att.position = -0; %Position relative to sample
            inst_params.att.number = [0];
            inst_params.att.ratio = [1];
            inst_params.att.type = [{'aperture'}];
            inst_params.att.size = {[30e-3,25e-3]}; %mm rectangular or diameter
            
            inst_params.col = [2.5, 5, 7.5];
            inst_params.col_aps{1} = {[30e-3,25e-3]};
            inst_params.col_aps{2} = {[30e-3,25e-3]};
            inst_params.col_aps{3} = {[30e-3,25e-3]};
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5, 5]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 0*10^-6;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = get_mask('llb_paxy_bf4_msk.msk');
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
            inst_params.vectors.time = 3;
            
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.det1 = 19;
            
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
            
            inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
            inst_params.vectors.detcalc1 = 26;
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.lambda = 53; %same as wav
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            
            %inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            %inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            
            inst_params.vectors.source_ap = 57; inst_params.vector_names{57} = {'Col Source Diameter mm'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.attenuator = 59; %same as att_type
            inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
            
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            
            
        elseif strcmp(grasp_env.inst_option,'PAXY_Monoblock_Detector')
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 4;
            inst_params.filename.lead_string = 'XY';
            inst_params.filename.extension_string = '.32';
            inst_params.filename.data_loader = 'grasp_paxy_read_wrapper';
            
            inst_params.guide_size = [30e-3,25e-3];  %mm x y
            inst_params.wav_range = [3 40];
            
            inst_params.att.position = -0; %Position relative to sample
            inst_params.att.number = [0];
            inst_params.att.ratio = [1];
            inst_params.att.type = [{'aperture'}];
            inst_params.att.size = {[30e-3,25e-3]}; %mm rectangular or diameter
            
            inst_params.col = [2.5, 5, 7.5];
            inst_params.col_aps{1} = {[30e-3,25e-3]};
            inst_params.col_aps{2} = {[30e-3,25e-3]};
            inst_params.col_aps{3} = {[30e-3,25e-3]};
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5, 5]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 0*10^-6;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = ones(inst_params.detector1.pixels);
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
            inst_params.vectors.time = 3;
            
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.det1 = 19;
            
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
            
            inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
            inst_params.vectors.detcalc1 = 26;
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.lambda = 53; %same as wav
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            
            %inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            %inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            
            inst_params.vectors.source_ap = 57; inst_params.vector_names{57} = {'Col Source Diameter mm'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.attenuator = 59; %same as att_type
            inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
            
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            
            
            
            
            
            
        elseif strcmp(grasp_env.inst_option,'TPA')
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 4;
            inst_params.filename.lead_string = 'TPA';
            inst_params.filename.extension_string = '.xml';
            inst_params.filename.data_loader = 'raw_read_llb_tpa';
            
            inst_params.guide_size = [40e-3,25e-3];  %mm x y
            inst_params.wav_range = [3 40];
            
            inst_params.att.position = -0; %Position relative to sample
            inst_params.att.number = [0];
            inst_params.att.ratio = [1];
            inst_params.att.type = [{'aperture'}];
            inst_params.att.size = {[40e-3,25e-3]}; %mm rectangular or diameter
            
            inst_params.col = [6];
            inst_params.col_aps{1} = {[40e-3,25e-3]};
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [512 512]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [0.15, 0.15]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [256.5 256.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 0*10^-6;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = ones(inst_params.detector1.pixels); %get_mask('llb_paxy_bf4_msk.msk');
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
            inst_params.vectors.time = 3;
            
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.det1 = 19;
            
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
            
            inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
            inst_params.vectors.detcalc1 = 26;
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.lambda = 53; %same as wav
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            
            inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            
            inst_params.vectors.source_ap = 57; inst_params.vector_names{57} = {'Col Source Diameter mm'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.attenuator = 59; %same as att_type
            inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
            
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            
        end
        
        
        
        
    case 'ILL_d22'
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 6;
        
        inst_params.guide_size = [40e-3,55e-3];  %m x y
        inst_params.wav_range = [1 38];
        
        inst_params.att.position = -18.8; %Position relative to sample
        inst_params.att.number = [0, 1, 2, 3, 4, 5, 6, 7];
        
        %Wavelength dependent attenuators, e.g. ratio(1,:) = [wav, att1, att2, att3 ....]
        %if more than one wavelength entry then interpolate for wavelengths inbetween
        
        
        %Simple single values for all attenuators.
        %inst_params.att.ratio = [1, 147, 902, 2874, 112, 28, 7, 3.1];
        
        
        
        
        %3D matrix Att# col col col
        %          wav
        %          wav
        %          wav
        %inst_params.att.ratio = [];
        
        n_cols =10; n_wavs = 10;
        cols = [1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        wavs = [1; 4.5; 5; 6; 8; 10; 11.5; 14; 18; 40];
        
        
        %Att0 - rectangular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1) = ones(n_wavs+1,n_cols+1);
        inst_params.att.ratio(2:n_wavs+1,1) = wavs; inst_params.att.ratio(1,2:n_cols+1) = cols;
        inst_params.att.ratio(1,1,1) = 0; %Att number
        
        
        %Att1 - rectangular diaphragm (values as of Feb 2013)
        inst_params.att.ratio(1,:,2) = [1, 1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        inst_params.att.ratio(2,:,2) = [1, 159.1514939, 159.1514939, 159.3390477, 157.6182694, 153.9380313,	155.8121938, 157.0651778, 160.3481585, 156.3206724, 147];
        inst_params.att.ratio(3,:,2) = [4.5, 159.1514939, 159.1514939, 159.3390477, 157.6182694, 153.9380313,	155.8121938, 157.0651778, 160.3481585, 156.3206724, 147];
        inst_params.att.ratio(4,:,2) = [5,  160.3218137, 160.3218137, 161.4059632, 160.4771765, 153.4533819, 155.487212, 154.0559438, 161.4811135, 156.8701091, 147];
        inst_params.att.ratio(5,:,2) = [6, 161.3897179, 161.3897179, 162.6171902, 160.6163217, 154.0993426, 155.0322022, 152.4939526, 162.7163112, 159.1979444, 147];
        inst_params.att.ratio(6,:,2) = [8, 165.1694866, 165.1694866, 164.2024295, 161.5682434, 151.090279, 154.6417158, 155.2927849, 158.3023139, 160.147665, 147];
        inst_params.att.ratio(7,:,2) = [10, 165.255679, 165.255679, 165.7011829, 162.3845829, 151.9563151, 152.6853031, 149.2886807, 157.3985827, 170.1949799, 147];
        inst_params.att.ratio(8,:,2) = [11.5,  165.9306386, 165.9306386, 164.6183907, 163.0601189, 151.3736442, 147.9941409, 141.9725436, 158.838917, 171.5079975, 147];
        inst_params.att.ratio(9,:,2) = [14, 165.808165, 165.808165, 166.1321769, 164.5226344, 148.001548, 149.6563563, 141.6800617, 152.5736125, 176.4779411, 147];
        inst_params.att.ratio(10,:,2) = [18, 161.618621, 161.618621, 164.1944141, 151.51158, 155.0078569, 159.8046583, 149.0982934, 143.7190927, 146.1097335, 147];
        inst_params.att.ratio(11,:,2) = [40, 161.618621, 161.618621, 164.1944141, 151.51158, 155.0078569, 159.8046583, 149.0982934, 143.7190927, 146.1097335, 147];
        inst_params.att.ratio(1,1,2) = 1; %Att number
        
        %Att2 - rectangular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,3) = ones(n_wavs+1,n_cols+1)*902 ;
        inst_params.att.ratio(2:n_wavs+1,1,3) = wavs; inst_params.att.ratio(1,2:n_cols+1,3) = cols;
        inst_params.att.ratio(1,1,3) = 2; %Att number
        
        %Att3 - rectangular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,4) = ones(n_wavs+1,n_cols+1)*2874;
        inst_params.att.ratio(2:n_wavs+1,1,4) = wavs; inst_params.att.ratio(1,2:n_cols+1,4) = cols;
        inst_params.att.ratio(1,1,4) = 3; %Att number
        
        %Att4 - rectangular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,5) = ones(n_wavs+1,n_cols+1)*112;
        inst_params.att.ratio(2:n_wavs+1,1,5) = wavs; inst_params.att.ratio(1,2:n_cols+1,5) = cols;
        inst_params.att.ratio(1,1,5) = 4; %Att number
        
        %Att5 - rectangular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,6) = ones(n_wavs+1,n_cols+1)*28;
        inst_params.att.ratio(2:n_wavs+1,1,6) = wavs; inst_params.att.ratio(1,2:n_cols+1,6) = cols;
        inst_params.att.ratio(1,1,6) = 5; %Att number
        
        %Att6 - rectangular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,7) = ones(n_wavs+1,n_cols+1)*7;
        inst_params.att.ratio(2:n_wavs+1,1,7) = wavs; inst_params.att.ratio(1,2:n_cols+1,7) = cols;
        inst_params.att.ratio(1,1,7) = 6; %Att number
        
        %Att7 - rectangular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,8) = ones(n_wavs+1,n_cols+1)*3.1;
        inst_params.att.ratio(2:n_wavs+1,1,8) = wavs; inst_params.att.ratio(1,2:n_cols+1,8) = cols;
        inst_params.att.ratio(1,1,8) = 7; %Att number
        
        %Dummy worksheet (Att8 - does not exist)
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,9) = ones(n_wavs+1,n_cols+1)*3.1;
        inst_params.att.ratio(2:n_wavs+1,1,9) = wavs; inst_params.att.ratio(1,2:n_cols+1,9) = cols;
        inst_params.att.ratio(1,1,9) = 7; %Att number
        
        %Dummy worksheet (Att9 - does not exist)
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,10) = ones(n_wavs+1,n_cols+1)*3.1;
        inst_params.att.ratio(2:n_wavs+1,1,8) = wavs; inst_params.att.ratio(1,2:n_cols+1,10) = cols;
        inst_params.att.ratio(1,1,10) = 7; %Att number
        
        
        %Att0 - Circular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,11) = ones(n_wavs+1,n_cols+1);
        inst_params.att.ratio(2:n_wavs+1,1,11) = wavs; inst_params.att.ratio(1,2:n_cols+1,11) = cols;
        inst_params.att.ratio(1,1,11) = 7; %Att number
        
        %Att1 - circular diaphragm (values as of Feb 2012 but copied from Rectangular)
        inst_params.att.ratio(1,:,12) = [1, 1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        inst_params.att.ratio(2,:,12) = [4, 159.1514939, 159.1514939, 159.3390477, 157.6182694, 153.9380313,	155.8121938, 157.0651778, 160.3481585, 156.3206724, 147];
        inst_params.att.ratio(3,:,12) = [4.5, 159.1514939, 159.1514939, 159.3390477, 157.6182694, 153.9380313,	155.8121938, 157.0651778, 160.3481585, 156.3206724, 147];
        inst_params.att.ratio(4,:,12) = [5,  160.3218137, 160.3218137, 161.4059632, 160.4771765, 153.4533819, 155.487212, 154.0559438, 161.4811135, 156.8701091, 147];
        inst_params.att.ratio(5,:,12) = [6, 161.3897179, 161.3897179, 162.6171902, 160.6163217, 154.0993426, 155.0322022, 152.4939526, 162.7163112, 159.1979444, 147];
        inst_params.att.ratio(6,:,12) = [8, 165.1694866, 165.1694866, 164.2024295, 161.5682434, 151.090279, 154.6417158, 155.2927849, 158.3023139, 160.147665, 147];
        inst_params.att.ratio(7,:,12) = [10, 165.255679, 165.255679, 165.7011829, 162.3845829, 151.9563151, 152.6853031, 149.2886807, 157.3985827, 170.1949799, 147];
        inst_params.att.ratio(8,:,12) = [11.5,  165.9306386, 165.9306386, 164.6183907, 163.0601189, 151.3736442, 147.9941409, 141.9725436, 158.838917, 171.5079975, 147];
        inst_params.att.ratio(9,:,12) = [14, 165.808165, 165.808165, 166.1321769, 164.5226344, 148.001548, 149.6563563, 141.6800617, 152.5736125, 176.4779411, 147];
        inst_params.att.ratio(10,:,12) = [18, 161.618621, 161.618621, 164.1944141, 151.51158, 155.0078569, 159.8046583, 149.0982934, 143.7190927, 146.1097335, 147];
        inst_params.att.ratio(11,:,12) = [40, 161.618621, 161.618621, 164.1944141, 151.51158, 155.0078569, 159.8046583, 149.0982934, 143.7190927, 146.1097335, 147];
        inst_params.att.ratio(1,1,12) = 1; %Att number
        
        %Att2 - circular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,13) = ones(n_wavs+1,n_cols+1)*902 ;
        inst_params.att.ratio(2:n_wavs+1,1,13) = wavs; inst_params.att.ratio(1,2:n_cols+1,13) = cols;
        inst_params.att.ratio(1,1,13) = 2; %Att number
        
        %Att3 - circular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,14) = ones(n_wavs+1,n_cols+1)*2874;
        inst_params.att.ratio(2:n_wavs+1,1,14) = wavs; inst_params.att.ratio(1,2:n_cols+1,14) = cols;
        inst_params.att.ratio(1,1,14) = 3; %Att number
        
        %Att4 - circular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,15) = ones(n_wavs+1,n_cols+1)*112;
        inst_params.att.ratio(2:n_wavs+1,1,15) = wavs; inst_params.att.ratio(1,2:n_cols+1,15) = cols;
        inst_params.att.ratio(1,1,15) = 4; %Att number
        
        %Att5 - circular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,16) = ones(n_wavs+1,n_cols+1)*28;
        inst_params.att.ratio(2:n_wavs+1,1,16) = wavs; inst_params.att.ratio(1,2:n_cols+1,16) = cols;
        inst_params.att.ratio(1,1,16) = 5; %Att number
        
        %Att6 - circular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,17) = ones(n_wavs+1,n_cols+1)*7;
        inst_params.att.ratio(2:n_wavs+1,1,17) = wavs; inst_params.att.ratio(1,2:n_cols+1,17) = cols;
        inst_params.att.ratio(1,1,17) = 6; %Att number
        
        %Att7 - circular diaphragm
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,18) = ones(n_wavs+1,n_cols+1)*3.1;
        inst_params.att.ratio(2:n_wavs+1,1,18) = wavs; inst_params.att.ratio(1,2:n_cols+1,18) = cols;
        inst_params.att.ratio(1,1,18) = 7; %Att number
        
        
        
        
        %3D matrix Att# col col col
        %          wav
        %          wav
        %          wav
        %inst_params.att.ratio = [];
        
        %n_cols =10; n_wavs = 9;
        %cols = [1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        %wavs = [4; 4.5; 6; 8; 10; 12; 14; 16; 40];
        
        
        %         %Att0 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1) = ones(n_wavs+1,n_cols+1);
        %         inst_params.att.ratio(2:n_wavs+1,1) = wavs; inst_params.att.ratio(1,2:n_cols+1) = cols;
        %         inst_params.att.ratio(1,1,1) = 0; %Att number
        
        %Old values for Att 1 rectangular (before 21 June 2011)
        %         %Att1 - rectangular diaphragm
        %         inst_params.att.ratio(1,:,2) = [1, 1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        %         inst_params.att.ratio(2,:,2) = [4, 142.9, 145.23, 144.67, 145.57, 146.38, 149.43, 156.22, 137.55, 127.32, 147];
        %         inst_params.att.ratio(3,:,2) = [4.5, 142.9, 145.23, 144.67, 145.57, 146.38, 149.43, 156.22, 137.55, 127.32, 147];
        %         inst_params.att.ratio(4,:,2) = [6, 144.95, 145.44, 145.31, 140.84, 145.57, 155.61, 167.22, 146.86, 133.60, 147];
        %         inst_params.att.ratio(5,:,2) = [8, 134.33, 136.76, 135.82, 133.70, 135.56, 155.20, 159.32, 135.61, 135.60, 147];
        %         inst_params.att.ratio(6,:,2) = [10, 141.26, 143.20, 143.78, 140.88, 143.29, 163.57, 170.58, 150.73, 137.42, 147];
        %         inst_params.att.ratio(7,:,2) = [12, 145.19, 143.20, 143.78, 140.88, 143.29, 163.57, 170.58, 150.73, 137.42, 147];
        %         inst_params.att.ratio(8,:,2) = [14, 147.32, 149.41, 149.08, 146.31, 145.57, 155.11, 161.90, 149.22, 137.78, 147];
        %         inst_params.att.ratio(9,:,2) = [16, 153.44, 156.70, 158.14, 157.76, 150.09, 148.71, 149.75, 149.63, 137.22, 147];
        %         inst_params.att.ratio(10,:,2) = [40, 153.44, 156.70, 158.14, 157.76, 150.09, 148.71, 149.75, 149.63, 137.22, 147];
        %         inst_params.att.ratio(1,1,2) = 1; %Att number
        
        
        %         %Att1 - rectangular diaphragm (values as of 21/06/2011)
        %         inst_params.att.ratio(1,:,2) = [1, 1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        %         inst_params.att.ratio(2,:,2) = [4, 220.1, 204.4, 157.33, 143.8, 148.54, 147, 151.42, 143.86, 128.60, 147];
        %         inst_params.att.ratio(3,:,2) = [4.6, 220.1, 204.4, 157.33, 143.8, 148.54, 147, 151.42, 143.86, 128.60, 147];
        %         inst_params.att.ratio(4,:,2) = [6, 196.6, 180.2, 152.0, 143.87, 149.62, 146.25, 149.40, 144.59, 131.00, 147];
        %         inst_params.att.ratio(5,:,2) = [8, 176.2, 165.60, 154.80, 144.42, 151.47, 145.99, 148.23, 144.33, 132.95, 147];
        %         inst_params.att.ratio(6,:,2) = [10, 168.1, 158.5, 153.1, 146.49, 151.74, 148.18, 148.79, 145.62, 136.89, 147];
        %         inst_params.att.ratio(7,:,2) = [12, 169, 155.4, 153.6, 146.27, 149.85, 147.91, 150.00, 145.84, 138.50, 147];
        %         inst_params.att.ratio(8,:,2) = [14, 162.90, 156.00, 156.30, 151.41, 149.79, 151.35, 155.97, 150.97, 141.27, 147];
        %         inst_params.att.ratio(9,:,2) = [16, 153.44, 156.70, 158.14, 157.76, 150.09, 148.71, 149.75, 149.63, 137.22, 147];
        %         inst_params.att.ratio(10,:,2) = [40, 153.44, 156.70, 158.14, 157.76, 150.09, 148.71, 149.75, 149.63, 137.22, 147];
        %         inst_params.att.ratio(1,1,2) = 1; %Att number
        %
        %         %Att2 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,3) = ones(n_wavs+1,n_cols+1)*902 ;
        %         inst_params.att.ratio(2:n_wavs+1,1,3) = wavs; inst_params.att.ratio(1,2:n_cols+1,3) = cols;
        %         inst_params.att.ratio(1,1,3) = 2; %Att number
        %
        %         %Att3 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,4) = ones(n_wavs+1,n_cols+1)*2874;
        %         inst_params.att.ratio(2:n_wavs+1,1,4) = wavs; inst_params.att.ratio(1,2:n_cols+1,4) = cols;
        %         inst_params.att.ratio(1,1,4) = 3; %Att number
        %
        %         %Att4 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,5) = ones(n_wavs+1,n_cols+1)*112;
        %         inst_params.att.ratio(2:n_wavs+1,1,5) = wavs; inst_params.att.ratio(1,2:n_cols+1,5) = cols;
        %         inst_params.att.ratio(1,1,5) = 4; %Att number
        %
        %         %Att5 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,6) = ones(n_wavs+1,n_cols+1)*28;
        %         inst_params.att.ratio(2:n_wavs+1,1,6) = wavs; inst_params.att.ratio(1,2:n_cols+1,6) = cols;
        %         inst_params.att.ratio(1,1,6) = 5; %Att number
        %
        %         %Att6 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,7) = ones(n_wavs+1,n_cols+1)*7;
        %         inst_params.att.ratio(2:n_wavs+1,1,7) = wavs; inst_params.att.ratio(1,2:n_cols+1,7) = cols;
        %         inst_params.att.ratio(1,1,7) = 6; %Att number
        %
        %         %Att7 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,8) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,8) = wavs; inst_params.att.ratio(1,2:n_cols+1,8) = cols;
        %         inst_params.att.ratio(1,1,8) = 7; %Att number
        %
        %         %Dummy worksheet (Att8 - does not exist)
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,9) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,9) = wavs; inst_params.att.ratio(1,2:n_cols+1,9) = cols;
        %         inst_params.att.ratio(1,1,9) = 7; %Att number
        %
        %         %Dummy worksheet (Att9 - does not exist)
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,10) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,8) = wavs; inst_params.att.ratio(1,2:n_cols+1,10) = cols;
        %         inst_params.att.ratio(1,1,10) = 7; %Att number
        %
        %
        %         %Att0 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,11) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,11) = wavs; inst_params.att.ratio(1,2:n_cols+1,11) = cols;
        %         inst_params.att.ratio(1,1,11) = 7; %Att number
        %
        %         %Att1 - circular diaphragm (values as of 21/06/2011)
        %         inst_params.att.ratio(1,:,12) = [1, 1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        %         inst_params.att.ratio(2,:,12) = [4, 209.6, 209.6, 162.4, 153.0, 146.9, 145.3, 139.8, 134.57, 135.30, 147];
        %         inst_params.att.ratio(3,:,12) = [4.6, 209.6, 209.6, 162.4, 153.0, 146.9, 145.3, 139.8, 134.57, 135.30, 147];
        %         inst_params.att.ratio(4,:,12) = [6, 180.5, 180.5, 158.5, 154.5, 148.00, 146.30, 140.6, 135.27, 137.60, 147];
        %         inst_params.att.ratio(5,:,12) = [8, 165.3, 165.3, 160.7, 159.8, 150.4, 150.0, 143.0, 133.92, 139.00, 147];
        %         inst_params.att.ratio(6,:,12) = [10, 161.5, 161.5, 161.5, 160.4, 152, 151, 146, 136.7, 139.1, 147];
        %         inst_params.att.ratio(7,:,12) = [12, 159.0, 159.0, 159.0, 157.0, 152.7, 153.0, 148.3, 138.8, 142.0, 147];
        %         inst_params.att.ratio(8,:,12) = [14, 156.7, 156.7, 156.7, 154.0, 152.2, 154.0, 149.0, 140.59, 141.7, 147];
        %         inst_params.att.ratio(9,:,12) = [16, 156.7, 156.7, 156.7, 154.0, 152.2, 154.0, 149.0, 140.59, 141.7, 147];
        %         inst_params.att.ratio(10,:,12) = [40, 156.7, 156.7, 156.7, 154.0, 152.2, 154.0, 149.0, 140.59, 141.7, 147];
        %         inst_params.att.ratio(1,1,12) = 1; %Att number
        %
        %         %Att2 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,13) = ones(n_wavs+1,n_cols+1)*902 ;
        %         inst_params.att.ratio(2:n_wavs+1,1,13) = wavs; inst_params.att.ratio(1,2:n_cols+1,13) = cols;
        %         inst_params.att.ratio(1,1,13) = 2; %Att number
        %
        %         %Att3 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,14) = ones(n_wavs+1,n_cols+1)*2874;
        %         inst_params.att.ratio(2:n_wavs+1,1,14) = wavs; inst_params.att.ratio(1,2:n_cols+1,14) = cols;
        %         inst_params.att.ratio(1,1,14) = 3; %Att number
        %
        %         %Att4 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,15) = ones(n_wavs+1,n_cols+1)*112;
        %         inst_params.att.ratio(2:n_wavs+1,1,15) = wavs; inst_params.att.ratio(1,2:n_cols+1,15) = cols;
        %         inst_params.att.ratio(1,1,15) = 4; %Att number
        %
        %         %Att5 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,16) = ones(n_wavs+1,n_cols+1)*28;
        %         inst_params.att.ratio(2:n_wavs+1,1,16) = wavs; inst_params.att.ratio(1,2:n_cols+1,16) = cols;
        %         inst_params.att.ratio(1,1,16) = 5; %Att number
        %
        %         %Att6 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,17) = ones(n_wavs+1,n_cols+1)*7;
        %         inst_params.att.ratio(2:n_wavs+1,1,17) = wavs; inst_params.att.ratio(1,2:n_cols+1,17) = cols;
        %         inst_params.att.ratio(1,1,17) = 6; %Att number
        %
        %         %Att7 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,18) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,18) = wavs; inst_params.att.ratio(1,2:n_cols+1,18) = cols;
        %         inst_params.att.ratio(1,1,18) = 7; %Att number
        
        
        
        
        %3D matrix Att# col col col
        %          wav
        %          wav
        %          wav
        %inst_params.att.ratio = [];
        
        %n_cols =10; n_wavs = 9;
        %cols = [1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        %wavs = [4; 4.5; 6; 8; 10; 12; 14; 16; 40];
        
        
        %         %Att0 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1) = ones(n_wavs+1,n_cols+1);
        %         inst_params.att.ratio(2:n_wavs+1,1) = wavs; inst_params.att.ratio(1,2:n_cols+1) = cols;
        %         inst_params.att.ratio(1,1,1) = 0; %Att number
        
        %Old values for Att 1 rectangular (before 21 June 2011)
        %         %Att1 - rectangular diaphragm
        %         inst_params.att.ratio(1,:,2) = [1, 1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        %         inst_params.att.ratio(2,:,2) = [4, 142.9, 145.23, 144.67, 145.57, 146.38, 149.43, 156.22, 137.55, 127.32, 147];
        %         inst_params.att.ratio(3,:,2) = [4.5, 142.9, 145.23, 144.67, 145.57, 146.38, 149.43, 156.22, 137.55, 127.32, 147];
        %         inst_params.att.ratio(4,:,2) = [6, 144.95, 145.44, 145.31, 140.84, 145.57, 155.61, 167.22, 146.86, 133.60, 147];
        %         inst_params.att.ratio(5,:,2) = [8, 134.33, 136.76, 135.82, 133.70, 135.56, 155.20, 159.32, 135.61, 135.60, 147];
        %         inst_params.att.ratio(6,:,2) = [10, 141.26, 143.20, 143.78, 140.88, 143.29, 163.57, 170.58, 150.73, 137.42, 147];
        %         inst_params.att.ratio(7,:,2) = [12, 145.19, 143.20, 143.78, 140.88, 143.29, 163.57, 170.58, 150.73, 137.42, 147];
        %         inst_params.att.ratio(8,:,2) = [14, 147.32, 149.41, 149.08, 146.31, 145.57, 155.11, 161.90, 149.22, 137.78, 147];
        %         inst_params.att.ratio(9,:,2) = [16, 153.44, 156.70, 158.14, 157.76, 150.09, 148.71, 149.75, 149.63, 137.22, 147];
        %         inst_params.att.ratio(10,:,2) = [40, 153.44, 156.70, 158.14, 157.76, 150.09, 148.71, 149.75, 149.63, 137.22, 147];
        %         inst_params.att.ratio(1,1,2) = 1; %Att number
        
        
        %         %Att1 - rectangular diaphragm (values as of 21/06/2011)
        %         inst_params.att.ratio(1,:,2) = [1, 1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        %         inst_params.att.ratio(2,:,2) = [4, 220.1, 204.4, 157.33, 143.8, 148.54, 147, 151.42, 143.86, 128.60, 147];
        %         inst_params.att.ratio(3,:,2) = [4.6, 220.1, 204.4, 157.33, 143.8, 148.54, 147, 151.42, 143.86, 128.60, 147];
        %         inst_params.att.ratio(4,:,2) = [6, 196.6, 180.2, 152.0, 143.87, 149.62, 146.25, 149.40, 144.59, 131.00, 147];
        %         inst_params.att.ratio(5,:,2) = [8, 176.2, 165.60, 154.80, 144.42, 151.47, 145.99, 148.23, 144.33, 132.95, 147];
        %         inst_params.att.ratio(6,:,2) = [10, 168.1, 158.5, 153.1, 146.49, 151.74, 148.18, 148.79, 145.62, 136.89, 147];
        %         inst_params.att.ratio(7,:,2) = [12, 169, 155.4, 153.6, 146.27, 149.85, 147.91, 150.00, 145.84, 138.50, 147];
        %         inst_params.att.ratio(8,:,2) = [14, 162.90, 156.00, 156.30, 151.41, 149.79, 151.35, 155.97, 150.97, 141.27, 147];
        %         inst_params.att.ratio(9,:,2) = [16, 153.44, 156.70, 158.14, 157.76, 150.09, 148.71, 149.75, 149.63, 137.22, 147];
        %         inst_params.att.ratio(10,:,2) = [40, 153.44, 156.70, 158.14, 157.76, 150.09, 148.71, 149.75, 149.63, 137.22, 147];
        %         inst_params.att.ratio(1,1,2) = 1; %Att number
        %
        %         %Att2 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,3) = ones(n_wavs+1,n_cols+1)*902 ;
        %         inst_params.att.ratio(2:n_wavs+1,1,3) = wavs; inst_params.att.ratio(1,2:n_cols+1,3) = cols;
        %         inst_params.att.ratio(1,1,3) = 2; %Att number
        %
        %         %Att3 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,4) = ones(n_wavs+1,n_cols+1)*2874;
        %         inst_params.att.ratio(2:n_wavs+1,1,4) = wavs; inst_params.att.ratio(1,2:n_cols+1,4) = cols;
        %         inst_params.att.ratio(1,1,4) = 3; %Att number
        %
        %         %Att4 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,5) = ones(n_wavs+1,n_cols+1)*112;
        %         inst_params.att.ratio(2:n_wavs+1,1,5) = wavs; inst_params.att.ratio(1,2:n_cols+1,5) = cols;
        %         inst_params.att.ratio(1,1,5) = 4; %Att number
        %
        %         %Att5 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,6) = ones(n_wavs+1,n_cols+1)*28;
        %         inst_params.att.ratio(2:n_wavs+1,1,6) = wavs; inst_params.att.ratio(1,2:n_cols+1,6) = cols;
        %         inst_params.att.ratio(1,1,6) = 5; %Att number
        %
        %         %Att6 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,7) = ones(n_wavs+1,n_cols+1)*7;
        %         inst_params.att.ratio(2:n_wavs+1,1,7) = wavs; inst_params.att.ratio(1,2:n_cols+1,7) = cols;
        %         inst_params.att.ratio(1,1,7) = 6; %Att number
        %
        %         %Att7 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,8) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,8) = wavs; inst_params.att.ratio(1,2:n_cols+1,8) = cols;
        %         inst_params.att.ratio(1,1,8) = 7; %Att number
        %
        %         %Dummy worksheet (Att8 - does not exist)
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,9) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,9) = wavs; inst_params.att.ratio(1,2:n_cols+1,9) = cols;
        %         inst_params.att.ratio(1,1,9) = 7; %Att number
        %
        %         %Dummy worksheet (Att9 - does not exist)
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,10) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,8) = wavs; inst_params.att.ratio(1,2:n_cols+1,10) = cols;
        %         inst_params.att.ratio(1,1,10) = 7; %Att number
        %
        %
        %         %Att0 - rectangular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,11) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,11) = wavs; inst_params.att.ratio(1,2:n_cols+1,11) = cols;
        %         inst_params.att.ratio(1,1,11) = 7; %Att number
        %
        %         %Att1 - circular diaphragm (values as of 21/06/2011)
        %         inst_params.att.ratio(1,:,12) = [1, 1.4, 2, 2.8, 4, 5.6, 8, 11.2, 14.4, 17.6, 19.0];
        %         inst_params.att.ratio(2,:,12) = [4, 209.6, 209.6, 162.4, 153.0, 146.9, 145.3, 139.8, 134.57, 135.30, 147];
        %         inst_params.att.ratio(3,:,12) = [4.6, 209.6, 209.6, 162.4, 153.0, 146.9, 145.3, 139.8, 134.57, 135.30, 147];
        %         inst_params.att.ratio(4,:,12) = [6, 180.5, 180.5, 158.5, 154.5, 148.00, 146.30, 140.6, 135.27, 137.60, 147];
        %         inst_params.att.ratio(5,:,12) = [8, 165.3, 165.3, 160.7, 159.8, 150.4, 150.0, 143.0, 133.92, 139.00, 147];
        %         inst_params.att.ratio(6,:,12) = [10, 161.5, 161.5, 161.5, 160.4, 152, 151, 146, 136.7, 139.1, 147];
        %         inst_params.att.ratio(7,:,12) = [12, 159.0, 159.0, 159.0, 157.0, 152.7, 153.0, 148.3, 138.8, 142.0, 147];
        %         inst_params.att.ratio(8,:,12) = [14, 156.7, 156.7, 156.7, 154.0, 152.2, 154.0, 149.0, 140.59, 141.7, 147];
        %         inst_params.att.ratio(9,:,12) = [16, 156.7, 156.7, 156.7, 154.0, 152.2, 154.0, 149.0, 140.59, 141.7, 147];
        %         inst_params.att.ratio(10,:,12) = [40, 156.7, 156.7, 156.7, 154.0, 152.2, 154.0, 149.0, 140.59, 141.7, 147];
        %         inst_params.att.ratio(1,1,12) = 1; %Att number
        %
        %         %Att2 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,13) = ones(n_wavs+1,n_cols+1)*902 ;
        %         inst_params.att.ratio(2:n_wavs+1,1,13) = wavs; inst_params.att.ratio(1,2:n_cols+1,13) = cols;
        %         inst_params.att.ratio(1,1,13) = 2; %Att number
        %
        %         %Att3 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,14) = ones(n_wavs+1,n_cols+1)*2874;
        %         inst_params.att.ratio(2:n_wavs+1,1,14) = wavs; inst_params.att.ratio(1,2:n_cols+1,14) = cols;
        %         inst_params.att.ratio(1,1,14) = 3; %Att number
        %
        %         %Att4 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,15) = ones(n_wavs+1,n_cols+1)*112;
        %         inst_params.att.ratio(2:n_wavs+1,1,15) = wavs; inst_params.att.ratio(1,2:n_cols+1,15) = cols;
        %         inst_params.att.ratio(1,1,15) = 4; %Att number
        %
        %         %Att5 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,16) = ones(n_wavs+1,n_cols+1)*28;
        %         inst_params.att.ratio(2:n_wavs+1,1,16) = wavs; inst_params.att.ratio(1,2:n_cols+1,16) = cols;
        %         inst_params.att.ratio(1,1,16) = 5; %Att number
        %
        %         %Att6 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,17) = ones(n_wavs+1,n_cols+1)*7;
        %         inst_params.att.ratio(2:n_wavs+1,1,17) = wavs; inst_params.att.ratio(1,2:n_cols+1,17) = cols;
        %         inst_params.att.ratio(1,1,17) = 6; %Att number
        %
        %         %Att7 - circular diaphragm
        %         inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,18) = ones(n_wavs+1,n_cols+1)*3.1;
        %         inst_params.att.ratio(2:n_wavs+1,1,18) = wavs; inst_params.att.ratio(1,2:n_cols+1,18) = cols;
        %         inst_params.att.ratio(1,1,18) = 7; %Att number
        
        
        
        inst_params.att.type = [{'aperture'}, {'sieve'}, {'sieve'}, {'sieve'}, {'aperture'}, {'aperture'}, {'aperture'}, {'aperture'}];
        inst_params.att.size = {[40e-3,55e-3], [40e-3,55e-3], [40e-3,55e-3], [5e-3], [10e-3], [20e-3], [30e-3]}; %m rectangular or diameter
        
        %Collimation distances
        inst_params.col = [1.4 2 2.8 4 5.6 8 11.2 14.4 17.6, 19];
        
        %inter-collimation apertures (if any, otherwise open guide size)
        inst_params.col_aps{1} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{2} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{3} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{4} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{5} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{6} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{7} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{8} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{9} = {[40e-3,55e-3],[40e-3]};
        inst_params.col_aps{10} = {[40e-3,55e-3], [40e-3,55e-3], [40e-3,55e-3], [40e-3,55e-3], [5e-3], [10e-3], [20e-3], [30e-3]};
        
        %Describe Detector(s)
        inst_params.detectors = 1;
        inst_params.detector1.type = 'tube';
        inst_params.detector1.view_position = 'centre';
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        inst_params.detector1.dead_time = ones(1,128) * 2*10^-6;
        
        
        if strcmp(grasp_env.inst_option,'d22')
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [8, 8]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.dan_rotation_offset = 0.25; %m
            inst_params.detector1.imask = get_mask('ill_d22_msk.msk');
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.lead_string = [];
            inst_params.filename.extension_string = [];
            inst_params.filename.data_loader = 'raw_read_ill_sans';
            
        elseif strcmp(grasp_env.inst_option,'d22_nexus')
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [8, 8]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.dan_rotation_offset = 0.25; %m
            inst_params.detector1.imask = get_mask('ill_d22_msk.msk');
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.lead_string = [];
            inst_params.filename.extension_string = '.nxs';
            %inst_params.filename.data_loader = 'raw_read_ill_nexus';
            inst_params.filename.data_loader = 'raw_read_ill_nexus_d33';
            
            
        elseif strcmp(grasp_env.inst_option,'d22_Jan2004_to_Oct2010')
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [8, 8]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.dan_rotation_offset = 0.25; %m
            inst_params.detector1.imask = get_mask('ill_d22_msk.msk');
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.lead_string = [];
            inst_params.filename.extension_string = [];
            inst_params.filename.data_loader = 'raw_read_ill_sans';
            
        elseif strcmp(grasp_env.inst_option,'d22_Pre2004') %Old D22 detector
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [7.5, 7.5]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.dan_rotation_offset = 0.25; %m
            inst_params.detector1.imask = ones(128,128);
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.lead_string = [];
            inst_params.filename.extension_string = [];
            inst_params.filename.data_loader = 'raw_read_ill_sans';
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.dead_time = 1*10^-6;
            
        elseif strcmp(grasp_env.inst_option,'d22_rawdata');
            inst_params.detector1.pixels = [128 256]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [8, 4]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64 128];
            inst_params.detector1.imask = get_mask('ill_d22_rawdata_msk.msk');
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.lead_string = '';
            inst_params.filename.extension_string = '.raw';
            inst_params.filename.data_loader = 'raw_read_ill_sans';
            
            
        elseif strcmp(grasp_env.inst_option,'d22_BERSANS_Treated_Data')
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [8, 8]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.dan_rotation_offset = 0.25; %m
            inst_params.detector1.imask = get_mask('ill_d22_msk.msk');
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.numeric_length = 7;
            inst_params.filename.lead_string = ['D'];
            inst_params.filename.extension_string = ['.001'];
            inst_params.filename.data_loader = 'raw_read_hzb_v4';
        end
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.aq_time = 1; inst_params.vector_names{1} = {'Measurement Time'};
        inst_params.vectors.slice_time = 2; inst_params.vector_names{2} = {'Slice Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Exposure Time'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        inst_params.vectors.seltrs = 21; inst_params.vector_names{21} = {'Selector Trans'};
        inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.bath1_temp = 32; inst_params.vector_names{32} = {'Bath1 Temp'};
        inst_params.vectors.bath1_set = 33; inst_params.vector_names{33} = {'Bath1 Set'};
        inst_params.vectors.bath2_temp = 34; inst_params.vector_names{34} = {'Bath2 Temp'};
        inst_params.vectors.bath2_set = 35; inst_params.vector_names{35} = {'Bath2 Set'};
        inst_params.vectors.bath_switch = 36; inst_params.vector_names{36} = {'Bath Switch'};
        inst_params.vectors.air_temp = 37; inst_params.vector_names{37} = {'Air Temp'};
        inst_params.vectors.rack_temp = 38; inst_params.vector_names{38} = {'Rack Temp'};
        inst_params.vectors.vslit_center = 40; inst_params.vector_names{40} = {'Vertical Slit Center'};
        inst_params.vectors.vslit_width = 41; inst_params.vector_names{41} = {'Vertical Slit Width'};
        inst_params.vectors.hslit_center = 42; inst_params.vector_names{42} = {'Horizontal Slit Center'};
        inst_params.vectors.hslit_width = 43; inst_params.vector_names{43} ={'Horizontal Slit Width'};
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        inst_params.vectors.col_app = 57; inst_params.vector_names{57} = {'Col Defining Aperture #'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        %inst_params.vectors.det_angle = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.att2 = 68; inst_params.vector_names{68} = {'ChopperAttenuator2'};
        inst_params.vectors.omega = 69; inst_params.vector_names{69} = {'Omega'};
        inst_params.vectors.gsan = 70; inst_params.vector_names{70} = {'gSan'};
        inst_params.vectors.gtrs = 71; inst_params.vector_names{71} = {'gTrs'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
        inst_params.vectors.tof_channels = 85; inst_params.vector_names{85} = {'TOF # Channels'};
        inst_params.vectors.tof_delay = 86; inst_params.vector_names{86} = {'TOF Delay muS'};
        inst_params.vectors.tof_width = 87; inst_params.vector_names{87} = {'TOF Width muS'};
        inst_params.vectors.pickups = 88; inst_params.vector_names{88} = {'TOF/Kin Pickups'};
        %inst_params.vectors.tof_current_frame = 90; inst_params.vector_names{90} = {'TOF Current Frame #'};
        
        
        inst_params.vectors.chopper1_phase = 90; inst_params.vector_names{90} = {'Chopper1 Phase'};
        inst_params.vectors.chopper1_speed = 91; inst_params.vector_names{91} = {'Chopper1 Speed'};
        inst_params.vectors.chopper2_phase = 92; inst_params.vector_names{92} = {'Chopper2 Phase'};
        inst_params.vectors.chopper2_speed = 93; inst_params.vector_names{93} = {'Chopper2 Speed'};
        
        
        inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
        inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.slit = 107; inst_params.vector_names{107} = {'Slit (mm)'};
        inst_params.vectors.shear_rate = 108; inst_params.vector_names{108} = {'Shear Rate RPM'};
        
        %Currents and voltages
        inst_params.vectors.ps1_i = 110; inst_params.vector_names{110} = {'PS1 Current'};
        inst_params.vectors.ps1_v = 111; inst_params.vector_names{111} = {'PS1 Voltage'};
        inst_params.vectors.ps2_i = 112; inst_params.vector_names{112} = {'PS2 Current'};
        inst_params.vectors.ps2_v = 113; inst_params.vector_names{113} = {'PS2 Voltage'};
        inst_params.vectors.ps3_i = 114; inst_params.vector_names{114} = {'PS3 Current'};
        inst_params.vectors.ps3_v = 115; inst_params.vector_names{115} = {'PS3 Voltage'};
        inst_params.vectors.ps1_i = 116; inst_params.vector_names{116} = {'DAC1 Voltage'};
        inst_params.vectors.ps1_v = 117; inst_params.vector_names{117} = {'DAC2 Voltage'};
        inst_params.vectors.ps2_i = 118; inst_params.vector_names{118} = {'DAC3 Voltage'};
        inst_params.vectors.ps2_v = 119; inst_params.vector_names{119} = {'DAC4 Voltage'};
        inst_params.vectors.ps3_i = 120; inst_params.vector_names{120} = {'ADC1 Voltage'};
        inst_params.vectors.ps3_v = 121; inst_params.vector_names{121} = {'ADC2 Voltage'};
        inst_params.vectors.ps3_i = 122; inst_params.vector_names{122} = {'ADC3 Voltage'};
        inst_params.vectors.ps3_v = 123; inst_params.vector_names{123} = {'ADC4 Voltage'};
        
        inst_params.vectors.frame_time = 126; inst_params.vector_names{126} = {'Frame Time (s)'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        
        
        if strcmp(grasp_env.inst_option,'d22_BERSANS_Treated_Data')
            inst_params.vectors = rmfield(inst_params.vectors,'col_app');
        end
        
    case 'ILL_d11'
         %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 6;
        inst_params.filename.lead_string = [];
        
        %***** Instrument: ILL D11 *****
        inst_params.guide_size = [30e-3,50e-3];  %mm x y
        inst_params.wav_range = [1 25];
        
        inst_params.att.position = -40.5; %Position relative to sample
        inst_params.att.number = [0, 1, 2, 3];
        
        %Wavelength dependent attenuators, e.g. ratio(1,:) = [wav, att1, att2, att3 ....]
        %if more than one wavelength entry then interpolate for wavelengths inbetween
        n_cols =12; n_wavs = 3;
        cols = [1.5 2.5 4 5.5 8 10.5 13.5 16.5 20.5 28 34 40.5];
        wavs = [4; 6; 40];
        %3D matrix Att# col col col
        %          wav
        %          wav
        %          wav
        inst_params.att.ratio = [];
        
        %Att0
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1) = ones(n_wavs+1,n_cols+1);
        inst_params.att.ratio(2:n_wavs+1,1) = wavs; inst_params.att.ratio(1,2:n_cols+1) = cols;
        inst_params.att.ratio(1,1,1) = 0; %Att number
        
        %Att1
        inst_params.att.ratio(1,:,2) = [1, 1.5 2.5 4 5.5 8 10.5 13.5 16.5 20.5 28 34 40.5];
        %Old values before August 2012
        %inst_params.att.ratio(2,:,2) = [4, 280.07, 303.21, 309.82, 344.32, 316.15, 287.77, 340.45, 295.57, 295.74, 421.7, 430.66, 250.92];
        %inst_params.att.ratio(3,:,2) = [6, 280.07, 303.21, 309.82, 344.32, 316.15, 287.77, 340.45, 295.57, 295.74, 421.7, 430.66, 250.92];
        %inst_params.att.ratio(4,:,2) = [40, 280.07, 303.21, 309.82, 344.32, 316.15, 287.77, 340.45, 295.57, 295.74, 421.7, 430.66, 250.92];
        
        %New values given by Ralf, August 2012
        inst_params.att.ratio(2,:,2) = [1, 327.54, 305.27, 290.51, 298.69, 323.54, 368.04, 407.00, 370.45, 369.03, 489.09, 494.36, 277.84];
        inst_params.att.ratio(3,:,2) = [6, 327.54, 305.27, 290.51, 298.69, 323.54, 368.04, 407.00, 370.45, 369.03, 489.09, 494.36, 277.84];
        inst_params.att.ratio(4,:,2) = [40, 327.54, 305.27, 290.51, 298.69, 323.54, 368.04, 407.00, 370.45, 369.03, 489.09, 494.36, 277.84];
        
        inst_params.att.ratio(1,1,2) = 1; %Att number
        
        %Att2
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,3) = ones(n_wavs+1,n_cols+1)*918 ;
        inst_params.att.ratio(2:n_wavs+1,1,3) = wavs; inst_params.att.ratio(1,2:n_cols+1,3) = cols;
        inst_params.att.ratio(1,1,3) = 2; %Att number
        
        %Att3
        inst_params.att.ratio(1:n_wavs+1,1:n_cols+1,4) = ones(n_wavs+1,n_cols+1)*2838;
        inst_params.att.ratio(2:n_wavs+1,1,4) = wavs; inst_params.att.ratio(1,2:n_cols+1,4) = cols;
        inst_params.att.ratio(1,1,4) = 3; %Att number
        
        inst_params.att.type = [{'aperture'}, {'sieve'}, {'sieve'}, {'sieve'}];
        inst_params.att.size = {[35e-3,55e-3], [35e-3,55e-3], [35e-3,55e-3], [35e-3, 55e3]}; %m rectangular or diameter
        
        
        inst_params.col = [1.5 2.5 4 5.5 8 10.5 13.5 16.5 20.5 28 34 40.5];
        inst_params.col_aps{1} = {[36.5e-3,40e-3], [50e-3, 55e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
        inst_params.col_aps{2} = {[50e-3,80e-3]};
        inst_params.col_aps{3} = {[50e-3,80e-3]};
        inst_params.col_aps{4} = {[50e-3,80e-3]};
        inst_params.col_aps{5} = {[50e-3,80e-3], [50e-3, 55e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
        inst_params.col_aps{6} = {[50e-3,80e-3]};
        inst_params.col_aps{7} = {[50e-3,80e-3], [50e-3], [55e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
        inst_params.col_aps{8} = {[50e-3,80e-3]};
        inst_params.col_aps{9} = {[50e-3,80e-3]};
        inst_params.col_aps{10} = {[50e-3,80e-3], [50e-3, 55e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
        inst_params.col_aps{11} = {[50e-3,80e-3]};
        inst_params.col_aps{12} = {[50e-3,80e-3]};
        inst_params.col_aps{13} = {[35e-3,55e-3], [30e-3]};
        
        %Describe Detector(s)
        inst_params.detectors = 1;
        inst_params.detector1.type = 'multiwire';
        inst_params.detector1.view_position = 'centre';
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        
        
        if strcmp(grasp_env.inst_option,'d11_nexus')
            inst_params.detector1.pixels = [256 256]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [3.75, 3.75]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [128.5 128.5]; %[x y]
            inst_params.detector1.dead_time = 0*10^-7;
            %inst_params.detector1.imask = get_mask('ill_d11_msk.msk');
            inst_params.detector1.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(2));
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.extension_string = '.nxs';
            inst_params.filename.data_loader = 'raw_read_ill_nexus_d33';
        elseif strcmp(grasp_env.inst_option,'new_d11');
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [7.5, 7.5]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5];
            inst_params.detector1.dead_time = 4.2*10^-7;
            inst_params.detector1.imask = get_mask('ill_d11_msk.msk');
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.extension_string = [];
        %inst_params.filename.data_loader = 'raw_read_d22d11_old';
        inst_params.filename.data_loader = 'raw_read_ill_sans';
        else %old_d11
            inst_params.detector1.pixels = [64,64]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [10,10]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [32.5 32.5]; %[x y]
            inst_params.detector1.dead_time = 8.5*10^-7;
            inst_params.detector1.imask = get_mask('ill_d11_old_msk.msk');
            inst_params.detector1.relative_efficiency = 1;
            inst_params.filename.extension_string = [];
            inst_params.filename.data_loader = 'raw_read_d22d11_old';
        end
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        %inst_params.vectors.col_app = 57; inst_params.vector_names{57} = {'Col Defining Aperture #'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.slice_time = 2; inst_params.vector_names{2} = {'Slice Time'};
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        
        inst_params.vectors.att2 = 68; inst_params.vector_names{68} = {'ChopperAttenuator2'};
        inst_params.vectors.gsan = 70; inst_params.vector_names{70} = {'gSan'};
        inst_params.vectors.gtrs = 71; inst_params.vector_names{71} = {'gTrs'};
        
        
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        inst_params.vectors.tof_channels = 85; inst_params.vector_names{85} = {'TOF # Channels'};
        inst_params.vectors.tof_delay = 86; inst_params.vector_names{86} = {'TOF Delay muS'};
        inst_params.vectors.tof_width = 87; inst_params.vector_names{87} = {'TOF Width muS'};
        %inst_params.vectors.tof_elapsed = 88; inst_params.vector_names{88} = {'TOF Elapsed Time'};
        inst_params.vectors.tof_current_frame = 90; inst_params.vector_names{90} = {'TOF Current Frame #'};
        
        inst_params.vectors.frame_time = 126; inst_params.vector_names{126} = {'Frame Time (s)'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        
        
        
        
    case 'ILL_d33'
        if strcmp(grasp_env.inst_option,'D33_Instrument_Commissioning');
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 6;
            inst_params.filename.lead_string = [];
            inst_params.filename.extension_string = ['.nxs'];
            inst_params.filename.data_loader = 'raw_read_ill_nexus_d33_commissioning';
            
            inst_params.guide_size = [30e-3,30e-3];  %mm x y
            inst_params.wav_range = [0 38];
            
            inst_params.att.position = -13.8; %Position relative to sample
            inst_params.att.number = [0, 1, 2, 3];
            %inst_params.att.ratio = [1, 112, 447, 1790]; Nominal values
            
            %Wavelength & collimaton dependent attenuators, e.g. ratio(1,:) = [wav, att1, att2, att3 ....]
            %if more than one wavelength entry then interpolate for wavelengths inbetween
            n_cols =5; n_wavs = 4;
            cols = [2.8, 5.3, 7.8, 10.3, 12.8];
            wavs = [0; 6; 10; 40];
            
            %3D matrix Att# col col col
            %          wav
            %          wav
            %          wav
            %inst_params.att.ratio = [];
            
            %Att0
            inst_params.att.ratio(1:n_wavs+1,1:n_cols+1) = ones(n_wavs+1,n_cols+1);
            inst_params.att.ratio(2:n_wavs+1,1) = wavs; inst_params.att.ratio(1,2:n_cols+1) = cols;
            inst_params.att.ratio(1,1,1) = 0; %Att number
            
            %Att1
            inst_params.att.ratio(1,:,2) = [1, 2.8, 5.3, 7.8, 10.3, 12.8];
            inst_params.att.ratio(2,:,2) = [0, 110, 119, 118, 119, 128];
            inst_params.att.ratio(3,:,2) = [6, 110, 119, 118, 119, 128];
            %inst_params.att.ratio(4,:,2) = [10, 110, 119, 118, 119, 128];
            %inst_params.att.ratio(5,:,2) = [40, 110, 119, 118, 119, 128];
            
            inst_params.att.ratio(4,:,2) = [10, 110, 121, 127, 135, 131];
            inst_params.att.ratio(5,:,2) = [40, 110, 121, 127, 135, 131];
            inst_params.att.ratio(1,1,2) = 1; %Att number
            
            %Att2 - rectangular diaphragm
            inst_params.att.ratio(:,:,3) = inst_params.att.ratio(:,:,2) *3.89;
            inst_params.att.ratio(1,:,3) = inst_params.att.ratio(1,:,2); %Reload Cols
            inst_params.att.ratio(:,1,3) = inst_params.att.ratio(:,1,2); %Reload Wavs
            inst_params.att.ratio(1,1,3) = 2; %Att number
            
            %Att3 - rectangular diaphragm
            inst_params.att.ratio(:,:,4) = inst_params.att.ratio(:,:,3) *4.4;
            inst_params.att.ratio(1,:,4) = inst_params.att.ratio(1,:,2); %Reload Cols
            inst_params.att.ratio(:,1,4) = inst_params.att.ratio(:,1,2); %Reload Wavs
            inst_params.att.ratio(1,1,4) = 3; %Att number
            
            
            inst_params.att.type = [{'aperture'}, {'sieve'}, {'sieve'}, {'sieve'}];
            inst_params.att.size = {[30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3]}; %mm rectangular or diameter
            
            inst_params.col = [2.8, 5.3, 7.8, 10.3, 12.8];
            inst_params.col_aps{1} = {[30e-3,30e-3], [30e-3], [20e-3], [10e-3]};
            inst_params.col_aps{2} = {[30e-3,30e-3], [30e-3], [20e-3], [10e-3]};
            inst_params.col_aps{3} = {[30e-3,30e-3], [30e-3], [20e-3], [10e-3]};
            inst_params.col_aps{4} = {[30e-3,30e-3], [30e-3], [20e-3], [10e-3]};
            inst_params.col_aps{5} = {[30e-3,30e-3], [30e-3], [20e-3], [10e-3]};
            
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            %Rear
            inst_params.detector1.type = 'tube';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [256 128]; %Number of pixels, x,y
            %inst_params.detector1.pixel_size = [2.5, 5]; %mm [x y]
            inst_params.detector1.pixel_size = [2.5, 5]; %mm [x y]
            
            inst_params.detector1.nominal_beam_centre = [128.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 1.5e-6 * ones(128,1); %the direction of this matrix determines the direction of the tubes
            inst_params.detector1.imask = ones(128,256);
            inst_params.detector1.relative_efficiency = 1;
            
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.aq_time = 1; inst_params.vector_names{1} = {'Measurement Time'};
            inst_params.vectors.slice_time = 2; inst_params.vector_names{2} = {'Slice Time'};
            inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Exposure Time'};
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
            inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
            inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
            inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
            inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
            inst_params.vectors.bath1_temp = 32; inst_params.vector_names{32} = {'Bath1 Temp'};
            inst_params.vectors.bath1_set = 33; inst_params.vector_names{33} = {'Bath1 Set'};
            inst_params.vectors.bath2_temp = 34; inst_params.vector_names{34} = {'Bath2 Temp'};
            inst_params.vectors.bath2_set = 35; inst_params.vector_names{35} = {'Bath2 Set'};
            inst_params.vectors.bath_switch = 36; inst_params.vector_names{36} = {'Bath Switch'};
            inst_params.vectors.air_temp = 37; inst_params.vector_names{37} = {'Air Temp'};
            inst_params.vectors.rack_temp = 38; inst_params.vector_names{38} = {'Rack Temp'};
            inst_params.vectors.potr = 40; inst_params.vector_names{40} = {'PoTr'};
            inst_params.vectors.wvtr = 41; inst_params.vector_names{41} = {'WvTr'};
            inst_params.vectors.attr = 42; inst_params.vector_names{42} = {'AtTr'};
            inst_params.vectors.dia1 = 43; inst_params.vector_names{43} = {'Dia1'};
            inst_params.vectors.col1 = 44; inst_params.vector_names{44} = {'Col1'};
            inst_params.vectors.dia2 = 45; inst_params.vector_names{45} = {'Dia2'};
            inst_params.vectors.col2 = 46; inst_params.vector_names{46} = {'Col2'};
            inst_params.vectors.dia3 = 47; inst_params.vector_names{47} = {'Dia3'};
            inst_params.vectors.col3 = 48; inst_params.vector_names{48} = {'Col3'};
            inst_params.vectors.dia4 = 49; inst_params.vector_names{49} = {'Dia4'};
            inst_params.vectors.col4 = 50; inst_params.vector_names{50} = {'Col4'};
            inst_params.vectors.dia5 = 51; inst_params.vector_names{51} = {'Dia5'};
            
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            inst_params.vectors.col_app = 57; inst_params.vector_names{57} = {'Col Defining Aperture #'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
            inst_params.vectors.sdi2 = 63; inst_params.vector_names{63} = {'Sdi2'};
            inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
            inst_params.vectors.sdi1 = 64; inst_params.vector_names{64} = {'Sdi'};
            inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
            inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
            inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
            %inst_params.vectors.att2 = 68; inst_params.vector_names{68} = {'ChopperAttenuator2'};
            inst_params.vectors.omega = 69; inst_params.vector_names{69} = {'Omega'};
            inst_params.vectors.gsan = 70; inst_params.vector_names{70} = {'gSan'};
            inst_params.vectors.gtrs = 71; inst_params.vector_names{71} = {'gTrs'};
            
            
            inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
            inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
            inst_params.vectors.tof_channels = 85; inst_params.vector_names{85} = {'TOF # Channels'};
            inst_params.vectors.tof_delay = 86; inst_params.vector_names{86} = {'TOF Delay muS'};
            inst_params.vectors.tof_width = 87; inst_params.vector_names{87} = {'TOF Width muS'};
            inst_params.vectors.pickups = 88; inst_params.vector_names{88} = {'TOF/Kin Pickups'};
            inst_params.vectors.chopper1_phase = 90; inst_params.vector_names{90} = {'Chopper1 Phase'};
            inst_params.vectors.chopper1_speed = 91; inst_params.vector_names{91} = {'Chopper1 Speed'};
            inst_params.vectors.chopper2_phase = 92; inst_params.vector_names{92} = {'Chopper2 Phase'};
            inst_params.vectors.chopper2_speed = 93; inst_params.vector_names{93} = {'Chopper2 Speed'};
            inst_params.vectors.chopper3_phase = 94; inst_params.vector_names{94} = {'Chopper3 Phase'};
            inst_params.vectors.chopper3_speed = 95; inst_params.vector_names{95} = {'Chopper3 Speed'};
            inst_params.vectors.chopper4_phase = 96; inst_params.vector_names{96} = {'Chopper4 Phase'};
            inst_params.vectors.chopper4_speed = 97; inst_params.vector_names{97} = {'Chopper4 Speed'};
            
            
            
            %inst_params.vectors.tof_current_frame = 90; inst_params.vector_names{90} = {'TOF Current Frame #'};
            inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
            inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
            inst_params.vectors.slit = 107; inst_params.vector_names{107} = {'Slit (mm)'};
            inst_params.vectors.shear_rate = 108; inst_params.vector_names{108} = {'Shear Rate RPM'};
            inst_params.vectors.frame_time = 126; inst_params.vector_names{126} = {'Frame Time (s)'};
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            
            
            % inst_params.vectors.is_tof = 52; inst_params.vector_names{52} = {'Is Tof Flag'};
            % inst_params.vectors.det_pannel = 18; inst_params.vector_names(18) = {'Detector Pannel Distance'};
            % inst_params.vectors.ox = 21; inst_params.vector_names{21} = {'Det Pannel Ox'};
            % inst_params.vectors.oy = 22; inst_params.vector_names{22} = {'Det Pannel Oy'};
            
        elseif strcmp(grasp_env.inst_option,'D33');
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 6;
            inst_params.filename.lead_string = [];
            inst_params.filename.extension_string = ['.nxs'];
            inst_params.filename.data_loader = 'raw_read_ill_nexus_d33';
            
            inst_params.guide_size = [30e-3,30e-3];  %mm x y
            inst_params.wav_range = [0 38];
            
            inst_params.att.position = -13.8; %Position relative to sample
            inst_params.att.number = [0, 1, 2, 3];
            %inst_params.att.ratio = [1, 112, 447, 1790]; Nominal values
            
            %Wavelength & collimaton dependent attenuators, e.g. ratio(1,:) = [wav, att1, att2, att3 ....]
            %if more than one wavelength entry then interpolate for wavelengths inbetween
            n_cols =5; n_wavs = 4;
            cols = [2.8, 5.3, 7.8, 10.3, 12.8];
            wavs = [0; 6; 10; 40];
            
            %3D matrix Att# col col col
            %          wav
            %          wav
            %          wav
            %inst_params.att.ratio = [];
            
            %Att0
            inst_params.att.ratio(1:n_wavs+1,1:n_cols+1) = ones(n_wavs+1,n_cols+1);
            inst_params.att.ratio(2:n_wavs+1,1) = wavs; inst_params.att.ratio(1,2:n_cols+1) = cols;
            inst_params.att.ratio(1,1,1) = 0; %Att number
            
            %Att1
            inst_params.att.ratio(1,:,2) = [1, 2.8, 5.3, 7.8, 10.3, 12.8];
            inst_params.att.ratio(2,:,2) = [0, 110, 119, 118, 119, 128];
            inst_params.att.ratio(3,:,2) = [6, 110, 119, 118, 119, 128];
            %inst_params.att.ratio(4,:,2) = [10, 110, 119, 118, 119, 128];
            %inst_params.att.ratio(5,:,2) = [40, 110, 119, 118, 119, 128];
            
            inst_params.att.ratio(4,:,2) = [10, 110, 121, 127, 135, 131];
            inst_params.att.ratio(5,:,2) = [40, 110, 121, 127, 135, 131];
            inst_params.att.ratio(1,1,2) = 1; %Att number
            
            %Att2 - rectangular diaphragm
            inst_params.att.ratio(:,:,3) = inst_params.att.ratio(:,:,2) *3.89;
            inst_params.att.ratio(1,:,3) = inst_params.att.ratio(1,:,2); %Reload Cols
            inst_params.att.ratio(:,1,3) = inst_params.att.ratio(:,1,2); %Reload Wavs
            inst_params.att.ratio(1,1,3) = 2; %Att number
            
            %Att3 - rectangular diaphragm
            inst_params.att.ratio(:,:,4) = inst_params.att.ratio(:,:,3) *4.4;
            inst_params.att.ratio(1,:,4) = inst_params.att.ratio(1,:,2); %Reload Cols
            inst_params.att.ratio(:,1,4) = inst_params.att.ratio(:,1,2); %Reload Wavs
            inst_params.att.ratio(1,1,4) = 3; %Att number
            
            inst_params.att.type = [{'aperture'}, {'sieve'}, {'sieve'}, {'sieve'}];
            inst_params.att.size = {[30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3]}; %mm rectangular or diameter
            
            inst_params.col = [2.8, 5.3, 7.8, 10.3, 12.8];
            inst_params.col_aps{1} = {[30e-3,30e-3], [30e-3,30e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
            inst_params.col_aps{2} = {[30e-3,30e-3], [30e-3,30e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
            inst_params.col_aps{3} = {[30e-3,30e-3], [30e-3,30e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
            inst_params.col_aps{4} = {[30e-3,30e-3], [30e-3,30e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
            inst_params.col_aps{5} = {[30e-3,30e-3], [30e-3,30e-3], [30e-3], [20e-3], [10e-3], [5e-3]};
            
            
            %Describe Detector(s)
            inst_params.detectors = 5;
            %Rear
            inst_params.detector1.type = 'tube';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [256 128]; %Number of pixels, x,y
            %inst_params.detector1.pixel_size = [2.5, 5]; %mm [x y]
            inst_params.detector1.pixel_size = [2.5, 5]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [128.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 1.5e-6 * ones(128,1); %the direction of this matrix determines the direction of the tubes
            inst_params.detector1.imask = ones(128,256);
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            %Front-Left
            inst_params.detector3.type = 'tube';
            inst_params.detector3.view_position = 'left';
            inst_params.detector3.pixels = [32,256]; %Number of pixels, x,y
            inst_params.detector3.pixel_size = [5,2.5]; %mm [x y]
            inst_params.detector3.nominal_beam_centre = [16.5,128.5]; %[x y]
            inst_params.detector3.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector3.dead_time = 1.5e-6 * ones(1,32);
            inst_params.detector3.imask = get_mask('d33_det3_msk.msk',3);
            %inst_params.detector3.relative_efficiency = 1.03;   %Up to Aug2013 Efficiency relative to rear detector (detector 1)
            %inst_params.detector3.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            inst_params.detector3.relative_efficiency = 1;  %from July2014
            %Front-Right
            inst_params.detector2.type = 'tube';
            inst_params.detector2.view_position = 'right';
            inst_params.detector2.pixels = [32,256]; %Number of pixels, x,y
            inst_params.detector2.pixel_size = [5,2.5]; %mm [x y]
            inst_params.detector2.nominal_beam_centre = [16.5, 128.5]; %[x y]
            inst_params.detector2.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector2.dead_time = 1.5e-6 * ones(1,32);
            inst_params.detector2.imask = get_mask('d33_det2_msk.msk',2);
            %inst_params.detector2.relative_efficiency = 1.03;   % Up to Aug2013 Efficiency relative to rear detector (detector 1)
            %inst_params.detector2.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            inst_params.detector2.relative_efficiency = 1; %from July2014
            %Front-Top
            inst_params.detector5.type = 'tube';
            inst_params.detector5.view_position = 'top';
            inst_params.detector5.pixels = [256,32]; %Number of pixels, x,y
            inst_params.detector5.pixel_size = [2.5,5]; %mm [x y]
            inst_params.detector5.nominal_beam_centre = [128.5, 16.5]; %[x y]
            inst_params.detector5.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector5.dead_time = 1.5e-6 * ones(32,1);
            inst_params.detector5.imask = ones(32,256);
            %inst_params.detector5.relative_efficiency = 1.02;   % Up to Aug2013 Efficiency relative to rear detector (detector 1)
            inst_params.detector5.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            %Front-Bottom
            inst_params.detector4.type = 'tube';
            inst_params.detector4.view_position = 'bottom';
            inst_params.detector4.pixels = [256,32]; %Number of pixels, x,y
            inst_params.detector4.pixel_size = [2.5,5]; %mm [x y]
            inst_params.detector4.nominal_beam_centre = [128.5 16.5]; %[x y]
            inst_params.detector4.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector4.dead_time = 1.5e-6 * ones(32,1);
            inst_params.detector4.imask = ones(32,256);
            %inst_params.detector4.relative_efficiency = 1.015;   % Up to Aug2013 Efficiency relative to rear detector (detector 1)
            inst_params.detector4.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.aq_time = 1; inst_params.vector_names{1} = {'Measurement Time'};
            inst_params.vectors.slice_time = 2; inst_params.vector_names{2} = {'Slice Time'};
            inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Exposure Time'};
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
            
            inst_params.vectors.det1 = 9; inst_params.vector_names{9} = {'Detector1 Distance'};
            inst_params.vectors.detcalc1 = 10; inst_params.vector_names{10} = {'Det1_Calc'};
            inst_params.vectors.det1_panel_offset = 11; inst_params.vector_names{11} = {'Detector1 Panel Offset'};
            inst_params.vectors.oxl = 12; inst_params.vector_names{12} = {'DetPannel Opening OxL'};
            inst_params.vectors.oxr = 13; inst_params.vector_names{13} = {'DetPannel Opening OxR'};
            inst_params.vectors.oyt = 14; inst_params.vector_names{14} = {'DetPannel Opening OyT'};
            inst_params.vectors.oyb = 15; inst_params.vector_names{15} = {'DetPannel Opening OyB'};
            
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.det2 = 19; inst_params.vector_names{19} = {'Detector2 Distance'};
            
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
            inst_params.vectors.seltrs = 21; inst_params.vector_names{21} = {'Selector Trans'};
            
            inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
            inst_params.vectors.detcalc2 = 26; inst_params.vector_names{26} = {'Det2_Calc'};
            
            inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
            inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
            inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
            inst_params.vectors.bath1_temp = 32; inst_params.vector_names{32} = {'Bath1 Temp'};
            inst_params.vectors.bath1_set = 33; inst_params.vector_names{33} = {'Bath1 Set'};
            inst_params.vectors.bath2_temp = 34; inst_params.vector_names{34} = {'Bath2 Temp'};
            inst_params.vectors.bath2_set = 35; inst_params.vector_names{35} = {'Bath2 Set'};
            inst_params.vectors.bath_switch = 36; inst_params.vector_names{36} = {'Bath Switch'};
            inst_params.vectors.air_temp = 37; inst_params.vector_names{37} = {'Air Temp'};
            inst_params.vectors.rack_temp = 38; inst_params.vector_names{38} = {'Rack Temp'};
            
            inst_params.vectors.wvtr = 41; inst_params.vector_names{41} = {'WvTr'};
            inst_params.vectors.attr = 42; inst_params.vector_names{42} = {'AtTr'};
            inst_params.vectors.dia1 = 43; inst_params.vector_names{43} = {'Dia1'};
            inst_params.vectors.col1 = 44; inst_params.vector_names{44} = {'Col1'};
            inst_params.vectors.dia2 = 45; inst_params.vector_names{45} = {'Dia2'};
            inst_params.vectors.col2 = 46; inst_params.vector_names{46} = {'Col2'};
            inst_params.vectors.dia3 = 47; inst_params.vector_names{47} = {'Dia3'};
            inst_params.vectors.col3 = 48; inst_params.vector_names{48} = {'Col3'};
            inst_params.vectors.dia4 = 49; inst_params.vector_names{49} = {'Dia4'};
            inst_params.vectors.col4 = 50; inst_params.vector_names{50} = {'Col4'};
            inst_params.vectors.dia5 = 51; inst_params.vector_names{51} = {'Dia5'};
            
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            %inst_params.vectors.col_app = 57; inst_params.vector_names{57} = {'Col Defining Aperture #'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
            inst_params.vectors.source_ap_x = 61; inst_params.vector_names{61} = {'Source Aperture X dimension'};
            inst_params.vectors.source_ap_y = 62; inst_params.vector_names{62} = {'Source Aperture Y dimension'};
            inst_params.vectors.sdi2 = 63; inst_params.vector_names{63} = {'Sdi2'};
            inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
            inst_params.vectors.sdi1 = 64; inst_params.vector_names{64} = {'Sdi'};
            inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
            inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
            inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
            inst_params.vectors.att2 = 68; inst_params.vector_names{68} = {'ChopperAttenuator2'};
            inst_params.vectors.omega = 69; inst_params.vector_names{69} = {'Omega'};
            
            inst_params.vectors.potr = 73; inst_params.vector_names{73} = {'PoTr'};
            inst_params.vectors.flipper_rfcurrent = 74; inst_params.vector_names{74} = {'Flipper RF Current'};
            inst_params.vectors.flipper_rfvoltage = 75; inst_params.vector_names{75} = {'Flipper RF Voltage'};
            inst_params.vectors.flipper_fieldvoltage = 76; inst_params.vector_names{76} = {'Flipper Field Current'};
            inst_params.vectors.flipper_fieldvoltage = 77; inst_params.vector_names{77} = {'Flipper Field Voltage'};
            
            
            inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
            inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
            inst_params.vectors.tof_channels = 85; inst_params.vector_names{85} = {'TOF # Channels'};
            inst_params.vectors.tof_delay = 86; inst_params.vector_names{86} = {'TOF Delay muS'};
            inst_params.vectors.tof_width = 87; inst_params.vector_names{87} = {'TOF Width muS'};
            inst_params.vectors.pickups = 88; inst_params.vector_names{88} = {'TOF/Kin Pickups'};
            inst_params.vectors.chopper1_phase = 90; inst_params.vector_names{90} = {'Chopper1 Phase'};
            inst_params.vectors.chopper1_speed = 91; inst_params.vector_names{91} = {'Chopper1 Speed'};
            inst_params.vectors.chopper2_phase = 92; inst_params.vector_names{92} = {'Chopper2 Phase'};
            inst_params.vectors.chopper2_speed = 93; inst_params.vector_names{93} = {'Chopper2 Speed'};
            inst_params.vectors.chopper3_phase = 94; inst_params.vector_names{94} = {'Chopper3 Phase'};
            inst_params.vectors.chopper3_speed = 95; inst_params.vector_names{95} = {'Chopper3 Speed'};
            inst_params.vectors.chopper4_phase = 96; inst_params.vector_names{96} = {'Chopper4 Phase'};
            inst_params.vectors.chopper4_speed = 97; inst_params.vector_names{97} = {'Chopper4 Speed'};
            
            
            
            
            
            %inst_params.vectors.tof_current_frame = 90; inst_params.vector_names{90} = {'TOF Current Frame #'};
            inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
            inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
            inst_params.vectors.slit = 107; inst_params.vector_names{107} = {'Slit (mm)'};
            inst_params.vectors.shear_rate = 108; inst_params.vector_names{108} = {'Shear Rate RPM'};
            
            %Currents and voltages
            inst_params.vectors.ps1_i = 110; inst_params.vector_names{110} = {'PS1 Current'};
            inst_params.vectors.ps1_v = 111; inst_params.vector_names{111} = {'PS1 Voltage'};
            inst_params.vectors.ps2_i = 112; inst_params.vector_names{112} = {'PS2 Current'};
            inst_params.vectors.ps2_v = 113; inst_params.vector_names{113} = {'PS2 Voltage'};
            inst_params.vectors.ps3_i = 114; inst_params.vector_names{114} = {'PS3 Current'};
            inst_params.vectors.ps3_v = 115; inst_params.vector_names{115} = {'PS3 Voltage'};
            inst_params.vectors.ps1_i = 116; inst_params.vector_names{116} = {'DAC1 Voltage'};
            inst_params.vectors.ps1_v = 117; inst_params.vector_names{117} = {'DAC2 Voltage'};
            inst_params.vectors.ps2_i = 118; inst_params.vector_names{118} = {'DAC3 Voltage'};
            inst_params.vectors.ps2_v = 119; inst_params.vector_names{119} = {'DAC4 Voltage'};
            inst_params.vectors.ps3_i = 120; inst_params.vector_names{120} = {'ADC1 Voltage'};
            inst_params.vectors.ps3_v = 121; inst_params.vector_names{121} = {'ADC2 Voltage'};
            inst_params.vectors.ps3_i = 122; inst_params.vector_names{122} = {'ADC3 Voltage'};
            inst_params.vectors.ps3_v = 123; inst_params.vector_names{123} = {'ADC4 Voltage'};
            
            inst_params.vectors.frame_time = 126; inst_params.vector_names{126} = {'Frame Time (s)'};
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            
            
            % inst_params.vectors.is_tof = 52; inst_params.vector_names{52} = {'Is Tof Flag'};
        end
        
        
    case 'SINQ_PSI'
        if strcmp(grasp_env.inst_option,'SINQ_sans_I');
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 7;
            inst_params.filename.lead_string = 'D';
            inst_params.filename.extension_string = '.001';
            inst_params.filename.data_loader = 'raw_read_sinq_sans1';
            
            inst_params.guide_size = [50e-3,50e-3];  %mm x y
            inst_params.wav_range = [4.5 38];
            
            inst_params.att.position = -18; %Position relative to sample
            inst_params.att.number = [0, 1, 2, 3, 4, 5];
            inst_params.att.ratio = [1, 485, 88, 8, 3.5, 6.25];
            inst_params.att.type = [{'aperture'}, {'sieve'}, {'sieve'}, {'aperture'}, {'aperture'}, {'aperture'}];
            inst_params.att.size = {[50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [20e-3], [30e-3], [20e-3,40e-3]}; %mm rectangular or diameter
            %         att_describe.number = [41, 9, 1, 1, 1]; %Number of holes for a sieve or aperture
            
            
            inst_params.col = [2, 3, 4.5, 6, 8, 11, 15, 18];
            inst_params.col_aps{1} = {[48e-3,48e-3]};
            inst_params.col_aps{2} = {[48e-3,48e-3]};
            inst_params.col_aps{3} = {[48e-3,48e-3]};
            inst_params.col_aps{4} = {[48e-3,48e-3]};
            inst_params.col_aps{5} = {[48e-3,48e-3]};
            inst_params.col_aps{6} = {[48e-3,48e-3]};
            inst_params.col_aps{7} = {[48e-3,48e-3]};
            inst_params.col_aps{8} = {[48e-3,48e-3]};
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [7.5, 7.5]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 0.6*10^-6;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = get_mask('sinq_sans_i_msk.msk');
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.lambda = 53; %same as wav
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.sd = 19; %same as det
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.attenuator = 59; %same as att_type
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            inst_params.vectors.collimation = 58; %same as col
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.beamstopy = 16; %same as by
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            inst_params.vectors.beamstopx = 17; %same as bx
            inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
            inst_params.vectors.temperature = 31; %same as temp
            inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
            inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
            inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
            inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
            inst_params.vectors.omega = 65; %same as san
            inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
            inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
            inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
            inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            inst_params.vectors.sum = 127; %same as array_counts
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.moni1 = 5;
            inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
            inst_params.vectors.moni2 = 6;
            inst_params.vectors.monitor3 = 7; inst_params.vector_names{7} = {'Monitor3'};
            inst_params.vectors.moni3 = 7;
            inst_params.vectors.monitor4 = 8; inst_params.vector_names{8} = {'Monitor4'};
            inst_params.vectors.moni4 = 8;
            
            inst_params.vectors.det_angle = 61; inst_params.vector_names{61} = {'Dan'};
            inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
            inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
            inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
            inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
            inst_params.vectors.sdchi = 61; %same as DAN
            inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
            inst_params.vectors.sy = 62; %same as DTR
            inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
            inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
            
            
            
        elseif strcmp(grasp_env.inst_option,'SINQ_sans_II');
            
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 7;
            inst_params.filename.lead_string = 'D';
            inst_params.filename.extension_string = '.001';
            inst_params.filename.data_loader = 'raw_read_sinq_sans1';
            
            inst_params.guide_size = [20e-3,30e-3];  %mm x y
            inst_params.wav_range = [4.5 20];
            
            inst_params.att.position = -6; %Position relative to sample
            inst_params.att.number = [0, 1, 2, 3, 4];
            inst_params.att.ratio = [1, 5, 25, 125, 625];
            inst_params.att.type = [{'aperture'}, {'sieve'}, {'sieve'}, {'sieve'}, {'sieve'}];
            inst_params.att.size = {[20e-3,30e-3], [20e-3,30e-3], [20e-3,30e-3], [20e-3,30e-3], [20e-3,30e-3]}; %mm rectangular or diameter
            
            inst_params.col = [1, 2, 3, 4, 5, 6];
            inst_params.col_aps{1} = {[16e-3]};
            inst_params.col_aps{2} = {[16e-3]};
            inst_params.col_aps{3} = {[16e-3]};
            inst_params.col_aps{4} = {[16e-3]};
            inst_params.col_aps{5} = {[16e-3]};
            inst_params.col_aps{6} = {[16e-3]};
            inst_params.col_aps{7} = {[16e-3], [8e-3], [1.7e-3]};
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [4.3, 4.3]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 4.5*10^-5;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = get_mask('sinq_sans_ii_msk.msk');
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.lambda = 53; %same as wav
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.sd = 19; %same as det
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.attenuator = 59; %same as att_type
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            inst_params.vectors.collimation = 58; %same as col
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.beamstopy = 16; %same as by
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            inst_params.vectors.beamstopx = 17; %same as bx
            inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
            inst_params.vectors.temperature = 31; %same as temp
            inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
            inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
            inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
            inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
            inst_params.vectors.omega = 65; %same as san
            inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
            inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
            inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
            inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            inst_params.vectors.sum = 127; %same as array_counts
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.moni1 = 5;
            inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
            inst_params.vectors.moni2 = 6;
            inst_params.vectors.monitor3 = 7; inst_params.vector_names{7} = {'Monitor3'};
            inst_params.vectors.moni3 = 7;
            inst_params.vectors.monitor4 = 8; inst_params.vector_names{8} = {'Monitor4'};
            inst_params.vectors.moni4 = 8;
            
            inst_params.vectors.det_angle = 61; inst_params.vector_names{61} = {'Dan'};
            inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
            inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
            inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
            inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
            inst_params.vectors.sdchi = 61; %same as DAN
            inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
            inst_params.vectors.sy = 62; %same as DTR
            inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
            inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        end
        
        
    case 'NIST_NCNR'
        
        if strcmp(grasp_env.inst_option,'NIST_ng3');
            
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 3;
            inst_params.filename.lead_string = 'xxxxx';
            inst_params.filename.extension_string = '.GSP';
            inst_params.filename.data_loader = 'raw_read_nist_sans';
            
            inst_params.guide_size = [60e-3,60e-3];  %mm x y
            inst_params.wav_range = [5 20];
            
            inst_params.att.position = -16.5; %Position relative to sample
            inst_params.att.number = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
            inst_params.att.ratio(1,:) = [0  1 0.444784  0.207506  0.092412  0.0417722  0.0187129   0.00851048  0.00170757  0.000320057 6.27682e-05 1.40323e-05];
            inst_params.att.ratio(2,:) = [4  1 0.444784  0.207506  0.092412  0.0417722  0.0187129   0.00851048  0.00170757  0.000320057 6.27682e-05 1.40323e-05];
            inst_params.att.ratio(3,:) = [5  1 0.419     0.1848    0.07746   0.03302    0.01397     0.005984    0.001084    0.0001918   3.69e-05    8.51e-06];
            inst_params.att.ratio(4,:) = [6  1 0.3935    0.1629    0.06422   0.02567    0.01017     0.004104    0.0006469   0.0001025   1.908e-05   5.161e-0];
            inst_params.att.ratio(5,:) = [7  1 0.3682    0.1447    0.05379   0.02036    0.007591    0.002888    0.0004142   6.085e-05   1.196e-05   4.4e-06];
            inst_params.att.ratio(6,:) = [8  1 0.3492    0.1292    0.04512   0.01604    0.005668    0.002029    0.0002607   3.681e-05   8.738e-06   4.273e-06];
            inst_params.att.ratio(7,:) = [10 1 0.3132    0.1056    0.03321   0.01067    0.003377    0.001098    0.0001201   1.835e-05   6.996e-06   1.88799e-07];
            inst_params.att.ratio(8,:) = [12 1 0.2936    0.09263   0.02707   0.00812    0.002423    0.0007419   7.664e-05   6.74002e-06 6.2901e-07  5.87021e-08];
            inst_params.att.ratio(9,:) = [14 1 0.2767    0.08171   0.02237   0.006316   0.001771    0.0005141   4.06624e-05 3.25288e-06 2.60221e-07 2.08169e-08];
            inst_params.att.ratio(10,:) = [17 1 0.2477    0.06656   0.01643   0.00419    0.001064    0.000272833 1.77379e-05 1.15321e-06 7.49748e-08 4.8744e-09];
            inst_params.att.ratio(11,:) = [20 1 0.22404   0.0546552 0.0121969 0.00282411 0.000651257 0.000150624 7.30624e-06 3.98173e-07 2.08029e-08 1.08687e-09];
            
            %Grasp would like the reciprocal of these attenuation factors - turn upside down
            inst_params.att.ratio(:,2:size(inst_params.att.ratio,2)) = 1 ./ inst_params.att.ratio(:,2:size(inst_params.att.ratio,2));
            
            
            
            inst_params.att.type = [{'aperture'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}];
            inst_params.att.size = {[], [], [], [], [], [], []}; %mm rectangular or diameter
            
            inst_params.col = [3.87, 5.42, 6.97, 8.52, 10.07, 11.62, 13.17, 14.72, 16.27];
            inst_params.col_aps{1} = {[50.8e-3]};
            inst_params.col_aps{2} = {[50.8e-3]};
            inst_params.col_aps{3} = {[50.8e-3]};
            inst_params.col_aps{4} = {[50.8e-3]};
            inst_params.col_aps{5} = {[50.8e-3]};
            inst_params.col_aps{6} = {[50.8e-3]};
            inst_params.col_aps{7} = {[50.8e-3]};
            inst_params.col_aps{8} = {[14.3e-3], [25.4e-3], [38.1e-3]};
            
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5.08, 5.08]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 1.5e-6;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = get_mask('nist_ng3_msk.msk');
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            inst_params.vectors.source_ap = 57; inst_params.vector_names{57} = {'Source Aperture Size'};
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
            inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
            inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
            inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
            inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
            inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
            inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
            inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
            inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
            inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
            inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
            inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
            inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
            inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
            inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
            inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
            inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
            
            inst_params.vectors.frame_time = 126; inst_params.vector_names{126} = {'Frame Time (s)'};
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            
            
            
        elseif strcmp(grasp_env.inst_option,'NIST_ng7');
            
            
            %***** File name handleing parameters *****
            inst_params.filename.numeric_length = 3;
            inst_params.filename.lead_string = 'xxxxx';
            inst_params.filename.extension_string = '.GSP';
            inst_params.filename.data_loader = 'raw_read_nist_sans';
            
            inst_params.guide_size = [50e-3,50e-3];  %mm x y
            inst_params.wav_range = [5 20];
            
            inst_params.att.position = -18.8; %Position relative to sample
            inst_params.att.number = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
            
            inst_params.att.ratio(1,:) = [0  1  0.448656 0.217193  0.098019  0.0426904  0.0194353  0.00971666  0.00207332  0.000397173 9.43625e-05 2.1607e-05];
            inst_params.att.ratio(2,:) = [4  1  0.448656 0.217193  0.098019  0.0426904  0.0194353  0.00971666  0.00207332  0.000397173 9.43625e-05 2.1607e-05];
            inst_params.att.ratio(3,:) = [5  1  0.4192   0.1898    0.07877   0.03302    0.01398    0.005979    0.001054    0.0001911   3.557e-05   7.521e-06];
            inst_params.att.ratio(4,:) = [6  1  0.3925   0.1682    0.06611   0.02617    0.01037    0.004136    0.0006462   0.0001044   1.833e-05   2.91221e-06];
            inst_params.att.ratio(5,:) = [7  1  0.3661   0.148     0.05429   0.02026    0.0075496  0.002848    0.0003957   5.844e-05   1.014e-05   1.45252e-06];
            inst_params.att.ratio(6,:) = [8  1  0.3458   0.1321    0.04548   0.0158     0.005542   0.001946    0.0002368   3.236e-05   6.153e-06   7.93451e-07];
            inst_params.att.ratio(7,:) = [10 1  0.3098   0.1076    0.03318   0.01052    0.003339   0.001079    0.0001111   1.471e-05   1.64816e-06 1.92309e-07];
            inst_params.att.ratio(8,:) = [12 1  0.2922   0.0957    0.02798   0.008327   0.002505   0.0007717   7.642e-05   6.88523e-06 6.42353e-07 5.99279e-08];
            inst_params.att.ratio(9,:) = [14 1  0.2738   0.08485   0.0234    0.006665   0.001936   0.000588    4.83076e-05 4.06541e-06 3.42132e-07 2.87928e-08];
            inst_params.att.ratio(10,:) = [17 1 0.2544   0.07479   0.02004   0.005745   0.001765   0.000487337 3.99401e-05 3.27333e-06 2.68269e-07 2.19862e-08];
            inst_params.att.ratio(11,:) = [20 1 0.251352 0.0735965 0.0202492 0.00524807 0.00165959 0.000447713 3.54814e-05 2.81838e-06 2.2182e-07  1.7559e-08];
            
            %Grasp would like the reciprocal of these attenuation factors - turn upside down
            inst_params.att.ratio(:,2:size(inst_params.att.ratio,2)) = 1 ./ inst_params.att.ratio(:,2:size(inst_params.att.ratio,2));
            
            inst_params.att.type = [{'aperture'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}];
            inst_params.att.size = {[], [], [], [], [], [], []}; %mm rectangular or diameter
            
            inst_params.col = [3.87, 5.42, 6.97, 8.52, 10.07, 11.62, 13.17, 14.72, 16.27];
            inst_params.col_aps{1} = {[50.8e-3]};
            inst_params.col_aps{2} = {[50.8e-3]};
            inst_params.col_aps{3} = {[50.8e-3]};
            inst_params.col_aps{4} = {[50.8e-3]};
            inst_params.col_aps{5} = {[50.8e-3]};
            inst_params.col_aps{6} = {[50.8e-3]};
            inst_params.col_aps{7} = {[50.8e-3]};
            inst_params.col_aps{8} = {[14.3e-3], [25.4e-3], [38.1e-3]};
            
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5.08, 5.08]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 2.3e-6;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = get_mask('nist_ng7_msk.msk');
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %Parameter position vectors
            inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
            
            inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
            inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
            inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
            inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
            inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
            inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
            inst_params.vectors.source_ap = 57; inst_params.vector_names{57} = {'Source Aperture Size'};
            inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
            inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
            inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
            inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
            inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
            inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
            inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
            inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
            inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
            inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
            inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
            inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
            inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
            inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
            inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
            inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
            inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
            inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
            inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
            inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
            inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
            inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
            inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
            
            inst_params.vectors.frame_time = 126; inst_params.vector_names{126} = {'Frame Time (s)'};
            inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
            
        end
        
        
        
    case 'ORNL_cg2'
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 4;
        inst_params.filename.lead_string = 'xxxxxxxxx';
        inst_params.filename.extension_string = 'xml';
        inst_params.filename.data_loader = 'raw_read_ornl_sans';
        
        inst_params.guide_size = [40e-3,40e-3];  %mm x y
        inst_params.wav_range = [4.2 19];
        
        inst_params.att.position = -18.8; %Position relative to sample
        inst_params.att.number = [0, 1, 2, 3, 4, 5, 6];
        %inst_params.att.ratio = [1, 3.605, 43.85, 553.544, 3456, 22973.37, 69043];   %Are these CG2?
        inst_params.att.ratio = [1, 1, 1, 1, 1, 1];
        
        inst_params.att.type = [{'aperture'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}];
        inst_params.att.size = {[40,40], [40,40], [40,40], [40,40], [40,40], [40,40], [40,40]}; %mm rectangular or diameter
        
        inst_params.col = [];
        
        %Describe Detector(s)
        if strcmp(grasp_env.inst_option,'old_detector192y')
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [192, 192]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5.15, 5.15]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [96.5 96.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 6*10^-6;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = get_mask('ornl_cg2_msk.msk');
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        elseif strcmp(grasp_env.inst_option,'new_detector256y')
            inst_params.detectors = 1;
            inst_params.detector1.type = 'tube';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [192, 256]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5.5, 3.94]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [96.5 128.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 6*10^-6;
            inst_params.detector1.dan_rotation_offset = 0; %m
            %inst_params.detector1.imask = get_mask('ornl_cg2_msk.msk'); % EB 06/08/2011
            inst_params.detector1.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(1));
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        end
        
        
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        inst_params.vectors.source_ap = 57; inst_params.vector_names{57} = {'Source Aperture Size'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.zarc = 102;
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        
        
        
    case 'ORNL_cg3'
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 4;
        inst_params.filename.lead_string = 'xxxxxxxxx';
        inst_params.filename.extension_string = 'xml';
        inst_params.filename.data_loader = 'raw_read_ornl_sans';
        
        inst_params.guide_size = [40e-3,40e-3];  %mm x y
        inst_params.wav_range = [4.2 19];
        
        inst_params.att.position = -18.8; %Position relative to sample
        inst_params.att.number = [0, 1, 2, 3, 4, 5, 6];
        %inst_params.att.ratio = [1, 3.605, 43.85, 553.544, 3456, 22973.37, 69043];   %Are these CG2?
        inst_params.att.ratio = [1, 2000, 1, 1, 1, 1];
        
        inst_params.att.type = [{'aperture'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}];
        inst_params.att.size = {[40,40], [40,40], [40,40], [40,40], [40,40], [40,40], [40,40]}; %mm rectangular or diameter
        
        inst_params.col = [];
        
        %Describe Detector(s)
        inst_params.detectors = 1;
        inst_params.detector1.type = 'multiwire';
        inst_params.detector1.view_position = 'centre';
        inst_params.detector1.pixels = [192, 192]; %Number of pixels, x,y
        inst_params.detector1.pixel_size = [5.15, 5.15]; %mm [x y]
        inst_params.detector1.nominal_beam_centre = [96.5 96.5]; %[x y]
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        inst_params.detector1.dead_time = 6*10^-6;
        inst_params.detector1.dan_rotation_offset = 0; %m
        inst_params.detector1.imask = get_mask('ornl_cg3_msk.msk');
        inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        inst_params.vectors.source_ap = 57; inst_params.vector_names{57} = {'Source Aperture Size'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.zarc = 102;
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        
        
        
        
        
    case 'ANSTO_quokka'
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 7;
        inst_params.filename.lead_string = ['QKK'];
        inst_params.filename.extension_string = ['.nx.hdf'];
        inst_params.filename.data_loader = 'raw_read_ansto_sans';
        
        inst_params.guide_size = [50e-3,50e-3];  %m x y
        inst_params.wav_range = [4.5 43];
        
        inst_params.att.position = -20; %Position relative to sample
        inst_params.att.number = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        inst_params.att.ratio(1,:) = [4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
        inst_params.att.ratio(2,:) = [50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
        
        %Grasp would like the reciprocal of these attenuation factors - turn upside down
        inst_params.att.ratio(:,2:size(inst_params.att.ratio,2)) = 1 ./ inst_params.att.ratio(:,2:size(inst_params.att.ratio,2));
        
        inst_params.att.type = [{'aperture'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}];
        inst_params.att.size = {[50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3], [50e-3,50e-3]}; %mm rectangular or diameter
        
        inst_params.col = [1, 2, 4, 6, 8, 10, 12, 14, 16, 20];
        inst_params.col_aps{1} = {[50e-3]};
        inst_params.col_aps{2} = {[50e-3]};
        inst_params.col_aps{3} = {[50e-3]};
        inst_params.col_aps{4} = {[50e-3]};
        inst_params.col_aps{5} = {[50e-3]};
        inst_params.col_aps{6} = {[50e-3]};
        inst_params.col_aps{7} = {[50e-3]};
        inst_params.col_aps{8} = {[50e-3]};
        inst_params.col_aps{9} = {[50e-3]};
        inst_params.col_aps{10} = {[50e-3]};
        
        %Describe Detector(s)
        inst_params.detectors = 1;
        inst_params.detector1.type = 'multiwire';
        inst_params.detector1.view_position = 'centre';
        inst_params.detector1.pixels = [192 192]; %Number of pixels, x,y
        inst_params.detector1.pixel_size = [5.08, 5.08]; %mm [x y]
        inst_params.detector1.nominal_beam_centre = [96.5 96.5]; %[x y]
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        inst_params.detector1.dead_time = 8.5e-7;
        inst_params.detector1.dan_rotation_offset = 0; %m
        inst_params.detector1.imask = get_mask('ansto_quokka_msk.msk');
        inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        %inst_params.vectors.col_app = 57; inst_params.vector_names{57} = {'Col Defining Aperture #'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.phi2 = 103; inst_params.vector_names{103} = {'Phi2'};
        
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        
        
    case 'ISIS_SANS_2D'
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 8;
        inst_params.filename.lead_string = ['SANS2D'];
        inst_params.filename.extension_string = ['.nxs'];
        inst_params.filename.data_loader = 'raw_read_isis_sans2d';
        
        %Load Direct beam function data (detector / monitor efficiency ratio)
        inst_params.direct_beam_function = dlmread('SANS2D_direct_beam_function.dat');
        
        inst_params.source.moderator_monitor_distance = 17.937;  %m
        
        
        inst_params.guide_size = [30e-3,50e-3];  %m x y
        inst_params.wav_range = [1.75 16];
        
        inst_params.att.position = -20; %Position relative to sample
        inst_params.att.number = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        inst_params.att.ratio(1,:) = [4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
        inst_params.att.ratio(2,:) = [50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
        
        %Grasp would like the reciprocal of these attenuation factors - turn upside down
        inst_params.att.ratio(:,2:size(inst_params.att.ratio,2)) = 1 ./ inst_params.att.ratio(:,2:size(inst_params.att.ratio,2));
        
        inst_params.att.type = [{'aperture'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}, {'absorber'}];
        inst_params.att.size = {[30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3], [30e-3,50e-3]}; %mm rectangular or diameter
        
        inst_params.col = [2, 4, 6, 8, 10,12];
        inst_params.col_aps{1} = {[30e-3,50e-3]};
        inst_params.col_aps{2} = {[30e-3,50e-3]};
        inst_params.col_aps{3} = {[30e-3,50e-3]};
        inst_params.col_aps{4} = {[30e-3,50e-3]};
        inst_params.col_aps{5} = {[30e-3,50e-3]};
        inst_params.col_aps{6} = {[30e-3,50e-3]};
        
        %Describe Detector(s)
        inst_params.detectors = 2;
        inst_params.detector1.type = 'multiwire';
        inst_params.detector1.view_position = 'centre_right';
        inst_params.detector1.pixels = [192 192]; %Number of pixels, x,y
        inst_params.detector1.pixel_size = [5.08, 5.08]; %mm [x y]
        inst_params.detector1.nominal_beam_centre = [96.5 96.5]; %[x y]
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        inst_params.detector1.dead_time = 8.5e-7;
        inst_params.detector1.dan_rotation_offset = 0; %m
        inst_params.detector1.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(2));
        inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        
        inst_params.detector2.type = 'multiwire';
        inst_params.detector2.view_position = 'centre_left';
        inst_params.detector2.pixels = [192 192]; %Number of pixels, x,y
        inst_params.detector2.pixel_size = [5.08, 5.08]; %mm [x y]
        inst_params.detector2.nominal_beam_centre = [96.5 96.5]; %[x y]
        inst_params.detector2.nominal_det_translation = [0, 0]; %mm [x y]
        inst_params.detector2.dead_time = 8.5e-7;
        inst_params.detector2.dan_rotation_offset = 0; %m
        inst_params.detector2.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(2));
        inst_params.detector2.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        %inst_params.vectors.col_app = 57; inst_params.vector_names{57} = {'Col Defining Aperture #'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.phi2 = 103; inst_params.vector_names{103} = {'Phi2'};
        
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        
        
        
    case 'JAEA_sansu'
        
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 6;
        inst_params.filename.lead_string = ['SANSU10_'];
        
        inst_params.guide_size = [50e-3,50e-3];  %m x y
        inst_params.wav_range = [4.5 43];
        
        inst_params.att.position = -18.8; %Position relative to sample
        inst_params.att.number = [0, 1, 2, 3, 4, 5, 6, 7];
        inst_params.att.ratio = [1];
        inst_params.att.type = [{'aperture'}];
        inst_params.att.size = {[50e-3,50e-3]}; %m rectangular or diameter
        
        inst_params.col = [];
        
        %Normal resolution instrument config
        if strcmp(grasp_env.inst_option,'JAEA_sansu')
            
            %***** File name handleing parameters *****
            inst_params.filename.extension_string = ['.mdat'];
            inst_params.filename.data_loader = 'raw_read_jaea_sansu';
            
            
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5.08, 5.08]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 0;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(2));
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
            
            %High resolution instrument config
        elseif strcmp(grasp_env.inst_option,'JAEA_sansu_hres')
            
            %***** File name handleing parameters *****
            inst_params.filename.extension_string = ['.sdat'];
            inst_params.filename.data_loader = 'raw_read_jaea_highres';
            
            %Describe Detector(s)
            inst_params.detectors = 1;
            inst_params.detector1.type = 'multiwire';
            inst_params.detector1.view_position = 'centre';
            inst_params.detector1.pixels = [256 256]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5.08, 5.08]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [128.5 128.5]; %[x y]
            inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
            inst_params.detector1.dead_time = 0;
            inst_params.detector1.dan_rotation_offset = 0; %m
            inst_params.detector1.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(1));
            inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        end
        
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        %inst_params.vectors.col_app = 57; inst_params.vector_names{57} = {'Col Defining Aperture #'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        
        
        
        
        
    case 'FRM2_Mira'
        %***** Instrument: FRM2 Mira *****
        
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 5;
        inst_params.filename.lead_string = ['mira_psd_'];
        inst_params.filename.extension_string = ['.XML'];
        inst_params.filename.data_loader = 'raw_read_frm2_mira';
        
        inst_params.guide_size = [120e-3,10e-3];  %m x y
        inst_params.wav_range = [4.5 38];
        
        inst_params.att.position = -18.8; %Position relative to sample
        inst_params.att.number = [0];
        
        %Wavelength dependent attenuators, e.g. ratio(1,:) = [wav, att1, att2, att3 ....]
        %if more than one wavelength entry then interpolate for wavelengths inbetween
        inst_params.att.ratio(1,:) = [4, 1];
        inst_params.att.ratio(2,:) = [20, 1];
        inst_params.att.ratio(3,:) = [40, 1];
        inst_params.att.type = [{'aperture'}];
        inst_params.att.size = {[40e-3,40e-3]}; %m rectangular or diameter
        
        %Collimation distances
        inst_params.col = [];
        
        %Describe Detector(s)
        inst_params.detectors = 1;
        inst_params.detector1.type = 'multiwire';
        inst_params.detector1.view_position = 'centre';
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        inst_params.detector1.dead_time = 0*10^-6;
        inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        
        
        if strcmp(grasp_env.inst_option,'data128x128') %New Detector
            inst_params.data_resize = 8; %i.e. divide by a factor of 8 e.g. 1024 pixels becomes 128
        elseif strcmp(grasp_env.inst_option,'data256x256') %Old Detector
            inst_params.data_resize = 4; %i.e. divide by a factor of 4 e.g. 1024 pixels becomes 256
        end
        inst_params.detector1.pixels = [1024 1024]/inst_params.data_resize; %Number of pixels, x,y
        inst_params.detector1.pixel_size = [0.1953, 0.1953]*inst_params.data_resize; %mm [x y]
        inst_params.detector1.nominal_beam_centre = (inst_params.detector1.pixels +1)/2; %[x y]
        
        
        
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        
        inst_params.detector1.dan_rotation_offset = 0; %m
        inst_params.detector1.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(1));
        
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.mag_field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.om = 65; inst_params.vector_names{65} = {'Om'};
        inst_params.vectors.phi = 61; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.stx = 101; inst_params.vector_names{101} = {'Stx'};
        inst_params.vectors.sty = 64; inst_params.vector_names{64} = {'Sty'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        inst_params.vectors.sgx = 103; inst_params.vector_names{103} = {'Sgx'};
        
    case 'HZB_V4'
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 7;
        inst_params.filename.lead_string = ['D'];
        inst_params.filename.extension_string = ['.001'];
        inst_params.filename.data_loader = 'raw_read_hzb_v4';
        
        inst_params.guide_size = [50e-3,50e-3];  %m x y
        inst_params.wav_range = [4.5 38];
        
        inst_params.att.position = -18.8; %Position relative to sample
        inst_params.att.number = [0];
        
        %Wavelength dependent attenuators, e.g. ratio(1,:) = [wav, att1, att2, att3 ....]
        %if more than one wavelength entry then interpolate for wavelengths inbetween
        inst_params.att.ratio(1,:) = [4, 1];
        inst_params.att.ratio(2,:) = [20, 1];
        inst_params.att.ratio(3,:) = [40, 1];
        inst_params.att.type = [{'aperture'}];
        inst_params.att.size = {[50e-3,50e-3]}; %m rectangular or diameter
        
        %Collimation distances
        inst_params.col = [];
        
        %Describe Detector(s)
        inst_params.detectors = 1;
        inst_params.detector1.type = 'multiwire';
        inst_params.detector1.view_position = 'centre';
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        inst_params.detector1.dead_time = 0*10^-6;
        inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        
        if strcmp(grasp_env.inst_option,'V4_128')
            inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [5, 5]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
            
        elseif strcmp(grasp_env.inst_option,'V4_64');
            inst_params.detector1.pixels = [64 64]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [10, 10]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [32.5 32.5];
            
        elseif strcmp(grasp_env.inst_option,'V4_NewDetector2012');
            inst_params.detector1.pixels = [120 112]; %Number of pixels, x,y
            inst_params.detector1.pixel_size = [8.3, 8.3]; %mm [x y]
            inst_params.detector1.nominal_beam_centre = [110.5 56.5];
            
            
        end
        inst_params.detector1.dan_rotation_offset = 0; %m
        inst_params.detector1.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(1));
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        inst_params.vectors.str = 18; inst_params.vector_names{18} = {'Str'};
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        %inst_params.vectors.col_app = 57; inst_params.vector_names{57} = {'Col Defining Aperture #'};
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        inst_params.vectors.det_angle = [61]; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dan = 61; inst_params.vector_names{61} = {'Dan'};
        inst_params.vectors.dtr = 62; inst_params.vector_names{62} = {'Dtr'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'Sdi'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'San'};
        inst_params.vectors.chpos = 66; inst_params.vector_names{66} = {'Changer Position'};
        inst_params.vectors.sht = 67; inst_params.vector_names{67} = {'Sht'};
        inst_params.vectors.field = 82; inst_params.vector_names{82} = {'Magnetic Field'};
        inst_params.vectors.reactor_power = 84; inst_params.vector_names{84} = {'Reactor Power'};
        inst_params.vectors.trs = 101; inst_params.vector_names{101} = {'Trs'};
        inst_params.vectors.phi = 102; inst_params.vector_names{102} = {'Phi'};
        inst_params.vectors.chi = 103; inst_params.vector_names{103} = {'Chi'};
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
        
        
        
    case 'FRM2_SANS1'
        %***** File name handleing parameters *****
        inst_params.filename.numeric_length = 7;
        inst_params.filename.lead_string = ['D'];
        inst_params.filename.extension_string = ['.001'];
        inst_params.filename.data_loader = 'raw_read_frm2_sans1';
        
        inst_params.guide_size = [50e-3,50e-3];  %m x y
        inst_params.wav_range = [3.5 25];
        
        inst_params.att.position = -18.8; %Position relative to sample
        inst_params.att.number = [0];
        
        %Wavelength dependent attenuators, e.g. ratio(1,:) = [wav, att1, att2, att3 ....]
        %if more than one wavelength entry then interpolate for wavelengths inbetween
        inst_params.att.ratio(1,:) = [3, 1, 10,100,1000];
        inst_params.att.ratio(2,:) = [40, 1, 10, 100, 1000];
        inst_params.att.type = [{'aperture'}, {'sieve'}, {'sieve'}, {'sieve'}];
        inst_params.att.size = {[50e-3,50e-3]}; %m rectangular or diameter
        
        %Collimation distances
        inst_params.col = [];
        
        %Describe Detector(s)
        inst_params.detectors = 1;
        inst_params.detector1.type = 'tube';
        inst_params.detector1.view_position = 'centre';
        inst_params.detector1.nominal_det_translation = [0, 0]; %mm [x y]
        inst_params.detector1.dead_time = 0*10^-6;
        inst_params.detector1.relative_efficiency = 1;   % Efficiency relative to rear detector (detector 1)
        inst_params.detector1.pixels = [128 128]; %Number of pixels, x,y
        inst_params.detector1.pixel_size = [8, 8]; %mm [x y]
        inst_params.detector1.nominal_beam_centre = [64.5 64.5]; %[x y]
        inst_params.detector1.dan_rotation_offset = 0; %m
        inst_params.detector1.imask = ones(inst_params.detector1.pixels(2),inst_params.detector1.pixels(1));
        
        %Parameter position vectors
        inst_params.vector_names = cell(128,1); %Create empty cells for parameter names
        
        inst_params.vectors.time = 3; inst_params.vector_names{3} = {'Time'};
        inst_params.vectors.aq_time = 3; inst_params.vector_names{3} = {'Measurement Time'};
        inst_params.vectors.monitor = 5; inst_params.vector_names{5} = {'Monitor1'};
        inst_params.vectors.monitor1 = 5; inst_params.vector_names{5} = {'Monitor1'};
        inst_params.vectors.monitor2 = 6; inst_params.vector_names{6} = {'Monitor2'};
        
        inst_params.vectors.by = 16; inst_params.vector_names{16} = {'By'};
        inst_params.vectors.bx = 17; inst_params.vector_names{17} = {'Bx'};
        
        inst_params.vectors.det = 19; inst_params.vector_names{19} = {'Detector Distance'};
        inst_params.vectors.sel_rpm = 20; inst_params.vector_names{20} = {'Selector RPM'};
        
        inst_params.vectors.detcalc = 26; inst_params.vector_names{26} = {'Det_Calc'};
        
        inst_params.vectors.tset = 29; inst_params.vector_names{29} = {'Setpoint Temperature'};
        inst_params.vectors.treg = 30; inst_params.vector_names{30} = {'Regulation Temparature'};
        inst_params.vectors.temp = 31; inst_params.vector_names{31} = {'Sample Temperature'};
        inst_params.vectors.field = 32; inst_params.vector_names{32} = {'Magnetic Field'};
        
        inst_params.vectors.wav = 53; inst_params.vector_names{53} = {'Wavelength'};
        inst_params.vectors.deltawav = 54; inst_params.vector_names{54} = {'Delta_Wavelength'};
        
        inst_params.vectors.pixel_x = 55; inst_params.vector_names{55} = {'Pixel Size x'};
        inst_params.vectors.pixel_y = 56; inst_params.vector_names{56} = {'Pixel Size y'};
        
        inst_params.vectors.col = 58; inst_params.vector_names{58} = {'Collimation'};
        inst_params.vectors.att_type = 59; inst_params.vector_names{59} = {'Attenuator'};
        inst_params.vectors.att_status = 60; inst_params.vector_names{60} = {'Attenuator Status'};
        
        inst_params.vectors.chpos = 62; inst_params.vector_names{62} = {'Changer Position'};
        
        inst_params.vectors.x_2b = 63; inst_params.vector_names{63} = {'x-2b'};
        inst_params.vectors.sdi2 = 63; inst_params.vector_names{63} = {'x-2b'};
        inst_params.vectors.x_2a = 64; inst_params.vector_names{64} = {'x-2b'};
        inst_params.vectors.sdi1 = 64; inst_params.vector_names{64} = {'x-2b'};
        inst_params.vectors.sdi = 64; inst_params.vector_names{64} = {'x-2b'};
        inst_params.vectors.san = 65; inst_params.vector_names{65} = {'omega-2b'};
        inst_params.vectors.omega_2b = 65; inst_params.vector_names{65} = {'omega-2b'};
        inst_params.vectors.chi_2b = 66; inst_params.vector_names{66} = {'chi-2b'};
        inst_params.vectors.phi_2b = 67; inst_params.vector_names{67} = {'phi-2b'};
        inst_params.vectors.z_2a = 68; inst_params.vector_names{68} = {'z-2a'};
        inst_params.vectors.sht = 68; inst_params.vector_names{68} = {'z-2a'};
        inst_params.vectors.z_2b = 69; inst_params.vector_names{69} = {'z-2b'};
        inst_params.vectors.y_2b = 70; inst_params.vector_names{70} = {'y-2b'};
        inst_params.vectors.y_2a = 71; inst_params.vector_names{71} = {'y-2a'};
        inst_params.vectors.trs = 72; inst_params.vector_names{72} = {'y-2a'};
        
        inst_params.vectors.array_counts = 127; inst_params.vector_names{127} = {'Total Array Counts'};
        inst_params.vectors.numor = 128; inst_params.vector_names{128} = {'Numor'};
end


