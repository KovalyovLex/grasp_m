function update_last_saved_project

global grasp_env
global inst_params
global status_flags
global grasp_data
global last_saved

last_saved = struct(....
    'grasp_env',grasp_env,....
    'inst_params',inst_params,....
    'status_flags',status_flags,....
    'grasp_data',grasp_data);
