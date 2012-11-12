function numor_data = d33_model_data_read(fname,numor)

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

numor_data = [];

%Load In Data, Numor
fid=fopen(fname);

while feof(fid) ==0;
    text = fgetl(fid);
    if findstr(text,'<Numor>')
        numor_str = fgetl(fid);
        numor_data.numor = str2num(numor_str);
        break
    end
end

while feof(fid) ==0;
    text = fgetl(fid);
    if findstr(text,'<nFrames>')
        nframes_str = fgetl(fid);
        numor_data.n_frames = str2num(nframes_str);
        break
    end
end

while feof(fid) ==0;
    text = fgetl(fid);
    if findstr(text,'<Start>')
        date_time = fgetl(fid);
        numor_data.info.start_date = date_time(1:11);
        numor_data.info.start_time = date_time(13:20);
        break
    end
end

while feof(fid) ==0;
    text = fgetl(fid);
    if findstr(text,'<End>')
        date_time = fgetl(fid);
        numor_data.info.end_date = date_time(1:11);
        numor_data.info.end_time = date_time(13:20);
        break
    end
end

while feof(fid) ==0;
    text = fgetl(fid);
    if findstr(text,'<Subtitle>')
        numor_data.subtitle = fgetl(fid);
        break
    end
end


numor_data.info.user = ' ';

if numor_data.n_frames>1;
    is_tof = 1;
else
    is_tof = 0; 
end

%Loop though the number of Frames:  TOF or Kinetic
for frame = 1:numor_data.n_frames
    
    while feof(fid) ==0;
        text = fgetl(fid);
        if findstr(text,'<Frame>')
            text = fgetl(fid);
            if frame == str2num(text);
                %Read Frame for all detectors
                disp(['Reading Frame ' num2str(frame) ' of ' num2str(numor_data.n_frames)]);

                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Parameters1>')
                        numor_data.params1(:,frame)=fscanf(fid,'%g',128);
                        numor_data.params1(128,frame) = numor_data.numor;
                        numor_data.params1(inst_params.vectors.is_tof,frame) = is_tof;
                        break
                    end
                end
                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Detector1>')
                        numor_data.data1(:,:,frame) =fscanf(fid,'%g',[128 128]);
                        numor_data.error1(:,:,frame) = sqrt(numor_data.data1(:,:,frame));
                        break
                    end
                end
                numor_data.params1(inst_params.vectors.array_counts,frame) = sum(sum(numor_data.data1(:,:,frame)));
                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Parameters2>')
                        numor_data.params2(:,frame)=fscanf(fid,'%g',128);
                        numor_data.params2(128,frame) = numor_data.numor;
                        numor_data.params2(inst_params.vectors.is_tof,frame) = is_tof;
                        break
                    end
                end
                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Detector2>')
                        numor_data.data2(:,:,frame)=fscanf(fid,'%g',[128 32]);
                        numor_data.error2(:,:,frame) = sqrt(numor_data.data2(:,:,frame));
                        break
                    end
                end
                numor_data.params2(inst_params.vectors.array_counts,frame) = sum(sum(numor_data.data2(:,:,frame)));

                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Parameters3>')
                        numor_data.params3(:,frame)=fscanf(fid,'%g',128);
                        numor_data.params3(128,frame) = numor_data.numor;
                        numor_data.params3(inst_params.vectors.is_tof,frame) = is_tof;
                        break
                    end
                end
                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Detector3>')
                        numor_data.data3(:,:,frame)=fscanf(fid,'%g',[128 32]);
                        numor_data.error3(:,:,frame) = sqrt(numor_data.data3(:,:,frame));
                        break
                    end
                end
                numor_data.params3(inst_params.vectors.array_counts,frame) = sum(sum(numor_data.data3(:,:,frame)));

                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Parameters4>')
                        numor_data.params4(:,frame)=fscanf(fid,'%g',128);
                        numor_data.params4(128,frame) = numor_data.numor;
                        numor_data.params4(inst_params.vectors.is_tof,frame) = is_tof;
                        break
                    end
                end
                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Detector4>')
                        numor_data.data4(:,:,frame)=fscanf(fid,'%g',[32 128]);
                        numor_data.error4(:,:,frame) = sqrt(numor_data.data4(:,:,frame));
                        break
                    end
                end
                numor_data.params4(inst_params.vectors.array_counts,frame) = sum(sum(numor_data.data4(:,:,frame)));

                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Parameters5>')
                        numor_data.params5(:,frame)=fscanf(fid,'%g',128);
                        numor_data.params5(128,frame) = numor_data.numor;
                        numor_data.params5(inst_params.vectors.is_tof,frame) = is_tof;
                        break
                    end
                end
                
                while feof(fid) ==0;
                    text = fgetl(fid);
                    if findstr(text,'<Detector5>')
                        numor_data.data5(:,:,frame)=fscanf(fid,'%g',[32 128]);
                        numor_data.error5(:,:,frame) = sqrt(numor_data.data5(:,:,frame));
                        break
                    end
                end
                numor_data.params5(inst_params.vectors.array_counts,frame) = sum(sum(numor_data.data5(:,:,frame)));

                
                break
                
            end
        end
    end
end


%Close file
fclose(fid);

