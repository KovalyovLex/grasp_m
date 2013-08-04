function foreimage = d33_paralax_correction(foreimage)

global inst_params

%det = 1 ;  Rear
%det = 2 ;  Right
%det = 3 ;  Left
%det = 4 ;  Bottom
%det = 5 ;  Top

%D33 rear detector paralax seems approximately linear with params
gradient = 0.75;
offset = 100;

for det =1:inst_params.detectors
%for det = 1;    
    if det == 1 || det == 4 || det == 5;  %Rear, Bottom, Top - i.e. horizontal tubes
        data2theta = abs(foreimage.(['qmatrix' num2str(det)])(:,:,8)); %y_scattering angle
    elseif det == 2 || det == 3;
        data2theta = abs(foreimage.(['qmatrix' num2str(det)])(:,:,7)); %x_scattering angle
    end

    response_function = 1+ (gradient / offset).*data2theta;
    foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) ./ response_function;
    foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) ./ response_function;

    %figure
    %pcolor(response_function); colorbar; title(num2str(det))
    
end