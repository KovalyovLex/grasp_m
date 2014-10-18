function add_worksheet(wks_type)

global status_flags
global grasp_data

if nargin <1;
    wks_type = status_flags.selector.fw;
end

if wks_type >=1 && wks_type <=7; %i.e. scattering data types
    for n = 1:7 %go though all scattering data & masks
        index = data_index(n);
        disp(['Adding ' grasp_data(index).name ' Worksheet Number ' num2str(grasp_data(index).nmbr+1)]);
        initialise_data_arrays(n, grasp_data(index).nmbr+1)
    end
   
    selector_build
    selector_build_values
    grasp_update
    
elseif wks_type == 99 %i.e. Detector Efficiency
    index = data_index(wks_type);
    disp(['Adding ' grasp_data(index).name ' Worksheet Number ' num2str(grasp_data(index).nmbr+1)]);
    initialise_data_arrays(wks_type, grasp_data(index).nmbr+1)
    selector_build
    selector_build_values
    grasp_update
else
    disp('Can only add scattering data type worksheets for the moment')
end


