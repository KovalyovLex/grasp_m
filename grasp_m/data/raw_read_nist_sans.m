function numor_data = raw_read_nist_sans(fname,numor)

global inst_params

numor_data.numor = numor;

%***** Raw Data Load Routine for NIST NG3 &  NG7 *****
numor_data.params1 = zeros(128,1);

%Read NIST NG7 format data
fid=fopen(fname);
warning on

%Begin reading data line by line
%Line 1
linestr = fgetl(fid);
a = findstr(linestr,'''');
expdate = linestr(a(3):a(4));
temp = findstr(' ',expdate);

numor_data.info.start_date = expdate(2:temp-1);
numor_data.info.start_time = expdate(temp+1:length(expdate)-1);
numor_data.info.end_date = 'N/A';
numor_data.info.end_time = 'N/A';
numor_data.info.user = '';

%Line 2
linestr = fgetl(fid);
len = length(linestr); if len>80; len = 80; end
numor_data.subtitle = linestr(1:len);

%Line 3
linestr = fgetl(fid);
prm = str2num(linestr);
numor_data.params1(inst_params.vectors.time) = prm(1);
numor_data.params1(inst_params.vectors.monitor) = prm(2);

%Line 4
linestr = fgetl(fid);
%Line 5
linestr = fgetl(fid);
%Parse the temperature string
[temp1,temp2] = strtok(linestr,'''');
prm = str2num(temp1);
numor_data.params1(inst_params.vectors.temp) = prm(3);%Temperature

%Parse the magnetic field string
temp1 = findstr(temp2,'''');
fieldstr = temp2(temp1(2)+1:temp1(3)-1);
numor_data.params1(inst_params.vectors.field) = str2num(fieldstr); %Magnetic field

%Line 6
linestr = fgetl(fid);

%Line 7
linestr = fgetl(fid);
len = length(linestr);
a = findstr(linestr,'''');  %Find the text elements
newline = [linestr(1:(a(1)-1)) linestr((a(2)+1):len)]; %Remove the text elements
prm = str2num(newline);
numor_data.params1(inst_params.vectors.wav) = prm(1);
numor_data.params1(inst_params.vectors.deltawav) = prm(2);
numor_data.params1(inst_params.vectors.san) = prm(4);

%Line 8
linestr = fgetl(fid);

%Line 9 
linestr = fgetl(fid);
prm = str2num(linestr);
numor_data.params1(inst_params.vectors.det) = prm(1);
%numor_data.params1(inst_params.vectors.detcalc) = prm(1);
numor_data.params1(inst_params.vectors.bx) = prm(3);
numor_data.params1(inst_params.vectors.by) = prm(4);
numor_data.params1(inst_params.vectors.att_type) = prm(6);


%Line 10
linestr = fgetl(fid);
%Line 11
linestr = fgetl(fid);
%Line 12
linestr = fgetl(fid);

%Line 13
linestr = fgetl(fid);
a = findstr(linestr,'''');
temp = str2num(linestr(1:a(1)-1));
numor_data.params1(inst_params.vectors.col) = temp(3);
numor_data.params1(inst_params.vectors.source_ap) = temp(1)/1000; %m

%Find beginning of multidetector data
while isempty(findstr(linestr,'Packed Counts by Rows'));
     linestr = fgetl(fid);
end

%Read the comma separated data line by line, str2num, and add to the data array.
data = [];
while not(feof(fid))
    linestr = fgetl(fid);
    line_num = str2num(linestr);
    data = [data,line_num];
end
data = reshape(flipud(rot90(data)),inst_params.detector1.pixels(2),inst_params.detector1.pixels(1));
data = rot90(data,3);
data = fliplr(data);
numor_data.data1 = data;
disp('Using SQRT(I) errors')
numor_data.error1 = sqrt(data);

%New reading routine - end
fclose(fid);


%Add extra parameter total counts actually counted from the data in the file
numor_data.params1(127) = sum(sum(numor_data.data1)); %The total Det counts as summed from the data array
numor_data.params1(inst_params.vectors.array_counts) = sum(sum(numor_data.data1)); %The total Det counts as summed from the data array
numor_data.params1(128) = numor; %Additional parameter added by chuck

numor_data.file_type = 'single frame';
