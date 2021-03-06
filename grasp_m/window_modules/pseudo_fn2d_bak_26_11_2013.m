function z_multiplex=pseudo_fn2d(xy,parameters_in,fitdata)

if nargin <3; fitdata = []; end

global status_flags
global grasp_data


%***** Evaluate the function *****

xy

fitdata
[fitdata.modqdat, fitdata.delta_q_dat]


figure
pcolor(100*fitdata.mask_mat.*fitdata.delta_q_mat./fitdata.modqmat);shading flat, colorbar
asdasa


if status_flags.analysis_modules.multi_beam.fit2d_checkbox ==0; %NOT Multi Beam
    
    %Multiplex control
    param_number = 1;
    for fn_multiplex = 1:status_flags.fitter.number2d;
        %Prepare the variables from the parameters
        for variable_loop = 1:status_flags.fitter.function_info_2d.no_parameters
            
            %check for grouped parameters
            if status_flags.fitter.function_info_2d.group(param_number) == 1;
                %parameter is grouped - copy the first copy of this parameter to this position
                parameters_in(param_number) = parameters_in(variable_loop);
            end
            %[status_flags.fitter.function_info_2d.variable_names{param_number} ' = ' num2str(parameters_in(param_number)) ';']
            eval([status_flags.fitter.function_info_2d.variable_names{param_number} ' = ' num2str(parameters_in(param_number)) ';']);
            param_number = param_number+1;
        end
        
        for line = 1:length(status_flags.fitter.function_info_2d.math_code)
            %status_flags.fitter.function_info_2d.math_code{line}
            eval(status_flags.fitter.function_info_2d.math_code{line});%this takes 'xy' and 'fitdata' and gives a variable called 'z' as the result
        end
        
        if fn_multiplex ==1;
            z_multiplex = z;
        else
            z_multiplex = z_multiplex +z;
        end
    end
    
    
    
    
    
