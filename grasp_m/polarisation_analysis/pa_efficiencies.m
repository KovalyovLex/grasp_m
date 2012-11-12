function efficiencies = pa_efficiencies(i00,i10,i11,i01)

%see Wildes, Polarisation & Analysis Corrections made easy

%Check if errors exist
if length(i00) <2; i00(2) = 0; end
if length(i10) <2; i10(2) = 0; end
if length(i11) <2; i11(2) = 0; end
if length(i01) <2; i01(2) = 0; end

[efficiencies.fr_p, efficiencies.err_fr_p] = err_divide(i00(1),i00(2),i10(1),i10(2));
[efficiencies.fr_a, efficiencies.err_fr_a] = err_divide(i11(1),i11(2),i01(1),i01(2));

%efficiencies.fp = (i00 - i01 - i10 + i11) / (2*(i00-i01));
[temp1,temp2] = err_sub(i00(1),i00(2),i01(1),i01(2));
[temp1, temp2] = err_sub(temp1,temp2,i10(1),i10(2));
[temp1, temp2] = err_add(temp1,temp2,i11(1),i11(2));
[temp3,temp4] = err_sub(i00(1),i00(2),i01(1),i01(2));
temp3 = temp3*2; temp4 = temp4*2;
[efficiencies.fp, efficiencies.err_fp] = err_divide(temp1,temp2,temp3,temp4);

%efficiencies.fa = (i00 - i01 - i10 + i11) / (2*(i00-i10));
[temp3,temp4] = err_sub(i00(1),i00(2),i10(1),i10(2));
temp3 = temp3*2; temp4 = temp4*2;
[efficiencies.fa, efficiencies.err_fa] = err_divide(temp1,temp2,temp3,temp4);

%efficiencies.phi = (i00-i01)*(i00-i10) / (i00*i11 - i01*i10);
[temp1,temp2] = err_sub(i00(1),i00(2),i01(1),i01(2));
[temp3,temp4] = err_sub(i00(1),i00(2),i10(1),i10(2));
[temp1,temp2] = err_multiply(temp1,temp2,temp3,temp4);

[temp3,temp4] = err_multiply(i00(1),i00(2),i11(1),i11(2));
[temp5,temp6] = err_multiply(i01(1),i01(2),i10(1),i10(2));
[temp3,temp4] = err_sub(temp3,temp4,temp5,temp6);

[efficiencies.phi, efficiencies.err_phi] = err_divide(temp1,temp2,temp3,temp4);






