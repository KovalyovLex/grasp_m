function sigma = pa_correct(i00, i10, i11, i01, p, fp, a, fa)


%p = [value,error] polariser efficiency (%), i.e. I+ / (I+ + I-) NOT Polarisation (I+ - I-) / (I+ + I-)
%a = [value,error] analyzer efficiency
%fp = [value,error] flipper1 efficiency
%fa = [value,error] flipper2 efficiency

%i00, i01 etc are the full selector structures, e.g. i00.data1, i00.error1 etc

%From Wildes - Pol & Annal made easy
%[Sigma] = [A][Fa][P]Fp][I] eq.4a

global inst_params

%Correction Matricies (eq. 4a)
Fp = (1/fp(1)).*[fp(1) 0 0 0; 0 fp(1) 0 0; (fp(1)-1) 0 1 0; 0 (fp(1)-1) 0 1];
Fa = (1/fa(1)).*[fa(1) 0 0 0; (fa(1)-1) 1 0 0; 0 0 fa(1) 0; 0 0 (fa(1)-1) 1];
P = (1/(1-2*p(1))).*[-p(1) 0 (1-p(1)) 0; 0 -p(1) 0 (1-p(1)); (1-p(1)) 0 -p(1) 0; 0 (1-p(1)) 0 -p(1)];
A = (1/(1-2*a(1))).*[-a(1) (1-a(1)) 0 0; (1-a(1)) -a(1) 0 0; 0 0 -a(1) (1-a(1)); 0 0 (1-a(1)) -a(1)];

%Derivative of Correction Matricies (eq. 15)
dFp_dfp = [0 0 0 0; (1/fp(1).^2) (1/fp(1).^2) 0 0; 0 0 0 0; 0 0 (1/fp(1).^2) (1/fp(1).^2)];
dFa_dfa = [0 0 0 0; (1/fa(1).^2) (1/fa(1).^2) 0 0; 0 0 0 0; 0 0 (1/fa(1).^2) (1/fa(1).^2)];
dP_dp = (1/((1-2*p(1)).^2)).* [-1 1 0 0; 1 -1 0 0; 0 0 -1 1; 0 0 1 -1];
dA_da = (1/((1-2*a(1)).^2)).* [-1 1 0 0; 1 -1 0 0; 0 0 -1 1; 0 0 1 -1];


%Loop though the instruments detectors
for det = 1:inst_params.detectors
    temp = size(i00.(['data' num2str(det)]));
    
    %Switch to temporary variables - quicker than using structure addressing in the loop
    sigma_i00_data = zeros(temp(1),temp(2));
    sigma_i10_data = zeros(temp(1),temp(2));
    sigma_i11_data = zeros(temp(1),temp(2));
    sigma_i01_data = zeros(temp(1),temp(2));
    
    sigma_i00_error = zeros(temp(1),temp(2));
    sigma_i10_error = zeros(temp(1),temp(2));
    sigma_i11_error = zeros(temp(1),temp(2));
    sigma_i01_error = zeros(temp(1),temp(2));
    
    i00_data = i00.(['data' num2str(det)]);
    i10_data = i10.(['data' num2str(det)]);
    i11_data = i11.(['data' num2str(det)]);
    i01_data = i01.(['data' num2str(det)]);
    
    i00_error = i00.(['error' num2str(det)]);
    i10_error = i10.(['error' num2str(det)]);
    i11_error = i11.(['error' num2str(det)]);
    i01_error = i01.(['error' num2str(det)]);

    %Need to loop though the detector matrix one by one as each pixel
    %correction is a matrix operation in itself.
    for n = 1:temp(1);
        for m = 1:temp(2);
            I = [i00_data(n,m);i01_data(n,m);i10_data(n,m);i11_data(n,m)]; %Wildes way round
            sigma_temp = A*Fa*P*Fp*I;
            
            sigma_i00_data(n,m) = sigma_temp(1); %the numbering here undoes the wildes way round
            sigma_i10_data(n,m) = sigma_temp(3);
            sigma_i11_data(n,m) = sigma_temp(4);
            sigma_i01_data(n,m) = sigma_temp(2);
            
            %Error Propogation %eq.15
            dsigma_temp1 = (a(2)*dA_da*Fa*P*Fp*I).^2;
            dsigma_temp2 = (fa(2)*A*dFa_dfa*P*Fp*I).^2;
            dsigma_temp3 = (p(2)*A*Fa*dP_dp*Fp*I).^2;
            dsigma_temp4 = (fp(2)*A*Fa*P*dFp_dfp*I).^2;
            
            dI = [i00_error(n,m);i01_error(n,m);i10_error(n,m);i11_error(n,m)]; %Wildes way round
            dI_squared = dI.^2;
            dsigma_temp5 = ((A*Fp*P*Fp).^2)*dI_squared;
            
            dsigma_temp_squared = dsigma_temp1 + dsigma_temp2 + dsigma_temp3 + dsigma_temp4 + dsigma_temp5;
            dsigma_temp = sqrt(dsigma_temp_squared);

            sigma_i00_error(n,m) = dsigma_temp(1); %the numbering here undoes the wildes way round
            sigma_i10_error(n,m) = dsigma_temp(3);
            sigma_i11_error(n,m) = dsigma_temp(4);
            sigma_i01_error(n,m) = dsigma_temp(2);
        end
    end
    
    %Assemble into final output matrix structure
    sigma.i00.(['data' num2str(det)]) = sigma_i00_data;
    sigma.i10.(['data' num2str(det)]) = sigma_i10_data;
    sigma.i11.(['data' num2str(det)]) = sigma_i11_data;
    sigma.i01.(['data' num2str(det)]) = sigma_i01_data;
    
    sigma.i00.(['error' num2str(det)]) = sigma_i00_error;
    sigma.i10.(['error' num2str(det)]) = sigma_i10_error;
    sigma.i11.(['error' num2str(det)]) = sigma_i11_error;
    sigma.i01.(['error' num2str(det)]) = sigma_i01_error;

    
end







