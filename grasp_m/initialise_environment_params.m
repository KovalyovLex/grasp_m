function initialise_environment_params

%Sets up the general Grasp environment parameters stored in 'grasp_env'
%Some of these parameters may be over written by subsequent grasp.ini
%or project load

global grasp_env;  %The general grasp environment variable

%Default Instrument
grasp_env.inst = 'ILL_d22';
grasp_env.inst_option = []; %Used for New/Old D11, D22 Raw data etc.

%Default project title
grasp_env.project_title = 'UNTITLED';

%Font Style and Sizes. These should be tuned depending on the system
grasp_env.font = 'Arial';
grasp_env.fontsize = 9; %Windows NT/98 (1280x1024 - Small Fonts)

%Default Display Colours
grasp_env.background_color = [0.2 0.22 0.21]; %- Dark Grey /Green
grasp_env.sub_figure_background_color = [0.4 0.05 0]; %- Burgundy
grasp_env.displayimage.active_axis_color = 'red'; %Red
grasp_env.displayimage.inactive_axis_color = 'white'; %White

%Set European paper type & background
set(0,'defaultfigurepapertype','a4');
colordef black; %Window bacground

%Screen resolution and scaling
screen = screen_scaling; %This is now done in its own function as is used elsewhere
grasp_env.screen.screen_size = screen.screen_size;
%Grasp default window dimensions
grasp_env.screen.grasp_main_default_position = [110, 85, 750, 870]; %x0,y0,dx0,dy0
grasp_env.screen.grasp_main_toolbar_overhead = 47; %Pixels taken up by tool bar etc not counted in figure dimensions.


%Default Data Dir
grasp_env.path.data_dir = 'c:\'; %PC path to network drive 'z' attached to SERDON/DATA/
%data_dir = '/usr/illdata/data/'; %For Unix
grasp_env.path.project_dir = 'c:\';

%Worksheet management
grasp_env.worksheet.worksheets = 6; %Number of Worksheets per Worksheet Group
grasp_env.worksheet.worksheet_max = 20; %Max number of Worksheets
grasp_env.worksheet.depth_max = 500; 

