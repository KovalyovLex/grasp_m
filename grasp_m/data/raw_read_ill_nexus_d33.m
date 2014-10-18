function numor_data = raw_read_ill_nexus_d33(fname,numor)

global inst_params
global status_flags
global grasp_env

if strcmp(grasp_env.inst,'ILL_d22'); inst_str = 'D22';
elseif strcmp(grasp_env.inst,'ILL_d33'); inst_str = 'D33';
elseif strcmp(grasp_env.inst,'APEX'); inst_str = 'D33';
else strcmp(grasp_env.inst,'ILL_d11'); inst_str = 'D11';
    
end



param = zeros(128,1); %Empty Parameters array of 128, as Grasp expects.

%Read ILL SANS Nexus Format Data (HDF)
warning on
fileinfo=hdf5info(fname);
entryName =  fileinfo.GroupHierarchy.Groups(1).Name; %Root folder in HDF fileed


%***** Read User, Sample and Environment Parameters *****

%Numor
param(inst_params.vectors.numor) = hdf5read(fname,strcat(entryName,'/run_number'));; %Usually stored as param 128

%User Information
try
    temp1 = hdf5read(fname,strcat(entryName,'/user/name'));
    numor_data.info.user = temp1.Data;
catch
    numor_data.info.user = 'No Name';
end

% Date and time from start_time
try
    temp1 = hdf5read(fname,strcat(entryName,'/start_time'));
    numor_data.info.start_date = temp1.Data(1:10);
    numor_data.info.start_time = temp1.Data(11:18);
catch
    numor_data.info.start_date = [];
    numor_data.info.start_time = [];
end

try
    temp1 = hdf5read(fname,strcat(entryName,'/end_time'));
    numor_data.info.end_date = temp1.Data(1:10);
    numor_data.info.end_time = temp1.Data(11:18);
catch
    numor_data.info.end_date = [];
    numor_data.info.end_time = [];
end

    
%Acquisition Time
try; param(inst_params.vectors.aq_time) = hdf5read(fname,strcat(entryName,'/duration')); %Seconds
catch; param(inst_params.vectors.aq_time) =1; end

%Subtitle
try
    temp1 = hdf5read(fname,strcat(entryName,'/sample_description'));
    len = length(temp1.Data);
    if len<=80
        numor_data.subtitle = temp1.Data(1:len);
    elseif len>80
        numor_data.subtitle = strcat(temp1.Data(1:77),'...');
    end
catch
    numor_data.subtitle = 'No Subtitle';
end

%***** Read Instrument configuration & Measurement parameters ******

%Detector Distance & Motors

%Det 1 (Panel Detector)
try param(inst_params.vectors.det1) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/det1_actual'])));end %m
try param(inst_params.vectors.detcalc1) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/det1_calc'])));end %m
try param(inst_params.vectors.det1_panel_offset) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/det1_panel_separation']))); end
try param(inst_params.vectors.oxl) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/OxL_actual']))); end
try param(inst_params.vectors.oxr) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/OxR_actual']))); end
try param(inst_params.vectors.oyt) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/OyT_actual']))); end
try param(inst_params.vectors.oyb) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/OyB_actual']))); end

%Det 2 (Rear Detector)
try param(inst_params.vectors.det2) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/det2_actual'])));
catch
    %Alternative name for det2
    try; param(inst_params.vectors.det) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/det_actual']))); catch; end %m
end

try param(inst_params.vectors.detcalc2) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/det2_calc'])));
catch
    %Alternative name for det2
    try; param(inst_params.vectors.detcalc) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/det_calc']))); catch; param(inst_params.vectors.detcalc) = param(inst_params.vectors.det); end %m
end
try; param(inst_params.vectors.dtr) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/dtr_actual']))); catch; end %m
try; param(inst_params.vectors.dan) = (hdf5read(fname,strcat(entryName,['/' inst_str '/detector/dan_actual']))); catch; end%m





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
param(inst_params.vectors.wav) = hdf5read(fname,strcat(entryName,['/' inst_str '/selector/wavelength']));

