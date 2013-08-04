function foreimage = d22_paralax_correction(foreimage)

global inst_params

for det =1:inst_params.detectors
    
    %wav = foreimage.(['params' num2str(det)])(inst_params.vectors.wav);

    %     if  wav >4.8 && wav <5.5
    %         %5� parameters
    %         m0 = 1.000087;
    %         m1 = -7.094023e-5;
    %         m2 = 8.622997e-5;
    %         m3 = 9.262026e-6;
    %         m4 = -3.2616369e-7;
    %         m5 = 2.142398e-9;
    %     elseif wav >=5.5 && wav < 7
    %         %6� parameters
    %         m0 = 0.9996799;
    %         m1 = -0.0003934609;
    %         m2 = 0.0001366218;
    %         m3 = 8.219264e-6;
    %         m4 = -3.820951e-7;
    %         m5 = 3.671637e-9;
    %     elseif wav >=7
    %         %8� parameters
    %         m0 = 0.9993575;
    %         m1 = -0.0002320264;
    %         m2 = 9.751713e-5;
    %         m3 = 1.018564e5;
    %         m4 = -3.977445e-7;
    %         m5 = 2.960205e-9;
    %     else
   
    %***** OLD parameters Nov2010
    %4.5� parameters
    %m0 = 1.000163;
    %m1 = -0.0001241957;
    %m2 = 0.0001177791;
    %m3 = 7.147859e-6;
    %m4 = -2.943812e-7;
    %m5 = 2.492871e-9;
    %    end
    
    
%     %**** NEW Parameters after proto detector test
%     m0 = 0.9999667;
%     m1 = -0.0006132585;
%     m2 = 0.0002494345;
%     m3 = -3.779846e-6;
%     m4 = 0;
%     m5 = 0;
%     
  
    
    data2theta_x = abs(foreimage.(['qmatrix' num2str(det)])(:,:,7)); %x_scattering angle
    %Correct 2theta_x for DAN angle
    %DAN:  Check if detector angle parameter exists
    dan_angle = 0; %unless otherwise parameter exists
    if isfield(inst_params.vectors,'dan');
        if not(isempty(inst_params.vectors.dan));
            dan_angle = foreimage.(['params' num2str(det)])(inst_params.vectors.dan);
        end
    end
    data2theta_x = data2theta_x - dan_angle;
    
    %Old response function using polynomial fit
    %response_function = m0 + m1.*data2theta_x + m2.*(data2theta_x.^2) + m3.*(data2theta_x.^3) + m4.*(data2theta_x.^4) + m5.*(data2theta_x.^5);
    
    response_function = 1./cos(2.*3.1415927*data2theta_x/360.) ;  %remember this is a matrix of values corresponding to the matrix of data2theta_x
    temp = find(data2theta_x>=26);  %these are the indicies where data2theta_x is greater than 26.
    response_function(temp) = 1.113+0.007726*(data2theta_x(temp)-26);
    
    foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) ./ response_function;
    foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) ./ response_function;

end



