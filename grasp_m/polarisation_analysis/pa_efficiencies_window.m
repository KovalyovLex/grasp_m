function pa_efficiencies_window


global grasp_env
global grasp_handles
global status_flags
global grasp_data

%***** Open Radial Average Window Window *****

if isfield(grasp_handles.window_modules.pa_tools,'efficiencies_window')
    if ishandle(grasp_handles.window_modules.pa_tools.efficiencies_window);
        delete(grasp_handles.window_modules.pa_tools.efficiencies_window);
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   640*grasp_env.screen.screen_scaling(1)   920*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.pa_tools.efficiencies_window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Polarisation & Analysis Efficiencies Calculator',....
    'NumberTitle', 'off',....
    'Tag','pol_3he_optimisation',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','pa_efficiencies_callbacks(''close'');closereq;');

handle = grasp_handles.window_modules.pa_tools.efficiencies_window;


%Beam Worksheet
allowed_index = [10];
for n = 1:length(allowed_index);
    index = data_index(allowed_index(n));
    popup_string{n} = grasp_data(index).name;
    userdata(n) = allowed_index(n);
end

%FR Check Worksheet Selector
grasp_handles.window_modules.pa_tools.pa_efficiencies_worksheet_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.05 0.95 0.17 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','4-Spins Worksheet:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.pa_efficiencies_worksheet_popup = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.23 0.95 0.2 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','String',popup_string, 'value', status_flags.pa_optimise.pa_efficiency_wks, 'userdata',userdata, 'ForegroundColor', [0 0 0]);
grasp_handles.window_modules.pa_tools.pa_efficiencies_worksheet_wks = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.45 0.95 0.05 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','text','String',num2str(status_flags.pa_optimise.pa_efficiency_nmbr), 'ForegroundColor', [0 0 0]);

%FR & Efficiencies Calculate
grasp_handles.window_modules.pa_tools.pa_efficiencies_calc_button = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.6 0.95 0.2 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','pushbutton','String','Calculate Efficiencies', 'ForegroundColor', [0 0 0],'callback','pa_efficiencies_callbacks(''calculate_efficiencies'');');

%Start Date and Time - T0
grasp_handles.window_modules.pa_tools.pa_efficiencies_start_time_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.05 0.9 0.17 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Start Date & Time:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.pa_efficiencies_start_time_edit = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.23 0.9 0.25 0.02],'fontweight','bold','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','**-**-** **:**:**','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);


%Open Fp & Fa Plot
grasp_handles.window_modules.pa_efficiencies.fp_plot = axes;
set(grasp_handles.window_modules.pa_efficiencies.fp_plot,'units','normalized','position',[0.1  0.7  0.6  0.15]);
xlabel(grasp_handles.window_modules.pa_efficiencies.fp_plot,'Time [hrs]');
ylabel(grasp_handles.window_modules.pa_efficiencies.fp_plot,'Flipper Efficiency');
title(grasp_handles.window_modules.pa_efficiencies.fp_plot,'Flipper Efficiencies, Fp & Fa')

%Average Fp & Fa
grasp_handles.window_modules.pa_tools.pa_efficiencies_fpfa_average_text1 = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.75 0.8 0.17 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Average Efficiencies:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.pa_efficiencies_fp_average = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.75 0.78 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Fp:  ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.pa_efficiencies_fa_average = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.75 0.76 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Fa:  ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

%Use Average Fp & Fa Button
grasp_handles.window_modules.pa_tools.use_average_fpfa_button = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.75 0.7 0.17 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','pushbutton','String','Use!','callback','pa_efficiencies_callbacks(''use_fpfa'')');


%Fit Combined Efficiency Button
grasp_handles.window_modules.pa_tools.pa_efficiencies_fit_button = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.75 0.3 0.17 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','pushbutton','String','Fit It!','callback','pa_efficiencies_callbacks(''fit_combined_efficiency'')');




%Open Flipping Ratio Plot
grasp_handles.window_modules.pa_efficiencies.fr_plot = axes;
set(grasp_handles.window_modules.pa_efficiencies.fr_plot,'units','normalized','position',[0.1  0.48  0.6  0.15]);
xlabel(grasp_handles.window_modules.pa_efficiencies.fr_plot,'Time [hrs]');
ylabel(grasp_handles.window_modules.pa_efficiencies.fr_plot,'Flipping Ratio');
title(grasp_handles.window_modules.pa_efficiencies.fr_plot,'Flipping Ratio Pol & 3He')


