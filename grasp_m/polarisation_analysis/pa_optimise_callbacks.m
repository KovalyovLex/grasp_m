function pa_optimise_callbacks(to_do)

global status_flags
global grasp_handles
global grasp_env

switch to_do
    
    case 't1_edit'
        temp = get(gcbo,'string');
        value = str2num(temp);
        if not(isempty(value))
            status_flags.pa_optimise.pa_3he_t1 = value;
        end
        pa_optimise_callbacks('update_time');

    case 'max_time_edit'
        temp = get(gcbo,'string');
        value = str2num(temp);
        if not(isempty(value))
            status_flags.pa_optimise.pa_3he_time_max = value;
        end
        pa_optimise_callbacks('update_time');

    case 'close'
        grasp_handles.window_modules.pa_tools.optimise_window = [];
        
    case 'he_pol_edit'
        
        temp = get(gcbo,'string');
        value = str2num(temp);
        if not(isempty(value))
            status_flags.pa_optimise.pa_3he_pol = value/100;
        end
        pa_optimise_callbacks('update');
        
    case 'he_opacity_max'
        temp = get(gcbo,'string');
        value = str2num(temp);
        if not(isempty(value))
            status_flags.pa_optimise.pa_3he_opacity_max = value;
        end
        pa_optimise_callbacks('update');
        
        
    case 'he_pressure_edit'
        temp = get(gcbo,'string');
        value = str2num(temp);
        if not(isempty(value))
            status_flags.pa_optimise.pa_3he_pressure = value;
        end
        pa_optimise_callbacks('update_opacity');
        
    case 'he_wav_edit'
        temp = get(gcbo,'string');
        value = str2num(temp);
        if not(isempty(value))
            status_flags.pa_optimise.pa_3he_wavelength = value;
        end
        
    case 'he_pathlength_edit'
        temp = get(gcbo,'string');
        value = str2num(temp);
        if not(isempty(value))
            status_flags.pa_optimise.pa_3he_pathlength = value;
        end
        
    case 'he_optimum_opacity'
        temp = get(gcbo,'string');
        value = str2num(temp);
        if not(isempty(value))
            status_flags.pa_optimise.pa_3he_optimum = value;
        end
          pa_optimise_callbacks('update_time');
      
        
        
        
        
    case 'update'
        pa_optimise_callbacks('update_opacity');
        pa_optimise_callbacks('update_time');
        
    case 'update_opacity'
        
        
        opacity = 0:status_flags.pa_optimise.pa_3he_opacity_max/100:status_flags.pa_optimise.pa_3he_opacity_max;
        pa_cell = pa_cell_optimise(opacity,status_flags.pa_optimise.pa_3he_pol);
        
        %Determine Optimum
        [fom_max, opacity_index]  = max(pa_cell.fom_opacity);
        status_flags.pa_optimise.pa_3he_optimum = opacity(opacity_index);

        
        %delete previous plots (if they exist)
        if isfield(grasp_handles.window_modules.pa_optimise,'fom_curve');
            if ishandle(grasp_handles.window_modules.pa_optimise.fom_curve);
                delete(grasp_handles.window_modules.pa_optimise.fom_curve);
                grasp_handles.window_modules.pa_optimise.fom_curve = [];
                                delete(grasp_handles.window_modules.pa_optimise.transmission_curve);
                grasp_handles.window_modules.pa_optimise.transmission_curve = [];
                                delete(grasp_handles.window_modules.pa_optimise.pol_curve);
                grasp_handles.window_modules.pa_optimise.pol_curve = [];
                delete(grasp_handles.window_modules.pa_optimise.fom_line);
                grasp_handles.window_modules.pa_optimise.fom_line = [];
            end
        end
   
        
        %Plot P2T
        axes(grasp_handles.window_modules.pa_optimise.pa_optimise_plot);
        hold on
        grasp_handles.window_modules.pa_optimise.fom_curve = plot(opacity,pa_cell.fom_opacity,'.','color',[0.4, 0.4, 1]);
        %Plot Transmission
        axes(grasp_handles.window_modules.pa_optimise.pa_optimise_plot);
        hold on
        grasp_handles.window_modules.pa_optimise.transmission_curve = plot(opacity,pa_cell.t_total_opacity,'.y');
        %Plot Polarisation
        axes(grasp_handles.window_modules.pa_optimise.pa_optimise_plot);
        hold on
        grasp_handles.window_modules.pa_optimise.pol_curve = plot(opacity,pa_cell.pol_opacity,'.','color',[1, 0.2, 0.2]);
        axis auto;
        %Plot line at optimum
        hold on
        ax_lims = axis;
        grasp_handles.window_modules.pa_optimise.fom_line = line([status_flags.pa_optimise.pa_3he_optimum,status_flags.pa_optimise.pa_3he_optimum],[ax_lims(3),ax_lims(4)],'color',[0.4, 0.4, 1]);
        %Add legend
        h = legend(grasp_handles.window_modules.pa_optimise.pa_optimise_plot,'P^2T', 'Total Transmission', 'Polarisation');
        set(h,'fontsize',grasp_env.fontsize)

        
       
        
        
    case 'update_time'
        
        time = 0:status_flags.pa_optimise.pa_3he_time_max/100:status_flags.pa_optimise.pa_3he_time_max;
        pa_decay = pa_cell_transmission(status_flags.pa_optimise.pa_3he_optimum,status_flags.pa_optimise.pa_3he_pol,status_flags.pa_optimise.pa_3he_t1,time);
        
        %delete previous plots (if they exist)
        if isfield(grasp_handles.window_modules.pa_optimise,'pa_efficiency_time_curve_a1');
            if ishandle(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a1);
                delete(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a1);
                grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a1 = [];
                
                delete(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a2);
                grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a2 = [];
                
                delete(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a3);
                grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a3 = [];
            end
        end
        
        %delete previous plots (if they exist)
        if isfield(grasp_handles.window_modules.pa_optimise,'transmission_curve1');
            if ishandle(grasp_handles.window_modules.pa_optimise.transmission_curve1);
                delete(grasp_handles.window_modules.pa_optimise.transmission_curve1);
                grasp_handles.window_modules.pa_optimise.transmission_curve1 = [];
                delete(grasp_handles.window_modules.pa_optimise.transmission_curve2);
                grasp_handles.window_modules.pa_optimise.transmission_curve2 = [];
                delete(grasp_handles.window_modules.pa_optimise.transmission_curve3);
                grasp_handles.window_modules.pa_optimise.transmission_curve3 = [];
            end
        end
        
        %delete previous plots (if they exist)
        if isfield(grasp_handles.window_modules.pa_optimise,'pol_beam_curve');
            if ishandle(grasp_handles.window_modules.pa_optimise.pol_beam_curve);
                delete(grasp_handles.window_modules.pa_optimise.pol_beam_curve);
                grasp_handles.window_modules.pa_optimise.pol_beam_curve = [];
            end
        end
        
        
        
        
        %Plot Efficeincy 'a' vs. Time
        axes(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_plot);
        hold on
        grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a1 = plot(time,pa_decay.efficiency_a1,'.b');
        hold on
        grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a2 = plot(time,pa_decay.efficiency_a2,'.r');
        hold on
        grasp_handles.window_modules.pa_optimise.pa_efficiency_time_curve_a3 = plot(time,pa_decay.efficiency_a1+pa_decay.efficiency_a2,'.y');
        h = legend('Analyser Efficiency ''a''', 'Analyser InEfficiency ''(1-a)''','a + (1-a)');
        set(h,'fontsize',grasp_env.fontsize);
        axis auto;
        
        %Plot Transmission Plot vs. Time
        axes(grasp_handles.window_modules.pa_optimise.pa_transmission_time_plot);
        hold on
        grasp_handles.window_modules.pa_optimise.transmission_curve1 = plot(time,pa_decay.t_para_time,'.b');
        hold on
        grasp_handles.window_modules.pa_optimise.transmission_curve2 = plot(time,pa_decay.t_anti_time,'.r');
        hold on
        grasp_handles.window_modules.pa_optimise.transmission_curve3 = plot(time,pa_decay.t_total_time,'.y');
        h = legend('T-Parallel', 'T-Anti-Para', 'T-Total');
        set(h,'fontsize',grasp_env.fontsize);

        axis auto;
        
        %Plot Polarisation of Unpolarised Beam Plot vs. Time
        axes(grasp_handles.window_modules.pa_optimise.pa_polbeam_time_plot);
        hold on
        grasp_handles.window_modules.pa_optimise.pol_beam_curve = plot(time,pa_decay.pol_beam_time,'.b');
        axis auto;
        h = legend('Polarisation of Unpolarised beam');
        set(h,'fontsize',grasp_env.fontsize);

        
        
        
        
        
        
        
        
