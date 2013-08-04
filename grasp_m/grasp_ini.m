function grasp_ini

global grasp_env
global status_flags


%Open File
fid = -1;
%Try smart opening of correct default instrument configuration .ini file
if ispc; hostname = getenv('COMPUTERNAME');
else [idum,hostname]= system('hostname');
end

temp = findstr(hostname,'11');
if not(isempty(temp));
    fid=fopen('grasp_d11.ini');
end

temp = findstr(hostname,'22');
if not(isempty(temp));
    fid=fopen('grasp_d22.ini');
end

temp = findstr(hostname,'33');
if not(isempty(temp));
    fid=fopen('grasp_d33.ini');
end

if fid ==-1 %Default
    fid=fopen('grasp.ini');
end

line = 1;
warning off

if not(fid==-1)
    disp('Loading Grasp Configuration from grasp.ini');
    
    while line~=-1
        line = fgets(fid);

        %Instrument
        if findstr(line,'inst=');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.inst = strtok(line(eqpos+1:len));
        end

        %Instrument Option
        if findstr(line,'inst_option=');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.inst_option = strtok(line(eqpos+1:len));
        end

        
        %Data Path
        if findstr(line,'data_dir');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.path.data_dir = strtok(line(eqpos+1:len));
        end

        %Project Path
        if findstr(line,'project_dir');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.path.project_dir = strtok(line(eqpos+1:len));
        end
        
        %Project Title
        if findstr(line,'project_title');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.project_title = strtok(line(eqpos+1:len));
        end
        
        %Display
        if findstr(line,'fontsize')
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.fontsize = str2num(line(eqpos+1:len));
            
        elseif findstr(line,'font');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.font = deblank(line(eqpos+1:len));
        end
        
        if findstr(line,'colormap_invert');
            eqpos = findstr(line,'=');
            len = length(line);
            status_flags.color.invert = str2num(line(eqpos+1:len));
            
        elseif findstr(line,'colormap_swap');
            eqpos = findstr(line,'=');
            len = length(line);
            status_flags.color.swap = str2num(line(eqpos+1:len));
            
        elseif findstr(line,'colormap');
            eqpos = findstr(line,'=');
            len = length(line);
            status_flags.color.map = strtok(line(eqpos+1:len));
        end

        if findstr(line,'render');
            eqpos = findstr(line,'=');
            len = length(line);
            status_flags.display.render = strtok(line(eqpos+1:len));
        end
        
        if findstr(line,'sub_figure_background_color');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.sub_figure_background_color = str2num(line(eqpos+1:len));
            
        elseif findstr(line,'background_color');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.background_color = str2num(line(eqpos+1:len));
        end

        %if findstr(line,'linestyle')
        %    eqpos = findstr(line,'=');
        %    len = length(line);
        %    status_flags.display.linestyle = (line(eqpos+1:len));
        %end
        
        %Worksheets
        if findstr(line,'worksheets=');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.worksheet.worksheets = str2num(line(eqpos+1:len));
        end

        if findstr(line,'worksheets_max=');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.worksheet.worksheet_max = str2num(line(eqpos+1:len));
        end

        if findstr(line,'depth_max=');
            eqpos = findstr(line,'=');
            len = length(line);
            grasp_env.worksheet.depth_max = str2num(line(eqpos+1:len));
        end
        
        %Data
        if findstr(line,'normalization');
            eqpos = findstr(line,'=');
            len = length(line);
            status_flags.normalization.status = strtok(line(eqpos+1:len));
        end
        if findstr(line,'standard_monitor');
            eqpos = findstr(line,'=');
            len = length(line);
            status_flags.normalization.standard_monitor = str2num(line(eqpos+1:len));
        end
        if findstr(line,'standard_time');
            eqpos = findstr(line,'=');
            len = length(line);
            status_flags.normalization.standard_time = str2num(line(eqpos+1:len));
        end
    end
    fclose(fid);
    warning on
else
    disp('''Grasp.ini'' doesn''t exist. Using default settings.');
end
