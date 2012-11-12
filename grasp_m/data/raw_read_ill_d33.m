function numor_data = raw_read_ill_d33(fname,numor)

global inst_params

%***** Raw Data Load Routine for ILL D33 *****
param = zeros(128,1);

%Read ILL D33 Nexus Format Data (HDF)
warning on
fileinfo=hdf5info(fname);
entryName =  fileinfo.GroupHierarchy.Groups(1).Name;
numor = str2num(entryName(5:length(entryName)));
if isempty(numor); numor = 0; end


%User Information
temp1 = hdf5read(fname,strcat(entryName,'/user/name'));
numor_data.info.user = temp1.Data;

% Date and time from start_time (if available)!
temp1 = hdf5read(fname,strcat(entryName,'/start_time'))
numor_data.info.start_date = temp1.Data(1:10);
numor_data.info.start_time = temp1.Data(12:18);
temp1 = hdf5read(fname,strcat(entryName,'/end_time'));
numor_data.info.end_date = temp1.Data(1:10);
numor_data.info.end_time = temp1.Data(12:18);

%Subtitle
temp1 = hdf5read(fname,strcat(entryName,'/title'));
len = length(temp1.Data); 
if len<=80
    numor_data.subtitle = temp1.Data(1:len);
elseif len>80
    numor_data.subtitle = strcat(temp1.Data(1:77),'...');
end

%Time and Monitor
param(inst_params.vectors.time) = hdf5read(fname,strcat(entryName,'/duration')); %Seconds
%param(inst_params.vectors.monitor) = hdf5read(fname,strcat(entryName,'/monitor/bm1_counts')); %Beam Monitor 1

%Add extra parameter total counts actually counted from the data in the file
%param(127) = sum(sum(sum(numor_data.data1))); %The total detector counts as summed from the data array
param(128) = numor; 
numor_data.params1 = param;

%Finally Read the data array.
detector1_data = double(hdf5read(fname,strcat(entryName,'/data/data')));

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

%Temporary parameters to make Grasp work
param(inst_params.vectors.col) = 10;
param(inst_params.vectors.wav) = 10;
param(inst_params.vectors.deltawav) = 0.1;
param(inst_params.vectors.det) = 11;
param(inst_params.vectors.det_pannel) = 1;

%Prepare Grasp Depth-format time frames
for n = 1:data_size(1);
    %Detector Data and Errors
    time_frame = reshape(detector1_data(n,:),256,128);
    %Turn around to the correct orientation
    time_frame = rot90(time_frame);
    time_frame = flipud(time_frame);
    numor_data.data1(:,:,n) = time_frame;
    numor_data.error1(:,:,n) = sqrt(time_frame);
 
    param(127) = sum(sum(sum(numor_data.data1(:,:,n))));
       
    %Parameters per depth
    numor_data.params1(:,n) = param;
    
    %Make empty pannel data
    numor_data.data2 = zeros(inst_params.detector2.pixels(2),inst_params.detector2.pixels(1));
    numor_data.error2 = zeros(inst_params.detector2.pixels(2),inst_params.detector2.pixels(1));
    numor_data.params2(:,n) = param;

    numor_data.data3 = zeros(inst_params.detector3.pixels(2),inst_params.detector3.pixels(1));
    numor_data.error3 = zeros(inst_params.detector3.pixels(2),inst_params.detector3.pixels(1));
    numor_data.params3(:,n) = param;

    numor_data.data4 = zeros(inst_params.detector4.pixels(2),inst_params.detector4.pixels(1));
    numor_data.error4 = zeros(inst_params.detector4.pixels(2),inst_params.detector4.pixels(1));
    numor_data.params4(:,n) = param;

    numor_data.data5 = zeros(inst_params.detector5.pixels(2),inst_params.detector5.pixels(1));
    numor_data.error5 = zeros(inst_params.detector5.pixels(2),inst_params.detector5.pixels(1));
    numor_data.params5(:,n) = param;

    
end



% 
% %Temperature
% try; param(inst_params.vectors.temp) = hdf5read(fname,strcat(entryName,'/sample/temperature'));%Temperature
% catch;disp('Could not read sample temperature from data file'); end
% 
% %Magnetic field
% try;param(inst_params.vectors.field) = hdf5read(fname,strcat(entryName,'/sample/magnetic_field')); %Magnetic field
% catch;disp('Could not read magnetic filed temperature from data file'); end
% 
% %Lambda, delta_lambda, Sample angles
% param(inst_params.vectors.wav) = hdf5read(fname,strcat(entryName,'/data/wavelength')); %Wavelength
% param(inst_params.vectors.deltawav) = hdf5read(fname,strcat(entryName,'/instrument/velocity_selector/wavelength_spread')); %Delta Lambda
% param(inst_params.vectors.sel_rpm) = hdf5read(fname,strcat(entryName,'/instrument/velocity_selector/rspeed')); %Selector Speed RPM
% 
% 
% %Collimation
% param(inst_params.vectors.col) = 0.001*hdf5read(fname,strcat(entryName,'/instrument/parameters/L1')); %L1 in metres
% 
% %Sample Motors
% param(inst_params.vectors.san) = hdf5read(fname,strcat(entryName,'/sample/sample_theta')); %Sample rotation
% %  Phi and chi motors exist only when motors enabled, otherwise no entry in dataset
% %  This is screwed up and needs to be fixed (temperature and magnetic_field
% %  entries now persist
% param(inst_params.vectors.phi) = hdf5read(fname,strcat(entryName,'/sample/sample_phi')); %Sample upper tilt
% %param(inst_params.vectors.phi2) = hdf5read(fname,strcat(entryName,'/sample/sample_chi')); %Sample lower tilt
% 
% %Detector Parameters
% param(inst_params.vectors.det) = 0.001*hdf5read(fname,strcat(entryName,'/instrument/parameters/L2')); %Detector distance (in m)
% param(inst_params.vectors.bx) = hdf5read(fname,strcat(entryName,'/instrument/detector/bsx')); %BeamStop x 
% param(inst_params.vectors.by) = hdf5read(fname,strcat(entryName,'/instrument/detector/bsz')); %BeamStop y





    
    
% Things that exist in the file in case you want to know
% Sample_thickness  =  hdf5read(fname,strcat(entryName,'/sample/SampleThickness')); in mm
% Sample_aperture  = hdf5read(fname,strcat(entryName,'/sample/diameter')); in mm
% BeamStopNumber = hdf5read(fname,strcat(entryName,'/instrument/parameters/BeamStop'));
% BS_diameter = hdf5read(fname,strcat(entryName,'/instrument/parameters/BSdiam')); Beamstop diameter in mm

