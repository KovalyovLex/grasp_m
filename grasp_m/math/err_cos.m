function [result,err] = err_cos(a,da);

%Main Function
result = cos(a);

%Error Combination
err = da*sin(a);

