function foreimage = normalize_data(foreimage)

%Performs all data normalisation to monitor, time etc.
%Performs deadtime correction
%Performs auto attenuator correction


global status_flags
global inst_params
vectors = inst_params.vectors;
history = [];

%***** Deadtime correction - should be done before any normalisation *****
%formula is real_count_rate = measured_count_rate / (1 - Tau*measured_count_rate)
if strcmp(status_flags.deadtime.status,'on')
    %Loop though detectors
    for det = 1:inst_params.detectors
        det_params = inst_params.(['detector' num2str(det)]);
        
        if strcmpi(det_params.type,'tube');
            %Tube-by-tube deadtime correction
            if foreimage.(['params' num2str(det)])(vectors.time) ~=0
                %Determine which dimension the tubes are from the dimensions of the deadtime array
                [temp, dim] = max(size(det_params.dead_time));
                if dim == 1; %Horizontal tubes
                    tube_rate = sum(foreimage.(['data' num2str(det)]),2) / foreimage.(['params' num2str(det)])(vectors.time);
                    dead_scale = 1./ (1- det_params.dead_time .* tube_rate); %vector
                    [temp, dead_scale_matrix] = meshgrid(1:det_params.pixels(1),dead_scale);
                    foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) .* dead_scale_matrix;
                    foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) .* dead_scale_matrix;
                    history = [history, {['Det: ' num2str(det) ' : Applying Deadtime Correction per (horizontal) Tube: 1/[1-tau/detector_rate], tau = ' num2str(det_params.dead_time(1)) ' (seconds)']}];
                    
                else %Vertical tubes
                    tube_rate = sum(foreimage.(['data' num2str(det)]),1) / foreimage.(['params' num2str(det)])(vectors.time);
                    dead_scale = 1./ (1- det_params.dead_time .* tube_rate); %vector
                    dead_scale_matrix = meshgrid(dead_scale,1:det_params.pixels(2));
                    foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) .* dead_scale_matrix;
                    foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) .* dead_scale_matrix;
                    history = [history, {['Det: ' num2str(det) ' : Applying Deadtime Correction per (vertical) Tube: 1/[1-tau/detector_rate], tau = ' num2str(det_params.dead_time(1)) ' (seconds)']}];
                end
            else
                history = [history, {['Det: ' num2str(det) ' : CANNOT Apply Deadtime Correction: Time Parameter = 0']}];
            end
            
        elseif strcmpi(det_params.type,'multiwire');
            %Global detector deadtime correction
            if foreimage.(['params' num2str(det)])(vectors.time) ~=0
                %Single volume detectors - deadtime done on global count rate across detector
                det_rate = sum(sum(foreimage.(['data' num2str(det)]))) / foreimage.(['params' num2str(det)])(vectors.time);
                dead_scale = 1/ (1- det_params.dead_time(1)*det_rate);
                foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) .* dead_scale;
                foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) .* dead_scale;
                history = [history, {['Det: ' num2str(det) ' : Applying Deadtime Correction per Detector: 1/[1-tau/detector_rate], tau = ' num2str(det_params.dead_time(1)) ' (seconds)']}];
            else
                history = [history, {['Det: ' num2str(det) ' : CANNOT Apply Deadtime Correction: Time Parameter = 0']}];
            end
        end
    end
    
else
    history = [history, {['No Deadtime Correction']}];
end
%End Deadtime correction

%NOTE NEED TO CHECK WHAT HAPPENS WHEN NORMALIZING TRANSMISSION DATA TO
%SOMEHTHING OTHER THAN MON TIME OR NONE
%   beep
%   disp('***** WARNING *****');
%   disp('You are not using Monitor, Time or None for data normalisation');
%   disp('Transmissions will be calculated using MONITOR normalisation');
%   disp('(If you''ve got a problem with this then you better see Charles)');
%   disp(' ');





%***** Data normalisation *****
%Note:  all checks to normalisation validy AND the monitor & time values to
%normalise by are taken from the params1 (i.e. for the first declared detector)

if strcmp(status_flags.normalization.status,'none') %i.e. abs counts
    divider = 1; divider_standard = 1;
    history = [history, {['Data Normalisation: NONE']}];
    
