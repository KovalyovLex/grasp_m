function d33_chopper_time_distance_callbacks(to_do)

global d33_chopper_time_distance_handles
global d33_chopper_time_distance_params

%Constants
h_plank = 6.626076*(10^-34); %Plank's Constant
m_n = 1.674929*(10^-27); %Neutron Rest Mass

resolution_preset = get(d33_chopper_time_distance_handles.res_preset,'value');

switch(to_do)
    
    
    case 'wav_min'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            d33_chopper_time_distance_params.wav_range(1) = temp;
            d33_chopper_time_distance_callbacks('re_calculate_chopper_parameters');
        end
        
        
    case 'wav_max'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            d33_chopper_time_distance_params.wav_range(2) = temp;
            d33_chopper_time_distance_callbacks('re_calculate_chopper_parameters');
        end

        
    case 'det'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            d33_chopper_time_distance_params.detector_distance = temp;
            d33_chopper_time_distance_callbacks('re_calculate_chopper_parameters');
        end
        
    case 're_calculate_chopper_parameters'
        %Recalculate Chopper Parameters
        d33_chopper_time_distance_params = d33_chopper_settings(d33_chopper_time_distance_params.wav_range,d33_chopper_time_distance_params.detector_distance);
        %Rebuild Resolution Pre-set list
        popup_menu = num2str(d33_chopper_time_distance_params.resolution);
        set(d33_chopper_time_distance_handles.res_preset,'string',popup_menu);
        
        
    case 'res_preset'
        d33_chopper_time_distance_callbacks('re_calculate_chopper_parameters');

    case 'f1_freq'
        temp = str2num(get(gcbo,'string'));
        if not(isempty(temp));
            d33_chopper_time_distance_params.slaves_rpm(resolution_preset) = temp;
            multiplier = d33_chopper_time_distance_params.multiplier(resolution_preset);
            d33_chopper_time_distance_params.masters_rpm(resolution_preset) = temp*multiplier;
        end
        
    case 'chopper1_phase'
        phase = str2num(get(gcbo,'string'));
        if not(isempty(phase));
            temp = find(d33_chopper_time_distance_params.masters(resolution_preset,:)==1);
            if not(isempty(temp));
                d33_chopper_time_distance_params.masters_phase(resolution_preset,temp) = phase;
            else
                temp = find(d33_chopper_time_distance_params.slaves(resolution_preset,:)==1);
                d33_chopper_time_distance_params.slaves_phase(resolution_preset,temp) = phase;
            end
        end
        
    case 'chopper2_phase'
        phase = str2num(get(gcbo,'string'));
        if not(isempty(phase));
            temp = find(d33_chopper_time_distance_params.masters(resolution_preset,:)==2);
            if not(isempty(temp));
                d33_chopper_time_distance_params.masters_phase(resolution_preset,temp) = phase;
            else
                temp = find(d33_chopper_time_distance_params.slaves(resolution_preset,:)==2);
                d33_chopper_time_distance_params.slaves_phase(resolution_preset,temp) = phase;
            end
        end
        
        
    case 'chopper3_phase'
        phase = str2num(get(gcbo,'string'));
        if not(isempty(phase));
            temp = find(d33_chopper_time_distance_params.masters(resolution_preset,:)==3);
            if not(isempty(temp));
                d33_chopper_time_distance_params.masters_phase(resolution_preset,temp) = phase;
            else
                temp = find(d33_chopper_time_distance_params.slaves(resolution_preset,:)==3);
                d33_chopper_time_distance_params.slaves_phase(resolution_preset,temp) = phase;
            end
        end
        
        
    case 'chopper4_phase'
        phase = str2num(get(gcbo,'string'));
        if not(isempty(phase));
            temp = find(d33_chopper_time_distance_params.masters(resolution_preset,:)==4);
            if not(isempty(temp));
                d33_chopper_time_distance_params.masters_phase(resolution_preset,temp) = phase;
            else
                temp = find(d33_chopper_time_distance_params.slaves(resolution_preset,:)==4);
                d33_chopper_time_distance_params.slaves_phase(resolution_preset,temp) = phase;
            end
        end
end

set(d33_chopper_time_distance_handles.f1_freq,'string',num2str(d33_chopper_time_distance_params.slaves_rpm(resolution_preset)));

