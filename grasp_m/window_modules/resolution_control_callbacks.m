function resolution_control_callbacks(to_do)

global status_flags
global grasp_handles

switch to_do

    
    case 'xgrid_2d'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            if not(isodd(temp));temp = temp +1; end
            status_flags.resolution_control.xgrid_2d = temp;
        end
        set(gcbo,'string',num2str(status_flags.resolution_control.xgrid_2d));
        
    case 'ygrid_2d'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            if not(isodd(temp));temp = temp +1; end
            status_flags.resolution_control.ygrid_2d = temp;
        end
        set(gcbo,'string',num2str(status_flags.resolution_control.ygrid_2d));
        
    case 'sigma_extent_2d'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.resolution_control.sigma_extent_2d = temp;
        end
        set(gcbo,'string',num2str(status_flags.resolution_control.sigma_extent_2d));

    case 'close_window'
        grasp_handles.window_modules.resolution_control_window.window  =[];
        return
    
    case 'fwhmwidth'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.resolution_control.fwhmwidth = temp;
        end
        set(grasp_handles.window_modules.resolution_control_window.kernel_width,'string',num2str(status_flags.resolution_control.fwhmwidth));
        
    case 'finesse'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.resolution_control.finesse = temp;
        end
        set(grasp_handles.window_modules.resolution_control_window.finesse,'string',num2str(status_flags.resolution_control.finesse));
        
    case 'wavelength_check'
        status_flags.resolution_control.wavelength_check = get(gcbo,'value');
        
    case 'wavelength_shape'
        status_flags.resolution_control.wavelength_type = get(gcbo,'value');
        
    case 'divergence_check'
        status_flags.resolution_control.divergence_check = get(gcbo,'value');
        
    case 'divergence_shape'
        status_flags.resolution_control.divergence_type = get(gcbo,'value');
        
        %Hide Apetrue smearing if using measured beam profile
        if status_flags.resolution_control.divergence_type ==2; %Measured profile
            status = 'off';
        else
            status = 'on';
        end
        set(grasp_handles.window_modules.resolution_control_window.aperture_check,'visible',status)
        set(grasp_handles.window_modules.resolution_control_window.aperture_size,'visible',status)
        
        
    case 'aperture_check'
        status_flags.resolution_control.aperture_check = get(gcbo,'value');
        
    case 'aperture_size'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.resolution_control.aperture_size = temp/1e3;
        end
        
    case 'pixelation_check'
        status_flags.resolution_control.pixelation_check = get(gcbo,'value');

    case 'pixelation_shape'
        
    case 'binning_check'
        status_flags.resolution_control.binning_check = get(gcbo,'value');
        
    case 'binning_shape'
        
    case 'show_kernels_check'
        status_flags.resolution_control.show_kernels_check = get(gcbo,'value');
        
    case 'radio1'
        status_flags.resolution_control.convolution_type = 1;
        resolution_control_callbacks('update_radio_buttons');
        
    case 'radio2'
        status_flags.resolution_control.convolution_type = 2;
        resolution_control_callbacks('update_radio_buttons');
        
    case 'radio3'
        status_flags.resolution_control.convolution_type = 3;
        resolution_control_callbacks('update_radio_buttons');

    case 'update_radio_buttons'
        values = [0 0 0];
        values(status_flags.resolution_control.convolution_type) = 1;
        set(grasp_handles.window_modules.resolution_control_window.radio1,'value',values(1));
        set(grasp_handles.window_modules.resolution_control_window.radio2,'value',values(2));
        set(grasp_handles.window_modules.resolution_control_window.radio3,'value',values(3));
end

grasp_update
