function tof_calculator_callbacks(todo)

%Constants
h = 6.626076*(10^-34); %Plank's Constant
m_n = 1.674929*(10^-27); %Neutron Rest Mass

%Get all the gui handles and values
hd = findobj('tag','tof_calculator_dist');
dist = str2num(get(hd,'string'));
if isempty(dist); return; end
hw = findobj('tag','tof_calculator_wav');
wav = str2num(get(hw,'string'));
if isempty(wav); return; end
ht = findobj('tag','tof_calculator_time');
tof = str2num(get(ht,'string'));
if isempty(tof); return; end
hv = findobj('tag','tof_calculator_velocity'); 
hf = findobj('tag','tof_calculator_freq'); 



switch todo
    
    case 'distance_edit'
        velocity = h / (m_n*wav*10^-10); %m/s
        tof = dist / velocity; %seconds
    case 'wav_edit'
        velocity = h / (m_n*wav*10^-10); %m/s
        tof = dist / velocity; %seconds
    case 'time_edit'
        wav = (h * tof)/ (m_n*dist);
        wav = wav*(10^10); %Convert m to angs
        velocity = h / (m_n*wav*10^-10); %m/s
end

freq = 1/tof; %Hz

%Poke all the numbers back to the display
set(hd,'string',num2str(dist));
set(hw,'string',num2str(wav));
set(ht,'string',num2str(tof));
set(hv,'string',num2str(velocity));
set(hf,'string',num2str(freq));


        
        