end

%Re-calculate derived parameters e.g. pressure from given path length and wavelength
status_flags.pa_optimise.pa_3he_pressure = status_flags.pa_optimise.pa_3he_optimum / (status_flags.pa_optimise.pa_3he_pathlength * status_flags.pa_optimise.pa_3he_wavelength);

%General Update

set(grasp_handles.window_modules.pa_optimise.pol_3he_edit,'string', num2str(status_flags.pa_optimise.pa_3he_pol*100));
set(grasp_handles.window_modules.pa_optimise.pol_optimum_edit,'string', num2str(status_flags.pa_optimise.pa_3he_optimum));
set(grasp_handles.window_modules.pa_optimise.pol_pressure_edit,'string', num2str(status_flags.pa_optimise.pa_3he_pressure));
set(grasp_handles.window_modules.pa_optimise.pol_pathlength_edit,'string', num2str(status_flags.pa_optimise.pa_3he_pathlength));
set(grasp_handles.window_modules.pa_optimise.pol_wavelength_edit,'string', num2str(status_flags.pa_optimise.pa_3he_wavelength));
set(grasp_handles.window_modules.pa_optimise.pol_opacity_edit,'string', num2str(status_flags.pa_optimise.pa_3he_opacity_max));
set(grasp_handles.window_modules.pa_optimise.pol_3he_t1_edit,'string', num2str(status_flags.pa_optimise.pa_3he_t1));
set(grasp_handles.window_modules.pa_optimise.pol_3he_time_max_edit,'string', num2str(status_flags.pa_optimise.pa_3he_time_max));

