function tof_iq

global status_flags
global grasp_data
global inst_params
global displayimage

%Churn through the depth doing the averages
index = data_index(status_flags.selector.fw);
foreground_depth = status_flags.selector.fdpth_max - grasp_data(index).sum_allow;
depth_start = status_flags.selector.fd; %remember the initial foreground depth

disp(['Averaging Workhseets through Depth']);
tof_iq_store = []; %Empty array

if  status_flags.selector.depth_range_min <= foreground_depth;
    d_start =  status_flags.selector.depth_range_min;
else
    d_start = foreground_depth;
end
if  status_flags.selector.depth_range_max<= foreground_depth;
    d_end =  status_flags.selector.depth_range_max;
else
    d_end = foreground_depth;
end

if strcmp(status_flags.analysis_modules.radial_average.display_update,'on');
    status_flags.command_window.display_params=1;
    status_flags.display.refresh = 1;
else
    status_flags.command_window.display_params=0;
    status_flags.display.refresh = 0;
end


% %Check for Sector Masks
% smask = [];
% if status_flags.analysis_modules.radial_average.sector_mask_chk ==1;
%     %Check sector window is still open
%     if ishandle(grasp_handles.window_modules.sector.window);
%         smask = sector_callbacks('build_sector_mask');
%     else
%         status_flags.analysis_modules.radial_average.sector_mask_chk =0;
%     end
% end
%
% %Check for Strip Masks
% strip_mask = [];
% if status_flags.analysis_modules.radial_average.strip_mask_chk ==1;
%     %Check if strip window is still open
%     if ishandle(grasp_handles.window_modules.strips.window);
%         strip_mask = strips_callbacks('build_strip_mask');
%     else
%         status_flags.analysis_modules.radial_average.strip_mask_chk =0;
%     end
% end

% %Prepare any aditional masks, e.g. sector & strip masks.
% mask = displayimage.(['mask' num2str(det)]);  %This is the combined user & instrument mask
% %Add the Sector Mask
% if not(isempty(smask));
%     mask = mask.*smask.(['det' num2str(det)]);
% end
% %Add the Strip Mask
% if not(isempty(strip_mask));
%     mask = mask.*strip_mask.(['det' num2str(det)]);
% end
%

%Radial and Azimuthal average takes the data directly from displayimage
iq_data = []; %Final iq for all detectors and all (TOF) frames
iq_big_list = zeros(10e6,8); %Final iq for all detectors and all (TOF) frames
pointer = 1;
tic

%Loop though all frames
for n = d_start:d_end
    message_handle = grasp_message(['Averaging Worksheets through Depth: ' num2str(n) ' of ' num2str(foreground_depth)]);
    status_flags.selector.fd = n+grasp_data(index).sum_allow;
    main_callbacks('depth_scroll'); %Scroll all linked depths and update
    
    for det = 1:inst_params.detectors
        
        if status_flags.display.(['axis' num2str(det) '_onoff']) ==1; %i.e. Detector is Active
            
            mask = displayimage.(['mask' num2str(det)]);  %This is the combined user & instrument mask
            
            %Check current displayimage is not empty
            if sum(sum(displayimage.(['data' num2str(det)])))==0 && sum(displayimage.(['params' num2str(det)]))==0
                disp(['Detector ' num2str(det) ' data and parameters are empty']);
            else
                
                
                %***** Turn 2D detector data into list(s) for re-binning *****
                %Turn 2D data into a list for re-binning
                temp = displayimage.(['qmatrix' num2str(det)])(:,:,5); %mod_q
                temp2 = displayimage.(['qmatrix' num2str(det)])(:,:,13); %delta_q (FWHM) - Classic Resolution
                temp3 = displayimage.(['qmatrix' num2str(det)])(:,:,11); %delta_q_lambda (FWHM)
                temp4 = displayimage.(['qmatrix' num2str(det)])(:,:,12); %delta_q_theta (FWHM)
                temp5 = displayimage.(['qmatrix' num2str(det)])(:,:,18); %delta_q_pixel (FWHM)
                temp6 = displayimage.(['qmatrix' num2str(det)])(:,:,19); %delta_q_sample_aperture (FWHM)
                
                iq_list = [];
                iq_list(:,1) = temp(logical(mask)); %mod q
                iq_list(:,2) = displayimage.(['data' num2str(det)])(logical(mask)); %Intensity
                iq_list(:,3) = displayimage.(['error' num2str(det)])(logical(mask)); %err_Intensity
                iq_list(:,4) = temp2(logical(mask)); %delta_q FWHM
                iq_list(:,5) = temp3(logical(mask)); %delta_q_lambda FWHM
                iq_list(:,6) = temp4(logical(mask)); %delta_q_theta FWHM
                iq_list(:,7) = temp5(logical(mask)); %delta_q_pixel FWHM
                iq_list(:,8) = temp6(logical(mask)); %delta_q_sample_aperture FWHM
                
                iq_big_list(pointer:(pointer+length(iq_list)-1),:) = iq_list;
                pointer = pointer + length(iq_list);
                
            end
        end
        
    end
