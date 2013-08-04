function numor_data = raw_read_ill_nexus(fname,temp)


global inst_params
global grasp_env

param = zeros(128,1); %Empty Parameters array of 128, as Grasp expects.

%Read ILL SANS Nexus Format Data (HDF)
warning on
fileinfo=hdf5info(fname);
entryName =  fileinfo.GroupHierarchy.Groups(1).Name; %Root folder in HDF file


%***** Read User, Sample and Environment Parameters *****

%Numor
param(inst_params.vectors.numor) = hdf5read(fname,strcat(entryName,'/run_number'));; %Usually stored as param 128

%User Information
temp1 = hdf5read(fname,strcat(entryName,'/user/name'));
numor_data.info.user = temp1.Data;

% Date and time from start_time
temp1 = hdf5read(fname,strcat(entryName,'/start_time'));
numor_data.info.start_date = temp1.Data(1:10);
numor_data.info.start_time = temp1.Data(11:18);
temp1 = hdf5read(fname,strcat(entryName,'/end_time'));
numor_data.info.end_date = temp1.Data(1:10);
numor_data.info.end_time = temp1.Data(11:18);

%Acquisition Time
param(inst_params.vectors.aq_time) = hdf5read(fname,strcat(entryName,'/duration')); %Seconds

%Reactor Power
param(inst_params.vectors.reactor_power) = hdf5read(fname,strcat(entryName,'/reactor_power')); %MW

%Subtitle
temp1 = hdf5read(fname,strcat(entryName,'/sample_description'));
len = length(temp1.Data); 
if len<=80
    numor_data.subtitle = temp1.Data(1:len);
elseif len>80
    numor_data.subtitle = strcat(temp1.Data(1:77),'...');
end


%***** Read Instrument configuration & Measurement parameters ******

%Detector Distance & Motors
param(inst_params.vectors.det) = (hdf5read(fname,strcat(entryName,'/D22/detector/det_actual'))); %m
param(inst_params.vectors.detcalc) = (hdf5read(fname,strcat(entryName,'/D22/detector/det_calc'))); %m
param(inst_params.vectors.dtr) = (hdf5read(fname,strcat(entryName,'/D22/detector/dtr_actual'))); %m
param(inst_params.vectors.dan) = (hdf5read(fname,strcat(entryName,'/D22/detector/dan_actual'))); %m

%Detector pixel size
param(inst_params.vectors.pixel_x) = (hdf5read(fname,strcat(entryName,'/D22/detector/pixel_size_x'))); %mm
param(inst_params.vectors.pixel_y) = (hdf5read(fname,strcat(entryName,'/D22/detector/pixel_size_y'))); %mm
if param(inst_params.vectors.pixel_x) ~= inst_params.detector1.pixel_size(1); %Default Pixel X-setting
    disp(['Modifying Pixel X size from ' num2str(inst_params.detector1.pixel_size(1)) ' to ' num2str(param(inst_params.vectors.pixel_x))]);
    inst_params.detector1.pixel_size(1) = param(inst_params.vectors.pixel_x);
end
if param(inst_params.vectors.pixel_y) ~= inst_params.detector1.pixel_size(2); %Default Pixel Y-setting
    disp(['Modifying Pixel Y size from ' num2str(inst_params.detector1.pixel_size(2)) ' to ' num2str(param(inst_params.vectors.pixel_y))]);
    inst_params.detector1.pixel_size(2) = param(inst_params.vectors.pixel_y);
end


%Wavelength
param(inst_params.vectors.wav) = hdf5read(fname,strcat(entryName,'/D22/selector/wavelength'));
param(inst_params.vectors.deltawav) = 0.1;
param(inst_params.vectors.sel_rpm) = hdf5read(fname,strcat(entryName,'/D22/selector/rotation_speed'));
try; param(inst_params.vectors.seltrs) = hdf5read(fname,strcat(entryName,'/D22/selector/seltrs_actual')); catch; end


%BeamStop
param(inst_params.vectors.bx) = hdf5read(fname,strcat(entryName,'/D22/beamstop/bx_actual'));
param(inst_params.vectors.by) = hdf5read(fname,strcat(entryName,'/D22/beamstop/by_actual'));

%Attenuator
param(inst_params.vectors.att_type) = hdf5read(fname,strcat(entryName,'/D22/attenuator/position'));
param(inst_params.vectors.att_status) = 1;
%ChopperAttenuator2
param(inst_params.vectors.att2) = hdf5read(fname,strcat(entryName,'/D22/attenuator2/actual_value'));

%Collimation
param(inst_params.vectors.col) = (hdf5read(fname,strcat(entryName,'/D22/collimation/actual_position'))); %m;
temp = (hdf5read(fname,strcat(entryName,'/D22/collimation/ap_size'))); %m;
if max(size(temp)) == 2;
    param(inst_params.vectors.col_app) = 0;
