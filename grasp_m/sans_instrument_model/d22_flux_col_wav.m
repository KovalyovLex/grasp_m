function flux = d22_flux_col_wav(col,wav, dwav, wavres_shape);

%col = collimation length in m
%wav = wavelength in angs
%dwav = wavelength resolution (fraction)
%wavres_shape = wavelength resolution function, i.e. triangular for selector, top-hat for blind double chopper

global inst_config


%***** Generate master spectrum for the instrument (in the limit of small divergence, e.g. 17.6m collimation on D22) *****
lambda_min = 1.1; lambda_step = 0.01; lambda_max = 50;
lambda = lambda_min:lambda_step:lambda_max;

%Spectrum 1
%k =5400000; %Just a scale constant
%spectrum176 = k* (1./lambda) .* 10.^(-0.17.*lambda);  %spectrum shape D22, 17.6m used in the MC simulations UNDONE for selector 10%
%col_ref = 17.6;
%This spectrum actually falls off a bit fast at the longest wavelengths
%compared to measured (beyond about 15angs)

%Spectrum 2
k = 0.2; %Just a scale constant
spectrum176 = k .* (1./lambda) .* 10.^(6.46076 + 2.19603.*log10(lambda) -2.90839.*(log10(lambda).^2));   %spectrum shape D22 based on fit to May2008 data, undone for selector 10% 
col_ref = 17.6; source_ref = [40e-3,55e-3]; %m
%Excellent agreement with May2008 D22 data, as comes from fit to this data.
%However, this data was before the final guide realignment but taking the
%17.6m data as the reference should be fairly independent of these effects.

%Scale for divergence (inverse square)
col_scale = (col_ref/col)^2;

%Wavelength band filter
if strcmp(wavres_shape,'selector')
    wav_filter = selector_kernel(wav,(wav*dwav)/2,lambda); %Triangular integration profile of selector
elseif strcmp(wavres_shape,'double_chopper')
    wav_filter = double_chopper_kernel(wav,(wav*dwav)/2,lambda); %Top-Hat resolution integration profile of blind double chopper pair
    %Then correct for the overall transmission of the chopper system
    T = (wav/inst_config.tof_wav_max) * dwav;
    wav_filter = wav_filter * T;
end
    
%Scale for source size relative to reference
%current source size
if length(inst_config.source_size) ==1; %Round source aperture
    source_area = pi*(inst_config.source_size/2)^2;
    col_div_x = (180/pi)*(inst_config.source_size/2)/col;
    col_div_y = (180/pi)*(inst_config.source_size/2)/col;
else %Rectangular source aperture
    source_area = inst_config.source_size(1)*inst_config.source_size(2);
    col_div_x = (180/pi)*(inst_config.source_size(1)/2)/col;
    col_div_y = (180/pi)*(inst_config.source_size(2)/2)/col;
end

%reference source size
ref_source_area = source_ref(1)*source_ref(2);



%Guide Critical angle cut-off scaling
m_eff = 0.7; %value NOT m=1 to try to account for some imperfect guides or misalignment on D22
m_div = 0.1*m_eff*wav;
if m_div < col_div_x; critical_angle_scaling_x = m_div/col_div_x; else critical_angle_scaling_x = 1; end
if m_div < col_div_y; critical_angle_scaling_y = m_div/col_div_y; else critical_angle_scaling_y = 1; end

%Final flux multiplication
flux_spectrum = spectrum176.*wav_filter.*col_scale*critical_angle_scaling_x*critical_angle_scaling_y*source_area/ref_source_area; %This is a spectrum
flux = sum(flux_spectrum); %Integrated over selector or chopper band width
%disp([num2str(wav) char(9) num2str(flux,'%4.2g')])








