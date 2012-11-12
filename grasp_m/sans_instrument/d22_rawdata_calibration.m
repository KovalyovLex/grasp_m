function new_data = d22_rawdata_calibration(data)

%Open the tube_peak_fit file
fid = fopen('d22_tube_peak_fit.dat');
if fid ==-1
    disp('No peak-fit data found:  Exiting')
    return
end

%Peak fit file should be all numeric for ease of reading
%First line contains aperture positions in mm from the bottom of the detector
%e.g.   1   50  100 150 .....
%Then tube number goes down the file
%while horizontally are the raw data fit positions in raw pixels corresping to the
%aperture postion in mm

%Read the aperture positions
line_str = fgetl(fid);
aperture_pos = str2num(line_str);

%Read the fit positions for all tubes
fit_positions = [];
for tube = 1:128;
    line_str = fgetl(fid);
    line_data = str2num(line_str);
    fit_positions(tube,:) = line_data;
end
fclose(fid);


raw_pixel_list = 1:1:256;


%Generate real physical positions (mm) for the raw pixel bottom, centre and
%top based on the fitted peak positions vs raw pixel readout

%Now Re-bin to new array
pixels = 256;
pixel_size = 4; %mm
offset = -12; %mm Shifts the image up in the new array


new_data = zeros(pixels,128);
for tube = 1:128

    %Interpolate the new positions in mm
    old_pix_bottom = interp1(fit_positions(tube,:),aperture_pos,raw_pixel_list-0.5,'spline');
    old_pix_top = interp1(fit_positions(tube,:),aperture_pos,raw_pixel_list+0.5,'spline');

    %Run up each tube re-binning
    for new_pixel = 1:pixels
        new_pix_bottom = (new_pixel-1)*pixel_size + offset;
        new_pix_top = new_pixel*pixel_size+offset;
        
        %Case1
        %Find all old pixels that fully fall within the new pixel
        temp = find(old_pix_top <= new_pix_top & old_pix_bottom >= new_pix_bottom);
        if not(isempty(temp))
            for n = 1:length(temp)
                new_data(new_pixel,tube) = new_data(new_pixel,tube) + data(temp(n),tube);
            end
        end
        
        %Case2
        %Find the old pixel that spans the new pixel top boundary
        temp = find(old_pix_top >= new_pix_top & old_pix_bottom < new_pix_top & old_pix_bottom >= new_pix_bottom);
        if not(isempty(temp))
            %Find fraction of the pixel covered
            fraction = (new_pix_top - old_pix_bottom(temp)) / (old_pix_top(temp) - old_pix_bottom(temp));
            new_data(new_pixel,tube) = new_data(new_pixel,tube) + data(temp,tube) * fraction;
        end
        
        %Case3
        %Find all old pixel that spans the new pixel bottom 
        temp = find(old_pix_bottom < new_pix_bottom & old_pix_top >= new_pix_bottom & old_pix_top < new_pix_top);
        if not(isempty(temp))
            %Find fraction of the pixel covered
            fraction = (old_pix_top(temp) - new_pix_bottom) / (old_pix_top(temp) - old_pix_bottom(temp));
            new_data(new_pixel,tube) = new_data(new_pixel,tube) + data(temp,tube) * fraction;
        end
        
        %Case4
        %Find old pixel that completely spans the new pixel
        temp = find(old_pix_top >= new_pix_top & old_pix_bottom < new_pix_bottom);

        if not(isempty(temp))
            %Find fraction of the pixel covered
            fraction = (new_pix_top - new_pix_bottom) / (old_pix_top(temp) - old_pix_bottom(temp));
            new_data(new_pixel,tube) = new_data(new_pixel,tube) + data(temp,tube) * fraction;
        end
        
    end
   
end

 