try;
    param(inst_params.vectors.deltawav) = hdf5read(fname,strcat(entryName,['/' inst_str '/selector/wavelength_res']));
    param(inst_params.vectors.deltawav) = param(inst_params.vectors.deltawav)/100; %fractional
catch
    disp('Wavelength resolution is not in data file: using default 0.1');
    param(inst_params.vectors.deltawav) = 0.1;
end

try; param(inst_params.vectors.sel_rpm) = hdf5read(fname,strcat(entryName,['/' inst_str '/selector/rotation_speed'])); catch; end
try; param(inst_params.vectors.seltrs) = hdf5read(fname,strcat(entryName,['/' inst_str '/selector/seltrs_actual'])); catch; end


%Chopper Parameters
try; param(inst_params.vectors.chopper1_phase) = hdf5read(fname,strcat(entryName,['/' inst_str '/chopper1/phase'])); catch; end
try; param(inst_params.vectors.chopper1_speed) = hdf5read(fname,strcat(entryName,['/' inst_str '/chopper1/rotation_speed'])); catch; end
try; param(inst_params.vectors.chopper2_phase) = hdf5read(fname,strcat(entryName,['/' inst_str '/chopper2/phase'])); catch; end
try; param(inst_params.vectors.chopper2_speed) = hdf5read(fname,strcat(entryName,['/' inst_str '/chopper2/rotation_speed'])); catch; end
try; param(inst_params.vectors.chopper3_phase) = hdf5read(fname,strcat(entryName,['/' inst_str '/chopper3/phase'])); catch; end
try; param(inst_params.vectors.chopper3_speed) = hdf5read(fname,strcat(entryName,['/' inst_str '/chopper3/rotation_speed'])); catch; end
try; param(inst_params.vectors.chopper4_phase) = hdf5read(fname,strcat(entryName,['/' inst_str '/chopper4/phase'])); catch; end
try; param(inst_params.vectors.chopper4_speed) = hdf5read(fname,strcat(entryName,['/' inst_str '/chopper4/rotation_speed'])); catch; end

tof_dist = []; %Tof distances for detectors 1-5
try; tof_dist(1) = hdf5read(fname,strcat(entryName,['/' inst_str '/tof/tof_distance_detector1'])); catch; end
try; tof_dist(2) = hdf5read(fname,strcat(entryName,['/' inst_str '/tof/tof_distance_detector2'])); catch; end
try; tof_dist(3) = hdf5read(fname,strcat(entryName,['/' inst_str '/tof/tof_distance_detector3'])); catch; end
try; tof_dist(4) = hdf5read(fname,strcat(entryName,['/' inst_str '/tof/tof_distance_detector4'])); catch; end
try; tof_dist(5) = hdf5read(fname,strcat(entryName,['/' inst_str '/tof/tof_distance_detector5'])); catch; end
try; master_spacing = hdf5read(fname,strcat(entryName,['/' inst_str '/tof/tof_master_pair_separation'])); catch; end


%BeamStop
try; param(inst_params.vectors.bx) = hdf5read(fname,strcat(entryName,['/' inst_str '/beamstop/bx_actual'])); catch; end
try; param(inst_params.vectors.by) = hdf5read(fname,strcat(entryName,['/' inst_str '/beamstop/by_actual'])); catch; end

%Attenuator
try; param(inst_params.vectors.att_type) = hdf5read(fname,strcat(entryName,['/' inst_str '/attenuator/position'])); catch; end
try param(inst_params.vectors.attr) = hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/AttTr_actual_position'])); catch end
%ChopperAttenuator2
try
    param(inst_params.vectors.att2) = hdf5read(fname,strcat(entryName,['/' inst_str '/attenuator2/actual_value'])); %Absolute attenuation value - not index
catch
    param(inst_params.vectors.att2) = 1;
end


