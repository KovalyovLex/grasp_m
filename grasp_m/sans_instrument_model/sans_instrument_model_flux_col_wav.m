function flux = sans_instrument_model_flux_col_wav(max_flux,max_flux_col,max_flux_wav,col,wav)

global inst_config


%Wavelength Scaling
%Flux decreases roughly as 1/lambda^4 on D22 measured with 10% selector
flux = max_flux * (max_flux_wav/wav)^4;


%Collimation Scaling
%Flux decreases roughly as 1/col^2 for pin-hole collimation
flux = flux * (max_flux_col/col)^2;

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
if length(inst_config.max_flux_source_size) ==1; %Round source aperture
    ref_source_area = pi*(inst_config.max_flux_source_size/2)^2;
else %Rectangular source aperture
    ref_source_area = inst_config.max_flux_source_size(1)*inst_config.max_flux_source_size(2);
end

%Guide critical angle scaling
m_div = 0.1*1*wav;
if m_div < col_div_x; critical_angle_scaling_x = m_div/col_div_x; else critical_angle_scaling_x = 1; end
if m_div < col_div_y; critical_angle_scaling_y = m_div/col_div_y; else critical_angle_scaling_y = 1; end

flux = flux * source_area * critical_angle_scaling_x * critical_angle_scaling_y / ref_source_area;




% 
% 
% max_flux
% max_flux_col
% max_flux_wav
% col
% wav
% 
% flux



end



