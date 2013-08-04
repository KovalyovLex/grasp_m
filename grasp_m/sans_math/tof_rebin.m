function binned_array = tof_rebin(array,res_kernels,bin_edges)

global status_flags

temp=size(array);
if temp(2)<4;
    array(:,4) = zeros(temp(1),1);
end

number_bins = length(bin_edges);

%Output binned_array.array :  Columns are Av_x, Av_Y, Av_Err_y, etc etc, bin_resolution, number_elements
%       binned_array.res_kernels.x
%       binned_array.res_kernels.weight


warning off
m = 1;
[temp1,temp2] = size(array);
bin_resolution = diff(bin_edges);
for n = 1:number_bins-1;
    temp = find((array(:,1) >= bin_edges(n)) &  (array(:,1) < bin_edges(n+1)));
    if not(isempty(temp)) %i.e. values falling between the bin_edges have been found
        number_elements = length(temp);
        
        %Estimate quality factor of individual points
        %proportional to 1/ di/i * dq/q
        di_i = array(temp,3)./array(temp,2);
        %Check for nans coming though from having 0 counts & 0 error in sparse data
        nan_check = find(isnan(di_i));
        if not(isempty(nan_check)); di_i(nan_check) = 1; end
        dq_q = array(temp,4)./array(temp,1);
        
        
        quality_factor = 1./((di_i.^status_flags.analysis_modules.rebin.dii_power).*(dq_q.^status_flags.analysis_modules.rebin.dqq_power));
        
        %Check for very low statistics
        low_stats = find(abs(di_i) > 0.1);
        if not(isempty(low_stats)); quality_factor(low_stats) = 1; end
 
        binned_array.array(m,1) = sum(array(temp,1).*quality_factor) / sum(quality_factor); %Q
        binned_array.array(m,2) = sum(array(temp,2).*quality_factor) / sum(quality_factor); %I
        binned_array.array(m,3) = sqrt( sum((array(temp,3).*quality_factor).^2)) / sum(quality_factor); %Err I
        
        for column = 4:temp2
            binned_array.array(m,column) = sum(array(temp,column)) / number_elements;
        end
        binned_array.array(m,temp2+1) = bin_resolution(n); %Bin resolution FWHM TOPHAT
        binned_array.array(m,temp2+2) = number_elements; %Nu. elements used in averaging
        
        %Resolution Kernel Averaging
        binned_array.res_kernels.weight{m} = res_kernels.weight{temp(1)}*quality_factor(1);
        binned_array.res_kernels.x{m} = res_kernels.x{temp(1)}*quality_factor(1);
        for nn = 2:length(temp)
            binned_array.res_kernels.weight{m} = binned_array.res_kernels.weight{m} + res_kernels.weight{temp(nn)}*quality_factor(nn);
            binned_array.res_kernels.x{m} = binned_array.res_kernels.x{m} + res_kernels.x{temp(nn)}*quality_factor(nn);
        end
        binned_array.res_kernels.weight{m} =  binned_array.res_kernels.weight{m} / sum(quality_factor);
        binned_array.res_kernels.x{m} =  binned_array.res_kernels.x{m} / sum(quality_factor);
         
        %Calculate the Gaussian Equivalent of this averaged resolution
        %Std deviation of this distribution - Gaussian Equivalent Resolution for export
        variance = sum(binned_array.res_kernels.weight{m}.*(binned_array.res_kernels.x{m}- binned_array.array(m,1)).^2)/(sum(binned_array.res_kernels.weight{m}));
        sigma = sqrt(variance);
        binned_array.res_kernels.fwhm(m,1) = sigma *(2*sqrt(2*log(2)));

        
        
        
        m = m+1;
        
    end
end
warning on


