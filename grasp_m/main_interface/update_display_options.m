function update_display_options

%Updates the display option checkboxes etc.
%depending on status_flags

global status_flags
global grasp_handles

%Update Figure Display option checkboxes
set(grasp_handles.figure.logz_chk,'value',status_flags.display.log);
set(grasp_handles.figure.image_chk,'value',status_flags.display.image);
set(grasp_handles.figure.contour_chk,'value',status_flags.display.contour);
set(grasp_handles.figure.smooth_chk,'value',status_flags.display.smooth.check);
set(grasp_handles.figure.back_chk,'value',status_flags.selector.b_check);
set(grasp_handles.figure.cad_chk,'value',status_flags.selector.c_check);
set(grasp_handles.figure.beamcentre_lock_chk,'value',status_flags.beamcentre.cm_lock);
set(grasp_handles.figure.mask_chk,'value',status_flags.display.mask.check);
set(grasp_handles.figure.trans_tslock_chk,'value',status_flags.transmission.ts_lock);
set(grasp_handles.figure.trans_telock_chk,'value',status_flags.transmission.te_lock);
set(grasp_handles.figure.beamcentre_lock_chk,'value',status_flags.beamcentre.cm_lock);
%set(grasp_handles.figure.detcal_chk,'value',status_flags.calibration.d22_soft_det_cal);
set(grasp_handles.figure.calibrate_chk,'value',status_flags.calibration.calibrate_check);
set(grasp_handles.figure.pa_chk,'value',status_flags.calibration.pa_chk);

%set(grasp_handles.figure.rotate_chk,'value',status_flags.display.rotate.check);
% if status_flags.display.rotate.check ==1; status = 'on'; else status = 'off'; end
% set(grasp_handles.figure.rotate_angle,'visible',status);


