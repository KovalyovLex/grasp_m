function fit_params_list = fit2d_spots(coords,boxsizes,function_number)

%Coords should be xy pairs of PIXEL coordinates.
%e.g.
%x1,y1
%x2,y2
%x3,y3

%boxsizes should be xy pairs of PIXEL coordinates.
%e.g.
%wx1,wy1
%wx2,wy2
%wx3,wy3
%if only on width is specified this is used for all the spots

%function_number specifies which 2D fit function to fit.  If not specified the default is 3 (old Polar fit in Cartesian coords)

global fit_parameters

if nargin <3;function_number = 1;end
if nargin <2; boxsizes = [10,10]; end %Pixels

if nargin <1
    disp('fit2d_spots needs you to give it some data, spot coordinates and box size');
else

    [number_spots,temp] = size(coords);
    [number_boxsizes,temp] = size(boxsizes);
    if number_boxsizes ~= number_spots
        boxsizes = ones(number_spots,2).*boxsizes(1,1);
    end
    
    %Remember original axis coords
    old_axis_lims = current_axis_limits;

    %Loop and fit2D all the spots
    for spot = 1:number_spots
        
        %Set axis limits to zoom in on spot
        axis_lims = [coords(spot,1)-(boxsizes(spot,1)/2), coords(spot,1)+(boxsizes(spot,1)/2), coords(spot,2)-(boxsizes(spot,2)/2), coords(spot,2)+(boxsizes(spot,2)/2)];
        tool_callbacks('poke_scale',axis_lims);
            
        %Fit 2D Function, using auto guess
        fit2d(function_number);
        %Wait - for display purposes    
        pause(0.2);
        
        fit_params_list{spot} = fit_parameters;
    end
    
    %Reset the original axis limits
    tool_callbacks('poke_scale',old_axis_lims.det1.pixels);
end

