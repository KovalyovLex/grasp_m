function [y] = gauss_kernel_1d(x0,sigma,intint,x)

%Generate Gaussian points on the kernel mesh
%sigma = fwhm / (2*sqrt(2*log(2)));
y  = (intint./(sigma .* sqrt(2*pi))) .* exp( -(x-x0).^2 ./ (2*sigma.^2));

% figure
% plot(x-x0,y,'.')
% sum(y.*dx)
% sadasda