function data_menu_callbacks(to_do,options)

global status_flags
global inst_params
global grasp_handles
global grasp_data
global displayimage

%***** Retrieve ONLY FOREGROUND DATA: NOT NORMALISED as indicated by the MAIN selector *****
[intensity] = retrieve_data('fore');

switch to_do

    case 'extract_parameter'
        %Ploting column format
        column_format = 'x';
        
        if isfield(status_flags,'parameter_survey'); 
            param_str = num2str(status_flags.parameter_survey.parameter);
        else
            param_str = '65';
        end
        param_values = [];
        parameter_str=inputdlg(({'Enter Parameters # ('','' separated)'}),'Enter Parameter # to Extract',[1],{param_str});
        parameter_str = parameter_str{1}; %convert cell to str
        
        
        %worksheet indicies
        depths = (status_flags.selector.fdpth_max-grasp_data(1).sum_allow);

        param_servey = [];
        column_format = ['x'];
        for n = 1:depths;
            depth_params = n;
            
            %Parse the input string of parameter numbers or text parameters (e.g. ts, te)
            remain = parameter_str;
            while not(isempty(remain));
                [token,remain] = strtok(remain,',');
                %Check for numeric parameters
                parameter = str2num(token);
                if not(isempty(parameter)); %i.e. parameter is numeric
                    index = data_index(status_flags.selector.fw);
                    depth_params = [depth_params, grasp_data(index).params1{status_flags.selector.fn}(parameter,n)];
                    if n ==1; column_format = [column_format, 'y'];end
                elseif strcmp(token,'ts');
                    index = data_index(4); %Sample Transmission
                    depth_params =[depth_params, grasp_data(index).trans{status_flags.selector.fn}(n,:)];
                    if n==1; column_format = [column_format, 'ye']; end
                elseif strcmp(token,'te');
                    index = data_index(5); %Empty Cell Transmission
                    depth_params =[depth_params, grasp_data(index).trans{status_flags.selector.fn}(n,:)];
                    if n==1; column_format = [column_format, 'ye']; end
                elseif strcmp(token,'cx');
                    index = data_index(status_flags.selector.fw);
                    depth_params =[depth_params, grasp_data(index).cm1{status_flags.selector.fn}.cm_pixels(n,1)];
                    if n==1; column_format = [column_format, 'y']; end
                elseif strcmp(token,'cy');
                    index = data_index(status_flags.selector.fw);
                    depth_params =[depth_params, grasp_data(index).cm1{status_flags.selector.fn}.cm_pixels(n,2)];
                    if n==1; column_format = [column_format, 'y']; end
                end

                
                
            end
            param_servey(n,:) = depth_params;
        end
        
        disp(['Numor, Parameter(s) ' parameter_str ' though the depth']);
        disp(param_servey);
        
        %Prepare Parameters for the clipboard (arranged correctly to be pasted into Origin, Excel etc.)
        str = [];
        for n = 1:size(param_servey,1)
            for m = 1:size(param_servey,2);
                str = [str num2str(param_servey(n,m)) char(9)];
            end
            str = [str char(13) char(10)];
        end
        clipboard('copy',str);
        
        %***** Plot Parameter vs Depth ****
        plotdata = [param_servey];
        column_format
        plot_info = struct(....
            'plot_type','plot',....
            'hold_graph','off',....
            'plot_title',['Parameter Survey'],....
            'x_label',['Depth #'],....
            'y_label','Parameter',....
            'params',displayimage.params1,....
            'parsub',displayimage.subtitle,....
            'export_data',plotdata,....
            'plot_data',plotdata,....
            'info',displayimage.info,....
            'column_labels',[]);
        plot_info.history = [];
        plot_info.legend_str = [''];
        grasp_plot(plotdata,column_format,plot_info);
        
        
        
        
        
        %                                 if not(isempty(inst_params.vector_names{parameters(m)}))
%                                     temp_str = inst_params.vector_names{parameters(m)}{1};
%                                 else
%                                     temp_str = 'No Name';
                  
            
         
        

