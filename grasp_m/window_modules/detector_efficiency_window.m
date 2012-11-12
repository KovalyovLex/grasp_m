function detector_efficiency_window

global grasp_env
global grasp_handles
global status_flags

%***** Detector Efficieny Window *****
if ishandle(grasp_handles.window_modules.detector_efficiency.window);
    delete(grasp_handles.window_modules.detector_efficiency.window);
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   265*grasp_env.screen.screen_scaling(1)   312*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.detector_efficiency.window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Detector Efficeincy Calculator',....
    'NumberTitle', 'off',....
    'Tag','water_analysis_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','detector_efficiency_callbacks(''close'');closereq');

handle = grasp_handles.window_modules.detector_efficiency.window;

%Display Average Pixel Value - Calibration Scalar
uicontrol(handle,'units','normalized','Position',[0.02 0.81 0.5 0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Mean Intensity:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.detector_efficiency.cal_average_units = uicontrol(handle,'units','normalized','Position',[0.05 0.75 0.9 0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','tag','water_average_units','String','xxxxxx','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.detector_efficiency.cal_average_value = uicontrol(handle,'units','normalized','Position',[0.55 0.82 0.4 0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','Tag','average_water_value','String','xxxxxx');

%Diagnostics: Plot Histogram Button
uicontrol(handle,'units','normalized','Position',[0.02 0.60 0.5 0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','text','String','Diagnostics:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1,1,1]);
grasp_handles.window_modules.detector_efficiency.histogram_button = uicontrol(handle,'units','normalized','Position',[0.55 0.61 0.4 0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','pushbutton','String','Plot Histogram','HorizontalAlignment','center','Tag','efficiency_histogram_button','Visible','on','CallBack','detector_efficiency_callbacks(''histogram'');');

%Sketch Efficiency
uicontrol(handle,'units','normalized','Position',[0.02 0.48 0.5 0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','text','String','Manual Paste Eff. = 1:','HorizontalAlignment','right','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1,1,1]);
grasp_handles.window_modules.detector_efficiency.det_efficiency_sketch = uicontrol(handle,'units','normalized','Position',[0.55 0.49 0.4 0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','pushbutton','String','Sketch Efficiency','HorizontalAlignment','center','Tag','sketch_efficiency_button','Visible','on','CallBack','detector_efficiency_callbacks(''sketch'');');

%Accept Callibration
grasp_handles.window_modules.detector_efficiency.det_efficiency_button = uicontrol(handle,'units','normalized','Position',[0.1,0.35,0.8,0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','pushbutton','String','Accept Detector Efficiency','HorizontalAlignment','center','Tag','det_efficiency_button','Visible','on','CallBack','detector_efficiency_callbacks(''accept'');');

%Merge Det Eff 1 & 2
grasp_handles.window_modules.detector_efficiency.det_efficiency_merge_button = uicontrol(handle,'units','normalized','Position',[0.1,0.2,0.8,0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','pushbutton','String','Merge Efficiencies 1 & 2','HorizontalAlignment','center','Visible','on','CallBack','detector_efficiency_callbacks(''merge'');');

%Split Line Number
uicontrol(handle,'units','normalized','Position',[0.5,0.1,0.3,0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','text','String','Split Line:','HorizontalAlignment','center','Visible','on','backgroundcolor',grasp_env.background_color,'foregroundcolor',[1,1,1]);
grasp_handles.window_modules.detector_efficiency.det_efficiency_split_line = uicontrol(handle,'units','normalized','Position',[0.8,0.1,0.1,0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.analysis_modules.det_eff.split_line),'HorizontalAlignment','center','Visible','on','CallBack','detector_efficiency_callbacks(''split_line'');');

%Split Method
methods = {'Left Eff.#1 + Right Eff.#2', 'Right Eff.#1 + Left Eff.#1','Top Eff.#1 + Bottom Eff.#2', 'Bottom Eff.#1 + Top Eff.#1'};
grasp_handles.window_modules.detector_efficiency.det_efficiency_split_method = uicontrol(handle,'units','normalized','Position',[0.1,0.1,0.4,0.06],'fontname',grasp_env.font,'fontsize',grasp_env.fontsize,'Style','popupmenu','String',methods,'value',status_flags.analysis_modules.det_eff.split_method,'HorizontalAlignment','center','Visible','on','CallBack','detector_efficiency_callbacks(''split_method'');');



detector_efficiency_callbacks;
