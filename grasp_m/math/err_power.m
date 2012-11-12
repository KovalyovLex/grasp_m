function [result,err] = err_power(x,dx,a);

%Main Function
result = x.^a;

%Error Combination
err = sqrt(((a.^2).*(x.^(2.*a-2)).*(dx.^2)));