elseif strcmp(status_flags.normalization.status,'mon') %i.e. normalise data to standard monitor
    divider = foreimage.params1(vectors.monitor); divider_standard = status_flags.normalization.standard_monitor;
    if divider == 0;
        if status_flags.command_window.display_params == 1;
            disp(['Attempted divide by zero using this data normalisation scheme ''' status_flags.normalization.status '''']);
            disp('resetting divider = 1  in normalize_data.m');
        end
        divider = 1;
    else
        foreimage.units = [foreimage.units '\\ Std mon '];
        history = [history, {['Data Normalisation: Standard Monitor (' num2str(divider_standard) ') counts']}];
    end
    
elseif strcmp(status_flags.normalization.status,'time') %i.e. normalisation to standard time
    divider = foreimage.params1(vectors.aq_time); divider_standard = status_flags.normalization.standard_time;
    if divider == 0;
        if status_flags.command_window.display_params == 1;
            disp(['Attempted divide by zero using this data normalisation scheme ''' status_flags.normalization.status '''']);
            disp('resetting divider = 1  in normalize_data.m');
        end
        divider = 1;
    else
        foreimage.units = [foreimage.units '\\ Aqc time '];
        history = [history, {['Data Normalisation: Acquisition Time (' num2str(divider_standard) ') seconds']}];
    end

elseif strcmp(status_flags.normalization.status,'exposure_time') %i.e. normalisation to standard time
    divider = foreimage.params1(vectors.time); divider_standard = status_flags.normalization.standard_exposure_time;
    if divider == 0;
        if status_flags.command_window.display_params == 1;
            disp(['Attempted divide by zero using this data normalisation scheme ''' status_flags.normalization.status '''']);
            disp('resetting divider = 1  in normalize_data.m');
        end
        divider = 1;
    else
        foreimage.units = [foreimage.units '\\ Exp time '];
        history = [history, {['Data Normalisation: Exposure Time (' num2str(divider_standard) ') seconds']}];
    end
    
    
    
elseif strcmp(status_flags.normalization.status,'det') %i.e. detector counts
    divider = foreimage.params1(vectors.counts); %This is the parameter block counts (not actual array counts)
    %divider = foreimage.params(vectors.array_counts);  %This is the actual array counts
    divider_standard = status_flags.normalization.standard_detector;
    if divider == 0;
        if status_flags.command_window.display_params == 1;
            disp(['Attempted divide by zero using this data normalisation scheme ''' status_flags.normalization.status '''']);
            disp('resetting divider = 1  in normalize_data.m');
        end
        divider = 1;
    else
        foreimage.units = [foreimage.units '\\ Det Counts Norm: ' num2str(divider_standard,'%1g')];
        history = [history, {['Data Normalisation: Total Detector (' num2str(divider_standard) ') counts']}];
    end
    
elseif strcmp(status_flags.normalization.status,'detwin') %i.e. detector counts
    detwin = status_flags.normalization.detwin; %x1,x2,y1,y1
    divider = sum(sum(foreimage.data1(detwin(3):detwin(4),detwin(1):detwin(2))));
    divider_standard = status_flags.normalization.standard_detector;
    if divider == 0;
        if status_flags.command_window.display_params == 1;
            disp(['Attempted divide by zero using this data normalisation scheme ''' status_flags.normalization.status '''']);
            disp('resetting divider = 1  in normalize_data.m');
        end
        divider = 1;
    else
        foreimage.units = [foreimage.units '\\ Det Counts '];
        history = [history, {['Data Normalisation: Detector Window ' num2str(detwin) ' (' num2str(divider_standard) ') counts']}];
    end
    
elseif strcmp(status_flags.normalization.status,'parameter')
    divider = foreimage.params1(status_flags.normalization.param); divider_standard = 1;
    if divider == 0;
        if status_flags.command_window.display_params == 1;
            disp(['Attempted divide by zero using this data normalisation scheme ''' status_flags.normalization.status '''']);
            disp('resetting divider = 1  in normalize_data.m');
        end
        divider = 1;
    else
        foreimage.units = [foreimage.units '\\ Param' num2str(status_flags.normalization.param) ' '];
        history = [history, {['Data Normalisation: File Parameter #' num2str(status_flags.normalization.param) '  value ' num2str(divider_standard)]}];
    end
    
end

%Loop though the detectors and apply the normalisation
for det = 1:inst_params.detectors
    %Normalise the data to it's reference and up-scale by it's standard value
    if divider_standard == 0;
        if status_flags.command_window.display_params == 1;
            disp('Your divider standard value is set to zero')
            disp('Your data is being multiplied by zero! in normalize_data.m');
        end
    end
    foreimage.(['data' num2str(det)]) = (foreimage.(['data' num2str(det)])/divider)*divider_standard;
    foreimage.(['error' num2str(det)]) = (foreimage.(['error' num2str(det)])/divider)*divider_standard;
end



%Attenuator correction (based on parameters held params1 (first detector)
attenuator_scaler = 1; %Default Value for unnkown attenuator status
foreimage.attenuation = attenuator_scaler;  %Default Value for unnkown attenuator status
att_type = foreimage.params1(inst_params.vectors.att_type);
if isfield(inst_params.vectors,'att_status');
    att_status = foreimage.params1(inst_params.vectors.att_status);
else
    att_status = 1;
end

if isfield(inst_params.vectors,'col_app'); %D22's rectangular or circular aperture option - results in different attenuations
    col_app = foreimage.params1(inst_params.vectors.col_app);
else
    col_app = 0;
end

current_wav = foreimage.params1(inst_params.vectors.wav);
current_col = foreimage.params1(inst_params.vectors.col);

if att_status == 1 %i.e. if the attenuator is IN
    
    %Check the size of the attenuator matrix
    %1D - single value
    %2D - Wavelength dependent
    %3D - Wavelength and Collimation dependent
    
        if size(inst_params.att.ratio,1) == 1;  %Single value
        %attenuator_scaler = inst_params.att.ratio((col_app*10 + att_type+1)); %+1 is because the attenuator list starts at 0
        attenuator_scaler = inst_params.att.ratio((att_type+1)); %+1 is because the attenuator list starts at 0
        
    elseif size(inst_params.att.ratio,3) == 1; %Wavelength dependent
        attenuations = inst_params.att.ratio(:,(col_app*10 + att_type+2)); %+1 because attenuator list starts at 0, +1 because wavelength is the first entry
        wavelengths = inst_params.att.ratio(:,1);
        attenuator_scaler = interp1(wavelengths,attenuations,current_wav);
        
    elseif size(inst_params.att.ratio,3) > 1; %Wavelength and Collimation dependent
        if col_app > 0; sheet_index = 10; else sheet_index = 0; end
        att_matrix = inst_params.att.ratio(:,:,(sheet_index + att_type+1));
        temp = find(single(att_matrix(1,:)) ==single(current_col));
        att_wav = att_matrix(:,temp);
        attenuator_scaler = interp1(att_matrix(2:size(att_matrix,1),1),att_wav(2:length(att_wav)),current_wav);
        end
    
    foreimage.attenuation = attenuator_scaler;
    history = [history, {['Attenuator: ' num2str(att_type) ' is In.  Attenuation factor ' num2str(attenuator_scaler)]}];
    
else
    attenuator_scaler = 1;
    history = [history, {['Attenuator: ' num2str(att_type) ' is Out.  NO ATTENUATION ']}];
end


%Loop though the detectors and apply the attenuator correction
if strcmp(status_flags.normalization.auto_atten,'on');
    for det = 1:inst_params.detectors
        %Normalise the data to it's reference and up-scale by it's standard value
        if divider_standard == 0;
            if status_flags.command_window.display_params == 1;
                disp('Your divider standard value is set to zero')
                disp('Your data is being multiplied by zero! in normalize_data.m');
            end
        end
        foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)])*attenuator_scaler;
        foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)])*attenuator_scaler;
        history = [history, {['Attenuator: ' num2str(att_type) ' is In. Up-scaling data by ' num2str(attenuator_scaler)]}];
    end
end


%Attenuator 2 - D22 & D33 chopper attenuator
if isfield(inst_params.vectors,'att2')
    att2 = foreimage.params1(inst_params.vectors.att2);
    if att2 >1; status = 'In'; else status = 'Out'; end
    history = [history, {['Attenuator2: is ' status]}];
    if strcmp(status_flags.normalization.auto_atten,'on');
        for det = 1:inst_params.detectors
            foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)])*att2;
            foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)])*att2;
            history = [history, {['Attenuator2: Up-scaling data by ' num2str(att2)]}];
        end
    else
            history = [history, {['Attenuator2: No correction applied']}];
    end
end





%***** Count Scaler *****
if strcmp(status_flags.normalization.count_scaler,'on');
    count_scaler = status_flags.normalization.standard_count_scaler;
    foreimage.(['data' num2str(det)]) = (foreimage.(['data' num2str(det)]))*count_scaler;
    foreimage.(['error' num2str(det)]) = (foreimage.(['error' num2str(det)]))*count_scaler;
    foreimage.units = [foreimage.units '*' num2str(count_scaler) ' '];
    history = [history, {['Count Scaler :  Up-scaling data by ' num2str(count_scaler)]}];
end



foreimage.history = history;

    


