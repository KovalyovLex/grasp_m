function [result,err] = err_asin(a,da);

%Main Function
result = asin(a);

%Error Combination
err = sqrt((da/cos(result))^2);

