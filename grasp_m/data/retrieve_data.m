function output = retrieve_data(selector)

%Retrieve data is designed to sort out which data set either the foreground or subtract data menus are pointing at.
%The corresponding data is then shipped out as 'data' for subsequent operations

%OR 'selector' can also speficy a specific worksheet, e.g. [6,1,1] would
%indicate the empty beam worksheet 1, depth 1.

%***** Worksheet types *****
% 1 = sample scattering
% 2 = sample background
% 3 = sample cadmium
% 4 = sample transmission
% 5 = sample empty transmission
% 6 = sample empty beam transmission
% 7 = sample mask
% 8 = I0 Beam Intensity
% 99 = detector efficiency map


global status_flags
global grasp_data
global inst_params
global grasp_env

%Data Worksheets index
if strcmp(selector,'fore');
    index = data_index(status_flags.selector.fw);
    nmbr = status_flags.selector.fn;
    dpth = status_flags.selector.fd;
elseif strcmp(selector,'back');
    index = data_index(status_flags.selector.bw);
    nmbr = status_flags.selector.bn;
    dpth = status_flags.selector.bd;
elseif strcmp(selector,'cad');
    index = data_index(status_flags.selector.cw);
    nmbr = status_flags.selector.cn;
    dpth = status_flags.selector.cd;
elseif isnumeric(selector);
    index = selector(1); nmbr = selector(2); dpth = selector(3);
end

%Mask worksheet index
mask_number = status_flags.display.mask.number;
mask_index = data_index(7);

dpth_sum_allow = grasp_data(index).sum_allow;
real_dpth = dpth - dpth_sum_allow;
if real_dpth > grasp_data(index).dpth{nmbr}; real_dpth = 1; end


%in this way, if no depth then status_flags.selector.fd reflects the real
%worksheet depth.  If there is a depth, then need to subtract 1 from
%status_flags.selector.fd.  If the result is 0 then the sum is being
%displayed.


%Parameters that are not detector dependent
output.type = grasp_data(index).type;
output.history = [];
output.load_string = grasp_data(index).load_string{nmbr};
%Data Units
if output.type == 7;
    output.units = 'Mask Data';
elseif output.type == 99;
    output.units = 'Detector Efficiency';
else
    output.units = 'Counts ';
end


if real_dpth ==0;  %i.e. Sum is being displayed
    output.subtitle = grasp_data(index).subtitle{nmbr}{1};
    output.sum_flag = 1;
    output.info.start_date = grasp_data(index).info{nmbr}.start_date{1};
    output.info.start_time = grasp_data(index).info{nmbr}.start_time{1};
    output.info.end_date = grasp_data(index).info{nmbr}.end_date{1};
    output.info.end_time = grasp_data(index).info{nmbr}.end_time{1};
    if isfield(grasp_data(index).info{nmbr},'user')
        output.info.user = grasp_data(index).info{nmbr}.user{1};
    end
    %Put the thickness into the structure based on what is stored in the SAMPLES worksheet
    samples_index = data_index(1);
    output.thickness = grasp_data(samples_index).thickness{nmbr}(1); %Taken from the first one in the depth
else
    output.subtitle = grasp_data(index).subtitle{nmbr}{real_dpth};
    output.sum_flag = 0;
    output.info.start_date = grasp_data(index).info{nmbr}.start_date{real_dpth};
    output.info.start_time = grasp_data(index).info{nmbr}.start_time{real_dpth};
    output.info.end_date = grasp_data(index).info{nmbr}.end_date{real_dpth};
    output.info.end_time = grasp_data(index).info{nmbr}.end_time{real_dpth};
    if isfield(grasp_data(index).info{nmbr},'user')
        output.info.user = grasp_data(index).info{nmbr}.user{real_dpth};
    end
    %Put the thickness into the structure based on what is stored in the SAMPLES worksheet
    samples_index = data_index(1);
    %check if enough thickness' exist
    if real_dpth > length(grasp_data(samples_index).thickness{nmbr})
        thickness_depth = 1;
    else
        thickness_depth = real_dpth;
    end
    output.thickness = grasp_data(samples_index).thickness{nmbr}(thickness_depth);
end


%Loop though the number of detectors
for det = 1:inst_params.detectors
    
    if real_dpth ==0;  %i.e. Sum is being displayed
        
        %Update Sum DATA
        output.(['data' num2str(det)]) = sum(grasp_data(index).(['data' num2str(det)]){nmbr},3);
        output.(['error' num2str(det)]) = sqrt(sum(grasp_data(index).(['error' num2str(det)]){nmbr}.^2,3));
        output.(['params' num2str(det)]) = grasp_data(index).(['params' num2str(det)]){nmbr}(:,1); %Params are taken from the first one in the depth
        
        %Update Summed Parameters, eg, Total Det, Total Monitor etc.
        param_sum = sum(grasp_data(index).(['params' num2str(det)]){nmbr},2);
        output.(['params' num2str(det)])(inst_params.vectors.monitor) = param_sum(inst_params.vectors.monitor);
        output.(['params' num2str(det)])(inst_params.vectors.time) = param_sum(inst_params.vectors.time);
        output.(['params' num2str(det)])(inst_params.vectors.array_counts) = param_sum(inst_params.vectors.array_counts);
    else
        output.(['data' num2str(det)]) = grasp_data(index).(['data' num2str(det)]){nmbr}(:,:,real_dpth);
        output.(['error' num2str(det)]) = grasp_data(index).(['error' num2str(det)]){nmbr}(:,:,real_dpth);
        output.(['params' num2str(det)]) = grasp_data(index).(['params' num2str(det)]){nmbr}(:,real_dpth);
    end
    
    %Get instrument mask for detector
    output.(['imask' num2str(det)]) = inst_params.(['detector' num2str(det)]).imask;
    %Get user mask for detector
    output.(['umask' num2str(det)]) = grasp_data(mask_index).(['data' num2str(det)]){mask_number}(:,:);
end


%***** Data Parameter Patcher *****
if status_flags.data.patch_check ==1; %Patch some parameters
    for det = 1:inst_params.detectors
        for n = 1: status_flags.data.number_patches
            if not(isempty(status_flags.data.(['patch_parameter' num2str(n)]))) && not(isempty(status_flags.data.(['patch' num2str(n)])))
                
                %Replace or Modify
                if status_flags.data.(['rep_mod' num2str(n)]) == 0; %Replace
                    output.(['params' num2str(det)])(status_flags.data.(['patch_parameter' num2str(n)]),:) = status_flags.data.(['patch' num2str(n)]);
                elseif status_flags.data.(['rep_mod' num2str(n)]) == 1; %Modify
                    output.(['params' num2str(det)])(status_flags.data.(['patch_parameter' num2str(n)]),:) = output.(['params' num2str(det)])(status_flags.data.(['patch_parameter' num2str(n)]),:) + status_flags.data.(['patch' num2str(n)]);
                end
            end
        end
    end
end




%***** Soft Detector Position Correction - Tube detectors like D22 & d33 *****
if status_flags.calibration.soft_det_cal ~= 0 && strcmp(grasp_env.inst,'ILL_d33') && strcmp(grasp_env.inst_option,'D33_Instrument_Comissioning')
    %&& sum(sum(output.data1)) ~=0
    
   if output.type ~= 7 && output.type ~=99; %Not Masks or detector efficiency
        output.data1 = d33_rawdata_calibration(output.data1);
   end
end
