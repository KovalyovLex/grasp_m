function numor_data = raw_read_isis_sans2d(fname,numor)

global inst_params

%Some constants for tof - wav calculations
h = 6.626076*(10^-34); %Plank's Constant
m_n = 1.674929*(10^-27); %Neutron Rest Mass

param = zeros(128,1); %Empty Parameters array of 128, as Grasp expects.

%Read ISIS SANS 2D Nexus Format Data (HDF)
warning on
fileinfo=hdf5info(fname);
entryName =  fileinfo.GroupHierarchy.Groups(1).Name; %Root folder in HDF file

%Numor
param(inst_params.vectors.numor) = numor; %Usually stored as param 128

%User Information
temp1 = hdf5read(fname,strcat(entryName,'/user_1/name'));
numor_data.info.user = temp1.Data;

% Date and time from start_time
temp1 = hdf5read(fname,strcat(entryName,'/start_time'));
numor_data.info.start_date = temp1.Data(1:10);
numor_data.info.start_time = temp1.Data(12:19);
temp1 = hdf5read(fname,strcat(entryName,'/end_time'));
numor_data.info.end_date = temp1.Data(1:10);
numor_data.info.end_time = temp1.Data(12:19);

%Subtitle
temp1 = hdf5read(fname,strcat(entryName,'/title'));
len = length(temp1.Data); 
if len<=80
    numor_data.subtitle = temp1.Data(1:len);
elseif len>80
    numor_data.subtitle = strcat(temp1.Data(1:77),'...');
end

%Acquisition Time
param(inst_params.vectors.time) = hdf5read(fname,strcat(entryName,'/collection_time')); %Seconds

%Detector Distance
param(inst_params.vectors.det) = (hdf5read(fname,strcat(entryName,'/selog/Rear_Det_Z/value')))/1000; %m

%Moderator Distance
moderator_distance = hdf5read(fname,strcat(entryName,'/instrument/moderator/distance')); %m
%Total tof distance moderator - detector
total_tof = -moderator_distance + param(inst_params.vectors.det);


%Sample environment parameters  - edit the hdf5read command as appropriate
%param(inst_params.vectors.san) = hdf5read(fname,strcat(entryName,'/selog/Huber_X/value'));
%param(inst_params.vectors.phi) = hdf5read(fname,strcat(entryName,'/selog/Huber_X/value'));
%param(inst_params.vectors.temp) = hdf5read(fname,strcat(entryName,'/selog/Huber_X/value'));
%param(inst_params.vectors.tset) = hdf5read(fname,strcat(entryName,'/selog/Huber_X/value'));
%param(inst_params.vectors.treg) = hdf5read(fname,strcat(entryName,'/selog/Huber_X/value'));
%param(inst_params.vectors.field) = hdf5read(fname,strcat(entryName,'/selog/Huber_X/value'));



%Collimation length
%Read guide 1-5 positions and work out what the collimation length is
%Guide lengths = 2m each
%Guide 1 Guide/Collimation 0/270
%Guide 2 Guide/Collimation 270/0
%Guide 3 Guide/Collimation 0/270
%Guide 4 Guide/Collimation 270/0
%Guide 5 Guide/Collimation 0/270
col = 12; %Maximum collimation length
guide1=(hdf5read(fname,strcat(entryName,'/selog/Guide1/value')));
if guide1 < 100; col = col -2; end
guide2=(hdf5read(fname,strcat(entryName,'/selog/Guide2/value')));
if guide2 > 100; col = col -2; end
guide3=(hdf5read(fname,strcat(entryName,'/selog/Guide3/value')));
if guide3 < 100; col = col -2; end
guide4=(hdf5read(fname,strcat(entryName,'/selog/Guide4/value')));
if guide4 >100; col = col -2; end
guide5=(hdf5read(fname,strcat(entryName,'/selog/Guide5/value')));
if guide5 <100; col = col -2; end
param(inst_params.vectors.col) = col;



%****** Monitor2 - TOF Monitor *****
monitor_counts = hdf5read(fname,strcat(entryName,'/monitor_2/data')); %153 values
monitor_tofs = hdf5read(fname,strcat(entryName,'/monitor_2/time_of_flight')); %154 values.  The +1 is beacuse these are actual bin-edges, not bin centres
monitor_tofs = monitor_tofs /1e6; %convert to seconds
monitor_wavs = h ./ (m_n.*(inst_params.source.moderator_monitor_distance./monitor_tofs)); %Convert tofs to wavs.  tof_monitor is 17.937m from moderator
monitor_wavs = monitor_wavs./(10^-10); %Convert m to Angstroms

%Prepare Monitor TOF Histogram Data Storage
wav_monitor = zeros(length(monitor_counts),4); %mean_lambda, counts, lower_edge (lambda), upper_edge (lambda)
for n = 1:length(monitor_counts);
    wav_monitor(n,1) = (monitor_wavs(n)+monitor_wavs(n+1))/2; %Mean lambda
    wav_monitor(n,2) = monitor_counts(n); %Histogram monitor sum for this channel
    wav_monitor(n,3) = monitor_wavs(n); %lower bin edge (lambda)
    wav_monitor(n,4) = monitor_wavs(n+1); %upper bin edge (lambda)