elseif max(size(temp)) == 1;
    param(inst_params.vectors.col_app) = 1;
end

param(inst_params.vectors.vslit_center) = hdf5read(fname,strcat(entryName,'/D22/collimation/vertical_slit_center'));
param(inst_params.vectors.vslit_width) = hdf5read(fname,strcat(entryName,'/D22/collimation/vertical_slit_width_actual'));
param(inst_params.vectors.hslit_center) = hdf5read(fname,strcat(entryName,'/D22/collimation/horizontal_slit_center'));
param(inst_params.vectors.hslit_width) = hdf5read(fname,strcat(entryName,'/D22/collimation/horizontal_slit_width_actual'));

if strcmp(grasp_env.inst,'ILL_d22') 
    %Patch effective collimation length if using entrance apertures at the attenuator position
    if param(inst_params.vectors.att_type) > 3 && param(inst_params.vectors.att_type) < 8
        if param(inst_params.vectors.att_status) == 1
            disp(['Entrance Aperture in use:  Patching effective collimation length to ' num2str(inst_params.col(length(inst_params.col)))]);
            param(inst_params.vectors.col) = inst_params.col(length(inst_params.col));
            param(inst_params.vectors.col_app) = param(inst_params.vectors.att_type);
        end
    end
end


%Chopper Parameters
param(inst_params.vectors.chopper1_phase) = hdf5read(fname,strcat(entryName,'/D22/chopper1/phase'));
param(inst_params.vectors.chopper1_speed) = hdf5read(fname,strcat(entryName,'/D22/chopper1/rotation_speed'));
param(inst_params.vectors.chopper2_phase) = hdf5read(fname,strcat(entryName,'/D22/chopper2/phase'));
param(inst_params.vectors.chopper2_speed) = hdf5read(fname,strcat(entryName,'/D22/chopper2/rotation_speed'));


%Sample Motors
param(inst_params.vectors.san) = (hdf5read(fname,strcat(entryName,'/sample/san_actual'))); %m
param(inst_params.vectors.phi) = (hdf5read(fname,strcat(entryName,'/sample/phi_actual'))); %m
param(inst_params.vectors.sdi) = (hdf5read(fname,strcat(entryName,'/sample/sdi_actual'))); %m
param(inst_params.vectors.trs) = (hdf5read(fname,strcat(entryName,'/sample/trs_actual'))); %m
param(inst_params.vectors.sht) = (hdf5read(fname,strcat(entryName,'/sample/sht_actual'))); %m
param(inst_params.vectors.str) = (hdf5read(fname,strcat(entryName,'/sample/str_actual'))); %m
param(inst_params.vectors.chpos) = (hdf5read(fname,strcat(entryName,'/sample/sample_changer_value'))); %m
param(inst_params.vectors.omega) = (hdf5read(fname,strcat(entryName,'/sample/omega_actual'))); %m
param(inst_params.vectors.slit) = (hdf5read(fname,strcat(entryName,'/sample/slit_actual'))); %mm

%Sample environment
%Temperatures
try; param(inst_params.vectors.temp) = (hdf5read(fname,strcat(entryName,'/sample/temperature'))); catch; end
try; param(inst_params.vectors.treg) = (hdf5read(fname,strcat(entryName,'/sample/regulation_temperature'))); catch; end
try; param(inst_params.vectors.tset) = (hdf5read(fname,strcat(entryName,'/sample/setpoint_temperature'))); catch; end
try; param(inst_params.vectors.bath1_temp) = (hdf5read(fname,strcat(entryName,'/sample/bath1_regulation_temperature'))); catch; end
try; param(inst_params.vectors.bath1_set) = (hdf5read(fname,strcat(entryName,'/sample/bath1_setpoint_temperature'))); catch; end
try; param(inst_params.vectors.bath2_temp) = (hdf5read(fname,strcat(entryName,'/sample/bath2_regulation_temperature'))); catch; end
try; param(inst_params.vectors.bath2_temp) = (hdf5read(fname,strcat(entryName,'/sample/bath2_setpoint_temperature'))); catch; end
try; param(inst_params.vectors.bath_switch) = (hdf5read(fname,strcat(entryName,'/sample/bath_selector_actual'))); catch; end
try; param(inst_params.vectors.air_temp) = (hdf5read(fname,strcat(entryName,'/sample/air_temperature'))); catch; end
try; param(inst_params.vectors.rack_temp) = (hdf5read(fname,strcat(entryName,'/sample/rack_temperature')));  catch; end

