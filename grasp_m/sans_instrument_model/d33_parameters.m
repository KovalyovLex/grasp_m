function resolution_matrix = d33_parameters(tof_wavelength_cutoff)


%Determine all chopper parameters & resolutuion parameters for a certain
%instrument layout.

%Constants
h = 6.626076*(10^-34); %Plank's Constant
m_n = 1.674929*(10^-27); %Neutron Rest Mass

%Key instrument parameters
tof_wavelength_cuton = 2; %Angs
if nargin<1; tof_wavelength_cutoff = 12; end %Angs
%chopper_radius = 0.38;  %radius at which the centre of the neutron beam cuts.
chopper_radius = 0.33;  %radius at which the centre of the neutron beam cuts.
chopper_spacing12 = 2.8; %m
chopper_spacing23 = 1.4; %m
chopper_spacing34 = 0.7; %m
chopper_opening_angle = 110; %degrees

instrument_guide_size = [30e-3, 30e-3];
last_chopper_sample_length = 14.1; %(m)
max_col = 12.8; %(m)

%Display Parameters Summary
disp(' ')
disp(['Chopper diameter (at which the neutron beam cuts) = ' num2str(2*chopper_radius) ' (m)']);
disp(['Chopper Opening Angle = ' num2str(chopper_opening_angle)]);
disp(['TOF Wavelength cuton = ' num2str(tof_wavelength_cuton) ' (Å)']);
disp(['TOF Wavelength cutoff = ' num2str(tof_wavelength_cutoff) ' (Å)']);
disp(['Max Collimation length = ' num2str(max_col) ' (m)']);
disp(['Last chopper - sample distance = ' num2str(last_chopper_sample_length) ' (m)']);
disp(' ')


%Chopper spacings, a b c
a = chopper_spacing34;
b = chopper_spacing23;
c = chopper_spacing12;

%For smallest to largest spacing (going backwards)
spacing_matrix = [a,b,a+b,c,b+c,a+b+c];
spacing_offset_matrix = [0,a,0,a+b,a,0];%To take into accout the extra flight path due to the positioning of the choppers and which pair is actually being used

detector_distance = 2:2:14;

resolution_matrix = zeros(length(spacing_matrix)+1,length(detector_distance)+1);
resolution_matrix(1,2:length(detector_distance)+1) = detector_distance;
resolution_matrix(2:length(spacing_matrix)+1,1) = rot90(spacing_matrix,3);

total_tof_matrix = zeros(length(spacing_matrix)+1,length(detector_distance)+1);
total_tof_matrix(1,2:length(detector_distance)+1) = detector_distance;
total_tof_matrix(2:length(spacing_matrix)+1,1) = rot90(spacing_matrix,3);

for m = 1:length(spacing_matrix);
    for n = 1:length(detector_distance);
        delta_d = spacing_matrix(m);
        total_tof = detector_distance(n) + last_chopper_sample_length + spacing_offset_matrix(m)+delta_d/2;
        resolution_matrix(m+1,n+1) = 100*delta_d/total_tof;
        total_tof_matrix(m+1,n+1) = total_tof;
    end
end
disp(' ')
disp('NOMINAL Resolutions availaible as fn of chopper-pair-spacing & detector distance')
disp(resolution_matrix)
temp = size(resolution_matrix);
low_resolution = max(max(resolution_matrix(2:temp(1),2:temp(2))));
high_resolution = min(min(resolution_matrix(2:temp(1),2:temp(2))));
disp(['Highest resolution = ' num2str(high_resolution) ' (%)']);
disp(['Lowest resolution = ' num2str(low_resolution) ' (%)']);

disp(' ')
disp('Total TOF Flight path Mid-Chopper-Pair to Detector');
disp(total_tof_matrix);

disp(' ')
disp('Maximum F1 chopper frequency for resolution & detector distance [Hz]')
f1_frequency_matrix = total_tof_matrix;
temp = size(f1_frequency_matrix);
f1_frequency_matrix(2:temp(1),2:temp(2)) = h./(m_n.*f1_frequency_matrix(2:temp(1),2:temp(2)).*tof_wavelength_cutoff*10^-10);
disp(f1_frequency_matrix);

disp(' ')
disp('Required chopper opening window for given resolution');
chopper_opening_matrix = resolution_matrix;
chopper_opening_matrix(2:temp(1),2:temp(2)) = chopper_opening_matrix(2:temp(1),2:temp(2)) * 360/100;
disp(round(chopper_opening_matrix*10)/10)
largest_chopper_opening = max(max(chopper_opening_matrix(2:temp(1),2:temp(2))));
smallest_chopper_opening = min(min(chopper_opening_matrix(2:temp(1),2:temp(2))));
disp(['Smallest required chopper opening = ' num2str(smallest_chopper_opening) ' (degrees)']);
disp(['Largest required chopper opening = ' num2str(largest_chopper_opening) ' (degrees)']);

disp(' ')
disp(['Max chopper frequency multiplication due to Chopper Opening ' num2str(chopper_opening_angle) ' degrees']);
chopper_multiplier = chopper_opening_matrix;
chopper_multiplier(2:temp(1),2:temp(2)) = floor((chopper_opening_angle) ./ chopper_multiplier(2:temp(1),2:temp(2)));
disp(chopper_multiplier)

disp(' ')
disp(['Max chopper frequency multiplication due to frame overlap within choppers']);
max_chopper_spacing = chopper_spacing12 + chopper_spacing23 + chopper_spacing34;
chopper_multiplier2 =  total_tof_matrix;
chopper_multiplier2(2:temp(1),2:temp(2)) = floor(total_tof_matrix(2:temp(1),2:temp(2)) / max_chopper_spacing);
disp(chopper_multiplier2);

disp(' ')
disp(['Overall Maximum frequency multiplication possible']);
final_chopper_multiplier = min(chopper_multiplier,chopper_multiplier2);
disp(final_chopper_multiplier);

disp(' ');
disp(['N x F1 chopper frequency required for maximum multiplication [Hz]']);
nf_frequency_matrix = f1_frequency_matrix;
nf_frequency_matrix(2:temp(1),2:temp(2)) = nf_frequency_matrix(2:temp(1),2:temp(2)) .* final_chopper_multiplier(2:temp(1),2:temp(2));
disp(nf_frequency_matrix)
disp('RPM (NxF1x60)')
nf_frequency_matrix_rpm = nf_frequency_matrix;
nf_frequency_matrix_rpm(2:temp(1),2:temp(2)) = nf_frequency_matrix_rpm(2:temp(1),2:temp(2)) *60;
disp(nf_frequency_matrix_rpm)


%Calculate TOF resolution limit curve (due to guide cutting time)
wavs = tof_wavelength_cuton:tof_wavelength_cutoff;
tof_wav_res1 = (instrument_guide_size(1) * tof_wavelength_cutoff) ./ (2*pi*chopper_radius .* wavs);

figure
plot(wavs,tof_wav_res1,'w');hold on
plot(wavs,tof_wav_res1/2,'w'); hold on
plot(wavs,tof_wav_res1/3,'w'); hold on
plot(wavs,tof_wav_res1/4,'w'); hold on
plot(wavs,tof_wav_res1/5,'w'); hold on
plot(wavs,tof_wav_res1/6,'w'); hold on
plot(wavs,tof_wav_res1/7,'w'); hold on
plot(wavs,tof_wav_res1/8,'w'); hold on
plot(wavs,tof_wav_res1/9,'w'); hold on
plot(wavs,tof_wav_res1/10,'w'); hold on

    

% wavs'
% tof_wav_res1'


              
                  
                  
                  
                  