function z_multiplex=pseudo_fn2d(xy,parameters_in,fitdata)

if nargin <3; fitdata = []; end

global status_flags

%Evaluate the function

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
        eval([status_flags.fitter.function_info_2d.variable_names{param_number} ' = ' num2str(parameters_in(param_number)) ';']);
        param_number = param_number+1;
    end
    for line = 1:length(status_flags.fitter.function_info_2d.math_code)
        eval(status_flags.fitter.function_info_2d.math_code{line});%this takes 'x' and gives a variable called 'y' as the result
    end
    if fn_multiplex ==1;
        z_multiplex = z;
    else
        z_multiplex = z_multiplex +z;
    end
end

