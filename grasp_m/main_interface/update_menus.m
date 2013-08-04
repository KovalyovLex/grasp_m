function update_menus

%Updates the various ticks etc in the menu items 
%depending on their values in status_flags

global status_flags
global grasp_handles
global grasp_env



%Update averaging, sector & box depth graphic updates
set(grasp_handles.menu.file.preferences.averaging_depth_update,'checked',status_flags.analysis_modules.radial_average.display_update);
set(grasp_handles.menu.file.preferences.sector_box_update,'checked',status_flags.analysis_modules.sector_boxes.display_refresh);
set(grasp_handles.menu.file.preferences.box_update,'checked',status_flags.analysis_modules.boxes.display_refresh);

%Update param display and graphic display tick
if status_flags.command_window.display_params ==1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.display.parameter_display,'checked',status);
if  status_flags.display.refresh ==1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.display.graphic_update,'checked',status);


%Update the render 'tick' in the menu
if strcmp(status_flags.display.render,'flat'); set(grasp_handles.menu.display.render.flat,'checked','on');
else set(grasp_handles.menu.display.render.flat,'checked','off'); end

if strcmp(status_flags.display.render,'interp'); set(grasp_handles.menu.display.render.interp,'checked','on');
else set(grasp_handles.menu.display.render.interp,'checked','off'); end

if strcmp(status_flags.display.render,'faceted'); set(grasp_handles.menu.display.render.faceted,'checked','on');
else set(grasp_handles.menu.display.render.faceted,'checked','off'); end

%Update the colormap 'tick'
for n = 1:length(grasp_handles.menu.display.colormap.map)
    label = get(grasp_handles.menu.display.colormap.map(n),'label');
    if strcmp(status_flags.color.map,label);
        set(grasp_handles.menu.display.colormap.map(n),'checked','on'); %main menu
        set(grasp_handles.figure.image_context.map_handles(n),'checked','on'); %colorbar context menu
    else
        set(grasp_handles.menu.display.colormap.map(n),'checked','off');
        set(grasp_handles.figure.image_context.map_handles(n),'checked','off');
    end
end




%Colorbar tick
if status_flags.display.colorbar == 1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.display.showcolorbar,'checked',status);

%Show axes tick
if status_flags.display.axes ==1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.display.showaxes,'checked',status);

%Show title
if status_flags.display.title ==1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.display.showtitle, 'checked',status);

%Show axis box
if status_flags.display.axis_box == 1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.display.axis_box,'checked',status);

%Flip u/d
if status_flags.display.flipud == 1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.display.flip.updown,'checked',status);

%Flip l/r
if status_flags.display.fliplr == 1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.display.flip.lr,'checked',status);

%Smooth Kernel
handles1 = grasp_handles.menu.display.smoothkernel.kernel;
handles2 = grasp_handles.figure.smooth_context.smooth;
for i = 1:length(handles1);
    menu_name = get(handles1(i),'Label');
    if strcmp(menu_name,status_flags.display.smooth.kernel);
        set(handles1(i),'checked','on');
        set(handles2(i),'checked','on');
    else
        set(handles1(i),'checked','off');
        set(handles2(i),'checked','off');
    end
end

%Z-Scale
if strcmp(status_flags.display.zscale,'Log Z');
    set(grasp_handles.menu.display.zscale.logz,'checked','on');
    set(grasp_handles.figure.logz_context.logz,'checked','on');
else
    set(grasp_handles.menu.display.zscale.logz,'checked','off');
    set(grasp_handles.figure.logz_context.logz,'checked','off');
end
if strcmp(status_flags.display.zscale,'Asinh Z');
    set(grasp_handles.menu.display.zscale.asinhz,'checked','on');
    set(grasp_handles.figure.logz_context.asinhz,'checked','on');
else
    set(grasp_handles.menu.display.zscale.asinhz,'checked','off');
    set(grasp_handles.figure.logz_context.asinhz,'checked','off');
end
if strcmp(status_flags.display.zscale,'Sqrt Z');
    set(grasp_handles.menu.display.zscale.sqrtz,'checked','on');
    set(grasp_handles.figure.logz_context.sqrtz,'checked','on');
else
    set(grasp_handles.menu.display.zscale.sqrtz,'checked','off');
    set(grasp_handles.figure.logz_context.sqrtz,'checked','off');
end


%Contour color tick
handles1 = grasp_handles.menu.display.contourcolors.colors;
handles2 = grasp_handles.figure.contour_context.color;
for i = 1:length(handles1)
    col = get(handles1(i),'userdata');
    if strcmp(col,status_flags.contour.color);
        set(handles1(i),'checked','on');
        set(handles2(i),'checked','on');
    else
        set(handles1(i),'checked','off');
        set(handles2(i),'checked','off');
    end
end

       
%Update the tick in the instrument menu
%Set all inst ticks off
i = findobj('tag','inst_menu'); set(i,'checked','off');
%Set the relevant instrument tick on
if isfield(grasp_handles.menu.instrument.inst,grasp_env.inst_option);
    handle = getfield(grasp_handles.menu.instrument.inst,grasp_env.inst_option);
    set(handle,'checked','on');
