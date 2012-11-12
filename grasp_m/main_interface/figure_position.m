function fig_position = figure_position(default_position,toolbar_overhead,screen)

fig_position = default_position; % the default is to do nothing

if nargin<3; screen = 1; end
if nargin<2; toolbar_overhead = 40; end

global grasp_env

gamma = default_position(3)/default_position(4); %Figure aspect ratio
   
%Re-scale Grasp window if window is to high for current resolution
if default_position(4) > 0.85*(grasp_env.screen.screen_size(screen,4)-toolbar_overhead);
    disp('Re-scaling Grasp window to match Screen Resolution');
    %Rescale Dy to be no more than 0.85 of screen height.
    fig_position(4) = 0.85*(grasp_env.screen.screen_size(screen,4)-toolbar_overhead);
    fig_position(3) = fig_position(4)*gamma;
end

%Re-position Grasp window based on spare lines in x and y
y_spare = grasp_env.screen.screen_size(screen,4)-grasp_env.screen.screen_size(screen,2)+1 - fig_position(4)-toolbar_overhead;
if y_spare <0; y_spare = 0; end
fig_position(2) = 0.7*y_spare;


x_spare = grasp_env.screen.screen_size(screen,3)-grasp_env.screen.screen_size(screen,1)+1 - fig_position(3);
if x_spare <0; x_spare = 0; end
fig_position(1) = 0.1*x_spare;

if screen > 1;
    fig_position(1) = fig_position(1) + grasp_env.screen.screen_size(screen,1)-1;
    fig_position(2) = fig_position(2) + grasp_env.screen.screen_size(screen,2)-1;
end
    