set(d33_chopper_time_distance_handles.det_distance,'string',num2str(d33_chopper_time_distance_params.detector_distance));
set(d33_chopper_time_distance_handles.last_chopper_sample,'string',['Last Chopper-Sample Distance [m]: ' num2str(d33_chopper_time_distance_params.last_chopper_sample_distance)]);
set(d33_chopper_time_distance_handles.wav_min,'string',num2str(d33_chopper_time_distance_params.wav_range(1)));
set(d33_chopper_time_distance_handles.wav_max,'string',num2str(d33_chopper_time_distance_params.wav_range(2)));



%Draw the time-distance diagram
nf=d33_chopper_time_distance_params.multiplier(resolution_preset);
f1= d33_chopper_time_distance_params.slaves_rpm(resolution_preset);
chopper_opening = d33_chopper_time_distance_params.opening_angle;

periods = 2;
time_base = -periods*360:1:360*periods; %In cyclic units of f1
first_chopper_position = 1;


%Find parameters for the physical ordering of the choppers 1-4
%chopper1
chopper1_position = 0+first_chopper_position;
temp = find(d33_chopper_time_distance_params.masters(resolution_preset,:)==1);
if not(isempty(temp));
    chopper1_rpm = d33_chopper_time_distance_params.masters_rpm(resolution_preset);
    chopper1_phase = d33_chopper_time_distance_params.masters_phase(resolution_preset,temp);
    set(d33_chopper_time_distance_handles.c1_multiply,'string',num2str(nf));
else
    temp = find(d33_chopper_time_distance_params.slaves(resolution_preset,:)==1);
    chopper1_rpm = d33_chopper_time_distance_params.slaves_rpm(resolution_preset);
    chopper1_phase = d33_chopper_time_distance_params.slaves_phase(resolution_preset,temp);
    set(d33_chopper_time_distance_handles.c1_multiply,'string','1');
end
    set(d33_chopper_time_distance_handles.c1_rpm,'string',chopper1_rpm);
    set(d33_chopper_time_distance_handles.c1_phase,'string',chopper1_phase);


%chopper2
chopper2_position = 2.8+first_chopper_position;
temp = find(d33_chopper_time_distance_params.masters(resolution_preset,:)==2);
if not(isempty(temp));
    chopper2_rpm = d33_chopper_time_distance_params.masters_rpm(resolution_preset);
    chopper2_phase = d33_chopper_time_distance_params.masters_phase(resolution_preset,temp);
        set(d33_chopper_time_distance_handles.c2_multiply,'string',num2str(nf));
else
    temp = find(d33_chopper_time_distance_params.slaves(resolution_preset,:)==2);
    chopper2_rpm = d33_chopper_time_distance_params.slaves_rpm(resolution_preset);
    chopper2_phase = d33_chopper_time_distance_params.slaves_phase(resolution_preset,temp);
    set(d33_chopper_time_distance_handles.c2_multiply,'string','1');
end
    set(d33_chopper_time_distance_handles.c2_rpm,'string',chopper2_rpm);
    set(d33_chopper_time_distance_handles.c2_phase,'string',chopper2_phase);


%chopper3
chopper3_position = 4.2+first_chopper_position;
temp = find(d33_chopper_time_distance_params.masters(resolution_preset,:)==3);
if not(isempty(temp));
    chopper3_rpm = d33_chopper_time_distance_params.masters_rpm(resolution_preset);
    chopper3_phase = d33_chopper_time_distance_params.masters_phase(resolution_preset,temp);
    set(d33_chopper_time_distance_handles.c3_multiply,'string',num2str(nf));
else
    temp = find(d33_chopper_time_distance_params.slaves(resolution_preset,:)==3);
    chopper3_rpm = d33_chopper_time_distance_params.slaves_rpm(resolution_preset);
    chopper3_phase = d33_chopper_time_distance_params.slaves_phase(resolution_preset,temp);
    set(d33_chopper_time_distance_handles.c3_multiply,'string','1');
end
    set(d33_chopper_time_distance_handles.c3_rpm,'string',chopper3_rpm);
    set(d33_chopper_time_distance_handles.c3_phase,'string',chopper3_phase);


%chopper4
chopper4_position = 4.9+first_chopper_position;
temp = find(d33_chopper_time_distance_params.masters(resolution_preset,:)==4);
if not(isempty(temp));
    chopper4_rpm = d33_chopper_time_distance_params.masters_rpm(resolution_preset);
    chopper4_phase = d33_chopper_time_distance_params.masters_phase(resolution_preset,temp);
        set(d33_chopper_time_distance_handles.c4_multiply,'string',num2str(nf));
