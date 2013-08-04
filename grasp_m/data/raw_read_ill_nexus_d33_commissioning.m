function numor_data = raw_read_ill_nexus_d33_commissioning(fname,numor)

global inst_params
global status_flags

param = zeros(128,1); %Empty Parameters array of 128, as Grasp expects.

%Read ILL SANS Nexus Format Data (HDF)
warning on
fileinfo=hdf5info(fname);
entryName =  fileinfo.GroupHierarchy.Groups(1).Name; %Root folder in HDF fileed


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
try; param(inst_params.vectors.aq_time) = hdf5read(fname,strcat(entryName,'/duration')); %Seconds
catch; param(inst_params.vectors.aq_time) =1; end

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

%Det 1 (Panel Detector)
try param(inst_params.vectors.det1) = (hdf5read(fname,strcat(entryName,'/D33/detector/det1_actual')));end %m
try param(inst_params.vectors.detcalc1) = (hdf5read(fname,strcat(entryName,'/D33/detector/det1_calc')));end %m

try param(inst_params.vectors.det1_panel_offset) = (hdf5read(fname,strcat(entryName,'/D33/detector/det1_panel_separation'))); end
try param(inst_params.vectors.oxl) = (hdf5read(fname,strcat(entryName,'/D33/detector/oxl'))); end
try param(inst_params.vectors.oxr) = (hdf5read(fname,strcat(entryName,'/D33/detector/oxr'))); end
try param(inst_params.vectors.oyt) = (hdf5read(fname,strcat(entryName,'/D33/detector/oyt'))); end
try param(inst_params.vectors.oyb) = (hdf5read(fname,strcat(entryName,'/D33/detector/oyb'))); end

%Det 2 (Rear Detector)
try param(inst_params.vectors.det2) = (hdf5read(fname,strcat(entryName,'/D33/detector/det2_actual'))); end %m
try param(inst_params.vectors.detcalc2) = (hdf5read(fname,strcat(entryName,'/D33/detector/det2_calc'))); end %m
%Alternative name for det2
try param(inst_params.vectors.det) = (hdf5read(fname,strcat(entryName,'/D33/detector/det2_actual'))); end %m
try param(inst_params.vectors.detcalc) = (hdf5read(fname,strcat(entryName,'/D33/detector/det2_calc'))); catch; param(inst_params.vectors.detcalc2) = param(inst_params.vectors.det2); end %m



% %Detector pixel size
% param(inst_params.vectors.pixel_x) = (hdf5read(fname,strcat(entryName,'/D33/detector/pixel_size_x'))); %mm
% param(inst_params.vectors.pixel_y) = (hdf5read(fname,strcat(entryName,'/D33/detector/pixel_size_y'))); %mm
% if param(inst_params.vectors.pixel_x) ~= inst_params.detector1.pixel_size(1); %Default Pixel X-setting
%     disp(['Modifying Pixel X size from ' num2str(inst_params.detector1.pixel_size(1)) ' to ' num2str(param(inst_params.vectors.pixel_x))]);
%     inst_params.detector1.pixel_size(1) = param(inst_params.vectors.pixel_x);
% end
% if param(inst_params.vectors.pixel_y) ~= inst_params.detector1.pixel_size(2); %Default Pixel Y-setting
%     disp(['Modifying Pixel Y size from ' num2str(inst_params.detector1.pixel_size(2)) ' to ' num2str(param(inst_params.vectors.pixel_y))]);
%     inst_params.detector1.pixel_size(2) = param(inst_params.vectors.pixel_y);
% end


%Wavelength
param(inst_params.vectors.wav) = hdf5read(fname,strcat(entryName,'/D33/selector/wavelength'));
param(inst_params.vectors.deltawav) = 0.1;
param(inst_params.vectors.sel_rpm) = hdf5read(fname,strcat(entryName,'/D33/selector/rotation_speed'));

%Chopper Parameters
param(inst_params.vectors.chopper1_phase) = hdf5read(fname,strcat(entryName,'/D33/chopper1/CH1_phase'));
param(inst_params.vectors.chopper1_speed) = hdf5read(fname,strcat(entryName,'/D33/chopper1/CH1_rotation_speed'));
param(inst_params.vectors.chopper2_phase) = hdf5read(fname,strcat(entryName,'/D33/chopper2/CH2_phase'));
param(inst_params.vectors.chopper2_speed) = hdf5read(fname,strcat(entryName,'/D33/chopper2/CH2_rotation_speed'));
param(inst_params.vectors.chopper3_phase) = hdf5read(fname,strcat(entryName,'/D33/chopper3/CH3_phase'));
param(inst_params.vectors.chopper3_speed) = hdf5read(fname,strcat(entryName,'/D33/chopper3/CH3_rotation_speed'));
param(inst_params.vectors.chopper4_phase) = hdf5read(fname,strcat(entryName,'/D33/chopper4/CH4_phase'));
param(inst_params.vectors.chopper4_speed) = hdf5read(fname,strcat(entryName,'/D33/chopper4/CH4_rotation_speed'));




