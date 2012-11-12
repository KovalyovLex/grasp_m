function [result,err] = err_multiply(a,da,b,db);

%Main Function
result = a.*b;

%Error Combination
err = sqrt(((b.^2).*(da.^2)) + ((a.^2).*(db.^2)));

