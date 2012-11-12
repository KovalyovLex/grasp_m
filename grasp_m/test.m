function data_out = test
load('/home/lss/dewhurst/Desktop/2_dry_flax.mat')


data_out.data = data(15).data{1};
data_out.error = data(15).error{1};




