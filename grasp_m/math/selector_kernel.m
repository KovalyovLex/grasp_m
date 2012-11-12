function [y] = selector_kernel(x0,basehalfwidth,x)

%Normalised Tophat function 
y = zeros(size(x)); %Empty Array
temp = find(x>=(x0-basehalfwidth) & x<=(x0+basehalfwidth));
y(temp) =  1-(1/basehalfwidth)*abs(x(temp)-x0);

% figure
% plot(x-x0,y,'.')
% sum(y.*dx)
% asdasdas