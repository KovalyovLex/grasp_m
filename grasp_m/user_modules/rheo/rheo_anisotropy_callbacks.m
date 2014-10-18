function rheo_anisotropy_callbacks(to_do)

if nargin<1; to_do = ''; end

global status_flags
global displayimage
global grasp_handles
global inst_params
global grasp_data
global last_result
global box_Af

switch to_do
    
    case 'rheo_anisotropy_window_close'
        %Delete old sectors
        if isfield(grasp_handles.user_modules.rheo_anisotropy,'sketch_handle');
            temp = find(ishandle(grasp_handles.user_modules.rheo_anisotropy.sketch_handle));
            delete(grasp_handles.user_modules.rheo_anisotropy.sketch_handle(temp));
        end
        grasp_handles.user_modules.rheo_anisotropy.sketch_handle = [];
        grasp_handles.user_modules.rheo_anisotropy.window = [];
        return
        
    case 'phase_lock'
        status_flags.user_modules.rheo_anisotropy.phase_lock = not(status_flags.user_modules.rheo_anisotropy.phase_lock);
        
    case 'phase_angle'
        value = str2num(get(gcbo,'string'));
        if not(isempty(value))
            status_flags.user_modules.rheo_anisotropy.phase_angle = value;
        end
        
   
      
   
        
    case 'width'
        value = str2num(get(gcbo,'string'));
        if not(isempty(value))
            status_flags.user_modules.rheo_anisotropy.radius_width = value;
        end
        
    case 'step'
        value = str2num(get(gcbo,'string'));
        if not(isempty(value))
            status_flags.user_modules.rheo_anisotropy.radius_step = value;
        end
        
    case 'color'
        color_list = get(gcbo,'string');
        value = get(gcbo,'value');
        status_flags.user_modules.rheo_anisotropy.color = color_list{value};
        
        
    case 'radius'
        value = str2num(get(gcbo,'string'));
        if not(isempty(value))
            status_flags.user_modules.rheo_anisotropy.radius = value;
        end   
        
        
   case 'binning_Af'
        value = str2num(get(gcbo,'string'));
        if not(isempty(value))
            status_flags.user_modules.rheo_anisotropy.binning_Af = value;
        end  
        
        
        
        case 'parameter'
        value = str2num(get(gcbo,'string'));
        if not(isempty(value))
            status_flags.user_modules.rheo_anisotropy.parameter = value;
        end 
        
      
        
    
   case 'plot_Af'
        
        radius = status_flags.user_modules.rheo_anisotropy.radius;
        radius_width = status_flags.user_modules.rheo_anisotropy.radius_width;
        binning_Af = status_flags.user_modules.rheo_anisotropy.binning_Af;
        
        phase_lock_angle = status_flags.user_modules.rheo_anisotropy.phase_angle;
        phase_lock = status_flags.user_modules.rheo_anisotropy.phase_lock;
        color = [1 0 0]; %status_flags.analysis_modules.rheo_anisotropy.color;
        
         %Take a copy of the history to modify though this process
        local_history = displayimage.history;
        local_history = [local_history, {'***** Analysis *****'}];
        local_history = [local_history, {'rheo_anisotropy: I(theta,q)'}];
        
        %***** Add Plot Af History *****
        local_history = [local_history, {['rheo_anisotropy: Radius = ' num2str(radius) ]}];
        
        
            %***** Loop though the ring, extract and fit and get the Anisotropy parameter *****
            % here should be the loop through the depth.....
            
            
        fit_list = []; fit_list_error = [];q_list = [];counter = 1;
        
        
        
        
        
         %Churn through the depth and extract box-sums
        index = data_index(status_flags.selector.fw);
       foreground_depth = status_flags.selector.fdpth_max - grasp_data(index).sum_allow;
        depth_start = status_flags.selector.fd; %remember the initial foreground depth

        %Check if using depth max min
        if status_flags.selector.depth_range_chk == 1;
            dstart = status_flags.selector.depth_range_min;
            if status_flags.selector.depth_range_max > foreground_depth;
                dend = foreground_depth;
            else
                dend = status_flags.selector.depth_range_max;
            end
        else
            dstart = 1; dend = foreground_depth;
        end
        
        
        disp(['Extracting Af through depth']);
        box_Af = [];
            for n = dstart:dend
                message_handle = grasp_message(['Extracting Af Depth: ' num2str(n) ' of ' num2str(foreground_depth)]);
                status_flags.selector.fd = n+grasp_data(index).sum_allow;
                main_callbacks('depth_scroll'); %Scroll all linked depths and update

        
        
        
        %----- for
        
         
%            disp(['rheo_anisotropy: Radius = ' num2str(radius)]);
            %Display Working Message
