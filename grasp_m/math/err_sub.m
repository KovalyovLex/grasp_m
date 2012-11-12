function [result,err] = err_sub(a,da,b,db);

%Main Function
result = a-b;

%Error Combination
err = sqrt((da.^2) + (db.^2));

