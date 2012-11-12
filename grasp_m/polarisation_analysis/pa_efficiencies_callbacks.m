function pa_efficiencies_callbacks(to_do)

global status_flags
global grasp_handles
global grasp_data
global displayimage

switch to_do
    
    case 'grab_fit_params'
        
        if isfield(status_flags.fitter,'function_info_1d')
            pnames = [{'p'}, {'opacity'}, {'p0'}, {'t1'}, {'t0'}];
            for m = 1:length(pnames);
                for n = 1:length(status_flags.fitter.function_info_1d.variable_names);
                    if strcmp(status_flags.fitter.function_info_1d.variable_names{n},pnames{m})
                        status_flags.pa_optimise.parameters.([pnames{m}]) = [status_flags.fitter.function_info_1d.values(n), status_flags.fitter.function_info_1d.err_values(n)];
                    end
                end
            end
        end
        
        
    case 'phi_time_max_edit'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.pa_optimise.phi_time_max = temp;
        end
        
    case 'p_edit'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.pa_optimise.parameters.p = [temp, 0];
        end
        
    case 'fp_edit'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.pa_optimise.parameters.fp = [temp, 0];
        end
        
    case 'fa_edit'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.pa_optimise.parameters.fa = [temp, 0];
        end
        
    case 'opacity_edit'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.pa_optimise.parameters.opacity = [temp, 0];
        end
        
    case 'hepol_edit'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.pa_optimise.parameters.p0 = [temp, 0];
        end
        
    case 't1_edit'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.pa_optimise.parameters.t1 = [temp, 0];
        end
        
    case 't0_edit'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.pa_optimise.parameters.t0 = [temp, 0];
        end
        
        
        
    case 'use_fpfa'
        status_flags.pa_optimise.parameters.fp = status_flags.pa_optimise.fp_av;
        status_flags.pa_optimise.parameters.fa = status_flags.pa_optimise.fa_av;
        
        
    case 'close'
        grasp_handles.window_modules.pa_tools.efficiencies_window = [];
        
    case 'fit_combined_efficiency'
        %Re-plot the displayed combined efficiency in a Grasp plot figure
        %ready for fitting
        
        %***** Plot Phi vs. Time ****
        plot_data = [rot90(status_flags.pa_optimise.efficiencies.normalised_time_hrs),rot90(status_flags.pa_optimise.efficiencies.phi),rot90(status_flags.pa_optimise.efficiencies.err_phi)]; 
        column_format = 'xye';
        column_labels = ['Time [hrs]  ' char(9) 'Phi       ' char(9) 'Err_Phi  '];
        export_data = plot_data;
        
        plot_info = struct(....
            'plot_type','plot',....
            'hold_graph',0,....
            'plot_title',['Combined Polariser--Analyser Efficiency, Phi'],....
            'x_label',['Time [hrs]'],....
            'y_label','Phi',....
            'legend_str','',....
            'export_data',export_data,....
            'column_labels',column_labels);
        grasp_plot(plot_data,column_format,plot_info);

        %Open Curve fitter
        grasp_plot_fit_window
        %Set grasp plot fitter to the correct function
        for n = 1:length(status_flags.fitter.fn_list1d)
            if strcmp(status_flags.fitter.fn_list1d{n},'3He Combined Polariser Analyser Efficiency, Phi')
                status_flags.fitter.fn1d = n;
                set(grasp_handles.window_modules.curve_fit1d.fn_selector,'value',n);
                grasp_plot_fit_callbacks('retrieve_fn');
                grasp_plot_fit_callbacks('update_curve_fit_window');
            end
        end
        return
        
        
        
    case 'calculate_efficiencies'
        
        %Run though all the depths and collect the stats (normalised counts & errors)
        %(at the moment just over the full detector)
        
        %Turn off updating
        remember_display_params_status = status_flags.command_window.display_params; %Turn off command window parameter update for the boxing
        status_flags.command_window.display_params= 0;
        status_flags.display.refresh = 0; %Turn off the 2D display for speed
        
        %Find the worksheet we are dealing with
        userdata = get(grasp_handles.window_modules.pa_tools.pa_efficiencies_worksheet_popup,'userdata');
        wks = userdata(status_flags.pa_optimise.pa_efficiency_wks);
        
        index = data_index(wks);
        total_depth = grasp_data(index).dpth{1};
        depth_start = status_flags.selector.fd; %remember the initial foreground depth
        
        disp(' ')
        disp(['Collecting Total intensities & time though depth']);
        box_intensities = [];
        disp(['Depth #:  Mid-point Time  Total Counts (after Normalisation):   Error Counts:']);
        
        for n = 1:total_depth
            message_handle = grasp_message(['Extracting Total intensities Depth: ' num2str(n) ' of ' num2str(total_depth)]);
            status_flags.selector.fd = n+grasp_data(index).sum_allow;
            
            main_callbacks('depth_scroll'); %Scroll all linked depths and update
            
            det = 1;
            box_sum = (sum(sum(displayimage.(['data' num2str(det)]))));
            box_sum_error = (sqrt(sum(sum((displayimage.(['error' num2str(det)])).^2))));
            
            %Calculate mid-point-time
            temp1 = datenum([displayimage.info.start_date displayimage.info.start_time]);
            temp2 = datenum([displayimage.info.end_date displayimage.info.end_time]);
            mid_point_time = temp1+(temp2-temp1)/2;
            box_intensities(n,:) = [mid_point_time, box_sum, box_sum_error];
            
            %Display results in the comment window
            disp([num2str(n) char(9) datestr(mid_point_time) char(9) num2str(box_sum) char(9) num2str(box_sum_error)])
        end
        
        %Set selector back to where it was in the beginning
        status_flags.selector.fd = depth_start;
        main_callbacks('depth_scroll'); %Scroll all linked depths and update
        delete(message_handle);
        
        %Turn on command window parameter update for the boxing
        status_flags.command_window.display_params = remember_display_params_status;
        %Turn on the 2D display
        status_flags.display.refresh = 1;
        disp(' ');
        
        %Calculate Efficiencies
        status_flags.pa_optimise.efficiencies = [];
        for n = 1:length(box_intensities)/4;
            temp = pa_efficiencies([box_intensities(1+(n-1)*4,2), box_intensities(1+(n-1)*4,3)],[box_intensities(2+(n-1)*4,2),box_intensities(2+(n-1)*4,3)],[box_intensities(3+(n-1)*4,2), box_intensities(3+(n-1)*4,3)],[box_intensities(4+(n-1)*4,2),box_intensities(4+(n-1)*4,3)]);
            
            %re-order data into status_flags
            status_flags.pa_optimise.efficiencies.fr_p(n) = temp.fr_p;
            status_flags.pa_optimise.efficiencies.err_fr_p(n) = temp.err_fr_p;
            status_flags.pa_optimise.efficiencies.fr_a(n) = temp.fr_a;
            status_flags.pa_optimise.efficiencies.err_fr_a(n) = temp.err_fr_a;
            status_flags.pa_optimise.efficiencies.fp(n) = temp.fp;
            status_flags.pa_optimise.efficiencies.err_fp(n) = temp.err_fp;
            status_flags.pa_optimise.efficiencies.fa(n) = temp.fa;
            status_flags.pa_optimise.efficiencies.err_fa(n) = temp.err_fa;
            status_flags.pa_optimise.efficiencies.phi(n) = temp.phi;
            status_flags.pa_optimise.efficiencies.err_phi(n) = temp.err_phi;
            status_flags.pa_optimise.efficiencies.absolute_time(n) = mean([box_intensities(1+(n-1)*4,1),box_intensities(2+(n-1)*4,1),box_intensities(3+(n-1)*4,1),box_intensities(4+(n-1)*4,1)]);
        end
        status_flags.pa_optimise.efficiencies.normalised_time_hrs = (status_flags.pa_optimise.efficiencies.absolute_time - status_flags.pa_optimise.efficiencies.absolute_time(1))*24;
        
        
        %Display Efficiency Data vs Time in the Text window
        disp('    Time              Fr_p     F_p      Fr_a      F_a      Phi');
        
        
        %Calculate average efficiencies
        fp_list = []; fa_list = [];
        for n = 1:length(status_flags.pa_optimise.efficiencies.fp)
            disp([datestr(status_flags.pa_optimise.efficiencies.absolute_time(n)) '  ' num2str(status_flags.pa_optimise.efficiencies.fr_p(n),'%5g') '  ' num2str(status_flags.pa_optimise.efficiencies.fp(n),'%5g') '  ' num2str(status_flags.pa_optimise.efficiencies.fr_a(n),'%5g') '  ' num2str(status_flags.pa_optimise.efficiencies.fa(n),'%5g') '  ' num2str(status_flags.pa_optimise.efficiencies.phi(n),'%5g')])
            fp_list(n,:) = [status_flags.pa_optimise.efficiencies.fp(n), status_flags.pa_optimise.efficiencies.err_fp(n)];
            fa_list(n,:) = [status_flags.pa_optimise.efficiencies.fa(n), status_flags.pa_optimise.efficiencies.err_fa(n)];
        end
        status_flags.pa_optimise.fp_av = average_error(fp_list);
        status_flags.pa_optimise.fa_av = average_error(fa_list);
        
        
        
        pa_efficiencies_callbacks('update_plots');
        
        
    case 'update_plots'
        
        %Update Plots if previous efficiency data exists in status_flags
        if isfield(status_flags.pa_optimise,'efficiencies')
            if isfield(status_flags.pa_optimise.efficiencies,'fp')
                
                %Efficiency plot
                %delete previous plots (if they exist)
                if isfield(grasp_handles.window_modules.pa_efficiencies,'fp_curve');
                    if ishandle(grasp_handles.window_modules.pa_efficiencies.fp_curve);
                        delete(grasp_handles.window_modules.pa_efficiencies.fp_curve);
                        grasp_handles.window_modules.pa_efficiencies.fp_curve = [];
                        delete(grasp_handles.window_modules.pa_efficiencies.fa_curve);
                        grasp_handles.window_modules.pa_efficiencies.fa_curve = [];
                    end
                end
                
                %Plot Fp & Fa
                axes(grasp_handles.window_modules.pa_efficiencies.fp_plot);
                hold on
                grasp_handles.window_modules.pa_efficiencies.fp_curve = errorbar(status_flags.pa_optimise.efficiencies.normalised_time_hrs,status_flags.pa_optimise.efficiencies.fp,status_flags.pa_optimise.efficiencies.err_fp,'.','color','y');
                hold on
                grasp_handles.window_modules.pa_efficiencies.fa_curve = errorbar(status_flags.pa_optimise.efficiencies.normalised_time_hrs,status_flags.pa_optimise.efficiencies.fa,status_flags.pa_optimise.efficiencies.err_fa,'.','color','r');
                legend('Fp','Fa');
                axis auto;
                
                
                %FR plot
                %delete previous plots (if they exist)
                if isfield(grasp_handles.window_modules.pa_efficiencies,'fr_p_curve');
                    if ishandle(grasp_handles.window_modules.pa_efficiencies.fr_p_curve);
                        delete(grasp_handles.window_modules.pa_efficiencies.fr_p_curve);
                        grasp_handles.window_modules.pa_efficiencies.fr_p_curve = [];
                        delete(grasp_handles.window_modules.pa_efficiencies.fr_a_curve);
                        grasp_handles.window_modules.pa_efficiencies.fr_a_curve = [];
                    end
                end
                
                %Plot FR_p
                axes(grasp_handles.window_modules.pa_efficiencies.fr_plot);
                hold on
                grasp_handles.window_modules.pa_efficiencies.fr_p_curve = errorbar(status_flags.pa_optimise.efficiencies.normalised_time_hrs,status_flags.pa_optimise.efficiencies.fr_p,status_flags.pa_optimise.efficiencies.err_fr_p,'.','color','y');
                hold on
                grasp_handles.window_modules.pa_efficiencies.fr_a_curve = errorbar(status_flags.pa_optimise.efficiencies.normalised_time_hrs,status_flags.pa_optimise.efficiencies.fr_a,status_flags.pa_optimise.efficiencies.err_fr_a,'.','color','r');
                legend('Fr-p (RF Flipper)','Fr-a 3He Flipper');
                axis auto;
                
                
                %Combined Polariser & Analyser efficiency, Phi
                %delete previous plots (if they exist)
                if isfield(grasp_handles.window_modules.pa_efficiencies,'phi_curve');
                    if ishandle(grasp_handles.window_modules.pa_efficiencies.phi_curve);
                        delete(grasp_handles.window_modules.pa_efficiencies.phi_curve);
                        grasp_handles.window_modules.pa_efficiencies.phi_curve = [];
                    end
                end
                
                %Plot Combined efficency
                axes(grasp_handles.window_modules.pa_efficiencies.phi_plot);
                hold on
                grasp_handles.window_modules.pa_efficiencies.phi_curve = errorbar(status_flags.pa_optimise.efficiencies.normalised_time_hrs,status_flags.pa_optimise.efficiencies.phi,status_flags.pa_optimise.efficiencies.err_phi,'o','color',[1, 1, 1]);
                axis auto;
            end
        end