%Power Supplies
try; param(inst_params.vectors.ps1_i) = (hdf5read(fname,strcat(entryName,'/sample/ps1_current'))); catch; end
try; param(inst_params.vectors.ps1_v) = (hdf5read(fname,strcat(entryName,'/sample/ps1_voltage'))); catch; end
try; param(inst_params.vectors.ps2_i) = (hdf5read(fname,strcat(entryName,'/sample/ps2_current'))); catch; end
try; param(inst_params.vectors.ps2_v) = (hdf5read(fname,strcat(entryName,'/sample/ps2_voltage'))); catch; end
try; param(inst_params.vectors.ps3_i) = (hdf5read(fname,strcat(entryName,'/sample/ps3_current'))); catch; end
try; param(inst_params.vectors.ps3_v) = (hdf5read(fname,strcat(entryName,'/sample/ps3_voltage'))); catch; end



%Magnet
try; param(inst_params.vectors.field) = (hdf5read(fname,strcat(entryName,'/sample/field_actual'))); catch; end
%Shear
try; param(inst_params.vectors.shear_rate) = (hdf5read(fname,strcat(entryName,'/sample/shearrate_actual'))); catch; end


%***** Read Detector Data, Monitor and Time Slices *****

%***** Determine Measurement Mode, Single, Kinetic or TOF *****
mode = hdf5read(fname,strcat(entryName,'/mode'));
if mode == 0; numor_data.file_type = 'single frame';
elseif mode == 3;
    numor_data.file_type = 'kinetic';
    %read time slices
    slices= hdf5read(fname,strcat(entryName,'/slices'));
    frame_time = slices(1)/2;
    param(inst_params.vectors.pickups) = hdf5read(fname,strcat(entryName,'/nbrepaint'));
elseif mode == 4;
    numor_data.file_type = 'tof';
    %read tof parameters
    tof_params = hdf5read(fname,strcat(entryName,'/monitor1/time_of_flight'));
    param(inst_params.vectors.tof_width) = tof_params(1); %microS
    param(inst_params.vectors.tof_channels) = tof_params(2); %microS
    param(inst_params.vectors.tof_delay) = tof_params(3); %microS
    param(inst_params.vectors.pickups) = hdf5read(fname,strcat(entryName,'/nbpickup'));
else
    numor_data.file_type = 'unknown';
end
disp(['File type is ' numor_data.file_type ', mode = ' num2str(mode)]);



%Detector Data - all frames
numor_data.data1 = [];
data = double(hdf5read(fname,strcat(entryName,'/data/data')));
temp_data_size = size(data)

data = reshape(data,temp_data_size(2),temp_data_size(3),temp_data_size(1));
data_size = size(data);
if length(data_size) <3; data_size(3) =1; end
numor_data.n_frames = data_size(3);
disp(['Number of Frames = ' num2str(numor_data.n_frames)]);
disp('Using SQRT(I) errors')

%Read Monitor Data - all frames
monitor = hdf5read(fname,strcat(entryName,'/monitor1/data'));



%***** Loop though the frames and organize the data array as Grasp likes it *****
numor_data.data1 = [];
numor_data.error1 = [];
for n = 1:numor_data.n_frames
%    disp(['Preparing frame ' num2str(n)]);
    %data
    frame_data = reshape(data(:,:,n),data_size(1),data_size(2));
    frame_data = rot90(frame_data);
    frame_data = flipud(frame_data);
    numor_data.data1(:,:,n) = frame_data;
    %error
    frame_error = sqrt(frame_data);
    numor_data.error1(:,:,n) = frame_error;
    %monitor
    param(inst_params.vectors.monitor) = monitor(n);
    %time & frame_time
    if strcmp(numor_data.file_type,'kinetic');
        param(inst_params.vectors.time) = slices(n)*param(inst_params.vectors.pickups);
        param(inst_params.vectors.frame_time) = frame_time;
        frame_time = frame_time + slices(n); %ready for next time round the loop
        param(inst_params.vectors.slice_time) = slices(n);
    elseif strcmp(numor_data.file_type,'tof');
        param(inst_params.vectors.time) = param(inst_params.vectors.tof_width) * param(inst_params.vectors.pickups) / 1e6; %microS to S
        frame_time = param(inst_params.vectors.tof_delay) + param(inst_params.vectors.tof_width) * (n-1) + param(inst_params.vectors.tof_width)/2;
        frame_time = frame_time/1e6;
        param(inst_params.vectors.frame_time) = frame_time;
        param(inst_params.vectors.slice_time) = param(inst_params.vectors.tof_width)/1e6;
    else %single or other
        param(inst_params.vectors.time) = param(inst_params.vectors.aq_time)/numor_data.n_frames;
        param(inst_params.vectors.slice_time) = param(inst_params.vectors.time);
    end
    %frame total counts
    param(inst_params.vectors.array_counts) = sum(sum(frame_data)); %Total Detector counts - all frames
    
    
    %Frame Parameters
    numor_data.params1(:,n) = param;
end

