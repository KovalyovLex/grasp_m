function calibration_callbacks(to_do)

if nargin<1; to_do = '';end

global status_flags
global data
global grasp_handles
global grasp_data

switch to_do
    
    case 'calib_xsection_edit'
        value = str2num(get(gcbo,'string'));
        if not(isempty(value));
            index = data_index(99);
            grasp_data(index).calibration_xsection{status_flags.calibration.det_eff_nmbr} = value;
        end
    
    case 'det_eff_selector'
        value = get(gcbo,'value');
        status_flags.calibration.det_eff_nmbr = value;
    
    case 'direct_beam_selector'
        value = get(gcbo,'value');
        userdata = get(gcbo,'userdata');
        status_flags.calibration.beam_worksheet = userdata(value);
        
    case 'toggle_none'
        status_flags.calibration.method = 'none';
        set(grasp_handles.window_modules.calibration.none_radio,'value',1);
        set(grasp_handles.window_modules.calibration.beam_radio,'value',0);
        set(grasp_handles.window_modules.calibration.water_radio,'value',0);
        
        %Turn off all the water&beam calibration stuff
        fields = fieldnames(grasp_handles.window_modules.calibration.waterbeam);
        for n = 1:length(fields);
            handle = getfield(grasp_handles.window_modules.calibration.waterbeam,fields{n});
            set(handle(ishandle(handle)),'visible','off');
        end
        
        %Turn off all the water calibration stuff
        if isfield(grasp_handles.window_modules.calibration,'water')
            fields = fieldnames(grasp_handles.window_modules.calibration.water);
            for n = 1:length(fields);
                handle = getfield(grasp_handles.window_modules.calibration.water,fields{n});
                set(handle(ishandle(handle)),'visible','off');
            end
        end
        
        %Turn off all the direct beam calibration stuff
        fields = fieldnames(grasp_handles.window_modules.calibration.beam);
        for n = 1:length(fields);
            handle = getfield(grasp_handles.window_modules.calibration.beam,fields{n});
            set(handle(ishandle(handle)),'visible','off');
        end
        
        
    case 'toggle_water'
        status_flags.calibration.method = 'water';
        set(grasp_handles.window_modules.calibration.none_radio,'value',0);
        set(grasp_handles.window_modules.calibration.beam_radio,'value',0);
        set(grasp_handles.window_modules.calibration.water_radio,'value',1);
        
        %Turn on all the water&beam calibration stuff
        fields = fieldnames(grasp_handles.window_modules.calibration.waterbeam);
        for n = 1:length(fields);
            handle = getfield(grasp_handles.window_modules.calibration.waterbeam,fields{n});
            set(handle(ishandle(handle)),'visible','on');
        end
        
        %Turn off all the direct beam calibration stuff
        fields = fieldnames(grasp_handles.window_modules.calibration.beam);
        for n = 1:length(fields);
            handle = getfield(grasp_handles.window_modules.calibration.beam,fields{n});
            set(handle(ishandle(handle)),'visible','off');
        end
        
        %Turn on all the water calibration crap
        water_fields = fieldnames(grasp_handles.window_modules.calibration.water);
        for n = 1:length(water_fields);
            handle = getfield(grasp_handles.window_modules.calibration.water,water_fields{n});
            set(handle(ishandle(handle)),'visible','on');
        end
        
    case 'toggle_beam'
        status_flags.calibration.method = 'beam';
        set(grasp_handles.window_modules.calibration.none_radio,'value',0);
        set(grasp_handles.window_modules.calibration.beam_radio,'value',1);
        set(grasp_handles.window_modules.calibration.water_radio,'value',0);
        
        %Turn on all the water&beam calibration stuff
        fields = fieldnames(grasp_handles.window_modules.calibration.waterbeam);
        for n = 1:length(fields);
            handle = getfield(grasp_handles.window_modules.calibration.waterbeam,fields{n});
            set(handle(ishandle(handle)),'visible','on');
        end
        
        %Turn on all the direct beam calibration stuff
        fields = fieldnames(grasp_handles.window_modules.calibration.beam);
        for n = 1:length(fields);
            handle = getfield(grasp_handles.window_modules.calibration.beam,fields{n});
            set(handle(ishandle(handle)),'visible','on');
        end
        
        %Turn off all the water calibration crap
        if isfield(grasp_handles.window_modules.calibration,'water')
            water_fields = fieldnames(grasp_handles.window_modules.calibration.water);
            for n = 1:length(water_fields);
                handle = getfield(grasp_handles.window_modules.calibration.water,water_fields{n});
                set(handle(ishandle(handle)),'visible','off');
            end
        end
        
    case 'det_eff'
        status_flags.calibration.det_eff_check = not(status_flags.calibration.det_eff_check);
        set(grasp_handles.window_modules.calibration.det_eff_chk,'value',status_flags.calibration.det_eff_check);
        
    case 'd22_tube_angle_correction'
        status_flags.calibration.d22_tube_angle_check = not(status_flags.calibration.d22_tube_angle_check);
        set(grasp_handles.window_modules.calibration.d22_tube_angle_chk,'value',status_flags.calibration.d22_tube_angle_check);
        
        
    case 'sample_volume_chk'
        status_flags.calibration.volume_normalize_check = not(status_flags.calibration.volume_normalize_check);
        set(grasp_handles.window_modules.calibration.waterbeam.volume_chk,'value',status_flags.calibration.volume_normalize_check);
        
    case 'pixel_solid_angle_chk'
        status_flags.calibration.solid_angle_check = not(status_flags.calibration.solid_angle_check);
        set(grasp_handles.window_modules.calibration.waterbeam.solid_angle_chk,'value',status_flags.calibration.solid_angle_check);
        
    case 'beam_flux_chk'
        status_flags.calibration.beam_flux_check = not(status_flags.calibration.beam_flux_check);
        set(grasp_handles.window_modules.calibration.beam.beamflux_chk,'value',status_flags.calibration.beam_flux_check);
        
    case 'flux_col_check'
        status_flags.calibration.flux_col_check = not(status_flags.calibration.flux_col_check);
        set(grasp_handles.window_modules.calibration.water.fluxcol_check,'value',status_flags.calibration.flux_col_check);
        
    case 'solid_angle_check'
        status_flags.calibration.solid_angle_check = not(status_flags.calibration.solid_angle_check);
        set(grasp_handles.window_modules.calibration.waterbeam.solid_angle_chk,'value',status_flags.calibration.solid_angle_check);
        
    case 'calib_scalar_check'
        status_flags.calibration.scalar_check = not(status_flags.calibration.scalar_check);
        set(grasp_handles.window_modules.calibration.water.water_check,'value',status_flags.calibration.scalar_check);
        
    case 'calib_xsection'
        status_flags.calibration.xsection_check = not(status_flags.calibration.xsection_check);
        set(grasp_handles.window_modules.calibration.water.cal_xsection_check,'value',status_flags.calibration.xsection_check);
        
    case 'calib_xsection_edit'
        %Check entered value is numberic first.
        index = data_index(99);
        value = str2num(get(gcbo,'string'));
        if isempty(value);
            set(gcbo,'string',num2str(data(index).calib_xsection{1})); %i.e. re-put the old value
        else
            data(index).calib_xsection{1} = value; %get new value
        end
        
        
    case 'close'
        grasp_handles.window_modules.calibration.window = [];
        return
        
        
        
    case 'sample_area_edit'
        %Check entered value is numberic first.
        value = str2num(get(gcbo,'string'));
        if isempty(value);
            set(gcbo,'string',num2str(status_flags.calibration.sample_area)); %i.e. re-put the old value
        else
            status_flags.calibration.sample_area = value; %get new value
        end
        
    case 'sample_thickness_edit'
        %Sample thickness entered here now gets stored in the main Data
        %array next to the scattering data
        
        %Check entered value is numberic first.
        value = str2num(get(gcbo,'string'));
        if not(isempty(value));
            samples_index = data_index(1); %Thicknesses are always stored with the samples data, regardless of what is displayed
            real_depth = status_flags.selector.fd - data(samples_index).sum_allow;
            if real_depth <1; real_depth = 1;end %for when sum is displayed
            data(samples_index).thickness{status_flags.selector.fn}(real_depth) = value;
        end
        grasp_update
        
    case 'standard_area_edit'
        %Check entered value is numberic first.
        value = str2num(get(gcbo,'string'));
        if isempty(value);
            set(gcbo,'string',num2str(status_flags.calibration.standard_area)); %i.e. re-put the old value
        else
            status_flags.calibration.standard_area = value; %get new value
        end
        
    case 'standard_thickness_edit'
        %Check entered value is numberic first.
        value = str2num(get(gcbo,'string'));
        if isempty(value);
            set(gcbo,'string',num2str(status_flags.calibration.standard_thickness)); %i.e. re-put the old value
        else
            status_flags.calibration.standard_thickness = value; %get new value
        end
        
        
        
end

grasp_update


