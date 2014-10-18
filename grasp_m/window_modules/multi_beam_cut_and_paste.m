function multi_beam_cut_and_paste


global status_flags
global grasp_data

new_worksheet = 6;

%Find current worksheet indicies
index = data_index(status_flags.selector.fw);
current_data = grasp_data(index).data1{status_flags.selector.fn}(:,:,status_flags.selector.fd);
current_error = grasp_data(index).error1{status_flags.selector.fn}(:,:,status_flags.selector.fd);

%Find current I0 worksheet
index_i0 = data_index(status_flags.calibration.beam_worksheet); 
current_i0_data = grasp_data(index_i0).data1{status_flags.selector.fn}(:,:,status_flags.selector.fd);
current_i0_error = grasp_data(index_i0).error1{status_flags.selector.fn}(:,:,status_flags.selector.fd);

%Find current Mask worksheet
index_mask = data_index(7); %type 7 = mask


%Find Main Beam Center
det_cms = current_beam_centre;
cm = det_cms.det1.cm_pixels;

%Calculate pixel coords for full current data
temp = size(current_data);
[coords_x,coords_y] = meshgrid(1:temp(2),1:temp(1)); %Raw Pixel array coords

%Calculate the beam-centered (central beam) coords for the full current data
centered_pixel_x = coords_x - cm(1);
centered_pixel_y = coords_y - cm(2);


%Empty new data arrays
new_data = zeros(size(current_data));
new_error = zeros(size(current_data));

new_i0_data = zeros(size(current_data));
new_i0_error = zeros(size(current_data));

redundant_mask = zeros(size(current_data)); 

box_size = [50,25]; %[x,y] pixels  - 9 Beams
%box_size = [34,17]; %[x,y] pixels  - 25 Beams



for beam = 1:status_flags.analysis_modules.multi_beam.number_beams
    
    %Find beam center for this box
    box_center = [status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(beam)]).cx, status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(beam)]).cy];
    box_coords = [box_center(1)-box_size(1)/2, box_center(1)+box_size(1)/2, box_center(2)-box_size(2)/2, box_center(2)+box_size(2)/2]; %[x1,x2,y1,y2]
    box_coords = round(box_coords);

    %Cut out the data for this box
    cut_data = current_data(box_coords(3):box_coords(4),box_coords(1):box_coords(2));
    cut_error = current_error(box_coords(3):box_coords(4),box_coords(1):box_coords(2));
    
    %Cut out the I0 data for this box
    cut_i0_data = current_i0_data(box_coords(3):box_coords(4),box_coords(1):box_coords(2));
    cut_i0_error = current_i0_error(box_coords(3):box_coords(4),box_coords(1):box_coords(2));
    
    %Raw pixel coords for this box
    box_pixel_x = coords_x(box_coords(3):box_coords(4),box_coords(1):box_coords(2));
    box_pixel_y = coords_y(box_coords(3):box_coords(4),box_coords(1):box_coords(2));
    
    %Center the box coords on the new central beam position
    box_pixel_x = box_pixel_x - box_center(1) + cm(1);
    box_pixel_y = box_pixel_y - box_center(2) + cm(2);
    
    %Interpolate data to match new shifted matrix
    z = interp2(box_pixel_x,box_pixel_y,cut_data,coords_x,coords_y);
    ez = interp2(box_pixel_x,box_pixel_y,cut_error,coords_x,coords_y);
    
    i0 = interp2(box_pixel_x,box_pixel_y,cut_i0_data,coords_x,coords_y);
    ei0 = interp2(box_pixel_x,box_pixel_y,cut_i0_error,coords_x,coords_y);

    %Add the image together
    temp = find(not(isnan(z))); %find all valid data (i.e the box that was cut-pasted)
    
    new_data(temp) = new_data(temp)+z(temp); %data
    new_error(temp) = sqrt( new_error(temp).^2 + ez(temp).^2); %error
    
    new_i0_data(temp) = new_i0_data(temp)+i0(temp); %data
    new_i0_error(temp) = sqrt( new_i0_error(temp).^2 + ei0(temp).^2); %error
    
    %Un-mask where there was any valid data
    redundant_mask(temp) = 1;
    
    
end



%Now Put new data back into worksheet new_worksheet
grasp_data(index).data1{new_worksheet}(:,:,status_flags.selector.fd) = new_data;
grasp_data(index).error1{new_worksheet}(:,:,status_flags.selector.fd) = new_error;

grasp_data(index_i0).data1{new_worksheet}(:,:,status_flags.selector.fd) = new_i0_data;
grasp_data(index_i0).error1{new_worksheet}(:,:,status_flags.selector.fd) = new_i0_error;

grasp_data(index_mask).data1{new_worksheet}(:,:) = redundant_mask; %auto generate mask


%Also copy any necessary parameters
grasp_data(index).params1{new_worksheet} = grasp_data(index).params1{status_flags.selector.fn}(:,status_flags.selector.fd);
grasp_data(index).cm1{new_worksheet}.cm_pixels = grasp_data(index).cm1{status_flags.selector.fn}.cm_pixels(status_flags.selector.fd,:);
grasp_data(index).load_string{new_worksheet} = grasp_data(index).load_string{status_flags.selector.fn};

grasp_data(index_i0).params1{new_worksheet} = grasp_data(index_i0).params1{status_flags.selector.fn}(:,status_flags.selector.fd);
%grasp_data(index_i0).cm1{new_worksheet}.cm_pixels = grasp_data(index_i0).cm1{status_flags.selector.fn}.cm_pixels(status_flags.selector.fd,:);
grasp_data(index_i0).load_string{new_worksheet} = grasp_data(index_i0).load_string{status_flags.selector.fn};


    