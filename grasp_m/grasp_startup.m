%***** Grasp Startup Parameters Required for Matlab Script Version *****
disp('Running Grasp_Startup');


%***** Global variables availiable at the Matlab command prompt *****
global grasp_env;  %The general grasp environment variable
global status_flags %all the settings of menus etc.
global grasp_handles; %All the grasp graphic object handles
global inst_params;  %Contains the instrument description
global grasp_data %Contains all data arrays in a big structure containing: 'name', 'nmbr', 'dpth', 'data', 'dsum', 'params', 'parsub', 'lm'
global displayimage %A structure containing 'data', 'params', 'parsubm', 'lm' of the currently displayed image
global fit_parameters
global last_saved
global last_result

%***** Grasp Program Paths *****
if exist('chuck_root_grasp_path') %Root directories as specified per host name in chuck_startup.m
    grasp_env.path.grasp_root = chuck_root_grasp_path;
else
    
    machine_type = computer;
    
    if strcmp(machine_type,'PCWIN') %Windows
        hostname = getenv('COMPUTERNAME');
        if strcmp(hostname,'DEWHURSTPC3') %ILL Office Windows machine (duel boot)
            grasp_env.path.grasp_root = 'd:\matlab_code_backup\grasp_m_develop\';
        elseif strcmp(hostname,'CHUCKVBXP') %Chuck's Windows VirtualBox
            grasp_env.path.grasp_root = 'd:\Dropbox\Matlab\grasp_m_develop\';
        elseif strcmp(hostname,'DEWHURSTLNX-VM')  %ILL Office Windows7 Virtual Machine
            grasp_env.path.grasp_root = 'c:\Users\dewhurst\Desktop\Dropbox\Matlab\grasp_m_develop\';
        else
            grasp_env.path.grasp_root = 'c:\progra~1\grasp_m\'
        end
        
    elseif strcmp(machine_type,'PCWIN64') %Windows 64bit
         hostname = getenv('COMPUTERNAME');
        if strcmp(hostname,'DEWHURSTPC3') %ILL Office Windows machine (duel boot)
            grasp_env.path.grasp_root = 'd:\matlab_code_backup\grasp_m_develop\';
        elseif strcmp(hostname,'CHUCKVBXP') %Chuck's Windows VirtualBox
            grasp_env.path.grasp_root = 'd:\Dropbox\Matlab\grasp_m_develop\';
        elseif strcmp(hostname,'DEWHURSTLNX-VM')  %ILL Office Windows7 Virtual Machine
            grasp_env.path.grasp_root = 'c:\Users\dewhurst\Desktop\Dropbox\Matlab\grasp_m_develop\';
        else
            grasp_env.path.grasp_root = 'c:\progra~1\grasp_m\'
        end
        
    elseif strcmp(machine_type,'GLNX86') %32bit Linux
        [status,hostname] = system('hostname');
        if findstr(hostname,'dewhurstpc3') %ILL Office Linux Machine (duel boot)
            grasp_env.path.grasp_root = '~/Desktop/Dropbox/Matlab/grasp_m_develop/';
        elseif findstr(hostname,'dewhurstport') %ILL Linux Laptop
            grasp_env.path.grasp_root = '~/Desktop/Dropbox/Matlab/grasp_m_develop/';
        elseif findstr(hostname,'chuck-ubuntu') %Chuck's Home Linux Box 32bit
            grasp_env.path.grasp_root = '~/Desktop/Dropbox/Matlab/grasp_m_develop/';
        elseif findstr(hostname,'dewhurstlnx'); %chuck's office linux machine
            grasp_env.path.grasp_root = '~/Desktop/Dropbox/Matlab/grasp_m_develop/';
        else
            grasp_env.path.grasp_root = '~/grasp_m/';
        end
        
    elseif strcmp(machine_type,'GLNXA64') %64bit Linux
        [status,hostname] = system('hostname');
        if findstr(hostname,'chuck-ubuntu') %Chuck's Home Linux Box 64bit
            grasp_env.path.grasp_root = '~/Desktop/Dropbox/Matlab/grasp_m_develop/';
        elseif findstr(hostname,'dewhurstlnx'); %chuck's office linux machine
            grasp_env.path.grasp_root = '~/Desktop/Dropbox/Matlab/grasp_m_develop/';
        else
            grasp_env.path.grasp_root = '~/grasp_m/';
        end
        
    elseif strcmp(machine_type,'MACI') %32bit Mac CSIMAC
        grasp_env.path.grasp_root = '/Users/chuck/Desktop/grasp_m_develop/';
        
    elseif strcmp(machine_type,'MACI64') %64bit Mac CSIMAC
        [status,hostname] = system('hostname');
        if findstr(hostname,'pormac.gen.ill.fr')
            grasp_env.path.grasp_root = '/Applications/grasp_m';
        else
            grasp_env.path.grasp_root = '/Users/chuck/Desktop/grasp_m_develop/';
        end
    end
end
 

addpath(grasp_env.path.grasp_root);
addpath(fullfile(grasp_env.path.grasp_root,'math'));
addpath(fullfile(grasp_env.path.grasp_root,'sans_math'));
addpath(fullfile(grasp_env.path.grasp_root,'icons'));
addpath(fullfile(grasp_env.path.grasp_root,'sans_instrument'));
addpath(fullfile(grasp_env.path.grasp_root,'data'));
addpath(fullfile(grasp_env.path.grasp_root,'callbacks'));
addpath(fullfile(grasp_env.path.grasp_root,'colormaps'));
addpath(fullfile(grasp_env.path.grasp_root,'window_modules'));
addpath(fullfile(grasp_env.path.grasp_root,'user_modules'));
addpath(fullfile(grasp_env.path.grasp_root,'user_modules','fll_math'));
addpath(fullfile(grasp_env.path.grasp_root,'user_modules','d33'));
addpath(fullfile(grasp_env.path.grasp_root,'grasp_script'));
addpath(fullfile(grasp_env.path.grasp_root,'grasp_changer'));
addpath(fullfile(grasp_env.path.grasp_root,'sans_instrument_model'));
addpath(fullfile(grasp_env.path.grasp_root,'grasp_plot'));
addpath(fullfile(grasp_env.path.grasp_root,'grasp_plot','fit_functions'));
addpath(fullfile(grasp_env.path.grasp_root,'polarisation_analysis'));
addpath(fullfile(grasp_env.path.grasp_root,'main_interface'));