%            message_handle = grasp_message(['Working: rheo_anisotropy:  Radius = ' num2str(radius)]);
            
            %Make Compund Mask and Ring Mask (FOR ALL DETECTORS - done in one go)
            smask = sector_callbacks('build_sector_mask',[radius,radius+radius_width,0,360,1]);

            %Loop though the detectors for each COS2 ring
            rheo_anisotropy_sketch_handle = [];
            ring_data = []; %This is a variable that is appended to for each detector before doing the cos2 fit
                for det = 1:inst_params.detectors
                
                %Retrieve parameters for this detector pannel
                params = displayimage.(['params' num2str(det)]);
                
                %***** Make Raw Intensity vs. Angle @ mod_q list for given detector pannel *****
                IAngleQ_list = []; %Clear the variable as matrix size changes for each detector
                IAngleQ_list(:,1) = reshape(displayimage.(['qmatrix' num2str(det)])(:,:,6),inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1),1); %q_Angle
                IAngleQ_list(:,2) = reshape(displayimage.(['data' num2str(det)])(:,:),inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1),1); %Intensity
                IAngleQ_list(:,3) = reshape(displayimage.(['error' num2str(det)])(:,:),inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1),1); %Error in intensity
                IAngleQ_list(:,4) = reshape(displayimage.(['qmatrix' num2str(det)])(:,:,5),inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1),1); %mod q
                
                %***** Conical Ring Radius Scaling *****
                %Find current detector distance for particular detector pannel
                det_current = params(inst_params.vectors.det); %Default unless otherwise
                if strcmp(status_flags.q.det,'detcalc');
                    if isfield(inst_params.vectors,'detcalc')
                        if not(isempty(inst_params.vectors.detcalc));
                            det_current = params(inst_params.vectors.detcalc);
                        end
                    end
                end
                if isfield(inst_params.vectors,'det_pannel');
                    det_current = params(inst_params.vectors.det_pannel);
                end
                %Keep a memory of the main detector(1) Det
                if det ==1; det1det = det_current; end
                %For conical radius scaling of multiple detectors
                eff_radius = radius * det_current / det1det;
                eff_radius_width = radius_width * det_current / det1det;
                %***** End Conical Ring Radius Scaling *****
                
                
                %***** Draw Af Ring Sketches *****
                cm = displayimage.cm.(['det' num2str(det)]);
                %Pixel distances from Beam Centre
                if isfield(inst_params.vectors,'ox')
                    cx_eff = cm.cm_pixels(1) - ((params(inst_params.vectors.ox) - cm.cm_translation(1))/inst_params.detector1.pixel_size(1));
                else
                    cx_eff = cm.cm_pixels(1);
                end
                if isfield(inst_params.vectors,'oy')
                    cy_eff = cm.cm_pixels(2) - ((params(inst_params.vectors.oy) - cm.cm_translation(2))/inst_params.detector1.pixel_size(1));
                else
                    cy_eff = cm.cm_pixels(2);
                end
                %Draw Sketches
                handle = circle(det,eff_radius+eff_radius_width,eff_radius,cx_eff,cy_eff,0,360,color);
                rheo_anisotropy_sketch_handle = [rheo_anisotropy_sketch_handle, handle];
                pause(0.01); %Wait for screen update
                %**************************************
                
                %Final ring mask
                ring_mask = displayimage.(['mask' num2str(det)]).* smask.(['det' num2str(det)]);
                %figure
                %pcolor(ring_mask)
                
                %Reshape Compound Ring Mask to a list like the data
                ring_mask_list = reshape(ring_mask(:,:),inst_params.(['detector' num2str(det)]).pixels(1)*inst_params.(['detector' num2str(det)]).pixels(2),1);
                
                %Illiminate Pixels in the ring-mask
                temp = find(ring_mask_list==1);
                IAngleQ_ring_list = IAngleQ_list(temp,:);
                
                %Final check for any Zero Counts, Zero Error - this should
                %never be produced BUT, for D33 test data where detectors
                %shadow this was being produced.
                temp = find(IAngleQ_ring_list(:,2)~=0 & IAngleQ_ring_list(:,3)~=0);
                IAngleQ_ring_list = IAngleQ_ring_list(temp,:);
                
                %Debug plot
                %figure
                %plot(IAngleQ_ring_list(:,1),IAngleQ_ring_list(:,2),'.')
 
                ring_data = [ring_data; IAngleQ_ring_list];
                
                
                
            end
            
              delete(rheo_anisotropy_sketch_handle);
                    rheo_anisotropy_sketch_handle = [];

  
            
            
            
                        %Generate azimuthal bins
                    
                    
                        bin_step = status_flags.user_modules.rheo_anisotropy.binning_Af;
                        bin_edges = 0:bin_step:360;
                    
                    local_history = [local_history, {['Averaging I vs. Azimuth.  Bin size:  ' num2str(status_flags.user_modules.rheo_anisotropy.binning_Af) ' [Degree(s)]']}];
                    
                    if length(bin_edges) <2;
                        disp('Error generating Bin_Edges - not enough Bins')
                        disp('Please check re-binning paramters');
                    end
                    
                    %***** Now re-bin *****
                    if length(bin_edges) >=2;
                        temp = rebin([ring_data(:,1),ring_data(:,2),ring_data(:,3)],bin_edges); %[q,I,errI,delta_q,pixel_count]
                        ring_data = temp; %[ring_data; temp]; %append the iq data from the different detectors together
                    
              
                    
                    end
         

       

