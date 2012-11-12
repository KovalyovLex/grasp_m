function [mask] = get_mask(path_name,det)

%path_name is full path and file name
%det_size is the detector pixels [x,y];

if nargin <2; det = 1; end %This is the detector number

global inst_params

%Open File
fid=fopen(path_name);

lineskip = 2;  %i.e. Parsub, Inst Parameters
for i = 1:lineskip; a=fgetl(fid); end

mask = zeros(inst_params.(['detector' num2str(det)]).pixels(2),inst_params.(['detector' num2str(det)]).pixels(1));

%Get Mask
for y = 1:inst_params.(['detector' num2str(det)]).pixels(2)
   line = fgetl(fid);
   mask(y,:) = double(line(1:inst_params.(['detector' num2str(det)]).pixels(1)));
end
fclose(fid);

%Turn the right way round
mask = flipud(mask);

%Convert to logical mask (1's and 0's)
i = find(mask==46); mask(i) = 1;
i = find(mask==35); mask(i) = 0;

