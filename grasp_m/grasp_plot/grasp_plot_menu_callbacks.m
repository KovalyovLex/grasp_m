function grasp_plot_menu_callbacks(to_do,option)

if nargin<2; option = []; end
if nargin<1; to_do = ''; end

global grasp_env
global status_flags
global grasp_handles


%Some useful handles to the current Grasp_Plot
grasp_plot_figure = findobj('tag','grasp_plot');
if not(isempty(grasp_plot_figure));
    grasp_plot_figure = grasp_plot_figure(1);
    grasp_plot_handles = get(grasp_plot_figure,'userdata');
    curve_handles = get(grasp_plot_handles.axis,'userdata');
end


switch to_do
    case 'show_q_resolution'
        status_flags.subfigure.show_resolution = option;
        warndlg('Please Replot for Resolution changes to take effect','Replot notification')
        
    case 'options_ascii'
        status_flags.subfigure.export.format = 'ascii';
        
    case 'options_illg'
        status_flags.subfigure.export.format = 'illg';
        
    case 'options_auto_filename'
        if strcmp(status_flags.subfigure.export.auto_filename,'on')
            status_flags.subfigure.export.auto_filename = 'off';
        else
            status_flags.subfigure.export.auto_filename = 'on';
        end
        
    case 'options_column_labels'
        if strcmp(status_flags.subfigure.export.column_labels,'on')
            status_flags.subfigure.export.column_labels = 'off';
        else
            status_flags.subfigure.export.column_labels = 'on';
        end
        
    case 'options_data_history'
        if strcmp(status_flags.subfigure.export.data_history,'on')
            status_flags.subfigure.export.data_history = 'off';
        else
            status_flags.subfigure.export.data_history = 'on';
        end
        
    case 'options_q_resolution'
        if strcmp(status_flags.subfigure.export.include_resolution,'on')
            status_flags.subfigure.export.include_resolution = 'off';
        else
            status_flags.subfigure.export.include_resolution = 'on';
        end
        
    case 'options_q_format'
        status_flags.subfigure.export.resolution_format = option;
        %warndlg('Please Replot for Resolution changes to take effect','Replot notification')
        
    case 'export_fit_curves'
        
        %Use different line terminators for PC or unix
        if ispc; newline = 'pc'; terminator_str = [char(13) char(10)]; %CR/LF
        else newline = 'unix'; terminator_str = [char(10)]; %LF
        end
        
        %Check if NOT to use auto file numbering
        if strcmp(status_flags.subfigure.export.auto_filename,'off');
            %Get file name proposal from run number
            plot_info = get(curve_handles{1}(1),'userdata');
            fname_in = num2str(plot_info.params(128));
            %File name dialog
            [fname_in, directory] = uiputfile([grasp_env.path.project_dir fname_in '.dat'],'Export Data');
            if isequal(fname_in,0) || isequal(directory,0) %Check the save dialog was'nt canceled
                return
            else
                grasp_env.path.project_dir = directory;
            end
        end
        
        %Loop though all the curves in the plot
        for n = 1:length(curve_handles);
            
            %Retrieve data from plot
            plot_info = get(curve_handles{n}(1),'userdata');
            
            %Check if curve fits exist
            
            if isfield(plot_info,'fit1d_curve_data')
                
                
                if isempty(plot_info.params);
                    fname_in = 'file_name';
                    %File name dialog
                    [fname, directory] = uiputfile([grasp_env.path.project_dir fname_in '.dat'],'Export Data');
                    if isequal(fname,0) || isequal(directory,0) %Check the save dialog was'nt canceled
                        return
                    else
                        grasp_env.path.project_dir = directory;
                    end
                elseif strcmp(status_flags.subfigure.export.auto_filename,'on');
                    %***** Build Output file name *****
                    numor_str = num2str(plot_info.params(128));
                    a = length(numor_str);
                    if a ==1; addzeros = '00000';
                    elseif a==2; addzeros = '0000';
                    elseif a==3; addzeros = '000';
                    elseif a==4; addzeros = '00';
                    elseif a==5; addzeros = '0';
                    elseif a==6; addzeros = ''; end
                    fname = [addzeros numor_str '_' num2str(plot_info.curve_number,'%6.3i') '_fit.dat'];
                else
                    %Make file has correct extension '_fit.dat'
                    %& add file number to filename
                    temp = findstr('.',fname_in);
                    if isempty(temp); fname = [fname_in '_' num2str(n,'%6.3i') '_fit.dat'];
                    else fname = [fname_in(1:(temp(1)-1)) '_' num2str(n,'%6.3i') '_fit.dat']; end
                end
                
                %Open file for writing
                disp(['Exporting Fit Curve data: '  grasp_env.path.project_dir fname]);
                fid=fopen([grasp_env.path.project_dir fname],'wt');
                
                %Check if include fit history header
                if strcmp(status_flags.subfigure.export.data_history,'on') & isfield(plot_info,'fit1d_history');
                    history = plot_info.fit1d_history;
                    for m = 1:length(history)
                        textstring = history{m};
                        fprintf(fid,'%s \n',textstring);
                    end
                    fprintf(fid,'%s \n','');
                    fprintf(fid,'%s \n','');
                end
                export_data = plot_info.fit1d_curve_data;
                dlmwrite([grasp_env.path.project_dir fname],export_data,'delimiter','\t','newline',newline,'-append','precision',6);
                fclose(fid);
                
            else
                disp(['No curve fits to export for curve # ' num2str(n)]);
            end
            
        end
        
        
        
    case 'export_data'
        if strcmp(status_flags.subfigure.export.format,'ascii')
            grasp_plot_menu_callbacks('export_ascii');
        elseif strcmp(status_flags.subfigure.export.format,'illg')
            grasp_plot_menu_callbacks('export_illg');
        end
        
        
    case 'export_illg'
        
        %Check the save dialog was'nt canceled
        for n = 1:length(curve_handles);
            %**** Get the current curve data *****
            plot_info = get(curve_handles{n}(1),'userdata');
            if isfield(plot_info,'plotdata')
                export_data = plot_info.plotdata;
            else
                export_data = [plot_info.xdata,plot_info.ydata,plot_info.edata];
            end
            params =  plot_info.params;
            parsub = plot_info.parsub;
            
            %***** Check directory and file numor *****
            [fname, directory] = uiputfile([grasp_env.path.project_dir num2str(params(128)) '.100'],'Export ILL Format Regrouped Data');
            if fname ~=0
                grasp_env.path.project_dir = directory;
                %***** Write the file *****
                temp = findstr('.',fname);
                if not(isempty(temp))
                    fname = fname(1:temp-1);
                end
                numor = str2num(fname);
                disp(['Exporting data ILL format data']);
                ill_sans_1ddata_write(export_data,params,parsub,numor,grasp_env.path.project_dir);
            end
        end
        
    case 'export_ascii'
        
        %Use different line terminators for PC or unix
        if ispc; newline = 'pc'; terminator_str = [char(13) char(10)]; %CR/LF
        else newline = 'unix'; terminator_str = [char(10)]; %LF
        end
        
        %Check if NOT to use auto file numbering
        if strcmp(status_flags.subfigure.export.auto_filename,'off');
            %Get file name proposal from run number
            plot_info = get(curve_handles{1}(1),'userdata');
            fname_in = num2str(plot_info.params(128));
            %File name dialog
            [fname_in, directory] = uiputfile([grasp_env.path.project_dir fname_in '.dat'],'Export Data');
            if isequal(fname_in,0) || isequal(directory,0) %Check the save dialog was'nt canceled
                return
            else
                grasp_env.path.project_dir = directory;
            end
        end
        
        
        
        %Loop though all the curves in the plot
        for n = 1:length(curve_handles);
            
            %Retrieve data from plot
            plot_info = get(curve_handles{n}(1),'userdata');
            if not(isfield(plot_info,'params'));
                 fname_in = 'file_name';
                %File name dialog
                [fname, directory] = uiputfile([grasp_env.path.project_dir fname_in '.dat'],'Export Data');
                if isequal(fname,0) || isequal(directory,0) %Check the save dialog was'nt canceled
                    return
                else
                    grasp_env.path.project_dir = directory;
                end
            elseif isempty(plot_info.params);
                fname_in = 'file_name';
                %File name dialog
                [fname, directory] = uiputfile([grasp_env.path.project_dir fname_in '.dat'],'Export Data');
                if isequal(fname,0) || isequal(directory,0) %Check the save dialog was'nt canceled
                    return
                else
                    grasp_env.path.project_dir = directory;
                end
            elseif strcmp(status_flags.subfigure.export.auto_filename,'on');
                %***** Build Output file name *****
                numor_str = num2str(plot_info.params(128));
                a = length(numor_str);
                if a ==1; addzeros = '00000';
                elseif a==2; addzeros = '0000';
                elseif a==3; addzeros = '000';
                elseif a==4; addzeros = '00';
                elseif a==5; addzeros = '0';
                elseif a==6; addzeros = ''; end
                fname = [addzeros numor_str '_' num2str(plot_info.curve_number,'%6.3i') '.dat'];
            else
                %Make file has correct extension '.dat'
                %& add file number to filename
                temp = findstr('.',fname_in);
                if isempty(temp); fname = [fname_in '_' num2str(n,'%6.3i') '.dat'];
                else fname = [fname_in(1:(temp(1)-1)) '_' num2str(n,'%6.3i') '.dat']; end
            end
            
            
            %Open file for writing
            disp(['Exporting data: '  grasp_env.path.project_dir fname]);
            fid=fopen([grasp_env.path.project_dir fname],'wt');
            
            %Check if to include history header
            if strcmp(status_flags.subfigure.export.data_history,'on');
                history = plot_info.history;
                
                for m = 1:length(history)
                    textstring = history{m};
                    fprintf(fid,'%s \n',textstring);
                end
                fprintf(fid,'%s \n','');
                fprintf(fid,'%s \n','');
            end
            
            export_data = plot_info.export_data;
            %Check if to include column labels
            if strcmp(status_flags.subfigure.export.column_labels,'on')
                if isfield(plot_info,'column_labels');
                    %Convert column labels to hwhm or fwhm if necessary
                    if strcmp(status_flags.subfigure.export.resolution_format,'hwhm') %Convert to hwhm
                        plot_info.column_labels = strrep(plot_info.column_labels,'FWHM_Q','HWHM_Q');
                    elseif strcmp(status_flags.subfigure.export.resolution_format,'sigma') %Convert to sigma
                        plot_info.column_labels = strrep(plot_info.column_labels,'FWHM_Q','Sigma_Q');
                    end
                    fprintf(fid,'%s \n',[plot_info.column_labels terminator_str]);
                    fprintf(fid,'%s \n','');
                end
            end
            
            %Strip out any Nans
            temp = find(not(isnan(export_data(:,1))));
            export_data = export_data(temp,:);
            size(export_data)
            %Check if 4th column exists (resolution)
            temp = size(export_data);
            if temp(2) >3; %4th column exists
                
                disp('4th column data exists - q-resolution?')
                %Check if to include q-reslution (4th column)
                if strcmp(status_flags.subfigure.export.include_resolution,'on')
                    disp('Including q-resolution')
                    %Check what format of q-resolution, sigma, hwhm, fwhm
                    %Default coming though from Grasp is fwhm
                    if strcmp(status_flags.subfigure.export.resolution_format,'hwhm') %Convert to hwhm
                        export_data(:,4) = export_data(:,4)/2; %hwhm
                    elseif strcmp(status_flags.subfigure.export.resolution_format,'sigma') %Convert to sigma
                        export_data(:,4) = export_data(:,4)/ (2 * sqrt(2 * log(2)));%gaussian sigma
                    end
                else
                    %strip the 4th column out of the export data
                    disp('Removing 4th column (q-resolution?) before export')
                    export_data = export_data(:,1:3);
                end
            end
            
            dlmwrite([grasp_env.path.project_dir fname],export_data,'delimiter','\t','newline',newline,'-append','precision',6);
            fclose(fid);
            
        end
