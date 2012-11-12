function a = rand_gauss(centre,fwhm,cut_off);

%Random number with a Gaussian probability distribution
%centre is the mean value
%fwhm is fwhm %

fwhm = (fwhm/100)*centre; %Convert fwhm % to absolute
if nargin <3; cut_off = 2*fwhm; end %wing cut-off at 2 fwhm

a = zeros(size(centre));
for n = 1:numel(centre);
    probability = 0;
    while rand > probability;
        a(n) = (centre(n) - cut_off(n))+(2*cut_off(n)*rand);
        probability = exp((-2*(a(n)-centre(n)).^2)/(fwhm(n)^2/log(4)));
    end
end


beep
disp('Chuck Says:  Should be using RANDN fn. instead of this rand_gauss.n')