%        plotdata(:,1) = ring_data(:,1); %theta
%        plotdata(:,2) = ring_data(:,2); %I(theta)
%        plotdata(:,3) = ring_data(:,3); %error
%        column_format = 'xye';
%        plot_params = struct(....
%            'plot_type','plot',....
%            'hold_graph','off',....
%            'plot_title',['AF Analysis '],....
%            'x_label',['theta'],....
%            'y_label',['I (theta) ' displayimage.units],....
%            'legend_str',['I (theta)'],....
%            'params',displayimage.params1,....
%            'parsub',displayimage.subtitle,....
%            'export_data',plotdata,....
%            'info',displayimage.info,....
%            'column_labels',['theta   ' char(9) 'I (theta)       ' char(9) 'Err_I   ']);
        
%        plot_params.history = local_history;
%        grasp_plot(plotdata,column_format,plot_params);


        



        Af_list=[];

           

            %***** Fit to each curve *****
            xdat =    ring_data(:,1);
            ydat =    ring_data(:,2);
            edat =    ring_data(:,3);
            
             %Check for zero's in the edat - this crashes the fitter
            temp = find(edat==0); edat(temp) = 1;
            
            
            
            
            %let's try to calculate Af
            
            
             % Asigning indices to the angle and intesity data:
            Af=0 ;
           stepangle = 360/(length(bin_edges))
            Numer = sum(stepangle*ydat.*(cos(2*((pi/180)*xdat))));
            Denom = sum(stepangle*ydat);
            
            error_numer = stepangle * sum(edat.*(cos(2*((pi/180)*xdat))));
            error_denom = stepangle * sum(edat);
            
   %         Af_error=  sqrt( (((1/Denom)^2)*(error_numer^2)) + (((-Numer/(Denom^2))^2)*(error_denom^2)) );
            
            
 %        [result,err] = err_add(a,da,b,db)
            
%            Numer=  trapz((pi/180)*xdat,ydat.*(cos(2*((pi/180)*xdat))));
%            Denom= trapz((pi/180)*xdat,ydat);
%            Af=-Numer/Denom;
            
%            disp(['value of Af calculated raw' Af]);
%            disp(['value of Af error calculated raw' Af_error]);
            
 %           disp(Af);
            
 %          Af_error= ;
           
           
            [Af,Af_error] = err_divide(Numer,error_numer,Denom,error_denom);
           
           
             Af_list = [Af_list,-Af,Af_error]; %Accumulate the sum list
 
             % Saving the data:
           disp(Af);
           disp (Numer);
           disp (Denom);
           disp(stepangle);

            
           
           
          %Delete message
           
            
            %Delete ancos2 sketch
            if not(isempty(rheo_anisotropy_sketch_handle));
                if ishandle(rheo_anisotropy_sketch_handle);
                    delete(rheo_anisotropy_sketch_handle);
                    rheo_anisotropy_sketch_handle = [];
                end
            end
            
            
             if status_flags.user_modules.rheo_anisotropy.parameter == 0;
                parameter = n; %depth
                box_param_name = 'depth';
            else
                parameter = displayimage.params1(status_flags.user_modules.rheo_anisotropy.parameter);
                box_param_name = inst_params.vector_names{status_flags.user_modules.rheo_anisotropy.parameter};
                if iscell(box_param_name); %If name exists then remove it's cell nature
                    box_param_name = box_param_name{1};
                end
            end
            
            box_Af = [box_Af; [n, parameter, Af_list]];
                 
            end
        
        delete(message_handle);
        
        status_flags.selector.fd = depth_start;
        main_callbacks('depth_scroll'); %Scroll all linked depths and update
%        delete(message_handle);

        %Dislplay results on screen
        disp(' ');
        disp(['Depth #,     Parameter(' num2str(status_flags.user_modules.rheo_anisotropy.parameter) '),     Af,     Err_Af, ']);
        l = size(box_Af);
        for n = 1:l(1);
            disp_string = [];
            for m = 1:l(2);
                disp_string = [disp_string num2str(box_Af(n,m),'%6.6g') '   ' char(9)];
            end
            disp(disp_string);
        end

        %Turn on command window parameter update for the boxing
 %       status_flags.command_window.display_params = remember_display_params_status;
        %Turn on the 2D display
 %       status_flags.display.refresh = 1;
