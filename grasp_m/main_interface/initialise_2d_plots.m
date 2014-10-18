function initialise_2d_plots

global grasp_handles
global grasp_env
global inst_params
global status_flags

%Delete last plots if they exist
for det = 1:10 %10 is well beyond some maximum number of detectors
    if isfield(grasp_handles.displayimage,['image' num2str(det)]);
        if ishandle(grasp_handles.displayimage.(['image' num2str(det)]));
            delete(grasp_handles.displayimage.(['image' num2str(det)]));
            grasp_handles.displayimage.(['image' num2str(det)]) = [];
        end
    end
    if isfield(grasp_handles.displayimage,['axis' num2str(det)]);
        if ishandle(grasp_handles.displayimage.(['axis' num2str(det)]));
            delete(grasp_handles.displayimage.(['axis' num2str(det)]));
            grasp_handles.displayimage.(['axis' num2str(det)]) = [];
        end
    end
    if isfield(grasp_handles.figure,'subtitle');
        if ishandle(grasp_handles.figure.subtitle);
            delete(grasp_handles.figure.subtitle); grasp_handles.figure.subtitle = [];
        end
    end
end


%Create 2D Plot Title Text
grasp_handles.figure.subtitle = uicontrol(grasp_handles.figure.grasp_main,'units','normalized','Position',[0.01,0.95,0.6,0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);


%Create new 2D display upon Grasp startup

%Calcualte total display width & height required to display detectors
detectors_width = 0; detectors_height = 0;
horz_detectors = 0; vert_detectors = 0;
for det = 1:inst_params.detectors
    if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'centre') || strcmp(inst_params.(['detector' num2str(det)]).view_position, 'centre_right') || strcmp(inst_params.(['detector' num2str(det)]).view_position, 'left') || strcmp(inst_params.(['detector' num2str(det)]).view_position, 'right')
        detectors_width = detectors_width + inst_params.(['detector' num2str(det)]).pixels(1) .* inst_params.(['detector' num2str(det)]).pixel_size(1);
        horz_detectors = horz_detectors + 1;
    end
    if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'centre') || strcmp(inst_params.(['detector' num2str(det)]).view_position, 'centre_right') || strcmp(inst_params.(['detector' num2str(det)]).view_position, 'top') || strcmp(inst_params.(['detector' num2str(det)]).view_position, 'bottom')
        detectors_height = detectors_height + inst_params.(['detector' num2str(det)]).pixels(2) .* inst_params.(['detector' num2str(det)]).pixel_size(2);
        vert_detectors = vert_detectors + 1;
    end
end
if vert_detectors ==0; vert_detectors =1;detectors_height = detectors_height + inst_params.detector1.pixels(2) .* inst_params.detector1.pixel_size(2);end
if horz_detectors ==0; horz_detectors =1;detectors_width = detectors_width + inst_params.detector1.pixels(1) .* inst_params.detector1.pixel_size(1);end


%Total page position avaialible for plots
page = [0.0940    0.43    0.58    0.5]; %normalised units
grasp_env.displayimage.det_page = page; %Keep a copy ready for expanding to full the central detector

detector_display_gap = [0.03 0.03]; %Horz, vert separation of different detector displays
horz_width_per_mm = (page(3) - detector_display_gap(1)*(horz_detectors-1)) / detectors_width;
vert_width_per_mm = (page(4) - detector_display_gap(2)*(vert_detectors-1)) / detectors_height;



