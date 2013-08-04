function foreimage=build_q_matrix(foreimage)

warning off
%foreimage contains all data arrays for all detectors and parameters.  cm
%contains all beam centres for all detectors.
%Output matrix has n x m x depth where the qmatrix depths are:
%(1) pixel_x, (2) pixel_y
%(3) qx, (4) qy, (5) mod q
%(6) q angle
%(7) 2theta_x, (8) 2theta_y, (9) mod_2theta
%(10) solid_angle
%(11) delta_q_lambda (12) delta_q_theta (13) delta_q
%(14) radius_x, (15) radius_y, (16) mod_radius  (m)
%(17) delta_theta
%(18) delta_q_pixel
%(19) detla_q_sample_aperture

global inst_params
global status_flags
global grasp_env

%Loop though the number of detectors
for det = 1:inst_params.detectors
    
    %Parameters for this detector
    det_params = inst_params.(['detector' num2str(det)]);
    params = foreimage.(['params' num2str(det)]);
    cm = foreimage.cm.(['det' num2str(det)]).cm_pixels;  %Beam centre coordinates in pixels
    cm_offset = foreimage.cm.(['det' num2str(det)]).cm_translation; %Detector pannel opening translation when beam centre was measured
    
    %Make empty q-matrix
    qmatrix =  zeros(det_params.pixels(2),det_params.pixels(1),16);
    
    %Make the pixel x & y matricies
    [pixel_x,pixel_y] = meshgrid(1:det_params.pixels(1),1:det_params.pixels(2));
    qmatrix(:,:,1) = pixel_x;
    qmatrix(:,:,2) = pixel_y;
    
    %Check that an empty parameter block hasn't been sent in
    if sum(params) ~= 0;
        
        %DAN:  Check if detector angle parameter exists
        dan_angle = 0; %unless otherwise parameter exists
        dan_offset = 0; %unless otherwise parameter exists
        if isfield(inst_params.vectors,'dan');
            if not(isempty(inst_params.vectors.dan));
                dan_angle = params(inst_params.vectors.dan);
                if isfield(inst_params,'dan_rotation_offset');
                    dan_offset = inst_params.dan_rotation_offset;
                end
            end
        end
        
        %DET:  Check if to use Det,  DetCalc (m) or Det_Pannel
        if strcmp(grasp_env.inst,'ILL_d33');
            sdet = params(inst_params.vectors.det); %Default, unless otherwise
            if strcmp(grasp_env.inst_option,'D33_Model_Data') %Instrument model
                if strcmp(status_flags.q.det,'detcalc');
                    if isfield(inst_params.vectors,'detcalc')
                        if not(isempty(inst_params.vectors.detcalc));
                            sdet = params(inst_params.vectors.detcalc);
                        end
                    end
                end
                if isfield(inst_params.vectors,'det_pannel');
                    sdet = params(inst_params.vectors.det_pannel);
                end
                
            elseif strcmp(grasp_env.inst_option,'D33') %real D33 with panel detector
                if det == 1; %Rear
                    sdet = params(inst_params.vectors.detcalc2);
                elseif det == 2; % Right
                    sdet = params(inst_params.vectors.detcalc1) + params(inst_params.vectors.det1_panel_offset);
                elseif det == 3; % Left
                    sdet = params(inst_params.vectors.detcalc1) + params(inst_params.vectors.det1_panel_offset);
                elseif det == 4; %Bottom
                    sdet = params(inst_params.vectors.detcalc1);
                elseif det == 5; %Top
                    sdet = params(inst_params.vectors.detcalc1);
                end
            end
            
        else  %All other cases
            
        sdet = params(inst_params.vectors.det); %Default, unless otherwise
        if strcmp(status_flags.q.det,'detcalc');
            if isfield(inst_params.vectors,'detcalc')
                if not(isempty(inst_params.vectors.detcalc));
                    sdet = params(inst_params.vectors.detcalc);
                end
            end
        end
        if isfield(inst_params.vectors,'det_pannel');
            sdet = params(inst_params.vectors.det_pannel);
        end
        
        end
        
        %Detector pixel size (x,y)
        pixelsize_x = det_params.pixel_size(1) * 1e-3; %x-pixel size in m
        pixelsize_y = det_params.pixel_size(2) * 1e-3; %y-pixel size in m
        
        %Wave vector (Angs-1)
        lambda = params(inst_params.vectors.wav);
        k = (2*pi)/lambda;
        
        %Pixel distances from Beam Centre
        if strcmp(grasp_env.inst,'ILL_d33')
            if strcmp(grasp_env.inst_option,'D33'); %Real D33 instrument with Panel Detector
                %det = 1 ;  Rear
                %det = 2 ;  Right
                %det = 3 ;  Left
                %det = 4 ;  Bottom
                %det = 5 ;  Top
                if det == 1; %Rear
                    %disp('build_q_matrix rear')
                    r_x = ((qmatrix(:,:,1) - cm(1))*pixelsize_x);
                    r_y = ((qmatrix(:,:,2) - cm(2))*pixelsize_y);
                elseif det == 2; % Right
                    r_x = ((qmatrix(:,:,1) - cm(1))*pixelsize_x) + (params(inst_params.vectors.oxr) - cm_offset(1))/1000; %horizontal distance from beam centre to pixel (m)
                    r_y = ((qmatrix(:,:,2) - cm(2))*pixelsize_y);
                elseif det == 3; % Left
                    r_x = ((qmatrix(:,:,1) - cm(1))*pixelsize_x) - (params(inst_params.vectors.oxl) - cm_offset(1))/1000; %horizontal distance from beam centre to pixel (m)
                    r_y = ((qmatrix(:,:,2) - cm(2))*pixelsize_y);
                elseif det == 4; %Bottom
                    r_x = ((qmatrix(:,:,1) - cm(1))*pixelsize_x);
                  r_y = ((qmatrix(:,:,2) - cm(2))*pixelsize_y) - (params(inst_params.vectors.oyb) - cm_offset(2))/1000; %vertical distance from beam centre to pixel (m)
                elseif det == 5; %Top
                    r_x = ((qmatrix(:,:,1) - cm(1))*pixelsize_x);
                    r_y = ((qmatrix(:,:,2) - cm(2))*pixelsize_y) + (params(inst_params.vectors.oyt) - cm_offset(2))/1000; %vertical distance from beam centre to pixel (m)
                end
                    
            elseif strcmp(grasp_env.inst_option,'D33_Instrument_Commissioning'); %Real D33 during comissioning (Rear Detector Only)
                r_x = ((qmatrix(:,:,1) - cm(1))*pixelsize_x);
                r_y = ((qmatrix(:,:,2) - cm(2))*pixelsize_y);
            elseif strcmp(grasp_env.inst_option,'D33_Model_Data'); %D33 Instrument Model
                r_x = ((qmatrix(:,:,1) - cm(1))*pixelsize_x) + (params(inst_params.vectors.ox) - cm_offset(1))/1000; %horizontal distance from beam centre to pixel (m)
                r_y = ((qmatrix(:,:,2) - cm(2))*pixelsize_y) + (params(inst_params.vectors.oy) - cm_offset(2))/1000; %vertical distance from beam centre to pixel (m)
            end
        else %All other instruments
            r_x = ((qmatrix(:,:,1) - cm(1))*pixelsize_x);
            r_y = ((qmatrix(:,:,2) - cm(2))*pixelsize_y);
        end
        qmatrix(:,:,14) = r_x; %radii (m) used for building sector masks
        qmatrix(:,:,15) = r_y;
        qmatrix(:,:,16) = sqrt(r_x.^2 + r_y.^2);
        
      
        
        %DAN Correction (22/9/2008)
        %Find true Sample - Pixel distance based on DET and DAN Rotation
        S = r_x * cos(dan_angle *pi/180);  %This is r_x corrected for the dan angle
        n = (pixel_x - (det_params.pixels(1) + 0.5)) * pixelsize_x * tan(dan_angle *pi/180);
        m = dan_offset - dan_offset*cos(dan_angle*pi/180);
        R = sdet - (m+n); %R is the effective projected detector distance corrected for DAN
        
        %Effective (project) radius on detector, mod_r
        mod_r = sqrt(S.^2 + r_y.^2); %S is used instead of r_x for DAN correction.
        %mod_r is then the projected radius on the detector and not the physical radius on the detector
        
       
        %Mod 2Theta
        two_theta = atan(mod_r ./ R); %radians.  R is used instead of DET for DAN correction
        qmatrix(:,:,9) = two_theta * (180/pi); %degrees in qmatrix;
        
        %2Theta_x & 2Theta_y (there is also a 2Theta_z component not calculated here)
        two_theta_x = atan(r_x / sdet); %radians
        qmatrix(:,:,7) = two_theta_x * (180/pi); %degrees in qmatrix;
        
        two_theta_y = atan(r_y / sdet); %radians
        qmatrix(:,:,8) = two_theta_y * (180/pi); %degrees in qmatrix;
        
        %Mod q
        mod_q = 2*k*sin(two_theta/2);
        qmatrix(:,:,5) = mod_q;
        
        %q_angle around the detector (measured clockwise from vertical)
        %This is not quite correct for DAN angles
        ang_array = ((atan2(r_x,r_y)) *180 / pi);
        temp = find(ang_array<0);
        ang_array(temp) = ang_array(temp) +360;
        qmatrix(:,:,6) = ang_array;
        
        %q_x and q_y components (resolved from Mod_q taking into acount the q_z component)
        q_x = mod_q.*cos(two_theta/2).*sin(ang_array*pi/180);
        qmatrix(:,:,3) = q_x;
        q_y = mod_q.*cos(two_theta/2).*cos(ang_array*pi/180);
        qmatrix(:,:,4) = q_y;
        
        %***** Solid Angle *****
        pixel_area = ones(det_params.pixels(2),det_params.pixels(1)).*(pixelsize_x * pixelsize_y); %m^2
        pixel_distance = zeros(det_params.pixels(2),det_params.pixels(1),5); %x,y, r, theta on detector, then R, distance to sample
        
        %geometry!
        % pixelx_line = ((1:det_params.pixels(1)) - cm(1))*pixelsize_x; %x distance from centre in m
        % pixely_line = ((1:det_params.pixels(2)) - cm(2))*pixelsize_y; %y distance from centre in m
        
        %Geometry - Pixel distances from Beam Centre
        if strcmp(grasp_env.inst,'ILL_d33')
            if strcmp(grasp_env.inst_option,'D33'); %Real D33 instrument with Panel Detector
                if det == 1; %Rear
                    pixelx_line = ((1:det_params.pixels(1)) - cm(1))*pixelsize_x; %x distance from centre in m
                    pixely_line = ((1:det_params.pixels(2)) - cm(2))*pixelsize_y; %y distance from centre in m
                elseif det == 2; % Right
                    pixelx_line = (((1:det_params.pixels(1)) - cm(1))*pixelsize_x) + (params(inst_params.vectors.oxr) - cm_offset(1))/1000; %x distance from centre in m
                    pixely_line = ((1:det_params.pixels(2)) - cm(2))*pixelsize_y; %y distance from centre in m
                elseif det == 3; % Left
                    pixelx_line = (((1:det_params.pixels(1)) - cm(1))*pixelsize_x)  - (params(inst_params.vectors.oxl) - cm_offset(1))/1000; %x distance from centre in m
                    pixely_line = ((1:det_params.pixels(2)) - cm(2))*pixelsize_y; %y distance from centre in m
                elseif det == 4; %Bottom
                    pixelx_line = ((1:det_params.pixels(1)) - cm(1))*pixelsize_x; %x distance from centre in m
                    pixely_line = ((1:det_params.pixels(2)) - cm(2))*pixelsize_y  - (params(inst_params.vectors.oyb) - cm_offset(2))/1000; %y distance from centre in m
                elseif det == 5; %Top
                    pixelx_line = ((1:det_params.pixels(1)) - cm(1))*pixelsize_x; %x distance from centre in m
                    pixely_line = (((1:det_params.pixels(2)) - cm(2))*pixelsize_y)  + (params(inst_params.vectors.oyt) - cm_offset(2))/1000; %y distance from centre in m
                end
                
            elseif strcmp(grasp_env.inst_option,'D33_Instrument_Commissioning'); %Real D33 during comissioning (Rear Detector Only)
                pixelx_line = ((1:det_params.pixels(1)) - cm(1))*pixelsize_x; %x distance from centre in m
                pixely_line = ((1:det_params.pixels(2)) - cm(2))*pixelsize_y; %y distance from centre in m
                
            elseif strcmp(grasp_env.inst_option,'D33_Model_Data'); %D33 Instrument Model
                pixelx_line = (((1:det_params.pixels(1)) - cm(1))*pixelsize_x) + (params(inst_params.vectors.ox) - cm_offset(1))/1000; %x distance from centre in m
                pixely_line = (((1:det_params.pixels(2)) - cm(2))*pixelsize_y)  + (params(inst_params.vectors.oy) - cm_offset(2))/1000; %y distance from centre in m
            end
        else %All other instruments
            pixelx_line = ((1:det_params.pixels(1)) - cm(1))*pixelsize_x; %x distance from centre in m
            pixely_line = ((1:det_params.pixels(2)) - cm(2))*pixelsize_y; %y distance from centre in m
            
        end
        [pixel_distance(:,:,1), pixel_distance(:,:,2)] = meshgrid(pixelx_line,pixely_line);
        
        
        %Correct pixel area for curvature effect
        effective_pixel_area = pixel_area .* cos((dan_angle*pi/180) - two_theta_x) .* cos(two_theta_y);
        
        %Calculate distance from sample in x-plane taking into account DAN
        pixel_distance_x = sqrt(R.^2 + S.^2);
        pixel_distance(:,:,3) = sqrt(pixel_distance_x.^2 + (pixel_distance(:,:,2).^2));
        %Finally calculate solid angle subtended by each pixel
        qmatrix(:,:,10) = effective_pixel_area./(pixel_distance(:,:,3).^2); %matrix - to account for distortions of flat detector against scattering sphere at short distances.
        
        
        
        %***** Calcualte resolution components, dq, dtheta or dlambda *****
        if status_flags.command_window.display_params ==1 & det ==1;
            disp('***** Resolution Components: *****');
        end
        
        %***** Beam Divergence *****
        col = params(inst_params.vectors.col); source_geometry = '';
        
        %Check if source aperture size is explicitly defined (e.g. NIST data)
        if isfield(inst_params.vectors,'source_ap');
            ap_geometry = params(inst_params.vectors.source_ap);
        
        else %Where col and aperture position number are defined (e.g. D22, D11 etc.)
            %Find the geometric source size and geometry
            col_index = find(single(inst_params.col)== single(col));
            if not(isempty(col_index));
                col_ap = inst_params.col_aps{col_index};
            else
                col_ap = [];
            end
            if isfield(inst_params.vectors,'col_app');
                ap_geometry = col_ap{params(inst_params.vectors.col_app)+1}; %these parameters are not yet defined
            else
                if isempty(col_ap); ap_geometry = [];
                else ap_geometry = col_ap{1};
                end
            end
            if isempty(ap_geometry); ap_geometry = inst_params.guide_size; end %Take guide size as default
        end
        
        %Determine source geometry
        if length(ap_geometry) ==2;
            if ap_geometry(1) == ap_geometry(2); source_geometry = 'Square';
            else source_geometry = 'Rectangular';
            end
        else source_geometry = 'Circular';
        end
        
        if strcmp(source_geometry,'Square') || strcmp(source_geometry,'Rectangular');
            if status_flags.command_window.display_params ==1 & det ==1;
                disp(['Effective source is ' source_geometry ' of dimensions:  ' num2str(ap_geometry(1)*1000) ' (mm)  x  ' num2str(ap_geometry(2)*1000) ' (mm)   at a distance of: ' num2str(col) ' (m)']);
            end
            div_x = ap_geometry(1) / col; %Radians FWHM TOPHAT Distribution
            div_y = ap_geometry(2) / col; %Radians FWHM TOPHAT Distribution
            
        elseif strcmp(source_geometry,'Circular');
            if status_flags.command_window.display_params ==1 & det ==1;
                disp(['Effective source is Circular of dimensions:  ' num2str(ap_geometry(1)*1000) ' (mm) Diameter at a distance of: ' num2str(col) ' (m)']);
            end
            div_x = ap_geometry(1) / col; %Radians FWHM TOPHAT Distribution
            div_y = ap_geometry(1) / col; %Radians FWHM TOPHAT Distribution
        end
        
        if strcmp(source_geometry,'Circular');
            %For circular beam profile
            d_theta = sqrt( (div_x * sin(qmatrix(:,:,6)*pi/180)).^2 + (div_y * cos(qmatrix(:,:,6)*pi/180)).^2  );
        
        elseif strcmp(source_geometry,'Square') || strcmp(source_geometry,'Rectangular');
            %For rectangular beam profile
            %Which Mean to take?
            %d_theta = sqrt((div_x.^2 + div_y.^2)/2); %RMS FWHM TOPHAT profile
            %d_theta = (div_x + div_y)/2; %Mean FWHM TOPHAT profile
            %d_theta = sqrt(div_x.*div_y); %Geometric Mean (square of equivalent area) FWHM TOPHAT profile
            d_theta = 2*sqrt((div_x.*div_y)/pi); %Cricle of the same area FWHM TOPHAT profile
        end
       
        d_theta = d_theta /2;  %(Radians) Above actually calculates Delta_2Theta FWHM TOPHAT Distribution
        qmatrix(:,:,17) = d_theta*180/pi; %(Degrees) Delta Theta  FWHM TOPHAT Distribution in qmatrix
        
        
        %***** Wavelength Spread - Monochromatic SANS: determined by velocity selector (triangular distribution)*****
        lambda = params(inst_params.vectors.wav); %absolute wavelength
        if isfield(inst_params.vectors,'deltawav');
            d_lambda_lambda = params(inst_params.vectors.deltawav); %Fraction (e.g. 0.1 FWHM TRIANGULAR distribution for velocity selector)
            if status_flags.command_window.display_params ==1 & det ==1;
                disp(['Wavelength resolution d_lambda / lambda:  ' num2str(d_lambda_lambda*100) ' [%]']);
            end
        else
            if status_flags.command_window.display_params == 1 & det == 1;
                disp('Warning:  Parameter ''Delta_Lambda'' does not exist');
                disp('Using default assumed 10% FWHM wavelength spread');
            end
            d_lambda_lambda = 0.1; %10% FWHM default
        end
        %Check for bad wavelength resolution parameter (coming in from D11)
        if  d_lambda_lambda ==0;
            disp('WARNING:  Wavelength resolution = 0')
            disp('Patching Delta lamda to a default 10%');
            d_lambda_lambda = 0.1;
        end
        
        
        %Wavelength delta_q resolution component
        warning off
        q = qmatrix(:,:,5);
        d_q_lambda_squared = (q.^2) .* (d_lambda_lambda.^2);
        qmatrix(:,:,11) = real(sqrt(d_q_lambda_squared)); %FWHM Triangular (selector) or Top-Hat (D33 TOF)
        
        %Divergence delta_q resolution component (Geometric)
        d_q_theta_squared = (d_theta.^2) .* ( ((4*pi / lambda).^2)  - (q.^2) );
        qmatrix(:,:,12) = real(sqrt(d_q_theta_squared)); %FWHM TOPHAT
        
        %Detector Pixelation smearing
        [d_q_pixel_line_x] = (gradient(qmatrix(det_params.pixels(2)/2,:,3)));%FWHM TOPHAT profile
        [d_q_pixel_line_y] = (gradient(qmatrix(:,det_params.pixels(1)/2,4)));%FWHM TOPHAT profile
        [temp1,temp2] = meshgrid(d_q_pixel_line_x, d_q_pixel_line_y);
        %Which Mean to take?
        %d_q_pixel = sqrt((temp1.^2 + temp2.^2)/2); %RMS FWHM TOPHAT profile
        %d_q_pixel = (temp1 + temp2)/2; %Mean FWHM TOPHAT profile
        %d_q_pixel = sqrt(temp1.*temp2); %Geometric Mean (square of equivalent area) FWHM TOPHAT profile
        d_q_pixel = 2*sqrt((temp1.*temp2)/pi); %Cricle of the same area FWHM TOPHAT profile
        qmatrix(:,:,18) = d_q_pixel; %FWHM TOPHAT Profile
        if status_flags.command_window.display_params ==1 & det ==1;
            disp(['Detector pixelation:']);
        end

        
        
        %Aperture (sample) smearing
        sample_ap_size = status_flags.resolution_control.aperture_size; %m (diameter)
        r = (sample_ap_size/2)*(col + sdet)/col;
        two_theta_ap = atan(r/sdet);
        delta_q_ap_hwhm = (4*pi/lambda)*sin(two_theta_ap/2);
        delta_q_ap_fwhm = delta_q_ap_hwhm*2;
        qmatrix(:,:,19) = delta_q_ap_fwhm; %FWHM Top_Hat Distribution 
        if status_flags.command_window.display_params ==1 & det ==1;
            disp(['Sample aperture: assuming circular  ' num2str(sample_ap_size*1000) ' [mm] diameter']);
        end

        % ***** Classic Resolution ****
        % Total q-resolution (add components in quadrature)
        
        %convert to sigmas to add in quadrature
        if status_flags.resolution_control.wavelength_type ==1;
            d_q_lambda_squared = d_q_lambda_squared ./ (2.45^2); %fwhm = 2.45sigma (triangular)
        elseif status_flags.resolution_control.wavelength_type ==2;
            d_q_lambda_squared = d_q_lambda_squared ./ (3.4^2); %fwhm = 3.4sigma (to-hat)
        end
        d_q_theta_squared = d_q_theta_squared ./ (3.4^2);
        d_q_ap_squared = (delta_q_ap_fwhm^2) ./ (3.4^2); %fwhm to sigma for square
        d_q_pixel_squared = mean(mean(d_q_pixel))^2 / (3.4^2); %fwhm to sigma for square
        
        %Check if to use all components
        if status_flags.resolution_control.wavelength_check == 0; d_q_lambda_squared = 0; end
        if status_flags.resolution_control.divergence_check == 0; d_q_theta_squared = 0; end
        if status_flags.resolution_control.aperture_check == 0; d_q_ap_squared = 0; end
        if status_flags.resolution_control.pixelation_check == 0; d_q_pixel_squared = 0; end
        
        %Add all resolution components 'sigma's' in quadrature (Gaussian Aproximation)
        delta_q_squared = d_q_lambda_squared  +   d_q_theta_squared   + d_q_ap_squared  +  d_q_pixel_squared;
        delta_q = real(sqrt(delta_q_squared));
        
        delta_q = delta_q*2.3548; %back to fwhm Gaussian
        
        qmatrix(:,:,13) = delta_q; %FWHM - to be used in gaussian approximation after
    end
    foreimage.(['qmatrix' num2str(det)]) = qmatrix;
end
warning on