%        disp(' ');















        %***** Plot Box intensity vs. parameter ****
        l = size(box_Af);
        plotdata = box_Af(:,2:l(2));
        column_format = 'x';
        temp = size(plotdata);
        for n = 1:(temp(2)/2); column_format = [column_format, 'ye']; end
%         if status_flags.user_modules.rheo_anisotropy_.parameter ==1; y_string = ' \\ Pixel'; else y_string = []; end



        
        
        
        
        plot_params = struct(....
            'plot_type','plot',....
            'hold_graph','off',....
            'plot_title',['Af'],....
            'x_label',(['Parameter ' num2str(status_flags.user_modules.rheo_anisotropy.parameter), ', ' box_param_name]),....
            'y_label',['Af ' displayimage.units ],....
            'legend_str',['#' num2str(displayimage.params1(128))],....
            'params',displayimage.params1,....
            'parsub',displayimage.subtitle,....
            'export_data',plotdata,....
            'column_labels',[box_param_name char(9) 'Af' char(9) 'Err_Af']);
            
        local_history = displayimage.history; %This will actually be the history of the last file
        local_history = [local_history, {['***** Analysis *****']}];
        local_history = [local_history, {['Af vs. Parameter ' num2str(status_flags.user_modules.rheo_anisotropy.parameter),' '  box_param_name]}];
