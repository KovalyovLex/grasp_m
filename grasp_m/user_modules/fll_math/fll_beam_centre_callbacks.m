function fll_beam_centre_callbacks(to_do,option)

global fit_parameters

switch to_do
    
    case 'load'
        
        i=findobj('tag',['x' num2str(option)]);
        set(i(1),'string',num2str(fit_parameters.values(3)));
        i=findobj('tag',['dx' num2str(option)]);
        set(i(1),'string',num2str(fit_parameters.err_values(3)));
        i=findobj('tag',['y' num2str(option)]);
        set(i(1),'string',num2str(fit_parameters.values(4)));
        i=findobj('tag',['dy' num2str(option)]);
        set(i(1),'string',num2str(fit_parameters.err_values(4)));
        
    case 'centre_calc'
        
        %capture spot coordinates and corresponding errors from the ui window
        i = findobj('tag','x1'); x1 = str2num(get(i(1),'string'));
        i = findobj('tag','y1'); y1 = str2num(get(i(1),'string'));
        i = findobj('tag','x2'); x2 = str2num(get(i(1),'string'));
        i = findobj('tag','y2'); y2 = str2num(get(i(1),'string'));
        i = findobj('tag','dx1'); dx1 = str2num(get(i(1),'string'));
        i = findobj('tag','dy1'); dy1 = str2num(get(i(1),'string'));
        i = findobj('tag','dx2'); dx2 = str2num(get(i(1),'string'));
        i = findobj('tag','dy2'); dy2 = str2num(get(i(1),'string'));
        i = findobj('tag','x3'); x3 = str2num(get(i(1),'string'));
        i = findobj('tag','y3'); y3 = str2num(get(i(1),'string'));
        i = findobj('tag','x4'); x4 = str2num(get(i(1),'string'));
        i = findobj('tag','y4'); y4 = str2num(get(i(1),'string'));
        i = findobj('tag','dx3'); dx3 = str2num(get(i(1),'string'));
        i = findobj('tag','dy3'); dy3 = str2num(get(i(1),'string'));
        i = findobj('tag','dx4'); dx4 = str2num(get(i(1),'string'));
        i = findobj('tag','dy4'); dy4 = str2num(get(i(1),'string'));

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
        i = findobj('tag','x0'); set(i(1),'string',num2str(x0));
        i = findobj('tag','y0'); set(i(1),'string',num2str(y0));

        disp('Beam Centre co-ordinates (Pixels)');
        disp(['centre_x = ' num2str(x0)]);
        disp(['centre_y = ' num2str(y0)]);

        %Poke new beam centre to main display and beam centre array
        cm_data.cx = x0; cm_data.cy = y0;
        main_callbacks('cm_poke', cm_data);
        
end
