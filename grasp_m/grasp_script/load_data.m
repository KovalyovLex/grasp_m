function load_data(wks, nmbr, load_str)

global status_flags
global grasp_handles

%Change to worksheet to load into
status_flags.selector.fw = wks;
status_flags.selector.fn = nmbr;
grasp_update

%Poke the load string into the load text box
set(grasp_handles.figure.data_load,'string',load_str);
main_callbacks('data_read'); %load the data


