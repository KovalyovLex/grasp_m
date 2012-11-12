function fit1d(fn,curve_no,guess_flag)

%fn is simply the function number as it appears in the list.  This is far easier for the moment.

global status_flags

if nargin <3;
    guess_flag = 1;
end
if nargin <2;
    curve_no = 1;
end
if nargin <1;
    fn = 'Gaussian';
end

not_found_flag = [];
temp = [];

%open 1d curve fit window (if not already open)
grasp_plot_fit_window

%Find and select the correct fitting function
i = findobj('tag','fit_function_selector');
%Find the number of the fitting function in the list.
if not(isnumeric(fn))
    temp = get(i,'userdata')
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
        status_flags.fitter.fn1d =fn;
        grasp_plot_fit_callbacks('delete_curves');
        grasp_plot_fit_callbacks('retrieve_fn');
        grasp_plot_fit_callbacks('update_curve_fit_window');
    end
   
    i = findobj('tag','curve_fit_selector');
    str = get(i,'string');
    n = length(str);
    if curve_no <= n;
        set(i,'value',curve_no);
    end
    if guess_flag == 1;
        grasp_plot_fit_callbacks('auto_guess','auto_guess');
    end
    grasp_plot_fit_callbacks('fit_it');
end