end
%remove all zeros
temp = find(iq_big_list(:,1)~=0);
iq_big_list = iq_big_list(temp,:);


iq_list = iq_big_list;

status_flags.display.refresh = 1;
status_flags.command_window.display_params = 1;


%Generate Bin_Edges
q_min = min(iq_list(:,1)); q_max = max(iq_list(:,1));
n_bins =  status_flags.analysis_modules.rebin.n_bins;

%Bin Spacing
if strcmp(status_flags.analysis_modules.rebin.bin_spacing,'log');
    %Log Bin Spacing
    logq_span =  ceil(log10(q_max)) - floor(log10(q_min));
    bin_step = logq_span/n_bins;
    log_edges = floor(log10(q_min)):bin_step:ceil(log10(q_max));
    bin_edges = 10.^log_edges;
elseif strcmp(status_flags.analysis_modules.rebin.bin_spacing,'linear');
    %Linear Bin Spacing
    q_span = q_max - q_min;
    bin_step = q_span /n_bins;
    bin_edges = q_min:bin_step:q_max;
end



if length(bin_edges) <2;
    disp('Error generating Bin_Edges - not enough Bins')
    disp('Please check re-binning paramters');
end


%***** Now re-bin *****
if length(bin_edges) >=2;
    %temp = rebin([iq_list(:,1),iq_list(:,2),iq_list(:,3),iq_list(:,4)],bin_edges); %[q,I,errI,delta_q,pixel_count]
    temp = rebin(iq_list,bin_edges);
    iq_data = [iq_data; temp]; %append the iq data from the different detectors together
    %Note: Note, output from rebin is:
    %iq_data(:,1) = mod_q
    %iq_data(:,2) = Intensity
    %iq_data(:,3) = Err_Intensity
    %iq_data(:,4) = delta_q Classic q-resolution
    %iq_data(:,5) = delta_q Lambda
    %iq_data(:,6) = delta_q Theta
    %iq_data(:,7) = delta_q Detector Pixels
    %iq_data(:,8) = delta_q Sample Aperture
    
    %iq_data(:,9) = delta_q Binning (FWHM Square) - always next to last
    %iq_data(:,10) = # elements - always last
    
    %If enabled (ticked) add the binning resolution (FWHM) to the classic q-resolution (FWHM)
    if status_flags.resolution_control.binning_check == 1;
        %convert both back to sigma before adding in quadrature
        sigma1 = iq_data(:,4)/2.3548; %Came as a Gaussian FWHM
        sigma2 = iq_data(:,9)/3.4; %Came as a Square FWHM
        sigma = sqrt( sigma1.^2 + sigma2.^2 ); %Gaussian Equivalent
        fwhm = sigma * 2.3548;
        iq_data(:,4) = fwhm;
    end
    
