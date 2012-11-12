function numor_data = raw_read_d22d11_old(fname,numor)

global inst_params

%Load In Data, Numor
fid=fopen(fname);
line = 1;line_max = 1000; i_block = 0;
%Read ILL Text Data File
while feof(fid) ==0;
    text = fgetl(fid);
    
    %Search for Numor description
    if findstr(text,'RRRRR')
        [pointers,count] = fscanf(fid,'%8g');
        numor_data.numor = pointers(1);
    end
    
    %Search for Parsub Block
    if findstr(text,'AAAAA')
        [pointers,count] = fscanf(fid,'%8i');
        if pointers(1) == 512; %Check it is the correct 'AAAAA' block
            %Parsub
            parsub=fgetl(fid);
            %User
            numor_data.info.user = parsub(1:10);
            l = size(parsub);
            numor_data.subtitle =  parsub(60:l(2));
            %Start and End Time and Date
            date_time = fgetl(fid);
            numor_data.info.start_date = date_time(1:10); numor_data.info.start_time = date_time(11:20);
            numor_data.info.end_date = date_time(21:30); numor_data.info.end_time = date_time(31:40);
        end
    end
    %Search for header text and parameters block
    if findstr(text,'FFFFF')
        text = fgetl(fid);
        pointers = str2num(text);
        [old_pointers,count] = sscanf(text,'%i');
        no_float = pointers(1);
        if count == 2 %i.e. there is text as well
            no_text = pointers(2);
        else
            no_text = 0;
        end
        %Ignore text block for now
        if no_text > 0
            for n = 1:no_text
                text = fgetl(fid);
            end
        end
        %Read Parameters
        numor_data.params1=fscanf(fid,'%g');
    end
    %Search for data block 'IIIII' - 2nd 'IIIII' block!
    if findstr(text,'IIIII')
        if i_block == 1
            fgetl(fid); %Skip data sizer
            data=fscanf(fid,'%g',[inst_params.detector1.pixels(2) inst_params.detector1.pixels(1)]); %Read Data
            %data=fscanf(fid,'%8i',[inst_params.det_size(2) inst_params.det_size(1)]); %Read Data
            data = rot90(data); %Turn data right way round
            data = flipud(data);
            numor_data.data1 = data;
        else
            i_block =1; %for the first time though
        end
    end
end
fclose(fid);

if numor_data.params1(inst_params.vectors.detcalc) == 0;  %This should fix the 'Ross bug'
    numor_data.params1(inst_params.vectors.detcalc) =  numor_data.params1(inst_params.vectors.det);
end

%Add extra parameter total counts actually counted from the data in the file
%inst_params.fparams(127) = {'Multi Det Sum'};
numor_data.params1(127) = sum(sum(numor_data.data1));
numor_data.params1(128) = numor_data.numor;
numor_data.params1(3) = numor_data.params1(3)/10; %Convert time to from 10th Seconds to Seconds

%Check if the pixel size reported in the params is different to the default instrument setting.
%Added after change of D22 detector, March 2004.

disp('Using SQRT(I) errors')
numor_data.error1 = sqrt(numor_data.data1);