else %***** MULTI BEAM *****
    
    
    for fn_multi_beam = 1:status_flags.analysis_modules.multi_beam.number_beams
        %Replace fitdata q-matricies with new data corresponding to beams
        
        fitdata.cm = fitdata.(['beam' num2str(fn_multi_beam)]).cm;
        fitdata.qxmat = fitdata.(['beam' num2str(fn_multi_beam)]).qxmat;
        fitdata.qymat = fitdata.(['beam' num2str(fn_multi_beam)]).qymat;
        fitdata.modqmat = fitdata.(['beam' num2str(fn_multi_beam)]).modqmat;
        fitdata.qanglemat = fitdata.(['beam' num2str(fn_multi_beam)]).qanglemat;
        fitdata.modqdat = fitdata.(['beam' num2str(fn_multi_beam)]).modqdat;
        fitdata.delta_q_dat = fitdata.(['beam' num2str(fn_multi_beam)]).delta_q_dat;
        
        %Multiplex control
        param_number = 1;
        for fn_multiplex = 1:status_flags.fitter.number2d;
            %Prepare the variables from the parameters
            for variable_loop = 1:status_flags.fitter.function_info_2d.no_parameters
                
                %check for grouped parameters
                if status_flags.fitter.function_info_2d.group(param_number) == 1;
                    %parameter is grouped - copy the first copy of this parameter to this position
                    parameters_in(param_number) = parameters_in(variable_loop);
                end
                %[status_flags.fitter.function_info_2d.variable_names{param_number} ' = ' num2str(parameters_in(param_number)) ';']
                eval([status_flags.fitter.function_info_2d.variable_names{param_number} ' = ' num2str(parameters_in(param_number)) ';']);
                param_number = param_number+1;
            end
            
            for line = 1:length(status_flags.fitter.function_info_2d.math_code)
                %status_flags.fitter.function_info_2d.math_code{line}
                eval(status_flags.fitter.function_info_2d.math_code{line});%this takes 'xy' and 'fitdata' and gives a variable called 'z' as the result
            end
            
            if fn_multiplex ==1;
                z_multiplex = z;
            else
                z_multiplex = z_multiplex +z;
            end
            
            
            
            %Get empty beam intensity for each beam
            if status_flags.analysis_modules.multi_beam.beam_scale_check == 1;
                
                %Find box coordinates for beam #
                x1 = status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(fn_multi_beam)]).x1;
                x2 = status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(fn_multi_beam)]).x2;
                y1 = status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(fn_multi_beam)]).y1;
                y2 = status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(fn_multi_beam)]).y2;
                
                beam_index = data_index(status_flags.calibration.beam_worksheet);
                %Note: at the moment the empty beam worksheet, worksheet
                %number and depth are hard-wired to correspond to the
                %foreground worksheet.  This may be changed in the future
                status_flags.calibration.beam_number = status_flags.selector.fn;
                status_flags.calibration.beam_depth = status_flags.selector.fd;
                %don't correct the depth for the sum - this is done already in retrieve data
                
                %***** Direct Beam Intensity *****
                %NOTE Empty beam intensity comes ONLY from the Rear Detector (1)
                %For D33, FRONT detector scattering data is also normalised to the
                %direct beam intensity for the REAR detector.
                
                %Retrieve direct beam data
                empty_beam = retrieve_data([beam_index, status_flags.calibration.beam_number, status_flags.calibration.beam_depth]);
                %Normalise direct beam data for deadtime, monitor & attenuator
                empty_beam = normalize_data(empty_beam);
                empty_beam_detector = 1; %This is the detector to use the empty beam intensity from for ALL other detectors
                
                if sum(sum(empty_beam.(['data' num2str(empty_beam_detector)]))) ~=0; %Check if direct beam worksheet is empty otherwise don't bother with below
                    
                    %Divide direct beam data also by detector efficiency
                    if status_flags.calibration.det_eff_check == 1;
                        %Retrieve the efficiency data
                        index = data_index(99);
                        efficiency_data = grasp_data(index).(['data' num2str(empty_beam_detector)]){1};
                        efficiency_error = grasp_data(index).(['error' num2str(empty_beam_detector)]){1};
                        %Only divide direct beam where there are valid efficiency data
                        temp = find(efficiency_data~=0);
                        [empty_beam.(['data' num2str(empty_beam_detector)])(temp),empty_beam.(['error' num2str(empty_beam_detector)])(temp)] = err_divide(empty_beam.(['data' num2str(empty_beam_detector)])(temp),empty_beam.(['error' num2str(empty_beam_detector)])(temp),efficiency_data(temp),efficiency_error(temp));
                        
                        %IS THIS BELOW A BIT DODGY?  SHOULD THESE INF's AND NAN's BE MASKED AS WELL
                        %Correct all NAN's - set them to zero.
                        temp = find(isnan(empty_beam.(['data' num2str(empty_beam_detector)]))); empty_beam.(['data' num2str(empty_beam_detector)])(temp) = 0;
                        temp = find(isnan(empty_beam.(['error' num2str(empty_beam_detector)]))); empty_beam.(['error' num2str(empty_beam_detector)])(temp) = 0;
                        %Correct all INF's - set them to zero.
                        temp = find(isinf(empty_beam.(['data' num2str(empty_beam_detector)]))); empty_beam.(['data' num2str(empty_beam_detector)])(temp) = 0;
                        temp = find(isinf(empty_beam.(['error' num2str(empty_beam_detector)]))); empty_beam.(['error' num2str(empty_beam_detector)])(temp) = 0;
                        %history = [history, {['Data: Corrected for Detector Efficiency (doesn''t change magnitude but contains curvature correction)']}];
                    end
                    
                    %Take the sum of the empty beam worksheet
                    emptybeam_sum = sum(sum(empty_beam.(['data' num2str(empty_beam_detector)])(y1:y2,x1:x2)));
                    emptybeam_sum_error = sqrt(sum(sum(empty_beam.(['error' num2str(empty_beam_detector)])(y1:y2,x1:x2).^2)));
                    
                    %Convert to flux by dividing by beam area
                    emptybeam_flux = emptybeam_sum / status_flags.calibration.sample_area;
                    emptybeam_flux_error = emptybeam_sum_error / status_flags.calibration.sample_area;
                    %additional \\cm2 units done later to correctly combine with volume units of cm3
                    
                    %                 %***** Divide all detectors data by the single direct beam intensity *****
                    %                 for det = 1:inst_params.detectors
                    %                     %Divide scattering data by emptybeam
                    %                     [foreimage.(['data' num2str(det)]), foreimage.(['error' num2str(det)])] = err_divide(foreimage.(['data' num2str(det)]), foreimage.(['error' num2str(det)]),emptybeam_flux, emptybeam_flux_error);
                    %                 end
                end
                
                
                z_multiplex = z_multiplex * emptybeam_flux;
                
            end
            
            
            
        end
        
        
        
        if fn_multi_beam == 1;
            z_multibeam = z_multiplex;
        else
           % size(z_multibeam)
           % size(z_multiplex)
            z_multibeam = z_multibeam + z_multiplex;
        end
    end
    
    z_multiplex = z_multibeam; %just swap variable names so gets out of the fn ok
    
    
end


