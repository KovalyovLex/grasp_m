function [y] = tophat_kernel_1d(x0,halfwidth,intint,x,dx)

%Normalised Tophat function 
y = zeros(size(x)); %Empty Array
temp = find(x>=(x0-halfwidth) & x<=(x0+halfwidth));
y(temp) = 1;
y = intint*y/(sum(y)*dx);

% figure
% plot(x-x0,y,'.')
% sum(y.*dx)
% asdasdas