function foreimage = divide_detector_efficiency(foreimage)

global inst_params
global grasp_data
global status_flags

eff_index = data_index(99); %index to the detector efficiency worksheet
eff_number = status_flags.calibration.det_eff_nmbr;


%Loop though the detector
warning off % gonna get some Nan's and Inf's here
for det = 1:inst_params.detectors
    
    %Divide by efficiency map
    [foreimage.(['data' num2str(det)]),foreimage.(['error' num2str(det)])] = err_divide(foreimage.(['data' num2str(det)]),foreimage.(['error' num2str(det)]),grasp_data(eff_index).(['data' num2str(det)]){eff_number},grasp_data(eff_index).(['error' num2str(det)]){eff_number});
    
    %Divide by detector relative efficiency (relative to rear detector (det 1)
    foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) / inst_params.(['detector' num2str(det)]).relative_efficiency;
    foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) / inst_params.(['detector' num2str(det)]).relative_efficiency;
    
    
    
    %Create a nan and inf mask for the data in case of divide by zeros in the efficiency etc.
    foreimage.(['nan_mask' num2str(det)]) = ones(size(foreimage.(['data' num2str(det)])));
    
    temp = find(isnan(foreimage.(['data' num2str(det)])));
    foreimage.(['nan_mask' num2str(det)])(temp) = 0;
    foreimage.(['data' num2str(det)])(temp) = 0;
    foreimage.(['error' num2str(det)])(temp) = 0;
    
    
    temp = find(isinf(foreimage.(['data' num2str(det)])));
    foreimage.(['nan_mask' num2str(det)])(temp) = 0;
    foreimage.(['data' num2str(det)])(temp) = 0;
    foreimage.(['error' num2str(det)])(temp) = 0;
    
    
end
warning on;


