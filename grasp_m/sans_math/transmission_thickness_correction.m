function foreimage = transmission_thickness_correction(foreimage)


%Makes the sample thickness correction based on the sample transmission and
%scattering angle.  Assumes transmission variation with angle is due to
%absorbtion

%If transmission thickness correction is ON and ts & te >0, then new fields
%are added to the foreimage array.  These are arrays (same as detector
%size) of effective transmission per pixel

%Otherwise, fields are no added and the simple scalar values should be
%used.

global inst_params
trans = [];

%***** Transmission thickness correction ******
if foreimage.trans.ts>0 && foreimage.trans.te>0
    
    for det = 1:inst_params.detectors
        
        %qmatrix(:,:,9) is mod_2theta
        qmatrix = foreimage.(['qmatrix' num2str(det)]);
        
        %***** NIST version *****
        %Sample transmission
        mu = -log(foreimage.trans.ts);
        argument = (1 - cos(qmatrix(:,:,9)*pi/180)) ./ cos(qmatrix(:,:,9)*pi/180);
        if mu < 0.01; %e.g. if T =1;
            correction = 1-0.5*mu*argument;
        else
            warning off
            correction = (1 - exp(-mu .* argument)) ./ (mu.*argument); %This is the normal case
            warning on
            %Check for very small angles, i.e. cos -> 1 and apply the simple correction
            temp = find((cos(qmatrix(:,:,9)*pi/180))>0.99);
            correction(temp) = 1-0.5*mu*argument(temp);
        end
        trans.ts = foreimage.trans.ts .* correction;
        trans.err_ts = foreimage.trans.err_ts .* correction;
        
        %Cell transmission
        mu = -log(foreimage.trans.te);
        argument = (1 - cos(qmatrix(:,:,9)*pi/180)) ./ cos(qmatrix(:,:,9)*pi/180);
        if mu < 0.01; %e.g. if T =1;
            correction = 1-0.5*mu*argument;
        else
            warning off
            correction = (1 - exp(-mu .* argument)) ./ (mu.*argument); %This is the normal case
            warning on
            %Check for very small angles, i.e. cos -> 1 and apply the simple correction
            temp = find((cos(qmatrix(:,:,9)*pi/180))>0.99);
            correction(temp) = 1-0.5*mu*argument(temp);
        end
        trans.te = foreimage.trans.te .* correction;
        trans.err_te = foreimage.trans.err_te .* correction;
        
        %Add new transmission fields to foreimage structure
        foreimage.(['trans' num2str(det)]) = trans;
        
    end
end






%*****Chuck's old version - does not integrate though sample thickness only
%calculates the maximum correction assuming scattering from front face
%of sample
%     ts_thickness = exp( log(trans.ts) ./ cos(qmatrix(:,:,9)*pi/180));
%     ts_thickness_error = ones(size(ts_thickness)).* trans.err_ts; %This is only an aproximation at the error in te
%
%     te_thickness = exp( log(trans.te) ./ cos(qmatrix(:,:,9)*pi/180));
%     te_thickness_error = ones(size(te_thickness)).* trans.err_te; %This is only an aproximation at the error in te
