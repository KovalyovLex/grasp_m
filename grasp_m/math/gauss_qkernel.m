function [kernel] = gauss_qkernel(qx, qy, sigma_qx, sigma_qy, extent,finesse_x,finesse_y,pixel_x,pixel_y,q_per_pixel_x,q_per_pixel_y)


%qx - qx-center point
%qy - qy center point
%sigma_qx - resolution standard deviation in x (horizontal)
%sigma_qy - resolution standard deviation in y (horizontal)
%extent - how far out on the gaussian to go (number of sigmas each side of the center)
%finesse_x, finesse_y is the matrix granularity 
%q_per_pixel_x
%q_per_pixel_y


if nargin <1; qx = 1e-2; end
if nargin <2; qy = qx;end
if nargin <3; sigma_qx = 1e-3;end
if nargin <4; sigma_qy = siqma_qx;end
if nargin <5; extent = 4; end 
if nargin <6; finesse_x = 5; end
if nargin <7; finesse_y = finesse_x; end
if nargin <8; pixel_x = []; end
if nargin <9; pixel_y = []; end
if nargin <10; q_per_pixel_x = []; end
if nargin <11; q_per_pixel_x = []; end



%Kernel size should be an odd x odd matrix so as to put the nominal q point in the centre of the matrix
if not(isodd(finesse_x)); finesse_x = finesse_x +1;end
if not(isodd(finesse_y)); finesse_y = finesse_y +1;end

[index_x,index_y] = meshgrid(-(finesse_x-1)/2:(finesse_x-1)/2,-(finesse_y-1)/2:(finesse_y-1)/2);
index_y = flipud(index_y);

matrix_element_qstep_x = extent*2*sigma_qx / (finesse_x -1);
matrix_element_qstep_y = extent*2*sigma_qy / (finesse_y -1);

kernel.qx = (index_x .* matrix_element_qstep_x) + qx;
kernel.qy = (index_y .* matrix_element_qstep_y) + qy;

kernel.modq = sqrt(kernel.qx.^2 + kernel.qy.^2);

kernel_weight = (1./(sigma_qx .* sqrt(2*pi))) .* exp( -((kernel.qx-qx).^2)./(2*sigma_qx.^2))  .* (1./(sigma_qy .* sqrt(2*pi))) .* exp( -((kernel.qy-qy).^2)./(2*sigma_qy.^2));
kernel.weight = kernel_weight / sum(sum(kernel_weight));

kernel.x_pixel = pixel_x + (index_x .* matrix_element_qstep_x) / q_per_pixel_x;
kernel.y_pixel = pixel_y + (index_y .* matrix_element_qstep_y) / q_per_pixel_y;

