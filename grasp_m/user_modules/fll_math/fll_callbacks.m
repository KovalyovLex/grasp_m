function fll_callbacks(option)

global inst_params

%Get values from the display window.
i = findobj('tag','fll_B'); B = str2num(get(i(1),'string'));
i = findobj('tag','fll_d'); d = str2num(get(i(1),'string'));
i = findobj('tag','fll_a0'); a0 = str2num(get(i(1),'string'));
i = findobj('tag','fll_q'); q = str2num(get(i(1),'string'));
i = findobj('tag','fll_symmetry'); symmetry_check = get(i(1),'value');

%Convert all units to SI
B = B*10^-4; %Gauss to Tesla
d = d*10^-6; %Microns to m
a0 = a0*10^-6; %Microns to m
q = q * 10^10; %Ang^-1 to m^-1

%Constants
if symmetry_check == 0 %i.e. not checked = Hex
   a0_pre_factor = sqrt(2/(sqrt(3)));
elseif symmetry_check ==1 %i.e. checked = Square
   a0_pre_factor = 1;
end
phi0=2.07e-15; %Flux quantum (SI)

%Now calculate the relevant quantities from either B, d, a0 of q
if option == '1' | option == '5'; %i.e. calculate from B
   a0 = a0_pre_factor *sqrt(phi0/B);
   d = (1/(a0_pre_factor^2))*a0;
   q = 2*pi / d;
   
elseif option == '2'; %i.e. calculate from d
   a0 = (a0_pre_factor^2)*d;
   B = ((a0_pre_factor/a0)^2)*phi0;
   q = 2*pi / d;
   
elseif option == '3'; %i.e. calculate from a0
   d = a0 / (a0_pre_factor^2);
   B = ((a0_pre_factor/a0)^2)*phi0;
   q = 2*pi / d;
   
elseif option == '4'; %i.e. calculate from q
   d = 2*pi / q;
   a0 = (a0_pre_factor^2)*d;
   B = ((a0_pre_factor/a0)^2)*phi0;
end


%Convert back to display units;
B = B*10^4;    %Tesla to Gauss
d = d*10^6;    %m to microns
a0 = a0*10^6;  %m to microns
q = q*10^-10;  %m^-1 to Ang.^-1

%Poke new values back in the display window.
i = findobj('tag','fll_B'); set(i(1),'string',num2str(B));
i = findobj('tag','fll_d'); set(i(1),'string',num2str(d));
i = findobj('tag','fll_a0');set(i(1),'string',num2str(a0));
i = findobj('tag','fll_q');set(i(1),'string',num2str(q));

%Calculate 2theta
i = findobj('tag','fll_wav');
wav = str2num(get(i,'string'));
twotheta = 2*asin(wav/(2*d*10000));
twotheta = twotheta*360/(2*pi);
i = findobj('tag','fll_2theta');
set(i,'string',num2str(twotheta));

%calculate FLL position
i = findobj('tag','fll_det');
det = str2num(get(i,'string'));
position = (det*tan(twotheta*2*pi/360))/(inst_params.detector1.pixel_size(1)*10^-3);
i = findobj('tag','fll_detpixels');set(i,'string',num2str(position));



  