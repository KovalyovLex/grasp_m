function plot_numeric_function

global fit_parameters
global displayimage

column_format = ['xyeh'];
column_labels = ['Mod_Q   ' char(9) 'I       ' char(9) 'Err_I   ' char(9) 'dQ'];

plot_data.xdat = fit_parameters.fit_return_data.a_q_list;
plot_data.ydat = fit_parameters.values;
plot_data.edat = fit_parameters.err_values;

if isfield(fit_parameters.fit_return_data,'a_dq_list');
    plot_data.exdat = fit_parameters.fit_return_data.a_dq_list;
    column_format = ['xyeh'];
    export_column_format = ['xyhe'];
    plotdata(:,1) = fit_parameters.fit_return_data.a_q_list;
    plotdata(:,2) = fit_parameters.values;
    plotdata(:,4) = fit_parameters.err_values;
    plotdata(:,3) = fit_parameters.fit_return_data.a_dq_list;
else
    plotdata(:,1) = fit_parameters.fit_return_data.a_q_list;
    plotdata(:,2) = fit_parameters.values;
    plotdata(:,3) = fit_parameters.err_values;
    column_format = ['xye'];
    export_column_format = ['xye'];
end

export_data = plotdata;

plot_info = struct(....
    'plot_type','plot',....
    'hold_graph','on',....
    'plot_title',['Radial Re-grouping: |q|'],....
    'x_label',['|q| (' char(197) '^{-1})'],....
    'y_label',displayimage.units,....
    'legend_str',['# Numeric Fit Fu`nction'],....
    'params',displayimage.params1,....
    'parsub',displayimage.subtitle,....
    'export_data',export_data,....
    'export_column_format',export_column_format,....
    'plot_data',plot_data,....
    'info',displayimage.info,....
    'column_labels',column_labels);
    
grasp_plot(plotdata,column_format,plot_info);
