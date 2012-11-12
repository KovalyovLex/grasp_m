function hide_gui(gui_group,property,status)

%Gui_group specifies groups of gui objects, e.g. selector, transmission
%Property is the gui property to modify, e.g. 'visible','enable'
%Status is the status of the property to modify, e.g. 'off', 'on'

global status_flags
global grasp_handles

%Note:  In order to make the 'case' statement drop-through for multiple
%cases it has to be repeated for each of the multiple options

switch gui_group
    case {'foreground_wks','worksheet'}

        set(grasp_handles.figure.fore_wks,property,status);
        set(grasp_handles.figure.fore_nmbr,property,status);
        set(grasp_handles.figure.fore_dpth,property,status);
end


switch gui_group
    case {'background_wks','worksheet'}

        set(grasp_handles.figure.back_wks,property,status);
        set(grasp_handles.figure.back_dpth,property,status);
        set(grasp_handles.figure.back_chk,property,status);
        set(grasp_handles.figure.back_nmbr,property,status);
end


switch gui_group
    case {'cadmium_wks','worksheet'}

        set(grasp_handles.figure.cad_wks,property,status);
        set(grasp_handles.figure.cad_nmbr,property,status);
        set(grasp_handles.figure.cad_dpth,property,status);
        set(grasp_handles.figure.cad_chk,property,status);
end

switch gui_group
    case {'trans_nmbr','transmission'}
        set(grasp_handles.figure.trans_ts_nmbr,property,status);
        set(grasp_handles.figure.trans_te_nmbr,property,status);
end

switch gui_group
    case {'trans_calc','transmission','ts','te'}
        set(grasp_handles.figure.trans_tscalc,property,status);
end

switch gui_group
    case{'transmission'}
        set(grasp_handles.figure.trans_tslock_chk,property,status);
        set(grasp_handles.figure.trans_telock_chk,property,status);
        set(grasp_handles.figure.trans_ts,property,status);
        set(grasp_handles.figure.trans_te,property,status);
end

switch gui_group
    case{'ts'}
        set(grasp_handles.figure.trans_tslock_chk,property,status);
        set(grasp_handles.figure.trans_ts,property,status);
end

switch gui_group
    case{'te'}
        set(grasp_handles.figure.trans_telock_chk,property,status);
        set(grasp_handles.figure.trans_te,property,status);
end

switch gui_group
    case 'dataload'

        set(grasp_handles.figure.data_load,property,status);
        set(grasp_handles.figure.data_ext,property,status);
        set(grasp_handles.figure.data_lead,property,status);
        set(grasp_handles.figure.numor_plus,property,status);
        set(grasp_handles.figure.numor_minus,property,status);
        set(grasp_handles.figure.getit,property,status);

    case 'mask'

        set(grasp_handles.figure.mask_chk,property,status);
        set(grasp_handles.figure.calibrate_chk,property,status);

    case 'calibrate'

        set(grasp_handles.figure.calibrate_chk,property,status);

    case 'beamcentre'
        
        set(grasp_handles.figure.beamcentre_cx,property,status);
        set(grasp_handles.figure.beamcentre_cy,property,status);
        set(grasp_handles.figure.beamcentre_ctheta,property,status);
        set(grasp_handles.figure.beamcentre_lock_chk,property,status);
        set(grasp_handles.figure.beamcentre_calc,property,status);
        set(grasp_handles.figure.beamcentre_nmbr,property,status);

    case 'number_selectors'
        set(grasp_handles.figure.back_nmbr,property,status);
        set(grasp_handles.figure.cad_nmbr,property,status);
        set(grasp_handles.figure.trans_ts_nmbr,property,status);
        set(grasp_handles.figure.trans_te_nmbr,property,status);
        set(grasp_handles.figure.beamcentre_nmbr,property,status);
        set(grasp_handles.figure.mask_nmbr,property,status);

    case 'depth_selectors'
        set(grasp_handles.figure.back_dpth,property,status);
        set(grasp_handles.figure.cad_dpth,property,status);
        %set(grasp_handles.figure.trans_ts_dpth,'visible',dpth_status);
        %set(grasp_handles.figure.trans_te_dpth,'visible',dpth_status);
        %set(grasp_handles.figure.beamcentre_dpth,'visible',dpth_status);

        
        
    case 'number_selectors_hide'
        if status_flags.selector.ngroup == 1; nmbr_status= 'off'; else nmbr_status = 'on';end
        set(grasp_handles.figure.back_nmbr,'enable',nmbr_status);
        set(grasp_handles.figure.cad_nmbr,'enable',nmbr_status);
        set(grasp_handles.figure.trans_ts_nmbr,'visible',nmbr_status);
        set(grasp_handles.figure.trans_te_nmbr,'visible',nmbr_status);
        set(grasp_handles.figure.beamcentre_nmbr,'visible',nmbr_status);
        set(grasp_handles.figure.mask_nmbr,'visible',nmbr_status);
        set(grasp_handles.figure.trans_ts_nmbr,'enable',nmbr_status);
        set(grasp_handles.figure.trans_te_nmbr,'enable',nmbr_status);
        set(grasp_handles.figure.beamcentre_nmbr,'enable',nmbr_status);
        set(grasp_handles.figure.mask_nmbr,'enable',nmbr_status);

        
        
    case 'depth_selectors_hide'
        if status_flags.selector.dgroup == 1; dpth_status= 'off'; else dpth_status = 'on';end
        set(grasp_handles.figure.back_dpth,'enable',dpth_status);
        set(grasp_handles.figure.cad_dpth,'enable',dpth_status);
        %set(grasp_handles.figure.trans_ts_dpth,'visible',dpth_status);
        %set(grasp_handles.figure.trans_te_dpth,'visible',dpth_status);
        %set(grasp_handles.figure.beamcentre_dpth,'visible',dpth_status);
        
    case 'subtract'
        set(grasp_handles.figure.back_chk,property,status);
        set(grasp_handles.figure.cad_chk,property,status);

end


