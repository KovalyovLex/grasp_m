function parameter_patch_callbacks(to_do)

global status_flags

switch to_do
    
    case 'parameter_edit'
        number = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.data.(['patch_parameter' num2str(number)]) = temp;
        end
        
    case 'patch_edit'
        number = get(gcbo,'userdata');
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.data.(['patch' num2str(number)]) = temp;
        end
        
    case 'replace_modify'
        number = get(gcbo,'userdata');
        status_flags.data.(['rep_mod' num2str(number)]) = get(gcbo,'value');
        
    case 'close'
        
    case 'parameter_check'
        status_flags.data.patch_check = get(gcbo,'value');
        
end
grasp_update
      
