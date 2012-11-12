function [y] = triangle_kernel_1d(x0,basehalfwidth,intint,x,dx)

%Normalised Tophat function 
y = zeros(size(x)); %Empty Array
temp = find(x>=(x0-basehalfwidth) & x<=(x0+basehalfwidth));
y(temp) =  1-(1/basehalfwidth)*abs(x(temp)-x0);
y = intint*y/(sum(y)*dx);

% figure
% plot(x-x0,y,'.')
% sum(y.*dx)
% asdasdas