function grasp_plot(plotdata,column_format,plot_info)

%March2010:  'grasp_plot' is Chuck's 2D plotting plotting program designed
%to work in conjunction with Grasp and also as a stand alone plotting,
%curve fitting and manipulation program.
%
%This version follows that of 'chuck_plot' from Jan2007.
%
%New modifications ensure that grasp_plot is robust and can stand alone
%outside of Grasp.
%
%Usage:
%Simple Usage:
%e.g.  'grasp_plot(plotdata)'  Where plotdata are columns of xy or xye
%
%More explicit usage:
%e.g.  'grasp_plot(plotdata,column_format)' Where plotdata are columns of 'xyhe'
%type data where x = xdata, y = ydata, h = horizontal error bar data, e =
%vertical error bar data.
%Can also take multiple curves at one time described, e.g as 'x1y1e1y2e2'
%
%Advanced usage
%e.g.  'chuck_plot(plotdata,column_format,plot_properties)'  Where
%'plot_properties' is a structure containing optional fields such as:
%plot_properties.type
%plot_properties.title
%plot_properties.x_label
%plot_properties.y_label
%plot_properties.plot_type

if nargin <3; plot_info = []; end
if nargin <2; column_format = []; end


%***** Copy parameters from Grasp_env or use new defaults *****
global grasp_env
if isfield(grasp_env,'font'); font = grasp_env.font; fontsize = grasp_env.fontsize; else font = 'Arial'; fontsize = 10; end
if isfield(grasp_env,'sub_figure_background_color'); background_color = grasp_env.sub_figure_background_color; else background_color = [0.2 0.3 0.3]; end

%***** Copy parameters from status_flags or use new defaults *****
global status_flags
if isfield(status_flags,'display');
    linestyle = status_flags.display.linestyle; linewidth = status_flags.display.linewidth; markersize = status_flags.display.markersize;
else
    linestyle = '-'; linewidth = 1; markersize = 5;
end

%***** Build the plot info structre that determines how the plot should be built and ALSO is stored with each plot for subsetuent replotting, exporting etc. *****
if not(isfield(plot_info,'plot_type')); plot_info.plot_type = 'plot'; end
if not(isfield(plot_info,'plot_title')); plot_info.plot_title = 'No Title'; end
if not(isfield(plot_info,'x_label')); plot_info.x_label = 'x-axis'; end
if not(isfield(plot_info,'y_label')); plot_info.y_label = 'y-axis'; end
if not(isfield(plot_info,'hold_graph')); plot_info.hold_graph = 0; end
if not(isfield(plot_info,'legend_str')); plot_info.legend_str = 'No Legend'; end
if not(isfield(plot_info,'export_data')); plot_info.export_data = plotdata; end
if not(isfield(plot_info,'column_format')); plot_info.column_format = column_format; end
if isfield(plot_info,'marker_size'); markersize = plot_info.marker_size; end


%***** Plot Variables *****
colors = ['w' 'r' 'c' 'm' 'y' 'g' 'b' 'w' 'y' 'm' 'c' 'r' 'g' 'b'];
symbols = ['o' 'x' '+' '*' '.' 's' 'd' 'v' '^' '<' '>' 'p' 'h' '.' 'o' 'x' '+' '*' 's' 'd' 'v' '^' '<' '>' 'p' 'h'];
number_previous_curves = 0; %for incremental colours and symbols in overplotting mode



%***** Check to see if we are over-plotting in an existing window or opening a new plot window *****
new_plot_flag = 1; %i.e. the default is to open a new plot
i = findobj('name',plot_info.plot_title); %See if there is an existing plot with the same title
if not(isempty(i)); %i.e. at least one exists
    grasp_plot_handles = get(i(1),'userdata');
    if strcmpi(grasp_plot_handles.hold_status,'on')
        new_plot_flag = 0; %i.e. there is a plot of the same type on hold so add to it
        curve_handles = get(grasp_plot_handles.axis,'userdata');
        number_previous_curves = length(curve_handles);
        figure(i(1)); %Make over plotting figure the current one
    else
        new_plot_flag = 1; %i.e. not a plot of the same type on hold so open a new plot
    end
