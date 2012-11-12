function numor_data = raw_read_ansto_sans(fname)

if nargin < 2; numor = 0; end

global inst_params

%***** Raw Data Load Routine for QUOKKA *****
param = zeros(128,1);

%Read OPAL QuOKKA format data
warning on


%Regenerate the FileName, e.g. QKK00*****  etc.
temp = findstr(fname,filesep);
temp2 = fname(temp(length(temp))+1:length(fname));
[frecord,b] = strtok(temp2,'.nx.hdf');

%Experiment Info
numor_data.info.start_time = 'N/A';
numor_data.info.end_date = 'N/A';
numor_data.info.end_time = 'N/A';
numor_data.subtitle = 'No Title Loaded';
numor_data.info.user = 'No User Name Loaded';

%Time and Monitor
param(inst_params.vectors.time) = hdf5read(fname,[frecord '/monitor/time']); %Seconds
param(inst_params.vectors.monitor) = hdf5read(fname,[frecord '/monitor/bm1_counts']); %Beam Monitor 1

%Lambda, delta_lambda
param(inst_params.vectors.wav) = hdf5read(fname,[frecord '/data/Lambda']); %Wavelength
param(inst_params.vectors.deltawav) = hdf5read(fname,[frecord '/instrument/velocity_selector/LambdaResFWHM_percent']); %Delta Lambda (fraction)

%Sample Movements
param(inst_params.vectors.san) = hdf5read(fname,[frecord '/sample/sample_theta']); %Sample rotation
%What are the names of these angles?
%param(inst_params.vectors.phi1) = hdf5read(fname,'/entry1/sample/sample_phi'); %Sample upper tilt
%param(inst_params.vectors.phi2) = hdf5read(fname,'/entry1/sample/sample_chi'); %Sample lower tilt

%Temperature
param(inst_params.vectors.temp) = hdf5read(fname,[frecord '/sample/tc1_cntrl/sensorA/value']);%Temperature

%Magnetic field
param(inst_params.vectors.field) = hdf5read(fname,[frecord '/sample/magnetic_field']); %Magnetic field

%Detector Parameters
param(inst_params.vectors.det) = hdf5read(fname,[frecord '/instrument/detector/detector_y'])/1000; %Detector distance (in mm, convert to m)
param(inst_params.vectors.bx) = hdf5read(fname,[frecord '/instrument/detector/bsx']); %BeamStop x 
param(inst_params.vectors.by) = hdf5read(fname,[frecord '/instrument/detector/bsz']); %BeamStop y

%Collimation Parameters
param(inst_params.vectors.col) = 2;

%Read the data array.
data = hdf5read(fname, [frecord '/data/hmm_xy']);

%Add extra parameter total counts actually counted from the data in the file
param(127) = sum(sum(data)); %The total Det counts as summed from the data array

numor_data.data1 = double(data);
disp('Using SQRT(I) errors')
numor_data.error1 = sqrt(numor_data.data1);
numor_data.params1 = param;

