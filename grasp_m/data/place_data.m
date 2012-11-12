function place_data(numor_data, wks,nmbr,dpth_start)

global grasp_data
global inst_params

%Find index to DATA
index = data_index(wks);

%Check for multi-frame data coming in, e.g. TOF, Kinetic etc.
if numor_data.n_frames >1;
    disp('Multi-frame TOF or Kinetic Data')
end

for frame = 1:numor_data.n_frames
    
    dpth = dpth_start +frame -1;
    
    disp(['Appending Worksheet: ' grasp_data(index).name '; Number: ' num2str(nmbr) '; Depth: ' num2str(dpth)]);
    
    %Check if requested depth is greater than Max allowed
    if dpth > grasp_data(index).dpth_max{nmbr};
        disp(' ');
        disp('Attemp to Exceed Maximum Worksheet Depth');
        disp(' ');
        error(' ');
    end

    %Check if requested depth is greater than current depth
    %If so, increase dpth parameter in Data
    current_depth = grasp_data(index).dpth{nmbr};
    if dpth > current_depth  %Just place the new data into matrix
        grasp_data(index).dpth{nmbr} = dpth;
        %Loop though number of detectors
        for det = 1:inst_params.detectors
            grasp_data(index).(['data' num2str(det)]){nmbr}(:,:,dpth) = numor_data.(['data' num2str(det)])(:,:,frame);
            grasp_data(index).(['error' num2str(det)]){nmbr}(:,:,dpth) = numor_data.(['error' num2str(det)])(:,:,frame);
            grasp_data(index).(['params' num2str(det)]){nmbr}(:,dpth) = numor_data.(['params' num2str(det)])(:,frame);
        end
    
    else %Append to existing contents
        %Loop though number of detectors
        for det = 1:inst_params.detectors
            grasp_data(index).(['data' num2str(det)]){nmbr}(:,:,dpth) = grasp_data(index).(['data' num2str(det)]){nmbr}(:,:,dpth) + numor_data.(['data' num2str(det)])(:,:,frame);
            grasp_data(index).(['error' num2str(det)]){nmbr}(:,:,dpth) = sqrt ( ((grasp_data(index).(['error' num2str(det)]){nmbr}(:,:,dpth)).^2) + ((numor_data.(['error' num2str(det)])(:,:,frame)).^2)  );
            
            %Careful with parameters when appending files
            %Some parameters, e.g. monitor, need to be summed
            total_monitor = grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.monitor,dpth);
            %total_counts = grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.counts,dpth);
            total_time = grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.time,dpth);
            total_array_counts = grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.array_counts,dpth);
            
            %Over write the parameters
            grasp_data(index).(['params' num2str(det)]){nmbr}(:,dpth) = numor_data.(['params' num2str(det)])(:,frame);
            
            %Add to the monitor etc
            grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.monitor,dpth) = grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.monitor,dpth) + total_monitor;
            %grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.counts,dpth) = grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.counts,dpth) + total_counts;
            grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.time,dpth) = grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.time,dpth) + total_time;
            grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.array_counts,dpth) = grasp_data(index).(['params' num2str(det)]){nmbr}(inst_params.vectors.array_counts,dpth) + total_array_counts;
        end
    end
    grasp_data(index).subtitle{nmbr}{dpth} = numor_data.subtitle;

    %organise data info structure
    if isfield(numor_data,'info')
        %grasp_data(index).info{nmbr} = [];
        temp = (fieldnames(numor_data.info));
        for n = 1:length(temp)
            grasp_data(index).info{nmbr}.([temp{n}]){dpth} = numor_data.info.([temp{n}]);
        end
    end

    %Add a default thickness to the array if one doesn't already exist
    if dpth > length(grasp_data(index).thickness{nmbr})
        grasp_data(index).thickness{nmbr}(dpth) = 0.1; %default thickness
    end
    grasp_data(index).load_string{nmbr} = {[numor_data.load_string]};
    
    %data(index).trans{nmbr}(dpth,:) = [1,0];
    %data(index).cm{nmbr}(dpth,:) = [inst_params.det_size(1)/2 inst_params.det_size(2)/2 0];
    
end
    
