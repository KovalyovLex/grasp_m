function update_selectors

%Updates the position and values of the data selectors
%depending on status_flags

global status_flags
global grasp_handles
global grasp_data

%Set the selector to the correct values
index = data_index(status_flags.selector.fw);
last_displayed = grasp_data(index).last_displayed;
userdata = get(grasp_handles.figure.fore_wks,'userdata');
list_index = find(userdata==status_flags.selector.fw);
set(grasp_handles.figure.fore_wks,'value',list_index);
if last_displayed(1)~=0
    userdata = get(grasp_handles.figure.back_wks,'userdata');
    list_index = find(userdata==status_flags.selector.bw);
    set(grasp_handles.figure.back_wks,'value',list_index);
    last_displayed(1) = status_flags.selector.bw;
end
if last_displayed(2)~=0
    userdata = get(grasp_handles.figure.cad_wks,'userdata');
    list_index = find(userdata==status_flags.selector.cw);
    set(grasp_handles.figure.cad_wks,'value',list_index);
    last_displayed(2) = status_flags.selector.cw;
end
grasp_data(index).last_displayed = last_displayed;

%Worksheet depth & group chk
set(grasp_handles.figure.wks_group_chk,'value',status_flags.selector.ngroup);
set(grasp_handles.figure.dpth_group_chk,'value',status_flags.selector.dgroup);

%Worksheet number
set(grasp_handles.figure.fore_nmbr,'value',status_flags.selector.fn);
set(grasp_handles.figure.back_nmbr,'value',status_flags.selector.bn);
set(grasp_handles.figure.cad_nmbr,'value',status_flags.selector.cn);

if status_flags.transmission.ts_lock == 0;
    set(grasp_handles.figure.trans_ts_nmbr,'value',status_flags.transmission.ts_number);
end
if status_flags.transmission.te_lock == 0;
    set(grasp_handles.figure.trans_te_nmbr,'value',status_flags.transmission.te_number);
end
if status_flags.beamcentre.cm_lock == 0; %beam centre is NOT locked
    set(grasp_handles.figure.beamcentre_nmbr,'value',status_flags.beamcentre.cm_number);
end
set(grasp_handles.figure.mask_nmbr,'value',status_flags.display.mask.number);

%Worksheet depth
set(grasp_handles.figure.fore_dpth,'value',status_flags.selector.fd);
set(grasp_handles.figure.back_dpth,'value',status_flags.selector.bd);
set(grasp_handles.figure.cad_dpth,'value',status_flags.selector.cd);

