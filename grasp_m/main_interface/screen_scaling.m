function screen = screen_scaling

screen.screen_size = get(0,'monitorpositions');
screen.reference_res = [1600, 1200]; %DewhurstPC1 screen1
screen.screen_scaling = (screen.screen_size(1,3:4)./screen.reference_res);
screen.screen_scaling = [1,1];

