function fll_anisotropy_callbacks(to_do)

global fit_parameters

switch to_do
    
    case 'load_cm'
        
        cm = current_beam_centre;
        cm = cm.det1.cm_pixels;
        i = findobj('tag','anisotropy_cx');
        set(i,'string',num2str(cm(1)));
        i = findobj('tag','anisotropy_cy');
        set(i,'string',num2str(cm(2)));
        
        
        %Spot Fit Version
    case 'load_spot'
        
        spot_number = get(gcbo,'userdata');
        i = findobj('tag',['anisotropy_s' num2str(spot_number) 'x']);
        set(i,'string',num2str(fit_parameters.values(3)));
        i = findobj('tag',['anisotropy_s' num2str(spot_number) 'ex']);
        set(i,'string',num2str(fit_parameters.err_values(3)));
        i = findobj('tag',['anisotropy_s' num2str(spot_number) 'y']);
        set(i,'string',num2str(fit_parameters.values(4)));
        i = findobj('tag',['anisotropy_s' num2str(spot_number) 'ey']);
        set(i,'string',num2str(fit_parameters.err_values(4)));
        
    case 'clear_spots'
        %collect all the spot coords
        for spot = 1:6;
            i = findobj('tag',['anisotropy_s' num2str(spot) 'x']);
            set(i,'string','0');
            i = findobj('tag',['anisotropy_s' num2str(spot) 'ex']);
            set(i,'string','0');
            i = findobj('tag',['anisotropy_s' num2str(spot) 'y']);
            set(i,'string','0');
            i = findobj('tag',['anisotropy_s' num2str(spot) 'ey']);
            set(i,'string','0');
        end
        
        
    case 'plot_x2y2'
        
        %collect the beam centre
        i = findobj('tag','anisotropy_cx');
        cm(1) = str2num(get(i,'string'));
        i = findobj('tag','anisotropy_cy');
        cm(2) = str2num(get(i,'string'));
        
        %collect all the spot coords
        index = 1;
        for spot = 1:6;
            i = findobj('tag',['anisotropy_s' num2str(spot) 'x']);
            xtemp = str2num(get(i,'string'));
            i = findobj('tag',['anisotropy_s' num2str(spot) 'ex']);
            extemp = str2num(get(i,'string'));
            i = findobj('tag',['anisotropy_s' num2str(spot) 'y']);
            ytemp = str2num(get(i,'string'));
            i = findobj('tag',['anisotropy_s' num2str(spot) 'ey']);
            eytemp = str2num(get(i,'string'));
            %Check for unfilled Spot Boxes (check for all zeros)
            if xtemp ~=0 | ytemp ~=0;
                x(index) = xtemp; ex(index) = extemp; y(index) = ytemp; ey(index) = eytemp;
                index = index +1;
            end
        end
        
        %Subtract Beam Centre from spot coords
        x = x -cm(1);
        y = y -cm(2);
        
        %Square the coords with errors
        [x2, ex2] = err_power(x,ex,2);
        [y2, ey2] = err_power(y,ey,2);
        
        %Plot X2 Y2
        
        global grasp_debug
        if grasp_debug == 1;
            disp(' ');
            disp('''anisotropy_callbacks'' has Plot&Export vs. Chuck_plot code compatibility fixes');
            disp(' ');
        end
        
        plotdata = [rot90(x2),rot90(y2),rot90(ey2)];
        column_format = 'xye';
        exportdata = plotdata; %data array to be exported
        plottitle = 'Ellipse Anisotropy Analysis'; x_label = 'X^2'; y_label = 'Y^2';
        
        %Try chuck's new plotting routine
        
        
        plot_params = struct('export_data',exportdata,...
            'x_label',x_label,'y_label',y_label,'plot_title',plottitle,...
            'plot_type','plot','hold_graph','off','legend_str',' ');
        grasp_plot(plotdata,column_format,plot_params);
        
        %Fit the data
        fit1d(3);
        
        gradient = fit_parameters.values(2);
        err_gradient = fit_parameters.err_values(2);
        
        [epsilon,err_epsilon] = err_power(-gradient,err_gradient,-0.5);
        
        %find measurement angle
        i = findobj('tag','anisotropy_angle');
        angle = str2num(get(i,'string')); %Degrees
        angle = angle*pi / 180; %Radians
        
        %Gamma calculation
        [epsilon_squared, err_epsilon_squared] = err_power(epsilon, err_epsilon, 2);
        
        numerator = epsilon_squared * (sin(angle))^2;
        err_numerator = err_epsilon_squared * (sin(angle))^2;
        
        denominator = 1-(epsilon_squared*(cos(angle))^2);
        err_denominator = (err_epsilon_squared*(cos(angle))^2);
        
        [gamma_squared, err_gamma_squared] = err_divide(numerator,err_numerator,denominator,err_denominator);
        [gamma, err_gamma] = err_power(gamma_squared, err_gamma_squared, 0.5);
        
        
        disp(['Epsilon = ' num2str(epsilon) ', Err_Epsilon = ' num2str(err_epsilon)]);
        disp(['Gamma = ' num2str(gamma) ', Err_Gamma = ' num2str(err_gamma)]);
        
        
        
    case 'anisotropy_auto_spots_fit'
        
        %Make the main Grasp window the current window
        main_figure_handle = findobj('tag','grasp_main');
        figure(main_figure_handle);
        
        for spot = 1:6
            
            text_handle = grasp_message(['Click on Spot No. ' num2str(spot)],1,'main'); %Grasp Text Message
            [x(spot) y(spot)]=ginput(1); %Mouse input
            delete(text_handle);
        end
        
        
        %***** Now fit all the spots *****
        %Get spot fit window size
        i = findobj('tag','anisotropy_auto_box_x');
        xwidth = str2num(get(i,'string'));
        i = findobj('tag','anisotropy_auto_box_y');
        ywidth = str2num(get(i,'string'));
        
        %Loop though 6 spots
        for spot = 1:6
            %zoom in
            axis_lims = [x(spot)-xwidth/2, x(spot)+xwidth/2, y(spot)-ywidth/2, y(spot)+ywidth/2]
            
            %Reset the original axis limits
            tool_callbacks('poke_scale',axis_lims);
            
            %Fit 2D Gaussian
            fit2d(1); %Function number 1
            %Wait - for display purposes
            pause(0.2)
            
            %Poke the x-cord and y-cord results into the anisotropy window
            i = findobj('tag',['anisotropy_s' num2str(spot) 'x']);
            set(i,'string',num2str(fit_parameters.values(3)));
            i = findobj('tag',['anisotropy_s' num2str(spot) 'ex']);
            set(i,'string',num2str(fit_parameters.err_values(3)));
            i = findobj('tag',['anisotropy_s' num2str(spot) 'y']);
            set(i,'string',num2str(fit_parameters.values(4)));
            i = findobj('tag',['anisotropy_s' num2str(spot) 'ey']);
            set(i,'string',num2str(fit_parameters.err_values(4)));
        end
        
        %Now do the Plot X2 Y2 and fit.
        fll_anisotropy_callbacks('plot_x2y2');
        
end
