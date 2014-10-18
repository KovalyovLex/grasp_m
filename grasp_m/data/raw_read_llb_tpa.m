function numor_data = raw_read_llb_tpa(fname,numor)

global inst_params

%Parameters 
param = zeros(128,1); %Empty Parameters array of 128, as Grasp expects.

%Open file
fid=fopen(fname);

%Read TPA XML format data
%Use our own file parser
linestr = ''; line_counter = 0;

loop_end = 0;
while loop_end ==0;
    linestr = fgetl(fid);
    
    
    if strfind(linestr,'<Frame')
        %Parse the string to strip out all the parameters
        
        %Monitor
        temp = strfind(linestr,'Monitor=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        param(inst_params.vectors.monitor) = str2num(linestr(temp2(temp3(1))+1:temp2(temp3(2))-1));
        
        %Acquisition Time
        temp = strfind(linestr,'Monitor_Time=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        param(inst_params.vectors.aq_time) = str2num(linestr(temp2(temp3(1))+1:temp2(temp3(2))-1));
        
        %Detector Distance
        temp = strfind(linestr,'Detector_Distance=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        param(inst_params.vectors.det1) = str2num(linestr(temp2(temp3(1))+1:temp2(temp3(2))-1))/1000;
        param(inst_params.vectors.detcalc1) = param(inst_params.vectors.det1);
        
        %Wavelength
        temp = strfind(linestr,' Lambda=');
        temp2 = strfind(linestr,'"');
        temp3 = find(temp2>=temp);
        param(inst_params.vectors.wav) = str2num(linestr(temp2(temp3(1))+1:temp2(temp3(2))-1));
        
        %Delta Wav
        temp = strfind(linestr,'DeltaLambdasurLambda=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        param(inst_params.vectors.deltawav) = str2num(linestr(temp2(temp3(1))+1:temp2(temp3(2))-1));

        %Collimation
        temp = strfind(linestr,'Collimator_Distance=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        param(inst_params.vectors.col) = str2num(linestr(temp2(temp3(1))+1:temp2(temp3(2))-1))/1000;
        
        %Source Aperture Size
        temp = strfind(linestr,'Collimator_Diaphragm_In=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        param(inst_params.vectors.source_ap) = str2num(linestr(temp2(temp3(1))+1:temp2(temp3(2))-1))/1000;
        
        
        %Subtitle
        temp = strfind(linestr,'Comment=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        numor_data.subtitle = (linestr(temp2(temp3(1))+1:temp2(temp3(2))-1));

        %Date
        temp = strfind(linestr,' date=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        numor_data.info.start_date  = (linestr(temp2(temp3(1))+1:temp2(temp3(2))-1));
        
        %Time
        temp = strfind(linestr,' time=');
        temp2 = strfind(linestr,'"'); temp3 = find(temp2>temp);
        numor_data.info.start_time  = (linestr(temp2(temp3(1))+1:temp2(temp3(2))-1));
        
    end
    
    if strfind(linestr,'<Data')
        temp = strfind(linestr,'>');
        temp2 = linestr(temp(1)+1:length(linestr));
        temp3 = strrep(temp2,';',' ');
        temp4 = strrep(temp3,'</Data>','');
        temp5 = str2num(temp4);
        numor_data.data1 = reshape(temp5,[512,512]);
        numor_data.data1 = rot90(numor_data.data1);
        disp('Using SQRT Errors');
        numor_data.error1 = sqrt(numor_data.data1);
   end
    
    if strfind(linestr,'</Acquisition');
        loop_end = 1; %quit loop and read detector array
    end
    
end

%Total Counts
param(inst_params.vectors.array_counts) = sum(sum(numor_data.data1));

%Numor
param(inst_params.vectors.numor) = numor;  %Usually stored as param 128

%BeamStop
param(inst_params.vectors.bx) = 0;
param(inst_params.vectors.by) = 0;

%Attenuator
param(inst_params.vectors.att_type) = 0;
param(inst_params.vectors.att_status) = 1;

% %User Information
 numor_data.info.user = 'No Name';
% numor_data.info.start_date = d.et.date_heure(1:10);
% numor_data.info.start_time = d.et.date_heure(12:19);
% numor_data.info.end_date = [];
% numor_data.info.end_time = [];

% 
% 
% 
numor_data.params1 = param;
% 