end



%***** Open New Figure Window if required *****
if new_plot_flag ==1;
    
    
    %Check How Many Output Windows are Already Open! - Too many crash the computer
    i = findobj('tag','grasp_plot');
    if length(i) >10;
        i = warndlg('Please Close Some Grasp_Plot Windows!','Warning: Matlab Memory');
        set(i,'tag','plot_warn');
        pause(2);
        while not(isempty(i))
            i = findobj('tag','plot_warn');
            pause(0.1);
        end
    end
    
    
    %Open New Figure
    colordef black; %Window background
    if isfield(grasp_env,'screen');
        fig_position = [1.1*(grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3)), grasp_env.screen.grasp_main_actual_position(2)+grasp_env.screen.grasp_main_actual_position(4)-400,   600*grasp_env.screen.screen_scaling(1)   400*grasp_env.screen.screen_scaling(2)];
        fig_units = 'pixels';
    else
        fig_position = [0.5, 0.5, 0.4, 0.4];
        fig_units = 'normalized';
        
    end
    
    grasp_plot_handles = [];
    grasp_plot_handles.figure = figure(....
        'units',fig_units,....
        'Position',fig_position,....
        'Name',plot_info.plot_title,....
        'NumberTitle', 'off',....
        'Tag','grasp_plot',....
        'color',background_color,....
        'papertype','A4',....
        'paperunits','centimeters',....
        'paperorientation','landscape',....
        'paperposition',[2 8 15 11.25],....
        'renderer','zbuffer',....
        'resize','on',....
        'menubar','none',....
        'toolbar','none',....
        'windowbuttondownfcn','grasp_plot_callbacks(''button_down'');');
    
    %Modify Grasp_Plot Menu Items
    grasp_plot_handles = modify_grasp_plot_menu(grasp_plot_handles);
    %Modify Grasp_Plot Tool Items
    grasp_plot_handles = modify_grasp_plot_toolbar(grasp_plot_handles);
    pause(0.1); %Let the figure window finnish displaying
    
    
    %Hold Graph Checkbox - when ticked and another graph is requested it plots into the last figure.
    if strcmpi(plot_info.hold_graph,'on'); hold_status = 1; else hold_status = 0; end
    grasp_plot_handles.hold_status = plot_info.hold_graph;
    grasp_plot_handles.hold_check = uicontrol(grasp_plot_handles.figure,'units','normalized','Position',[0.85,0.93,0.1,0.06],'ToolTip',['Hold Graph: Yes(checked) / No(un-checked)' char(13) 'Next Results Output will plot in this Figure.'],...
        'FontName',font,'FontSize',fontsize,'Style','checkbox','String','Hold!','HorizontalAlignment','left','value',hold_status,'backgroundcolor',background_color,'foregroundcolor',[1 1 1],'callback','grasp_plot_callbacks(''hold_toggle'')');
    %Log and Lin Dropdown list
    %y_list_string = {'y','log10(y)','ln(y)', 'y^2', 'y^4', 'y^n', 'y*x'};
    y_list_string = {'y','log10(y)'};
    grasp_plot_handles.yscale_list = uicontrol(grasp_plot_handles.figure,'units','normalized','Position',[0.025 0.93 0.09 0.06],'FontName',font,'FontSize',fontsize,'Style','Popup','String',y_list_string,'HorizontalAlignment','left','Tag','log_button_y','Visible','on',...
        'CallBack','grasp_plot_callbacks(''y_scale'');','backgroundcolor',[0 0 0],'foregroundcolor',[1 1 1]);
    x_list_string = {'x','log10(x)'};
    grasp_plot_handles.xscale_list = uicontrol(grasp_plot_handles.figure,'units','normalized','Position',[0.78 0.15 0.1 0.06],'FontName',font,'FontSize',fontsize,'Style','Popup','String',x_list_string,'HorizontalAlignment','left','Tag','log_button_x','Visible','on',...
        'CallBack','grasp_plot_callbacks(''x_scale'');','backgroundcolor',[0 0 0],'foregroundcolor',[1 1 1]);
    %Scaling Power Box
    grasp_plot_handles.yscale_edit = uicontrol(grasp_plot_handles.figure,'units','normalized','Position',[0.120 0.93 0.08 0.06],'FontName',font,'FontSize',fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','yscaling_power_box','Visible','off',...
        'CallBack','grasp_plot_callbacks(''y_power_scale'');','backgroundcolor',[1 1 1],'foregroundcolor',[0 0 0]);
    grasp_plot_handles.xscale_edit = uicontrol(grasp_plot_handles.figure,'units','normalized','Position',[0.89 0.15 0.08 0.06],'FontName',font,'FontSize',fontsize,'Style','edit','String','1','HorizontalAlignment','left','Tag','xscaling_power_box','Visible','off',...
        'CallBack','grasp_plot_callbacks(''x_power_scale'');','backgroundcolor',[1 1 1],'foregroundcolor',[0 0 0]);
    
    %Make a dummy graph axes
    curve_handles = []; %Store this in the axis userdata and add to it as curves are drawn
    grasp_plot_handles.axis = axes('Position',[0.1 0.15 0.650 0.7],'tag','results_axes','box','on','FontName',font,'FontSize',fontsize,'Layer','Top','TickDir','in','userdata',curve_handles);
    
    
    %Store all the new handles in the figure's userdata
    set(grasp_plot_handles.figure,'userdata',grasp_plot_handles);
    