%        local_history = [local_history, box_history];
        

            
     

        plot_params.history = local_history;
        grasp_plot(plotdata,column_format,plot_params);
        
        last_result = plotdata;
            
            
   

        
            
            
            
            %Update the schematic annuli
        rheo_anisotropy_callbacks;
            
    
        
        

           
        
        
        
        
        
    
        
    case 'rheo_anisotropy_it'
        
        %Get the rheo_anisotropy parameters
        radius = status_flags.user_modules.rheo_anisotropy.radius;
        radius_width = status_flags.user_modules.rheo_anisotropy.radius_width;
        phase_lock_angle = status_flags.user_modules.rheo_anisotropy.phase_angle;
        phase_lock = status_flags.user_modules.rheo_anisotropy.phase_lock;
        color = [1 0 0]; %status_flags.analysis_modules.ancos2.color;
        
        %Take a copy of the history to modify though this process
        local_history = displayimage.history;
        local_history = [local_history, {'***** Analysis *****'}];
        local_history = [local_history, {'rheo_anisotropy: I(theta,q)'}];
        
        %***** Add Ancos2 History *****
        local_history = [local_history, {['rheo_anisotropy: Radius= ' num2str(radius) ]}];
        local_history = [local_history, {['rheo_anisotropy: R_width= ' num2str(radius_width)]}];
        
        
        
         fit_list = []; fit_list_error = [];q_list = [];counter = 1;
         plot_params=[];
         plot_data=[];
        
         %Churn through the depth and extract box-sums
        index = data_index(status_flags.selector.fw);
       foreground_depth = status_flags.selector.fdpth_max - grasp_data(index).sum_allow;
        depth_start = status_flags.selector.fd; %remember the initial foreground depth
        
        
        
        %***** Loop though the rings, extract and fit *****
        
        %Check if using depth max min
        if status_flags.selector.depth_range_chk == 1;
            dstart = status_flags.selector.depth_range_min;
            if status_flags.selector.depth_range_max > foreground_depth;
                dend = foreground_depth;
            else
                dend = status_flags.selector.depth_range_max;
            end
        else
            dstart = 1; dend = foreground_depth;
        end
        
        depth_param = [];
        
        for n = dstart:dend
            
            
                message_handle = grasp_message(['Extracting Cos^2 Depth: ' num2str(n) ' of ' num2str(foreground_depth)]);
                status_flags.selector.fd = n+grasp_data(index).sum_allow;
                main_callbacks('depth_scroll'); %Scroll all linked depths and update
        
        
        
       
 % -----       for radius = start_radius:radius_step:end_radius
            disp(['rheo_anisotropy: Radius = ' num2str(radius)]);
            %Display Working Message
 %           message_handle = grasp_message(['Working: rheo_anisotropy:  Radius = ' num2str(radius) ' : ' num2str(radius_width) ]);
            
            %Make Compund Mask and Ring Mask (FOR ALL DETECTORS - done in one go)
            smask = sector_callbacks('build_sector_mask',[radius,radius+radius_width,0,360,1]);

            %Loop though the detectors for each ANCOS2 ring
            rheo_anisotropy_sketch_handle = [];
            ring_data = []; %This is a variable that is appended to for each detector before doing the cos2 fit
            for det = 1:inst_params.detectors
                
                %Retrieve parameters for this detector pannel
                params = displayimage.(['params' num2str(det)]);
                
                %Keep track of parameter though depth
                if  status_flags.user_modules.rheo_anisotropy.parameter == 0;
                    depth_param = [depth_param; n];
                    depth_param_name = 'Depth';
                else
              %      depth_param = [depth_param; n];
              %      displayimage.params1(status_flags.user_modules.rheo_anisotropy.parameter)];
                    depth_param = [depth_param; params(status_flags.user_modules.rheo_anisotropy.parameter)];
                    depth_param_name = inst_params.vector_names{status_flags.user_modules.rheo_anisotropy.parameter};
                    
                end
                    

                
                
                %***** Make Raw Intensity vs. Angle @ mod_q list for given detector pannel *****
                IAngleQ_list = []; %Clear the variable as matrix size changes for each detector
                IAngleQ_list(:,1) = reshape(displayimage.(['qmatrix' num2str(det)])(:,:,6),inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1),1); %q_Angle
                IAngleQ_list(:,2) = reshape(displayimage.(['data' num2str(det)])(:,:),inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1),1); %Intensity
                IAngleQ_list(:,3) = reshape(displayimage.(['error' num2str(det)])(:,:),inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1),1); %Error in intensity
                IAngleQ_list(:,4) = reshape(displayimage.(['qmatrix' num2str(det)])(:,:,5),inst_params.(['detector' num2str(det)]).pixels(2)*inst_params.(['detector' num2str(det)]).pixels(1),1); %mod q
                
                %***** Conical Ring Radius Scaling *****
                %Find current detector distance for particular detector pannel
                det_current = params(inst_params.vectors.det); %Default unless otherwise
                if strcmp(status_flags.q.det,'detcalc');
                    if isfield(inst_params.vectors,'detcalc')
                        if not(isempty(inst_params.vectors.detcalc));
                            det_current = params(inst_params.vectors.detcalc);
                        end
                    end
                end
                if isfield(inst_params.vectors,'det_pannel');
                    det_current = params(inst_params.vectors.det_pannel);
                end
                %Keep a memory of the main detector(1) Det
                if det ==1; det1det = det_current; end
                %For conical radius scaling of multiple detectors
                eff_radius = radius * det_current / det1det;
                eff_radius_width = radius_width * det_current / det1det;
                %***** End Conical Ring Radius Scaling *****
                
                
                %***** Draw ANCOS2 Ring Sketches *****
                cm = displayimage.cm.(['det' num2str(det)]);
                %Pixel distances from Beam Centre
                if isfield(inst_params.vectors,'ox')
                    cx_eff = cm.cm_pixels(1) - ((params(inst_params.vectors.ox) - cm.cm_translation(1))/inst_params.detector1.pixel_size(1));
                else
                    cx_eff = cm.cm_pixels(1);
                end
                if isfield(inst_params.vectors,'oy')
                    cy_eff = cm.cm_pixels(2) - ((params(inst_params.vectors.oy) - cm.cm_translation(2))/inst_params.detector1.pixel_size(1));
                else
                    cy_eff = cm.cm_pixels(2);
                end
                %Draw Sketches
                handle = circle(det,eff_radius+eff_radius_width,eff_radius,cx_eff,cy_eff,0,360,color);
                rheo_anisotropy_sketch_handle = [rheo_anisotropy_sketch_handle, handle];
                pause(0.01); %Wait for screen update
                %**************************************
                
                %Final ring mask
                ring_mask = displayimage.(['mask' num2str(det)]).* smask.(['det' num2str(det)]);
                %figure
                %pcolor(ring_mask)
                
                %Reshape Compound Ring Mask to a list like the data
                ring_mask_list = reshape(ring_mask(:,:),inst_params.(['detector' num2str(det)]).pixels(1)*inst_params.(['detector' num2str(det)]).pixels(2),1);
                
                %Illiminate Pixels in the ring-mask
                temp = find(ring_mask_list==1);
                IAngleQ_ring_list = IAngleQ_list(temp,:);
                
                %Final check for any Zero Counts, Zero Error - this should
                %never be produced BUT, for D33 test data where detectors
                %shadow this was being produced.
                temp = find(IAngleQ_ring_list(:,2)~=0 & IAngleQ_ring_list(:,3)~=0);
                IAngleQ_ring_list = IAngleQ_ring_list(temp,:);
                
                %Debug plot
                %figure
                %plot(IAngleQ_ring_list(:,1),IAngleQ_ring_list(:,2),'.')
 
                ring_data = [ring_data; IAngleQ_ring_list];
            end
            
            
            
            
                        %Generate azimuthal bins
                    
                    
                        bin_step = status_flags.user_modules.rheo_anisotropy.binning_Af;
                        bin_edges = 0:bin_step:360;
                    
                    local_history = [local_history, {['Averaging I vs. Azimuth.  Bin size:  ' num2str(status_flags.user_modules.rheo_anisotropy.binning_Af) ' [Degree(s)]']}];
                    
                    if length(bin_edges) <2;
                        disp('Error generating Bin_Edges - not enough Bins')
                        disp('Please check re-binning paramters');
                    end
                    
                    %***** Now re-bin *****
                    if length(bin_edges) >=2;
                        temp = rebin([ring_data(:,1),ring_data(:,2),ring_data(:,3)],bin_edges); %[q,I,errI,delta_q,pixel_count]
                        ring_data = temp; %[ring_data; temp]; %append the iq data from the different detectors together
                    
              
                    
                    end
            
            
            
            
            
            
            
            
            
            
            
            
            %Only do the Cos^2 fit if there is enough data to fit
            if length(ring_data) > 10;
            
            %Retrieve the 1D Cosine^2 fit function
            fn_name = 'Cosine^2';
            ancos2_fn = grasp_plot_fit_callbacks('retrieve_fn',fn_name);
            ancos2_fn.number1d =1;

            %***** Fit to each curve *****
            xdat = ring_data(:,1);
            ydat = ring_data(:,2);
            edat = ring_data(:,3);
            
            %Check for zero's in the edat - this crashes the fitter
            temp = find(edat==0); edat(temp) = 1;
            
