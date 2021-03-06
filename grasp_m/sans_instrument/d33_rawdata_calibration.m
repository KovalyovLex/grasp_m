function data = d33_rawdata_calibration(data)

global d33_detector_calibration

for det = [1,2,3,4,5];
        disp('Reading d33 detector calibration file')
        %Open the tube_peak_fit file
        
        if det ==1; %rear
            %fid = fopen('d33_tube_peak_fit_det1.dat');
            fid = fopen('d33_tube_peak_fit_det1(July2014).dat');
            
            
            n_tubes = 128;
        elseif det == 4; %bottom
            %fid = fopen('d33_tube_peak_fit_det_bottom.dat');
            fid = fopen('d33_tube_peak_fit_det_bottom(July2014).dat');
            n_tubes = 32;
        elseif det == 5; %top
            fid = fopen('d33_tube_peak_fit_det_top.dat');
            %fid = fopen('d33_tube_peak_fit_det_top(July2014).dat');
            n_tubes = 32;
        elseif det == 2; %right
            %fid = fopen('d33_tube_peak_fit_det_right.dat');
            fid = fopen('d33_tube_peak_fit_det_right(July2014).dat');
            n_tubes = 32;
        elseif det == 3; %left
            fid = fopen('d33_tube_peak_fit_det_left.dat');
            n_tubes = 32;
        end
        
        if fid ==-1
            disp('No peak-fit data found:  Exiting')
            return
        end
        %Peak fit file should be all numeric for ease of reading
        %First line contains aperture positions in mm from left to right of the detector
        %e.g.   1   50  100 150 .....
        %Then tube number goes down the file corresponding to TOP to BOTTOM or rear D33 detector
        %while horizontally are the raw data fit positions in raw pixels corresping to the
        %aperture postion in mm
        
        %Read the aperture positions
        line_str = fgetl(fid);
        d33_detector_calibration.aperture_pos = str2num(line_str);
        %Read the fit positions for all tubes
        fit_positions = zeros(n_tubes,length(d33_detector_calibration.aperture_pos));
        for tube = 1:n_tubes;
            line_str = fgetl(fid);
            line_data = str2num(line_str);
            fit_positions(tube,:) = line_data;
        end
        d33_detector_calibration.fit_positions = fit_positions;
        fclose(fid);
    
    
    raw_pixel_list = 1:1:256;
    
    %Generate real physical positions (mm) for the raw pixel left, centre and
    %right based on the fitted peak positions vs raw pixel readout
    
    %Now Re-bin to new array
    pixels = 256;
    pixel_size = 2.5; %mm
    offset = 0; %mm Shifts the image Left-Right in the new array
        
    old_data = data.(['data' num2str(det)]);
    new_data = zeros(size(old_data));
    
    for tube = 1:n_tubes %(Bottom to Top)
        
        %Interpolate the new positions in mm
        old_pix_left = interp1(d33_detector_calibration.fit_positions(tube,:),d33_detector_calibration.aperture_pos,raw_pixel_list-0.5,'spline');
        old_pix_right = interp1(d33_detector_calibration.fit_positions(tube,:),d33_detector_calibration.aperture_pos,raw_pixel_list+0.5,'spline');
        
        %   old_pix_left = interp1(d33_detector_calibration.fit_positions(tube,:),d33_detector_calibration.aperture_pos,raw_pixel_list-0.5,'cubic','extrap');
        %  old_pix_right = interp1(d33_detector_calibration.fit_positions(tube,:),d33_detector_calibration.aperture_pos,raw_pixel_list+0.5,'cubic','extrap');
        
        %  old_pix_left = interp1(d33_detector_calibration.fit_positions(tube,:),d33_detector_calibration.aperture_pos,raw_pixel_list-0.5,'linear','extrap');
        %  old_pix_right = interp1(d33_detector_calibration.fit_positions(tube,:),d33_detector_calibration.aperture_pos,raw_pixel_list+0.5,'linear','extrap');
        
        
        
        %Run along (left-right) each tube re-binning
        for new_pixel = 1:pixels
            %for new_pixel = 132:132
            
            new_pix_left = (new_pixel-1)*pixel_size + offset;
            new_pix_right = new_pixel*pixel_size+offset;
            
            %Case1
            %Find all old pixels that fully fall within the new pixel
            temp = find(old_pix_right <= new_pix_right & old_pix_left >= new_pix_left);
            if not(isempty(temp))
                for n = 1:length(temp)
                    if det == 1 || det == 4 || det == 5 %horizonal tubes
                        new_data(tube,new_pixel) = new_data(tube,new_pixel) + old_data(tube,temp(n));
                    elseif det == 2 || det == 3 %vertical tubes
                        new_data(new_pixel,tube) = new_data(new_pixel,tube) + old_data(temp(n),tube);
                    end
                end
            end
            
            %Case2
            %Find the old pixel that spans the new pixel top boundary
            temp = find(old_pix_right >= new_pix_right & old_pix_left < new_pix_right & old_pix_left >= new_pix_left);
            if not(isempty(temp))
                %Find fraction of the pixel covered
                fraction = (new_pix_right - old_pix_left(temp)) / (old_pix_right(temp) - old_pix_left(temp));
                if det == 1 || det == 4 || det == 5 %horizonal tubes
                    new_data(tube,new_pixel) = new_data(tube,new_pixel) + old_data(tube,temp) * fraction;
                elseif det == 2 || det == 3 %vertical tubes
                    new_data(new_pixel,tube) = new_data(new_pixel,tube) + old_data(temp,tube) * fraction;
                end
            end
            
            %Case3
            %Find all old pixel that spans the new pixel bottom
            temp = find(old_pix_left < new_pix_left & old_pix_right >= new_pix_left & old_pix_right < new_pix_right);
            if not(isempty(temp))
                %Find fraction of the pixel covered
                fraction = (old_pix_right(temp) - new_pix_left) / (old_pix_right(temp) - old_pix_left(temp));
                if det == 1 || det == 4 || det == 5 %horizonal tubes
                    new_data(tube,new_pixel) = new_data(tube,new_pixel) + old_data(tube,temp) * fraction;
                elseif det == 2 || det == 3 %vertical tubes
                    new_data(new_pixel,tube) = new_data(new_pixel,tube) + old_data(temp,tube) * fraction;
                end    
            end
            
            %Case4
            %Find old pixel that completely spans the new pixel
            temp = find(old_pix_right >= new_pix_right & old_pix_left < new_pix_left);
            
            if not(isempty(temp))
                %Find fraction of the pixel covered
                fraction = (new_pix_right - new_pix_left) / (old_pix_right(temp) - old_pix_left(temp));
                if det == 1 || det == 4 || det == 5 %horizonal tubes
                    new_data(tube,new_pixel) = new_data(tube,new_pixel) + old_data(tube,temp) * fraction;
                elseif det == 2 || det == 3 %vertical tubes
                    new_data(new_pixel,tube) = new_data(new_pixel,tube) + old_data(temp,tube) * fraction;
                end
            end
            new_data = round(new_data);
        end

    end
    
    data.(['data' num2str(det)]) = new_data;
    
end
