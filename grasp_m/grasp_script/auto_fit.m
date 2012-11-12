function auto_fit(file, tepVal)

global status_flags;
global grasp_handles;
global displayimage;
global inst_params;

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

for i = 2:status_flags.selector.fdpth_max
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
        fprintf(fileID,[ num2str(displayimage.params1(inst_params.vectors.tset)) ' ' ]);
    end
    if tepVal == 2
        fprintf(fileID,[ num2str(displayimage.params1(inst_params.vectors.treg)) ' ' ]);
    end
    if tepVal == 3
        fprintf(fileID,[ num2str(displayimage.params1(inst_params.vectors.temp)) ' ' ]);
    end
    
    for n = 1:length(status_flags.fitter.function_info_1d.long_names)
            %TODO
            %PARAMETER NAME
            if tepVal == 1
                fprintf(fid(n),[ num2str(displayimage.params1(inst_params.vectors.tset)) ' ' num2str(status_flags.fitter.function_info_1d.values(n)) ' ' num2str(status_flags.fitter.function_info_1d.err_values(n)) '\n']);
            end
            if tepVal == 2
                fprintf(fid(n),[ num2str(displayimage.params1(inst_params.vectors.treg)) ' ' num2str(status_flags.fitter.function_info_1d.values(n)) ' ' num2str(status_flags.fitter.function_info_1d.err_values(n)) '\n']);
            end
            if tepVal == 3
                fprintf(fid(n),[ num2str(displayimage.params1(inst_params.vectors.temp)) ' ' num2str(status_flags.fitter.function_info_1d.values(n)) ' ' num2str(status_flags.fitter.function_info_1d.err_values(n)) '\n']);
            end
            
            fprintf(fileID,[ num2str(status_flags.fitter.function_info_1d.values(n)) ' ' num2str(status_flags.fitter.function_info_1d.err_values(n)) ' ' ]);
    end
    
    fprintf(fileID, '\n');
    
    h = findobj('name', 'Radial Re-grouping: |q|');
    figure(h);
    pause(1);
        
    % export tot eps format
    fname = [filePrefix '_plot_' num2str(i - 2) '.jpg'];
    if fname ~= 0
       print(h, '-djpeg100','-noui',fname);
    end
    pause(0.1);

    close(h);
end

for n = 1:length(status_flags.fitter.function_info_1d.long_names)
    %TODO
    %PARAMETER NAME
    fclose( fid(n) );
end
fclose(fileID);

end

% temp params: (names in inst_params.vector_names)
%displayimage.params1(inst_params.vectors.tset)
%displayimage.params1(inst_params.vectors.treg)
%displayimage.params1(inst_params.vectors.temp)