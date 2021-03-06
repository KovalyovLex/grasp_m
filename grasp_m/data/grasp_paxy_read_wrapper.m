function numor_data = grasp_paxy_read_wrapper(fname,numor)

global inst_params

%Read the PAXY data using LLB's own data reader
d = DLlirePAX(fname,128,'int32');


%Multi detector data
numor_data.data1 = d.m;
disp('Using SQRT(n) Errors');
numor_data.error1 = sqrt(d.m);


%User Information
numor_data.info.user = 'No Name';
numor_data.info.start_date = d.et.date_heure(1:10);
numor_data.info.start_time = d.et.date_heure(12:19);
numor_data.info.end_date = [];
numor_data.info.end_time = [];
numor_data.subtitle = d.et.commentaire;


%Parameters 
param = zeros(128,1); %Empty Parameters array of 128, as Grasp expects.

%Numor
param(inst_params.vectors.numor) = d.et.numero;  %Usually stored as param 128
%Acquisition Time
param(inst_params.vectors.aq_time) = d.et.temps; %Seconds
%Detector Distance
param(inst_params.vectors.det1) = d.et.distance/1000; %m
param(inst_params.vectors.detcalc1) = param(inst_params.vectors.det1); %m
%Wavelength
param(inst_params.vectors.wav) = d.et.lambda; %Angs
param(inst_params.vectors.deltawav) = d.et.dlsurl*2; %Fraction 2* to go from half-width to FWHM
param(inst_params.vectors.sel_rpm) = d.et.vitesse_selecteur; %RPM
%BeamStop
param(inst_params.vectors.bx) = 0;
param(inst_params.vectors.by) = 0;
%Attenuator
param(inst_params.vectors.att_type) = 0;
param(inst_params.vectors.att_status) = 1;
%Collimation
param(inst_params.vectors.col) = d.et.dc /1000; %m;
%Collimation Source Size
param(inst_params.vectors.source_ap) = d.et.r1*2 / 1000 ; %m *2 to make diameter
%Monitor
param(inst_params.vectors.monitor) = d.et.moniteur;
%Total Counts
param(inst_params.vectors.array_counts) = sum(sum(numor_data.data1));
numor_data.params1 = param;

