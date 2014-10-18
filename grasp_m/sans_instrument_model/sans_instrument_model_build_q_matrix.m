function qmatrix = sans_instrument_model_build_q_matrix(detector,wav, delta_theta_x, delta_theta_y)

%Wav can be scalar or matrix
%delta_theta_x should be matrix (but probably also works with a scalar - but this is meaningless) (degrees)
%delta_theta_y should be matrix (but probably also works with a scalar - but this is meaningless) (degrees)


if nargin <4; delta_theta_y = 0; end
if nargin <3; delta_theta_x = 0; end


%Output: matrix of :
%(1) pixel_x
%(2) pixel_y
%(3) qx
%(4) qy
%(5) mod q
%(6) q angle
%(7) 2theta_x
%(8) 2theta_y
%(9) mod_2theta
%(10) solid_angle
%(11) qz
%(12) delta_theta_x
%(13) delta_theta_y

%Make empty q-matrix
qmatrix = zeros(detector.pixels(2),detector.pixels(1),13);

qmatrix(:,:,12) = delta_theta_x;
qmatrix(:,:,13) = delta_theta_y;

%Make the pixel x & y matricies
[pixel_x,pixel_y] = meshgrid(1:detector.pixels(1),1:detector.pixels(2));
qmatrix(:,:,1) = pixel_x; qmatrix(:,:,2) = pixel_y;

%Pixel distances from Beam Centre
r_x = ((qmatrix(:,:,1) - detector.centre(1))*detector.pixel_size(1))   + (detector.opening(1)-detector.centre_translation(1)); %horizontal distance from beam centre to pixel (m)
r_y = ((qmatrix(:,:,2) - detector.centre(2))*detector.pixel_size(2))   + (detector.opening(2)-detector.centre_translation(2)); %vertical distance from beam centre to pixel (m)

% %Add effects of divergence here and change the effective 'radius' rx and ry
delta_rx = detector.position * tan(delta_theta_x * pi /180);  %Should this be 2x this angle?
delta_ry = detector.position * tan(delta_theta_y * pi /180);
r_x = r_x + delta_rx;
r_y = r_y + delta_ry;

%Mod 2Theta
mod_r = sqrt(r_x.^2 + r_y.^2);
two_theta = atan(mod_r ./ detector.position); %radians.  R is used instead of DET for DAN correction
qmatrix(:,:,9) = two_theta * (180/pi); %degrees in qmatrix;

%2Theta_x & 2Theta_y (there is also a 2Theta_z component not calculated here)
two_theta_x = atan(r_x / detector.position); %radians
qmatrix(:,:,7) = two_theta_x * (180/pi); %degrees in qmatrix;

two_theta_y = atan(r_y / detector.position); %radians
qmatrix(:,:,8) = two_theta_y * (180/pi); %degrees in qmatrix;


%Wave vector (Angs-1)
k = (2*pi)./wav;

%Mod q
mod_q = 2*k.*sin(two_theta/2);
qmatrix(:,:,5) = mod_q;

%q_angle around the detector (measured clockwise from vertical)
%This is not quite correct for DAN angles
ang_array = ((atan2(r_x,r_y)) *180 / pi);
temp = find(ang_array<0);
ang_array(temp) = ang_array(temp) +360;
qmatrix(:,:,6) = ang_array;

%q_x and q_y components (resolved from Mod_q taking into acount the q_z component)
q_x = mod_q.*cos(two_theta/2).*sin(ang_array*pi/180);
qmatrix(:,:,3) = q_x;
q_y = mod_q.*cos(two_theta/2).*cos(ang_array*pi/180);
qmatrix(:,:,4) = q_y;
q_z = mod_q.*sin(two_theta/2);
qmatrix(:,:,11) = q_z;


%***** Solid Angle *****
pixel_area = ones(detector.pixels(2),detector.pixels(1)).*(detector.pixel_size(1) * detector.pixel_size(2)); %m^2
pixel_distance = zeros(detector.pixels(2),detector.pixels(1),5); %x,y, r, theta on detector, then R, distance to sample

%geometry!
pixelx_line = ((1:detector.pixels(1)) - detector.centre(1))*detector.pixel_size(1); %x distance from centre in m
pixely_line = ((1:detector.pixels(2)) - detector.centre(2))*detector.pixel_size(2); %y distance from centre in m
[pixel_distance(:,:,1), pixel_distance(:,:,2)] = meshgrid(pixelx_line,pixely_line);

%Correct pixel area for curvature effect
effective_pixel_area = pixel_area .* cos(two_theta_x) .* cos(two_theta_y);

% %Calculate Polar co-ords. in plane of detector
% [pixel_distance(:,:,4),pixel_distance(:,:,3)] = cart2pol(pixel_distance(:,:,1),pixel_distance(:,:,2));
% %Distance to sample
% pixel_distance(:,:,5) = sqrt((detector.position.^2) + (pixel_distance(:,:,3).^2));
% %Finally calculate solid angle subtended by each pixel
% qmatrix(:,:,10) = effective_pixel_area./(pixel_distance(:,:,5).^2); %matrix - to account for distortions of flat detector against scattering sphere at short distances.
%

R = detector.position;
S = r_x;
%NEW 22/9/2008 to take accout of DAN
%Calculate distance from sample in x-plane
pixel_distance_x = sqrt(R.^2 + S.^2);
pixel_distance(:,:,3) = sqrt(pixel_distance_x.^2 + (pixel_distance(:,:,2).^2));
%Finally calculate solid angle subtended by each pixel
qmatrix(:,:,10) = effective_pixel_area./(pixel_distance(:,:,3).^2); %matrix - to account for distortions of flat detector against scattering sphere at short distances.




