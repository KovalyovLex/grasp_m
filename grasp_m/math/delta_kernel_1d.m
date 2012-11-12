function [y] = delta_kernel_1d(x0,intint,x,dx)

%Normalised Delta function 
y = zeros(size(x)); %Empty Array
[a,temp] = min(abs(x-x0)); %find the closest point
y(temp) = 1;
y = intint*y/(sum(y)*dx);

% figure
% plot(x-x0,y,'.')
% sum(y.*dx)
% asdasdas