case 'pixel_pick'

        %Switch to main figure window
        figure(grasp_handles.figure.grasp_main);
        zoom off;
        endflag = 0;

        %Display pixel-pick On Status
        text_handle = grasp_message('Pixel-Pick On!   (ESC) to Exit');

        while endflag==0

            event=waitforbuttonpress;

            if event == 0 && gcf == grasp_handles.figure.grasp_main %i.e. when mouse button was pressed, was it on the correct figure?  If not, terminate loop anyway
                point1=get(grasp_handles.displayimage.(['axis' num2str(status_flags.display.active_axis)]),'CurrentPoint');
                finalrect = rbbox;
                point2 = get(grasp_handles.displayimage.(['axis' num2str(status_flags.display.active_axis)]),'CurrentPoint');

                %Check sketch actually happend on the designated active axis
                if gca ~= grasp_handles.displayimage.(['axis' num2str(status_flags.display.active_axis)]);
                    disp('Pixel-Pick Coordinates Outside of Current Axes')
                    if not(isempty(text_handle)) & ishandle(text_handle); delete(text_handle); end
                    return
                end
                
                %point1 & point2 coordinates could be in any axes:  sort into order and convert back to pixels
                xcoord = [point1(1,1),point2(1,1)]; ycoord = [point2(1,2),point1(1,2)];
                xcoord = sort(xcoord); ycoord = sort(ycoord);
                sketch_coords = current_axis_limits([xcoord,ycoord]);
                sketch_coords_pixels = round(sketch_coords.(['det' num2str(status_flags.display.active_axis)]).pixels);
                
                %Check that the sketched coordinates lie within the detector size
                if sketch_coords_pixels(1) >= 1 && sketch_coords_pixels(2) <= inst_params.(['detector' num2str(status_flags.display.active_axis)]).pixels(1) && sketch_coords_pixels(3) >=1 && sketch_coords_pixels(4) <= inst_params.(['detector' num2str(status_flags.display.active_axis)]).pixels(2); %Check coord were actually within the axes
                    pixelsum = sum(sum(intensity.(['data' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(3):sketch_coords_pixels(4),sketch_coords_pixels(1):sketch_coords_pixels(2))));
                    pixel_count = (((sketch_coords_pixels(4)+1)-sketch_coords_pixels(3))*((sketch_coords_pixels(2)+1)-sketch_coords_pixels(1)));
                    counts_per_pixel = pixelsum / pixel_count;

                    disp(' ')
                    disp('WARNING! - Pixel Pick Shows the RAW counts in the FOREGROUND data file only');
                    disp('         - No corrections for Monitor, Deadtime, etc are made');
                    disp(' ')
                    disp(['Pixel Coords, x1,x2,y1,y2: ' num2str(sketch_coords_pixels(1)) ' ' num2str(sketch_coords_pixels(2)) ' ' num2str(sketch_coords_pixels(3)) ' ' num2str(sketch_coords_pixels(4))]);
                    text_handle = grasp_message(['x1: ' num2str(sketch_coords_pixels(1)) ' x2: ' num2str(sketch_coords_pixels(2)) ' y1: ' num2str(sketch_coords_pixels(3)) ' y2: ' num2str(sketch_coords_pixels(4))],1);

                    qx = mean([displayimage.(['qmatrix' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(3),sketch_coords_pixels(1),3), displayimage.(['qmatrix' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(4),sketch_coords_pixels(2),3)]);
                    qy = mean([displayimage.(['qmatrix' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(3),sketch_coords_pixels(1),4), displayimage.(['qmatrix' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(4),sketch_coords_pixels(2),4)]);
                    modq = mean([displayimage.(['qmatrix' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(3),sketch_coords_pixels(1),5), displayimage.(['qmatrix' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(4),sketch_coords_pixels(2),5)]);
                    
                    disp(['Pixel qx = ' num2str(qx)]);
                    disp(['Pixel qy = ' num2str(qy)]);
                    disp(['Pixel mod q = ' num2str(modq)]);
                    text_handle = grasp_message(['q_x: ' num2str(qx) '   q_y: ' num2str(qy) '   Mod_q: ' num2str(modq)],2);
                        
                    disp(['Pixel Sum = ' num2str(pixelsum) ', Number of Pixels = ' num2str(pixel_count) ', Counts/Pixel = ' num2str(counts_per_pixel)]);
                    text_handle = grasp_message(['N: ' num2str(pixel_count) ' Sum: ' num2str(pixelsum) ' Sum/N: ' num2str(counts_per_pixel)],3);
                else
                    endflag =1; %i.e. exit the loop
                end
            else
                endflag =1; %i.e. exit the loop
            end
        end
        delete(text_handle);

    case 'windet'

        %Switch to main figure window
        figure(grasp_handles.figure.grasp_main);
        zoom off;
        endflag = 0;

        %Display Windet On Status
        text_handle = grasp_message('Windet On!   (ESC) to Exit');

        while endflag==0

            event=waitforbuttonpress;

            if event == 0 && gcf == grasp_handles.figure.grasp_main %i.e. when mouse button was pressed, was it on the correct figure?  If not, terminate loop anyway
                point1=get(grasp_handles.displayimage.(['axis' num2str(status_flags.display.active_axis)]),'CurrentPoint');
                finalrect = rbbox;
                point2 = get(grasp_handles.displayimage.(['axis' num2str(status_flags.display.active_axis)]),'CurrentPoint');

                %Check sketch actually happend on the designated active axis
                if gca ~= grasp_handles.displayimage.(['axis' num2str(status_flags.display.active_axis)]);
                    disp('Mask Sketch Coordinates Outside of Current Axes')
                    if not(isempty(text_handle)) & ishandle(text_handle); delete(text_handle); end
                    return
                end
                
                %point1 & point2 coordinates could be in any axes:  sort into order and convert back to pixels
                xcoord = [point1(1,1),point2(1,1)]; ycoord = [point2(1,2),point1(1,2)];
                xcoord = sort(xcoord); ycoord = sort(ycoord);
                sketch_coords = current_axis_limits([xcoord,ycoord]);
                sketch_coords_pixels = round(sketch_coords.(['det' num2str(status_flags.display.active_axis)]).pixels);

                %Check that the sketched coordinates lie within the detector size
                if sketch_coords_pixels(1) >= 1 && sketch_coords_pixels(2) <= inst_params.(['detector' num2str(status_flags.display.active_axis)]).pixels(1) && sketch_coords_pixels(3) >=1 && sketch_coords_pixels(4) <= inst_params.(['detector' num2str(status_flags.display.active_axis)]).pixels(2); %Check coord were actually within the axes
                    disp(' ');
                    disp('WARNING! - Windet Shows the RAW counts in the FOREGROUND data file only');
                    disp('         - No corrections for Monitor, Deadtime, etc are made');
                    disp(' ');
                    disp(['y     |    AV']); %X header
                    for n = sketch_coords_pixels(4):-1:sketch_coords_pixels(3)
                        av  = sum(intensity.(['data' num2str(status_flags.display.active_axis)])(n,sketch_coords_pixels(1):sketch_coords_pixels(2)));
                        av = av / (sketch_coords_pixels(2)-sketch_coords_pixels(1)+1);
                        disp_string = [num2str(n) blanks(6-length(num2str(n))) '|' blanks(6-length(num2str(av,'%-6.1f\t'))) num2str(av,'%-6.1f\t') blanks(4)]; %X, X Av
                        disp_string = [disp_string num2str(intensity.(['data' num2str(status_flags.display.active_axis)])(n,sketch_coords_pixels(1):sketch_coords_pixels(2)),'%-6.1i\t')]; %Data
                        disp(disp_string);
                    end
                    disp_string2 = '';
                    for n = 1:(12+(((sketch_coords_pixels(2)-sketch_coords_pixels(1))+1)*8));
                        disp_string2 = [disp_string2 '-'];
                    end
                    disp(disp_string2); %------ line

                    disp_string = [blanks(8) 'x' blanks(8) ];
                    disp_stringAV = ['AV' blanks(7)];
                    for n = sketch_coords_pixels(1):sketch_coords_pixels(2)
                        disp_string = [disp_string num2str(n,'%-6.1i\t') blanks(8-length(num2str(n,'%-6.1i\t')))];
                        av = sum(intensity.(['data' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(3):sketch_coords_pixels(4),n));
                        av = av / (sketch_coords_pixels(4)-sketch_coords_pixels(3)+1);
                        disp_stringAV = [disp_stringAV num2str(av,'%-6.1f\t') blanks(8-length(num2str(av,'%-6.1f\t')))];

                    end
                    disp(disp_stringAV);
                    disp(disp_string2);
                    disp(disp_string);
                    disp(disp_string2);

                    pixel_count = (((sketch_coords_pixels(4)+1)-sketch_coords_pixels(3))*((sketch_coords_pixels(2)+1)-sketch_coords_pixels(1)));
                    pixelsum = sum(sum(intensity.(['data' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(3):sketch_coords_pixels(4),sketch_coords_pixels(1):sketch_coords_pixels(2))));
                    counts_per_pixel = pixelsum / pixel_count;
                    disp(['Pixel Sum = ' num2str(pixelsum) ', Number of Pixels = ' num2str(pixel_count) ', Counts/Pixel = ' num2str(counts_per_pixel)]);
                    disp(['Box : x' num2str(sketch_coords_pixels(1)) ' x' num2str(sketch_coords_pixels(2)) ' y' num2str(sketch_coords_pixels(3)) ' y' num2str(sketch_coords_pixels(4))]);

                    cm = centre_of_mass(intensity.(['data' num2str(status_flags.display.active_axis)])(sketch_coords_pixels(3):sketch_coords_pixels(4),sketch_coords_pixels(1):sketch_coords_pixels(2)),[sketch_coords_pixels(1),sketch_coords_pixels(2),sketch_coords_pixels(3),sketch_coords_pixels(4)]);
                    disp(['Centre of Mass of Window :   Cx = ' num2str(cm.cm(1)) '    Cy = ' num2str(cm.cm(2))]);
                   % disp(['Sigma of Window (pixels):   Cx = ' num2str(cm.sigma_pixels(1)) '    Cy = ' num2str(cm.sigma_pixels(2))]);
                    
                    disp(' ');
                    disp(' ');
                    endflag = 1;
                else
                    endflag =1; %i.e. exit the loop
                end
            else
                endflag =1; %i.e. exit the loop
            end
        end
        delete(text_handle);

    case 'normalization'
        status_flags.normalization.status = options;
        grasp_update

    case 'deadtime_toggle'
        status_flags.deadtime.status = options;
        grasp_update

    case 'thickness_transmission_toggle'
        status_flags.transmission.thickness_correction = options;
        grasp_update

    case 'auto_atten_toggle'
        status_flags.normalization.auto_atten = options;
        grasp_update

    case 'count_scaler_toggle'
        status_flags.normalization.count_scaler = options;
        grasp_update
        
    case 'set_std_mon'
        mon_str=inputdlg({'Enter Standard Monitor Scalar'},'Standard Monitor',1,{num2str(status_flags.normalization.standard_monitor)});
        if not(isempty(mon_str));
            value = str2num(mon_str{1});
            if not(isempty(value));
                status_flags.normalization.standard_monitor= value;
            else
                disp('Please enter a sensible value for Standard Monitor');
            end
        end
        grasp_update;

    case 'set_std_time'
        tim_str=inputdlg({'Enter Standard Time Scalar'},'Standard Time',1,{num2str(status_flags.normalization.standard_time)});
        if not(isempty(tim_str));
            value = str2num(tim_str{1});
            if not(isempty(value));
                status_flags.normalization.standard_time= value;
            else
                disp('Please enter a sensible value for Standard Time');
            end
        end
        grasp_update;

    case 'set_std_detup'
        det_upstr=inputdlg({'Enter Standard Detector Upscaler'},'Det Upscaler',1,{num2str(status_flags.normalization.standard_detector)});
        if not(isempty(det_upstr));
            value = str2num(det_upstr{1});
            if not(isempty(value));
                status_flags.normalization.standard_detector = value;
            else
                disp('Please enter a sensible value for Detector Upscaler');
            end
        end
        grasp_update;

    case 'set_std_detwin'
        old_detwin = status_flags.normalization.detwin;
        new_detwin=inputdlg(({'x_min','x_max','y_min','y_max'}),'Enter Axes Limits',[1],{num2str(old_detwin(1)),num2str(old_detwin(2)),num2str(old_detwin(3)),num2str(old_detwin(4))});
        if not(isempty(new_detwin));
            xmin = str2num(new_detwin{1});
            xmax = str2num(new_detwin{2});
            ymin = str2num(new_detwin{3});
            ymax = str2num(new_detwin{4});
            if isempty(xmin) | isempty(xmax) | isempty(ymin) | isempty(ymax)
                disp('Please Enter Sensible (i.e. Numeric) Axis Limits!');
            else
                status_flags.normalization.detwin = [str2num(new_detwin{1}),str2num(new_detwin{2}),str2num(new_detwin{3}),str2num(new_detwin{4})];
            end
        end
        grasp_update;
        

    case 'set_std_param'
        
        param_str=inputdlg({'Enter Parameter Number to Normalize to'},'Parameter',1,{num2str(status_flags.normalization.param)});
        if not(isempty(param_str));
            value = str2num(param_str{1});
            if not(isempty(value)) & value>=0 & value <=128;
                status_flags.normalization.param = value;
            else
                disp('Please enter a parameter number between 1 and 128');
            end
        end
        grasp_update
        
    case 'set_std_count_scaler'
        
        det_upstr=inputdlg({'Enter Count Scaler'},'Count Scaler',1,{num2str(status_flags.normalization.standard_count_scaler)});
        if not(isempty(det_upstr));
            value = str2num(det_upstr{1});
            if not(isempty(value));
                status_flags.normalization.standard_count_scaler = value;
            else
                disp('Please enter a sensible value for Count Scaler');
            end
        end
        grasp_update;

    case 'set_tof_dist'
        tof_dist=inputdlg({'Enter TOTAL TOF Distance [m]'},'TOF Distance',1,{num2str(status_flags.normalization.d33_total_tof_dist)});
        if not(isempty(tof_dist));
            value = str2num(tof_dist{1});
            if not(isempty(value));
                status_flags.normalization.d33_total_tof_dist = value;
            else
                disp('Please enter a sensible value for TOTAL TOF Distance [m]');
            end
        end
        
    case 'set_tof_delay'
        tof_delay=inputdlg({'Enter TOF Delay [microS] (i.e. Time between Trigger and Mid Window Opening)'},'TOF Delay',1,{num2str(status_flags.normalization.d33_tof_delay)});
        if not(isempty(tof_delay));
            value = str2num(tof_delay{1});
            if not(isempty(value));
                status_flags.normalization.d33_tof_delay = value;
            else
                disp('Please enter a sensible value for TOF Delat (microS)');
            end
        end
    
        

%     case 'set_deadtime'
%         %check that detector is described by a single deadtime
%         if length(inst_params.dead_time) > 1;
%             f = warndlg('Problem:  This detector is described by multiple deadtime parameters that cannot be edited here.  Deadtime for this detector has to be hard-coded into Grasp.', 'Multi-Deadtime Detector');
%         else
%             tim_str=inputdlg({'Enter Deadtime (s)'},'Deadtime',1,{num2str(inst_params.dead_time)});
%             if not(isempty(tim_str));
%                 value = str2num(tim_str{1});
%                 if not(isempty(value));
%                     inst_params.dead_time= value;
%                 else
%                     disp('Please enter a sensible value for Instrument Deadtime');
%                     disp(['Deadtime = ' num2str(inst_params.dead_time)]);
%                 end
%             end
%             grasp_update
%         end
        
end

