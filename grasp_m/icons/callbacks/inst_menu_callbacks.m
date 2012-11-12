function inst_menu_callbacks(to_do,option1,option2)

                        

if nargin<3; option2 = []; end
if nargin<2; option1 = []; end

global grasp_env

switch to_do

    case 'change' %Change instrument
        
        button = file_menu('close');
        if not(strcmp(button,'cancel'))
            
            grasp_env.inst = option1;
            grasp_env.inst_option = option2;
            initialise_instrument_params;
            %initialise_status_flags;
            initialise_data_arrays
            selector_build;
            selector_build_values('all');
            initialise_2d_plots
            grasp_update
            tool_callbacks('rescale');
            update_last_saved_project
        end
        
    case 'sans_instrument_model'
        
        sans_instrument_model(grasp_env.inst);
        
        
        
end