end


%update_grasp_plot_menus
resolution_fwhm = 'off';
resolution_hwhm = 'off';
resolution_sigma = 'off';

if strcmp(status_flags.subfigure.export.format,'ascii');
    ascii_check = 'on'; illg_check = 'off'; status = 'on';
    autofile_checked = status_flags.subfigure.export.auto_filename;
    column_checked = status_flags.subfigure.export.column_labels;
    history_checked = status_flags.subfigure.export.data_history;
    resolution_checked = status_flags.subfigure.export.include_resolution;
    
    if strcmp(status_flags.subfigure.export.resolution_format,'fwhm');
        resolution_fwhm = 'on';
    elseif strcmp(status_flags.subfigure.export.resolution_format,'hwhm');
        resolution_hwhm = 'on';
    elseif strcmp(status_flags.subfigure.export.resolution_format,'sigma');
        resolution_sigma = 'on';
    end
else
    ascii_check = 'off'; illg_check = 'on'; status = 'off';
    autofile_checked = 'off';
    column_checked = 'off';
    history_checked = 'off';
    resolution_checked = 'off';
end
set(grasp_plot_handles.grasp_plot_menu.export_options.ascii,'checked',ascii_check);
set(grasp_plot_handles.grasp_plot_menu.export_options.illg,'checked',illg_check);
set(grasp_plot_handles.grasp_plot_menu.export_options.auto_filename,'checked',autofile_checked,'enable',status);
set(grasp_plot_handles.grasp_plot_menu.export_options.colum_labels,'checked',column_checked,'enable',status);
set(grasp_plot_handles.grasp_plot_menu.export_options.data_history,'checked',history_checked,'enable',status);
set(grasp_plot_handles.grasp_plot_menu.export_options.resolution,'checked',resolution_checked,'enable',status);
set(grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_root,'enable',status);
set(grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_fwhm,'enable',status,'checked',resolution_fwhm);
set(grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_hwhm,'enable',status,'checked',resolution_hwhm);
set(grasp_plot_handles.grasp_plot_menu.export_options.resolution_format_sigma,'enable',status,'checked',resolution_sigma);


if strcmp(status_flags.subfigure.show_resolution,'on');
    status1 = 'on'; status2 = 'off';
else
    status2 = 'on'; status1 = 'off';
end
set(grasp_plot_handles.grasp_plot_menu.analysis.show_res_on,'checked',status1);
set(grasp_plot_handles.grasp_plot_menu.analysis.show_res_off,'checked',status2);
%Also the tick in the main Grasp file menu
set(grasp_handles.menu.file.preferences.show_resolution,'checked',status1);





