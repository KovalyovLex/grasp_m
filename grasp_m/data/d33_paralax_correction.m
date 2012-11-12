function foreimage = d33_paralax_correction(foreimage)

global inst_params

for det =1:inst_params.detectors
    
    data2theta_y = abs(foreimage.(['qmatrix' num2str(det)])(:,:,8)); %y_scattering angle
    
    %D33 rear detector paralax seems approximately linear with params
    gradient = 0.75;
    offset = 100;
        
    response_function = 1+ (gradient / offset).*data2theta_y;
    foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) ./ response_function;
    foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) ./ response_function;
end