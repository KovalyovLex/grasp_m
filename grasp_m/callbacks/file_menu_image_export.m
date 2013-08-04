function file_menu_image_export(format)

global grasp_env
global status_flags
global grasp_handles
global grasp_data
global inst_params

message_handle = [];

if not(isfield(grasp_env.path,'working_data_dir'))
    grasp_env.path.working_data_dir = grasp_env.path.project_dir;
end
directory = grasp_env.path.working_data_dir;
fname = 'image';

% %***** Invert BW contours prior to Printing *****
% if status_flags.display.contour ==1; %i.e. we are using contours
%     if status_flags.display.invert_hardcopy == 1;
%         if ishandle(grasp_handles.displayimage.contour)
%             if strcmp(status_flags.contour.color,'k') & not(isempty(grasp_handles.displayimage.contour));
%                 set(grasp_handles.displayimage.contour,'color',[1 1 1]);
%             end
%         end
%     end
% end


for det = 1:inst_params.detectors
    %Re-color any white contours slightly grey before printing
    if isfield(grasp_handles.displayimage, ['contour' num2str(det)])
        if ishandle(grasp_handles.displayimage.(['contour' num2str(det)]));
            set(grasp_handles.displayimage.(['contour' num2str(det)]),'color',[0.01,0.01,0.01]');
        end
    end
end
    


%Invert Figure Legend Text from White to Black
legend_handle = findobj(gcf,'tag','grasp_plot_legend');
if ishandle(legend_handle);
    old_legend_color = get(legend_handle,'textcolor');
    if old_legend_color == [1,1,1]; new_legend_color = [0,0,0];
    elseif old_legend_color == [0,0,0]; new_legend_color = [1,1,1];
    else new_legend_color = [1,0,0];
    end
    set(legend_handle,'textcolor',new_legend_color')
end

% %Invert figure background
% if status_flags.display.invert_hardcopy == 1;
%     figure_axis = gca;
%     color = get(figure_axis,'color');
%     if color == [0 0 0];
%         set(figure_axis,'color',[1 1 1]);
%     end
% end

%Hide the Parameters Summary panel
set(grasp_handles.figure.data_summary_panel.root,'visible','off');





%***** Mac OSX and Unix Bug Work around (For dissapearing dropdown menus after print -noui *****
%***** work around is to set UICONTROL units to Pixels (rather than normalized) before print *****
%handles = findobj('type','uicontrol');
%set(handles,'units','pixels');


switch format

    case 'prn' %Quick Print
        disp('Printing Image to Default Printer');
        message_handle = grasp_message('Printing Image to Default Printer');
        if isdeployed
            deployprint('-v','-noui');
        else
            print('-noui')
            %print('-v','-noui'); %Bring up the choose printer dialog & print
        end
        

    case 'bmp' %Bitmap export
        start_string = [directory fname '.bmp'];
        [fname, directory] = uiputfile(start_string,'Export Bitmap Image');
        if isempty(findstr(fname,'.bmp'));fname = [fname '.bmp'];end
        if fname ~= 0
            disp(['Exporting Bitmap Image ' directory fname]);
            message_handle = grasp_message('Exporting Bitmap Image');
            print('-dbmp','-noui',[directory fname]);
            grasp_env.path.working_data_dir = directory;
        end
        
    case 'png'
        start_string = [directory fname '.png'];
        [fname, directory] = uiputfile(start_string,'Export PNG Image');
        if isempty(findstr(fname,'.png'));fname = [fname '.png'];end
        if fname ~= 0
            disp(['Exporting PNG Image ' directory fname]);
            message_handle = grasp_message('Exporting PNG Image');
            print('-dpng','-noui',[directory fname]);
            grasp_env.path.working_data_dir = directory;
        end
        
        
    case 'jpg'
        start_string = [directory fname '.jpg'];
        [fname, directory] = uiputfile(start_string,'Export Jpeg Image');
        if isempty(findstr(fname,'.jpg'));fname = [fname '.jpg'];end
        if fname ~= 0
            disp(['Exporting Jpeg Image ' directory fname]);
            message_handle = grasp_message('Exporting Jpeg Image');
            print('-djpeg100','-noui',[directory fname]);
            grasp_env.path.working_data_dir = directory;
        end

    case 'tif'
        start_string = [directory fname '.tif'];
        [fname, directory] = uiputfile(start_string,'Export Tiff Image');
        if isempty(findstr(fname,'.tif'));fname = [fname '.tif'];end
        if fname ~= 0
            disp(['Exporting Tiff Image ' directory fname]);
            message_handle = grasp_message('Exporting Tiff Image');
            print('-dtiff','-noui',[directory fname]);
            grasp_env.path.working_data_dir = directory;
        end

    case 'eps'
        start_string = [directory fname '.eps'];
        [fname, directory] = uiputfile(start_string,'Export Eps Image');
        if isempty(findstr(fname,'.eps'));fname = [fname '.eps'];end
        if fname ~= 0
            disp(['Exporting Eps Image ' directory fname]);
            message_handle = grasp_message('Exporting Eps Image');
            print('-depsc2','-noui','-loose',[directory fname]);
            grasp_env.path.working_data_dir = directory;
        end

    case 'ai'
        start_string = [directory fname '.ai'];
        [fname, directory] = uiputfile(start_string,'Export Illustrator Image');
        if isempty(findstr(fname,'.ai'));fname = [fname '.ai'];end
        if fname ~= 0
            disp(['Exporting Illustrator Image ' directory fname]);
            message_handle = grasp_message('Exporting Illustrator Image');
            print('-dill','-noui',[directory fname]);
            grasp_env.path.working_data_dir = directory;
        end

    case 'pdf'
        start_string = [directory fname '.pdf'];
        [fname, directory] = uiputfile(start_string,'Export PDF Image');
        if isempty(findstr(fname,'.pdf'));fname = [fname '.pdf'];end
        if fname ~= 0
            disp(['Exporting PDF Image ' directory fname]);
            message_handle = grasp_message('Exporting PDF Image');
            print('-dpdf','-noui',[directory fname]);
            grasp_env.path.working_data_dir = directory;
        end

    case 'jpg_movie_frames'
        start_string = [directory fname '.jpg'];
        [fname, directory] = uiputfile(start_string,'Export Jpeg Image');
        temp = findstr(fname,'.jpg'); %Remove the .jpg extension
        if not(isempty(temp)); fname = fname(1:temp-1); end

        index = data_index(1);
        foreground_depth = status_flags.selector.fdpth_max - grasp_data(index).sum_allow;

        %Build movie frames
        depth_start = status_flags.selector.fd; %remember the initial foreground depth
        for n = 1:foreground_depth
            disp(['Exporting JPG depth frames ' directory fname num2str(n) '.jpg']);
            message_handle = grasp_message(['JPG depth frame ' directory fname num2str(n)]);
            status_flags.selector.fd = n+grasp_data(index).sum_allow;
            main_callbacks('depth_scroll'); %Scroll all linked depths and update
            %Export JGP
            print('-djpeg100','-noui',[directory fname num2str(n) '.jpg']);
        end
        delete(message_handle);
        status_flags.selector.fd = depth_start;
        main_callbacks('depth_scroll'); %Scroll all linked depths and update
        
    case 'clipboard'
        editmenufcn('EditCopyFigure');
        
        
        
        

end

if not(isempty(message_handle));
    if ishandle(message_handle);
        delete(message_handle); %Delete any remaining message on the display
    end
end

% %***** Re-Invert BW contours prior to Printing *****
% if status_flags.display.contour ==1; %i.e. we are using contours
%     if status_flags.display.invert_hardcopy == 1;
%         if ishandle(grasp_handles.displayimage.contour)
%             if strcmp(status_flags.contour.color,'k') & not(isempty(grasp_handles.displayimage.contour));
%                 set(grasp_handles.displayimage.contour,'color',[0 0 0]);
%             end
%         end
%     end
% end


%ReInvert Figure Legend Text color
if ishandle(legend_handle);
    set(legend_handle,'textcolor',old_legend_color')
end

%Un-Hide the Parameters Summary panel
set(grasp_handles.figure.data_summary_panel.root,'visible','on');


% %Re-Invert figure background
% if status_flags.display.invert_hardcopy == 1;
%         set(figure_axis,'color',color);
% end



%***** Mac OSX and Unix print -noui bug work around
%set(handles,'units','normalized');