end


%Update some displayed Values
%Display Start time of first callibration run
set(grasp_handles.window_modules.pa_tools.pa_efficiencies_start_time_edit,'string',[datestr(status_flags.pa_optimise.efficiencies.absolute_time(1))]);
%Display average Fp & Fa
set(grasp_handles.window_modules.pa_tools.pa_efficiencies_fp_average,'string',['Fp :  ' num2str(status_flags.pa_optimise.fp_av(1))  '  +-  ' num2str(status_flags.pa_optimise.fp_av(2))]);
set(grasp_handles.window_modules.pa_tools.pa_efficiencies_fa_average,'string',['Fa :  ' num2str(status_flags.pa_optimise.fa_av(1))  '  +-  ' num2str(status_flags.pa_optimise.fa_av(2))]);

%Polariser
set(grasp_handles.window_modules.pa_tools.parameter_p_edit,'String',num2str(status_flags.pa_optimise.parameters.p(1)));
%RF Flipper
set(grasp_handles.window_modules.pa_tools.parameter_fp_edit,'String',num2str(status_flags.pa_optimise.parameters.fp(1)));
%3He Flipper
set(grasp_handles.window_modules.pa_tools.parameter_fa_edit,'String',num2str(status_flags.pa_optimise.parameters.fa(1)));
%3He Opacity
set(grasp_handles.window_modules.pa_tools.parameter_opacity_edit,'String',num2str(status_flags.pa_optimise.parameters.opacity(1)));
%3He Initial Polarisation
set(grasp_handles.window_modules.pa_tools.parameter_3hepol_edit,'String',num2str(status_flags.pa_optimise.parameters.p0(1)));
%3He Decay T1
set(grasp_handles.window_modules.pa_tools.parameter_t1_edit,'String',num2str(status_flags.pa_optimise.parameters.t1(1)));
%3He Time Offset T0
set(grasp_handles.window_modules.pa_tools.parameter_t0_edit,'String',num2str(status_flags.pa_optimise.parameters.t0(1)));

%Modeled Combined efficiency
time = 0:status_flags.pa_optimise.phi_time_max/100:status_flags.pa_optimise.phi_time_max;
phi = pa_combined_efficiency(time,status_flags.pa_optimise.parameters.p(1),status_flags.pa_optimise.parameters.opacity(1),status_flags.pa_optimise.parameters.p0(1),status_flags.pa_optimise.parameters.t1(1),status_flags.pa_optimise.parameters.t0(1));

%delete previous plots (if they exist)
if isfield(grasp_handles.window_modules.pa_efficiencies,'phi_model_curve');
    if ishandle(grasp_handles.window_modules.pa_efficiencies.phi_model_curve);
        delete(grasp_handles.window_modules.pa_efficiencies.phi_model_curve);
        grasp_handles.window_modules.pa_efficiencies.phi_model_curve = [];
    end
end

%Plot Combined efficency
axes(grasp_handles.window_modules.pa_efficiencies.phi_plot);
hold on
grasp_handles.window_modules.pa_efficiencies.phi_model_curve = plot(time,phi,'-y');
axis auto;








