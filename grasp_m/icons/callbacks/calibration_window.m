function calibration_window(option) %check is the default flag for 'Use Sector mask'

global grasp_env
global grasp_handles
global status_flags
global grasp_data

if nargin <1;
    option = [];
else
    status_flags.calibration.calibrate_check = option;
end


%***** Open Calibration Analysis Window *****
if ishandle(grasp_handles.window_modules.calibration.window); delete(grasp_handles.window_modules.calibration.window); end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3)+265*grasp_env.screen.screen_scaling(1), grasp_env.screen.grasp_main_actual_position(2),   265*grasp_env.screen.screen_scaling(1)   360*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.calibration.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Calibration Options' ,....
    'NumberTitle', 'off',....
    'Tag','calibration_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','calibration_callbacks(''close'');closereq');

index = data_index(99);

%***** Correct for Detector efficiency *****
uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0 0.95 1 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','***** Detector Efficiency Correction *****','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%Efficiency map
uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.90 0.8 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Divide by Detector Efficieny Map:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.det_eff_chk = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.7 0.9 0.068 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','det_eff_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.calibration.det_eff_check,'callback','calibration_callbacks(''det_eff'')');
grasp_handles.window_modules.calibration.det_eff_nmbr = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.8 0.9 0.15 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','String','', 'ForegroundColor', [0 0 0]);

%D22 &D33 Efficiency Paralax
if strcmp(grasp_env.inst,'ILL_d22') || (strcmp(grasp_env.inst,'ILL_d33') && strcmp(grasp_env.inst_option,'D33_Instrument_Comissioning'));
%if strcmp(grasp_env.inst,'ILL_d22');
    uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.85 0.8 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Correct Detector Tube Paralax:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    grasp_handles.window_modules.calibration.d22_tube_angle_chk = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.8 0.85 0.068 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.calibration.d22_tube_angle_check,'callback','calibration_callbacks(''d22_tube_angle_correction'')');
end


%***** Callibration Method:  Water or direct Beam *****
uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0 0.8 1 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','***** Calibration Method *****','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

if strcmp(status_flags.calibration.method,'none'); water_beam_toggle = [1,0,0];
elseif strcmp(status_flags.calibration.method,'beam'); water_beam_toggle = [0,1,0];
elseif strcmp(status_flags.calibration.method,'water'); water_beam_toggle = [0, 0, 1];
end

uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.74 0.3 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','None:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.none_radio = uicontrol(grasp_handles.window_modules.calibration.window,'value',water_beam_toggle(1),'units','normalized','Position',[0.2 0.74 0.2 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'callback','calibration_callbacks(''toggle_none'')');
uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.30 0.74 0.3 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Direct Beam:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.beam_radio = uicontrol(grasp_handles.window_modules.calibration.window,'value',water_beam_toggle(2),'units','normalized','Position',[0.55 0.74 0.2 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'callback','calibration_callbacks(''toggle_beam'')');
uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.7 0.74 0.3 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Water:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.water_radio = uicontrol(grasp_handles.window_modules.calibration.window,'value',water_beam_toggle(3),'units','normalized','Position',[0.85 0.74 0.2 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'callback','calibration_callbacks(''toggle_water'')');



%***** Common Direct Beam and Water Parameters *****
%Sample Area and Thickness
grasp_handles.window_modules.calibration.waterbeam.text1 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.66 0.4 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Illuminated Sample'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.waterbeam.text9 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.65 0.66 0.2 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Thickness:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.waterbeam.thickness = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.68 0.60 0.18 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String','xxx','tag','sample_thickness_edit','callback','calibration_callbacks(''sample_thickness_edit'')');
grasp_handles.window_modules.calibration.waterbeam.text3 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.85 0.60 0.15 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',' : cm','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'tag','sample_area_misc');

%Sample volume
grasp_handles.window_modules.calibration.waterbeam.text4 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.50 0.8 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Divide by Sample Volume:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.waterbeam.volume_chk = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.8 0.50 0.068 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','sample_volume_chk','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.calibration.volume_normalize_check,'callback','calibration_callbacks(''sample_volume_chk'')');

%Pixel Solid Angle
grasp_handles.window_modules.calibration.waterbeam.text5 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.44 0.8 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Divide by Pixel Solid Angle:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.waterbeam.solid_angle_chk = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.8 0.44 0.068 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','sample_volume_chk','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.calibration.solid_angle_check,'callback','calibration_callbacks(''pixel_solid_angle_chk'')');



