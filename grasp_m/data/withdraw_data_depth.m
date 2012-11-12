function depth_data = withdraw_data_depth(index,worksheet,depth)

global grasp_data
global inst_params
depth_data = [];

%Check if worksheet exists
if worksheet > grasp_data(index).nmbr;
    disp('Withdraw Data Depth:  Worksheet number does not exist');
    return
end
%Check if Depth Exists
if depth > grasp_data(index).dpth{worksheet};
    disp('Withdraw Data Depth:  Depth does not exist');
    return
end


%Extract worksheet depth data, error, params, parsub and info
for det = 1:inst_params.detectors
    depth_data.(['data' num2str(det)]) = grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,depth);
    depth_data.(['error' num2str(det)]) = grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,depth);
    depth_data.(['params' num2str(det)]) = grasp_data(index).(['params' num2str(det)]){worksheet}(:,depth);
end
depth_data.subtitle = grasp_data(index).subtitle{worksheet}{depth};
depth_data.thickness = grasp_data(index).thickness{worksheet}(depth);
depth_data.load_string = grasp_data(index).load_string{worksheet}{1};
fields = fieldnames(grasp_data(index).info{worksheet});
for n = 1:length(fields)
    depth_data.info.([fields{n}]) = grasp_data(index).info{worksheet}.([fields{n}]){depth};
end


%Collapse the data structure to take account of withdrawing this worksheet
previous_depth = grasp_data(index).dpth{worksheet};
if previous_depth == 1; %then just leave an empty worksheet
    for det = 1:inst_params.detectors
        grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,depth) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
        grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,depth) = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));
        grasp_data(index).(['params' num2str(det)]){worksheet}(:,depth) = zeros(128,1);
    end
    grasp_data(index).thickness{worksheet}(depth) = 0.1; 
    grasp_data(index).subtitle{worksheet}{depth} = 'Empty Space';
    grasp_data(index).load_string{worksheet}{depth} = ['<Numors>'];
    grasp_data(index).info{worksheet}.start_date{depth} = ['**-**-**']; %Start Date
    grasp_data(index).info{worksheet}.start_time{depth} = ['**-**-**']; %Start Time
    grasp_data(index).info{worksheet}.end_date{depth} = ['**-**-**']; %End Date
    grasp_data(index).info{worksheet}.end_time{depth} = ['**-**-**']; %End Time
    grasp_data(index).info{worksheet}.user{depth} = [' ']; %User Name
    
    
else %collapse the data structure by one to account for withdrawing worksheet
    for det = 1:inst_params.detectors
        data_pt1.(['data' num2str(det)]) = grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,1:depth-1);
        error_pt1.(['error' num2str(det)]) = grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,1:depth-1);
        params_pt1.(['params' num2str(det)]) = grasp_data(index).(['params' num2str(det)]){worksheet}(:,1:depth-1);
        
        data_pt2.(['data' num2str(det)]) = grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,depth+1:previous_depth);
        error_pt2.(['error' num2str(det)]) = grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,depth+1:previous_depth);
        params_pt2.(['params' num2str(det)]) = grasp_data(index).(['params' num2str(det)]){worksheet}(:,depth+1:previous_depth);
    end
    thickness_pt1 = grasp_data(index).thickness{worksheet}(1:depth-1);
    subtitle_pt1 = grasp_data(index).subtitle{worksheet}(:,1:depth-1);
    thickness_pt2 = grasp_data(index).thickness{worksheet}(depth+1:previous_depth);
    subtitle_pt2 = grasp_data(index).subtitle{worksheet}(:,depth+1:previous_depth);
    
    fields = fieldnames(grasp_data(index).info{worksheet});
    for n = 1:length(fields)
        info_pt1.([fields{n}]) = grasp_data(index).info{worksheet}.([fields{n}])(1:depth-1);
        info_pt2.([fields{n}]) = grasp_data(index).info{worksheet}.([fields{n}])(depth+1:previous_depth);
    end

    
    %Add the two parts of the storage worksheet back together
    grasp_data(index).dpth{worksheet} = grasp_data(index).dpth{worksheet} -1;
    new_depth = grasp_data(index).dpth{worksheet};
    
    %Put the collapsed matrix back in the main storage array
    for det = 1:inst_params.detectors
        grasp_data(index).(['data' num2str(det)]){worksheet} = data_pt1.(['data' num2str(det)]);
        grasp_data(index).(['data' num2str(det)]){worksheet}(:,:,depth:new_depth) = data_pt2.(['data' num2str(det)]);
        
        grasp_data(index).(['error' num2str(det)]){worksheet} = error_pt1.(['error' num2str(det)]);
        grasp_data(index).(['error' num2str(det)]){worksheet}(:,:,depth:new_depth) = error_pt2.(['error' num2str(det)]);
        
        grasp_data(index).(['params' num2str(det)]){worksheet} = params_pt1.(['params' num2str(det)]);
        grasp_data(index).(['params' num2str(det)]){worksheet}(:,depth:new_depth) = params_pt2.(['params' num2str(det)]);
    end
    grasp_data(index).thickness{worksheet} = thickness_pt1;
    grasp_data(index).subtitle{worksheet} = subtitle_pt1;
    grasp_data(index).thickness{worksheet}(depth:new_depth) = thickness_pt2;
    grasp_data(index).subtitle{worksheet}(depth:new_depth) = subtitle_pt2;
    for n = 1:length(fields)
        grasp_data(index).info{worksheet}.([fields{n}]) = info_pt1.([fields{n}]);
        grasp_data(index).info{worksheet}.([fields{n}])(depth:new_depth) = info_pt2.([fields{n}]);
    end
    
end