%             %Fix - Data when in units of solid angle can be very large numbers, i.e. 10^7.
%             %This causes mflsqr not to function properly, probably due to rounding errors.
%             %To Fix, find the 'order of magnitude' of the dacta divide, fit, then re-multiply.
%             data_order_mag = round(mean(floor(real(log10(ydat)))));
%             if isinf(data_order_mag); data_order_mag = 0; end
%             ydat = ydat / 10^data_order_mag;
%             edat = edat / 10^data_order_mag;
            
            %Guess Start Parameters
            code = ancos2_fn.auto_guess_code;
            x = xdat; y = ydat;
            for line = 1:length(code)
                eval([code{line} ';'])
            end
            ancos2_fn.values = guess_values;
            ancos2_fn.err_values = zeros(size(guess_values));

            start_params = ancos2_fn.values;
            vary_mask = double(not(ancos2_fn.fix));
            vary_params = 0.1*vary_mask;
            
            %Check if phase is locked - if so, replace the guessed phase with the fixed phase
            if phase_lock ==1;
                start_params(3) = phase_lock_angle; %Set the angle
                vary_params(3) = 0; %Fix the parameter
            end
            
            %Run the fit once
            pseudo_fn = 'ancos2_pseudo_fn';
            [fit_params, fit_params_err] = mf_lsqr_grasp(xdat,ydat,edat,start_params,vary_params,pseudo_fn,ancos2_fn);
            
            %***** Covarience checking *****
            disp(' ');
            disp('Covarience Checking');
            fit_params_err_cov = zeros(size(fit_params_err)); %only store the error
            params_to_vary = find(vary_params~=0);
            for n = 1:length(params_to_vary);
                temp_vary_params = zeros(size(vary_params));
                temp_vary_params(params_to_vary(n)) = vary_params(params_to_vary(n));
                %Recal the fitting function with the temporary vary_params
                [temp_fit_params, temp_fit_params_err] = mf_lsqr_grasp(xdat,ydat,edat,fit_params,temp_vary_params,pseudo_fn,ancos2_fn);
                fit_params_err_cov(params_to_vary(n)) = temp_fit_params_err(params_to_vary(n));
            end
              
%             %Fix - Undoo the order of mag division
%             fit_params(2) = fit_params(2)* 10^data_order_mag; %Offset
%             fit_params(3) = fit_params(3)* 10^data_order_mag; %Amplitude
%             fit_params_err(2) = fit_params_err(2)* 10^data_order_mag;
%             fit_params_err(3) = fit_params_err(3)* 10^data_order_mag;
            
            fit_list(counter,:) = rot90(fit_params);
            fit_list_error(counter,:) = rot90(fit_params_err);
            q_list(counter) = (sum(ring_data(:,4))/length(ring_data));
            counter = counter+1;
            
%             %***** Debugging - show fit data and fit  *****
            figure
             plot(ring_data(:,1),ring_data(:,2),'.');
%             %Generate the function
             x = 0:360;
             y = ancos2_pseudo_fn(x,fit_params,ancos2_fn);
             hold on
             plot(x,y,'green');
