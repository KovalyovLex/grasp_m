function y_multiplex=ancos2_pseudo_fn(x,parameters_in,fn_info)

%Evaluate the function

%Multiplex control
param_number = 1;
for fn_multiplex = 1:fn_info.number1d;
    %Prepare the variables from the parameters
    for variable_loop = 1:fn_info.no_parameters
        
        %check for grouped parameters
        if fn_info.group(param_number) == 1;
            %parameter is grouped - copy the first copy of this parameter to this position
            parameters_in(param_number) = parameters_in(variable_loop);
        end
        eval([fn_info.variable_names{param_number} ' = ' num2str(parameters_in(param_number)) ';']);
        param_number = param_number+1;
    end
    for line = 1:length(fn_info.math_code)
        eval(fn_info.math_code{line});%this takes 'x' and gives a variable called 'y' as the result
    end
    if fn_multiplex ==1;
        y_multiplex = y;
    else
        y_multiplex = y_multiplex +y;
    end
end

