function [phi,a] = pa_combined_efficiency(time,pol,opacity,phe0,t1,t0)

%time = array of times [hrs]
%pol = polariser efficiency
%opacity = 3he opacity [bar.cm.angs]
%phe0 = initial 3he polarisation (fraction) 0->1
%t1 = 3he decay constant [hrs]
%t0 = time offset [hrs]


sigma_a = 5333; %Barns   absorbtion cross-section for unpolarised neutrons
sigma_a = sigma_a * 1e-28; %m^2
wav0 = 1.7982; %angs
Na = 6.02214179*10^23; %Avagadro
R = 8.314;  %Molar gas constant
T = 300;  %(K) Cell Temperature
PHe = phe0*exp(-(time+t0)/t1);
T_para = exp(-opacity*100000*(Na/(R*T*100))*(sigma_a/wav0)*(1-PHe));
T_anti = exp(-opacity*100000*(Na/(R*T*100))*(sigma_a/wav0)*(1+PHe));
a = T_para./(T_para+T_anti);
phi = (2*pol-1).*(2*a-1);