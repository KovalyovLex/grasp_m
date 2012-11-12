function insert_data_depth(index,worksheet,depth,depth_data)

global grasp_data
global inst_params

%Check if incoming worksheet is valid
if isempty(depth_data)
    disp('Insert Data Depth:  No valid depth data to insert');
    return
end
%Check if worksheet exists
if worksheet > grasp_data(index).nmbr;
    disp('Insert Data Depth:  Worksheet number does not exist');
    return
end
%Check if Depth Exists
if depth > grasp_data(index).dpth{worksheet}+1;
    disp('Insert Data Depth:  Cannot insert worksheet beyond current depth+1');
    return
end


previous_depth = grasp_data(index).dpth{worksheet};

%check if worksheet was previously empty
if previous_depth ==1 && sum(sum(grasp_data(index).data1{worksheet}(:,:,1))) == 0 && sum(grasp_data(index).params1{worksheet}(:,1)) == 0;
    for det = 1:inst_params.detectors
        grasp_data(index).(['data' num2str(det)]){worksheet} = depth_data.(['data' num2str(det)]);
        grasp_data(index).(['error' num2str(det)]){worksheet} = depth_data.(['error' num2str(det)]);
        grasp_data(index).(['params' num2str(det)]){worksheet} = depth_data.(['params' num2str(det)]);
    end
    grasp_data(index).thickness{worksheet} = depth_data.thickness;
    grasp_data(index).subtitle{worksheet}{1} = depth_data.subtitle;
    grasp_data(index).load_string{worksheet}{1} = depth_data.load_string;
    fields = fieldnames(grasp_data(index).info{worksheet});
    for n = 1:length(fields)
        grasp_data(index).info{worksheet}.([fields{n}]){1} = depth_data.info.([fields{n}]);
    end
    
else
    %Split the data worksheet in half about the required depth to insert
    for det = 1:inst_params.detectors
        %Part 1
        data_pt1.(['data' num2str(det)]) = grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,1:depth-1);
        error_pt1.(['error' num2str(det)]) = grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,1:depth-1);
        params_pt1.(['params' num2str(det)]) = grasp_data(index).(['params' num2str(det)]){worksheet}(:,1:depth-1);
        
        %Part 2
        data_pt2.(['data' num2str(det)]) = grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,depth:previous_depth);
        error_pt2.(['error' num2str(det)]) = grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,depth:previous_depth);
        params_pt2.(['params' num2str(det)]) = grasp_data(index).(['params' num2str(det)]){worksheet}(:,depth:previous_depth);
    end
    
    fields = fieldnames(grasp_data(index).info{worksheet});
    for n = 1:length(fields)
        info_pt1.([fields{n}]) = grasp_data(index).info{worksheet}.([fields{n}])(1:depth-1);
        info_pt2.([fields{n}]) = grasp_data(index).info{worksheet}.([fields{n}])(depth:previous_depth);
    end

    
    %Part1
    thickness_pt1 = grasp_data(index).thickness{worksheet}(1:depth-1);
    subtitle_pt1 = grasp_data(index).subtitle{worksheet}(:,1:depth-1);
    %Part2
    thickness_pt2 = grasp_data(index).thickness{worksheet}(depth:previous_depth);
    subtitle_pt2 = grasp_data(index).subtitle{worksheet}(:,depth:previous_depth);

    
    %Add the storage worksheet back together
    new_depth = previous_depth+1;
    grasp_data(index).dpth{worksheet} = new_depth;

    
    %Put the collapsed matrix back in the main storage array
    for det = 1:inst_params.detectors
        grasp_data(index).(['data' num2str(det)]){worksheet} = data_pt1.(['data' num2str(det)]);
        grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,depth) = depth_data.(['data' num2str(det)]);
        grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,depth+1:new_depth) = data_pt2.(['data' num2str(det)]);
        
        grasp_data(index).(['error' num2str(det)]){worksheet} = error_pt1.(['error' num2str(det)]);
        grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,depth) = depth_data.(['error' num2str(det)]);
        grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,depth+1:new_depth) = error_pt2.(['error' num2str(det)]);
        
        grasp_data(index).(['params' num2str(det)]){worksheet} = params_pt1.(['params' num2str(det)]);
        grasp_data(index).(['params' num2str(det)]){worksheet}(:,depth) = depth_data.(['params' num2str(det)]);
        grasp_data(index).(['params' num2str(det)]){worksheet}(:,depth+1:new_depth) = params_pt2.(['params' num2str(det)]);
    end
    grasp_data(index).thickness{worksheet} = thickness_pt1;
    grasp_data(index).thickness{worksheet}(depth) = depth_data.thickness;
    grasp_data(index).thickness{worksheet}(depth+1:new_depth) = thickness_pt2;
    grasp_data(index).subtitle{worksheet} = subtitle_pt1;
    grasp_data(index).subtitle{worksheet}{depth} = depth_data.subtitle;
    grasp_data(index).subtitle{worksheet}(depth+1:new_depth) = subtitle_pt2;
    for n = 1:length(fields)
        grasp_data(index).info{worksheet}.([fields{n}]) = info_pt1.([fields{n}]);
        grasp_data(index).info{worksheet}.([fields{n}]){depth} = depth_data.info.([fields{n}]);
        grasp_data(index).info{worksheet}.([fields{n}])(depth+1:new_depth) = info_pt2.([fields{n}]);
    end
    
end