end

%Check all the detector data wasn't empty
if isempty(iq_data);
    disp(['All detector data was empty:  Nothing to rebin']);
    return
end

toc


%
%***** Build Resolution Kernels for every q point *****
kernel_data.fwhmwidth = status_flags.resolution_control.fwhmwidth;
kernel_data.finesse = status_flags.resolution_control.finesse * status_flags.resolution_control.fwhmwidth;
if not(isodd(kernel_data.finesse)); kernel_data.finesse = kernel_data.finesse+1; end %Finesse should be ODD number
kernel_data.classic_res.fwhm = iq_data(:,4); kernel_data.classic_res.shape = 'Gaussian';

kernel_data.lambda.fwhm = iq_data(:,5); kernel_data.lambda.shape = '';
kernel_data.theta.fwhm = iq_data(:,6); kernel_data.theta.shape = 'tophat';
kernel_data.pixel.fwhm = iq_data(:,7); kernel_data.pixel.shape = 'tophat';
kernel_data.binning.fwhm = iq_data(:,9); kernel_data.binning.shape = 'tophat';
kernel_data.aperture.fwhm = iq_data(:,8); kernel_data.aperture.shape = 'tophat';

kernel_data.cm = displayimage.cm.(['det' num2str(det)]); %Send real beam profile in to use for resolution smearing
%Build the kernels

resolution_kernels = build_resolution_kernels(iq_data(:,1), kernel_data);


%Prepare the Data to Plot, Export, or keep for D33_TOF_Rebin
plot_data.xdat = iq_data(:,1);
plot_data.ydat = iq_data(:,2);
plot_data.edat = iq_data(:,3);
plot_data.exdat = resolution_kernels.fwhm;
%plot_data.resolution_kernels = resolution_kernels;
%plot_data.no_elements = iq_data(:,9);




%***** Plot I vs Q ****
column_labels = ['Mod_Q   ' char(9) 'I       ' char(9) 'Err_I   ' char(9) 'FWHM_Q'];

export_data = iq_data(:,1:4); %[q, I, err_I, dq resolutuion(fwhm)]
%classic resolution by default.
%or
%replace by gaussian equivalent resolution
if status_flags.resolution_control.convolution_type == 1 || status_flags.resolution_control.convolution_type == 2; %Real shape kernel & gaussian equivalent
    %    export_data(:,4) = resolution_kernels.fwhm(:,1);
end

if strcmp(status_flags.subfigure.show_resolution,'on')
    column_format = 'xyhe'; %Show resolution
    %Note, need to swap colums around for the ploterr fn.  Need [x,y,err_x,err_y]
    plotdata = [iq_data(:,1:2),iq_data(:,4),iq_data(:,3)];% IvsQ, Horz Delta_q FWHM and Vert Err_I error bars
else
    column_format = 'xye'; %Do not show resolution.
    %Note, uses Matlab errorbar fn.  Need [x,y,err_y]
    plotdata = [iq_data(:,1:3)];
end

plot_info = struct(....
    'plot_type','plot',....
    'hold_graph','on',....
    'plot_title',['Radial Re-grouping: |q|'],....
    'x_label',['|q| (' char(197) '^{-1})'],....
    'y_label',displayimage.units,....
    'legend_str',['#' num2str(displayimage.params1(128))],....
    'params',displayimage.params1,....
    'parsub',displayimage.subtitle,....
    'export_data',export_data,....
    'plot_data',plot_data,....
    'info',displayimage.info,....
    'column_labels',column_labels);
%plot_info.history = local_history;
grasp_plot(plotdata,column_format,plot_info);


%Set depth selector back to as before
status_flags.selector.fd = depth_start;
grasp_update

%Delete message
if ishandle(message_handle);
    delete(message_handle);
end