%BeamStop
param(inst_params.vectors.bx) = hdf5read(fname,strcat(entryName,'/D33/beamstop/bx_actual'));
param(inst_params.vectors.by) = hdf5read(fname,strcat(entryName,'/D33/beamstop/by_actual'));

%Attenuator
param(inst_params.vectors.att_type) = hdf5read(fname,strcat(entryName,'/D33/attenuator/position'));
try param(inst_params.vectors.attr) = hdf5read(fname,strcat(entryName,'/D33/collimation/AttTr_actual_position')); catch end

%Trap for unknown attenuator status
if param(inst_params.vectors.att_type) == 99; param(inst_params.vectors.att_type) = 0;end
param(inst_params.vectors.att_status) = 1;
%%ChopperAttenuator2
%param(inst_params.vectors.att2) = hdf5read(fname,strcat(entryName,'/D33/attenuator2/actual_value'));

%Collimation
param(inst_params.vectors.col) = (hdf5read(fname,strcat(entryName,'/D33/collimation/actual_position'))); %m;

%Trap for unknown collimation status
if param(inst_params.vectors.col) >= 99; param(inst_params.vectors.col) = 12.8; end
%Collimation & Diaphragm Motors
try param(inst_params.vectors.dia1) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Dia1_actual_position'))); catch end%mm;
try param(inst_params.vectors.col1) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Coll1_actual_position'))); catch end%mm;
try param(inst_params.vectors.dia2) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Dia2_actual_position'))); catch end%mm;
try param(inst_params.vectors.col2) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Coll2_actual_position'))); catch end%mm;
try param(inst_params.vectors.dia3) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Dia3_actual_position'))); catch end%mm;
try param(inst_params.vectors.col3) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Coll3_actual_position'))); catch end%mm;
try param(inst_params.vectors.dia4) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Dia4_actual_position'))); catch end%mm;
try param(inst_params.vectors.col4) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Coll4_actual_position'))); catch end%mm;
try param(inst_params.vectors.dia5) = (hdf5read(fname,strcat(entryName,'/D33/collimation/Dia5_actual_position'))); catch end%mm;

%Polariser Position
try param(inst_params.vectors.potr) = hdf5read(fname,strcat(entryName,'/D33/collimation/PoTr_actual_position')); catch end

%Wavelength Filter Position
try param(inst_params.vectors.wvtr) = hdf5read(fname,strcat(entryName,'/D33/collimation/WvTr_actual_position')); catch end

%Reactor Power
param(inst_params.vectors.reactor_power) = hdf5read(fname,strcat(entryName,'/reactor_power')); %MW

% if strcmp(grasp_env.inst,'ILL_d22') 
%     %Patch effective collimation length if using entrance apertures at the attenuator position
%     if param(inst_params.vectors.att_type) > 3 && param(inst_params.vectors.att_type) < 8
%         if param(inst_params.vectors.att_status) == 1
%             disp(['Entrance Aperture in use:  Patching effective collimation length to ' num2str(inst_params.col(length(inst_params.col)))]);
%             param(inst_params.vectors.col) = inst_params.col(length(inst_params.col));
%             param(inst_params.vectors.col_app) = param(inst_params.vectors.att_type);
%         end
%     end
% end
% 
%Sample Motors
param(inst_params.vectors.san) = (hdf5read(fname,strcat(entryName,'/sample/san_actual'))); %m
param(inst_params.vectors.phi) = (hdf5read(fname,strcat(entryName,'/sample/phi_actual'))); %m
param(inst_params.vectors.sdi1) = (hdf5read(fname,strcat(entryName,'/sample/sdi1_actual'))); %m
param(inst_params.vectors.sdi2) = (hdf5read(fname,strcat(entryName,'/sample/sdi2_actual'))); %m
param(inst_params.vectors.trs) = (hdf5read(fname,strcat(entryName,'/sample/trs_actual'))); %m
param(inst_params.vectors.sht) = (hdf5read(fname,strcat(entryName,'/sample/sht_actual'))); %m
param(inst_params.vectors.str) = (hdf5read(fname,strcat(entryName,'/sample/str_actual'))); %m
param(inst_params.vectors.chpos) = (hdf5read(fname,strcat(entryName,'/sample/sample_changer_value')));%m
try; param(inst_params.vectors.omega) = (hdf5read(fname,strcat(entryName,'/sample/omega_actual')));catch; end %m
%param(inst_params.vectors.slit) = (hdf5read(fname,strcat(entryName,'/sample/slit_actual'))); %mm