end




%***** Plot the Data *****
plotdata = sortrows(plotdata,1); %Sort Plotdata into ascending x-order


%***** Simple XY plot only *****
if nargin ==1; %Simple plotdata only, i.e. x y1 y2 y3 etc.
    temp = size(plotdata);
    xdata = plotdata(:,1);
    for curve_number = 1:(temp(2)-1)
        ydata = plotdata(:,curve_number+1);
        plot_handle = plot(grasp_plot_handles.figure,'xdata',xdata,'ydata',ydata,'linestyle',linestyle,'linewidth',linewidth,'markersize',markersize,'color',colors(curve_number),'marker',symbols(curve_number));
        %Store curve handle in axis userdata
        curve_handles = get(grasp_plot_handles.axis,'userdata');
        curve_handles{length(curve_handles)+1} = plot_handle;
        set(grasp_plot_handles.axis,'userdata',curve_handles);
        
        %Add to to the plot_info structure
        %plot_info.xdata = xdata;
        %plot_info.ydata = ydata;
        %plot_info.edata = [];
        %plot_info.exdata = [];
        plot_info.column_format = 'xy';
        plot_info.plot_type = 'plot';
        plot_info.curve_number = curve_number;
        
        %Store the plot_info in the curve userdata
        set(plot_handle,'userdata',plot_info);
        
        %Now add the titles to the graph
        xlabel(grasp_plot_handles.axis,plot_info.x_label);
        ylabel(grasp_plot_handles.axis,plot_info.y_label);
        title(grasp_plot_handles.axis,plot_info.plot_title);
    end
end
%*******************************


