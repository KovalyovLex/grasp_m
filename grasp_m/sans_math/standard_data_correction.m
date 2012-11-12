function foreimage = standard_data_correction(foreimage, backimage, cadmiumimage)

%This function performs the 'Standard SANS background subtraction
%The current transmission to use comes in with the foreimage

%The formula is this:

%I_real = [1/Ts*Te]*[I_sample - I_cad] - [1/Te]*[I_back - I_cad]

%where:
%	I_sample = measured scattering from sample
%	I_back = background scattering from holder
%   I_cad = cadmium background
%	Ts = transmission of sample ONLY (i.e. sample trans / empty trans)
%	Te = transmission of empty ONLY (i.e. empty trans / direct trans)

%Split in to parts for ease of error calculation;
%   a = (I_sample - I_cad)
%   b = (I_back - I_cad)
%   c = Ts*Te;
%   d = a/c;
%   e = b /Te;
%   I_real = d - e


global inst_params

%Loop though the detectors
for det = 1:inst_params.detectors
    
    %Check if to use the thickness corrected transmission or just simple transmission
    if isfield(foreimage,['trans' num2str(det)])
        trans = foreimage.(['trans' num2str(det)]); %thickness corrected transmission matrix
    else
        trans = foreimage.trans; %Simple transmission scaler values
    end
   
    
    [a,err_a] = err_sub(foreimage.(['data' num2str(det)]),foreimage.(['error' num2str(det)]),cadmiumimage.(['data' num2str(det)]),cadmiumimage.(['error' num2str(det)]));
    [b,err_b] = err_sub(backimage.(['data' num2str(det)]),backimage.(['error' num2str(det)]),cadmiumimage.(['data' num2str(det)]),cadmiumimage.(['error' num2str(det)]));
    [c,err_c] = err_multiply(trans.ts,trans.err_ts,trans.te,trans.err_te); %Ts, err_Ts, Te err_Te
    [d,err_d] = err_divide(a,err_a,c,err_c);
    [e,err_e] = err_divide(b,err_b,trans.te,trans.err_te); %Te err_Te

    %     %Insert Background Shifter in here
    %     i = findobj('tag','background_shifter_window');
    %     if not(isempty(i)) & flag == 1; %i.e. Only do background shift if Shifter Window is open AND it is foreground data
    %         [e,err_e,history_string] = background_shifter(d,err_d,e,err_e,history_string);
    %     end
    
    %Final Foreground - Background Calculation
    [intensity, intensity_error] = err_sub(d,err_d,e,err_e);

    %Create new fields in the foreground structure containing the correctly subtracted intensity
    foreimage.(['data' num2str(det)]) = intensity;
    foreimage.(['error' num2str(det)]) = intensity_error;
end
    