%             %***** End Debug *****
            
            
            else
                disp('Warning:  Ancos2 - Ring does not have enough data to fit at this radius')
            end
            
            
            
            %Delete message
            delete(message_handle);
            
            %Delete ancos2 sketch
            if not(isempty(rheo_anisotropy_sketch_handle))
                if ishandle(rheo_anisotropy_sketch_handle);
                    delete(rheo_anisotropy_sketch_handle);
                    rheo_anisotropy_sketch_handle = [];
                end
            end
            
            
            
        end
        
        
        
        
        
        %***** Abs Phase - That is what is fitted after all *****
        fit_list(:,2) = abs(fit_list(:,2));
        
        %***** Renormalize phase angle to between 0 and 180 *****
        while find(fit_list(:,3)>=135); temp = find(fit_list(:,3)>=135); fit_list(temp,3) = fit_list(temp,3)-180; end
        while find(fit_list(:,3)<-45); temp = find(fit_list(:,3)<-45); fit_list(temp,3) = fit_list(temp,3)+180; end
        
        %********** Cosine Offset:  Plot and Export Results ************
    
        
        plotdata(:,1) = depth_param(:);
        plotdata(:,2) = fit_list(:,1); %Cosine^2 Offset
        plotdata(:,3) = fit_list_error(:,1); %Cosine^2 Offset
        column_format = 'xye';
        
       
        plot_params = struct(...
            'plot_type','plot',...
            'hold_graph','off',...
            'plot_title',['Rheo Analysis : Cosine Offset'],...
            'x_label',([ depth_param_name ]),...
            'y_label',['Isotropic Scattering : ' displayimage.units],...
            'legend_str',['#' num2str(displayimage.params1(128)) ' off set' ],...
            'params',displayimage.params1,...
            'parsub',displayimage.subtitle,...
            'export_data',plotdata,...
            'info',displayimage.info,...
            'column_labels',['Parameter   ' char(9) 'Cos offset       ' char(9) 'Err_Cos offset   ']);
   %    'column_labels',(['Parameter(' depth_param_name ')'  'off set'  'err_off set' ]));
              % disp(['Depth #,     Parameter(' num2str(status_flags.user_modules.rheo_anisotropy.parameter) '),     Af,     Err_Af, ']);
 
 
        
        local_history = displayimage.history; %This will actually be the history of the last file
        local_history = [local_history, {['***** Analysis *****']}];

        local_history = [local_history, {['***** Fit with the Iso + Amp cos^2 (angle+phase) *****']}];
        
%        local_history = [local_history, {['Iso Scatt vs.  '  depth_param_name]}]; 
        
            local_history = [local_history, 'Iso Scatt vs.  ' depth_param_name];
        
        plot_params.history = local_history;
        grasp_plot(plotdata,column_format,plot_params);   
         
        
        %********** Cosine Amplitude:  Plot and Export Results ************
        plotdata(:,1) = depth_param(:);
        plotdata(:,2) = fit_list(:,2); %Cosine^2 Amplitude
        plotdata(:,3) = fit_list_error(:,2); %Cosine^2 Amplitude Error
        column_format = 'xye';
        plot_params = struct(....
            'plot_type','plot',....
            'hold_graph','off',....
            'plot_title',['Rheo Analysis : Cosine Amplitude'],....
            'x_label',([ depth_param_name ]),...
            'y_label',['Anisotropy Amplitude Scattering : ' displayimage.units],....
            'legend_str',['#' num2str(displayimage.params1(128)) '  Cos Amp'],...
            'params',displayimage.params1,....
            'parsub',displayimage.subtitle,....
            'export_data',plotdata,....
            'info',displayimage.info,....
            'column_labels',['Parameter   ' char(9) 'Cos Amp       ' char(9) 'Err_Cos Amp   ']);
        
        
        local_history = displayimage.history; %This will actually be the history of the last file
        local_history = [local_history, {['***** Analysis *****']}];

        local_history = [local_history, {['***** Fit with the Iso + Amp cos^2 (angle+phase) *****']}];
        
%        local_history = [local_history, {['Cos Amp vs. '  depth_param_name]}];
        
        
        plot_params.history = local_history;
        grasp_plot(plotdata,column_format,plot_params);
        
        
        %********** Cosine Phase:  Plot and Export Results ************
        if phase_lock ~=1;
            plotdata(:,1) = depth_param(:);
            plotdata(:,2) = fit_list(:,3); %Cosine^2 Phase
            plotdata(:,3) = fit_list_error(:,3); %Cosine^2 Phase Error
            column_format = 'xye';
            plot_params = struct(....
                'plot_type','plot',....
                'hold_graph','off',....
                'plot_title',['Rheo Analysis : Cosine Phase'],....
                'x_label',([ depth_param_name ]),...
                'y_label',['Cosine Phase'],....
                'legend_str',['#' num2str(displayimage.params1(128)) '  Cos Phase'],...
                'params',displayimage.params1,....
                'parsub',displayimage.subtitle,....
                'export_data',plotdata,....
                'info',displayimage.info,....
                'column_labels',['Parameter   ' char(9) 'Cos Phase       ' char(9) 'Err_Cos Phase   ']);
            
            local_history = displayimage.history; %This will actually be the history of the last file
        local_history = [local_history, {['***** Analysis *****']}];

        local_history = [local_history, {['***** Fit with the Iso + Amp cos^2 (angle+phase) *****']}];
        
