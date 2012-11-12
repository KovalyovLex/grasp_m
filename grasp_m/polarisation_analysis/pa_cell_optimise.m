function pa_cell = pa_cell_optimise(opacity,PHe)

if nargin<2;
    PHe = 0.75; %3He Polarisation
end
if nargin<1;
    opacity = 0:100;
end



%Constants
sigma_a = 5333; %Barns   absorbtion cross-section for unpolarised neutrons
sigma_a = sigma_a * 1e-28; %m^2
wav0 = 1.7982; %angs
Na = 6.02214179*10^23; %Avagadro
R = 8.314;  %Molar gas constant
T = 300;  %(K) Cell Temperature

%Keep a store of the opacity array for future use
pa_cell.opacity_array = opacity;

%Model Cell Transmission Parallel and Anti-Parallel
pa_cell.t_para_opacity = 0.5*exp(-opacity*100000*(Na/(R*T*100))*(sigma_a/wav0)*(1-PHe));
pa_cell.t_anti_opacity = 0.5*exp(-opacity*100000*(Na/(R*T*100))*(sigma_a/wav0)*(1+PHe));

%Total Transmission
pa_cell.t_total_opacity = pa_cell.t_para_opacity + pa_cell.t_anti_opacity;
% figure 
% plot(opacity,pa_cell.t_total)

%Polarisation of an unpolarised neutron beam
pa_cell.pol_opacity = (pa_cell.t_para_opacity-pa_cell.t_anti_opacity)./(pa_cell.t_para_opacity+pa_cell.t_anti_opacity);

%Figure of Merit P^2 T
pa_cell.fom_opacity = pa_cell.t_total_opacity.*pa_cell.pol_opacity.^2;

