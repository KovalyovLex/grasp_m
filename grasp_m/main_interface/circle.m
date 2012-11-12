function circleref=circle(det,radius,innerradius,centrex,centrey,startangle,endangle,circolor,eccentricity,eccentricity_angle);

global inst_params
global status_flags
global grasp_handles
global displayimage

circleref = []; %in case not assigned for '(none)' color

if nargin <9; eccentricity = 1; eccentricity_angle = 0; end
if nargin <10; eccentricity_angle = 0; end

pixelsize_x = inst_params.detector1.pixel_size(1)/1000; %x-pixel size in m
pixelsize_y = inst_params.detector1.pixel_size(2)/1000; %y-pixel size in m
pixel_anisotropy = pixelsize_x / pixelsize_y;

%Main Axis Handle - make sure we draw in the correct graph
main_axis_handle = grasp_handles.displayimage.(['axis' num2str(det)]);

startx = innerradius*sin((startangle)*pi/180)*eccentricity; %in this case the starting position of the drawing
starty = innerradius*cos((startangle)*pi/180)* pixel_anisotropy;

%Correct for ellipse orientation (relatice to the vertical)
[theta,r] = cart2pol(startx,starty);
theta = theta-(eccentricity_angle*pi/180);
[startx,starty] = pol2cart(theta,r);

lastx = startx;
lasty = starty;



n = 1;
for theta = startangle:0.5:endangle
    x = innerradius*sin((theta)*pi/180)*eccentricity;
    y = innerradius*cos((theta)*pi/180) * pixel_anisotropy;

    %Correct for ellipse orientation (relative to the vertical)
    [theta,r] = cart2pol(x,y);
    theta = theta-(eccentricity_angle*pi/180);
    [x,y] = pol2cart(theta,r);
    
    draw_vectors(n,1) = x+centrex;
    draw_vectors(n,2) = lastx+centrex;
    draw_vectors(n,3) = y+centrey;
    draw_vectors(n,4) = lasty+centrey;
    n = n +1;
    lastx = x;
    lasty = y;
end

for theta = endangle:-0.5:startangle
    x = radius*sin((theta)*pi/180)*eccentricity;
    y = radius*cos((theta)*pi/180) * pixel_anisotropy;
    
    %Correct for ellipse orientation (relatice to the vertical)
    [theta,r] = cart2pol(x,y);
    theta = theta-(eccentricity_angle*pi/180);
    [x,y] = pol2cart(theta,r);
    
    draw_vectors(n,1) = x+centrex;
    draw_vectors(n,2) = lastx+centrex;
    draw_vectors(n,3) = y+centrey;
    draw_vectors(n,4) = lasty+centrey;
    n = n+1;
    lastx = x;
    lasty = y;
end

draw_vectors(n,1) = lastx+centrex;
draw_vectors(n,2) = startx+centrex;
draw_vectors(n,3) = y+centrey;
draw_vectors(n,4) = starty+centrey;



%Specify z-height of the lines for the 3D plot
%Set them to the max of the display range
z_height = max(max(displayimage.image1));
z_height = z_height * ones(size(draw_vectors(:,1:2)));

%Convert coordinates from pixels to q or two theta
if strcmp(status_flags.axes.current,'q') | strcmp(status_flags.axes.current,'t')
    x_pixel_strip = displayimage.qmatrix1(1,:,1);
    y_pixel_strip = displayimage.qmatrix1(:,1,2);
    if strcmp(status_flags.axes.current,'q')
        %Look up q values from qmatrix
        x_axes_strip = displayimage.qmatrix1(1,:,3);
        y_axes_strip = displayimage.qmatrix1(:,1,4);
    elseif strcmp(status_flags.axes.current,'t')
        %Look up 2theta values from qmatrix
        x_axes_strip = displayimage.qmatrix1(1,:,7);
        y_axes_strip = displayimage.qmatrix1(:,1,8);
    end
    %Interpolate new co-ordinates in the current axes
    draw_vectors(:,1:2) = interp1(x_pixel_strip,x_axes_strip,draw_vectors(:,1:2),'spline');
    draw_vectors(:,3:4) = interp1(y_pixel_strip,y_axes_strip,draw_vectors(:,3:4),'spline');
end

if not(strcmp(circolor,'(none)'));
    if strcmp(circolor,'white'); circolor = [0.99,0.99,0.99]; end %to get around the invert hard copy problem
    circleref=line(draw_vectors(:,1:2),draw_vectors(:,3:4),z_height,'color',circolor,'linewidth',status_flags.display.linewidth,'parent',main_axis_handle);
end

