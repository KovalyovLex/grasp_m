function numor_data = raw_read_frm2_sans1(fname,numor)

global inst_params

numor_data = [];

param = zeros(128,1);

%Load In Data, Numor
fid=fopen(fname);
warning on
%Read HMI format data
linestr = ''; line_counter = 0;

numor_data.info.start_date = '';
numor_data.info.start_time = '';
numor_data.info.end_date = '';
numor_data.info.end_time ='';
numor_data.info.user = '';

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

    if findstr(linestr,'Time='); a = findstr(linestr,'Time='); if a==1; l = length(linestr); param(inst_params.vectors.time) = str2num(linestr(findstr(linestr,'=')+1:l)); end; end
   
    if findstr(linestr,'Moni1')==1; l = length(linestr); param(inst_params.vectors.monitor1) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'Moni2')==1; l = length(linestr); param(inst_params.vectors.monitor2) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    
    %if findstr(linestr,'Moni3')==1; l = length(linestr); param(inst_params.vectors.moni3) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    %if findstr(linestr,'Moni4')==1; l = length(linestr); param(inst_params.vectors.moni4) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    
    if findstr(linestr,'BeamstopX=');
        l = length(linestr); param(inst_params.vectors.bx) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'BeamstopY='); l = length(linestr); param(inst_params.vectors.by) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'SD=');
        l = length(linestr); param(inst_params.vectors.det) = str2num(linestr(findstr(linestr,'=')+1:l)); param(inst_params.vectors.detcalc) = param(inst_params.vectors.det);
        param(inst_params.vectors.detcalc) = param(inst_params.vectors.det);
    end
    %if findstr(linestr,'Lambda='); l = length(linestr); param(inst_params.vectors.wav) = 10*str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'LambdaC=');
        l = length(linestr);
        rpm = str2num(linestr(findstr(linestr,'=')+1:l));
        param(inst_params.vectors.sel_rpm) = rpm;
        wav =  0.03 + 125800 / rpm;
        param(inst_params.vectors.wav) = wav;
        param(inst_params.vectors.deltawav) = 0.1; %Default 10%
    end

    if findstr(linestr,'Collimation='); l = length(linestr); param(inst_params.vectors.col) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'Attenuator=');
        l = length(linestr);
        temp = str2num(linestr(findstr(linestr,'=')+1:l));
        if ~isempty(temp);
            param(inst_params.vectors.att_type) = temp;
        else 
            param(inst_params.vectors.att_type) = 0;
        end
        param(inst_params.vectors.att_status) = 0;
    end
    

    %Sample Environment
    if findstr(linestr,'Temperature='); a = findstr(linestr,'Temperature='); if a==1; l = length(linestr); param(inst_params.vectors.temp) = str2num(linestr(findstr(linestr,'=')+1:l));end  ; end
    if findstr(linestr,'Magnet='); a = findstr(linestr,'Magnet='); if a==1; l = length(linestr); param(inst_params.vectors.field) = str2num(linestr(findstr(linestr,'=')+1:l));end  ; end

    if findstr(linestr,'Position='); l = length(linestr); param(inst_params.vectors.chpos) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'omega-2b='); l = length(linestr); param(inst_params.vectors.omega_2b) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'chi-2b='); l = length(linestr); param(inst_params.vectors.chi_2b) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'phi-2b='); l = length(linestr); param(inst_params.vectors.phi_2b) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'x-2b='); l = length(linestr); param(inst_params.vectors.x_2b) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'y-2b='); l = length(linestr); param(inst_params.vectors.y_2b) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'z-2b='); l = length(linestr); param(inst_params.vectors.z_2b) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'x-2a='); l = length(linestr); param(inst_params.vectors.x_2a) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'y-2a='); l = length(linestr); param(inst_params.vectors.y_2a) = str2num(linestr(findstr(linestr,'=')+1:l)); end
    if findstr(linestr,'z-2a='); l = length(linestr); param(inst_params.vectors.z_2a) = str2num(linestr(findstr(linestr,'=')+1:l)); end
end


%New reading routine.  - Compiles but is slightly slower than the 'dlmread' version (1/2 the speed of the dlmread version)
temp =fscanf(fid,'%c',[inf]); %Read all the rest of the file as string
data_end = findstr(temp,'%Counter'); %Find where the data ends: SINQ add extra at the end of file.
data_end = findstr(temp,'%Errors'); 
error_end = length(temp);
if isempty(data_end); data_end = length(temp); end %Find where the data ends for real HMI file.

%data = str2num(temp(1,1:data_end-1)); %Extract the data from the remaining string by str2num'ing
temp = strrep(temp,',',' '); %Replace commas with spaces so that sscanf works.
data = sscanf(temp(1,1:data_end-1),'%g');

%Turn data around 
data = reshape(data,inst_params.detector1.pixels(1),inst_params.detector1.pixels(2));
data = rot90(data);
data = flipud(data);

disp('Using SQRT(I) errors')
error_data = sqrt(data);

%Close file
fclose(fid);

%Add extra parameter total counts actually counted from the data in the file
param(127) = sum(sum(data)); %The total Det counts as summed from the data array
param(128) = numor;

%Make final output structure
numor_data.data1 = data;
numor_data.error1 = error_data;
numor_data.params1 = param;

