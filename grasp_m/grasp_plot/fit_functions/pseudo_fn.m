function y_out=pseudo_fn(x_in,parameters_in,fitdata)

if nargin <3; fitdata = []; end

global status_flags

%Evaluate the function
%Defaults if no smearing
finesse = 1;
x_smear = x_in;
x_weight = ones(size(x_smear));

%q-resolution data can be sent as:
%fitdata.exdat_all - combined overall q resolution, delta_q(q)
%AND / OR
%fitdata.resolution_kernels_all
%with fields
%   .lambda.sigma  .shape
%   .theta.sigma .shape
%   .pixel.sigma .shape
%   .binning.sigma .shape
%   .x {cell} - cells of lines of x-coordinates corresponding to the convolution kernel
%   .weight {cell} - cells of lines of weights corresponding to the convolution kernel
%   .sigma - combined overall q resolution, delta_q(q).  Same as in fitdata.exdat_all

% %Plot Resolutions
plot_res = 'off';
if strcmp(plot_res,'on'); figure; end

%***** Instrument Resolution Convolution Control *****
if status_flags.fitter.include_res_check ==1;  %Convolute instrument resolution if availaible
    
    if not(isfield(fitdata,'resolution_kernels_all')); fitdata.resolution_kernels_all = []; end
    
    if not(isempty(fitdata.resolution_kernels_all)) %Full resolution kernels exist - use this in preference
        %disp('Convoluting to pre-built resolution kernel in pseudo_fn.m')
        if not(isempty(fitdata.resolution_kernels_all))
            
            finesse = length(fitdata.resolution_kernels_all.x{1}); %Find out what finesse was used in caluclating the kernels
            x_smear = []; x_weight = [];
            for n = 1:length(fitdata.resolution_kernels_all.x);
                %Kernels are already build, just need to string them together into a list
                x_smear = [x_smear; rot90(fitdata.resolution_kernels_all.x{n},3)];
                x_weight = [x_weight; rot90(fitdata.resolution_kernels_all.weight{n},3)];
                
                if strcmp(plot_res,'on')
                    if n == 1 || n==round(length(fitdata.resolution_kernels_all.x)/2) || n==length(fitdata.resolution_kernels_all.x)
                        hold on
                        plot(fitdata.resolution_kernels_all.x{n},fitdata.resolution_kernels_all.weight{n},'.-w')
                    end
                end
            end
        end
        
        
    elseif isfield(fitdata,'exdat_all') %Convolute to Gaussian resolution if full shape kernel no availaible
        
        %disp('Convoluting to Instrument resolution with Gaussian Kernel in pseudo_fn.m');
        if not(isempty(fitdata.exdat_all))
            disp('No full shape kernel availaible in: pseudo_fn.m');
            disp('using exdat to generate gaussian kernal in pseudo_fn.m');
            %Run the model below for a range of q's weighted by a distribution describing the resolution
            %Build all the new x-matricies
            x_smear = []; x_weight = [];
            
            fwhmwidth = status_flags.resolution_control.fwhmwidth;
            finesse = status_flags.resolution_control.finesse * status_flags.resolution_control.fwhmwidth;
            for n = 1:length(x_in)
                
                %Make x coordinate range in high resolution for each x_in point
                low = x_in(n)-fwhmwidth*fitdata.exdat_all(n); high = x_in(n)+fwhmwidth*fitdata.exdat_all(n);
                dx = (high -low) /(finesse-1); %Make sure there is an ODD number of points
                new_x = low:dx:high; %Kernel x-range in higher resolution than the original data
 
                %Convolution function
                [weight] = gauss_kernel_1d(x_in(n),fitdata.exdat_all(n)/(2*sqrt(2*log(2))),1,new_x); %Arguments (xcentre,sigma_x,intint,x_range,dx)
                weight = weight*dx;
                
                %Plot resolution
                if strcmp(plot_res,'on');
                    if n ==1 || n == length(x_in);
                        hold on
                        plot(new_x,weight,'-m.');
                    end
                end
                
                %assemble a new x_list
                x_smear = [x_smear; rot90(new_x,3)];
                x_weight = [x_weight; rot90(weight,3)];
            end
        end
    else
        %disp('No Instrument Resolution information found')
    end
end


%The above produces a new x-list to run through the function
x = x_smear; %Replace variable name as all functions expect 'x'

math_Code = {};

%Multiplex control
param_number = 1;
for fn_multiplex = 1:status_flags.fitter.number1d;
	
	% Fill Math Code --
	for line = 1:length(status_flags.fitter.function_info_1d.math_code)
        math_Code{line} = status_flags.fitter.function_info_1d.math_code{line};
    end

    %Prepare the variables from the parameters
    for variable_loop = 1:status_flags.fitter.function_info_1d.no_parameters
        
        %check for grouped parameters
        if status_flags.fitter.function_info_1d.group(param_number) == 1;
            %parameter is grouped - copy the first copy of this parameter to this position
            parameters_in(param_number) = parameters_in(variable_loop);
        end
		
		%Prepare function with parameters --
        if ( strcmp(status_flags.fitter.function_info_1d.variable_names{param_number},status_flags.fitter.function_info_1d.functions{param_number}) )
            eval([status_flags.fitter.function_info_1d.variable_names{param_number} ' = ' num2str(parameters_in(param_number)) ';']);
        else
            % replace parameter for function
            for line = 1:length(status_flags.fitter.function_info_1d.math_code)
                math_Code{line} = strrep(math_Code{line},status_flags.fitter.function_info_1d.variable_names{param_number},status_flags.fitter.function_info_1d.functions{param_number});
            end
        end
		param_number = param_number+1;
    end
    for line = 1:length(status_flags.fitter.function_info_1d.math_code)
        %status_flags.fitter.function_info_1d.math_code{line}
        eval(math_Code{line});%this takes 'x' and gives a variable called 'y' as the result
    end
    
    if fn_multiplex ==1;
        y_multiplex = y;
    else
        y_multiplex = y_multiplex +y;
    end
end

%figure
%plot(x,y_multiplex,'.')

%The final y_multiplex value here is actually too long in the case of smearing an needs weighted averaging
%Final Weighted average smearing
y_out = [];
counter = 1;
for n =1:length(x_in);
    y_out(n) = 0;
%    x_out(n) = 0;
    for m = 1:finesse
        if counter > length(y_multiplex); break; end %Trying to error trap Poly Sphere model with poly = 0
        y_out(n) = y_out(n) + y_multiplex(counter)*x_weight(counter); %The smeared intensity
        counter = counter +1;
    end
end
y_out = rot90(y_out,3);
