function rebin_window


global grasp_env
global grasp_handles


%***** Open Radial Average Window Window *****

if isfield(grasp_handles.window_modules,'rebin')
    if isfield(grasp_handles.window_modules.rebin,'window')
        if ishandle(grasp_handles.window_modules.rebin.window);
            delete(grasp_handles.window_modules.rebin.window);
        end
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3)+265*grasp_env.screen.screen_scaling(1) , grasp_env.screen.grasp_main_actual_position(2),   265*grasp_env.screen.screen_scaling(1)   312*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.rebin.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Rebin',....
    'NumberTitle', 'off',....
    'Tag','radialav_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','rebin_callbacks(''close'');closereq;');

handle = grasp_handles.window_modules.rebin.window;


%Bin Spacing
uicontrol(handle,'units','normalized','Position',[0.05 0.80 0.6 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Bin Spacing [q_min -> q_max]:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','position',[0.65 0.85 0.4 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','String','Linear      Log','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1]);
grasp_handles.window_modules.rebin.radio_lin = uicontrol(handle,'units','normalized','position',[0.68 0.8 0.07 0.05],'tooltip','Liner Bin Spacing','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'callback','rebin_callbacks(''lin_radio'')');
grasp_handles.window_modules.rebin.radio_log = uicontrol(handle,'units','normalized','position',[0.88 0.8 0.07 0.05],'tooltip','Logarithmic Bin SpacingA','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','radiobutton','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1,1,1],'callback','rebin_callbacks(''log_radio'')');

%Number of Bins
uicontrol(handle,'units','normalized','Position',[0.05 0.65 0.5 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Max Number of Bins:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.window_modules.rebin.n_bins = uicontrol(handle,'units','normalized','Position',[0.68 0.65 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','edit','String','','callback','rebin_callbacks(''n_bins'');');

%delta_q/q bands
uicontrol(handle,'units','normalized','Position',[0.05 0.5 0.5 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','delta_q / q Filters:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.window_modules.rebin.dqq_filter = uicontrol(handle,'units','normalized','Position',[0.1 0.45 0.8 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','edit','String','','callback','rebin_callbacks(''dqq_bands'');');

%Rebin Weightings
%dI/I weighting Power
uicontrol(handle,'units','normalized','Position',[0.05 0.3 0.5 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','dI/I Weighting Power:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.window_modules.rebin.dii_power = uicontrol(handle,'units','normalized','Position',[0.68 0.3 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','edit','String','','callback','rebin_callbacks(''dii_power'');');

%dq/q weighting Power
uicontrol(handle,'units','normalized','Position',[0.05 0.2 0.5 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','dQ/Q Weighting Power:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.figure.window_modules.rebin.dqq_power = uicontrol(handle,'units','normalized','Position',[0.68 0.2 0.15 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','edit','String','','callback','rebin_callbacks(''dqq_power'');');


rebin_callbacks

 