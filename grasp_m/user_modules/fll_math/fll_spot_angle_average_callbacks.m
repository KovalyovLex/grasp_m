function fll_spot_angle_average_callbacks(to_do)

switch to_do
    
case 'choose_spot_pairs'
    
    %***** Collect the xy coordinates of the spots *****
    spot_coords = collect_points;
    
    %***** Now fit all the spots *****
    %Get spot fit window size
    i = findobj('tag','spot_angle_average_box_x');
    xwidth = str2num(get(i,'string'));
    i = findobj('tag','spot_angle_average_box_y');
    ywidth = str2num(get(i,'string'));
    
    %Auto fit all the spots
    fit_result = fit2d_spots(spot_coords,[xwidth,ywidth],1);
    
    %Take the x,y and err_x, err_y positions of the spot fits to calulate angles
    %spot_fit_positions = [x1,err_x1, y1,err_y1; x2,err_x2, y2,err_y2]
    %Number of PAIRS of Spots fitted
    number_spots = length(fit_result);
    %Make sure this is an even number in order to calculate angles, if necessary chops the last odd spot
    number_spots = (floor(number_spots/2)*2);
        
    for n = 1:number_spots;
        spot_fit_positions(n,:) = [fit_result{n}.values(3),fit_result{n}.err_values(3),fit_result{n}.values(4),fit_result{n}.err_values(4)];
    end
    
    %***** Now calculate angles between pairs *****
    cm = current_beam_centre;
    cm = cm.det1.cm_pixels;
    
    angle_list = fll_angle_between_spots(spot_fit_positions,cm);
    
    %***** Display Spot Coords in the terminal window *****
    disp(['You chose ' num2str(number_spots) ' spots.']);
    disp('Note: An initial odd number of spots is truncated by one');
    disp('Fitted Spot Coords:');
    for n = 1:number_spots;
        disp(['x: ' num2str(spot_fit_positions(n,1)) '  err_x: ' num2str(spot_fit_positions(n,2)) '  y: ' num2str(spot_fit_positions(n,3)) '  err_y: ' num2str(spot_fit_positions(n,4))]);
    end
    disp(' ')
    
    %Display all the Beta's + Errors
    l = size(angle_list);
    number_pairs_spots = l(1);
    disp(['You have ' num2str(number_pairs_spots) ' pair(s) of spots.']);
    disp('Spot Beta''s:');
    for n = 1:number_pairs_spots
        disp(['Beta: ' num2str(angle_list(n,1)) ' Err_Beta: ' num2str(angle_list(n,2))]);
    end
    disp(' ');
    
    %Finally, Caluclate the Average of all the angles
    beta_average = average_error(angle_list);    
    disp(['Average Beta: ' num2str(beta_average(1)) ' Err: ' num2str(beta_average(2))]);
    
    %Poke the result back into the window
    i = findobj('tag','spot_angle_average_beta'); set(i,'string',num2str(beta_average(1),'%3.4g'));
    i = findobj('tag','spot_angle_average_errbeta'); set(i,'string',num2str(beta_average(2),'%3.4g'));
    
    
end