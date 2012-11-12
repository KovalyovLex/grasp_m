function contour_options_callbacks(to_do,options);

global status_flags

switch to_do

    case 'contour_auto'
        status_flags.contour.auto_levels_index = get(gcbo,'value');

    case 'contour_min'
        value = str2num(get(gcbo,'string'));
        if isempty(value)
            set(gcbo,'string',num2str(status_flags.contour.contour_min));
        else
            status_flags.contour.contour_min = value;
        end

    case 'contour_max'
        value = str2num(get(gcbo,'string'));
        if isempty(value)
            set(gcbo,'string',num2str(status_flags.contour.contour_min));
        else
            status_flags.contour.contour_max = value;
        end

    case 'contour_interval'
        value = str2num(get(gcbo,'string'));
        if isempty(value)
            set(gcbo,'string',num2str(status_flags.contour.contour_interval));
        else
            status_flags.contour.contour_interval = value;
        end

    case 'contour_string'
        status_flags.contour.contours_string = get(gcbo,'string');

    case 'radio_buttons'
        i = findobj('tag','contour_check');
        set(i,'value',0);
        set(gcbo,'value',1);
        status_flags.contour.current_style =options;

    case 'contour_units'
        i = findobj('tag','contour_units_check');
        set(i,'value',0);
        set(gcbo,'value',1);
        status_flags.contour.percent_abs =options;


end

grasp_update
