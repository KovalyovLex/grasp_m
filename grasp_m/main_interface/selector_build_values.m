function selector_build_values(to_do)

%Selector Build Values:  Builds the number and depth indicators for the worksheet
%depending upon the worksheets that are presented in the Foreground, Background & Cadmium selectors.

if nargin <1; to_do = 'all'; end

global grasp_data
global status_flags
global grasp_handles

switch to_do

    case {'fore', 'all'};
        %Foreground
        index = data_index(status_flags.selector.fw);
        number = grasp_data(index).nmbr; %Number of worksheets
        if status_flags.selector.fn > number;
            status_flags.selector.fn = number;
            %The following should all be handled by the worksheet grouping
            %stuff and shouldn't be needed here
            status_flags.selector.bn = number;
            status_flags.selector.cn = number;
            status_flags.display.mask.number = number;
            status_flags.transmission.ts_number = number;
            status_flags.transmission.te_number = number;
            status_flags.beamcentre.cm_number = number;
        end
        number_string = '1';
        for n = 2:number; number_string = [number_string '|' num2str(n)]; end %#ok<AGROW>

        %Depth
        depth = grasp_data(index).dpth{status_flags.selector.fn};
        sum_allow = grasp_data(index).sum_allow;
        if sum_allow == 1; depth_string = 'sum'; ndstart = 1;
        else depth_string = '1'; ndstart = 2; end
        for n = ndstart:depth; depth_string = [depth_string '|' num2str(n)]; end

        %Remember the selector depth length
        status_flags.selector.fdpth_max = depth+sum_allow;

        %Set New Selector Strings to Selector
        set(grasp_handles.figure.fore_nmbr,'string',number_string,'value',status_flags.selector.fn);
        set(grasp_handles.figure.fore_dpth,'string',depth_string,'value',1);

        %Also set number selector to Ts, Te, Cm and Mask worksheet numbers
        set(grasp_handles.figure.mask_nmbr,'string',number_string,'value',status_flags.display.mask.number);
        set(grasp_handles.figure.trans_ts_nmbr,'string',number_string,'value',status_flags.transmission.ts_number);
        set(grasp_handles.figure.trans_te_nmbr,'string',number_string,'value',status_flags.transmission.te_number);
        set(grasp_handles.figure.beamcentre_nmbr,'string',number_string,'value',status_flags.beamcentre.cm_number);
end


switch to_do

    case {'back','all'}
        %Background
        index = data_index(status_flags.selector.bw);
        number = grasp_data(index).nmbr; %Number of worksheets
        if status_flags.selector.bn > number;
            status_flags.selector.bn = number;
        end
        number_string = '1';
        for n = 2:number; number_string = [number_string '|' num2str(n)]; end %#ok<AGROW>

        %Depth
        depth = grasp_data(index).dpth{status_flags.selector.bn};
        sum_allow = grasp_data(index).sum_allow;
        if sum_allow == 1; depth_string = 'sum'; ndstart = 1;
        else depth_string = '1'; ndstart = 2; end
        for n = ndstart:depth; depth_string = [depth_string '|' num2str(n)]; end %#ok<AGROW>
        
        %Remember the selector depth length
        status_flags.selector.bdpth_max = depth+sum_allow;
        
        %Set New Selector Strings to Selector
        set(grasp_handles.figure.back_nmbr,'string',number_string);
        set(grasp_handles.figure.back_dpth,'string',depth_string,'value',1);
end


switch to_do

    case {'cad','all'}
        %Cadmium
        index = data_index(status_flags.selector.cw);
        number = grasp_data(index).nmbr; %Number of worksheets
        if status_flags.selector.cn > number;
            status_flags.selector.cn = number;
        end
        number_string = '1';
        for n = 2:number; number_string = [number_string '|' num2str(n)]; end %#ok<AGROW>

        %Depth
        depth = grasp_data(index).dpth{status_flags.selector.cn};
        sum_allow = grasp_data(index).sum_allow;
        if sum_allow == 1; depth_string = 'sum'; ndstart = 1;
        else depth_string = '1'; ndstart = 2; end
        for n = ndstart:depth; depth_string = [depth_string '|' num2str(n)]; end %#ok<AGROW>

        %Remember the selector depth length
        status_flags.selector.cdpth_max = depth+sum_allow;

        %Set New Selector Strings to Selector
        set(grasp_handles.figure.cad_nmbr,'string',number_string);
        set(grasp_handles.figure.cad_dpth,'string',depth_string,'value',1);
end

