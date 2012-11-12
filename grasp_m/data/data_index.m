function index = data_index(type)

global grasp_data

index = [];
for n = 1:length(grasp_data)
    if type == grasp_data(n).type; index = n; return; end
end

