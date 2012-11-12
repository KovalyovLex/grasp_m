function update_grasp_changer

global status_flags
global grasp_handles
global grasp_data
global inst_params

index_samples = data_index(1); %Index to the samples worksheet
index_emptycell = data_index(2);  %Index to the empty cell or scattering background worksheet
index_cadmium = data_index(3);  %Index to the cadmium scattering worksheet
index_transsample = data_index(4); %Index to the sample transmission worksheet
index_transcell = data_index(5);  %Index to the empty cell transmission worksheet
index_transempty = data_index(6);  %Index to the empty beam worksheet
index_i0 = data_index(8); %Index to the I0 beam worksheet


%Check if a I0 beam worksheet exists in Grasp Changer - if so, use this to normalise
temp = find(ismember(status_flags.grasp_changer.designation,'i0 beam'));
if not(isempty(temp))
    status_flags.calibration.beam_worksheet = 8; %Calibrate to I0 Beam
else
    status_flags.calibration.beam_worksheet = 6; %Calibrate to empty beam
end


%Calibration Options
set(grasp_handles.grasp_changer.calibrate_check,'value',status_flags.grasp_changer.calibrate_check);
if status_flags.grasp_changer.calibrate_check ==1;
    %Set up grasp so as to calibrate to direct beam
    status_flags.calibration.method = 'beam';
    status_flags.calibration.calibrate_check = 1;
    status_flags.calibration.solid_angle_check = 1;
    status_flags.calibration.det_eff_check = 1;
    status_flags.calibration.beam_flux_check = 1;
    status_flags.calibration.d22_tube_angle_check =1;
    status_flags.calibration.volume_normalise_check = 1;
    %calibration_callbacks('toggle_beam');
elseif status_flags.grasp_changer.calibrate_check ==0;
    status_flags.calibration.calibrate_check = 0;
end


%***** Update some Grasp Changer GUI graphic *****
%Number of samples
set(grasp_handles.grasp_changer.number_samples,'string',num2str(status_flags.grasp_changer.number_samples));

%Update displayed sample designations
for sample = 1:status_flags.grasp_changer.number_samples
    handle = grasp_handles.grasp_changer.config1_designation(sample);
    set(handle,'string',status_flags.grasp_changer.designation{sample});
end

%Update Config Beam Centre
for config = 1:status_flags.grasp_changer.number_configs
    centre = grasp_data(index_samples).cm1{config}.cm_pixels(1,:);
    cx_handle = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_cx']);
    cy_handle = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_cy']);
    set(cx_handle,'string',num2str(centre(1),'%0.3g'));
    set(cy_handle,'string',num2str(centre(2),'%0.3g'));
    
    %update beam centre window
    handle = getfield(grasp_handles.grasp_changer,['det_window_handle' num2str(config)]);
    det_window = getfield(status_flags.grasp_changer,['transmission_window' num2str(config)]);
    if not(isempty(handle)); set(handle,'string',num2str(det_window)); end
end

