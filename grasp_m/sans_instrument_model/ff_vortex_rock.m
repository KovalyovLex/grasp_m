function ff_vortex_rock(angle_start,step,angle_end)

global sample_config

%Automate SANS_Instrument_Model ff_vortex model

%Steps though the range of angles, calculates scattering, exports data
parameter = 'san';
i = findobj('tag',['sans_instrument_model_ff_param_' parameter]);


for angle = angle_start:step:angle_end
    set(i,'string',num2str(angle));
    sample_config.model(sample_config.model_number) = setfield(sample_config.model(sample_config.model_number),parameter,angle);

    
    %Re-calculate model
    sans_instrument_model_callbacks('single_shot_calculate');
    
    %Export Data
    sans_instrument_model_callbacks('export_2d_data');
end

    
    
    
