function [penetration_depth, err_penetration_depth,F_squared, err_F_squared] = fll_int_to_lambda(intint,flux,q,neutron_lambda,volume,sample_app,spot_angle)

%Calculate Lambda from Integrated Rocking Curve intensity and the direct
%beam flux

%Usage:
%[lambda, err_lambda] = int_to_lambda([intint,err_intint],[flux,err_flux],[q,err_q],[neutron_lambda],[volume,err_volume],[sample_app,err_sample_app],[spot_angle])
%
%Units:
%
%intint (counts / standard monitor)
%flux (counts / standard monitor)
%neutron_lambda (angstroms)
%volume (mm^3)
%sample_app (mm^3)

%Constants    
gamma = 1.91;  %Neutron Gyromagnetic Ratio
phi0 = 2.07*10^-15; %Flux Quantum

%volume = 0.038; err_volume = 0; %err_volume = 0.01; %Sample Volume (mm3)
%sample_app = 2.5; err_sample_app = 0; %err_sample_app = 0.5; %Sample Apperture Area (mm2)
%neutron_lambda = 10;  %Neutron Wavelength (Angs)

%Convert Quantities to SI
volume = volume * 10^-9; %Convert mm3 to m3
sample_app = sample_app*10^-6; %Convert mm2 to m2;
neutron_lambda = neutron_lambda*10^-10; %convert angstroms to m;
intint = intint *pi/180;
q = q*(1/10^-10); %Angs-1 to m-1

%Calculate B from q assuming Hex lattice.
[q_squared, err_q_squared] = err_power(q(1),q(2),2);
B = (phi0*sqrt(3)/(8*pi^2))*q_squared;
err_B = (phi0*sqrt(3)/(8*pi^2))*err_q_squared;

%Derived Quantities
[flux_density, err_flux_density] = err_divide(flux(1),flux(2),sample_app(1),sample_app(2));  %Flux Density (Counts / StdMon / m2);

%Correct for Lorentz Factor
intint = intint * cos(spot_angle*pi/180);

%Intensity Formula, with Errors!
[numerator,err_numerator] = err_multiply(q(1),q(2),intint(1),intint(2));
numerator = (phi0^2)*numerator; err_numerator = (phi0^2)*err_numerator;

[denominator, err_denominator] = err_multiply(flux_density,err_flux_density,volume(1),volume(2));
denominator = 2*pi*((gamma/4)^2)*(neutron_lambda^2)*denominator;
err_denominator = 2*pi*((gamma/4)^2)*(neutron_lambda^2)*err_denominator;

%Form Factor
[F_squared, err_F_squared] = err_divide(numerator,err_numerator,denominator,err_denominator); %Form Factor ^2
[F,err_F] = err_power(F_squared,err_F_squared,0.5);

%Core Correction
%xi_sigma = 100.4e-10;
%F = F/(exp(-(xi_sigma^2)*q_squared/2));

%Penetration Depth
[B_div_F, err_B_div_F] = err_divide(B,err_B,F,err_F);
B_div_F = B_div_F-1;

[BF_q_squared, err_BF_q_squared] = err_divide(B_div_F,err_B_div_F,q_squared,err_q_squared);

[penetration_depth, err_penetration_depth] = err_power(BF_q_squared,err_BF_q_squared,0.5); %Should be in m
penetration_depth = penetration_depth / 10^-10; err_penetration_depth = err_penetration_depth / 10^-10;

disp(['Field = ', num2str(B), ' Penetration Depth = ' num2str(penetration_depth) ' +- ' num2str(err_penetration_depth) ' Angstroms']);