end




%***** Detector - TOF time channels *****
detector_tofs = double(hdf5read(fname,strcat(entryName,'/instrument/detector_1/time_of_flight'))); %154 values.  The +1 is because these are actual bin-edges not bin centres
detector_tofs = detector_tofs / 1e6; %convert to Seconds
detector_wavs = h ./ (m_n.*(total_tof./detector_tofs)); %Convert tofs to wavs based on total_tof distance
detector_wavs = detector_wavs./(10^-10); %Convert m to Angstroms

%Prepare Detector TOF Histogram Data Storage
wav_detector = zeros((length(detector_tofs)-1),3); %mean_lambda, lower_edge (lambda), upper_edge (lambda)
for n = 1:(length(detector_tofs)-1);
    wav_detector(n,1) = (detector_wavs(n)+detector_wavs(n+1))/2; %Mean lambda
    wav_detector(n,2) = detector_wavs(n); %lower bin edge (lambda)
    wav_detector(n,3) = detector_wavs(n+1); %upper bin edge (lambda)
end



%***** Read the TOF Detector Data Array. *****
detector1_data = double(hdf5read(fname,strcat(entryName,'/instrument/detector_1/counts'))); %153 Frames (compared to the 154 TOF bin edges)
%Stored detector data in HDF file is twice as big as it should be, i.e spare space.  Need to cut this off to the first 36864
detector1_data = detector1_data(:,1:36864,:);  %36864 = 192x192 pixels which I think Ordela detectors are

%Total detector counts
param(inst_params.vectors.array_counts) = sum(sum(sum(detector1_data)));

%Resize into 3D array, x,y, timedepth as Grasp likes
data_size = size(detector1_data);
numor_data.data1 = [];
frames = data_size(1);
disp(['Number of frames:  ' num2str(frames)]);
numor_data.n_frames = frames;
%divide collection time / frame to give frame time
param(inst_params.vectors.time)= param(inst_params.vectors.time)/frames;
disp('Reshaping Matrix')
disp('Using SQRT(I) errors')


%***** Prepare Grasp Depth-format time frames *****
for n = 1:frames
    %Detector Data and Errors
    detector_frame = reshape(detector1_data(n,:),192,192);
    %Turn around to the correct orientation
    detector_frame = rot90(detector_frame);
    detector_frame = flipud(detector_frame);
    numor_data.data1(:,:,n) = detector_frame;
    numor_data.error1(:,:,n) = sqrt(detector_frame); %SQRT(I) errors
    
    %Wavelength for each frame
    param(inst_params.vectors.wav) = wav_detector(n,1); %Effective mean wavelength of time bin
    param(inst_params.vectors.deltawav) = 0.01; %This is a guess (1%) and need to be properly calculated from moderator pulse size & total tof
    
    %Monitor for each frame
        %Do nothing to monitor - at different distance to detector so should be wrong
        %param(inst_params.vectors.monitor) = wav_monitor(n,2);
        
        %Linear interpolation only to match detector wav bins
        %param(inst_params.vectors.monitor) = interp1(wav_monitor(:,1),wav_monitor(:,2),wav_detector(n,1),'linear','extrap');
        
        %Note this is interpolation of a HISTOGRAM, not a point graph so is weighted to the dx (delta_wavlength) bin widths also
        monitor_histogram_area = interp1(wav_monitor(:,1),wav_monitor(:,2),wav_detector(n,1),'linear','extrap');
        monitor_histogram_lower_bin_edge = interp1(wav_monitor(:,1),wav_monitor(:,3),wav_detector(n,1),'linear','extrap');
        monitor_histogram_upper_bin_edge = interp1(wav_monitor(:,1),wav_monitor(:,4),wav_detector(n,1),'linear','extrap');
        monitor = monitor_histogram_area *(wav_detector(n,3) - wav_detector(n,2)) /  (monitor_histogram_upper_bin_edge - monitor_histogram_lower_bin_edge);
        param(inst_params.vectors.monitor) =monitor; %This is the re-binned Monitor histogram to take into account the fact the monitor is at a different tof-distance compared to the detector
        
        %Rescale monitor by the direct beam function
        db_scaler = interp1(inst_params.direct_beam_function(:,1),inst_params.direct_beam_function(:,2),wav_detector(n,1),'linear','extrap');
        param(inst_params.vectors.monitor) =  param(inst_params.vectors.monitor) * db_scaler;
        
        
        
    %Store all the parameters for each depth
    numor_data.params1(:,n) = param;
end


numor_data.data2 = numor_data.data1;
numor_data.error2 = numor_data.error1;
numor_data.params2 = numor_data.params1;




