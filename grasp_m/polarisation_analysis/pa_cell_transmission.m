function pa_decay = pa_cell_transmission(opacity,PHe0,t1,time)

%Equations

%PHe(t) = PHe(0) x exp(-t/t1)   % Polarisation decay with time
%T+-(lambda,t) = 1/2 exp(- [3He]*l*sigma_a*(1-+PHe(t)))

%Constants
sigma_a = 5333; %Barns absorbtion cross-section for unpolarised neutrons
sigma_a = sigma_a * 1e-28; %m^2
wav0 = 1.7982; %angs
Na = 6.02214179*10^23; %Avagadro
R = 8.314;  %Molar gas constant
T = 300;  %(K) Cell Temperature

%Model Cell Polarisation Decay
PHe = PHe0 .* exp(-time./t1);

%Keep a store of the time array for future use
pa_decay.time_array = time;

%Model Cell Transmission Parallel and Anti-Parallel
pa_decay.t_para_time = 0.5*exp(-opacity*100000*(Na/(R*T*100))*(sigma_a/wav0)*(1-PHe));
pa_decay.t_anti_time = 0.5*exp(-opacity*100000*(Na/(R*T*100))*(sigma_a/wav0)*(1+PHe));

%Total Transmission
pa_decay.t_total_time = pa_decay.t_para_time + pa_decay.t_anti_time;


% %Plot Transmissions
% figure
% plot(time,pa_decay.t_para_time,'.b')
% hold on
% plot(time,pa_decay.t_anti_time,'.r')
% hold on
% plot(time,pa_decay.t_total_time,'.y')
% legend('T-Parallel', 'T-Anti-Para', 'T-Total')


%Calculate Analysis efficiencies a1 = 'a' and a2 = '(1-a)'
pa_decay.efficiency_a1 = pa_decay.t_para_time ./ pa_decay.t_total_time;
pa_decay.efficiency_a2 = pa_decay.t_anti_time ./ pa_decay.t_total_time;

% figure
% plot(time,pa_decay.efficiency_a1,'.b')
% hold on
% plot(time,pa_decay.efficiency_a2,'.r')
% hold on
% plot(time,pa_decay.efficiency_a1+pa_decay.efficiency_a2,'.y')
% legend('Analyser Efficiency ''a''', 'Analyser InEfficiency ''(1-a)''','a + (1-a)')


%Polarisation of an unpolarised neutron beam
pa_decay.pol_beam_time = (pa_decay.t_para_time-pa_decay.t_anti_time)./(pa_decay.t_para_time+pa_decay.t_anti_time);

% figure
% plot(time,pa_decay.pol_beam_time,'.b')
% legend('Polarisation of Unpolarised beam')







