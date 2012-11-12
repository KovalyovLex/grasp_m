function [trans] = current_transmission

%Reads back the current transmission values, Ts, errTs, Te, errTe associated with the current displayed worksheet

global grasp_data
global status_flags

%Find the pointers and type of the current displayed worksheet
ts_number = status_flags.transmission.ts_number;
te_number = status_flags.transmission.te_number;
ts_depth = status_flags.transmission.ts_depth;
te_depth = status_flags.transmission.te_depth;

flag = status_flags.selector.fw;  %This is the type of worksheet we are dealing with: foregrounds or calibrations
if flag >=1 && flag <= 7 %Then usual sample data;
    ts_worksheet = 4; te_worksheet = 5;
elseif flag >=11 && flag <= 19; %Then PA worksheets
    ts_worksheet = 4; te_worksheet = 5;
else %All other cases such as detector efficiency
    trans.ts = 0; trans.err_ts = 0;
    trans.te = 0; trans.err_te = 0;
    return
end

index_samples = data_index(1);
index_ts = data_index(ts_worksheet);
index_te = data_index(te_worksheet);

%Correct depths for SUM worksheets
ts_depth = ts_depth-grasp_data(index_ts).sum_allow;
if ts_depth ==0; ts_depth = 1; end %The sum worksheet for the time being uses the transmission of the 1st depth
te_depth = te_depth-grasp_data(index_te).sum_allow;
if te_depth ==0; te_depth = 1; end %The sum worksheet for the time being uses the transmission of the 1st depth

% %Poke new values into transmission if required
% if not(isempty(varargin));
%     temp = length(varargin);
%     if temp ==1; %i.e. all cm values specified in one go
%         all_trans = varargin{1};
%         data(index_ts).trans{ts_number}(ts_depth,:) = all_trans(1,:);
%         data(index_te).trans{te_number}(te_depth,:) = all_trans(2,:);
%     else
%         arguments = cell2struct(varargin(2:2:temp),varargin(1:2:(temp-1)),(temp/2));
%         if isfield(arguments,'ts');
%             data(index_ts).trans{ts_number}(ts_depth,:) = arguments.ts;
%         end
%         if isfield(arguments,'te');
%             data(index_te).trans{te_number}(te_depth,:) = arguments.te;
%         end
%         if isfield(arguments,'thickness');
%             data(1).thickness{ts_number}(ts_depth) = arguments.thickness;
%         end
%         
%     end
% end

%Retrieve Ts & Te
ts = grasp_data(index_ts).trans{ts_number}(ts_depth,:); %ts and err_ts
te = grasp_data(index_te).trans{te_number}(te_depth,:); %te and err_te

%Rearange into structure form for output
trans.ts = ts(1);
trans.err_ts = ts(2);
trans.te = te(1);
trans.err_te = te(2);


