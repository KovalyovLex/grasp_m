function grasp_2d_nexus_write(directory,numor)

global grasp_env
global displayimage
global inst_params

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

%Check if file already exists, if so, delete first
warning off
try;delete(fname); end
warning on

disp(['Writing NEXUS data to: ' fname]);

%Run Number
h5create(fname,['/entry0/run_number'],[1]);
h5write(fname, ['/entry0/run_number'], numor);

%Loop though the number of detectors
for det = 1:inst_params.detectors

    %Data Size
    data_size = size(displayimage.(['data' num2str(det)]));
    
    %Intensity
    det_data = reshape(displayimage.(['data' num2str(det)]),[1 data_size]);
    h5create(fname,['/entry0/data' num2str(det) '/intensity' num2str(det)],[1, data_size]);
    h5write(fname, ['/entry0/data' num2str(det) '/intensity' num2str(det)], det_data);
    
    %Intensity Error
    err_det_data = reshape(displayimage.(['error' num2str(det)]),[1 data_size]);
    h5create(fname,['/entry0/data' num2str(det) '/err_intensity' num2str(det)],[1, data_size]);
    h5write(fname, ['/entry0/data' num2str(det) '/err_intensity' num2str(det)], err_det_data);

    %Mod q
    mod_q_data = reshape(displayimage.(['qmatrix' num2str(det)])(:,:,5),[1 data_size]);
    h5create(fname,['/entry0/data' num2str(det) '/mod_q' num2str(det)],[1, data_size]);
    h5write(fname, ['/entry0/data' num2str(det) '/mod_q' num2str(det)], mod_q_data);
    
    %qx
    qx_data = reshape(displayimage.(['qmatrix' num2str(det)])(:,:,3),[1 data_size]);
    h5create(fname,['/entry0/data' num2str(det) '/qx' num2str(det)],[1, data_size]);
    h5write(fname, ['/entry0/data' num2str(det) '/qx' num2str(det)], qx_data);
    
    %qy
    qy_data = reshape(displayimage.(['qmatrix' num2str(det)])(:,:,4),[1 data_size]);
    h5create(fname,['/entry0/data' num2str(det) '/qy' num2str(det)],[1, data_size]);
    h5write(fname, ['/entry0/data' num2str(det) '/qy' num2str(det)], qy_data);
    
    %qangle
    qangle_data = reshape(displayimage.(['qmatrix' num2str(det)])(:,:,6),[1 data_size]);
    h5create(fname,['/entry0/data' num2str(det) '/qangle' num2str(det)],[1, data_size]);
    h5write(fname, ['/entry0/data' num2str(det) '/qangle' num2str(det)], qangle_data);

    
end
