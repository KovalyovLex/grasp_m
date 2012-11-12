function P = ff_guinier(q, rg, I0, bck)

%Note:  params.r (sphere radius can come in as a scalar, or matrix distribution of r's to make a quick poly
%dispersiy 

%rg [Å]
%I0 [cm-1]
%bck [cm-1]

P = I0.*exp(-((rg.*q).^2) / 3);
P = P + bck; %P(q) / scatterer volume in [cm-1]