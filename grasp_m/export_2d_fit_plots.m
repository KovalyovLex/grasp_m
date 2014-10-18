%Script to copy fit-output 2D figure to new window, expand and export to
%jpg

global grasp_handles

%2D Fit

%new figure
fig_handle = figure;
pos = get(grasp_handles.figure.grasp_main,'position')
set(fig_handle,'units','pixels','position',pos);

c = copyobj(grasp_handles.fitter.fit2d_fit,fig_handle);
pos = get(grasp_handles.displayimage.axis1,'position')

%set(c,'position',[0.094,0.43,0.58,0.5]);
set(c,'position',pos);
set(c,'xticklabelmode','auto')
set(c,'yticklabelmode','auto')
set(c,'fontsize',12)

a = get(c,'ylabel');
set(a,'string','Pixels','fontsize',12)

a = get(c,'xlabel');
set(a,'string','Pixels','fontsize',12)

cbar = colorbar;
set(cbar,'position',get(grasp_handles.displayimage.colorbar,'position'));
set(cbar,'fontsize',12)

get(cbar)

asdasda

%Export
export_name = '/home/lss/dewhurst/Desktop/2dfit.jpg';
print('-djpeg100','-noui',[export_name]);



%2D Residual

%new figure
fig_handle = figure;
set(fig_handle,'units','normalized');

c = copyobj(grasp_handles.fitter.fit2d_fit_error,fig_handle);
set(c,'position',[0.1,0.1,0.8,0.8]);
cbar = colorbar;
cbar_pos = get(cbar,'position');
cbar_pos(3) = cbar_pos(3)/2;
cbar_pos(1) = cbar_pos(1)+0.05;
set(cbar,'position',cbar_pos);


%Export
export_name = '/home/lss/dewhurst/Desktop/2dresidual.jpg';
print('-djpeg100','-noui',[export_name]);


