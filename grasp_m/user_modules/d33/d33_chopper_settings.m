function chopper_params = d33_chopper_settings(wav_band,detector_distance)


%Determine all chopper parameters & resolutuion parameters for a certain
%instrument layout.

%Constants
h = 6.626076*(10^-34); %Plank's Constant
m_n = 1.674929*(10^-27); %Neutron Rest Mass

%default instrument parameters
if nargin<2; detector_distance = 10; end
if nargin<1; wav_band = [0,20]; end %Angs




chopper_spacing12 = 2.799; %m
chopper_spacing23 = 1.407; %m
chopper_spacing34 = 0.707; %m
chopper_positions = [0, 2.8, 4.2, 4.9]; %choppers 1,2,3,4 in direction of neutrons, relative to first chopper

chopper_opening_angle = 110; %degrees
last_chopper_sample_length = 14.099; %(m)

%Display Parameters Summary
disp(' ')
disp(['Chopper Opening Angle = ' num2str(chopper_opening_angle)]);
disp(['TOF Wavelength cuton = ' num2str(wav_band(1)) ' (Å)']);
disp(['TOF Wavelength cutoff = ' num2str(wav_band(2)) ' (Å)']);
disp(['Last chopper - sample distance = ' num2str(last_chopper_sample_length) ' (m)']);
disp(['Sample - Rear Detector Distance = ' num2str(detector_distance) ' (m)']);
disp(' ')


%Chopper spacings, a b c
a = chopper_spacing34; b = chopper_spacing23; c = chopper_spacing12;
%For smallest to largest spacing (going backwards)
spacing_matrix = [a,b,a+b,c,b+c,a+b+c];
spacing_masters_matrix = {'3,4', '2,3', '2,4', '1,2', '1,3', '1,4'};
spacing_slaves_matrix = {'1,2', '1,4', '1,3', '3,4', '2,4', '2,3'};
spacing_offset_matrix = [0,a,0,a+b,a,0];%To take into accout the extra flight path due to the positioning of the choppers and which pair is actually being used


%Prepare matricies
resolution_matrix = zeros(length(spacing_matrix),length(detector_distance));
resolution_matrix(1:length(spacing_matrix),1) = rot90(spacing_matrix,3);

total_tof_matrix = zeros(length(spacing_matrix),length(detector_distance));
total_tof_matrix(1:length(spacing_matrix),1) = rot90(spacing_matrix,3);

%Calculate total TOF distance and Resolutions
for m = 1:length(spacing_matrix);
    for n = 1:length(detector_distance);
        delta_d = spacing_matrix(m);
        total_tof = detector_distance(n) + last_chopper_sample_length + spacing_offset_matrix(m)+delta_d/2;
        resolution_matrix(m,n) = 100*delta_d/total_tof;
        total_tof_matrix(m,n) = total_tof;
    end
end

%Calculate Nominal F1 Frequency
f1_frequency_matrix = 60*h./(m_n.*total_tof_matrix.*wav_band(2)*10^-10);

%Longest Pulse time (determined by longest wavelengh and chopper separation)
longest_time_matrix = spacing_matrix* m_n*wav_band(2)*(1e-10)/h;


%Calculate required chopper opening 
chopper_opening_matrix = resolution_matrix *360/100;

%Max chopper frequency multiplication due to chopper opening angle
chopper_multiplier = floor((chopper_opening_angle) ./ chopper_opening_matrix);

%Max chopper frequency multiplication due to frame overlap within choppers
max_chopper_spacing = chopper_spacing12 + chopper_spacing23 + chopper_spacing34;
chopper_multiplier2 = floor(total_tof_matrix / max_chopper_spacing);

%Overall Maximum frequency multiplication possible (minimum of the two above)
final_chopper_multiplier = min(chopper_multiplier,chopper_multiplier2);

%Calculate Phases 
%Master Relative Phases
%phase1 - leading chopper.  0 phase by defintion
%Master choppers - Easily defined for optically blind system
master1_phase = 0;
master2_phase = 110; % - second of the master pair WORKING BACKWARDS UP THE BEAM. 110 degrees to be 'optically blind' by definition.  +ve because it's leading edge (where phase is defined) is ADVANCED relative to master1.