%        local_history = [local_history, {['Cos Phase vs.  '  depth_param_name]}];
            
            
            
            
        
            plot_params.history = local_history;
            grasp_plot(plotdata,column_format,plot_params);
        end
        
        
        %Update the schematic annuli
        rheo_anisotropy_callbacks;
        
        
        
end





%Update rheo_anisotropy
radius = status_flags.user_modules.rheo_anisotropy.radius;
radius_width = status_flags.user_modules.rheo_anisotropy.radius_width;
phase_lock_angle = status_flags.user_modules.rheo_anisotropy.phase_angle;
phase_lock = status_flags.user_modules.rheo_anisotropy.phase_lock;
binning_Af = status_flags.user_modules.rheo_anisotropy.binning_Af;
color = status_flags.user_modules.rheo_anisotropy.color;

if status_flags.user_modules.rheo_anisotropy.parameter ==0; string = 'Depth';
else string = inst_params.vector_names{status_flags.user_modules.rheo_anisotropy.parameter};
end
set(grasp_handles.user_modules.rheo_anisotropy.parameter_string,'string',string);





%Update the window parameters
%set(grasp_handles.user_modules.rheo_anisotropy.start_radius,'string',num2str(start_radius));
%set(grasp_handles.user_modules.rheo_anisotropy.end_radius,'string',num2str(end_radius));
set(grasp_handles.user_modules.rheo_anisotropy.radius,'string',num2str(radius));
set(grasp_handles.user_modules.rheo_anisotropy.radius_width,'string',num2str(radius_width));
%set(grasp_handles.user_modules.rheo_anisotropy.radius_step,'string',num2str(radius_step));
%set(grasp_handles.user_modules.rheo_anisotropy.radius_Af,'string',num2str(radius_Af));
set(grasp_handles.user_modules.rheo_anisotropy.binning_Af,'string',num2str(binning_Af));
set(grasp_handles.user_modules.rheo_anisotropy.phase_lock_angle,'string',num2str(phase_lock_angle));
set(grasp_handles.user_modules.rheo_anisotropy.phase_lock_check,'value',phase_lock);
if phase_lock == 1; set(grasp_handles.user_modules.rheo_anisotropy.phase_lock_angle,'visible','on');
else set(grasp_handles.user_modules.rheo_anisotropy.phase_lock_angle,'visible','off'); end


%Delete any previous sketches
i = findobj('tag','rheo_anisotropy_sketch_handle');
if not(isempty(i));delete(i);end




%Delete old sectors
if isfield(grasp_handles.user_modules.rheo_anisotropy,'sketch_handle');
    temp = find(ishandle(grasp_handles.user_modules.rheo_anisotropy.sketch_handle));
    delete(grasp_handles.user_modules.rheo_anisotropy.sketch_handle(temp));
end
grasp_handles.user_modules.rheo_anisotropy.sketch_handle = [];

%Draw new sectors
for det = 1:inst_params.detectors
    cm = displayimage.cm.(['det' num2str(det)]);
    params = displayimage.(['params' num2str(det)]);
    
    
    %Find current detector distance for particular detector pannel
    det_current = params(inst_params.vectors.det); %Default unless otherwise
    if strcmp(status_flags.q.det,'detcalc');
        if isfield(inst_params.vectors,'detcalc')
            if not(isempty(inst_params.vectors.detcalc));
                det_current = params(inst_params.vectors.detcalc);
            end
        end
    end
    if isfield(inst_params.vectors,'det_pannel');
        det_current = params(inst_params.vectors.det_pannel);
    end
    
    %Keep a memory of the main detector(1) Det
    if det ==1; det1det = det_current; end

    
    
    
    
    %Pixel distances from Beam Centre
    if isfield(inst_params.vectors,'ox')
        cx_eff = cm.cm_pixels(1) - ((params(inst_params.vectors.ox) - cm.cm_translation(1))/inst_params.detector1.pixel_size(1));
    else
        cx_eff = cm.cm_pixels(1);
    end
    if isfield(inst_params.vectors,'oy')
        cy_eff = cm.cm_pixels(2) - ((params(inst_params.vectors.oy) - cm.cm_translation(2))/inst_params.detector1.pixel_size(1));
    else
        cy_eff = cm.cm_pixels(2);
    end
    
    
    %For conical radius scaling of multiple detectors
    eff_radius = radius * det_current / det1det;
    eff_radius_width = radius_width * det_current / det1det;
%    eff_end_radius = end_radius * det_current / det1det;
    
    eff_radius = radius * det_current / det1det;
    
    
    %Draw Sketches
    sector_handle = circle(det,eff_radius, eff_radius + eff_radius_width, cx_eff,cy_eff, 0, 360, color);
    grasp_handles.user_modules.rheo_anisotropy.sketch_handle = [grasp_handles.user_modules.rheo_anisotropy.sketch_handle; sector_handle];
    
    
  
    
end


