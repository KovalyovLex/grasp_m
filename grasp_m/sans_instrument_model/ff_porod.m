function P = ff_porod(q, sv, contrast, bck)

%sv [Å2]
%contrast [Å-2]
%bck [cm-1]

P = 2*pi*contrast*sv ./ q.^4;
P = P + bck; %P(q) / scatterer volume in [cm-1]
