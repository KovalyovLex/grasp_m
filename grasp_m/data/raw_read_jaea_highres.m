function numor_data = raw_read_jaea_sansu_highres(fname,numor)

%Usage:  numor_data = raw_read_jaea_sansu_highres(fname);
%'fname' is the full data path AND filename
%
%Reads file Data Numor and outputs all information as a structure including fields:
%numor_data.data1    - 2D matrix of detector data from detector1
%          .data2    -  ...from detector 2 etc.
%          .error1   - sqrt(data1)
%          .params1  - Parameter array from detector1
%          .param_names1 - Parameter names 
%          .subtitle - measurement subtitle
%          .numor    - File number indicated by header block
%          .info.user

global inst_params
global grasp_env

numor_data = [];

%Load In Data, Numor
fid=fopen(fname);

%The SANS-U format consists of 2048 bytes of header and other information.
%The rest of the file is then unsigned 32-bit integer, and the binary files
%are in the big-endian format.

% Get the header information
% --------------------------
[header] = fscanf(fid,'%c',1024);
header_blocks = [1;13;19;31;46;76;81;82;83;84;87;92;94;100;106;107;114;120;126;128;135;142;147;152;160;165;175;185;195;255;315];
for i = 1:30
    header_info{i} = header(header_blocks(i):header_blocks(i+1)-1);
end

% Get the motor information
% -------------------------
[motors] = fscanf(fid,'%c',1024);
for j = 1:20
    motor_info{j} = motors(j*8-7:j*8);
end
for k = 1:10
    motor_info{k+20} = motors(160+k);
end

% Get the data
% ------------
data_column = fread(fid,'uint32','b');
no_frames = data_column(1);
det_x = data_column(2);
det_y = data_column(3);
numor_data.data1 = reshape(data_column(4:length(data_column)),det_x,det_y,no_frames);
fclose(fid);

disp('Using SQRT(I) errors')
numor_data.error1 = sqrt(numor_data.data1);

file_type = 'two frames';
disp(['File type is: ' file_type]);

% Get the various bits of information
% -----------------------------------
numor_data.numor = str2num(header_info{2});
numor_data.info.user = header_info{3};
numor_data.subtitle = header_info{5};
numor_data.info.start_date = [];
numor_data.info.start_time = [];
numor_data.info.end_date   = [];
numor_data.info.end_time   = [];

numor_data.params1(3) = str2num(header_info{22});
numor_data.params1(16) = str2num(header_info{13});
numor_data.params1(17) = str2num(header_info{14});
numor_data.params1(19) = str2num(header_info{11});
numor_data.params1(58) = str2num(header_info{10});
numor_data.params1(65) = str2num(header_info{18});
numor_data.params1(101) = str2num(header_info{21});
numor_data.params1(127) = str2num(header_info{24});
numor_data.params1(128) = str2num(header_info{2});

% Calculate the wavelength
% ------------------------

%tilt_angle = str2num(motor_info{13});
tilt_angle = -2.8169;
NVS_speed  = str2num(header_info{6});
wavelength = 127319 * (1 + 0.045*tilt_angle) / NVS_speed;

numor_data.params1(53) = wavelength;