else
    temp = find(d33_chopper_time_distance_params.slaves(resolution_preset,:)==4);
    chopper4_rpm = d33_chopper_time_distance_params.slaves_rpm(resolution_preset);
    chopper4_phase = d33_chopper_time_distance_params.slaves_phase(resolution_preset,temp);
    set(d33_chopper_time_distance_handles.c4_multiply,'string','1');
end
    set(d33_chopper_time_distance_handles.c4_rpm,'string',chopper4_rpm);
    set(d33_chopper_time_distance_handles.c4_phase,'string',chopper4_phase);


%Draw choppers
%Delete Old Choppers 
delete(d33_chopper_time_distance_handles.chopper_handles);
d33_chopper_time_distance_handles.chopper_handles = [];

%chopper1
x_coords = [];
nf_chopper = chopper1_rpm/f1;
for n=-periods*nf_chopper:periods*nf_chopper
    open_phase = (-chopper1_phase +n*360)/nf_chopper;
    close_phase = (-chopper1_phase+chopper_opening+n*360)/nf_chopper;
    if open_phase < close_phase; open_phase = open_phase+(360/nf_chopper);end
    x_coords = [x_coords; close_phase,open_phase];
end
y_coords = ones(size(x_coords))*chopper1_position;
for n = 1:length(x_coords);
    h =line(x_coords(n,:),y_coords(n,:));
    set(h,'color','green','linewidth',[4]);
    d33_chopper_time_distance_handles.chopper_handles = [d33_chopper_time_distance_handles.chopper_handles, h];
end
%Keep a store of the chopper closed phase coordinates
chopper1_closed = x_coords;

%chopper2
x_coords = [];
nf_chopper = chopper2_rpm/f1;
for n=-periods*nf_chopper:periods*nf_chopper
    open_phase = (-chopper2_phase +n*360)/nf_chopper;
    close_phase = (-chopper2_phase+chopper_opening+n*360)/nf_chopper;
    if open_phase < close_phase; open_phase = open_phase+(360/nf_chopper);end
    x_coords = [x_coords; close_phase,open_phase];
end
y_coords = ones(size(x_coords))*chopper2_position;
for n = 1:length(x_coords);
    h =line(x_coords(n,:),y_coords(n,:));
    set(h,'color','green','linewidth',[4])
d33_chopper_time_distance_handles.chopper_handles = [d33_chopper_time_distance_handles.chopper_handles, h];
end
%Keep a store of the chopper closed phase coordinates
chopper2_closed = x_coords;

%chopper3
x_coords = [];
nf_chopper = chopper3_rpm/f1;
for n=-periods*nf_chopper:periods*nf_chopper
    open_phase = (-chopper3_phase +n*360)/nf_chopper;
    close_phase = (-chopper3_phase+chopper_opening+n*360)/nf_chopper;
    if open_phase < close_phase; open_phase = open_phase+(360/nf_chopper);end
    x_coords = [x_coords; close_phase,open_phase];
end
y_coords = ones(size(x_coords))*chopper3_position;
for n = 1:length(x_coords);
    h =line(x_coords(n,:),y_coords(n,:));
    set(h,'color','green','linewidth',[4])
d33_chopper_time_distance_handles.chopper_handles = [d33_chopper_time_distance_handles.chopper_handles, h];
end
%Keep a store of the chopper closed phase coordinates
chopper3_closed = x_coords;

%chopper4
x_coords = [];
nf_chopper = chopper4_rpm/f1;
for n=-periods*nf_chopper:periods*nf_chopper
    open_phase = (-chopper4_phase +n*360)/nf_chopper;
    close_phase = (-chopper4_phase+chopper_opening+n*360)/nf_chopper;
    if open_phase < close_phase; open_phase = open_phase+(360/nf_chopper);end
    x_coords = [x_coords; close_phase,open_phase];
end
y_coords = ones(size(x_coords))*chopper4_position;
for n = 1:length(x_coords);
    h =line(x_coords(n,:),y_coords(n,:));
    set(h,'color','green','linewidth',[4])
d33_chopper_time_distance_handles.chopper_handles = [d33_chopper_time_distance_handles.chopper_handles, h];
end
%Keep a store of the chopper closed phase coordinates
chopper4_closed = x_coords;



