 function new_shift_image = d22_detector(image_data,params);


%***** Read Calibration Data from File *****
disp(' ');
disp('Reading Detector Tube Calibration File');
fid = fopen('d22detlines.cal');
text = fgetl(fid); %Skip 3 lines
text = fgetl(fid);
text = fgetl(fid);
%Read re-binning data, i.e. parameters about the detector and new bin requirements
text = fgetl(fid);
temp = str2num(text);

if nargin < 2;
    cad_spacing = temp(1); pixel_y_size = temp(2); number_new_pixels = temp(3);
else
    cad_spacing = params(1); pixel_y_size = params(2); number_new_pixels = params(3);
end
    
text = fgetl(fid); %Skip 2 lines
text = fgetl(fid);
%Read Calibration Data
tube_data = [];
for tube = 1:128;
    text = fgetl(fid);
    tube_data(tube,:) = str2num(text);  %Tube data is Tube, Bottom, Top
end
fclose(fid);

disp(['New Pixel y-size : ' num2str(pixel_y_size)]);
disp(['Rebinning D22 Detector Data to : ' num2str(number_new_pixels)]);
disp(['Detector Limit Spacing (Cd) : ' num2str(cad_spacing)]);
disp(' ');


%***** Calculate new REBINNED with fractional binning (Note, NOT interpolated) D22 detector data *****

%Blank Matricies to store the Rebinned data
new_image = zeros(number_new_pixels,128); %Blank matrix
new_shift_image = zeros(number_new_pixels,128);

%Keep a track of the maximum active line length.
%Used to calcualte the image shift into the centre of the picture, for niceness.
max_line_length = 0; 

%Remember, top = tube_data(:,3), bottom = tube_data(:,2)
%These are the positions of the Cd mask on the detector measured to be 'cad_spacing'=980mm apart.
old_pixel_y_size = cad_spacing ./ (tube_data(:,3)-tube_data(:,2)); %Vector 128 long as the effective OLD pixel size for each tube is slightly different, but about 4mm
line_y = 1:256; %Old Pixel Indicies

%Relative pixel size, old data to new data
relative_pixel_size = pixel_y_size ./ old_pixel_y_size(:); %Vector 128 long as the effective OLD pixesl size for each tube is slightly different, but reltive size will be something like 1.95, i.e. 8mm / 4.1mm for example

%***** Churn though the data Line by Line *****
%NOTE:It seems that my old pixel numbering is starting from the bottom side of the old pixels.
for tube = 1:128;
    
    %Get the line data from to be corrected from the currently displayed image in Grasp
    line_data = image_data(:,tube); %This is full vertical line at tube 'tube'
    first_new_pixel_bottom = tube_data(:,2).*relative_pixel_size;
    
    %***** Work up the line adding re-binning the counts along the way *****
    pixel_bottom = tube_data(tube,2); %This is the first pixel bottom position, in units of the old pixel numbering
    pixel_top = pixel_bottom; %Just assign anything that will let it pass though the WHILE the first time
    new_pixel_counter = 1; %First new pixel index
    
    while pixel_top < tube_data(tube,3)
        
        %Find the old pixel values that more than cover the new pixel
        pixel_top = pixel_bottom + relative_pixel_size(tube); %i.e 1 new pixel wide but in units of the old pixel numbering
        
        if floor(pixel_bottom) == floor(pixel_top)
            %Case of over-binning data, i.e. slightly smaller new bins compared to old bins
            sole_pixel_fraction = pixel_top-pixel_bottom;
            sole_pixel_fraction_counts = line_data(floor(pixel_bottom))*sole_pixel_fraction;
            new_image(new_pixel_counter,tube) = sole_pixel_fraction_counts;
        else
            %Normal case where the pixel boundaries span two or more old pixels
            
            %Whole pixels to sum
            whole_pixels = ceil(pixel_bottom):(floor(pixel_top)-1); %This is a list of pixel indicies to be summed in full
            if not(isempty(whole_pixels));
                whole_pixel_counts = sum(line_data(whole_pixels));
            else
                whole_pixel_counts = 0;
            end
            
            %Bottom fractional pixels
            bottom_fraction = 1-(pixel_bottom - floor(pixel_bottom)); %This is the fraction of the bottom side pixel to take
            bottom_fraction_counts = bottom_fraction*line_data(floor(pixel_bottom));
            
            %Top fractional pixels
            top_fraction = (pixel_top - floor(pixel_top)); %This is the fraction of the top side pixel to take
            top_fraction_counts = top_fraction*line_data(floor(pixel_top));
            
            %Put the total new counts into the new array at position 'new_pixel_counter'
            new_image(new_pixel_counter,tube) = whole_pixel_counts + bottom_fraction_counts + top_fraction_counts;
        end
        
        %Increment the counters and pixel bottom and top postions ready for the next pixel
        new_pixel_counter = new_pixel_counter +1;
        pixel_bottom = pixel_top;
        %pixel_top will be re_calculated in the loop
    end
    
    if new_pixel_counter > max_line_length; max_line_length = new_pixel_counter; end
end

%***** Shift the new interpolated image into the centre of the image, Just for niceness. *****
%Number of spare lines
spare_lines = number_new_pixels - max_line_length;
y_shift = floor(spare_lines/2);
new_shift_image((y_shift+1):number_new_pixels,:) = new_image(1:(number_new_pixels-y_shift),:);

%***** Finally, take the 'Round' of the new interpolated detector data to give integer counts. *****
%We do not actually know whether we should do this or should leave non-integer counts
new_shift_image = round(new_shift_image);
