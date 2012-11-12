function resolution_control_window

global grasp_env
global grasp_handles
global status_flags


%***** Open Resolution Control Window *****
if ishandle(grasp_handles.window_modules.resolution_control_window.window)
    if strcmp(get(grasp_handles.window_modules.resolution_control_window.window,'tag'),'resolution_window');
        figure(grasp_handles.window_modules.resolution_control_window.window)
        return
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3)-900*grasp_env.screen.screen_scaling(1), grasp_env.screen.grasp_main_actual_position(2)+grasp_env.screen.grasp_main_actual_position(4)-800*grasp_env.screen.screen_scaling(2),   450*grasp_env.screen.screen_scaling(1)   800*grasp_env.screen.screen_scaling(2)];
    grasp_handles.window_modules.resolution_control_window.window = figure(....
        'units','pixels',....
        'Position',fig_position,....
        'Name','Resolution Control',....
        'NumberTitle', 'off',....
        'Tag','resolution_window',....
        'color',grasp_env.background_color,....
        'papertype','A4',....
        'renderer','zbuffer',....
        'menubar','none',....
        'closerequestfcn',('resolution_control_callbacks(''close_window'');closereq;'),....
        'resize','off');

%Resolution Components
uicontrol('units','normalized','Position',[0.02 0.95 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Resolution Components:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
  
    
%Wavelength Spread
uicontrol('units','normalized','Position',[0.02 0.90 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Wavelength Spread, delta_lambda:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.resolution_control_window.wavelength_check = uicontrol('units','normalized','Position',[0.44 0.91 0.038,0.028],'ToolTip','Enable / Disable Wavelength Resolution','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','value',status_flags.resolution_control.wavelength_check,'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''wavelength_check'');');
string = {'Triangular (Selector)','TopHat (D33 TOF)'};
grasp_handles.window_modules.resolution_control_window.wavelength_shape = uicontrol('units','normalized','Position',[0.6 0.91 0.3,0.028],'ToolTip','Wavelength Resolution Shape Kernel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','string',string,'value',status_flags.resolution_control.wavelength_type,'callback','resolution_control_callbacks(''wavelength_shape'');');

%Divergence
uicontrol('units','normalized','Position',[0.02 0.80 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Divergence, delta_theta:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.resolution_control_window.divergence_check = uicontrol('units','normalized','Position',[0.44 0.81 0.038,0.028],'ToolTip','Enable / Disable Divergence Resolution','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','value',status_flags.resolution_control.divergence_check,'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''divergence_check'');');
string = {'TopHat (Geometric)', 'Measured Beam Shape(x)'};
grasp_handles.window_modules.resolution_control_window.divergence_shape = uicontrol('units','normalized','Position',[0.6 0.81 0.3,0.028],'ToolTip','Divergence Resolution Shape Kernel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','string',string,'value',status_flags.resolution_control.divergence_type,'callback','resolution_control_callbacks(''divergence_shape'');');

%Aperture Smearing
if status_flags.resolution_control.divergence_type ==2; status = 'off'; else status = 'on'; end
uicontrol('units','normalized','Position',[0.02 0.70 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Aperture Smearing:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.resolution_control_window.aperture_check = uicontrol('units','normalized','Position',[0.44 0.71 0.038,0.028],'ToolTip','Enable / Disable Aperture Smearing','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','value',status_flags.resolution_control.aperture_check,'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''aperture_check'');','enable','on','visible',status);
grasp_handles.window_modules.resolution_control_window.aperture_size = uicontrol('units','normalized','Position',[0.6 0.71 0.1,0.028],'ToolTip','Sample Aperture Size','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','string',num2str(status_flags.resolution_control.aperture_size*1e3),'callback','resolution_control_callbacks(''aperture_size'');','enable','on','visible',status);
grasp_handles.window_modules.resolution_control_window.aperture_text = uicontrol('units','normalized','Position',[0.72 0.70 0.07,0.028],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','left','Style','text','string','[mm]','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1],'enable','on');

%Detector Pixelation
uicontrol('units','normalized','Position',[0.02 0.60 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Detector Pixelation:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.resolution_control_window.pixelation_check = uicontrol('units','normalized','Position',[0.44 0.61 0.038,0.028],'ToolTip','Enable / Disable Detector Pixelation Resolution','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','value',status_flags.resolution_control.pixelation_check,'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''pixelation_check'');');
% string = {'TopHat (Square Pixels)'};
% grasp_handles.window_modules.resolution_control_window.pixelation_shape = uicontrol('units','normalized','Position',[0.6 0.61 0.3,0.028],'ToolTip','Detector Pixelation Resolution Shape Kernel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','string',string,'value',1,'callback','resolution_control_callbacks(''pixelation_shape'');');

%Binning Resolution
uicontrol('units','normalized','Position',[0.02 0.50 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Binning Resolution:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.resolution_control_window.binning_check = uicontrol('units','normalized','Position',[0.44 0.51 0.038,0.028],'ToolTip','Enable / Disable Rebinning Resolution','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','value',status_flags.resolution_control.binning_check,'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''binning_check'');');
% string = {'TopHat (Sharp Bins)'};
% grasp_handles.window_modules.resolution_control_window.binning_shape = uicontrol('units','normalized','Position',[0.6 0.51 0.3,0.028],'ToolTip','Detector Binning Resolution Shape Kernel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','popup','string',string,'value',1,'callback','resolution_control_callbacks(''binning_shape'');');


%Convolution Type:  Real Shape Kernel, Gaussian Equivalent Kernel, Classic Calc
uicontrol('units','normalized','Position',[0.02 0.40 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Convolution Type:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol('units','normalized','Position',[0.3 0.36 0.35 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Real Shape Kernel:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol('units','normalized','Position',[0.3 0.32 0.35 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Gaussian Equivalent Kernel:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol('units','normalized','Position',[0.3 0.28 0.35 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Classic Resolution: (dLambda & dTheta ONLY)','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);

values = [0 0 0];
values(status_flags.resolution_control.convolution_type) = 1;
grasp_handles.window_modules.resolution_control_window.radio1 = uicontrol('units','normalized','Position',[0.67 0.37 0.038,0.028],'ToolTip','Real Shape Kernel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','radiobutton','value',values(1),'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''radio1'');');
grasp_handles.window_modules.resolution_control_window.radio2 = uicontrol('units','normalized','Position',[0.67 0.33 0.038,0.028],'ToolTip','Gaussian Equivalent Kernel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','radiobutton','value',values(2),'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''radio2'');');
grasp_handles.window_modules.resolution_control_window.radio3 = uicontrol('units','normalized','Position',[0.67 0.29 0.038,0.028],'ToolTip','Real Shape Kernel','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','radiobutton','value',values(3),'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''radio3'');');







%Show Resolution Kernels
uicontrol('units','normalized','Position',[0.02 0.20 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Show Resolution Kernels:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.resolution_control_window.show_kernels = uicontrol('units','normalized','Position',[0.44 0.21 0.038,0.028],'ToolTip','Show Resolution Kernels when Calculated','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','checkbox','value',status_flags.resolution_control.show_kernels_check,'BackgroundColor', grasp_env.background_color,'callback','resolution_control_callbacks(''show_kernels_check'');');

%NOTE:
message_str = 'NOTE:  For resolution calculation changes to take effect in processed data, e.g. Radial Average, I vs. Q, such processing should be remade';
uicontrol('units','normalized','Position',[0.02 0.05 0.9 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','center','Style','text','String',message_str,'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);


%Kernel Width and Finesse
uicontrol('units','normalized','Position',[0.02 0.05 0.3 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Kernel Width, n x fwhm','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.resolution_control_window.kernel_width = uicontrol('units','normalized','Position',[0.34 0.06 0.08,0.022],'ToolTip','Kernel Width (n x fwhm)','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','string', num2str(status_flags.resolution_control.fwhmwidth),'callback','resolution_control_callbacks(''fwhmwidth'');');
uicontrol('units','normalized','Position',[0.45 0.05 0.4 0.03],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'FontWeight','bold','HorizontalAlignment','right','Style','text','String','Kernel Finesse (points/fwhm)', 'BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.resolution_control_window.finesse = uicontrol('units','normalized','Position',[0.87 0.06 0.08,0.022],'ToolTip','Kernel Finesse (points / fwhm)','FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','center','Style','edit','string', num2str(status_flags.resolution_control.finesse),'callback','resolution_control_callbacks(''finesse'');');




