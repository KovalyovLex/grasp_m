function grasp_plot_callbacks(to_do,option)

global status_flags


%Some useful handles to the current Grasp_Plot
curve_handles = [];
grasp_plot_figure = findobj('tag','grasp_plot');
if not(isempty(grasp_plot_figure));
    grasp_plot_figure = grasp_plot_figure(1);
    grasp_plot_handles = get(grasp_plot_figure,'userdata');
    curve_handles = get(grasp_plot_handles.axis,'userdata');
end


%General update of the plot

switch to_do
    
    case 're_bin_curves'
        %This code is the same (almost) as found in 'radial_average_callbacks'
        
        n_curves = length(curve_handles);
        
        %Compile all data points into a single list ready for re-binning
        iq_store = []; res_kernel_store_weight = []; res_kernel_store_x = [];
        for n = 1:n_curves
            plot_info = get(curve_handles{n}(1),'userdata');
            %note:  exdat is just the gaussian equivalent or classic FWHM gaussian resolution
            iq_store = [iq_store; [plot_info.plot_data.xdat, plot_info.plot_data.ydat, plot_info.plot_data.edat, plot_info.plot_data.exdat]];
            res_kernel_store_weight = [res_kernel_store_weight, plot_info.plot_data.resolution_kernels.weight];
            res_kernel_store_x = [res_kernel_store_x, plot_info.plot_data.resolution_kernels.x];
        end
        
        %Calculate delta_q / q for the iq list
        iq_store(:,5) = iq_store(:,4)./iq_store(:,1);
        data_count_max = length(iq_store);

        q_min = min(iq_store(:,1)); q_max = max(iq_store(:,1));
        n_bins =  status_flags.analysis_modules.rebin.n_bins;
        
        %Bin Spacing
        if strcmp(status_flags.analysis_modules.rebin.bin_spacing,'log');
            %Log Bin Spacing
            logq_span =  ceil(log10(q_max)) - floor(log10(q_min));
            bin_step = logq_span/n_bins;
            log_edges = floor(log10(q_min)):bin_step:ceil(log10(q_max));
            bin_edges = 10.^log_edges;
        elseif strcmp(status_flags.analysis_modules.rebin.bin_spacing,'linear');
            %Linear Bin Spacing
            q_span = q_max - q_min;
            bin_step = q_span /n_bins;
            bin_edges = q_min:bin_step:q_max;
        end
        
        %delta_q/q regrouping bands
        dqq =  status_flags.analysis_modules.rebin.regroup_bands;
        
        %Display parameters in command window
        disp(' ')
        disp('Re-grouping Data')
        disp(['Bin spacing = '  status_flags.analysis_modules.rebin.bin_spacing]);
        disp(['# bins = ' num2str(status_flags.analysis_modules.rebin.n_bins)]);
        disp(['dq/q regouping bands = ' num2str(status_flags.analysis_modules.rebin.regroup_bands)]);
        disp(['Weighting average to di/i^' num2str(status_flags.analysis_modules.rebin.dii_power)]);
        disp(['Weighting average to dq/q^' num2str(status_flags.analysis_modules.rebin.dqq_power)]);
        disp(' ')
        
        data_count = 0;
        for n = 1:(length(dqq)-1);
            %find IQ points that fall within the resolution band
            temp = find(iq_store(:,5)>= dqq(n) & iq_store(:,5)<dqq(n+1));
            if not(isempty(temp));
                
                data_count = data_count + numel(temp);
                
                iq_store2 = iq_store(temp,:); %List of IQ points within the resolution band
                
                res_kernels.x = res_kernel_store_x(temp);
                res_kernels.weight = res_kernel_store_weight(temp);
                
                
                temp = tof_rebin(iq_store2,res_kernels,bin_edges);
                
                new_plot_info.plot_data.resolution_kernels.weight = temp.res_kernels.weight;
                new_plot_info.plot_data.resolution_kernels.x = temp.res_kernels.x;
                new_plot_info.plot_data.resolution_kernels.history = [];
                
                new_plot_info.plot_data.xdat = temp.array(:,1);
                new_plot_info.plot_data.ydat = temp.array(:,2);
                new_plot_info.plot_data.edat = temp.array(:,3);
                plot_info.plot_data.exdat = temp.res_kernels.fwhm; %Gaussian Equivalent of the weighted averaged kernels

                %Use old history to pass through
                new_plot_info.history = plot_info.history;
                
                
                
                if strcmp(status_flags.subfigure.show_resolution,'on')
                    column_format = 'xyhe'; %Show resolution
                    %Note, need to swap colums around for the ploterr fn.  Need [x,y,err_x,err_y]
                    plotdata = [new_plot_info.plot_data.xdat,new_plot_info.plot_data.ydat,new_plot_info.plot_data.exdat,new_plot_info.plot_data.edat];
                else
                    column_format = 'xye'; %Do not show resolution.
                    %Note, uses Matlab errorbar fn.  Need [x,y,err_y]
                    plotdata = [new_plot_info.plot_data.xdat,new_plot_info.plot_data.ydat,new_plot_info.plot_data.edat];
                end
                
                new_plot_info.export_data = plotdata; % replace the export data with the new math op data
                
                %Check if over_plotting
                if strcmp(plot_info.hold_graph,'off');
                    new_plot_info.plot_title = [plot_info.plot_title ' : Rebinned'];
                else
                    new_plot_info.plot_title = plot_info.plot_title;
                end
                new_plot_info.hold_graph = 'on';
                new_plot_info.legend_str = [num2str(dqq(n)) '-' num2str(dqq(n+1)) ' dq/q Resolution'];
                new_plot_info.x_label = plot_info.x_label;
                new_plot_info.y_label = plot_info.y_label;

                grasp_plot(plotdata,column_format,new_plot_info);
            end
        end
        redundancy = 1-data_count/data_count_max;
        disp(['Re-bin data redundancy: ' num2str(redundancy*100) '[%]'])
        disp([num2str(data_count) ' counts used'])
        disp([num2str(data_count_max-data_count) ' counts thrown in the dustbin'])
            
        
    case 'moments'
        disp(' ');
        disp(['***** Sum, Average, Centre of Mass, Standard Deviation, Skewness & Kurtosis *****']);
        n_curves = length(curve_handles);
        for n = 1:n_curves
            
            plot_info = get(curve_handles{n}(1),'userdata');
            x = plot_info.plot_data.xdat;

            %Chop data to only use zoomed region
            xlim = get(grasp_plot_handles.axis,'xlim');
            data_mask = x > xlim(1) & x < xlim(2);
            temp = find(data_mask);
            x = x(temp);
            y = plot_info.plot_data.ydat(temp);
            if isfield(plot_info.plot_data,'edat');
                ey = plot_info.plot_data.edat(temp);
            else
                ey = zeros(size(y));
            end
            if isfield(plot_info.plot_data,'exdat');
                if isempty(plot_info.plot_data.exdat);
                    ex = zeros(size(x));
                else
                    ex =  plot_info.plot_data.exdat(temp);
                end
            else
                ex = zeros(size(x));
            end
            
            %Calcualte Average
            [sum_i, err_sum_i] = err_sum(y,ey);
            n_points = length(y);
            
             
            
            %Calculate Centre of Mass
            %cm = sum(x.*y)./sum(y)
            [moment, err_moment] = err_multiply(x,ex,y,ey);
            [sum_moment, err_sum_moment] = err_sum(moment,err_moment);
            [sum_mass,err_sum_mass] = err_sum(y,ey);
            [cm, err_cm] = err_divide(sum_moment,err_sum_moment,sum_mass,err_sum_mass);
            
            
            %Calculate Variance (standard deviation)
            %variance = sum(y.*(x - cm).^2)/(sum(y));
            %sigma = sqrt(variance)
            [x_cm, err_x_cm] = err_sub(x,ex,cm,err_cm);
            [x_cm2, err_x_cm2] = err_power(x_cm,err_x_cm,2);
            [yx_cm2, err_yx_cm2] = err_multiply(y,ey,x_cm2,err_x_cm2);
            [sum_yxcm2, err_sum_yxcm2] = err_sum(yx_cm2,err_yx_cm2);
            [variance, err_variance] = err_divide(sum_yxcm2,err_sum_yxcm2,sum_mass,err_sum_mass);           
            [sigma, err_sigma] = err_power(variance,err_variance,0.5);
            
            %Calculate Skewness
            n_points = length(x);
            %skewness = sum(y.*(x - cm).^3)/((n_points-1)*sigma^3);
            %skewness = skewness /sum(y);
            [x_cm3,err_x_cm3] = err_power(x_cm,err_x_cm,3);
            [yx_cm3, err_yx_cm3] = err_multiply(y,ey,x_cm3,err_x_cm3);
            [sum_yxcm3,err_sum_yxcm3] = err_sum(yx_cm3,err_yx_cm3);
            [sigma3,err_sigma3] = err_power(sigma,err_sigma,3);
            points_sigma3 = (n_points-1)*sigma3; err_points_sigma3 = (n_points-1)*err_sigma3;
            [skew1, err_skew1] = err_divide(sum_yxcm3,err_sum_yxcm3,points_sigma3,err_points_sigma3);
            [skewness,err_skewness] = err_divide(skew1,err_skew1,sum_mass,err_sum_mass);
            
            %Calculate Kurtosis (Peakyness)
            %kurtosis = sum(y.*(x - cm).^4)/((n_points-1)*sigma^4);
            %kurtosis = kurtosis / sum(y);
            [x_cm4,err_x_cm4] = err_power(x_cm,err_x_cm,4);
            [yx_cm4, err_yx_cm4] = err_multiply(y,ey,x_cm4,err_x_cm4);
            [sum_yxcm4,err_sum_yxcm4] = err_sum(yx_cm4,err_yx_cm4);
            [sigma4,err_sigma4] = err_power(sigma,err_sigma,4);
            points_sigma4 = (n_points-1)*sigma4; err_points_sigma4 = (n_points-1)*err_sigma4;
            [kurt1, err_kurt1] = err_divide(sum_yxcm4,err_sum_yxcm4,points_sigma4,err_points_sigma4);
            [kurtosis,err_kurtosis] = err_divide(kurt1,err_kurt1,sum_mass,err_sum_mass);
            
            %Calculate Area 
            step = diff(x);
            step(length(step)+1) = step(length(step)); %Make the delta_x array the same length as the data
            [area_array, err_area_array] = err_multiply(y, ey, step, zeros(size(step)));
            [total_area, err_total_area] = err_sum(area_array,err_area_array);
            
            disp(['Curve # ' num2str(n) '  :  Sum: ' num2str(sum_i) ' +- ' num2str(err_sum_i) ' :  Average: ' num2str(sum_i/n_points) ' +- ' num2str(err_sum_i/n_points) '  :  Area: ' num2str(total_area) ' +- ' num2str(err_total_area)]);
            disp(['              Centre of Mass: ' num2str(cm) ' +- ' num2str(err_cm) '  Sigma: ' num2str(sigma) ' +- ' num2str(err_sigma)]);
            disp(['              Skewness: ' num2str(skewness) ' +- ' num2str(err_skewness) '  Kurtosis: ' num2str(kurtosis) ' +- ' num2str(err_kurtosis)]);
            disp(' ');
            
            %Add to curve (fit) history
            if not(isfield(plot_info,'fit1d_history')); plot_info.fit1d_history = {}; end
            plot_info.fit1d_history(length(plot_info.fit1d_history)+1) = {['Centre of Mass: ' num2str(cm)]};
            plot_info.fit1d_history(length(plot_info.fit1d_history)+1) = {['Sigma: ' num2str(sigma)]};
            plot_info.fit1d_history(length(plot_info.fit1d_history)+1) = {['Skewness: ' num2str(skewness)]};
            set(curve_handles{n}(1),'userdata',plot_info);
        end
        
    case 'rescale_curve'
        
        prompt = {'Enter Matlab Matematical Expression to Scale Curve'};
        name = 'Rescale Curve';
        numlines = 1;
        defaultanswer = {'y = y'};
        expression_cell =inputdlg(prompt,name,numlines,defaultanswer);
        if isempty(expression_cell); return; end
        
        expression_str = [expression_cell{1} ';'];
        
        %Find the curve data
        curve = get(gcbo,'userdata');
        
        parent = get(gcbo,'parent'); %Curve Menu parent object
        parent = get(parent,'parent'); %Curve Tools Object
        parent = get(parent,'parent'); %Figure Object
        grasp_plot_handles = get(parent,'userdata');
        
        curve_handles = flipud(get(grasp_plot_handles.axis,'userdata'));
        
        %Prepare the other curves data as variables e.g. c1y, c1x, c1e, c1h
        for n = 1:length(curve_handles)
            if not(isempty(curve_handles{n}))
                curve_handle = curve_handles{n}(1);
                plot_info = get(curve_handle,'userdata');
                current_curve = plot_info.curve_number;
                
                eval(['c' num2str(current_curve) 'y = plot_info.plot_data.ydat'';']);
                eval(['c' num2str(current_curve) 'x = plot_info.plot_data.xdat'';']);
                if isfield(plot_info.plot_data,'edat')
                    eval(['c' num2str(current_curve) 'e = plot_info.plot_data.edat'';']);
                end
                if isfield(plot_info.plot_data,'exdat')
                    eval(['c' num2str(current_curve) 'h = plot_info.plot_data.exdat'';']);
                end
                
                if current_curve == curve; break; end
                
            end
        end
        
        
        curve_handle = curve_handles{curve};
        
        %Modify the displayed curve (multiple handles for errorbar objects)
        for n =1:length(curve_handle)
            y = get(curve_handle(n),'ydata'); %sometimes this is the real y value, sometimes this is the y of the error bar
            x = get(curve_handle(n),'xdata');
            
            try
                eval(expression_str)
            catch
                disp(' ')
                disp(['There was an error in evaluating your expression: ' expression_str]);
                disp('Reform your Matlab Matematical expression and Try again.');
                disp('Tip:  Use expressions of the form "y = ..."');
                disp('      where ''y'', ''x'', ''e'', ''h'' are reserved variables');
                disp('      describing the y-data, x-data, (vert)error-bar  and (horz)error-bar');
                disp('e.g.  "y = 0.92 * y + x/10"');
                %disp('Data beloning to all curves in the axis are also availaible for math operations:');
                %disp('e.g. c1x, c1y, c1e, c2x, c2y, ..... etc. all exist as reserved variables');
                disp(' ')
                return
            end
            set(curve_handle(n),'ydata',y,'xdata',x);
        end
        
        %Modify the raw data stored in the curves userdata
        plot_info = get(curve_handle(1),'userdata'); %This is the raw data structure for the curve
        if isfield(plot_info.plot_data,'xdat'); x = plot_info.plot_data.xdat; end
        if isfield(plot_info.plot_data,'ydat'); y = plot_info.plot_data.ydat; end
        if isfield(plot_info.plot_data,'edat'); e = plot_info.plot_data.edat; end
        if isfield(plot_info.plot_data,'exdat'); h = plot_info.plot_data.exdat; end
        eval(expression_str)
        if exist('x'); plot_info.plot_data.xdat = x; end
        if exist('y'); plot_info.plot_data.ydat = y; end
        if exist('e'); plot_info.plot_data.edat = e; end
        if exist('h'); plot_info.plot_data.exdat = h; end
        set(curve_handle(1),'userdata',plot_info);
        
        
    case 'curve_math'
        userdata = get(gcbo,'userdata');
        parent = get(gcbo,'parent'); %Curve Menu parent object
        parent = get(parent,'parent'); %Curve Tools Object
        parent = get(parent,'parent'); %Figure Object
        parent = get(parent,'parent'); %Figure Object
        parent = get(parent,'parent'); %Figure Object
        grasp_plot_handles = get(parent,'userdata');
        
        curve_handles = flipud(get(grasp_plot_handles.axis,'userdata'));
        curve_handle1 = curve_handles{userdata.curve1};
        plot_info1 = get(curve_handle1(1),'userdata');
        curve1 = plot_info1.curve_number;
        
        curve_handle2 = curve_handles{userdata.curve2};
        plot_info2 = get(curve_handle2(1),'userdata');
        curve2 = plot_info2.curve_number;
        
        %Do Math Operation
        x1dat = plot_info1.plot_data.xdat; y1dat = plot_info1.plot_data.ydat;
        if isfield(plot_info1.plot_data,'edat')
            e1dat=plot_info1.plot_data.edat;
        else
            e2dat = zeros(size(y1dat));
        end
        
        if isfield(plot_info1.plot_data,'hdat')
            h1dat=plot_info1.plot_data.hdat;
        else
            h1dat = zeros(size(x1dat));
        end
        
        x2dat = plot_info2.plot_data.xdat; y2dat = plot_info2.plot_data.ydat;
        y2interp = interp1(x2dat,y2dat,x1dat,'linear','extrap');
        if isfield(plot_info1.plot_data,'edat')
            e2dat=plot_info2.plot_data.edat;
            e2interp = interp1(x2dat,e2dat,x1dat,'linear','extrap');
        else
            e2dat = zeros(size(y2dat));
        end
        if isfield(plot_info1.plot_data,'hdat')
            h2dat=plot_info2.plot_data.hdat;
        else
            h2dat = zeros(size(x2dat));
        end
        
        
        warning off
        if strcmp(userdata.mathops{userdata.math}, 'Add')
            [new_y, new_e]= err_add(y1dat,e1dat,y2interp,e2interp);
        elseif strcmp(userdata.mathops{userdata.math}, 'Subtract')
            [new_y, new_e] = err_sub(y1dat,e1dat,y2interp,e2interp);
        elseif strcmp(userdata.mathops{userdata.math}, 'Multiply by')
            [new_y, new_e] = err_multiply(y1dat,e1dat,y2interp,e2interp);
        elseif strcmp(userdata.mathops{userdata.math}, 'Divide by')
            [new_y, new_e] = err_divide(y1dat,e1dat,y2interp,e2interp);
        else return
        end
        warning on
        
        
        %Plot the math modified curve either in a new window, or existing window, depending on hold status
        plot_info1.plot_data.ydat = new_y;
        plot_info1.plot_data.edat = new_e;
        plotdata = [x1dat,new_y,new_e,h1dat];
        plot_info1.export_data = plotdata; % replace the export data with the new math op data
        disp(['Curve Math Data: ' userdata.mathops{userdata.math}]);
        disp(['x    y   err_y   err_x']);
        disp(plotdata)
        
        if strcmp(grasp_plot_handles.hold_status,'on') %Keep original plot name for re-plotting into
        else
            plot_info1.plot_title = [plot_info1.plot_title ' : Math Ops']; %Modify plot name so new plot, and subsequent hold re-plotting
        end
        column_format = ['xyeh'];
        grasp_plot(plotdata,column_format,plot_info1);
        
        
    case 'average_curves'
        
        %Find number of curves in plot
        temp = get(gca,'userdata');
        n_curves = length(temp);
        
        %Retrieve all the curve data & find the longest curve
        curve_info = [];
        longest_curve = 0; longest_curve_number = [];
        for n =1:n_curves
            temp2= temp{n};
            curve_info.(['curve' num2str(n)]) = get(temp2(1),'userdata');
            curve_length = length(curve_info.(['curve' num2str(n)]).plot_data.xdat);
            if curve_length > longest_curve;
                longest_curve = curve_length;
                longest_curve_number = n;
            end
        end
        
        %Now run along the longest curve and find any points to average
        xdat_longest = curve_info.(['curve' num2str(longest_curve_number)]).plot_data.xdat;
        ydat_longest = curve_info.(['curve' num2str(longest_curve_number)]).plot_data.ydat;
        edat_longest = curve_info.(['curve' num2str(longest_curve_number)]).plot_data.edat;
        
        tollerance = 0.01; %1%
        curves_average = [];
        for l = 1:longest_curve
            ypoints = [ydat_longest(l),edat_longest(l)];
            
            %Search for any matching points in the other curves
            for n=1:n_curves
                if n ~= longest_curve_number
                    xdat = curve_info.(['curve' num2str(n)]).plot_data.xdat;
                    ydat = curve_info.(['curve' num2str(n)]).plot_data.ydat;
                    edat = curve_info.(['curve' num2str(n)]).plot_data.edat;
                    temp = find(xdat>xdat_longest(l)*(1-tollerance)  & xdat<xdat_longest(l)*(1+tollerance));
                    for m = 1:length(temp);
                        s = size(ypoints);
                        ypoints(s(1)+1,:) = [ydat(temp),edat(temp)];
                    end
                end
            end
            
            %Average the points
            av_y = average_error(ypoints);
            curves_average(l,:) = [xdat_longest(l),av_y];
        end
        
        
        %Plot the math modified curve either in a new window, or existing window, depending on hold status
        plot_info = curve_info.(['curve' num2str(longest_curve_number)]);
        plot_info.plot_data.xdat = curves_average(:,1);
        plot_info.plot_data.ydat = curves_average(:,2);
        plot_info.plot_data.edat = curves_average(:,3);
        plotdata = [plot_info.plot_data.xdat,plot_info.plot_data.ydat,plot_info.plot_data.edat];
        plot_info.export_data = plotdata; % replace the export data with the new math op data
        disp(['Curves Average Data:']);
        disp(['x    y   err_y']);
        disp(plotdata)
        
        grasp_plot_handles = get(gcf,'userdata');
        
        
        if strcmp(grasp_plot_handles.hold_status,'on') %Keep original plot name for re-plotting into
        else
            plot_info.plot_title = [plot_info.plot_title ' : Curves Average']; %Modify plot name so new plot, and subsequent hold re-plotting
        end
        column_format = ['xye'];
        grasp_plot(plotdata,column_format,plot_info);
        
        
        
        
        
    case 'erase_curve'
        
        curve = get(gcbo,'userdata');
        parent1 = get(gcbo,'parent'); %Curve Menu parent object
        parent2 = get(parent1,'parent'); %Menu Object
        parent3 = get(parent2,'parent'); %Figure Object
        grasp_plot_handles = get(parent3,'userdata');
        
        curve_handles = get(grasp_plot_handles.axis,'userdata');
        
        
        curve_handle = curve_handles{curve};
        plot_info = get(curve_handle(1),'userdata');
        
        %delete curve and its handle
        delete(curve_handle);
        curve_handles{curve} = [];
        
        %remove any empty curve handles
        new_curve_handles{1} = [];
        nn=1;
        for n =1:length(curve_handles)
            if not(isempty(curve_handles{n}))
                new_curve_handles{nn} = curve_handles{n};
                nn=nn+1;
            end
        end
        
        %delete fit curve if exists
        if isfield(plot_info,'fit_curve_handle');
            if ishandle(plot_info.fit_curve_handle);
                delete(plot_info.fit_curve_handle);
            end
        end
        
        %delete menu curve menu item
        delete(parent1);
        
        %Set curve handles back to the plot userdata
        set(grasp_plot_handles.axis,'userdata',new_curve_handles);
        
        grasp_plot_callbacks('update_legend',grasp_plot_handles);
        grasp_plot_fit_callbacks('build_curve_number');
        grasp_plot_callbacks('build_curve_tools_menu',grasp_plot_handles);
        
        
    case 'build_curve_tools_menu'
        
        
        %delete old curve tools menu
        temp = get(option.curve_tools_menu,'children');
        delete(temp);
        
        curve_handles = get(option.axis,'userdata');
        for n = 1:length(curve_handles);
            if not(isempty(curve_handles{n}));
                plot_info = get(curve_handles{n}(1),'userdata');
                curve = plot_info.curve_number;
                handle = uimenu(option.curve_tools_menu,'label',['Curve: ' num2str(curve)]);
                uimenu(handle,'label','Erase Curve','userdata',curve,'callback','grasp_plot_callbacks(''erase_curve'');');
                uimenu(handle,'label','Rescale Curve','userdata',curve,'callback','grasp_plot_callbacks(''rescale_curve'');');
                
                handle2 = uimenu(handle,'label','Curve Math','userdata',curve);
                mathops =[{'Add'} {'Subtract'} {'Multiply by'} {'Divide by'}];
                for math = 1:length(mathops)
                    handle3 = uimenu(handle2,'label',mathops{math});
                    for n2 = 1:length(curve_handles)
                        if not(isempty(curve_handles{n2}))
                            plot_info2 = get(curve_handles{n2}(1),'userdata');
                            curve2 = plot_info2.curve_number;
                            
                            userdata.curve1 = curve; userdata.curve2 = curve2; userdata.mathops = mathops; userdata.math = math;
                            uimenu(handle3,'label',['Curve: ' num2str(curve2)],'userdata',userdata,'callback','grasp_plot_callbacks(''curve_math'')');
                        end
                    end
                end
            end
        end
        handle = uimenu(option.curve_tools_menu,'label',['Average All Curves'],'callback','grasp_plot_callbacks(''average_curves'');');
        
        %Add All curve tools
        
        grasp_plot_fit_callbacks('build_curve_number');
        
        
    case 'update_legend'
        %Delete old legend
        if isfield(option,'legend_handle');
            if ishandle(option.legend_handle); delete(option.legend_handle); end
        end
        
        curve_handles = get(option.axis,'userdata');
        legend_str = []; legend_curve_handle = [];
        for n = 1:length(curve_handles);
            if not(isempty(curve_handles{n}));
                plot_info = get(curve_handles{n}(1),'userdata');
                legend_str = [legend_str, {[num2str(plot_info.curve_number) ': ' plot_info.legend_str]}];
                legend_curve_handle = [legend_curve_handle, curve_handles{n}(1)];
            end
        end
        if not(isempty(legend_curve_handle));
            handle = legend(legend_curve_handle,legend_str);
            grasp_plot_handles = get(option.figure,'userdata');
            grasp_plot_handles.legend_handle = handle;
            set(option.figure,'userdata',grasp_plot_handles);
        end
        
    case 'hold_toggle'
        
        status = get(gcbo,'value');
        if status == 1; status_str = 'on'; else status_str = 'off'; end
        parent_figure = get(gcbo,'parent');
        grasp_plot_handles = get(parent_figure,'userdata');
        grasp_plot_handles.hold_status = status_str;
        set(parent_figure,'userdata',grasp_plot_handles);
        
        %update the hold status in the curve plot_info
        n_curves = length(curve_handles);
        for n = 1:n_curves
            plot_info = get(curve_handles{n}(1),'userdata');
            plot_info.hold_graph = status_str;
            set(curve_handles{n}(1),'userdata',plot_info);
        end

        
        
    case 'y_scale'
        
        %Find new scaling option
        list= get(gcbo,'string');
        value = get(gcbo,'value');
        scaling_string = list{value};
        
        parent_figure = get(gcbo,'parent');
        grasp_plot_handles = get(parent_figure,'userdata');
        
        switch scaling_string
            case 'y'
                set(grasp_plot_handles.axis,'YScale','Linear')
                
            case 'log10(y)'
                set(grasp_plot_handles.axis,'YScale','Log')
                
        end
        
        
        
    case 'x_scale'
        
        %Find new scaling option
        list= get(gcbo,'string');
        value = get(gcbo,'value');
        scaling_string = list{value};
        
        parent_figure = get(gcbo,'parent');
        grasp_plot_handles = get(parent_figure,'userdata');
        
        switch scaling_string
            case 'x'
                set(grasp_plot_handles.axis,'XScale','Linear')
                
            case 'log10(x)'
                set(grasp_plot_handles.axis,'XScale','Log')
                
        end
        
end