%***** Plots with column_format and plot_params information *****
if nargin >= 2; %The column_format information exists
    
    %***** Turn Plotdata round to a vertical column if it looks to be the wrong way round *****
    l = size(plotdata);
    if l(1) == length(column_format) & l(2) ~= length(column_format); plotdata = rot90(plotdata); end
    %**********************************************************************
    
    %Parse the column_format string
    curve_number = 1;
    xdata = []; ydata = []; exdata = []; edata = [];
    for col_pointer = 1:length(column_format);
        if strcmp(column_format(col_pointer),'x');  %New x-column
            xdata = plotdata(:,col_pointer);
        elseif strcmp(column_format(col_pointer),'y');
            ydata = plotdata(:,col_pointer);
            %Check if X error data is coming also
            if col_pointer < length(column_format)
                if strcmp(column_format(col_pointer+1),'h');
                    exdata = plotdata(:,col_pointer+1);
                    col_pointer = col_pointer +1;
                else
                    exdata = [];
                end
            end
            %Check if Y error data is coming also
            if col_pointer < length(column_format)
                if strcmp(column_format(col_pointer+1),'e');
                    edata = plotdata(:,col_pointer+1);
                    col_pointer = col_pointer +1;
                else
                    edata = [];
                end
            end
            
            %***** Work out the next curve colour, symbol, line style and size *****
            total_curve_number = curve_number +number_previous_curves;
            curve_colour = curve_number +number_previous_curves;
            symbol_type = curve_number +number_previous_curves;
            while curve_colour > length(colors);
                curve_colour = curve_colour - length(colors);
            end
            while symbol_type > length(symbols);
                symbol_type = symbol_type - length(symbols);
            end
           
            %**************************************************************
            
            if strcmp(plot_info.plot_type,'plot') || strcmp(plot_info.plot_type,'errorbar');
                %Plot the data as either plot or errorbar
                if isempty(edata); %Plot only
                    
                    set(grasp_plot_handles.axis,'nextplot','add') %Same as hold on
                    plot_handle = plot(grasp_plot_handles.figure,'xdata',xdata,'ydata',ydata,'linestyle',linestyle,'linewidth',linewidth,'color',colors(curve_colour),'marker',symbols(symbol_type),'markersize',markersize);
                    
                    %Store curve handle in axis userdata
                    curve_handles = get(grasp_plot_handles.axis,'userdata');
                    curve_handles{length(curve_handles)+1} = plot_handle;
                    set(grasp_plot_handles.axis,'userdata',curve_handles);
                    
                    %Add to to the plot_info structure
                    if not(isfield(plot_info,'plot_data'));
                        plot_info.plot_data.xdat = xdata;
                        plot_info.plot_data.ydat = ydata;
                        plot_info.plot_data.edat = edata;
                        plot_info.plot_data.exdat = [];
                    end
                    
                    plot_info.column_format = 'xy';
                    plot_info.plot_type = 'plot';
                    plot_info.curve_number = total_curve_number;
                    
                    %Strip out the individual legends if multiple curves send it at one time
                    plot_info_temp = plot_info;
                    if iscell(plot_info.legend_str)
                        if total_curve_number > length(plot_info.legend_str);
                            plot_info_temp.legend_str = plot_info.legend_str{1};
                        else
                            plot_info_temp.legend_str = plot_info.legend_str{total_curve_number};
                        end
                    else
                        plot_info_temp.legend_str = plot_info.legend_str;
                    end
                    
                    %Store the plot_info in the curve userdata
                    set(plot_handle,'userdata',plot_info_temp);
                    plot_info = rmfield(plot_info,'plot_data'); %Remove plot_data so next curve plotted gets new data stored in plot_data
                    
                else %Errorbar plot
                    linespec = [linestyle colors(curve_colour) symbols(symbol_type)]; %Plot line type specification
                    figure(grasp_plot_handles.figure);
                    set(grasp_plot_handles.axis,'nextplot','add') %Same as hold on

                    plot_handle = ploterr(xdata,ydata,exdata,edata,linespec); 
                    %plot_handle = ploterr(xdata,ydata,exdata,edata,linespec,'logxy'); 
                    
                    %Store curve handle in axis userdata
                    curve_handles = get(grasp_plot_handles.axis,'userdata');
                    curve_handles{length(curve_handles)+1} = plot_handle;
                    set(grasp_plot_handles.axis,'userdata',curve_handles);
                    
                    %Add to to the plot_info structure
                    if not(isfield(plot_info,'plot_data'));
                        plot_info.plot_data.xdat = xdata;
                        plot_info.plot_data.ydat = ydata;
                        plot_info.plot_data.edat = edata;
                        plot_info.plot_data.exdat = [];
                    end
                    
                    plot_info.column_format = 'xye';
                    plot_info.plot_type = 'errorbar';
                    plot_info.curve_number = total_curve_number;
                    
                    
                    %Strip out the individual legends if multiple curves send it at one time
                    plot_info_temp = plot_info;
                    if iscell(plot_info.legend_str)
                        plot_info_temp.legend_str = plot_info.legend_str{total_curve_number};
                    else
                        plot_info_temp.legend_str = plot_info.legend_str;
                    end
                    
                    %NEW 12/11/2013
                    %Re-hash the exprot data so as to only set export data for this curve
                    
                    %Error trap for incoming plot data without 'export_column_format'
                    if not(isfield(plot_info_temp,'export_column_format'));
                        disp(' ')
                        disp('WARNING:  Export data does not contain ''export_column_format'' information')
                        disp(['Guessing column format as: ' column_format]);
                        plot_info_temp.export_column_format = column_format;
                    end
                    
                    %find indicies to y data
                    yindex = findstr('y',plot_info_temp.export_column_format);
                    yindex = yindex(curve_number); %Current y data index for this curve
                    yexport_data = plot_info_temp.export_data(:,yindex); %current y export data for this curve
                    xindex = findstr('x',plot_info_temp.export_column_format(1:yindex));
                    xindex = xindex(length(xindex)); %Last x data index before current y data
                    xexport_data = plot_info_temp.export_data(:,xindex); %current x export data for this curve
                    export_column_format = ['xy']; %Gets added to below
                    
                    %x-errors (resolution)
                    hindex = findstr('h',plot_info_temp.export_column_format);
                    temp = find(hindex>=yindex);
                    if not(isempty(temp));
                        hindex = hindex(temp(1)); %First x error data after current y column
                        hexport_data = plot_info_temp.export_data(:,hindex); %current h export data for this curve
                        export_column_format = [export_column_format 'h'];
                    else
                        hexport_data = [];
                    end
                    
                    %y-errors
                    eindex = findstr('e',plot_info_temp.export_column_format);
                    temp = find(eindex>=yindex);
                    if not(isempty(temp));
                        eindex = eindex(temp(1));
                        eexport_data = plot_info_temp.export_data(:,eindex); %current e export data for this curve
                        export_column_format = [export_column_format 'e'];
                    else
                        eexport_data = [];
                    end
                    
                    
                    plot_info_temp.export_data = [xexport_data, yexport_data, hexport_data, eexport_data,];
                    plot_info_temp.export_column_format = export_column_format;
                    
                    %Store the plot_info in the curve userdata
                    set(plot_handle(1),'userdata',plot_info_temp,'linewidth',linewidth,'markersize',markersize);
                    plot_info = rmfield(plot_info,'plot_data'); %Remove plot_data so next curve plotted gets new data stored in plot_data
                end
                
            elseif strcmp(plot_info.plot_type,'bar');
                
                set(grasp_plot_handles.axis,'nextplot','add') %Same as hold on
                plot_handle = bar(grasp_plot_handles.figure,'xdata',xdata,'ydata',ydata,'linestyle',linestyle,'linewidth',linewidth);
                
                %Store curve handle in axis userdata
                curve_handles = get(grasp_plot_handles.axis,'userdata');
                curve_handles{length(curve_handles)+1} = plot_handle;
                set(grasp_plot_handles.axis,'userdata',curve_handles);
                
                %Add to to the plot_info structure
                if not(isfield(plot_info,'plot_data'));
                    plot_info.plot_data.xdat = xdata;
                    plot_info.plot_data.ydat = ydata;
                    plot_info.plot_data.edat = edata;
                    plot_info.plot_data.exdat = [];
                end
                
                plot_info.column_format = 'xy';
                plot_info.plot_type = 'bar';
                plot_info.curve_number = total_curve_number;
                
                %Store the plot_info in the curve userdata
                set(plot_handle,'userdata',plot_info);
                plot_info = rmfield(plot_info,'plot_data'); %Remove plot_data so next curve plotted gets new data stored in plot_data
                
            end
            
            curve_number = curve_number +1;
        end
    end
    %Now add the titles to the graph
    warning off
    xlabel(grasp_plot_handles.axis,plot_info.x_label);
    ylabel(grasp_plot_handles.axis,plot_info.y_label);
    title(grasp_plot_handles.axis,plot_info.plot_title);
    warning on
end
%****************************************************************

%General update of the plot
grasp_plot_callbacks('build_curve_tools_menu',grasp_plot_handles);
grasp_plot_callbacks('update_legend',grasp_plot_handles);
grasp_plot_menu_callbacks; %General update of menu items