%Sample environment
%Temperatures
try; param(inst_params.vectors.temp) = (hdf5read(fname,strcat(entryName,'/sample/temperature'))); catch; end
try; param(inst_params.vectors.treg) = (hdf5read(fname,strcat(entryName,'/sample/regulation_temperature'))); catch; end
try; param(inst_params.vectors.tset) = (hdf5read(fname,strcat(entryName,'/sample/setpoint_temperature'))); catch; end
% param(inst_params.vectors.bath1_temp) = (hdf5read(fname,strcat(entryName,'/sample/bath1_regulation_temperature')));
% param(inst_params.vectors.bath1_set) = (hdf5read(fname,strcat(entryName,'/sample/bath1_setpoint_temperature')));
% param(inst_params.vectors.bath2_temp) = (hdf5read(fname,strcat(entryName,'/sample/bath2_regulation_temperature')));
% param(inst_params.vectors.bath2_temp) = (hdf5read(fname,strcat(entryName,'/sample/bath2_setpoint_temperature')));
% param(inst_params.vectors.bath_switch) = (hdf5read(fname,strcat(entryName,'/sample/bath_selector_actual')));
% param(inst_params.vectors.air_temp) = (hdf5read(fname,strcat(entryName,'/sample/air_temperature')));
% param(inst_params.vectors.rack_temp) = (hdf5read(fname,strcat(entryName,'/sample/rack_temperature'))); 

%Magnet
try param(inst_params.vectors.field) = (hdf5read(fname,strcat(entryName,'/sample/field_actual'))); catch; end
%Shear
%param(inst_params.vectors.shear_rate) = (hdf5read(fname,strcat(entryName,'/sample/shearrate_actual')));


%***** Read Detector Data, Monitor and Time Slices *****

%***** Determine Measurement Mode, Single, Kinetic or TOF *****
mode = hdf5read(fname,strcat(entryName,'/mode'));
disp(mode);
if mode == 0; numor_data.file_type = 'single frame';
elseif mode == 1; %tof - arranged differently to D22
%elseif mode == 4;
    numor_data.file_type = 'tof';
    %read tof parameters
    tof_params = hdf5read(fname,strcat(entryName,'/monitor1/time_of_flight'));
    param(inst_params.vectors.tof_width) = tof_params(1); %microS
    param(inst_params.vectors.tof_channels) = tof_params(2); %microS
    param(inst_params.vectors.tof_delay) = tof_params(3); %microS
    param(inst_params.vectors.pickups) = hdf5read(fname,strcat(entryName,'/monitor1/nbpickup'));
elseif mode == 3;
    numor_data.file_type = 'kinetic';
    %read time slices
    slices= hdf5read(fname,strcat(entryName,'/slices'));
    frame_time = slices(1)/2;
    param(inst_params.vectors.pickups) = hdf5read(fname,strcat(entryName,'/nbrepaint'));
else
    numor_data.file_type = 'unknown';
end
disp(['File type is ' numor_data.file_type ', mode = ' num2str(mode)]);



