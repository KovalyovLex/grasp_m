function c = rand_trapezoid(mean,fwhm,wing,n,m)

if nargin <5; m = 1; end
if nargin <4; n = 1; end
if nargin <3; wing = 1; end
if nargin <2; fwhm = 1; end
if nargin <1; mean = 0; end

if wing > fwhm; %
    d = wing-fwhm;
    fwhm = fwhm + d;
end


resolution =1e4;  %Finess of the random distribution

scale_magnitude = (round(log10(resolution)) - round(log10(fwhm+wing+wing)));
magnitude_scale = 10^scale_magnitude;
fwhm = round(fwhm*magnitude_scale);
wing = round(wing*magnitude_scale);

a=randi(wing,n,m);
b=randi(fwhm,n,m);

c=mean + (-(fwhm+wing)/2 + (a+b))/magnitude_scale;

%figure
%hist(c,resolution)
