function kernel = gauss_kernel(fwhmx,fwhmy); 

if nargin <1
    fwhmx = 1;
    fwhmy = 1;
elseif nargin <2
    fwhmy = fwhmx;
end

%fwhm is an integer in pixels
kernel_sizex = 4*fwhmx+1; %Must be an odd number to allow for a centre pixel
kernel_sizey = 4*fwhmy+1; %Must be an odd number to allow for a centre pixel

%Make coordinates mesh for x and y
x = 1:kernel_sizex;
y = 1:kernel_sizey;
[xmesh,ymesh] = meshgrid(x,y);

%Kernel centre
centre_x = (kernel_sizex/2)+0.5;
centre_y = (kernel_sizey/2)+0.5;

%Generate Gaussian points on the kernel mesh
xlist = reshape(xmesh,kernel_sizex*kernel_sizex,1);
ylist = reshape(ymesh,kernel_sizey*kernel_sizey,1);
xy = [xlist,ylist];

xy_new(:,1) = xy(:,1) - centre_x;
xy_new(:,2) = xy(:,2) - centre_y;
z = (1/(fwhmx*sqrt(pi/2)/(sqrt(log(4))))*exp(-2*((xy_new(:,1)).^2)/((fwhmx.^2)/log(4)))) .* (1/(fwhmy*sqrt(pi/2)/(sqrt(log(4))))*exp(-2*((xy_new(:,2)).^2)/((fwhmy.^2)/log(4))));

kernel = reshape(z,kernel_sizex,kernel_sizey);

%figure
%pcolor(kernel); axis square;colorbar;shading interp
%disp(['Gaussian Kernel Generator: Size = ' num2str(kernel_sizex) 'x' num2str(kernel_sizey) '; Sum = ' num2str(sum(sum(kernel)))]);