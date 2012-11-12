function P = ff_sphere(q, radius, poly_fwhm, contrast, scale, bck)

%Note:  params.r (sphere radius can come in as a scalar, or matrix distribution of r's to make a quick poly
%dispersiy 

%Radius [�]
%Poly_fwhm [%]
%Contrast [�-2]
%Scale [Unitless]
%bck [cm-1]

%***** Allow for poly dispersity *****
%radius = radius + (rand(size(q))-0.5)*(poly_fwhm/100)*radius;  %Flat distribution

%Old version based on chuck's own Gaussian rand
% radius = rand_gauss(radius*ones(size(q)),poly_fwhm); %Gaussian weighted distribution

%New version based on Matlab's RANDN fn.
%RANDN:  Generate values from a normal distribution with mean 1 and standard deviation 2.
%r = 1 + 2.*randn(100,1);


poly_sigma = ((poly_fwhm / 100)*radius) /2.35;
radius = radius + poly_sigma.*randn(size(q));

rq = (radius).* q;  %r [�] * q [�-1]  [Unitless]
contrast = contrast *1e8*1e8; %convert [�-2] to [cm-2];
V = (4/3)*pi*(radius*1e-8).^3; %Scatterer Volume in [cm2]

P = (scale./V) .* (3*V*contrast .*  (sin(rq) - (rq).*cos(rq)) ./ (rq).^3).^2;
P = P + bck; %P(q) / scatterer volume in [cm-1]