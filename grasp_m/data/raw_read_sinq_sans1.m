function numor_data = raw_read_sinq_sans1(fname,numor)

global inst_params

numor_data = [];

param = zeros(128,1);

%Load In Data, Numor
fid=fopen(fname);
warning on
%Read HMI format data for SINQ_sans
linestr = ''; line_counter = 0;
while isempty(findstr(linestr,'%Counts'));
    linestr = fgetl(fid);
    line_counter = line_counter +1;
    
    if findstr(linestr,'FromDate='); l = length(linestr); numor_data.info.start_date = linestr(findstr(linestr,'=')+1:l); end
    if findstr(linestr,'FromTime='); l = length(linestr); numor_data.info.start_time = linestr(findstr(linestr,'=')+1:l); end
    if findstr(linestr,'ToDate='); l = length(linestr); numor_data.info.end_date = linestr(findstr(linestr,'=')+1:l); end
    if findstr(linestr,'ToTime='); l = length(linestr); numor_data.info.end_time = linestr(findstr(linestr,'=')+1:l); end
    if findstr(linestr,'User='); l = length(linestr); numor_data.info.user = linestr(findstr(linestr,'=')+1:l); end
    
    if findstr(linestr,'FileName=');
        numor_str = strtok(linestr,'FileName=');
        numor_str = strtok(numor_str,'D');
        numor_str = numor_str(1:inst_params.filename.numeric_length);
        numor_data.numor = str2num(numor_str);
        param(128) = numor_data.numor; %Additional parameter added by chuck
    end
    
    if findstr(linestr,'Title'); l=length(linestr); numor_data.subtitle = linestr(7:l); end

    if findstr(linestr,'Time='); a = findstr(linestr,'Time='); if a==1; l = length(linestr); param(inst_params.vectors.time) = 10*str2num(linestr(findstr(linestr,'=')+1:l)); end; end
    if findstr(linestr,'Moni1='); 
        if findstr(linestr,'Sum/Moni1');
        else
            l = length(linestr); param(inst_params.vectors.monitor) = str2num(linestr(findstr(linestr,'=')+1:l));
        end
    end
    if findstr(linestr,'Moni2='); l = length(linestr); param(inst_params.vectors.moni2) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'Moni3='); l = length(linestr); param(inst_params.vectors.moni3) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'Moni4='); l = length(linestr); param(inst_params.vectors.moni4) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    
    if findstr(linestr,'BeamstopX=');
        l = length(linestr); param(inst_params.vectors.bx) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'BeamstopY='); l = length(linestr); param(inst_params.vectors.by) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'SD=');
        l = length(linestr); param(inst_params.vectors.det) = str2num(linestr(findstr(linestr,'=')+1:l)); param(inst_params.vectors.detcalc) = param(inst_params.vectors.det);
        param(inst_params.vectors.detcalc) = param(inst_params.vectors.det);
    end
    if findstr(linestr,'Temperature='); a = findstr(linestr,'Temperature='); if a==1; l = length(linestr); param(inst_params.vectors.temp) = str2num(linestr(findstr(linestr,'=')+1:l));end  ; end
    if findstr(linestr,'Lambda='); l = length(linestr); param(inst_params.vectors.wav) = 10*str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'LambdaC='); l = length(linestr); param(inst_params.vectors.wav) = 10*str2num(linestr(findstr(linestr,'=')+1:l)); end

    if findstr(linestr,'Collimation='); l = length(linestr); param(inst_params.vectors.col) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'Attenuator=');
        l = length(linestr);
        temp = str2num(linestr(findstr(linestr,'=')+1:l));
        if ~isempty(temp);
            param(inst_params.vectors.att_type) = temp;
        else 
            param(inst_params.vectors.att_type) = 0;
        end
    end
    if findstr(linestr,'SDchi='); l = length(linestr); param(inst_params.vectors.dan) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'SY='); l = length(linestr); param(inst_params.vectors.dtr) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    
    %Phi(SINQ) = SAN(D22)
    if findstr(linestr,'Phi=');  a = findstr(linestr,'Phi='); if a==1; l = length(linestr); param(inst_params.vectors.san) = str2num(linestr(findstr(linestr,'=')+1:l)); end; end
    %Theta(SINQ) = Phi(D22)
    if findstr(linestr,'Theta=');  a = findstr(linestr,'Theta='); if a==1; l = length(linestr); param(inst_params.vectors.phi) = str2num(linestr(findstr(linestr,'=')+1:l)); end; end
end
data_start_line = line_counter; %Start line of data;

% %Quick correction for HMI Wavelength
% %SINQ store LambdaC (vel selector speed) and Lambda (wavelength)
% %HMI only stor LambdaC then calculate Lambda.
% %This loader picks up Lambda for SINQ since it appears later in the params list
% %But picks up LambdaC for HMI
% %For HMI:  lambda in Angstroems = 0.03  +  125800 / LambdaC
% if strcmp(inst,'V4_HMI_64') | strcmp(inst,'V4_HMI_128');
%     param(inst_params.vectors.wav) = 0.03 + 125800 / (param(inst_params.vectors.wav)/10); %the extra /10 is due to the line above for SINQ wav which is in nm
% end

%New reading routine.  - Compiles but is slightly slower than the 'dlmread' version (1/2 the speed of the dlmread version)
temp =fscanf(fid,'%c',[inf]); %Read all the rest of the file as string
data_end = findstr(temp,'%Counter'); %Find where the data ends: SINQ add extra at the end of file.
if isempty(data_end); data_end = length(temp); end %Find where the data ends for real HMI file.
data = str2num(temp(1,1:data_end-1)); %Extract the data from the remaining string by str2num'ing

%New reading routine - end
fclose(fid);

data = reshape(flipud(rot90(data)),inst_params.detector1.pixels(2),inst_params.detector1.pixels(1));
data = rot90(data);
data = flipud(data);
disp('Using SQRT(I) errors')
error_data = sqrt(data);

%Add extra parameter total counts actually counted from the data in the file
param(127) = sum(sum(data)); %The total Det counts as summed from the data array
param(128) = numor;

%Make final output structure
numor_data.data1 = data;
numor_data.error1 = error_data;
numor_data.params1 = param;


