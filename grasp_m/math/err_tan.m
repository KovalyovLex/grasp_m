function [result,err] = err_tan(a,da);

%Main Function
result = tan(a);

%Error Combination
err = da*(sec(a))^2;

