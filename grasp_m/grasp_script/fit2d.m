function fit2d(fn,number_fns,guess_flag)

global status_flags

%fn is simply the function number as it appears in the list.  This is far easier for the moment.

if nargin <3;
    guess_flag = 1;
end
if nargin <2;
    number_fns = 1;
end
if nargin <1;
    fn = 'gauss_2d_n';
end

not_found_flag = [];
temp = [];

%open 2d curve fit window (if not already open)
curve_fit_window_2d

%Find and select the correct fitting function
i = findobj('tag','2d_fit_function_selector');
%Find the number of the fitting function in the list.
if not(isnumeric(fn))
    temp = get(i,'userdata');
    not_found_flag = 1;
    for n = 1:length(temp)
        if strcmpi(deblank(fn),deblank(temp(n,:)));
            not_found_flag = 0;
            break
        end
    end
    fn = n;
end


if not_found_flag ==1;
    beep
    disp('Fitting function not found');
    disp('Availiable functions are:');
    for n = 1:length(temp)
        disp(temp(n,:));
    end
else
    %Select the fitting function by it's number in the list.
    temp = get(i,'value');
    if not(temp==fn);
        set(i,'value',fn);
        status_flags.fitter.fn2d =fn;
        curve_fit_2d_callbacks('delete_curves');
        curve_fit_2d_callbacks('retrieve_fn');
        curve_fit_2d_callbacks('update_curve_fit_window');
    end
    
    i = findobj('tag','no_functions_selector_2d');
    temp = get(i,'value');
    if not(temp==number_fns);
        set(i,'value',number_fns);
        status_flags.fitter.number2d = number_fns;
        curve_fit_2d_callbacks('retrieve_fn');
        curve_fit_2d_callbacks('update_curve_fit_window');
    end
    
    if guess_flag == 1;
        curve_fit_2d_callbacks('auto_guess','auto_guess');
    end
    
    curve_fit_2d_callbacks('fit_it');
end
