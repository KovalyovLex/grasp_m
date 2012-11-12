function update_data_summary

global grasp_handles
global displayimage
global inst_params


param_fields = {'det','detcalc','col','wav','bx','by','att_type','att_status','chpos','str','san','phi','sht','trs','sdi','treg','temp'};
for n = 1:length(param_fields);
    if isfield(grasp_handles.figure.data_summary_panel,param_fields{n});
        handle = getfield(grasp_handles.figure.data_summary_panel,param_fields{n});
        if ishandle(handle)
            if isfield(inst_params.vectors,param_fields{n});
                param_vector = getfield(inst_params.vectors,param_fields{n});
                if isnumeric(param_vector);
                    if not(isnan(param_vector))
                    if param_vector >=1 && param_vector <=128;
                        param_value = displayimage.params1(param_vector);
                        set(handle,'string',num2str(param_value));
                    end
                    end
                end
            end
        end
    end
end