%Delete Old Rays
%Delete Old Choppers 
delete(d33_chopper_time_distance_handles.ray_handles);
d33_chopper_time_distance_handles.ray_handles = [];
if not(isempty(d33_chopper_time_distance_handles.wav_text_handle));
    temp = fieldnames(d33_chopper_time_distance_handles.wav_text_handle);
    for n = 1:length(temp);
        delete(d33_chopper_time_distance_handles.wav_text_handle.([temp{n}]));
        d33_chopper_time_distance_handles.wav_text_handle= rmfield(d33_chopper_time_distance_handles.wav_text_handle,([temp{n}]));
    end
end

%Draw wavelengths
wav_step = round((d33_chopper_time_distance_params.wav_range(2)-d33_chopper_time_distance_params.wav_range(1))/10);
colorscale = flipud(colormap);
for tp=time_base %Phase time base
    %convert phase time to real time
    tt = (tp /360)/(f1/60); %True time base
    
    for wav = d33_chopper_time_distance_params.wav_range(1):wav_step:d33_chopper_time_distance_params.wav_range(2)
        t0 = tt*360 *(f1/60); d0 = 0;
        
        color_index = floor(length(colorscale)/(d33_chopper_time_distance_params.wav_range(2)-d33_chopper_time_distance_params.wav_range(1))*wav);
        if color_index == 0; color_index = 1; end
        if color_index >64; color_index = 64; end
        color = colorscale(color_index,:);
        
        alive = 1;
        %Calculate phase time at chopper1
        d1 = chopper1_position;
        t1 = d1*m_n*wav*(10^-10)/h_plank;
        t1 = t1*360 *(f1/60);
        absolute_phase_time = t0+t1;
        for n = 1:length(chopper1_closed);
            if absolute_phase_time >chopper1_closed(n,1) & absolute_phase_time <chopper1_closed(n,2)%
                alive = 0; %neutron killed
            end
        end
        
        %Calculate phase time at chopper2
        if alive ==1;
            d1 = chopper2_position;
            t1 = d1*m_n*wav*(10^-10)/h_plank;
            t1 = t1*360 *(f1/60);
            absolute_phase_time = t0+t1;
            for n = 1:length(chopper2_closed);
                if absolute_phase_time >chopper2_closed(n,1) & absolute_phase_time <chopper2_closed(n,2)%
                    alive = 0; %neutron killed
                end
            end
        end
        
        %Calculate phase time at chopper3
        if alive ==1;
            d1 = chopper3_position;
            t1 = d1*m_n*wav*(10^-10)/h_plank;
            t1 = t1*360 *(f1/60);
            absolute_phase_time = t0+t1;
            for n = 1:length(chopper3_closed);
                if absolute_phase_time >chopper3_closed(n,1) & absolute_phase_time <chopper3_closed(n,2)%
                    alive = 0; %neutron killed
                end
            end
        end
        
        %Calculate phase time at chopper4
        if alive ==1;
            d1 = chopper4_position;
            t1 = d1*m_n*wav*(10^-10)/h_plank;
            t1 = t1*360 *(f1/60);
            absolute_phase_time = t0+t1;
            for n = 1:length(chopper4_closed);
                if absolute_phase_time >chopper4_closed(n,1) & absolute_phase_time <chopper4_closed(n,2)%
                    alive = 0; %neutron killed
                end
            end
        end
        
        %if still alive then draw to the end of diagram
        if alive ==1;
            d1 = d33_chopper_time_distance_params.last_chopper_sample_distance+d33_chopper_time_distance_params.detector_distance+chopper4_position;
            t1 = d1*m_n*wav*(10^-10)/h_plank;
            t1 = t1*360 *(f1/60);
            if not(isfield(d33_chopper_time_distance_handles.wav_text_handle,['wav' num2str(round(wav))]));
                d33_chopper_time_distance_handles.wav_text_handle.(['wav' num2str(round(wav))]) = text([t0+t1],[d1],num2str(wav));
            end
            
        
        end
        %Draw the neutron as far as it went
        %only draw if lies within the axis limits
        if (t0+t1) <= time_base(length(time_base)) & d0 >=0 & d1<= (d33_chopper_time_distance_params.last_chopper_sample_distance+d33_chopper_time_distance_params.detector_distance+chopper4_position)
        
        h = line([t0,t0+t1],[d0,d1]); set(h,'color',color)
        d33_chopper_time_distance_handles.ray_handles = [d33_chopper_time_distance_handles.ray_handles, h];
        end
        

    end
    
end
%set axis limits
axis(d33_chopper_time_distance_handles.axis_handle,[time_base(1),time_base(length(time_base)),0,d33_chopper_time_distance_params.last_chopper_sample_distance+d33_chopper_time_distance_params.detector_distance+chopper4_position])


