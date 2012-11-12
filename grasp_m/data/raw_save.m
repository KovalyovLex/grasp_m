function raw_save(path, fname);

disp(['Saving Project: ' path fname]);

global last_saved; %Store of the last saved data for comparison
global inst_params;
global grasp_env
global grasp_data %Contains all data arrays in a big structure containing: 'name', 'nmbr', 'dpth', 'data', 'dsum', 'params', 'parsub', 'lm'
            %Typical data sheets:  'fore', 'back', 'trans', water', 'water_bck', 'direct', 'cadmium', 'empty', 'mask'            
global status_flags;

%Check that 'fname' has a .mat on the end.
if isempty(findstr(fname,'.mat'))
   fname = [fname '.mat'];
end

%Save the attachment figures first then the filename of these are stored
%with the main file for re-loading.
%See if there any output windows to be saved with it.
%strip the project name of .mat for attachment figures
attachment_name = strrep(fname,'.mat','');
attachment_figures = [];
attachment_2df = [];
if status_flags.file.save_sub_figures == 1;
    
    %Output Results Figures
    i = findobj('tag','grasp_plot');
    n = 0;
    if not(isempty(i))
        for n = 1:length(i)
            attachment_figures{n} = [attachment_name '_figure' num2str(n)];
            saveas(i(n),[path attachment_figures{n}],'fig');
        end
    end
    %2D curve Fitter
    i = findobj('tag','curve_fit_control_2d');
    n = n+1;
    if not(isempty(i))
        attachment_2df{n} = [attachment_name '_2Df'];
        saveas(i,[path attachment_2df{n}],'fig');
    end
end


last_saved = struct(....
    'grasp_env',grasp_env,....
    'inst_params',inst_params,....
    'status_flags',status_flags,....
    'grasp_data',grasp_data,'attachment_figures',attachment_figures,'attachment_2df',attachment_2df);

save([path fname],....
    'grasp_env',....
    'inst_params',....
    'status_flags',....
    'grasp_data',....
    'attachment_figures',....
    'attachment_2df');

