function [foreimage] = divide_data_correction(foreimage, backimage)

%This function performs the 'Divide Foreground & Background worksheets'
%Ignore cadmium worksheets
%Ignore transmission

%The formula is this:
%I_real = [I_sample / I_back]

%where:
%	I_sample = measured scattering from sample
%	I_back = background scattering from holder

%Split in to parts for ease of error calculation;
%   a = (I_sample - I_cad)
%   b = (I_back - I_cad)
%   c = Ts*Te;
%   d = a/c;
%   e = b /Te;
%   I_real = d - e

global inst_params

%Loop though the detectors
for det = 1:inst_params.detectors


[foreimage.(['data' num2str(det)]), foreimage.(['error' num2str(det)])] = err_divide(foreimage.(['data' num2str(det)]),foreimage.(['error' num2str(det)]),backimage.(['data' num2str(det)]),backimage.(['error' num2str(det)]));

%Generate a mask of NAN points to be excluded due to divide by zero errors.
foreimage.(['nan_mask' num2str(det)]) = ones(size(foreimage.(['data' num2str(det)])));
temp = find(backimage.(['data' num2str(det)]) ==0);
foreimage.(['nan_mask' num2str(det)])(temp) = 0;

%Generate a mask of Zero foreground (numerator) points to avoid zeros
foreimage.(['zero_mask' num2str(det)]) = ones(size(foreimage.(['data' num2str(det)])));
temp = find(foreimage.(['data' num2str(det)]) ==0);
foreimage.(['zero_mask' num2str(det)])(temp) = 0;

end

