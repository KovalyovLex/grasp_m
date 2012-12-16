function auto_fit(file, tepVal, exportImage, from, to)

    global status_flags;
    global dataMatrix; % for output data
    global colToExport;    
    global headerDataMatrix; % headers for output data
    
    dataMatrix = [];
    colToExport = 1;
    headerDataMatrix = {};
    
    filePrefix = '';
    fileFormat = '';

    for i = 1:length(file)
        if ( file( length(file) - i + 1 ) == '.')
            filePrefix = file(1 : length(file) - i);
            fileFormat = file(length(file) - i + 1 : length(file));
            break
        end
    end

    filenames = [];
    fid = [];

    fileID =  fopen(file, 'a');

    for n = 1:length(status_flags.fitter.function_info_1d.long_names)
        %TODO
        %PARAMETER NAME
        filenames{n} = [ filePrefix '_' status_flags.fitter.function_info_1d.long_names{n} '.' status_flags.fitter.function_info_1d.variable_names{n} '_' num2str(n) fileFormat ];

        fid(n) = fopen(filenames{n}, 'a');
    end

    h = findobj('name', 'Radial Re-grouping: |q|');
    close(h);

    i = from;
    if (to < from)
        % reverse cycle
        while(i >= to)
            processData(i, tepVal, exportImage, fid, filePrefix, fileID);

            i = i - 1;
        end
    else
        %normal cycle
        while(i <= to)
            processData(i, tepVal, exportImage, fid, filePrefix, fileID);
            
            i = i + 1;
        end
    end

    for n = 1:length(fid)
        fclose( fid(n) );
    end
    fclose(fileID);

    % file to export data
    file_to_out = [filePrefix '_exportData' fileFormat];
    fileExport =  fopen(file_to_out, 'a');
    
    temp = size(dataMatrix);
    for j = 1:temp(2)
       fprintf(fileExport, [ headerDataMatrix{1, j} ' ']);
    end
    % windows format of end string
    fprintf(fileExport,[char(13) char(10)]);
    for j = 1:temp(2)
       fprintf(fileExport, [ headerDataMatrix{2, j} ' ']);
    end
    % windows format of end string
    fprintf(fileExport,[char(13) char(10)]);
    for i = 1:temp(1)
       for j = 1:temp(2)
           fprintf(fileExport, [ num2str(dataMatrix(i, j)) ' ']);
       end
       % windows format of end string
       fprintf(fileExport,[char(13) char(10)]);
    end
    fclose(fileExport);
end

function processData(i, tepVal, exportImage, fid, filePrefix, fileID)

    global status_flags;
    global grasp_handles;
    global displayimage;
    global inst_params;

    tempOut = 0;
    
    set(grasp_handles.figure.fore_dpth, 'value', i);
    status_flags.selector.fd = get(grasp_handles.figure.fore_dpth,'value');
    main_callbacks('update_depths'); %Done in a different routine so can be called from elsewhere

    sector_window;
    % Open Radial Average box
    status_flags.analysis_modules.radial_average.sector_mask_chk = 1;
    radial_average_window;

    % Open Avarage window
    radial_average_callbacks('averaging_control','radial_q');
    % open grap plot fit window
    grasp_plot_fit_window;

    % Start fitting
    grasp_plot_fit_callbacks('fit_it');

    if tepVal == 1
        % out Tsemp
        tempOut = displayimage.params1(inst_params.vectors.tset);
    elseif tepVal == 2
        % out Treg
        tempOut = displayimage.params1(inst_params.vectors.treg);
    elseif tepVal == 3
        % out Temp
        tempOut = displayimage.params1(inst_params.vectors.temp);
    end
    fname = [filePrefix '_plot_' num2str(tempOut) '.jpg'];
    fprintf(fileID,[ num2str(tempOut) ' ' ]);
    
    for n = 1:length(status_flags.fitter.function_info_1d.long_names)
            fprintf(fid(n),[ num2str(tempOut) ' ' num2str(status_flags.fitter.function_info_1d.values(n)) ' ' num2str(status_flags.fitter.function_info_1d.err_values(n)) '\n']);
            fprintf(fileID,[ num2str(status_flags.fitter.function_info_1d.values(n)) ' ' num2str(status_flags.fitter.function_info_1d.err_values(n)) ' ' ]);
    end

    fprintf(fileID, '\n');

    h = findobj('name', 'Radial Re-grouping: |q|');
    figure(h);
    pause(1);

    % export to jpg format
    if exportImage
       print(h, '-djpeg100','-noui',fname);
    end
    
    pause(0.1);
    
    collectData(tempOut);

    close(h);
