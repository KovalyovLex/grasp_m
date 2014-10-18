function foreimage = d33_paralax_correction(foreimage)

global inst_params

%det = 1 ;  Rear
%det = 2 ;  Right
%det = 3 ;  Left
%det = 4 ;  Bottom
%det = 5 ;  Top

%D33 rear detector paralax seems approximately linear with params
%gradient = 0.0081615;
%offset = 1.0273;

gradient = 0.0071926;
offset = 1.0287;


%gradient = 0.0067703;
%offset = 1.0289;87 


for det =1:inst_params.detectors
%for det = 1;    
    if det == 1 || det == 4 || det == 5;  %Rear, Bottom, Top - i.e. horizontal tubes
        data2theta = abs(foreimage.(['qmatrix' num2str(det)])(:,:,8)); %y_scattering angle
    elseif det == 2 || det == 3;
        data2theta = abs(foreimage.(['qmatrix' num2str(det)])(:,:,7)); %x_scattering angle
    end

    if det ==1; %Rear
        gradient = 0.0081615;
offset = 1.0273;
        %gradient = 0.0071926;
        %offset = 1.0287;
    elseif det ==2; %Right
        gradient = 0.005026;
        offset = 0.90814;
    elseif det ==3; %Left
        gradient = 0.005026;
        offset = 0.90814;
    elseif det ==4; %Bottom
        gradient = 0.0058296;
        offset = 0.98876;
    elseif det ==5; %Top
        gradient = 0.0058296;
        offset = 0.98876;
        
    end
        
    
    %
    response_function = ones(size(data2theta));
       
    saturation_angle = 10; %degrees
    temp = find(data2theta<saturation_angle);
    response_function(temp) = (1+ (gradient / offset).*data2theta(temp));
    temp = find(data2theta>=saturation_angle);
    response_function(temp) = (1+ (gradient / offset).*saturation_angle);
    
  %  response_function = (1+ (gradient / offset).*data2theta);
    
    
    
    foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) ./ response_function;
    foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) ./ response_function;
end