function [sum_a, err_sum_a] = err_sum(a,err_a)


sum_a = sum(a);
err_sum_a = sqrt(sum(err_a.^2));

