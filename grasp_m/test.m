function data_out = test

global status_flags
global grasp_data
global inst_params
global displayimage

%Churn through the depth and extract box-sums
index = data_index(status_flags.selector.fw);
foreground_depth = status_flags.selector.fdpth_max - grasp_data(index).sum_allow;

data_store = zeros(inst_params.detector1.pixels(2),inst_params.detector1.pixels(1));

for n = 1:foreground_depth

    status_flags.selector.fd = n+grasp_data(index).sum_allow;
    main_callbacks('depth_scroll'); %Scroll all linked depths and update
   
    pause(0.1)
    
    data_store = data_store + displayimage.data1;
end


figure
pcolor(data_store)


