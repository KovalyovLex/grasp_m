function phi_348g

global status_flags

numor = 13097;
load_str = [num2str(numor) '{41}'];
load_data(1,2,load_str);
%Sector Boxs
%clear all boxes
sector_box_callbacks('clear_all');

fit_param_store.peak1 = [];
fit_param_store.peak2 = [];
fit_param_store.peak3 = [];
fit_param_store.peak4 = [];
fit_param_store.peak5 = [];
fit_param_store.peak6 = [];

inner = 12; outer = 21; dtheta = 35;
index = 1;
for theta = [325, 25, 85, 145, 205, 265];
    status_flags.analysis_modules.sector_boxes.coords1 = [outer, inner, theta, dtheta, 1, 0];
    %box it
    sector_box_callbacks('box_it');
    
    %fit it - gaussian
    fit1d(2,1,1);
    %close window
    pause(0.5)
    close
    
    depth = size(fit_param_store.(['peak' num2str(index)]));
    depth = depth(1) +1;
    fit_param_store.(['peak' num2str(index)])(depth,:) = [status_flags.fitter.function_info_1d.values(2), status_flags.fitter.function_info_1d.err_values(2), status_flags.fitter.function_info_1d.values(3), status_flags.fitter.function_info_1d.err_values(3), status_flags.fitter.function_info_1d.values(4), status_flags.fitter.function_info_1d.err_values(4)];
    index= index+1;
end



first_numor = 13179;
for n = 1:22
%for n = 1:1
    numor = first_numor+(82*(n-1));
    load_str = [num2str(numor) '{41}'];
    load_data(1,1,load_str);
    
    %Sector Boxs
    %clear all boxes
    sector_box_callbacks('clear_all');
    
    inner = 12; outer = 21; dtheta = 35;
    index =1;
    for theta = [325, 25, 85, 145, 205, 265];
        status_flags.analysis_modules.sector_boxes.coords1 = [outer, inner, theta, dtheta, 1, 0];
        %box it
        sector_box_callbacks('box_it');
        %fit it - gaussian
        fit1d(2,1,1);
        %close window
        pause(0.5)
        close
        
        depth = size(fit_param_store.(['peak' num2str(index)]));
        depth = depth(1)+1;
        fit_param_store.(['peak' num2str(index)])(depth,:) = [status_flags.fitter.function_info_1d.values(2), status_flags.fitter.function_info_1d.err_values(2), status_flags.fitter.function_info_1d.values(3), status_flags.fitter.function_info_1d.err_values(3), status_flags.fitter.function_info_1d.values(4), status_flags.fitter.function_info_1d.err_values(4)];
        index= index+1;
    end
end

fit_param_store.peak1
fit_param_store.peak2
fit_param_store.peak3
fit_param_store.peak4
fit_param_store.peak5
fit_param_store.peak6

dlmwrite('~/Desktop/peak1_phi348.dat',fit_param_store.peak1,'\t');
dlmwrite('~/Desktop/peak2_phi348.dat',fit_param_store.peak2,'\t');
dlmwrite('~/Desktop/peak3_phi348.dat',fit_param_store.peak3,'\t');
dlmwrite('~/Desktop/peak4_phi348.dat',fit_param_store.peak4,'\t');
dlmwrite('~/Desktop/peak5_phi348.dat',fit_param_store.peak5,'\t');
dlmwrite('~/Desktop/peak6_phi348.dat',fit_param_store.peak6,'\t');
    