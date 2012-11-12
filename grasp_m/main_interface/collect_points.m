function [coords] = collect_points(number_points)

global grasp_handles
global status_flags

%Make the main figure active
figure(grasp_handles.figure.grasp_main);

spot_coords = []; %Store of all the spot coordinates
%Infinate Loop Spot Collect
if nargin <1; %i.e. infinate loop until ESC
    text_handle1 = grasp_message('Click on Coordinates, (ESC) to Exit',1,'main');
    spot_number = 1;
    endflag =0;
    while endflag ==0;
        text_handle1 = grasp_message('Click on Coordinates, (ESC) to Exit',1,'main');
        text_handle2 = grasp_message(['Click on Coordinates No. ' num2str(spot_number)],2,'main'); %Grasp Text Message
        event=waitforbuttonpress;
        if event == 0 & gcf == grasp_handles.figure.grasp_main %i.e. when mouse button was pressed, was it on the correct figure?  If not, terminate loop anyway
            ax = status_flags.display.active_axis;
            temp = get(grasp_handles.displayimage.(['axis' num2str(ax)]),'currentpoint');
            coords(spot_number,1) = temp(1,1);
            coords(spot_number,2)= temp(1,2);
            spot_number = spot_number+1;
        else
            endflag = 1;
            break
        end
        delete(text_handle2);
    end
    delete(text_handle2);
    

%Finite Loop Spot Collect
else
    number_points = floor(number_points); %Just incase it is not integer
    for spot_number = 1:number_points
        text_handle1 = grasp_message(['Click on Coordniates No. ' num2str(spot_number) ' of ' num2str(number_points)],1,'main'); %Grasp Text Message
        event=waitforbuttonpress;
        if event == 0 & gcf == grasp_handles.figure.grasp_main %i.e. when mouse button was pressed, was it on the correct figure?  If not, terminate loop anyway
            ax = status_flags.display.active_axis;
            temp = get(grasp_handles.displayimage.(['axis' num2str(ax)]),'currentpoint');
            coords(spot_number,1) = temp(1,1);
            coords(spot_number,2)= temp(1,2);
        else
            spot_number = spot_number - 1;
        end
        delete(text_handle1);
    end
end