elseif isfield(grasp_handles.menu.instrument.inst,grasp_env.inst);
    handle = getfield(grasp_handles.menu.instrument.inst,grasp_env.inst);
    set(handle,'checked','on');
end


%Update the File>Preferences menu ticks
if strcmp(status_flags.display.linestyle,''); status = 'on'; else status = 'off'; end
set(grasp_handles.menu.file.preferences.linestyle.none,'checked',status);
if strcmp(status_flags.display.linestyle,'-'); status = 'on'; else status = 'off'; end
set(grasp_handles.menu.file.preferences.linestyle.solid,'checked',status);
if strcmp(status_flags.display.linestyle,':'); status = 'on'; else status = 'off'; end
set(grasp_handles.menu.file.preferences.linestyle.dotted,'checked',status);
if strcmp(status_flags.display.linestyle,'-.'); status = 'on'; else status = 'off'; end
set(grasp_handles.menu.file.preferences.linestyle.dashdot,'checked',status);
if strcmp(status_flags.display.linestyle,'--'); status = 'on'; else status = 'off'; end
set(grasp_handles.menu.file.preferences.linestyle.dashed,'checked',status);

%line width
linewidth_handle_names = fieldnames(grasp_handles.menu.file.preferences.linewidth.width);
temp = length(linewidth_handle_names);
for n = 1:temp
    field = linewidth_handle_names{n};
    handle = getfield(grasp_handles.menu.file.preferences.linewidth.width,['width' num2str(n)]);
    if get(handle,'userdata') == status_flags.display.linewidth; status = 'on'; else status = 'off'; end
    set(handle,'checked',status);
end

%marker size
markersize_handle_names = fieldnames(grasp_handles.menu.file.preferences.markersize.markersize);
temp = length(markersize_handle_names);
for n = 1:temp
    field = markersize_handle_names{n};
    handle = getfield(grasp_handles.menu.file.preferences.markersize.markersize,field);
    if get(handle,'userdata') == status_flags.display.markersize; status = 'on'; else status = 'off'; end
    set(handle,'checked',status);
end

%invert hardcopy
if status_flags.display.invert_hardcopy == 1; status = 'on';else status = 'off'; end
set(grasp_handles.menu.file.preferences.inverthard,'checked',status);

%save sub figure
if status_flags.file.save_sub_figures == 1; status = 'on'; else status = 'off'; end
set(grasp_handles.menu.file.preferences.save_subfigure,'checked',status);

%Inst>Qsetup>Det & Det Calc
if strcmp(status_flags.q.det,'det'); status = 'on'; else status = 'off'; end
set(grasp_handles.menu.instrument.qsetup.det,'checked',status);
if strcmp(status_flags.q.det,'detcalc'); status = 'on'; else status = 'off'; end
set(grasp_handles.menu.instrument.qsetup.detcalc,'checked',status);

%Data Normalisation tick
norm_handle_names = fieldnames(grasp_handles.menu.data.normalization);
for n = 1:length(norm_handle_names);
    norm_handle = getfield(grasp_handles.menu.data.normalization,norm_handle_names{n});
    if ishandle(norm_handle)
        if strcmp(status_flags.normalization.status,get(norm_handle,'userdata'));
            set(norm_handle,'checked','on');
        else
            set(norm_handle,'checked','off');
        end
    end
end


%Deadtime tick
if strcmp(status_flags.deadtime.status,'on');
    set(grasp_handles.menu.data.deadtime.on,'checked','on');
    set(grasp_handles.menu.data.deadtime.off,'checked','off');
else
    set(grasp_handles.menu.data.deadtime.on,'checked','off');
    set(grasp_handles.menu.data.deadtime.off,'checked','on');
end
    

%Auto attenuator correction tick
if strcmp(status_flags.normalization.auto_atten,'on');
    set(grasp_handles.menu.data.attenuator.on,'checked','on');
    set(grasp_handles.menu.data.attenuator.off,'checked','off');
else
    set(grasp_handles.menu.data.attenuator.on,'checked','off');
    set(grasp_handles.menu.data.attenuator.off,'checked','on');
end


%Count Scaler tick
if strcmp(status_flags.normalization.count_scaler,'on');
    set(grasp_handles.menu.data.count_scaler.on,'checked','on');
    set(grasp_handles.menu.data.count_scaler.off,'checked','off');
else
    set(grasp_handles.menu.data.count_scaler.on,'checked','off');
    set(grasp_handles.menu.data.count_scaler.off,'checked','on');
end



%Transmission thickness correction
if strcmp(status_flags.transmission.thickness_correction,'on');
    set(grasp_handles.menu.data.transmission.on,'checked','on');
    set(grasp_handles.menu.data.transmission.off,'checked','off');
    else
    set(grasp_handles.menu.data.transmission.on,'checked','off');
    set(grasp_handles.menu.data.transmission.off,'checked','on');
end


%Data correction algorithm tick
fnames = fieldnames(grasp_handles.menu.analysis.algorithm);
for n = 1:length(fnames);
    if strcmp(fnames{n},status_flags.algorithm); status = 'on'; else status = 'off'; end
    handle = getfield(grasp_handles.menu.analysis.algorithm,fnames{n});
    set(handle,'checked',status);
end

    

