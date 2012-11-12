function P = ff_vortex(q_matrix, wav_matrix, field, width_fwhm, az_cor, rad_cor, pen_depth, san, phi, rot)

%q_matrix : pixel_x, pixel_y, qx, qy, mod q, q angle, 2theta_x, 2theta_y, mod_2theta, solid_angle, qz

%Convert field into q
option = 'hex';
q_bragg = fll_B_to_q(field,option); %angs

%Calcualte longitudinal qz from rock width
delta_qz = width_fwhm * (pi/180) * q_bragg; %FWHM
%Calculate azimuthal and radial q_widths from correlation lengths
delta_qaz = 2 / (az_cor * 10^4); %angs-1  FWHM
delta_qrad = 2 / (rad_cor * 10^4); %angs-1  FWHM

%Convert to radians
san = san *pi/180;
phi = phi *pi/180;

%Output detector matrix
P = zeros(size(q_matrix(:,:,1,1)));

%Generate Reciprocal lattice points for vortex lattice
spot_angles = [30,90,150,210, 270, 330]+rot;

qx_spots = q_bragg .* sin(spot_angles*pi/180);
qy_spots = q_bragg .* cos(spot_angles*pi/180);
qz_spots = zeros(1,length(spot_angles));


%Instead of transforming the reciprocal lattice points by the SAN or PHI
%angle, instead transform the scattering vector by the equivalent.  This
%makes it easier than trying to transform a 'fat lossenge' shape of
%reciprocal lattice point.
%Recalcualte the transformed (by san or phi) scattering vector components
%qx, qy, qz

[th,r] = cart2pol(q_matrix(:,:,3),q_matrix(:,:,11));
th = th + san - (q_matrix(:,:,12)*pi/180);
[q_matrix(:,:,3),q_matrix(:,:,11)] = pol2cart(th,r);

%Transform about Phi (rotation about horizontal axis)
[th,r] = cart2pol(q_matrix(:,:,11),q_matrix(:,:,4));
th = th + phi - (q_matrix(:,:,13)*pi/180);
th = th + phi;
[q_matrix(:,:,11),q_matrix(:,:,4)] = pol2cart(th,r);


%Calculate the integrated intensity of a Bragg peak from the flux lattice as a function of q
gamma = 1.91;  %Neutron Gyromagnetic Ratio
phi0 = 2.07*10^-15; %Flux Quantum
%Form factor
B = field /1e4; %T
mod_q = q_matrix(:,:,5); %REAL mod q (taking into account delta_lambda and delta_theta variations)
F = B ./ (1+ ((mod_q.^2).*(pen_depth^2)));
%Total Integrated Intensity
int = 2*pi*((gamma/4)^2)*((wav_matrix*1e-10).^2 ./ (phi0^2 .* q_bragg*1e10)).*F.^2;


%Now go though all the (transformed) spots and see if any lie in the Ewald Sphere.
for n = 1:length(spot_angles);
   
    %Transform q_matrix qx and qy into polar coords
    [q_theta, q_r] = cart2pol(q_matrix(:,:,3),q_matrix(:,:,4));
    
    %Transform Bragg peak coords into polar coords
    [qb_theta, qb_r] = cart2pol(qx_spots(n),qy_spots(n));
    
    
%     %***** Box q-space *****
%     %Radial
%     Ir = zeros(size(q_r));
%     temp = isalmost(q_r, qb_r, delta_qrad/2);
%     Ir(temp) = 1/delta_qrad;
% 
%     %Azimuthal
%     Iaz = zeros(size(q_theta));
%     temp = isalmost(q_theta, qb_theta, delta_qaz/(2*q_bragg));
%     Iaz(temp) = 1/(delta_qaz/(2*q_bragg));
%     temp = isalmost(q_theta-2*pi, qb_theta, delta_qaz/(2*q_bragg));
%     Iaz(temp) = 1/(delta_qaz/(2*q_bragg));
%     
%     %Longitudinal
%     Iz = zeros(size(q_matrix(:,:,11)));
%     temp = isalmost(q_matrix(:,:,11), 0, delta_qz/2);
%     Iz(temp) = 1/delta_qz;

 
    %***** Gaussian q-space *****
    %Radial
    sigma_qrad = delta_qrad/2.35;
    Ir = (1/(sigma_qrad*sqrt(2*pi))) .* exp( - ((q_r - qb_r).^2)./(2*sigma_qrad.^2));
   
    %Azimuthal
    sigma_qaz = delta_qaz/2.35;
    sigma_theta_az = sigma_qaz / q_bragg;
    Iaz1 = (1/(sigma_theta_az*sqrt(2*pi))) .* exp( - ((q_theta - qb_theta).^2)./(2*sigma_theta_az.^2));
    Iaz2 = (1/(sigma_theta_az*sqrt(2*pi))) .* exp( - ((q_theta-2*pi - qb_theta).^2)./(2*sigma_theta_az.^2));
    Iaz=Iaz1+Iaz2;
    
    %Longitudinal
    sigma_qz = delta_qz/2.35;
    Iz = (1/(sigma_qz*sqrt(2*pi))) .* exp( - ((q_matrix(:,:,11)).^2)./(2*sigma_qz.^2));
    
    
    
    %Final intensity 
    P = P+ int.*Ir.*Iaz.*Iz;
end


%Convert to units /cm3 as cm's are use for sample vol and thickness in the rest of the program
P = P / 100^3;
%Convert as flux is required here /m^2 and is in cm^2 in the rest of the program
P = P * 100^2;




function q = fll_B_to_q(B,option)

if nargin <2; option = 'hex'; end

%B [Gauss]

B = B / 10000; % Gauss to T

%Constants
if strcmp(option,'square');
   a0_pre_factor = 1;
else %Hex
    a0_pre_factor = sqrt(2/(sqrt(3)));
end
phi0=2.07e-15; %Flux quantum (SI)


a0 = a0_pre_factor * sqrt(phi0/B);
d = a0 / (a0_pre_factor^2);

q = 2*pi / d;

q = q * 10^-10; %m-1 to Angs^-1

