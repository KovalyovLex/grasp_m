function [int] = fll_int_int

%Calculate the integrated intensity of a Bragg peak from the flux lattice

%Constants    
gamma = 1.91;  %Neutron Gyromagnetic Ratio
phi0 = 2.07*10^-15; %Flux Quantum

area = 1e-4; %m,  i.e. 1cm^2 = 1e-4m^2
thickness = 1e-3; %m, i.e. 1mm
volume = area * thickness; %m^3

flux = 1e8; %n/cm2/s

wav = 10e-10; %m, i.e. 10angs

q = 1e-3; %angs^-1
q = q*1e10; %m^-1


q = 1e-3:1e-5:1e-2;
q = q*1e10; %m^-1


%Form factor
B = 0.1; %Tesla
lambda = 1000; %angs penetration depth
lambda = lambda*1e-10; %m
F = B ./ (1+ (q.^2).*(lambda^2));

%Integrated Intensity

int = 2*pi*volume*flux*((gamma/2)^2)*(wav^2 ./ (phi0^2 .* q)).*F.^2;



figure
plot(q,int,'.')