%***** Calibration to Direct Beam Parameters *****
%Beam Flux
grasp_handles.window_modules.calibration.beam.text3 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.38 0.8 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Divide by Beam Flux (Counts / Sample Area):','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.beam.beamflux_chk = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.8 0.38 0.068 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','sample_volume_chk','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.calibration.beam_flux_check,'callback','calibration_callbacks(''beam_flux_chk'')');
%Beam Worksheet
grasp_handles.window_modules.calibration.beam.text4 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.32 0.35 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Beam Worksheet:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.beam.wks = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.38 0.32 0.35 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','String','', 'ForegroundColor', [0 0 0]);
grasp_handles.window_modules.calibration.beam.nmbr = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.75 0.32 0.05 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','', 'ForegroundColor', [0 0 0]);
grasp_handles.window_modules.calibration.beam.dpth = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.85 0.32 0.05 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String','', 'ForegroundColor', [0 0 0]);


%***** Calibration to Water parameters *****
%Sample Area
%grasp_handles.window_modules.calibration.water.text7 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.4 0.66 0.2 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Area:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
%grasp_handles.window_modules.calibration.water.samplearea = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.34 0.60 0.18 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.calibration.sample_area),'tag','sample_area_edit','callback','calibration_callbacks(''sample_area_edit'')');
%grasp_handles.window_modules.calibration.water.text8 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.52 0.60 0.15 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',' : cm^2','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'tag','sample_area_misc');
% 
% %Flux-Colimation Scaling
% grasp_handles.window_modules.calibration.water.text1 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.38 0.8 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Flux-Collimation Auto Scaling:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
% grasp_handles.window_modules.calibration.water.fluxcol_check = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.8 0.38 0.068 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','flux_col_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.calibration.flux_col_check,'callback','calibration_callbacks(''flux_col_check'')');
% 

%divide by Water mean scattering
grasp_handles.window_modules.calibration.water.text2 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.32 0.8 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Divide by Water Mean Scattering:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.water.water_check = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.8 0.32 0.068 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.calibration.scalar_check,'callback','calibration_callbacks(''calib_scalar_check'')');
grasp_handles.window_modules.calibration.water.cal_scalar_value = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.3 0.26 0.25 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','String',num2str(grasp_data(index).mean_intensity1{status_flags.calibration.det_eff_nmbr}));
grasp_handles.window_modules.calibration.water.cal_scalar_units = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.60 0.26 0.4 0.04],'tag','calibration_scalar_units','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',grasp_data(index).mean_intensity_units1{status_flags.calibration.det_eff_nmbr},'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
% 
% %Calibration Area and Thickness
% grasp_handles.window_modules.calibration.water.text3 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.20 0.95 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Illuminated Calibration Sample Area & Thickness:'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
% grasp_handles.window_modules.calibration.water.area = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.34 0.14 0.18 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.calibration.standard_area),'tag','standard_area_edit','callback','calibration_callbacks(''standard_area_edit'')');
% grasp_handles.window_modules.calibration.water.text4 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.52 0.14 0.15 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',' : cm^2','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'tag','standard_area_misc');
% grasp_handles.window_modules.calibration.water.thickness = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.68 0.14 0.18 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.calibration.standard_thickness),'tag','standard_thickness_edit','callback','calibration_callbacks(''standard_thickness_edit'')');
% grasp_handles.window_modules.calibration.water.text5 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.85 0.14 0.1 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',' : cm','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'tag','standard_area_misc');
% 

%Calibration X Sections
grasp_handles.window_modules.calibration.water.text6 = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.05 0.18 0.8 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',['Calibration X-Section: ( / Unit Volume)'],'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.calibration.water.cal_xsection_check = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.8 0.18 0.068 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','Tag','calibration_xsection_check','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'value',status_flags.calibration.xsection_check,'callback','calibration_callbacks(''calib_xsection'')');
grasp_handles.window_modules.calibration.water.cal_xsection = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.68 0.12 0.18 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','tag','calibration_xsection','String',num2str(grasp_data(index).calibration_xsection{status_flags.calibration.det_eff_nmbr}),'callback','calibration_callbacks(''calib_xsection_edit'')');
%grasp_handles.window_modules.calibration.water.cal_xsection_units = uicontrol(grasp_handles.window_modules.calibration.window,'units','normalized','Position',[0.85 0.02 0.15 0.04],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String',' : cm^-1','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);


%***** END Calibration to Water parameters *****
%Update the displayed options
if strcmp(status_flags.calibration.method,'water')
    calibration_callbacks('toggle_water');
elseif strcmp(status_flags.calibration.method,'beam')
    calibration_callbacks('toggle_beam');
elseif strcmp(status_flags.calibration.method,'none')
    calibration_callbacks('toggle_none');
end


