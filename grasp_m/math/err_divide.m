function [result,err] = err_divide(a,da,b,db);

%Main Function
result = a./b;

%Error Combination
err = sqrt( (((1./b).^2).*(da.^2)) + (((-a./(b.^2)).^2).*(db.^2)) );