%Loop though all the availaible configurations
for config = 1:status_flags.grasp_changer.number_configs

    %Loop though all the samples in the table
    sample_counter = 1; %This counts the number of real samples (not empty cells, empty beams, cadmium etc)
    for sample = 1:status_flags.grasp_changer.number_samples

        %Get a bunch of handles that will be used to modify display
        iq_handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_iq']); %IQ button
        trans_handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans_value_handle']); %Displayed transmission value
        scatter_handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_scatter']); %Scattering numor handles
        transmission_handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_trans']); %Transmission numor handles
        thickness_handles = getfield(grasp_handles.grasp_changer,['config' num2str(config) '_sample_thickness']);
        all_iq_handles = getfield(grasp_handles.grasp_changer,'all_iq'); %All IQ button handles
        
        %Update sample IQ visibility / enable
        if strcmp(status_flags.grasp_changer.designation{sample},'sample') && sample_counter <= grasp_data(index_samples).dpth{config};
            iq_visible_status = 'on';
        else
            iq_visible_status = 'off';
        end
        set(iq_handles(sample),'enable',iq_visible_status);

        %All IQ visibility
        if config ==1;
            if strcmp(status_flags.grasp_changer.designation{sample},'sample')
                iq_visible_status = 'on';
            else
                iq_visible_status = 'off';
            end
            set(all_iq_handles(sample),'enable',iq_visible_status);
        end

       %Update Sample Transmissions
        if strcmp(status_flags.grasp_changer.designation{sample},'sample');
            temp = size(grasp_data(index_transsample).trans{config});
            if sample_counter <= temp(1);
                transmission = grasp_data(index_transsample).trans{config}(sample_counter,1); %ts and err_ts
            else transmission = [1];
            end
        elseif strcmp(status_flags.grasp_changer.designation{sample},'empty cell');
            transmission = grasp_data(index_transcell).trans{config}(1,1); %ts and err_ts
        elseif strcmp(status_flags.grasp_changer.designation{sample},'cadmium');
            transmission = 0;
        elseif strcmp(status_flags.grasp_changer.designation{sample},'empty beam');
            transmission = 1;
        elseif strcmp(status_flags.grasp_changer.designation{sample},'i0 beam');
            transmission = 1;
        else
            transmission = []; %for example for 'not defined'
        end
        set(trans_handles(sample),'string',num2str(transmission,'%0.4g'));


        %Scattering and Transmission Numors
        thickness_str = 'N/A'; thickness_enable = 'off';
        sample_enable = 'on'; %unless otherwise instructed below
        trans_enable = 'on'; %unless otherwise instructed below
        if strcmp(status_flags.grasp_changer.designation{sample},'sample');
            %Sample Numor
            if sample_counter <= grasp_data(index_samples).dpth{config}
                sample_numor_str = num2str(grasp_data(index_samples).params1{config}(inst_params.vectors.numor,sample_counter));
                sample_parsub_str = grasp_data(index_samples).subtitle{config}{sample_counter};
                sample_enable = 'on';
                
                %Sample thickness
                thickness = grasp_data(index_samples).thickness{config}(sample_counter);
                thickness_str = num2str(thickness);
                thickness_enable = 'on';
                
            elseif sample_counter == grasp_data(index_samples).dpth{config} + 1 && sum(sum(grasp_data(index_samples).data1{config}(:,:,sample_counter-1)))~=0 && sum(grasp_data(index_samples).params1{config}(:,sample_counter-1))~=0;
                sample_numor_str = '0'; sample_parsub_str = 'Waiting for Data';
                sample_enable = 'on';
            else
                sample_numor_str = 'N/A'; sample_parsub_str = '';
                sample_enable = 'off';
            end

            %Transmission Numor
            if sample_counter <= grasp_data(index_transsample).dpth{config}
                trans_numor_str = num2str(grasp_data(index_transsample).params1{config}(inst_params.vectors.numor,sample_counter));
                trans_parsub_str = grasp_data(index_transsample).subtitle{config}{sample_counter};
                trans_enable = 'on';
            elseif sample_counter == grasp_data(index_transsample).dpth{config} + 1 && sum(sum(grasp_data(index_transsample).data1{config}(:,:,sample_counter-1)))~=0 && sum(grasp_data(index_transsample).params1{config}(:,sample_counter-1))~=0;
                trans_numor_str = '0'; trans_parsub_str = 'Waiting for Data';
                trans_enable = 'on';
            else
                trans_numor_str = 'N/A'; trans_parsub_str = 'N/A';
                trans_enable = 'off';
            end

        elseif strcmp(status_flags.grasp_changer.designation{sample},'empty cell');
            sample_numor_str = num2str(grasp_data(index_emptycell).params1{config}(inst_params.vectors.numor,1));
            sample_parsub_str = grasp_data(index_emptycell).subtitle{config}{1};

            trans_numor_str = num2str(grasp_data(index_transcell).params1{config}(inst_params.vectors.numor,1));
            trans_parsub_str = grasp_data(index_transcell).subtitle{config}{1};

        elseif strcmp(status_flags.grasp_changer.designation{sample},'cadmium');
            sample_numor_str = num2str(grasp_data(index_cadmium).params1{config}(inst_params.vectors.numor,1));
            sample_parsub_str = grasp_data(index_cadmium).subtitle{config}{1};

            trans_enable = 'off';
            trans_numor_str = 'N/A'; trans_parsub_str = 'N/A';

        elseif strcmp(status_flags.grasp_changer.designation{sample},'empty beam');
            sample_enable = 'off';
            sample_numor_str = 'N/A'; sample_parsub_str = 'N/A';

            trans_numor_str = num2str(grasp_data(index_transempty).params1{config}(inst_params.vectors.numor,1));
            trans_parsub_str = grasp_data(index_transempty).subtitle{config}{1};
            
        elseif strcmp(status_flags.grasp_changer.designation{sample},'i0 beam');
            sample_enable = 'off';
            sample_numor_str = 'N/A'; sample_parsub_str = 'N/A';

            trans_numor_str = num2str(grasp_data(index_i0).params1{config}(inst_params.vectors.numor,1));
            trans_parsub_str = grasp_data(index_i0).subtitle{config}{1};
        else %For not defined worksheets
            sample_enable = 'off';
            sample_numor_str = 'N/A'; sample_parsub_str = 'N/A';
            trans_enable = 'off';
            trans_numor_str = 'N/A'; trans_parsub_str = '';
        end

        set(scatter_handles(sample),'string',sample_numor_str,'tooltipstring',sample_parsub_str,'enable',sample_enable);
        set(transmission_handles(sample),'string',trans_numor_str,'tooltipstring',trans_parsub_str,'enable',trans_enable);
        %set the thickness string
        if not(isempty(thickness_handles))
            if ishandle(thickness_handles(sample))
                set(thickness_handles(sample),'string',thickness_str,'enable',thickness_enable)
            end
        end

        if strcmp(status_flags.grasp_changer.designation{sample},'sample');
            sample_counter = sample_counter +1; %increment ready for next time
        end

        
    end



    %Transmission checkbox & Transmission Calc Button Enable
    if find(ismember(status_flags.grasp_changer.designation,'empty cell')) & find(ismember(status_flags.grasp_changer.designation,'empty beam'))
        trans_calc_enable = 'on';
    else
        trans_calc_enable = 'off';
    end

    if config == status_flags.grasp_changer.transmission_config;
        trans_check = 1; %checkbox
        trans_calc_string = 'T'; %Transmissions and Beamcentre
    else
        trans_check = 0;
        trans_calc_string = 'C'; %Beam centre only
    end

    set(grasp_handles.grasp_changer.trans_check_handles(config),'value',trans_check);
    set(grasp_handles.grasp_changer.trans_calc_handles(config),'string',trans_calc_string,'enable',trans_calc_enable);

end


