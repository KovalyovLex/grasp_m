function about_grasp

global grasp_env
global grasp_handles

if ishandle(grasp_handles.window_modules.about_grasp);
    delete(grasp_handles.window_modules.about_grasp);
end

grasp_handles.window_modules.about_grasp = figure(....
    'units','normalized',....
    'Position',[0.3675   0.5158-(0.1550/grasp_env.screen.screen_scaling(1) -0.1550)    0.2125    0.1550/grasp_env.screen.screen_scaling(1)],....
    'Name','About GRASP' ,....
    'NumberTitle', 'off',....
    'Resize','on',....
    'Tag','about_grasp',...
    'color',grasp_env.background_color,....
    'menubar','none');

handle = grasp_handles.window_modules.about_grasp;

uicontrol(handle,'units','normalized','Position',[0.1 0.8 0.8 0.18],'FontName',grasp_env.font,'FontSize',3*grasp_env.fontsize,'Style','text','string',['GRASP'],'HorizontalAlignment','center','Visible','on','backgroundcolor',grasp_env.background_color,'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[0.1 0.63 0.8 0.1],'FontName',grasp_env.font,'FontSize',1.5*grasp_env.fontsize,'Style','text','string',['V. ' grasp_env.grasp_version],'HorizontalAlignment','center','Visible','on','backgroundcolor',grasp_env.background_color,'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[0.1 0.45 0.8 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','string',['Version Date: ' grasp_env.grasp_version_date],'HorizontalAlignment','center','Visible','on','backgroundcolor',grasp_env.background_color,'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[0.1 0.32 0.8 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','string',['by Charles Dewhurst'],'HorizontalAlignment','center','Visible','on','backgroundcolor',grasp_env.background_color,'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[0.1 0.22 0.8 0.1],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','string',['Institut Laue Langevin'],'HorizontalAlignment','center','Visible','on','backgroundcolor',grasp_env.background_color,'ForegroundColor', [1 1 1]);
uicontrol(handle,'units','normalized','Position',[0.1 0.03 0.8 0.15],'FontName',grasp_env.font,'FontSize',grasp_env.fontsize,'Style','text','string',['Comments, suggestions, bug-reports etc. to dewhurst@ill.fr'],'HorizontalAlignment','center','Visible','on','backgroundcolor',grasp_env.background_color,'ForegroundColor', [1 1 1]);