%Slave choppers - positioned to make 'frame selection'
slave_phase = [];
for n =1:length(resolution_matrix)
    master1 = str2num(spacing_masters_matrix{n}(3));
    master1_pos = chopper_positions(master1);
    master2 = str2num(spacing_masters_matrix{n}(1));
    master2_pos = chopper_positions(master2);
    slave1 = str2num(spacing_slaves_matrix{n}(3));
    slave1_pos = chopper_positions(slave1);
    slave2 = str2num(spacing_slaves_matrix{n}(1));
    slave2_pos = chopper_positions(slave2);
    
    %Calculate the maximum pulse time window at the slave choppers (given
    %by the time-distance diagram of the shortest and longest wavelengths
    
    %slave1
    t1_1 = (master1_pos - slave1_pos) * m_n * wav_band(1)*(1e-10)/h;
    t1_2 = (master1_pos - slave1_pos) * m_n * wav_band(2)*(1e-10)/h;
    t1 = max([t1_1, t1_2]);
       
    t2_1 = (master2_pos - slave1_pos) * m_n * wav_band(1)*(1e-10)/h;
    t2_2 = (master2_pos - slave1_pos) * m_n * wav_band(2)*(1e-10)/h;
    t2 = min([t2_1, t2_2]);
    
    max_pulse_width_slave1 = t2-t1;
    max_pulse_phase_width_slave1 = max_pulse_width_slave1 * (f1_frequency_matrix(n)/60)*360;
        
    pulse_time_centre_slave1 = mean([t2,t1]);
    pulse_phase_centre_slave1 = pulse_time_centre_slave1 * (f1_frequency_matrix(n)/60)*360;
    slave1_phase = pulse_phase_centre_slave1 + (chopper_opening_angle/2);
    slave_phase(n,1) = slave1_phase;
      
    %slave2
    t1_1 = (master1_pos - slave2_pos) * m_n * wav_band(1)*(1e-10)/h;
    t1_2 = (master1_pos - slave2_pos) * m_n * wav_band(2)*(1e-10)/h;
    t1 = max([t1_1, t1_2]);
       
    t2_1 = (master2_pos - slave2_pos) * m_n * wav_band(1)*(1e-10)/h;
    t2_2 = (master2_pos - slave2_pos) * m_n * wav_band(2)*(1e-10)/h;
    t2 = min([t2_1, t2_2]);
    
    max_pulse_width_slave2 = t1-t2;
    max_pulse_phase_width_slave2 = max_pulse_width_slave2 * (f1_frequency_matrix(n)/60)*360;
        
    pulse_time_centre_slave2 = mean([t2,t1]);
    pulse_phase_centre_slave2 = pulse_time_centre_slave2 * (f1_frequency_matrix(n)/60)*360;
    slave2_phase = pulse_phase_centre_slave2 + (chopper_opening_angle/2);
    slave_phase(n,2) = slave2_phase;
end



disp(['Resolutions & Chopper speeds for Detector Distance = ' num2str(detector_distance) ' (m)']);
disp(['Resolution %' char(9) 'Masters' char(9) 'xN' char(9) 'NxF1 [RPM]' char(9) 'Phase' char(9) char(9) 'Slaves' char(9) 'F1 [RPM] ' char(9) 'Phase'])
disp(' ')
for n = 1:length(resolution_matrix);
    disp([num2str(resolution_matrix(n)) char (9) char(9) fliplr(spacing_masters_matrix{n}) char(9) num2str(final_chopper_multiplier(n)) char(9) num2str(f1_frequency_matrix(n) * final_chopper_multiplier(n),'%3.2f') char(9) char(9) [num2str(master1_phase) ',' num2str(master2_phase)] char(9) char(9) fliplr(spacing_slaves_matrix{n}) char(9) num2str(f1_frequency_matrix(n),'%3.2f') char(9) char(9) num2str(slave_phase(n,1),'%3.2f') ',' num2str(slave_phase(n,2),'%3.2f')])
end
      
disp(' ')
disp('NOTE:  Chopper phases are defined relative to their LEADING EDGE')
disp('+ve phases indicate choppers opening AHEAD of the master')
disp('-ve phases indicate choppers opening AFTER the master')
disp(' ')



%Prepare Function return output
chopper_params.opening_angle = chopper_opening_angle;
chopper_params.wav_range = [wav_band(1), wav_band(2)];
chopper_params.last_chopper_sample_distance = last_chopper_sample_length;
chopper_params.detector_distance = detector_distance;
for n = 1:length(resolution_matrix)
    chopper_params.resolution(n,:) = resolution_matrix(n);
    chopper_params.masters(n,:) = str2num(fliplr(spacing_masters_matrix{n}));
    chopper_params.slaves(n,:) = str2num(fliplr(spacing_slaves_matrix{n}));
    chopper_params.multiplier(n,:) = final_chopper_multiplier(n);
    chopper_params.masters_rpm(n,:) = f1_frequency_matrix(n) * final_chopper_multiplier(n);
    chopper_params.slaves_rpm(n,:) = f1_frequency_matrix(n);
    chopper_params.masters_phase(n,:) = [master1_phase, master2_phase];
    chopper_params.slaves_phase(n,:) = [slave_phase(n,1), slave_phase(n,2)];
    chopper_params.total_tof(n,:) = total_tof_matrix(n);

end

