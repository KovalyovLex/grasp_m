function ill_nexus_write_d33(directory,numor,data)



%numor is numeric:  Pad with zeros to correct length
numor_str = num2str(numor);
a = length(numor_str);
if a ==1; addzeros = '00000';
elseif a==2; addzeros = '0000';
elseif a==3; addzeros = '000';
elseif a==4; addzeros = '00';
elseif a==5; addzeros = '0';
elseif a==6; addzeros = ''; end
numor_str = [addzeros numor_str];
numor = str2num(numor_str);

%File Name
fname = fullfile(directory,[numor_str '.nxs']);

disp(['Writing NEXUS data to: ' fname]);

%Run Number
h5create(fname,['/entry0/run_number'],[1]);
h5write(fname, ['/entry0/run_number'], data.numor);

%Measurement time
h5create(fname,['/entry0/duration'],[1]);
h5write(fname, ['/entry0/duration'], data.time);

%Monitor (same as time)
h5create(fname,['/entry0/monitor1/data'],[1]);
h5write(fname, ['/entry0/monitor1/data'], data.monitor);


%Write Detector Data
for det = 1:data.detectors
    
    det_data = data.(['data' num2str(det)]);
    data_size = size(det_data);

    det_data = reshape(det_data,[1, data_size]);

    
    h5create(fname,['/entry0/data' num2str(det) '/data' num2str(det)],[1, data_size]);
    %h5disp(fname);
    h5write(fname, ['/entry0/data' num2str(det) '/data' num2str(det)], det_data);
end

%Attenuator
if isfield(data,'att');
    h5create(fname,['/entry0/D33/attenuator/position'],[1]);
    h5write(fname, ['/entry0/D33/attenuator/position'], data.att);
end
    
%Wavelength
h5create(fname,['/entry0/D33/selector/wavelength'],[1]);
h5write(fname, ['/entry0/D33/selector/wavelength'], data.wav);
h5create(fname,['/entry0/D33/selector/wavelength_res'],[1]);
h5write(fname, ['/entry0/D33/selector/wavelength_res'], data.dwav);

%Col
h5create(fname,['/entry0/D33/collimation/actual_position'],[1]);
h5write(fname, ['/entry0/D33/collimation/actual_position'], data.col);

%Source Size
h5create(fname,['/entry0/D33/collimation/ap_size'],[2]);
h5write(fname, ['/entry0/D33/collimation/ap_size'], [data.source_x, data.source_y]);


%San & Phi
if isfield(data,'san');
    h5create(fname,['/entry0/sample/san_actual'],[1]);
    h5write(fname, ['/entry0/sample/san_actual'], data.san);
end
if isfield(data,'phi')
    h5create(fname,['/entry0/sample/phi_actual'],[1]);
    h5write(fname, ['/entry0/sample/phi_actual'], data.phi);
end


%Det2
if isfield(data,'det2')
h5create(fname,['/entry0/D33/detector/det2_actual'],[1]);
h5write(fname, ['/entry0/D33/detector/det2_actual'], data.det2);
h5create(fname,['/entry0/D33/detector/det2_calc'],[1]);
h5write(fname, ['/entry0/D33/detector/det2_calc'], data.det2_calc);
end

%Det1
if isfield(data,'det1')
h5create(fname,['/entry0/D33/detector/det1_actual'],[1]);
h5write(fname, ['/entry0/D33/detector/det1_actual'], data.det1);
h5create(fname,['/entry0/D33/detector/det1_calc'],[1]);
h5write(fname, ['/entry0/D33/detector/det1_calc'], data.det1_calc);

if isfield(data,'det1_panel_separation') %i.e. D33 panels.
h5create(fname,['/entry0/D33/detector/det1_panel_separation'],[1]);
h5write(fname, ['/entry0/D33/detector/det1_panel_separation'], data.det1_panel_separation);
h5create(fname,['/entry0/D33/detector/OxL_actual'],[1]);
h5write(fname, ['/entry0/D33/detector/OxL_actual'], data.oxl);
h5create(fname,['/entry0/D33/detector/OxR_actual'],[1]);
h5write(fname, ['/entry0/D33/detector/OxR_actual'], data.oxr);
h5create(fname,['/entry0/D33/detector/OyT_actual'],[1]);
h5write(fname, ['/entry0/D33/detector/OyT_actual'], data.oyt);
h5create(fname,['/entry0/D33/detector/OyB_actual'],[1]);
h5write(fname, ['/entry0/D33/detector/OyB_actual'], data.oyb);
end
end

