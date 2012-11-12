function [result,err] = err_sin(a,da);

%Main Function
result = sin(a);

%Error Combination
err = da*cos(a);

