function update_beam_centre

global grasp_handles
global status_flags

cm = current_beam_centre; %[c_x,c_y]
cm = cm.(['det' num2str(status_flags.display.active_axis)]).cm_pixels;

set(grasp_handles.figure.beamcentre_cx,'string',num2str(cm(1)));
set(grasp_handles.figure.beamcentre_cy,'string',num2str(cm(2)));

