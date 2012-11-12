function clear_wks_nmbr(wks,n);

%Inputs: wks - as string
%n - as number
%Clears Data Worksheet Number - all depth.

global grasp_data

index = data_index(wks);
disp(['Clearing Worksheet:  ' grasp_data(index).name ' #' num2str(n)]); 
disp('  ');

initialise_data_arrays(wks,n)