%Trap for unknown attenuator status
if param(inst_params.vectors.att_type) == 99; param(inst_params.vectors.att_type) = 0;end
param(inst_params.vectors.att_status) = 1;
%%ChopperAttenuator2
%param(inst_params.vectors.att2) = hdf5read(fname,strcat(entryName,['/' inst_str '/attenuator2/actual_value']));

%Collimation
param(inst_params.vectors.col) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/actual_position']))); %m;
try
    temp = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/ap_size']))); %m;
    if max(size(temp)) == 2;
        param(inst_params.vectors.col_app) = 0;
    elseif max(size(temp)) == 1;
        param(inst_params.vectors.col_app) = 1;
    end
catch; end

%PATCH for D33 Source diaphragms
if strcmp(grasp_env.inst,'ILL_d33');
    try
        temp = double((hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/ap_size']))))/1000;%m
        param(inst_params.vectors.source_ap_x) = temp(1);
        param(inst_params.vectors.source_ap_y) = temp(2);
    catch
        param(inst_params.vectors.source_ap_x) = inst_params.guide_size(1);
        param(inst_params.vectors.source_ap_y) = inst_params.guide_size(2);
    end
    
    
end


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


%D22 slits
try; param(inst_params.vectors.vslit_center) = hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/vertical_slit_center'])); catch; end
try; param(inst_params.vectors.vslit_width) = hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/vertical_slit_width_actual'])); catch; end
try; param(inst_params.vectors.hslit_center) = hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/horizontal_slit_center'])); catch; end
try; param(inst_params.vectors.hslit_width) = hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/horizontal_slit_width_actual'])); catch; end


%Trap for unknown collimation status
if param(inst_params.vectors.col) >= 99; param(inst_params.vectors.col) = 12.8; end
%Collimation & Diaphragm Motors
try param(inst_params.vectors.dia1) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Dia1_actual_position']))); catch end%mm;
try param(inst_params.vectors.col1) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Coll1_actual_position']))); catch end%mm;
try param(inst_params.vectors.dia2) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Dia2_actual_position']))); catch end%mm;
try param(inst_params.vectors.col2) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Coll2_actual_position']))); catch end%mm;
try param(inst_params.vectors.dia3) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Dia3_actual_position']))); catch end%mm;
try param(inst_params.vectors.col3) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Coll3_actual_position']))); catch end%mm;
try param(inst_params.vectors.dia4) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Dia4_actual_position']))); catch end%mm;
try param(inst_params.vectors.col4) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Coll4_actual_position']))); catch end%mm;
try param(inst_params.vectors.dia5) = (hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/Dia5_actual_position']))); catch end%mm;

%Polariser Position
try param(inst_params.vectors.potr) = hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/PoTr_actual_position'])); catch end

%Flipper Status
try param(inst_params.vectors.flipper_rfcurrent) = hdf5read(fname,strcat(entryName,['/sample/psflipper_rf_actual_current'])); catch end
try param(inst_params.vectors.flipper_rfvoltage) = hdf5read(fname,strcat(entryName,['/sample/psflipper_rf_actual_voltage'])); catch end
try param(inst_params.vectors.flipper_fieldvoltage) = hdf5read(fname,strcat(entryName,['/sample/psflipper_field_actual_current'])); catch end
try param(inst_params.vectors.flipper_fieldvoltage) = hdf5read(fname,strcat(entryName,['/sample/psflipper_field_actual_voltage'])); catch end

%Wavelength Filter Position
try param(inst_params.vectors.wvtr) = hdf5read(fname,strcat(entryName,['/' inst_str '/collimation/WvTr_actual_position'])); catch end

%Reactor Power
try; param(inst_params.vectors.reactor_power) = hdf5read(fname,strcat(entryName,'/reactor_power')); catch; end%MW

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
try; param(inst_params.vectors.san) = (hdf5read(fname,strcat(entryName,'/sample/san_actual'))); catch; end%m
try; param(inst_params.vectors.phi) = (hdf5read(fname,strcat(entryName,'/sample/phi_actual'))); catch; end%m
try; param(inst_params.vectors.sdi1) = (hdf5read(fname,strcat(entryName,'/sample/sdi1_actual'))); catch; end%m
try; param(inst_params.vectors.sdi) = (hdf5read(fname,strcat(entryName,'/sample/sdi_actual'))); catch; end%m
try; param(inst_params.vectors.sdi2) = (hdf5read(fname,strcat(entryName,'/sample/sdi2_actual'))); catch; end%m
try; param(inst_params.vectors.trs) = (hdf5read(fname,strcat(entryName,'/sample/trs_actual'))); catch; end%m
try; param(inst_params.vectors.sht) = (hdf5read(fname,strcat(entryName,'/sample/sht_actual'))); catch; end%m
try; param(inst_params.vectors.str) = (hdf5read(fname,strcat(entryName,'/sample/str_actual'))); catch; end%m
try; param(inst_params.vectors.chpos) = (hdf5read(fname,strcat(entryName,'/sample/sample_changer_value'))); catch; end%m
try; param(inst_params.vectors.omega) = (hdf5read(fname,strcat(entryName,'/sample/omega_actual')));catch; end %m
%param(inst_params.vectors.slit) = (hdf5read(fname,strcat(entryName,'/sample/slit_actual'))); catch; end%m %mm

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
try; param(inst_params.vectors.rack_temp) = (hdf5read(fname,strcat(entryName,'/sample/rack_temperature'))); catch; end

%Power Supplies  -  D22 names
try; param(inst_params.vectors.ps1_i) = (hdf5read(fname,strcat(entryName,'/sample/ps1_current'))); catch; end
try; param(inst_params.vectors.ps1_v) = (hdf5read(fname,strcat(entryName,'/sample/ps1_voltage'))); catch; end
try; param(inst_params.vectors.ps2_i) = (hdf5read(fname,strcat(entryName,'/sample/ps2_current'))); catch; end
try; param(inst_params.vectors.ps2_v) = (hdf5read(fname,strcat(entryName,'/sample/ps2_voltage'))); catch; end
try; param(inst_params.vectors.ps3_i) = (hdf5read(fname,strcat(entryName,'/sample/ps3_current'))); catch; end
try; param(inst_params.vectors.ps3_v) = (hdf5read(fname,strcat(entryName,'/sample/ps3_voltage'))); catch; end

%Power Supplies  -  D33 names
try; param(inst_params.vectors.ps1_i) = (hdf5read(fname,strcat(entryName,'/sample/pselectromag_actual_current'))); catch; end
try; param(inst_params.vectors.ps1_v) = (hdf5read(fname,strcat(entryName,'/sample/pselectromag_actual_voltage'))); catch; end
try; param(inst_params.vectors.ps2_i) = (hdf5read(fname,strcat(entryName,'/sample/psflipper_field_actual_current'))); catch; end
try; param(inst_params.vectors.ps2_v) = (hdf5read(fname,strcat(entryName,'/sample/psflipper_field_actual_voltage'))); catch; end
try; param(inst_params.vectors.ps3_i) = (hdf5read(fname,strcat(entryName,'/sample/psflipper_rf_actual_current'))); catch; end
try; param(inst_params.vectors.ps3_v) = (hdf5read(fname,strcat(entryName,'/sample/psflipper_rf_actual_voltage'))); catch; end



%Magnet
try param(inst_params.vectors.field) = (hdf5read(fname,strcat(entryName,'/sample/field_actual'))); catch; end
%Shear
try; param(inst_params.vectors.shear_rate) = (hdf5read(fname,strcat(entryName,'/sample/shearrate_actual'))); catch; end


%***** Read Detector Data, Monitor and Time Slices *****
%***** Determine Measurement Mode, Single, Kinetic or TOF *****
try; mode = hdf5read(fname,strcat(entryName,'/mode')); catch; mode = 0; end
if mode == 0;
    numor_data.file_type = 'single frame';
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
elseif mode ==4; %inelastic tof (OLD D22 TOF Format < May 2013)
    numor_data.file_type = 'tof_inelastic';
    %read tof parameters
    tof_params = hdf5read(fname,strcat(entryName,'/monitor1/time_of_flight'));
    param(inst_params.vectors.tof_width) = tof_params(1); %microS
    param(inst_params.vectors.tof_channels) = tof_params(2); %microS
    param(inst_params.vectors.tof_delay) = tof_params(3); %microS
    param(inst_params.vectors.pickups) = hdf5read(fname,strcat(entryName,'/monitor1/nbpickup'));
    
else
    numor_data.file_type = 'unknown';
end
disp(['File type is ' numor_data.file_type ', mode = ' num2str(mode)]);

inst_params.detectors


for det = 1:inst_params.detectors
    disp(['Reading Detector #' num2str(det) ' Data']);
    %Detector Data - all frames
    numor_data.(['data' num2str(det)]) = [];
    if status_flags.fname_extension.raw_tube_data_load ==0; %load pre-calibrated data
        if strcmp(grasp_env.inst,'ILL_d22');
            data = double(hdf5read(fname,strcat(entryName,['/data/data'])));
        elseif strcmp(grasp_env.inst,'ILL_d11');
            data = double(hdf5read(fname,strcat(entryName,['/' inst_str '/detector/data'])));
            disp(['D11 data size is : ' num2str(size(data))]);
            
            %Charles' version
%             if numel(data) == 128*128; %16384
%                 disp('Upscaling 128x128 data to 256x256')
%                 %Software over sample data up to 256x256
%                 new_data = zeros(1,256,256);
%                 for n = 1:128
%                     for m = 1:128
%                         new_data(1,(n*2-1),(m*2-1)) = data(1,n,m)/4;
%                         new_data(1,(n*2),(m*2-1)) = data(1,n,m)/4;
%                         new_data(1,(n*2),(m*2)) = data(1,n,m)/4;
%                         new_data(1,(n*2-1),(m*2)) = data(1,n,m)/4;
%                     end
%                 end
%                 data = new_data;
%            end
            
            %Dirk's version
                        if size(data,2) == 128 && size(data,3) == 128;
                            disp(['Upscaling to 256 x 256 Pixels'])
                            data =  data(:,repmat(1:end,[2 1]),repmat(1:end,[2 1]));
                            data = data/4;
                        end
            
            
        else
            try
                data = double(hdf5read(fname,strcat(entryName,['/data' num2str(det) '/data' num2str(det)])));
            catch
                data = double(hdf5read(fname,strcat(entryName,['/data' num2str(det) '/MultiDetector' num2str(det) '_linear_data'])));
            end
        end
        
    elseif status_flags.fname_extension.raw_tube_data_load ==1; %load raw tube data
        if strcmp(grasp_env.inst,'ILL_d22');
            data = double(hdf5read(fname,strcat(entryName,['/data_raw/data_raw'])));
        else
            try
                data = double(hdf5read(fname,strcat(entryName,['/data_raw' num2str(det) '/data_raw' num2str(det)])));
            catch
                data = double(hdf5read(fname,strcat(entryName,['/data_raw' num2str(det) '/MultiDetector' num2str(det) '_data'])));
            end
        end
    end
    temp_data_size = size(data);
    
    
    if strcmp(numor_data.file_type,'kinetic');
        if length(temp_data_size) == 4;
            data = reshape(data,temp_data_size(1),temp_data_size(3),temp_data_size(4));
        else
            data = reshape(data,temp_data_size(1),temp_data_size(2),temp_data_size(3));
        end
        
        %data = reshape(data,temp_data_size(1),temp_data_size(2),temp_data_size(3));
        data_size = size(data);
        %if length(data_size) <3; data_size(3) =1; end
        numor_data.n_frames = data_size(1);
    elseif strcmp(numor_data.file_type,'tof');
        data = reshape(data,temp_data_size(1),temp_data_size(2),temp_data_size(3));
        data_size = size(data);
        %if length(data_size) <3; data_size(3) =1; end
        numor_data.n_frames = data_size(1);
        
        %read tof wavelengths
        try;
            tof_wavs =  hdf5read(fname,strcat(entryName,['/' inst_str '/tof/tof_wavelength_detector' num2str(det)]));
            tof_res = ones(numor_data.n_frames)*master_spacing/tof_dist(det);
        catch
            disp('TOF with no wavelength / time channel in data file');
            disp('Patching Monochromatic Wavelength & Resolution for each time frame');
            tof_wavs = ones(numor_data.n_frames)* param(inst_params.vectors.wav);
            tof_res = ones(numor_data.n_frames)* param(inst_params.vectors.deltawav);
        end
        
        
        
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
    try; monitor = hdf5read(fname,strcat(entryName,'/monitor1/data')); catch; monitor = 1; end
    
    %***** Loop though the frames and organize the data array as Grasp likes it *****
    numor_data.(['data' num2str(det)]) = [];
    numor_data.(['error' num2str(det)]) = [];
    for n = 1:numor_data.n_frames
        %monitor
        %time & frame_time
        if strcmp(numor_data.file_type,'kinetic');
            param(inst_params.vectors.monitor) = monitor(n);
            frame_data = reshape(data(n,:,:),data_size(2),data_size(3)); %data frame
            if strcmp(grasp_env.inst,'ILL_d22'); frame_data = rot90(frame_data); frame_data = flipud(frame_data); end
            numor_data.(['data' num2str(det)])(:,:,n) = frame_data; %data frame
            frame_error = sqrt(frame_data); %errors
            numor_data.(['error' num2str(det)])(:,:,n) = frame_error; %erros
            param(inst_params.vectors.time) = slices(n) * param(inst_params.vectors.pickups);
            param(inst_params.vectors.frame_time) = frame_time;
            %frame_time = frame_time + slices(n)/param(inst_params.vectors.pickups); %ready for next time round the loop, %In kin mode slices has already been multiplied by n pickups in nomad
            frame_time = frame_time + slices(n);
            %param(inst_params.vectors.slice_time) = slices(n)/param(inst_params.vectors.pickups); %In kin mode slices has already been multiplied by n pickups in nomad
            param(inst_params.vectors.slice_time) = slices(n);
            
        elseif strcmp(numor_data.file_type,'tof');
            param(inst_params.vectors.monitor) = monitor(n);
            frame_data = reshape(data(n,:,:),data_size(2),data_size(3)); %data frame
            if strcmp(grasp_env.inst,'ILL_d22'); frame_data = rot90(frame_data); frame_data = flipud(frame_data); end
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
            
            %tof_dist = status_flags.normalization.d33_total_tof_dist;
            %            h = 6.626076*(10^-34); %Plank's Constant
            %m_n = 1.674929*(10^-27); %Neutron Rest Mass
            %lambda = h / (m_n*(tof_dist/frame_time));
            %lambda = lambda/(10^-10); %Convert m to Angstroms
            %param(inst_params.vectors.wav) = lambda;
            param(inst_params.vectors.wav) = tof_wavs(n);
            param(inst_params.vectors.deltawav) = tof_res(n);
            
        elseif strcmp(numor_data.file_type,'tof_inelastic');
            param(inst_params.vectors.monitor) = monitor(n);
            frame_data = reshape(data(:,:,n),data_size(1),data_size(2)); %data frame
            
            if strcmp(grasp_env.inst,'ILL_d22'); frame_data = rot90(frame_data);  frame_data = flipud(frame_data); end
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
            
            
            
        else %single or other
            param(inst_params.vectors.monitor) = monitor(n);
            frame_data = reshape(data(:,:,n),data_size(2),data_size(1)); %data frame
            if strcmp(grasp_env.inst,'ILL_d22')||strcmp(grasp_env.inst,'ILL_d11'); frame_data = rot90(frame_data);  frame_data = flipud(frame_data); end
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

if inst_params.detectors >1; %i.e. D33 multiple detector banks
    
    if strcmp(numor_data.file_type,'tof');
        
        %     for det = 2:5;
        %         disp(' ')
        %         disp('Time shifting panel data to match rear detector');
        %
        %         new_det = zeros(size(numor_data.(['data' num2str(det)])));
        %         temp = size(numor_data.(['data' num2str(det)]));
        %         old_wavs = numor_data.(['params' num2str(det)])(inst_params.vectors.wav,:);
        %         new_wavs = numor_data.params1(inst_params.vectors.wav,:);  %read detector wav bins
        %
        %         divider = max(old_wavs)/max(new_wavs)
        %
        %         for n = 1:temp(1);
        %             for m = 1:temp(2);
        %                 idata(1,:) = numor_data.(['data' num2str(det)])(n,m,:);
        %                 new_det(n,m,:) = interp1(old_wavs,idata,new_wavs);
        %             end
        %         end
        %         new_det = new_det / divider;
        %         new_error = sqrt(new_det);
        %
        %         size(new_det)
        %         numor_data.(['data' num2str(det)]) = new_det;
        %         numor_data.(['error' num2str(det)]) = new_error;
        %         numor_data.(['params' num2str(det)])(inst_params.vectors.wav,:) = new_wavs;
        %
        %     end
        
        disp(' ');
        
        for det = 2:5;
            disp(['Time shifting panel #' num2str(det) ' data to match rear detector']);
            
            %Old Panel Wavs
            old_wavs = numor_data.(['params' num2str(det)])(inst_params.vectors.wav,:);
            old_wav_edges = [0, cumsum(diff(old_wavs))];
            temp = diff(old_wavs); temp2 = cumsum(temp);
            old_wav_edges = [0, temp2, temp2(length(temp2))+temp(length(temp))];
            
            %New Panel Wavs to match the rear detector
            new_wavs = numor_data.params1(inst_params.vectors.wav,:);  %read detector wav bins
            temp = diff(new_wavs); temp2 = cumsum(temp);
            new_wav_edges = [0, temp2, temp2(length(temp2))+temp(length(temp))];
            
            new_det = zeros(size(numor_data.(['data' num2str(det)])));
            new_det_error = zeros(size(numor_data.(['data' num2str(det)])));
            old_det = numor_data.(['data' num2str(det)]);
            old_det_error = numor_data.(['error' num2str(det)]);
            
            for n = 1:length(new_wavs);
                %new_wav_edges(n)
                %new_wav_edges(n+1)
                
                
                a = find(old_wav_edges <= new_wav_edges(n));
                a = a(length(a));
                
                b = find(old_wav_edges > new_wav_edges(n));
                b = b(1);
                
                c = find(old_wav_edges <= new_wav_edges(n+1));
                c = c(length(c));
                
                d = find(old_wav_edges > new_wav_edges(n+1));
                d = d(1);
                
                fraction1 = (old_wav_edges(b)-new_wav_edges(n)) / (old_wav_edges(b)-old_wav_edges(a));
                fraction2 = (new_wav_edges(n+1)-old_wav_edges(c)) / (old_wav_edges(d) - old_wav_edges(c));
                
                if c ==a;
                    new_det(:,:,n) = old_det(:,:,a)*fraction2;
                    new_det_error(:,:,n) = old_det_error(:,:,a)*fraction2;
                    
                else
                    new_det(:,:,n) = old_det(:,:,a)*fraction1 + old_det(:,:,b)*fraction2;
                    new_det_error(:,:,n) = sqrt((old_det_error(:,:,a)*fraction1).^2 + (old_det_error(:,:,b)*fraction2).^2);
                end
            end
            
            numor_data.(['data' num2str(det)]) = new_det;
            numor_data.(['error' num2str(det)]) = new_det_error;
            numor_data.(['params' num2str(det)])(inst_params.vectors.wav,:) = new_wavs;
        end
        
    end
end