for det = 1:inst_params.detectors
    if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'centre')
        grasp_handles.displayimage.(['axis' num2str(det)]) = axes;
        grasp_handles.displayimage.(['image' num2str(det)]) = surf(zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)));
        grasp_handles.displayimage.(['axis' num2str(det)]) = get(grasp_handles.displayimage.(['image' num2str(det)]),'parent');
        view(grasp_handles.displayimage.(['axis' num2str(det)]),2);
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),'tight')  %'square' -can be added as option;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'visible','off','userdata',struct('detector',det),'fontsize',grasp_env.fontsize); %Turn axis labels off
        set(grasp_handles.displayimage.(['image' num2str(det)]),'buttondownfcn',['main_callbacks(''active_axis'',' num2str(det) ')']);
        shading(grasp_handles.displayimage.(['axis' num2str(det)]),status_flags.display.render);

        %Make context menu (activate/deactivate) detector
        grasp_handles.displayimage.(['contextmenu' num2str(det)]) = uicontextmenu;
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label',['Detector #' num2str(det)],'userdata',det);
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','On','userdata',det,'callback','main_callbacks(''detector_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','Off','userdata',det,'callback','main_callbacks(''detector_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','All Panels On','userdata',det,'callback','main_callbacks(''all_panels_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','All Panels Off','userdata',det,'callback','main_callbacks(''all_panels_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','Show / Hide Panel Detectors','userdata',det,'callback','menu_callbacks(''show_minor_detectors'');');
        set(grasp_handles.displayimage.(['image' num2str(det)]),'uicontextmenu',grasp_handles.displayimage.(['contextmenu' num2str(det)]))
        
        %Calcualte plot screen coordinates
        det_width = inst_params.(['detector' num2str(det)]).pixels(1) .* inst_params.(['detector' num2str(det)]).pixel_size(1);
        plot_width = det_width * horz_width_per_mm;
        det_height = inst_params.(['detector' num2str(det)]).pixels(2) .* inst_params.(['detector' num2str(det)]).pixel_size(2);
        plot_height = det_height * vert_width_per_mm;
        plot_horz_position = page(1) + page(3)/2 - plot_width/2;
        plot_vert_position = page(2) + page(4)/2 - plot_height/2;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'position',[plot_horz_position    plot_vert_position    plot_width    plot_height]);
    end
    
    if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'left')
        
                
        grasp_handles.displayimage.(['axis' num2str(det)]) = axes;
        grasp_handles.displayimage.(['image' num2str(det)]) = surf(zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)));
        grasp_handles.displayimage.(['axis' num2str(det)]) = get(grasp_handles.displayimage.(['image' num2str(det)]),'parent');
        view(grasp_handles.displayimage.(['axis' num2str(det)]),2);
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),'tight')  %'square' -can be added as option;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'visible','off','userdata',struct('detector',det),'fontsize',grasp_env.fontsize); %Turn axis labels off
        set(grasp_handles.displayimage.(['image' num2str(det)]),'buttondownfcn',['main_callbacks(''active_axis'',' num2str(det) ')']);
        shading(grasp_handles.displayimage.(['axis' num2str(det)]),status_flags.display.render);
        
        %Make context menu (activate/deactivate) detector
        grasp_handles.displayimage.(['contextmenu' num2str(det)]) = uicontextmenu;
        
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label',['Detector #' num2str(det)],'userdata',det);
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','On','userdata',det,'callback','main_callbacks(''detector_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','Off','userdata',det,'callback','main_callbacks(''detector_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','All Panels On','userdata',det,'callback','main_callbacks(''all_panels_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','All Panels Off','userdata',det,'callback','main_callbacks(''all_panels_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','Show / Hide Panel Detectors','userdata',det,'callback','menu_callbacks(''show_minor_detectors'');');
        
        set(grasp_handles.displayimage.(['image' num2str(det)]),'uicontextmenu',grasp_handles.displayimage.(['contextmenu' num2str(det)]))
        
        %Calcualte plot screen coordinates
        det_width = inst_params.(['detector' num2str(det)]).pixels(1) .* inst_params.(['detector' num2str(det)]).pixel_size(1);
        plot_width = det_width * horz_width_per_mm;
        det_height = inst_params.(['detector' num2str(det)]).pixels(2) .* inst_params.(['detector' num2str(det)]).pixel_size(2);
        plot_height = det_height * vert_width_per_mm;
        plot_horz_position = page(1);
        plot_vert_position = page(2) + page(4)/2 - plot_height/2;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'position',[plot_horz_position    plot_vert_position    plot_width    plot_height]);
    end
    
        if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'right')
        grasp_handles.displayimage.(['axis' num2str(det)]) = axes;
        grasp_handles.displayimage.(['image' num2str(det)]) = surf(zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)));
        grasp_handles.displayimage.(['axis' num2str(det)]) = get(grasp_handles.displayimage.(['image' num2str(det)]),'parent');
        view(grasp_handles.displayimage.(['axis' num2str(det)]),2);
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),'tight')  %'square' -can be added as option;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'visible','off','userdata',struct('detector',det),'fontsize',grasp_env.fontsize); %Turn axis labels off
        set(grasp_handles.displayimage.(['image' num2str(det)]),'buttondownfcn',['main_callbacks(''active_axis'',' num2str(det) ')']);
        shading(grasp_handles.displayimage.(['axis' num2str(det)]),status_flags.display.render);

        %Make context menu (activate/deactivate) detector
        grasp_handles.displayimage.(['contextmenu' num2str(det)]) = uicontextmenu;
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label',['Detector #' num2str(det)],'userdata',det);
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','On','userdata',det,'callback','main_callbacks(''detector_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','Off','userdata',det,'callback','main_callbacks(''detector_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','All Panels On','userdata',det,'callback','main_callbacks(''all_panels_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','All Panels Off','userdata',det,'callback','main_callbacks(''all_panels_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','Show / Hide Panel Detectors','userdata',det,'callback','menu_callbacks(''show_minor_detectors'');');
        set(grasp_handles.displayimage.(['image' num2str(det)]),'uicontextmenu',grasp_handles.displayimage.(['contextmenu' num2str(det)]))
        
        %Calcualte plot screen coordinates
        det_width = inst_params.(['detector' num2str(det)]).pixels(1) .* inst_params.(['detector' num2str(det)]).pixel_size(1);
        plot_width = det_width * horz_width_per_mm;
        det_height = inst_params.(['detector' num2str(det)]).pixels(2) .* inst_params.(['detector' num2str(det)]).pixel_size(2);
        plot_height = det_height * vert_width_per_mm;
        plot_horz_position = page(1) + page(3) - plot_width;
        plot_vert_position = page(2) + page(4)/2 - plot_height/2;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'position',[plot_horz_position    plot_vert_position    plot_width    plot_height]);
    end

    
    if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'top')
        grasp_handles.displayimage.(['axis' num2str(det)]) = axes;
        grasp_handles.displayimage.(['image' num2str(det)]) = surf(zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)));
        grasp_handles.displayimage.(['axis' num2str(det)]) = get(grasp_handles.displayimage.(['image' num2str(det)]),'parent');
        view(grasp_handles.displayimage.(['axis' num2str(det)]),2);
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),'tight')  %'square' -can be added as option;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'visible','off','userdata',struct('detector',det),'fontsize',grasp_env.fontsize); %Turn axis labels off
        set(grasp_handles.displayimage.(['image' num2str(det)]),'buttondownfcn',['main_callbacks(''active_axis'',' num2str(det) ')']);
        shading(grasp_handles.displayimage.(['axis' num2str(det)]),status_flags.display.render);

        %Make context menu (activate/deactivate) detector
        grasp_handles.displayimage.(['contextmenu' num2str(det)]) = uicontextmenu;
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label',['Detector #' num2str(det)],'userdata',det);
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','Panel On','userdata',det,'callback','main_callbacks(''detector_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','Panel Off','userdata',det,'callback','main_callbacks(''detector_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','All Panels On','userdata',det,'callback','main_callbacks(''all_panels_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','All Panels Off','userdata',det,'callback','main_callbacks(''all_panels_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','Show / Hide Panel Detectors','userdata',det,'callback','menu_callbacks(''show_minor_detectors'');');
        set(grasp_handles.displayimage.(['image' num2str(det)]),'uicontextmenu',grasp_handles.displayimage.(['contextmenu' num2str(det)]))

        %Calcualte plot screen coordinates
        det_width = inst_params.(['detector' num2str(det)]).pixels(1) .* inst_params.(['detector' num2str(det)]).pixel_size(1);
        plot_width = det_width * horz_width_per_mm;
        det_height = inst_params.(['detector' num2str(det)]).pixels(2) .* inst_params.(['detector' num2str(det)]).pixel_size(2);
        plot_height = det_height * vert_width_per_mm;
        plot_horz_position = page(1) + page(3)/2 - plot_width/2;
        plot_vert_position = page(2) + page(4) - plot_height;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'position',[plot_horz_position    plot_vert_position    plot_width    plot_height]);
    end
    
    if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'bottom')
        grasp_handles.displayimage.(['axis' num2str(det)]) = axes;
        grasp_handles.displayimage.(['image' num2str(det)]) = surf(zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)));
        grasp_handles.displayimage.(['axis' num2str(det)]) = get(grasp_handles.displayimage.(['image' num2str(det)]),'parent');
        view(grasp_handles.displayimage.(['axis' num2str(det)]),2);
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),'tight')  %'square' -can be added as option;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'visible','off','userdata',struct('detector',det),'fontsize',grasp_env.fontsize); %Turn axis labels off
        set(grasp_handles.displayimage.(['image' num2str(det)]),'buttondownfcn',['main_callbacks(''active_axis'',' num2str(det) ')']);
        shading(grasp_handles.displayimage.(['axis' num2str(det)]),status_flags.display.render);

        %Make context menu (activate/deactivate) detector
        grasp_handles.displayimage.(['contextmenu' num2str(det)]) = uicontextmenu;
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label',['Detector #' num2str(det)],'userdata',det);
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','On','userdata',det,'callback','main_callbacks(''detector_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','Off','userdata',det,'callback','main_callbacks(''detector_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','All Panels On','userdata',det,'callback','main_callbacks(''all_panels_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','All Panels Off','userdata',det,'callback','main_callbacks(''all_panels_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','Show / Hide Panel Detectors','userdata',det,'callback','menu_callbacks(''show_minor_detectors'');');
        set(grasp_handles.displayimage.(['image' num2str(det)]),'uicontextmenu',grasp_handles.displayimage.(['contextmenu' num2str(det)]))
        
        %Calcualte plot screen coordinates
        det_width = inst_params.(['detector' num2str(det)]).pixels(1) .* inst_params.(['detector' num2str(det)]).pixel_size(1);
        plot_width = det_width * horz_width_per_mm;
        det_height = inst_params.(['detector' num2str(det)]).pixels(2) .* inst_params.(['detector' num2str(det)]).pixel_size(2);
        plot_height = det_height * vert_width_per_mm;
        plot_horz_position = page(1) + page(3)/2 - plot_width/2;
        plot_vert_position = page(2);
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'position',[plot_horz_position    plot_vert_position    plot_width    plot_height]);
    end
    
    if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'centre_right') %e.g. SANS 2D
        
        grasp_handles.displayimage.(['axis' num2str(det)]) = axes;
        grasp_handles.displayimage.(['image' num2str(det)]) = surf(zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)));
        grasp_handles.displayimage.(['axis' num2str(det)]) = get(grasp_handles.displayimage.(['image' num2str(det)]),'parent');
        view(grasp_handles.displayimage.(['axis' num2str(det)]),2);
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),'tight')  %'square' -can be added as option;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'visible','off','userdata',struct('detector',det),'fontsize',grasp_env.fontsize); %Turn axis labels off
        set(grasp_handles.displayimage.(['image' num2str(det)]),'buttondownfcn',['main_callbacks(''active_axis'',' num2str(det) ')']);
        shading(grasp_handles.displayimage.(['axis' num2str(det)]),status_flags.display.render);
        
        %Make context menu (activate/deactivate) detector
        grasp_handles.displayimage.(['contextmenu' num2str(det)]) = uicontextmenu;
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label',['Detector #' num2str(det)],'userdata',det);
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','On','userdata',det,'callback','main_callbacks(''detector_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','Off','userdata',det,'callback','main_callbacks(''detector_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','All Panels On','userdata',det,'callback','main_callbacks(''all_panels_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','All Panels Off','userdata',det,'callback','main_callbacks(''all_panels_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','Show / Hide Panel Detectors','userdata',det,'callback','menu_callbacks(''show_minor_detectors'');');
        set(grasp_handles.displayimage.(['image' num2str(det)]),'uicontextmenu',grasp_handles.displayimage.(['contextmenu' num2str(det)]))
        
        %Calcualte plot screen coordinates
        det_width = inst_params.(['detector' num2str(det)]).pixels(1) .* inst_params.(['detector' num2str(det)]).pixel_size(1);
        plot_width = det_width * horz_width_per_mm *0.85;
        det_height = inst_params.(['detector' num2str(det)]).pixels(2) .* inst_params.(['detector' num2str(det)]).pixel_size(2);
        plot_height = det_height * vert_width_per_mm * 0.85;
        plot_horz_position = page(1) + page(3)/2 - plot_width/2 + plot_width/10;
        plot_vert_position = page(2) + page(4)/2 - plot_height/2;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'position',[plot_horz_position    plot_vert_position    plot_width    plot_height]);
        
        
        %Add colorbar associated with the principle (1st) detector
        if status_flags.display.colorbar ==1; visible ='on'; else visible = 'off'; end
        grasp_handles.displayimage.colorbar = colorbar('units', 'normalized','position', [0.72, plot_vert_position, 0.015, plot_height],'visible',visible);
        %Keep a store of the nominal colorbar position on the screen
        grasp_env.displayimage.colorbar_position = [0.72, plot_vert_position, 0.015, plot_height];
    
        
    end

    
    if strcmp(inst_params.(['detector' num2str(det)]).view_position, 'centre_left') %e.g. SANS 2D
        
        grasp_handles.displayimage.(['axis' num2str(det)]) = axes;
        grasp_handles.displayimage.(['image' num2str(det)]) = surf(zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1)));
        grasp_handles.displayimage.(['axis' num2str(det)]) = get(grasp_handles.displayimage.(['image' num2str(det)]),'parent');
        view(grasp_handles.displayimage.(['axis' num2str(det)]),2);
        axis(grasp_handles.displayimage.(['axis' num2str(det)]),'tight')  %'square' -can be added as option;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'visible','off','userdata',struct('detector',det),'fontsize',grasp_env.fontsize); %Turn axis labels off
        set(grasp_handles.displayimage.(['image' num2str(det)]),'buttondownfcn',['main_callbacks(''active_axis'',' num2str(det) ')']);
        shading(grasp_handles.displayimage.(['axis' num2str(det)]),status_flags.display.render);
        
        %Make context menu (activate/deactivate) detector
        grasp_handles.displayimage.(['contextmenu' num2str(det)]) = uicontextmenu;
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label',['Detector #' num2str(det)],'userdata',det);
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','On','userdata',det,'callback','main_callbacks(''detector_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','Off','userdata',det,'callback','main_callbacks(''detector_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','All Panels On','userdata',det,'callback','main_callbacks(''all_panels_on'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'label','All Panels Off','userdata',det,'callback','main_callbacks(''all_panels_off'');');
        grasp_handles.displayimage.(['menuitems' num2str(det)]) = uimenu(grasp_handles.displayimage.(['contextmenu' num2str(det)]),'separator','on','label','Show / Hide Panel Detectors','userdata',det,'callback','menu_callbacks(''show_minor_detectors'');');
        set(grasp_handles.displayimage.(['image' num2str(det)]),'uicontextmenu',grasp_handles.displayimage.(['contextmenu' num2str(det)]))
        
        %Calcualte plot screen coordinates
        det_width = inst_params.(['detector' num2str(det)]).pixels(1) .* inst_params.(['detector' num2str(det)]).pixel_size(1);
        plot_width = det_width * horz_width_per_mm*0.85;
        det_height = inst_params.(['detector' num2str(det)]).pixels(2) .* inst_params.(['detector' num2str(det)]).pixel_size(2);
        plot_height = det_height * vert_width_per_mm*0.85;
        plot_horz_position = page(1) + page(3)/2 - plot_width/2 - plot_width/10;
        plot_vert_position = page(2) + page(4)/2 - plot_height/2;
        set(grasp_handles.displayimage.(['axis' num2str(det)]),'position',[plot_horz_position    plot_vert_position    plot_width    plot_height]);
        
        
        %Add colorbar associated with the principle (1st) detector
        if status_flags.display.colorbar ==1; visible ='on'; else visible = 'off'; end
        grasp_handles.displayimage.colorbar = colorbar('units', 'normalized','position', [0.72, plot_vert_position, 0.015, plot_height],'visible',visible);
        %Keep a store of the nominal colorbar position on the screen
        grasp_env.displayimage.colorbar_position = [0.72, plot_vert_position, 0.015, plot_height];
    
        
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    if det == 1;
        %Add colorbar associated with the principle (1st) detector
        if status_flags.display.colorbar ==1; visible ='on'; else visible = 'off'; end
        grasp_handles.displayimage.colorbar = colorbar('units', 'normalized','position', [.72, plot_vert_position, 0.015, plot_height],'visible',visible);
        %Keep a store of the nominal colorbar position on the screen
        grasp_env.displayimage.colorbar_position = [0.72, plot_vert_position, 0.015, plot_height];
    
    end

    %Keep a store of the nominal detector positions on the screen
    grasp_env.displayimage.(['det_position' num2str(det)]) = [plot_horz_position    plot_vert_position    plot_width    plot_height];
    
end
%Make the first detector the active axis
main_callbacks('active_axis',1);


