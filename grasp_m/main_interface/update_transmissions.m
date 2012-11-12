function update_transmissions

global grasp_handles

[trans] = current_transmission; %[structure with fields ts, err_ts;  te, err_te]
set(grasp_handles.figure.trans_ts,'string',num2str(trans.ts));
set(grasp_handles.figure.trans_te,'string',num2str(trans.te));

%transmission errors are not currently displayed