for det = 1:inst_params.detectors
    disp(['Reading Detector #' num2str(det) ' Data']);
    %Detector Data - all frames
    numor_data.(['data' num2str(det)]) = [];
    if status_flags.fname_extension.raw_tube_data_load ==0; %load pre-calibrated data
        data = double(hdf5read(fname,strcat(entryName,['/data' num2str(det) '/data' num2str(det)])));
    elseif status_flags.fname_extension.raw_tube_data_load ==1; %load raw tube data
            data = double(hdf5read(fname,strcat(entryName,['/data_raw' num2str(det) '/data_raw' num2str(det)])));
    end
    temp_data_size = size(data);
    
    if strcmp(numor_data.file_type,'kinetic');
        data = reshape(data,temp_data_size(1),temp_data_size(3),temp_data_size(4));
        data_size = size(data);
        %if length(data_size) <3; data_size(3) =1; end
        numor_data.n_frames = data_size(1);
    elseif strcmp(numor_data.file_type,'tof');
        data = reshape(data,temp_data_size(1),temp_data_size(2),temp_data_size(3));
        data_size = size(data);
        %if length(data_size) <3; data_size(3) =1; end
        numor_data.n_frames = data_size(1);
    else 
        %Standard acquisition
        data = reshape(data,temp_data_size(3),temp_data_size(2),temp_data_size(1));
        data_size = size(data);
        if length(data_size) <3; data_size(3) =1; end
        numor_data.n_frames = data_size(3);
    end
    
        
    disp(['Number of Frames = ' num2str(numor_data.n_frames)]);
    disp('Using SQRT(I) errors')
    
    %Read Monitor Data - all frames
    monitor = hdf5read(fname,strcat(entryName,'/monitor1/data'));
    
    %***** Loop though the frames and organize the data array as Grasp likes it *****
    numor_data.(['data' num2str(det)]) = [];
    numor_data.(['error' num2str(det)]) = [];
    for n = 1:numor_data.n_frames
        %monitor
        %time & frame_time
        if strcmp(numor_data.file_type,'kinetic');
            param(inst_params.vectors.monitor) = monitor(1);
            frame_data = reshape(data(n,:,:),data_size(2),data_size(3)); %data frame
            numor_data.(['data' num2str(det)])(:,:,n) = frame_data; %data frame
            frame_error = sqrt(frame_data); %errors
            numor_data.(['error' num2str(det)])(:,:,n) = frame_error; %erros
            param(inst_params.vectors.time) = slices(n); %In kin mode slices has already been multiplied by n pickups in nomad
            param(inst_params.vectors.frame_time) = frame_time;
            frame_time = frame_time + slices(n)/param(inst_params.vectors.pickups); %ready for next time round the loop, %In kin mode slices has already been multiplied by n pickups in nomad
            param(inst_params.vectors.slice_time) = slices(n)/param(inst_params.vectors.pickups); %In kin mode slices has already been multiplied by n pickups in nomad
        elseif strcmp(numor_data.file_type,'tof');
            param(inst_params.vectors.monitor) = monitor(n);
            frame_data = reshape(data(n,:,:),data_size(2),data_size(3)); %data frame
            numor_data.(['data' num2str(det)])(:,:,n) = frame_data; %data frame
            frame_error = sqrt(frame_data); %errors
            numor_data.(['error' num2str(det)])(:,:,n) = frame_error; %erros
            param(inst_params.vectors.time) = param(inst_params.vectors.tof_width) * param(inst_params.vectors.pickups) / 1e6; %microS to S
            frame_time = param(inst_params.vectors.tof_delay) + param(inst_params.vectors.tof_width) * (n-1) + param(inst_params.vectors.tof_width)/2;
            frame_time = frame_time + status_flags.normalization.d33_tof_delay;
            %frame_time = param(inst_params.vectors.tof_width) * (n-1) + param(inst_params.vectors.tof_width)/2;
            frame_time = frame_time/1e6;
            param(inst_params.vectors.frame_time) = frame_time;
            param(inst_params.vectors.slice_time) = param(inst_params.vectors.tof_width)/1e6;
            
            tof_dist = status_flags.normalization.d33_total_tof_dist;
                        h = 6.626076*(10^-34); %Plank's Constant
            m_n = 1.674929*(10^-27); %Neutron Rest Mass
            lambda = h / (m_n*(tof_dist/frame_time));
            lambda = lambda/(10^-10); %Convert m to Angstroms
            param(inst_params.vectors.wav) = lambda;
            
        else %single or other
            param(inst_params.vectors.monitor) = monitor(n);
            frame_data = reshape(data(:,:,n),data_size(2),data_size(1)); %data frame
            numor_data.(['data' num2str(det)])(:,:,n) = frame_data; %data frame
            frame_error = sqrt(frame_data); %errors
            numor_data.(['error' num2str(det)])(:,:,n) = frame_error; %erros
            param(inst_params.vectors.time) = param(inst_params.vectors.aq_time)/numor_data.n_frames;
            param(inst_params.vectors.slice_time) = param(inst_params.vectors.time);
        end
        %frame total counts
        param(inst_params.vectors.array_counts) = sum(sum(frame_data)); %Total Detector counts - all frames
        
        
        %Frame Parameters
        numor_data.(['params' num2str(det)])(:,n) = param;
    end
end

