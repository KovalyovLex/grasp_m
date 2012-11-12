function numor_data = raw_read_frm2_mira(fname,numor)

%Data loader function for FRM2_Mira

%Usage:  numor_data = raw_read_ill_sans(fname);
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

det_size = inst_params.detector1.pixels; %Can be 128x128 or 512x512 depending if old or new detector


%These parameter should be picked up in the future
numor_data.info.start_date = ['**-**-**']; %Start Date
numor_data.info.start_time = ['**-**-**']; %Start Time
numor_data.info.end_date = ['**-**-**']; %End Date
numor_data.info.end_time = ['**-**-**']; %End Time
numor_data.info.user = ['NoName']; %User name

numor_data.subtitle = ['No Title']; %Measurement Subtitle

numor_data.params1 = zeros(128,1); %Empty parameter array

%Load In Data, Numor
fid=fopen(fname);

warning on
%Read FRM2 Mira XML format data
%Use our own file parser
linestr = ''; line_counter = 0;

loop_end = 0;
while loop_end ==0;
    linestr = fgetl(fid);
    
    if strfind(linestr,'<Sample_Detector>')
        det_str = strtok(linestr,'<Sample_Detector>');
        numor_data.params1(inst_params.vectors.det) = str2num(det_str)/1000; % convert mm to m
        numor_data.params1(inst_params.vectors.detcalc) = numor_data.params1(inst_params.vectors.det);
    end
    
    if strfind(linestr,'<wavelength>')
        wav_str = strtok(linestr,'<wavelength>');
        numor_data.params1(inst_params.vectors.wav) = str2num(wav_str); %in Angs
    end
    
     if strfind(linestr,'<om>') %Sample angle
        om_str = strtok(linestr,'<om>');
        numor_data.params1(inst_params.vectors.om) = str2num(om_str);
     end

     if strfind(linestr,'<phi>') %Detector angle
         phi_str = strtok(linestr,'<phi>');
         numor_data.params1(inst_params.vectors.phi) = str2num(phi_str);
     end

     if strfind(linestr,'<stx>') %Sample position
         stx_str = strtok(linestr,'<stx>');
         numor_data.params1(inst_params.vectors.stx) = str2num(stx_str);
     end
     
     if strfind(linestr,'<sty>') %Sample position
         sty_str = strtok(linestr,'<sty>');
         numor_data.params1(inst_params.vectors.sty) = str2num(sty_str);
     end
     
     if strfind(linestr,'<sgx>') %Sample tilt
         sgx_str = strtok(linestr,'<sgx>');
        numor_data.params1(inst_params.vectors.sgx) = str2num(sgx_str);
     end

     if strfind(linestr,'<sgy>') %Sample tilt
         sgy_str = strtok(linestr,'<sgy>');
         numor_data.params1(inst_params.vectors.sgy) = str2num(sgy_str);
     end

     if strfind(linestr,'<temperature>') %Sample temperature
         temp_str = strtok(linestr,'<temperature>');
         numor_data.params1(inst_params.vectors.temp) = str2num(temp_str);
     end

     if strfind(linestr,'<mag_field>') %Magnetic field
         field_str = strtok(linestr,'<mag_field>');
         numor_data.params1(inst_params.vectors.mag_field) = str2num(field_str);
     end

     if strfind(linestr,'<pressure>') %Pressure
         pressure_str = strtok(linestr,'<pressure>');
         numor_data.params1(inst_params.vectors.pressure) = str2num(pressure_str);
     end

    if strfind(linestr,'<detector_value');
        loop_end = 1; %quit loop and read detector array
    end
    
    if strfind(linestr,'<totalcounts_counter>');
        counts_str = strtok(linestr,'<totalcounts_counter>');
        numor_data.params1(inst_params.vectors.counts) = str2num(counts_str);
    end
    
    if strfind(linestr,'<lifetime>');
        time_str = strtok(linestr,'<lifetime>');
        time_num = str2num(time_str);
        numor_data.params1(inst_params.vectors.time) = time_num(1);
    end

    if strfind(linestr,'<beam_monitor>')
        monitor_str = strtok(linestr,'<beam_monitor>');
        numor_data.params1(inst_params.vectors.monitor) = str2num(monitor_str);
    end

    %     if strfind(linestr,'<totalcounts_counter>');
    %         monitor_str = strtok(linestr,'<totalcounts_counter>');
    %         monitor_num = str2num(monitor_str);
    %         param(inst_params.vectors.monitor) = monitor_num(1);
    %     end
    %param(inst_params.vectors.monitor) = 1;

end

%Read the Detector data array in one go
data_temp=fscanf(fid,'%g',[1024 1024]); %Read Data 1024 is the raw det size

%Re-sample the data down to by the factor 'data_resize'
data = zeros([inst_params.detector1.pixels(2) inst_params.detector1.pixels(1)]);
data_resize = inst_params.data_resize;
 for n = 1:data_resize:1024
        for m=1:data_resize:1024
            data((m+data_resize-1)/data_resize,(n+data_resize-1)/data_resize) = sum(sum(data_temp(m:m+data_resize-1,n:n+data_resize-1)));
        end
 end
numor_data.data1 = data;
%Create Error Data
disp('Using SQRT(I) errors')
numor_data.error1 = sqrt(data);
 
%Add extra parameter total counts actually counted from the data in the file
numor_data.params1(127) = sum(sum(numor_data.data1)); %The total Det counts as summed from the data array
numor_data.params1(128) = numor;
%Close the data file
fclose(fid);



