function c = rand_tri(mean,fwhm,n,m)

if nargin <4; m = 1; end
if nargin <3; n = 1; end
if nargin <2; fwhm = 1; end
if nargin <1; mean = 0; end

resolution =10000;  %Finess of the random distribution

scale_magnitude = log10(resolution) - round(log10(fwhm));
magnitude_scale = 10^scale_magnitude;


fwhm = round(fwhm*magnitude_scale);


a=randi(fwhm,n,m);
b=randi(fwhm,n,m);

c=mean + (-fwhm + (a+b))/magnitude_scale;

