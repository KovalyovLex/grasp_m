function parameter_patch_window


global grasp_env
global grasp_handles
global status_flags

%***** Open Radial Average Window Window *****

if isfield(grasp_handles.window_modules.parameter_patch_window,'window')
    if ishandle(grasp_handles.window_modules.parameter_patch_window);
        delete(grasp_handles.window_modules.parameter_patch_window);
    end
end

fig_position = [grasp_env.screen.grasp_main_actual_position(1)+grasp_env.screen.grasp_main_actual_position(3), grasp_env.screen.grasp_main_actual_position(2),   265*grasp_env.screen.screen_scaling(1)   312*grasp_env.screen.screen_scaling(2)];
grasp_handles.window_modules.parameter_patch_window = figure(....
    'units','pixels',....
    'Position',fig_position,....
    'Name','Real-Time Parameter Patch',....
    'NumberTitle', 'off',....
    'Tag','parameter_patch_window',....
    'color',grasp_env.background_color,....
    'menubar','none',....
    'resize','off',....
    'closerequestfcn','parameter_patch_callbacks(''close'');closereq;');

handle = grasp_handles.window_modules.parameter_patch_window;


uicontrol(handle,'units','normalized','Position',[0.4 0.92 0.16 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'style','text','HorizontalAlignment','left','string','Param#','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[0.6 0.92 0.16 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'style','text','HorizontalAlignment','left','string','Value','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[0.8 0.94 0.16 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'style','text','HorizontalAlignment','left','string','Replace','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[0.8 0.90 0.16 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'style','text','HorizontalAlignment','left','string','/ Modify','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);


for n = 1:status_flags.data.number_patches;
    grasp_handles.window_modules.parameter_patch_text = uicontrol(handle,'units','normalized','Position',[0 0.85-(n-1)*0.07 0.35 0.05],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'HorizontalAlignment','right','Style','text','String','Parameter #:','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
    grasp_handles.window_modules.parameter_parameter_edit = uicontrol(handle,'units','normalized','Position',[0.4 0.85-(n-1)*0.07 0.16 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.data.(['patch_parameter' num2str(n)])),'userdata',n,'HorizontalAlignment','center','Visible','on','callback','parameter_patch_callbacks(''parameter_edit'');');
    grasp_handles.window_modules.parameter_patch_edit = uicontrol(handle,'units','normalized','Position',[0.6 0.85-(n-1)*0.07 0.16 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','edit','String',num2str(status_flags.data.(['patch' num2str(n)])),'userdata',n,'HorizontalAlignment','center','Visible','on','callback','parameter_patch_callbacks(''patch_edit'');');
    grasp_handles.window_modules.parameter_patch_replace_modify = uicontrol(handle,'units','normalized','Position',[0.8 0.85-(n-1)*0.07 0.06 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','value',status_flags.data.(['rep_mod' num2str(n)]),'userdata',n,'HorizontalAlignment','center','Visible','on','BackgroundColor', grasp_env.background_color,'callback','parameter_patch_callbacks(''replace_modify'')','tooltip','Replace (Unchecked) or Modify (Checked)');
    
end

uicontrol(handle,'units','normalized','Position',[0.2 0.3 0.16 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'style','text','HorizontalAlignment','left','string','On / Off','BackgroundColor', grasp_env.background_color, 'ForegroundColor', [1 1 1]);
grasp_handles.window_modules.parameter_patch_check = uicontrol(handle,'units','normalized','Position',[0.2 0.2 0.06 0.06],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','checkbox','HorizontalAlignment','center','value',status_flags.data.patch_check,'Visible','on','callback','parameter_patch_callbacks(''parameter_check'')');