end

function collectData(tempOut)
    % number of column to export
    global colToExport;
    % matrix to export
    global dataMatrix;
    global headerDataMatrix;
    
    %Some useful handles to the current Grasp_Plot
    grasp_plot_figure = findobj('tag','grasp_plot');
    if not(isempty(grasp_plot_figure));
        grasp_plot_figure = grasp_plot_figure(1);
        grasp_plot_handles = get(grasp_plot_figure,'userdata');
        curve_handles = get(grasp_plot_handles.axis,'userdata');
    end
    
    %Loop though all the curves in the plot
    for n = 1:length(curve_handles);

        %Retrieve data from plot
        plot_info = get(curve_handles{n}(1),'userdata');
        
        export_data = plot_info.export_data;

        %Strip out any Nans
        temp = find(not(isnan(export_data(:,1))));
        export_data = export_data(temp,:);
        size(export_data)

        export_data = export_data(:,1:3); % may be delete this ?
        
        temp = size(export_data);
        
        %Check if 4th column exists (resolution)
%         if temp(2) >3; %4th column exists
%             disp('4th column data exists - q-resolution?')
%             %Check if to include q-reslution (4th column)
%             if strcmp(status_flags.subfigure.export.include_resolution,'on')
%                 disp('Including q-resolution')
%                 %Check what format of q-resolution, sigma, hwhm, fwhm
%                 %Default coming though from Grasp is fwhm
%                 if strcmp(status_flags.subfigure.export.resolution_format,'hwhm') %Convert to hwhm
%                     export_data(:,4) = export_data(:,4)/2; %hwhm
%                 elseif strcmp(status_flags.subfigure.export.resolution_format,'sigma') %Convert to sigma
%                     export_data(:,4) = export_data(:,4)/ (2 * sqrt(2 * log(2)));%gaussian sigma
%                 end
%             else
%                 %strip the 4th column out of the export data
%                 disp('Removing 4th column (q-resolution?) before export')
%                 export_data = export_data(:,1:3);
%             end
%         end
        
        % copy data to our buffer
        if (colToExport == 1)
            start = 1;
        else
            start = 2;
        end
        
        for k = start:temp(2)
            if (k == 1)
                headerDataMatrix {1, colToExport} = 'q\\T';
                headerDataMatrix {2, colToExport} = 'q';
            elseif (k == 2)
                % I(temp)
                headerDataMatrix {1, colToExport} = [num2str(tempOut) 'K'];
                headerDataMatrix {2, colToExport} = ['I(' num2str(tempOut) ')'];
            elseif (k == 3)
                % Ierr(temp)
                headerDataMatrix {1, colToExport} = [num2str(tempOut) 'K'];
                headerDataMatrix {2, colToExport} = ['Ierr(' num2str(tempOut) ')'];
            elseif (k == 4)
                % q-resolution(temp)
                headerDataMatrix {1, colToExport} = [num2str(tempOut) 'K'];
                headerDataMatrix {2, colToExport} = ['q-resolution(' num2str(tempOut) ')'];
            end
            dataMatrix(:,colToExport) = export_data(:,k);
            colToExport = colToExport + 1;
        end
    end
end

% temp params: (names in inst_params.vector_names)
%displayimage.params1(inst_params.vectors.tset)
%displayimage.params1(inst_params.vectors.treg)
%displayimage.params1(inst_params.vectors.temp)