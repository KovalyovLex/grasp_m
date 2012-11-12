function selector_build

%Selector Build: Builds the worksheet selector menu's depending
%upon what is contained in the main DATA array and, for the background
%and cadmium selectors, what is allowed depending on the current
%foreground display setting.

global grasp_data
global status_flags
global grasp_handles

%***** Foreground *****
index = data_index(status_flags.selector.fw);
foreground_allowed_types = grasp_data(index).allowed_types;
last_displayed = grasp_data(index).last_displayed;

%Build Worksheet Selector from items in DATA array
worksheet_string = ''; userdata = []; n = 1;
for index = 1:length(grasp_data);
    if grasp_data(index).visible==1
        worksheet_string = [worksheet_string '|' grasp_data(index).name]; %#ok<AGROW>
        userdata = [userdata, grasp_data(index).type]; %#ok<AGROW>
        if grasp_data(index).type == status_flags.selector.fw; selector_value = n; end
        n=n+1;
    end
end
l = size(worksheet_string); worksheet_string = worksheet_string(2:l(2)); %Remove initial unwanted '|'
set(grasp_handles.figure.fore_wks,'string',worksheet_string,'value',selector_value,'userdata',userdata); %Set New Worksheet_String to the relevant selector


%***** Background *****
%Build Worksheet Selector from items in DATA array
worksheet_string = ''; userdata = []; n = 1;
if last_displayed(1)~=0;
    for index = 1:length(grasp_data);
        temp = find(foreground_allowed_types==grasp_data(index).type);
        if not(isempty(temp)) && grasp_data(index).visible==1;
            worksheet_string = [worksheet_string '|' grasp_data(index).name]; %#ok<AGROW>
            userdata = [userdata, grasp_data(index).type]; %#ok<AGROW>
            if grasp_data(index).type == last_displayed(1);
                selector_value = n; 
                status_flags.selector.bw = grasp_data(index).type;
            end
            n=n+1;
        end
    end
    status = 'on'; %visible status
else
    status = 'off'; %This for when the background selector is hiden
    selector_value = 1;
end
l = size(worksheet_string); worksheet_string = worksheet_string(2:l(2)); %Remove initial unwanted '|'
set(grasp_handles.figure.back_wks,'string',worksheet_string,'value',selector_value,'userdata',userdata); %Set New Worksheet_String to the relevant selector

%Set the visible status of all the background subtraction elements
set(grasp_handles.figure.back_wks,'visible',status);
set(grasp_handles.figure.back_nmbr,'visible',status);
set(grasp_handles.figure.back_dpth,'visible',status);
set(grasp_handles.figure.back_chk,'visible',status);


%***** Cadmium *****
%Build Worksheet Selector from items in DATA array
worksheet_string = ''; userdata = []; n = 1;
if last_displayed(2) ~=0;
    for index = 1:length(grasp_data);
        temp = find(foreground_allowed_types==grasp_data(index).type);
        if not(isempty(temp)) && grasp_data(index).visible==1;
            worksheet_string = [worksheet_string '|' grasp_data(index).name]; %#ok<AGROW>
            userdata = [userdata, grasp_data(index).type]; %#ok<AGROW>
            if grasp_data(index).type == last_displayed(2);
                selector_value = n;
                status_flags.selector.cw = grasp_data(index).type;
            end
            n=n+1;
        end
    end
    status = 'on'; %visible status
else
    status = 'off';
    selector_value = 1;
end
l = size(worksheet_string); worksheet_string = worksheet_string(2:l(2)); %Remove initial unwanted '|'
set(grasp_handles.figure.cad_wks,'string',worksheet_string,'value',selector_value,'userdata',userdata); %Set New Worksheet_String to the relevant selector

%Set the visible status of all the background subtraction elements
set(grasp_handles.figure.cad_wks,'visible',status);
set(grasp_handles.figure.cad_nmbr,'visible',status);
set(grasp_handles.figure.cad_dpth,'visible',status);
set(grasp_handles.figure.cad_chk,'visible',status);

