function multi_beam_callbacks(to_do)

global status_flags
global grasp_env
global grasp_handles
global displayimage
global grasp_data
global inst_params

switch to_do
    
    case 'number_beams'
        status_flags.analysis_modules.multi_beam.number_beams_index = get(gcbo,'value');
        temp = get(gcbo,'string');
        status_flags.analysis_modules.multi_beam.number_beams = str2num(temp(status_flags.analysis_modules.multi_beam.number_beams_index,:)); %Corresponding to index above
        
        multi_beam_callbacks('build_beams_list');
        
        
        
    case 'build_beams_list'
        
        %Delete old beams list
        temp = findobj('tag','multi_beam_list');
        if not(isempty(temp));
            delete(temp);
        end
        
        %'Box Coords' text
        uicontrol('units','normalized','Position',[0.1 0.87 0.45 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Tag','multi_beam_list','Style','text','String',['Box Coordinates [x1,x2,y1,y2]'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
        
        %'Cx, Cy' text
        uicontrol('units','normalized','Position',[0.75 0.87 0.15 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Tag','multi_beam_list','Style','text','String',['[Cx, Cy]'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
        
        
        
        y0 = 0.85; delta_y = 0.025;
        
        for beam = 1: status_flags.analysis_modules.multi_beam.number_beams
            
            %'Beam #' text
            uicontrol('units','normalized','Position',[0.0 y0 0.13 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Tag','multi_beam_list','Style','text','String',['Beam #:' num2str(beam)],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
            
            %Beam Box Coordinates
            userdata = [];
            userdata.beam = beam;
            
            beam_box = status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(beam)]);
            
            grasp_handles.window_modules.multi_beam.(['beam' num2str(beam) 'x1']) = uicontrol('units','normalized','Position',[0.14 y0 0.1 0.02],'ToolTip','x1','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','Tag','multi_beam_list','Visible','on', 'String',num2str(beam_box.x1),'userdata',userdata,'callback','multi_beam_callbacks(''x1'');');
            grasp_handles.window_modules.multi_beam.(['beam' num2str(beam) 'x2']) = uicontrol('units','normalized','Position',[0.26 y0 0.1 0.02],'ToolTip','x2','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','Tag','multi_beam_list','Visible','on', 'String',num2str(beam_box.x2),'userdata',userdata,'callback','multi_beam_callbacks(''x2'');');
            grasp_handles.window_modules.multi_beam.(['beam' num2str(beam) 'y1']) = uicontrol('units','normalized','Position',[0.38 y0 0.1 0.02],'ToolTip','y1','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','Tag','multi_beam_list','Visible','on', 'String',num2str(beam_box.y1),'userdata',userdata,'callback','multi_beam_callbacks(''y1'');');
            grasp_handles.window_modules.multi_beam.(['beam' num2str(beam) 'y2']) = uicontrol('units','normalized','Position',[0.50 y0 0.1 0.02],'ToolTip','y2','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','Tag','multi_beam_list','Visible','on', 'String',num2str(beam_box.y2),'userdata',userdata,'callback','multi_beam_callbacks(''y2'');');
            
            %Grab Box and Beam Center Button
            grasp_handles.window_modules.multi_beam.(['beam' num2str(beam) 'grab']) = uicontrol('units','normalized','Position',[0.62 y0 0.1 0.02],'ToolTip','Grab Box Coords and Beam Center','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','pushbutton','Tag','multi_beam_list','Visible','on', 'String','Grab','userdata',userdata,'callback','multi_beam_callbacks(''grab_box'');');
            
            %Beam Center Co-ords Cx Cy
            grasp_handles.window_modules.multi_beam.(['beam' num2str(beam) 'cx']) = uicontrol('units','normalized','Position',[0.74 y0 0.1 0.02],'ToolTip','Cx','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','Tag','multi_beam_list','Visible','on', 'String',num2str(beam_box.cx),'userdata',userdata,'callback','multi_beam_callbacks(''cx'');');
            grasp_handles.window_modules.multi_beam.(['beam' num2str(beam) 'cy']) = uicontrol('units','normalized','Position',[0.86 y0 0.1 0.02],'ToolTip','Cy','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','Tag','multi_beam_list','Visible','on', 'String',num2str(beam_box.cy),'userdata',userdata,'callback','multi_beam_callbacks(''cy'');');
            
            
            y0 = y0 - delta_y;
        end
        
        
        
    case 'x1'
        userdata = get(gcbo,'userdata');
        temp = get(gcbo,'string');
        temp2 = str2num(temp);
        if not(isempty(temp2));
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).x1 = temp2;
        end
        set(gcbo,'string',num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).x1));
        
    case 'x2'
        userdata = get(gcbo,'userdata');
        temp = get(gcbo,'string');
        temp2 = str2num(temp);
        if not(isempty(temp2));
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).x2 = temp2;
        end
        set(gcbo,'string',num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).x2));
        
    case 'y1'
        userdata = get(gcbo,'userdata');
        temp = get(gcbo,'string');
        temp2 = str2num(temp);
        if not(isempty(temp2));
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).y1 = temp2;
        end
        set(gcbo,'string',num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).y1));
        
    case 'y2'
        userdata = get(gcbo,'userdata');
        temp = get(gcbo,'string');
        temp2 = str2num(temp);
        if not(isempty(temp2));
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).y2 = temp2;
        end
        set(gcbo,'string',num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).y2));
        

            case 'cx'
        userdata = get(gcbo,'userdata');
        temp = get(gcbo,'string');
        temp2 = str2num(temp);
        if not(isempty(temp2));
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).cx = temp2;
        end
        set(gcbo,'string',num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).cx));
        
    case 'cy'
        userdata = get(gcbo,'userdata');
        temp = get(gcbo,'string');
        temp2 = str2num(temp);
        if not(isempty(temp2));
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).cy = temp2;
        end
        set(gcbo,'string',num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).cy));
        

    case 'grab_box'
        userdata = get(gcbo,'userdata');
        
        %get current axis limits for det1 only (main detector)
        temp = current_axis_limits;
        ax_lims = temp.det1.pixels;
        status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).x1 = ax_lims(1);
        status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).x2 = ax_lims(2);
        status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).y1 = ax_lims(3);
        status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).y2 = ax_lims(4);
        
        %Center of Mass of Zoomed area
        cm = centre_of_mass(displayimage.data1(ax_lims(3):ax_lims(4),ax_lims(1):ax_lims(2)),ax_lims);
        cx = cm.cm(1); cy = cm.cm(2);
        status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).cx = cx;
        status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).cy = cy;
        
        %Circular Mask over beam center
        index = data_index(7); %Index to masks 7 = masks
        nmbr = status_flags.selector.fn;
        radius = status_flags.analysis_modules.multi_beam.auto_mask_radius;
        %Correct for pixel anisotropy.  Pixels are measured in x-pixels
        pixelsize_x = inst_params.(['detector' num2str(status_flags.display.active_axis)]).pixel_size(1)/1000; %x-pixel size in m
        pixelsize_y = inst_params.(['detector' num2str(status_flags.display.active_axis)]).pixel_size(2)/1000; %y-pixel size in m
        pixel_anisotropy = pixelsize_x / pixelsize_y;
        
        active_axis = 1;  %Only works for main rear detector
        option = 0; %i.e. mask on
        if radius ~= 0
            for y = 0:radius
                width = sqrt((radius^2)-(y^2));
                yy = y*pixel_anisotropy;
                for x = 0:fix(width)
                    if floor(cy+yy) <= inst_params.(['detector' num2str(active_axis)]).pixels(2) && floor(cx+x) <= inst_params.(['detector' num2str(status_flags.display.active_axis)]).pixels(1)
                        grasp_data(index).(['data' num2str(active_axis)]){nmbr}(floor(cy+yy),floor(cx+x)) = option;
                    end
                    if ceil(cy-yy) >= 1 && floor(cx+x) <= inst_params.(['detector' num2str(active_axis)]).pixels(1)
                        grasp_data(index).(['data' num2str(active_axis)]){nmbr}(ceil(cy-yy),floor(cx+x)) = option;
                    end
                    if floor(cy+yy) <= inst_params.(['detector' num2str(active_axis)]).pixels(2) && ceil(cx-x) >= 1
                        grasp_data(index).(['data' num2str(active_axis)]){nmbr}(floor(cy+yy),ceil(cx-x)) = option;
                    end
                    if ceil(cy-yy) >=1 && ceil(cx-x) >=1
                        grasp_data(index).(['data' num2str(active_axis)]){nmbr}(ceil(cy-yy),ceil(cx-x)) = option;
                    end
                end
            end
        end
        grasp_update

        
        
                
        
        %Update the displayed values
        set(grasp_handles.window_modules.multi_beam.(['beam' num2str(userdata.beam) 'x1']), 'string', num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).x1));
        set(grasp_handles.window_modules.multi_beam.(['beam' num2str(userdata.beam) 'x2']), 'string', num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).x2));
        set(grasp_handles.window_modules.multi_beam.(['beam' num2str(userdata.beam) 'y1']), 'string', num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).y1));
        set(grasp_handles.window_modules.multi_beam.(['beam' num2str(userdata.beam) 'y2']), 'string', num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).y2));
        
        set(grasp_handles.window_modules.multi_beam.(['beam' num2str(userdata.beam) 'cx']), 'string', num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).cx));
        set(grasp_handles.window_modules.multi_beam.(['beam' num2str(userdata.beam) 'cy']), 'string', num2str(status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(userdata.beam)]).cy));
        
        
        
    case 'clear_beams'
        
        for n = 1:150 %Max possible number of beams
            %Box Coords
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(n)]).x1 = 0;
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(n)]).x2 = 0;
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(n)]).y1 = 0;
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(n)]).y2 = 0;
            
            %Beam Centers
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(n)]).cx = 0;
            status_flags.analysis_modules.multi_beam.box_beam_coordinates.(['beam' num2str(n)]).cy = 0;
        end
        multi_beam_callbacks('build_beams_list');
        
    case 'auto_mask_check'
        status_flags.analysis_modules.multi_beam.auto_mask_check = get(gcbo,'value');
        
    case 'auto_mask_radius'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            status_flags.analysis_modules.multi_beam.auto_mask_radius = temp;
        end
        set(gcbo,'string',num2str(status_flags.analysis_modules.multi_beam.auto_mask_radius));
        
    case 'beam_scale_check'
        status_flags.analysis_modules.multi_beam.beam_scale_check = get(gcbo,'value');
        
end


