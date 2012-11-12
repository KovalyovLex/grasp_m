function grasp_movie

global grasp_data
global status_flags

index = data_index(status_flags.selector.fw);
depth_max = grasp_data(index).dpth{status_flags.selector.fn};
sum_allow = grasp_data(index).sum_allow;

%***** Make sure selector is displaying foreground or background (i.e. a worksheet with a depth) *****
if depth_max == 1 %i.e. No depth
    disp('Sorry, can''t find a worksheet with a Depth to animate');
else

    %***** Build the movie frames *****
    %Find active foreground fox depth, i.e. the number of depths used
    depth_begin = status_flags.selector.fd; %keep a store of the initial depth position
    for n = 1:depth_max
        status_flags.selector.fd = n+sum_allow;
        grasp_update
        F = getframe;
        movie_frames(n) =  F;
    end
    %close(movie_handle);
    status_flags.selector.fd = depth_begin;
    grasp_update
    
    %***** Play the movie *****
    i = msgbox('Click OK to stop Movie','Grasp Depth-Movie Player');
    temp = figure;
    while ishandle(i);
        movie(temp,movie_frames,-1,5);
    end
    if ishandle(temp);
        close(temp)
    end
    grasp_update
end

