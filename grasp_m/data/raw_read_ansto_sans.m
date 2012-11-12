function numor_data = raw_read_ansto_sans(fname,numor)

global inst_params

%***** Raw Data Load Routine for QUOKKA *****
param = zeros(128,1);

%Read OPAL QuOKKA format data
warning on
fileinfo=hdf5info(fname);
entryName =  fileinfo.GroupHierarchy.Groups(1).Name;
numor = str2num(entryName(5:length(entryName)));
if isempty(numor); numor = 0; end


%User Information
temp1 = hdf5read(fname,strcat(entryName,'/user/name'));
numor_data.info.user = temp1.Name;


% Date and time from start_time (if available)!
temp1 = hdf5read(fname,strcat(entryName,'/start_time'));
numor_data.info.start_date = temp1.Data(1:10);
numor_data.info.start_time = temp1.Data(12:19);
temp1 = hdf5read(fname,strcat(entryName,'/end_time'));
numor_data.info.end_date = temp1.Data(1:10);
numor_data.info.end_time = temp1.Data(12:19);
 
%Subtitle
temp1 = hdf5read(fname,strcat(entryName,'/sample/name'));
len = length(temp1.Data); 
if len<=80
    numor_data.subtitle = temp1.Data(1:len);
elseif len>80
    numor_data.subtitle = strcat(temp1.Data(1:77),'...');
end

%Time and Monitor
param(inst_params.vectors.time) = hdf5read(fname,strcat(entryName,'/monitor/time')); %Seconds
param(inst_params.vectors.monitor) = hdf5read(fname,strcat(entryName,'/monitor/bm1_counts')); %Beam Monitor 1

%Temperature
try; param(inst_params.vectors.temp) = hdf5read(fname,strcat(entryName,'/sample/temperature'));%Temperature
catch;disp('Could not read sample temperature from data file'); end

%Magnetic field
try;param(inst_params.vectors.field) = hdf5read(fname,strcat(entryName,'/sample/magnetic_field')); %Magnetic field
catch;disp('Could not read magnetic filed temperature from data file'); end

%Lambda, delta_lambda, Sample angles
param(inst_params.vectors.wav) = hdf5read(fname,strcat(entryName,'/data/wavelength')); %Wavelength
param(inst_params.vectors.deltawav) = hdf5read(fname,strcat(entryName,'/instrument/velocity_selector/wavelength_spread')); %Delta Lambda
param(inst_params.vectors.sel_rpm) = hdf5read(fname,strcat(entryName,'/instrument/velocity_selector/rspeed')); %Selector Speed RPM


%Collimation
param(inst_params.vectors.col) = 0.001*hdf5read(fname,strcat(entryName,'/instrument/parameters/L1')); %L1 in metres

%Sample Motors
param(inst_params.vectors.san) = hdf5read(fname,strcat(entryName,'/sample/sample_theta')); %Sample rotation
%  Phi and chi motors exist only when motors enabled, otherwise no entry in dataset
%  This is screwed up and needs to be fixed (temperature and magnetic_field
%  entries now persist
param(inst_params.vectors.phi) = hdf5read(fname,strcat(entryName,'/sample/sample_phi')); %Sample upper tilt
%param(inst_params.vectors.phi2) = hdf5read(fname,strcat(entryName,'/sample/sample_chi')); %Sample lower tilt

%Detector Parameters
param(inst_params.vectors.det) = 0.001*hdf5read(fname,strcat(entryName,'/instrument/parameters/L2')); %Detector distance (in m)
param(inst_params.vectors.bx) = hdf5read(fname,strcat(entryName,'/instrument/detector/bsx')); %BeamStop x 
param(inst_params.vectors.by) = hdf5read(fname,strcat(entryName,'/instrument/detector/bsz')); %BeamStop y

%Read the data array.
numor_data.data1 = double(hdf5read(fname,strcat(entryName,'/data/hmm_xy')));
%turn the data around to be viewed from reactor
numor_data.data1 = rot90(numor_data.data1);
numor_data.data1 = flipud(numor_data.data1);

%NOTE:  pixel width is 5.08 mm /pixel (0.2" exactly :)
param(inst_params.vectors.pixel_x) = 5.08e-3;
param(inst_params.vectors.pixel_y) = 5.08e-3;

%Add extra parameter total counts actually counted from the data in the file
param(127) = sum(sum(numor_data.data1)); %The total detector counts as summed from the data array
param(128) = numor; 

numor_data.params1 = param;

disp('Using SQRT(I) errors')
numor_data.error1 = sqrt(numor_data.data1);
    
    
% Things that exist in the file in case you want to know
% Sample_thickness  =  hdf5read(fname,strcat(entryName,'/sample/SampleThickness')); in mm
% Sample_aperture  = hdf5read(fname,strcat(entryName,'/sample/diameter')); in mm
% BeamStopNumber = hdf5read(fname,strcat(entryName,'/instrument/parameters/BeamStop'));
% BS_diameter = hdf5read(fname,strcat(entryName,'/instrument/parameters/BSdiam')); Beamstop diameter in mm