%         %Plot Radial Averaged Curves or Direct export to file
%         if status_flags.analysis_modules.radial_average.direct_to_file == 0; %plot curves
%
%             grasp_plot(plotdata,column_format,plot_info);
%
%         else % Direct to file
%             disp('Exporting Radial Average Direct to File')
%
%             %The code below is copied and modified from the export data
%             %routine in grasp_plot_menu_callbacks.
%
%             %In the future a better single routine should be called for
%             %exporting data
%
%             %Use different line terminators for PC or unix
%             if ispc; newline = 'pc'; terminator_str = [char(13) char(10)]; %CR/LF
%             else newline = 'unix'; terminator_str = [char(10)]; %LF
%             end
%
%             %ONLY use Auto file numbering for 'direct to file'
%             %***** Build Output file name *****
%             numor_str = num2str(plot_info.params(128));
%             a = length(numor_str);
%             if a ==1; addzeros = '00000';
%             elseif a==2; addzeros = '0000';
%             elseif a==3; addzeros = '000';
%             elseif a==4; addzeros = '00';
%             elseif a==5; addzeros = '0';
%             elseif a==6; addzeros = ''; end
%
%             fname = [addzeros numor_str '_' num2str(options2) '.dat']; %options2 is the depth number
%
%             %Open file for writing
%             disp(['Exporting data: '  grasp_env.path.project_dir fname]);
%             fid=fopen([grasp_env.path.project_dir fname],'wt');
%
%             %Check if to include history header
%             if strcmp(status_flags.subfigure.export.data_history,'on');
%                 history = plot_info.history;
%
%                 for m = 1:length(history)
%                     textstring = history{m};
%                     fprintf(fid,'%s \n',textstring);
%                 end
%                 fprintf(fid,'%s \n','');
%                 fprintf(fid,'%s \n','');
%             end
%
%             export_data = plot_info.export_data;
%             %Check if to include column labels
%             if strcmp(status_flags.subfigure.export.column_labels,'on')
%                 if isfield(plot_info,'column_labels');
%                     %Convert column labels to hwhm or fwhm if necessary
%                     if strcmp(status_flags.subfigure.export.resolution_format,'hwhm') %Convert to hwhm
%                         plot_info.column_labels = strrep(plot_info.column_labels,'FWHM_Q','HWHM_Q');
%                     elseif strcmp(status_flags.subfigure.export.resolution_format,'sigma') %Convert to sigma
%                         plot_info.column_labels = strrep(plot_info.column_labels,'FWHM_Q','Sigma_Q');
%                     end
%                     fprintf(fid,'%s \n',[plot_info.column_labels terminator_str]);
%                     fprintf(fid,'%s \n','');
%                 end
%             end
%
%             %Strip out any Nans
%             temp = find(not(isnan(export_data(:,1))));
%             export_data = export_data(temp,:);
%
%             %Check if to include q-reslution (4th column)
%             if strcmp(status_flags.subfigure.export.include_resolution,'on')
%                 %Check what format of q-resolution, sigma, hwhm, fwhm
%                 %Default coming though from Grasp is sigma
%                 if strcmp(status_flags.subfigure.export.resolution_format,'hwhm') %Convert to hwhm
%                     export_data(:,4) = export_data(:,4)/2; %hwhm
%                 elseif strcmp(status_flags.subfigure.export.resolution_format,'sigma') %Convert to sigma
%                     export_data(:,4) = export_data(:,4)/ (2 * sqrt(2 * log(2)));%fwhm
%
%                 end
%             else
%                 disp('help here:  radial_average_callbacks 409 & grasp_plot_menu_callbacks line 189')
%             end
%             dlmwrite([grasp_env.path.project_dir fname],export_data,'delimiter','\t','newline',newline,'-append','precision',6);
%             fclose(fid);
%         end
%     end
%
%
%
%
%
%
%
%
%
%
%
% end
%
% if ishandle(message_handle);
%     delete(message_handle);
% end
%
% toc
%end