function grasp_plot_handles = modify_grasp_plot_toolbar(grasp_plot_handles)

%******** TOOLBAR's ***********
set(grasp_plot_handles.figure,'toolbar','figure'); %Turn on the button bar
set(0,'showhiddenhandles','on'); %Turn on hidden handles
%Delete the buttons we don't want.
i = findobj(grasp_plot_handles.figure,'tag','Plottools.PlottoolsOn');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Plottools.PlottoolsOff');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Standard.PrintFigure');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Standard.SaveFigure');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Standard.FileOpen');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Standard.NewFigure');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Standard.EditPlot');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Exploration.Pan');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Exploration.Rotate');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Exploration.DataCursor');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Annotation.InsertColorbar');delete(i);
i = findobj(grasp_plot_handles.figure,'tag','Annotation.InsertLegend');delete(i);


%**** Add aditional buttons to the toolbar menu.
%Rescale
icon = load('rescale');
handle = uipushtool('tag','subfigToolRescale','CData',icon.icon,'ToolTipString','Rescale','ClickedCallback','axis auto');
 
set(0,'ShowHiddenHandles','off');
