function foreimage = get_selector_result

%***** Worksheet types *****
% 1 = sample scattering
% 2 = sample background
% 3 = sample cadmium
% 4 = sample transmission
% 5 = sample empty transmission
% 6 = sample empty beam transmission
% 7 = sample mask
% 8 = I0 Beam Intensity
% 99 = detector efficiency map
% 10 = FR Trans Check
% 11,12,13,14 = PA Sample Sampleing ++ -+ -- +-

global status_flags
global inst_params
global grasp_env

%Begin the local history
history = {[grasp_env.grasp_name ' V.' grasp_env.grasp_version '    Instrument:  ' grasp_env.inst]};
history = [history, {[' ']}];


if status_flags.selector.fw == 11 || status_flags.selector.fw == 12 || status_flags.selector.fw == 13 || status_flags.selector.fw == 14
    %***** Do something differeny for PA analysis:  Worksheets Sample++, -+, --, +- *****
    disp('PA Analysis in ''get_selector_result.m''')

    %Worksheet number & Depth
    nmbr = status_flags.selector.fn;
    dpth = status_flags.selector.fd;
    %Worksheet number & Depth
    nmbr_bck = status_flags.selector.bn;
    dpth_bck = status_flags.selector.bd;


    %***** Get ++Sample *****
    index = data_index(11);
    [pa00] = retrieve_data([index,nmbr,dpth]);
    history = [history, {['***** PA Worksheets ++, -+, --, +- *****']}];
    history = [history, {['Subtitle:  ' pa00.subtitle]}];
    history = [history, {['Start: ' pa00.info.start_date '  ' pa00.info.start_time '   End: ' pa00.info.end_date '  ' pa00.info.end_time]}];
    history = [history, {[' ']}];
    %Add ++ info to History
    if pa00.sum_flag ==1
        history = [history, {['Sample ++: Sum ' pa00.load_string{:} ' , Loaded: ' pa00.load_string{:}]}];
    else
        history = [history, {['Sample ++:  ' num2str(pa00.params1(128)) ' , Loaded: ' pa00.load_string{:}]}];
    end
    %Data Normalisation, Attenuator & Deadtime
    pa00 = normalize_data(pa00);

    %***** Get ++Background *****
    index = data_index(15);
    [bck00] = retrieve_data([index,nmbr_bck,dpth_bck]);
    %Data Normalisation, Attenuator & Deadtime
    bck00 = normalize_data(bck00);
    if status_flags.selector.b_check ==1; %background subtraction is enabled
        %Add ++ background info to History
        if bck00.sum_flag ==1
            history = [history, {['Background ++: Sum ' bck00.load_string{:} ' , Loaded: ' bck00.load_string{:}]}];
        else
            history = [history, {['Background ++:  ' num2str(bck00.params1(128)) ' , Loaded: ' bck00.load_string{:}]}];
        end
    end
    
    
    
    
    %***** Get -+Sample *****
    index = data_index(12);
    [pa10] = retrieve_data([index,nmbr,dpth]);
    %Data Normalisation, Attenuator & Deadtime
    pa10 = normalize_data(pa10);
    %Add -+ info to History
    if pa10.sum_flag ==1
        history = [history, {['Sample -+: Sum ' pa10.load_string{:} ' , Loaded: ' pa10.load_string{:}]}];
    else
        history = [history, {['Sample -+:  ' num2str(pa10.params1(128)) ' , Loaded: ' pa10.load_string{:}]}];
    end
    
    %***** Get -+Background *****
    index = data_index(16);
    [bck10] = retrieve_data([index,nmbr_bck,dpth_bck]);
    %Data Normalisation, Attenuator & Deadtime
    bck10 = normalize_data(bck10);
    if status_flags.selector.b_check ==1; %background subtraction is enabled
        %Add -+ background info to History
        if bck10.sum_flag ==1
            history = [history, {['Background -+: Sum ' bck10.load_string{:} ' , Loaded: ' bck10.load_string{:}]}];
        else
            history = [history, {['Background -+:  ' num2str(bck10.params1(128)) ' , Loaded: ' bck10.load_string{:}]}];
        end
    end

    
    
    
    %***** Get --Sample *****
    index = data_index(13);
    [pa11] = retrieve_data([index,nmbr,dpth]);
    %Data Normalisation, Attenuator & Deadtime
    pa11 = normalize_data(pa11);
    %Add +- info to History
    if pa11.sum_flag ==1
        history = [history, {['Sample --: Sum ' pa11.load_string{:} ' , Loaded: ' pa11.load_string{:}]}];
    else
        history = [history, {['Sample --:  ' num2str(pa11.params1(128)) ' , Loaded: ' pa11.load_string{:}]}];
    end
    
    %***** Get --Background *****
    index = data_index(17);
    [bck11] = retrieve_data([index,nmbr_bck,dpth_bck]);
    %Data Normalisation, Attenuator & Deadtime
    bck11 = normalize_data(bck11);
    if status_flags.selector.b_check ==1; %background subtraction is enabled
        %Add -- background info to History
        if bck11.sum_flag ==1
            history = [history, {['Background --: Sum ' bck10.load_string{:} ' , Loaded: ' bck11.load_string{:}]}];
        else
            history = [history, {['Background --:  ' num2str(bck10.params1(128)) ' , Loaded: ' bck11.load_string{:}]}];
        end
    end

    
    
    
    %***** Get +-Sample *****
    index = data_index(14);
    [pa01] = retrieve_data([index,nmbr,dpth]);
    %Data Normalisation, Attenuator & Deadtime
    pa01 = normalize_data(pa01);
    %Add +- info to History
    if pa01.sum_flag ==1
        history = [history, {['Sample +-: Sum ' pa01.load_string{:} ' , Loaded: ' pa01.load_string{:}]}];
    else
        history = [history, {['Sample +-:  ' num2str(pa01.params1(128)) ' , Loaded: ' pa01.load_string{:}]}];
    end
    
    %***** Get +-Background *****
    index = data_index(18);
    [bck01] = retrieve_data([index,nmbr_bck,dpth_bck]);
    %Data Normalisation, Attenuator & Deadtime
    bck01 = normalize_data(bck01);
    if status_flags.selector.b_check ==1; %background subtraction is enabled
        %Add +- background info to History
        if bck01.sum_flag ==1
            history = [history, {['Background +-: Sum ' bck01.load_string{:} ' , Loaded: ' bck01.load_string{:}]}];
        else
            history = [history, {['Background +-:  ' num2str(bck01.params1(128)) ' , Loaded: ' bck01.load_string{:}]}];
        end
    end
    
    %Add the normalisation history only once
    history = [history, {[' ']}];
    history = [history, pa00.history]; %add the normalization history (taken from P00)
    
    
    
    
    %***** Corrections *****
    
    %Get current transmission values, Ts, err_Ts, Te, err_Te
    [trans] = current_transmission; %These are scalar values for simple transmissions or matricies when doing transmission thickness correction.  Also gives back the current sample thickness based upon the trasmission locked indicators.
    pa00.trans = trans; pa10.trans = trans; pa11.trans = trans; pa01.trans = trans;
    history = [history, {[' ']}];
    history = [history, {['Transmissions:  Ts = ' num2str(trans.ts) ' +/- ' num2str(trans.err_ts) '  Te = ' num2str(trans.te) ' +/- ' num2str(trans.err_te)]}];
    
    %Subtract Backgrounds from each spin state
    %for the moment use an empty 'dummy' cadmium worksheet
    for det = 1:inst_params.detectors;
        cadmiumimage.(['data' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
        cadmiumimage.(['error' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
    end
    history = [history, {['Cadmium: No Cadmium Subtraction']}];
    
    %Do the standard SANS subtraction
    history = [history, {[' ']}];
    pa00 = standard_data_correction(pa00, bck00, cadmiumimage);
    history = [history, {['Applying standard SANS data reduction:  I00 = 1/[Ts Te] [I00 - I_cd]  - 1/[Te] [Bck00 - I_cd]']}];
    pa10 = standard_data_correction(pa10, bck10, cadmiumimage);
    history = [history, {['Applying standard SANS data reduction:  I10 = 1/[Ts Te] [I10 - I_cd]  - 1/[Te] [Bck10 - I_cd]']}];
    pa11 = standard_data_correction(pa11, bck11, cadmiumimage);
    history = [history, {['Applying standard SANS data reduction:  I11 = 1/[Ts Te] [I11 - I_cd]  - 1/[Te] [Bck11 - I_cd]']}];
    pa01 = standard_data_correction(pa01, bck01, cadmiumimage);
    history = [history, {['Applying standard SANS data reduction:  I01 = 1/[Ts Te] [I01 - I_cd]  - 1/[Te] [Bck01 - I_cd]']}];
    
    
    %Set up output array 'foreimage';
    if status_flags.selector.fw == 11 %Sample ++ is displayed
        foreimage = pa00;
    elseif status_flags.selector.fw == 12 %Sample -+ is displayed
        foreimage = pa10;
    elseif status_flags.selector.fw == 13 %Sample -- is displayed
        foreimage = pa11;
    elseif status_flags.selector.fw == 14 %Sample +- is displayed
        foreimage = pa01;
    end
    
    %***** All the 4 spin components need correcting together THEN
    %designate one as the 'foreimage' to be displayed, depending on what is
    %chosen in the selector *****
    
    if status_flags.calibration.pa_chk ==1; %Do the correction
        
        %Calculate time midpoint for measurement
        temp1 = datenum([foreimage.info.start_date foreimage.info.start_time]);
        temp2 = datenum([foreimage.info.end_date foreimage.info.end_time]);
        mid_point_time = temp1+(temp2-temp1)/2;
        
        %reference time (of first pa check measurement)
        reference_time = status_flags.pa_optimise.efficiencies.absolute_time(1);

        time = mid_point_time - reference_time; %days
        time = time * 24; %hrs
        
        % Calculate 3He correction parameters
        %time = 100; %Time of current measurements being processed relative to 3He cell time-origin
        p = status_flags.pa_optimise.parameters.p; %polariser efficiency & error
        fp = status_flags.pa_optimise.parameters.fp; %rf flipper efficiency & error
        fa = status_flags.pa_optimise.parameters.fa; %3He flipper efficiency & error
        opacity = status_flags.pa_optimise.parameters.opacity; %3He Opacity & error
        phe0 = status_flags.pa_optimise.parameters.p0; %3He initial polarisation @ t0 &  error
        t1 = status_flags.pa_optimise.parameters.t1; %3He time constant & error
        t0 = status_flags.pa_optimise.parameters.t0; %Time offset & error
        [phi,a] = pa_combined_efficiency(time,p(1),opacity(1),phe0(1),t1(1),t0(1)); %phi = combined polarizer/analyzer efficiency, a = analyzer efficiency
        
        history = [history, {[' ']}];
        history = [history, {['Spin-Leakage Corrections:   ']}];
        history = [history, {['Polarizer efficiency = ' num2str(p(1)) ', RF Flipper efficiency = ' num2str(fp(1))]}];
        history = [history, {['Analyzer efficiency [@ time ' num2str(time) ' (hrs) = ' num2str(a) ', 3He Flipper efficiency = ' num2str(fa(1))]}];
        history = [history, {['3He Parameters:  Opacity ' num2str(opacity(1)) ', PHe0 = ' num2str(phe0(1)) ', T1 = ' num2str(t1(1)) ' (hrs), T0 = ' num2str(t0(1)) ' (hrs)']}];
        history = [history, {['Measurement time is ' num2str(time) ' (hrs) relative to first PA check']}];
        history = [history, {[' ']}];
        
        %Do the Spin-Leakage Correction
        sigma = pa_correct(pa00, pa10, pa11, pa01, p, fp, [a,0], fa);
        
        for det = 1:inst_params.detectors
            if status_flags.selector.fw == 11 %Sample ++ is displayed
                foreimage.(['data' num2str(det)]) = sigma.i00.(['data' num2str(det)]);
                foreimage.(['error' num2str(det)]) = sigma.i00.(['error' num2str(det)]);
            elseif status_flags.selector.fw == 12 %Sample -+ is displayed
                foreimage.(['data' num2str(det)]) = sigma.i10.(['data' num2str(det)]);
                foreimage.(['error' num2str(det)]) = sigma.i10.(['error' num2str(det)]);
            elseif status_flags.selector.fw == 13 %Sample -- is displayed
                foreimage.(['data' num2str(det)]) = sigma.i11.(['data' num2str(det)]);
                foreimage.(['error' num2str(det)]) = sigma.i11.(['error' num2str(det)]);
            elseif status_flags.selector.fw == 14 %Sample +- is displayed
                foreimage.(['data' num2str(det)]) = sigma.i01.(['data' num2str(det)]);
                foreimage.(['error' num2str(det)]) = sigma.i01.(['error' num2str(det)]);
            end
        end
    else
        history = [history, {[' ']}];
        history = [history, {['NO Spin-Leakage Corrections:   ']}];
    end
    
    
      %***** Q Calculations *****
    %Beam centre (for the current foreground data)
    foreimage.cm = current_beam_centre; %Need to get the real beam centre here rather than relying on beamcentre in worksheet as it can be different due to beam centre lock
    %Add beam centre history
    history = [history, {[' ']}];
    for det = 1:inst_params.detectors
        history = [history, {['Beam Centre' num2str(det) ' :  Cx = ' num2str(foreimage.cm.(['det' num2str(det)]).cm_pixels(1)) '  Cy = ' num2str(foreimage.cm.(['det' num2str(det)]).cm_pixels(2)) '       Cm Translation :  Tx = ' num2str(foreimage.cm.(['det' num2str(det)]).cm_translation(1)) '  Ty = ' num2str(foreimage.cm.(['det' num2str(det)]).cm_translation(2)) ' [mm]']}];
    end
    %Q-matrix for the foreground data
    foreimage = build_q_matrix(foreimage); %i.e. qx, qy, mod_q, q_angle, 2thetax, 2thetay, mod_2theta, solid angle
    
    
    
    
    
    
    
else %Conventional Analysis - Get foreground, background and cadmium selector data
    
    %Get Foreground data
    [foreimage] = retrieve_data('fore'); %foreground data, and flag - determines if data is 'data' or masks etc.
       
    status_flags.selector.f_type = foreimage.type; %Flag to show what type of data is displayed, e.g. foreground,
    
    history = [history, {['***** Sample, Backgrounds and Transmissions Data: *****']}];
    history = [history, {['Subtitle:  ' foreimage.subtitle]}];
    history = [history, {['Start: ' foreimage.info.start_date '  ' foreimage.info.start_time '   End: ' foreimage.info.end_date '  ' foreimage.info.end_time]}];
    history = [history, {[' ']}];
    
    %Add Foreground info to History
    if foreimage.sum_flag ==1
        history = [history, {['Foreground: Sum ' foreimage.load_string{:} ' , Loaded: ' foreimage.load_string{:}]}];
    else
        history = [history, {['Foreground:  ' num2str(foreimage.params1(128)) ' , Loaded: ' foreimage.load_string{:}]}];
    end
    
    if foreimage.type ~= 7 && foreimage.type ~=99; %Normalise foreground data (only if real data, not masks etc)
        foreimage = normalize_data(foreimage);  %Data Normalisation, Attenuator correction and deadtime
    end
   
    %Get Background data
    if status_flags.selector.b_check == 1 && (foreimage.type == 1 || foreimage.type == 2); %i.e. subtract background
        [backimage] = retrieve_data('back'); %background data
        %Add Background info to History
        if backimage.sum_flag ==1
            history = [history, {['Background: Sum ' backimage.load_string{:} ' , Loaded: ' backimage.load_string{:}]}];
        else
            history = [history, {['Background:  ' num2str(backimage.params1(128)) ' , Loaded: ' backimage.load_string{:}]}];
        end
        %Normalise background data (only if real data, not masks etc)
        backimage = normalize_data(backimage);  %Data Normalisation, Attenuator correction and deadtime
    else
        %Create empty effective backgrounds to subtract nothing in the data correction
        for det = 1:inst_params.detectors
            backimage.(['data' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)); %y,x
            backimage.(['error' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)); %y,x
        end
        history = [history, {['Background: No Background Subtraction']}];
    end
    
    
    %Get Cadmium data
    if status_flags.selector.c_check == 1 && (foreimage.type == 1 || foreimage.type == 2); %i.e. use cadmium
        [cadmiumimage] = retrieve_data('cad'); %cadmium data
        %Add Cadmium info to History
        if cadmiumimage.sum_flag ==1
            history = [history, {['Cadmium: Sum ' cadmiumimage.load_string{:} ' , Loaded: ' cadmiumimage.load_string{:}]}];
        else
            history = [history, {['Cadmium:  ' num2str(cadmiumimage.params1(128)) ' , Loaded: ' cadmiumimage.load_string{:}]}];
        end
        %Normalise cadmium data (only if real data, not masks etc)
        cadmiumimage = normalize_data(cadmiumimage); %Data Normalisation, Attenuator correction and deadtime
    else
        %Create empty effective backgrounds to subtract nothing in the data correction
        for det = 1:inst_params.detectors
            cadmiumimage.(['data' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)); %y,x
            cadmiumimage.(['error' num2str(det)]) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)); %y,x
        end
        history = [history, {['Cadmium: No Cadmium Subtraction']}];
    end
    
    %Add the normalisation history only once
    history = [history, foreimage.history]; %add the normalization history
    
    
    %***** Q Calculations *****
    %Beam centre (for the current foreground data)
    foreimage.cm = current_beam_centre; %Need to get the real beam centre here rather than relying on beamcentre in worksheet as it can be different due to beam centre lock
    %Add beam centre history
    history = [history, {[' ']}];
    for det = 1:inst_params.detectors
        history = [history, {['Beam Centre' num2str(det) ' :  Cx = ' num2str(foreimage.cm.(['det' num2str(det)]).cm_pixels(1)) '  Cy = ' num2str(foreimage.cm.(['det' num2str(det)]).cm_pixels(2)) '       Cm Translation :  Tx = ' num2str(foreimage.cm.(['det' num2str(det)]).cm_translation(1)) '  Ty = ' num2str(foreimage.cm.(['det' num2str(det)]).cm_translation(2)) ' [mm]']}];
    end
    %Q-matrix for the foreground data
    foreimage = build_q_matrix(foreimage); %i.e. qx, qy, mod_q, q_angle, 2thetax, 2thetay, mod_2theta, solid angle
    
    
    
    
    
    
    
    %Get current transmission values, Ts, err_Ts, Te, err_Te
    [foreimage.trans] = current_transmission; %These are scalar values for simple transmissions or matricies when doing transmission thickness correction.  Also gives back the current sample thickness based upon the trasmission locked indicators.
    history = [history, {['Transmissions:  Ts = ' num2str(foreimage.trans.ts) ' +/- ' num2str(foreimage.trans.err_ts) '  Te = ' num2str(foreimage.trans.te) ' +/- ' num2str(foreimage.trans.err_te)]}];
    
    %Check if to make transmission thickness correction
    if strcmp(status_flags.transmission.thickness_correction,'on')
        %Note:  if a thickness correction is made then new fields are added to
        %the foreimage structure containing and effective transmission for
        %every pixel for every detector
        foreimage = transmission_thickness_correction(foreimage);
    end
    history = [history, {['Transmissions Thickness Correction is:  ' status_flags.transmission.thickness_correction]}];
    
    
    %***** Various data correction algorythms *****
    %Check if doing standard SANS corrections
    if (foreimage.type >= 1 && foreimage.type <= 3) %i.e. real data so do the usual SANS data correction
        
        if strcmp(status_flags.algorithm,'standard')
            %Do the standard SANS subtraction
            foreimage = standard_data_correction(foreimage, backimage, cadmiumimage);
            history = [history, {['Applying standard SANS data reduction:  I_corr = 1/[Ts Te] [I_s - I_cd]  - 1/[Te] [I_bck - I_cd]']}];
            
        elseif strcmp(status_flags.algorithm,'divide')
            
            if status_flags.selector.b_check ==1 %i.e. divide is activated in the checkbox
                %Divide Foreground & Background worksheets
                [foreimage] = divide_data_correction(foreimage, backimage);
                history = [history, {['Applying Dividing Foreground & Background worksheets:  I_corr = [I_s / I_bck]']}];
            else
                %DO NOT Divide Foreground & Background worksheets.  Simply provide FOREGROUND ONLY image
                history = [history, {['Foreground Image Only :  I_corr = I_s']}];
            end
        else
            beep
            disp('help, don''t know what to do in get_selector_result line~130');
        end
        
    elseif foreimage.type == 7;
        history = [history, {['Data Masks']}]; %Masks
        
    elseif foreimage.type == 99;
        history = [history, {['Detector Efficiency Map']}]; %Detector efficiency
        
    elseif foreimage.type == 4 || foreimage.type == 5 || foreimage.type == 6 || foreimage.type == 8 %i.e. Transmission or Direct Beam
        history = [history, {['Direct Beam or Transmission Data']}];
        history = [history, {['No Background Corrections Made']}];
    end

    
    
end
    

%***** CALIRBATIONS ***** %***** CALIRBATIONS ***** %***** CALIRBATIONS *****
%Only do data calibrations for certain worksheet types described by flag:  i.e. fore, back, masks etc.
%AND check that the intensity matrix isn't empty
if ((foreimage.type >=1 && foreimage.type <=3 ) || (foreimage.type >= 11 && foreimage.type <= 18)) && sum(sum(foreimage.params1))~=0
    
    %Check General Calibration options are ON
    if status_flags.calibration.calibrate_check == 1; %i.e. Calibration is switched on
        history = [history, {[' ']}];
        history = [history, {['***** Calibrations: *****']}];

        %Paralax Correction
        if status_flags.calibration.d22_tube_angle_check ==1;
            
            if strcmp(grasp_env.inst,'ILL_d22')
                %Normalise D22 data by the detector response paralax correction
                foreimage = d22_paralax_correction(foreimage);
                history = [history, {['Data: Corrected for D22 Detector Paralax']}];
                
            elseif strcmp(grasp_env.inst,'ILL_d33')
                %Normalise D33 data by the detector response paralax correction
                if strcmp(grasp_env.inst_option,'D33_Instrument_Comissioning') || strcmp(grasp_env.inst_option,'D33');
                    foreimage = d33_paralax_correction(foreimage);
                    history = [history, {['Data: Corrected for D33 Detector Paralax']}];
                end
            end
        end

        %***** Divide by Detector Efficiency *****
        if status_flags.calibration.det_eff_check == 1;
            %also returns a 'nan_mask' in the data structure
            foreimage = divide_detector_efficiency(foreimage);
            history = [history, {['Data: Corrected for Detector Efficiency (doesn''t change magnitude but contains curvature correction)']}];
        end
        
        %***** Direct Beam Calibration *****
        if strcmp(status_flags.calibration.method,'beam') %beam, water or none
            [foreimage, history] = direct_beam_calibration(foreimage,history);
        elseif strcmp(status_flags.calibration.method,'water')
            [foreimage, history] = water_calibration(foreimage,history);
        end
    end
end


%***** Masking *****
%Prepare the final mask for data from each detector

%Final Mask is stored in foreimage as .mask1, mask2 etc. for each detector
for det = 1:inst_params.detectors
    detector_params = inst_params.(['detector' num2str(det)]);
    foreimage.(['mask' num2str(det)]) = ones(detector_params.pixels(2),detector_params.pixels(1));
    
    %***** Instrument Mask - brought in the foreimage.imask from retrieve_data *****
    if status_flags.display.imask.check == 1; %apply instrument mask (this is not a user option, can only be controlled by this parameter)
        foreimage.(['mask' num2str(det)]) = foreimage.(['mask' num2str(det)]) .* foreimage.(['imask' num2str(det)]);
        if det ==1; history = [history, {['Applying Default Instrument Mask']}]; end
    else
        if det ==1; history = [history, {['No Default Instrument Mask']}]; end
    end
    
    %***** User Mask - brought in the foreimage.umask from retrieve_data *****
    if status_flags.display.mask.check == 1 %apply user mask
        foreimage.(['mask' num2str(det)]) = foreimage.(['mask' num2str(det)]) .* foreimage.(['umask' num2str(det)]);
        if det==1; history = [history, {['Applying User Defined Mask']}]; end
    end
    
    %Add the Nan or Inf mask, if it exists
    if isfield(foreimage,['nan_mask' num2str(det)]);
        foreimage.(['mask' num2str(det)]) = foreimage.(['mask' num2str(det)]) .* foreimage.(['nan_mask' num2str(det)]);
        if det ==1; history = [history, {['Applying NanInf Mask']}]; end
    end
    
    %Add the Zero Mask, if it exists
    if isfield(foreimage,['zero_mask' num2str(det)]);
        foreimage.(['mask' num2str(det)]) = foreimage.(['mask' num2str(det)]) .* foreimage.(['zero_mask' num2str(det)]);
        if det ==1; history = [history, {['Applying Zeros Mask']}]; end
    end
end


%***** End Masking *****


%***** Add final History to the 'intensity' structure *****
history = [history, {['Intensity units are:  ' foreimage.units]}];
history = [history, {[' ']}];

foreimage.history = history;

