function rebin_callbacks(to_do)

global status_flags
global grasp_handles

if nargin <1; to_do = ''; end


%Radial Average Window & Parameter Callbacks
switch to_do
    
    case 'dii_power'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            status_flags.analysis_modules.rebin.dii_power = temp;
        end
        
    case 'dqq_power'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            status_flags.analysis_modules.rebin.dqq_power = temp;
        end
        
    case 'close'
        grasp_handles.window_modules.rebin.window = [];
        return
        
    case 'lin_radio'
        status_flags.analysis_modules.rebin.bin_spacing = 'linear';
        
    case 'log_radio'
        status_flags.analysis_modules.rebin.bin_spacing = 'log';
        
    case 'n_bins'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            status_flags.analysis_modules.rebin.n_bins = temp;
        end
        
    case 'dqq_bands'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp))
            if length(temp)>=2;
                status_flags.analysis_modules.rebin.regroup_bands = temp;
            else
                disp(' ')
                disp('Re-grouping bands must contain at least 2 band-edges')
                disp(' ')
            end
        end
end


%Update objects
if strcmp(status_flags.analysis_modules.rebin.bin_spacing,'linear');
    status = [1,0];
elseif strcmp(status_flags.analysis_modules.rebin.bin_spacing,'log');
    status = [0,1];
else
    status = [0,0];
end
set(grasp_handles.window_modules.rebin.radio_lin,'value',status(1));
set(grasp_handles.window_modules.rebin.radio_log,'value',status(2));
set(grasp_handles.figure.window_modules.rebin.n_bins,'string',num2str(status_flags.analysis_modules.rebin.n_bins));

regroup_bands_str = num2str(status_flags.analysis_modules.rebin.regroup_bands(1));
for n = 2:length(status_flags.analysis_modules.rebin.regroup_bands)
    regroup_bands_str = [regroup_bands_str, ', ' num2str(status_flags.analysis_modules.rebin.regroup_bands(n))];
end
set(grasp_handles.figure.window_modules.rebin.dqq_filter,'string', regroup_bands_str);

set(grasp_handles.figure.window_modules.rebin.dii_power,'string', status_flags.analysis_modules.rebin.dii_power);
set(grasp_handles.figure.window_modules.rebin.dqq_power,'string', status_flags.analysis_modules.rebin.dqq_power);

        