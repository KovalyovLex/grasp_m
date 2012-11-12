function pa_optimise_window


global grasp_env
global grasp_handles
global status_flags

%***** Open Radial Average Window Window *****

if isfield(grasp_handles.window_modules.pa_tools,'optimise_window')
    if ishandle(grasp_handles.window_modules.pa_tools.optimise_window);
        delete(grasp_handles.window_modules.pa_tools.optimise_window);
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   640*grasp_env.screen.screen_scaling(1)   920*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.pa_tools.optimise_window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','3He Optimisation',....
    'NumberTitle', 'off',....
    'Tag','pol_3he_optimisation',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','pa_optimise_callbacks(''close'');closereq;');

handle = grasp_handles.window_modules.pa_tools.optimise_window;

%3He Polarisation
grasp_handles.window_modules.pa_optimise.pol_3he_text = uicontrol(handle,'units','normalized','Position',[0.1 0.955 0.2 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','3He Polarisation [%]','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_optimise.pol_3he_edit = uicontrol(handle,'units','normalized','Position',[0.1 0.92 0.15 0.03],'tooltip',' ','FontName',grasp_env.font,'FontSize',grasp_env.fontsize*2,'Style','edit','String',num2str(status_flags.pa_optimise.pa_3he_pol*100),'HorizontalAlignment','center','Visible','on','callback','pa_optimise_callbacks(''he_pol_edit'');');

%Optimum Opacity
grasp_handles.window_modules.pa_optimise.pol_optimum_text = uicontrol(handle,'units','normalized','Position',[0.35 0.955 0.2 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Optimum Opacity [bar.cm.angs]','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_optimise.pol_optimum_edit = uicontrol(handle,'units','normalized','Position',[0.35 0.92 0.15 0.03],'tooltip',' ','FontName',grasp_env.font,'FontSize',grasp_env.fontsize*2,'Style','edit','String',num2str(status_flags.pa_optimise.pa_3he_optimum),'HorizontalAlignment','center','Visible','on','callback','pa_optimise_callbacks(''he_optimum_opacity'');');

%Opacity Max Edit
grasp_handles.window_modules.pa_optimise.pol_opacity_text = uicontrol(handle,'units','normalized','Position',[0.91 0.58 0.08 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Max','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_optimise.pol_opacity_edit = uicontrol(handle,'units','normalized','Position',[0.91 0.56 0.08 0.02],'tooltip',' ','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.pa_optimise.pa_3he_opacity_max),'HorizontalAlignment','center','Visible','on','callback','pa_optimise_callbacks(''he_opacity_max'');');


%Pressure
grasp_handles.window_modules.pa_optimise.pol_pressure_text = uicontrol(handle,'units','normalized','Position',[0.65 0.96 0.2 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Pressure [bar]','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_optimise.pol_pressure_edit = uicontrol(handle,'units','normalized','Position',[0.65 0.94 0.1 0.03],'tooltip',' ','FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'Style','edit','String',num2str(status_flags.pa_optimise.pa_3he_pressure),'HorizontalAlignment','center','Visible','on','callback','pa_optimise_callbacks(''he_pressure_edit'');');

%Path Length
grasp_handles.window_modules.pa_optimise.pol_pathlength_text = uicontrol(handle,'units','normalized','Position',[0.65 0.89 0.2 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Path Length [cm]','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_optimise.pol_pathlength_edit = uicontrol(handle,'units','normalized','Position',[0.65 0.87 0.1 0.03],'tooltip',' ','FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'Style','edit','String',num2str(status_flags.pa_optimise.pa_3he_pathlength),'HorizontalAlignment','center','Visible','on','callback','pa_optimise_callbacks(''he_pathlength_edit'');');

%Wavelength
grasp_handles.window_modules.pa_optimise.pol_wavelength_text = uicontrol(handle,'units','normalized','Position',[0.82 0.93 0.2 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Wavelength [angs]','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_optimise.pol_wavelength_edit = uicontrol(handle,'units','normalized','Position',[0.82 0.91 0.1 0.03],'tooltip',' ','FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'Style','edit','String',num2str(status_flags.pa_optimise.pa_3he_wavelength),'HorizontalAlignment','center','Visible','on','callback','pa_optimise_callbacks(''he_wav_edit'');');


%Open Opacity Plot
grasp_handles.window_modules.pa_optimise.pa_optimise_plot = axes;
set(grasp_handles.window_modules.pa_optimise.pa_optimise_plot,'units','normalized','position',[0.10  0.56  0.8  0.3]);
xlabel(grasp_handles.window_modules.pa_optimise.pa_optimise_plot,'Opacity [bar.cm.angs]');
ylabel(grasp_handles.window_modules.pa_optimise.pa_optimise_plot,'Polarisation, Transmission & P^2T');
title(grasp_handles.window_modules.pa_optimise.pa_optimise_plot,'3He Optimisation Plot')






%Decay Time T1
grasp_handles.window_modules.pa_optimise.pol_3he_t1 = uicontrol(handle,'units','normalized','Position',[0.1 0.48 0.15 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','3He Decay Time, T1 [hrs]','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_optimise.pol_3he_t1_edit = uicontrol(handle,'units','normalized','Position',[0.1 0.44 0.15 0.03],'tooltip',' ','FontName',grasp_env.font,'FontSize',grasp_env.fontsize*2,'Style','edit','String',num2str(status_flags.pa_optimise.pa_3he_t1),'HorizontalAlignment','center','Visible','on','callback','pa_optimise_callbacks(''t1_edit'');');

%Time max
grasp_handles.window_modules.pa_optimise.pol_3he_time_max_text = uicontrol(handle,'units','normalized','Position',[0.3 0.48 0.15 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Time Max [hrs]','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_optimise.pol_3he_time_max_edit = uicontrol(handle,'units','normalized','Position',[0.3 0.44 0.1 0.03],'tooltip',' ','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.pa_optimise.pa_3he_time_max),'HorizontalAlignment','center','Visible','on','callback','pa_optimise_callbacks(''max_time_edit'');');


%Open Efficeincy 'a' vs. Time
grasp_handles.window_modules.pa_optimise.pa_efficiency_time_plot = axes;
set(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_plot,'units','normalized','position',[0.10  0.05 0.4  0.34]);
xlabel(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_plot,'Time [hrs]');
ylabel(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_plot,'Analyser Efficiency');
title(grasp_handles.window_modules.pa_optimise.pa_efficiency_time_plot,'Analyser Efficiency')

%Open Transmission Plot vs. Time
grasp_handles.window_modules.pa_optimise.pa_transmission_time_plot = axes;
set(grasp_handles.window_modules.pa_optimise.pa_transmission_time_plot,'units','normalized','position',[0.6  0.3 0.35  0.18]);
xlabel(grasp_handles.window_modules.pa_optimise.pa_transmission_time_plot,'Time [hrs]');
ylabel(grasp_handles.window_modules.pa_optimise.pa_transmission_time_plot,'Transmission');
title(grasp_handles.window_modules.pa_optimise.pa_transmission_time_plot,'Analyser Transmission')

%Open Polarisation of Unpolarised Beam Plot vs. Time
grasp_handles.window_modules.pa_optimise.pa_polbeam_time_plot = axes;
set(grasp_handles.window_modules.pa_optimise.pa_polbeam_time_plot,'units','normalized','position',[0.6  0.05 0.35  0.18]);
xlabel(grasp_handles.window_modules.pa_optimise.pa_polbeam_time_plot,'Time [hrs]');
ylabel(grasp_handles.window_modules.pa_optimise.pa_polbeam_time_plot,'Neutron Polarisation');
title(grasp_handles.window_modules.pa_optimise.pa_polbeam_time_plot,'Analyser Polarisation ')






%Update the Plot
pa_optimise_callbacks('update');

