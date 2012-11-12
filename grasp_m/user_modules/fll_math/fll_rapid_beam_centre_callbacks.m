function fll_rapid_beam_centre_callbacks(to_do)

switch to_do
    
    
case 'take4'
    %Coose 4 spots with which to fit and calcualte the beam centre
    
    %***** Collect the xy coordinates of the spots *****
    spot_coords = collect_points(4);
    
    %***** Now fit all the spots *****
    %Get spot fit window size
    i = findobj('tag','fll_rapid_beamcentre_box_x');
    xwidth = str2num(get(i,'string'));
    i = findobj('tag','fll_rapid_beamcentre_box_y');
    ywidth = str2num(get(i,'string'));
    
    %Auto fit all the spots
    fit_result = fit2d_spots(spot_coords,[xwidth,ywidth],1);
    
    %***** Calcualte the new beam centre *****
    x1 = fit_result{1}.values(3); dx1 = fit_result{1}.err_values(3);
    y1 = fit_result{1}.values(4); dy1 = fit_result{1}.err_values(4);
    
    x2 = fit_result{2}.values(3); dx2 = fit_result{2}.err_values(3);
    y2 = fit_result{2}.values(4); dy2 = fit_result{2}.err_values(4);
   
    x3 = fit_result{3}.values(3); dx3 = fit_result{3}.err_values(3);
    y3 = fit_result{3}.values(4); dy3 = fit_result{3}.err_values(4);

    x4 = fit_result{4}.values(3); dx4 = fit_result{4}.err_values(3);
    y4 = fit_result{4}.values(4); dy4 = fit_result{4}.err_values(4);

    %Calculate the gradients
    m_A = (y2 - y1)/(x2 - x1);
    m_B = (y4 - y3)/(x4 - x3);
    
    %Calculate the intercepts
    c_A = y1 - (m_A)*x1;
    c_B = y3 - (m_B)*x3;
    
    %Calculate the beam centre
    x0 = (c_B - c_A)/(m_A - m_B);
    y0 = (m_A)*(x0) + c_A;
    
    %Sticking the new coordinates in the display window
    i = findobj('tag','rapid_x0'); set(i(1),'string',num2str(x0));
    i = findobj('tag','rapid_y0'); set(i(1),'string',num2str(y0));

    disp('Beam Centre co-ordinates (Pixels)');
    disp(['centre_x = ' num2str(x0)]);
    disp(['centre_y = ' num2str(y0)]);
    
    %Poke new beam centre to main display and beam centre array
    cm_data.cx = x0; cm_data.cy = y0;
    main_callbacks('cm_poke', cm_data);
end