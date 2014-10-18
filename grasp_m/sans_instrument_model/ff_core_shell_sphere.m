function P = ff_core_shell_sphere(x, radius, poly_fwhm, shell, rho_core, rho_shell, rho_matrix, scale, bck)

%Note:  params.r (sphere radius can come in as a scalar, or matrix distribution of r's to make a quick poly
%dispersiy 

%Radius [�]
%Poly_fwhm [%]
%Contrast [�-2]
%Scale [Unitless]
%bck [cm-1]



poly_sigma = ((poly_fwhm / 100)*radius) /2.354;
rad = radius + poly_sigma.*randn(size(x));

  
F1 = 3*(sin(x.*rad)-(x.*rad).*cos(x.*rad))./(x.*rad).^3; F2 = 3*(sin(x.*(rad+shell))-(x.*(rad+shell)).*cos(x.*(rad+shell)))./(x.*(rad+shell)).^3;
F1 = F1.*(4/3).*pi.*rad.^3;
F2 = F2.*(4/3).*pi.*(rad+shell).^3;
P = bck + scale./((4/3).*pi.*(rad+shell).^3.*10^(-8)).*(((rho_core-rho_shell).*F1 + (rho_shell-rho_matrix).*F2).^2);



