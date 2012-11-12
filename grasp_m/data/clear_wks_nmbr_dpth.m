function clear_wks_nmbr_dpth(wks,number,depth)

%wks is worksheet type
%number is worksheet number
%depth is worksheet depth

global grasp_data
global inst_params

index = data_index(wks);
disp(['Clearing Worksheet:  ' grasp_data(index).name ' #' num2str(number) ' Depth #' num2str(depth)]); 
disp('  ');

for det = 1: inst_params.detectors
    grasp_data(index).(['data' num2str(det)]){number}(:,:,depth) = zeros(inst_params.(['detector' num2str(det)]).pixels(2), inst_params.(['detector' num2str(det)]).pixels(1));
    grasp_data(index).(['error' num2str(det)]){number}(:,:,depth) = zeros(inst_params.(['detector' num2str(det)]).pixels(2), inst_params.(['detector' num2str(det)]).pixels(1));
    grasp_data(index).(['params' num2str(det)]){number}(:,depth) = zeros(128,1);
end
