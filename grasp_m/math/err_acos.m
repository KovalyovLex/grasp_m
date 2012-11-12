function [result,err] = err_acos(a,da);

%Main Function
result = acos(a);

%Error Combination
err = sqrt((da/sin(result))^2);

