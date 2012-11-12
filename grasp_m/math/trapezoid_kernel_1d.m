function [y] = trapezoid_kernel_1d(x0,tophalfwidth,basehalfwidth,intint,x,dx)

%Normalised trapezoidal function
y = zeros(size(x)); %Empty Array
temp = find(x>=(x0-tophalfwidth) & x<=(x0+tophalfwidth));
y(temp) = 1;  %flat top

temp = find(x>=(x0-basehalfwidth) & x<(x0-tophalfwidth));  %Left wing
y(temp) =  1-(1/(basehalfwidth-tophalfwidth))*abs(x(temp)-(x0-tophalfwidth));

temp = find(x<=(x0+basehalfwidth) & x>(x0+tophalfwidth));  %Right wing
y(temp) =  1-(1/(basehalfwidth-tophalfwidth))*abs(x(temp)-(x0+tophalfwidth));


%Normalise function
y = intint*y/(sum(y)*dx);

%  figure
%  plot(x-x0,y,'.')
%  sum(y.*dx)
%  asdasdas