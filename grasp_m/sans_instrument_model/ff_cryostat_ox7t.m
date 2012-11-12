function P = ff_cryostat_ox7t(q)

y0 = 0.014715;
m = 2.4896e-9;
n = -4;

y0 = 0;

P = y0+m.*q.^n;