%Open Combined Polariser & Analyser Efficiency Plot
grasp_handles.window_modules.pa_efficiencies.phi_plot = axes;
set(grasp_handles.window_modules.pa_efficiencies.phi_plot,'units','normalized','position',[0.1  0.26  0.6  0.15]);
xlabel(grasp_handles.window_modules.pa_efficiencies.phi_plot,'Time [hrs]');
ylabel(grasp_handles.window_modules.pa_efficiencies.phi_plot,'Efficiency, Phi');
title(grasp_handles.window_modules.pa_efficiencies.phi_plot,'Combined Pol & 3He Efficiency')
%Time max
grasp_handles.window_modules.pa_tools.pa_efficiencies_phi_time_max = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.72 0.26 0.1 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','edit','String',num2str(status_flags.pa_optimise.phi_time_max),'callback','pa_efficiencies_callbacks(''phi_time_max_edit'')');




%FINAL Polarisation and Analysis Correction parameters
%Polariser
grasp_handles.window_modules.pa_tools.parameter_p_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.05 0.15 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','text','String','Polariser Efficiency: ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.parameter_p_edit = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.32 0.15 0.1 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','edit','String',num2str(status_flags.pa_optimise.parameters.p(1)),'callback','pa_efficiencies_callbacks(''p_edit'')');
%RF Flipper
grasp_handles.window_modules.pa_tools.parameter_fp_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.05 0.12 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','text','String','RF Flipper, Fp: ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.parameter_fp_edit = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.32 0.12 0.1 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','edit','String',num2str(status_flags.pa_optimise.parameters.fp(1)),'callback','pa_efficiencies_callbacks(''fp_edit'')');
%3He Flipper
grasp_handles.window_modules.pa_tools.parameter_fa_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.05 0.09 0.25 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','text','String','3He Flipper, Fa: ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.parameter_fa_edit = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.32 0.09 0.1 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','edit','String',num2str(status_flags.pa_optimise.parameters.fa(1)),'callback','pa_efficiencies_callbacks(''fa_edit'')');


%3He Opacity
grasp_handles.window_modules.pa_tools.parameter_opacity_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.5 0.15 0.3 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','text','String','Opacity [bar.cm.angs: ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.parameter_opacity_edit = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.82 0.15 0.1 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','edit','String',num2str(status_flags.pa_optimise.parameters.opacity(1)),'callback','pa_efficiencies_callbacks(''opacity_edit'')');
%3He Initial Polarisation
grasp_handles.window_modules.pa_tools.parameter_3hepol_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.5 0.12 0.3 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','text','String','Initial 3He Pol [%]: ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.parameter_3hepol_edit = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.82 0.12 0.1 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','edit','String',num2str(status_flags.pa_optimise.parameters.p0(1)),'callback','pa_efficiencies_callbacks(''hepol_edit'')');
%3He Decay T1
grasp_handles.window_modules.pa_tools.parameter_t1_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.5 0.09 0.3 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','text','String','3He Decay T1 [hrs]: ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.parameter_t1_edit = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.82 0.09 0.1 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','edit','String',num2str(status_flags.pa_optimise.parameters.t1(1)),'callback','pa_efficiencies_callbacks(''t1_edit'')');
%3He Time Offset T0
grasp_handles.window_modules.pa_tools.parameter_t0_text = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.5 0.06 0.3 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','text','String','3He Time Offset, T0 [hrs]: ','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.pa_tools.parameter_t0_edit = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.82 0.06 0.1 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize*1.5,'HorizontalAlignment','right','Style','edit','String',num2str(status_flags.pa_optimise.parameters.t0(1)),'callback','pa_efficiencies_callbacks(''t0_edit'')');

%Grab fit parameters button
grasp_handles.window_modules.pa_tools.pa_efficiencies_grab_fit_params_button = uicontrol(grasp_handles.window_modules.pa_tools.efficiencies_window,'units','normalized','Position',[0.75 0.02 0.17 0.02],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','pushbutton','String','Grab Fit Params!','callback','pa_efficiencies_callbacks(''grab_fit_params'')');



%Update plots if previous data exists
pa_efficiencies_callbacks('update_plots');

