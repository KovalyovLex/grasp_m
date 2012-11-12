function set_colormap

global status_flags
global grasp_handles

%cmap
cmap = colormap(status_flags.color.map); %Retrieve the current colormap (as numbers)

%invert
if status_flags.color.invert == 1;
    cmap = flipud(cmap);
end

%swap
if status_flags.color.swap == 1;
    cmap = fliplr(cmap);
end

%Color Gamma Slider
cmap = cmap.^(3*status_flags.color.gamma);
cmap(find(cmap>1)) = 1;

%Color Bottom Slider
bottom= (fix(status_flags.color.bottom*64));
customtemp = cmap;
for x = 1:bottom
    cmap(x,1:3) = customtemp(1,1:3);
end

for x = (fix(status_flags.color.bottom*64)+1):64
    newxstep = 64/(64-((fix(status_flags.color.bottom*64))));
    xx = (x-(fix(status_flags.color.bottom*64)))*newxstep;
    xxx = fix(xx);
    if xxx > 64; xxx =64;end
    cmap(x,1:3) = customtemp(xxx,1:3);
end
cmap = rot90(cmap,2);


%Color Top Slider
bottom= (fix((1-status_flags.color.top)*64));
customtemp = cmap;
for x = 1:bottom
    cmap(x,1:3) = customtemp(1,1:3);
end
for x = (fix((1-status_flags.color.top)*64)+1):64
    newxstep = 64/(64-((fix((1-status_flags.color.top)*64))));
    xx = (x-(fix((1-status_flags.color.top)*64)))*newxstep;
    xxx = fix(xx);
    if xxx > 64; xxx =64; end
    cmap(x,1:3) = customtemp(xxx,1:3);
end
cmap = rot90(cmap,2);

%Set modified colormap to the figure
set(grasp_handles.figure.grasp_main,'Colormap', cmap);

%         %Update Color Sliders
%         i = findobj('Tag','colorbottom_slider');
%         set(i,'value',status_flags.color.bottom);
%         i = findobj('Tag','colortop_slider');
%         set(i,'value',status_flags.color.top);
%         i = findobj('Tag','colorgamma_slider');
%         set(i,'value',status_flags.color.gamma);

