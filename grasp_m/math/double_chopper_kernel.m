function [y] = double_chopper_kernel(x0,halfwidth,x)

%Normalised Tophat function 
y = zeros(size(x)); %Empty Array
temp = find(x>=(x0-halfwidth) & x<=(x0+halfwidth));
y(temp) = 1;

% figure
% plot(x-x0,y,'.')
% sum(y.*dx)
% asdasdas