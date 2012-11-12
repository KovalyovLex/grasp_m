function P = ff_mag_porod(q,qmatrix, sv, contrast, magsv, magcontrast, bck)

%Note:  params.r (sphere radius can come in as a scalar, or matrix distribution of r's to make a quick poly
%dispersiy 

%sv [�2]
%contrast [�-2]
%magsv [�2]
%magcontrast [�-2]
%bck [cm-1]

P = 2*pi*contrast*sv ./ q.^4; %non-magnetic q4 scattering
P = P + ((2*pi*magcontrast*magsv ./ q.^4) .* (cos(qmatrix(:,:,6)*pi/180).^2)); %magnetic q4 scattering
P = P + bck; %P(q) / scatterer volume in [cm-1]

