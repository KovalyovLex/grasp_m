function d33_chopper_time_distance


%Use:
%print('-depsc2','-noui','-loose',['/home/lss/dewhurst/Desktop/arse2.eps']);
%
%to print.


global d33_chopper_time_distance_handles
d33_chopper_time_distance_handles = [];
d33_chopper_time_distance_handles.chopper_handles = [];
d33_chopper_time_distance_handles.ray_handles = [];
d33_chopper_time_distance_handles.wav_text_handle = [];

global d33_chopper_time_distance_params
d33_chopper_time_distance_params = [];

global grasp_env

background_color = [0.1, 0.26, 0.21];
foreground_color = [0.95,0.95,0.95];

%Default chopper parameters
d33_chopper_time_distance_params.wav_range = [0,20];
d33_chopper_time_distance_params.detector_distance = 10;

%Setup Figure & Gui
d33_chopper_time_distance_handles.figure_handle = figure('units','pixels','position',[220, 50, 1200, 850],'color',background_color);
d33_chopper_time_distance_handles.axis_handle = axis;
set(gca,'position',[0.12, 0.10, 0.5, 0.8])
a = title('D33 Chopper Time-Distance Diagram');
get(a)
set(a,'fontname',grasp_env.font);
%set(a,'fontsize',20,'tag','time_distance_tag')


xlabel('Phase Time [degrees]'); ylabel('Distance [m]')


%Detector Distance & Wavelength Band
uicontrol('units','normalized','position',[0.65, 0.9, 0.1, 0.02],'horizontalalignment','right','style','text','string','Detector Distance [m]:','backgroundcolor',background_color,'foregroundcolor',foreground_color)
d33_chopper_time_distance_handles.det_distance = uicontrol('units','normalized','position',[0.77, 0.9, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','callback','d33_chopper_time_distance_callbacks(''det'');');
d33_chopper_time_distance_handles.last_chopper_sample = uicontrol('units','normalized','position',[0.65, 0.86, 0.4, 0.02],'horizontalalignment','left','style','text','string','xxxx','backgroundcolor',background_color,'foregroundcolor',foreground_color);
d33_chopper_time_distance_handles.total_tof_distance = uicontrol('units','normalized','position',[0.65, 0.81, 0.4, 0.02],'horizontalalignment','left','style','text','string','xxxx','backgroundcolor',background_color,'foregroundcolor',foreground_color);


uicontrol('units','normalized','position',[0.65, 0.75, 0.1, 0.02],'horizontalalignment','right','style','text','string','Wav Band [Å]:','backgroundcolor',background_color,'foregroundcolor',foreground_color);
d33_chopper_time_distance_handles.wav_min = uicontrol('units','normalized','position',[0.77, 0.75, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxx','callback','d33_chopper_time_distance_callbacks(''wav_min'');');
d33_chopper_time_distance_handles.wav_max = uicontrol('units','normalized','position',[0.85, 0.75, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','callback','d33_chopper_time_distance_callbacks(''wav_max'');');

%Resolution_Preset
uicontrol('units','normalized','position',[0.65, 0.70, 0.1, 0.02],'horizontalalignment','right','style','text','string','Resolution Preset:','backgroundcolor',background_color,'foregroundcolor',foreground_color);
d33_chopper_time_distance_handles.res_preset = uicontrol('units','normalized','position',[0.77, 0.70, 0.1, 0.02],'horizontalalignment','right','style','popup','string',' ','callback','d33_chopper_time_distance_callbacks(''res_preset'');');

%F1 frequency (RPM)
uicontrol('units','normalized','position',[0.65, 0.35, 0.1, 0.02],'horizontalalignment','right','style','text','string','F1 Frequency (RPM):','backgroundcolor',background_color,'foregroundcolor',foreground_color);
d33_chopper_time_distance_handles.f1_freq = uicontrol('units','normalized','position',[0.77, 0.35, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','callback','d33_chopper_time_distance_callbacks(''f1_freq'');');

%Multiplyer, Speed, Phase
uicontrol('units','normalized','position',[0.72, 0.28, 0.05, 0.02],'horizontalalignment','center','style','text','string','Multiplyer N','backgroundcolor',background_color,'foregroundcolor',foreground_color);
uicontrol('units','normalized','position',[0.82, 0.28, 0.05, 0.02],'horizontalalignment','center','style','text','string','RPM','backgroundcolor',background_color,'foregroundcolor',foreground_color);
uicontrol('units','normalized','position',[0.92, 0.28, 0.05, 0.02],'horizontalalignment','center','style','text','string','Phase','backgroundcolor',background_color,'foregroundcolor',foreground_color),;


%Chopper4
uicontrol('units','normalized','position',[0.65, 0.25, 0.06, 0.02],'horizontalalignment','right','style','text','string','Chopper4: ','backgroundcolor',background_color,'foregroundcolor',foreground_color);
d33_chopper_time_distance_handles.c4_multiply = uicontrol('units','normalized','position',[0.72, 0.25, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','enable','off');
d33_chopper_time_distance_handles.c4_rpm = uicontrol('units','normalized','position',[0.82, 0.25, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','enable','off');
d33_chopper_time_distance_handles.c4_phase = uicontrol('units','normalized','position',[0.92, 0.25, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','callback','d33_chopper_time_distance_callbacks(''chopper4_phase'');');

%Chopper3
uicontrol('units','normalized','position',[0.65, 0.2, 0.06, 0.02],'horizontalalignment','right','style','text','string','Chopper3: ','backgroundcolor',background_color,'foregroundcolor',foreground_color);
d33_chopper_time_distance_handles.c3_multiply = uicontrol('units','normalized','position',[0.72, 0.2, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','enable','off');
d33_chopper_time_distance_handles.c3_rpm = uicontrol('units','normalized','position',[0.82, 0.2, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','enable','off');
d33_chopper_time_distance_handles.c3_phase = uicontrol('units','normalized','position',[0.92, 0.2, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','callback','d33_chopper_time_distance_callbacks(''chopper3_phase'');');

%Chopper2
uicontrol('units','normalized','position',[0.65, 0.15, 0.06, 0.02],'horizontalalignment','right','style','text','string','Chopper2: ','backgroundcolor',background_color,'foregroundcolor',foreground_color);
d33_chopper_time_distance_handles.c2_multiply = uicontrol('units','normalized','position',[0.72, 0.15, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','enable','off');
d33_chopper_time_distance_handles.c2_rpm = uicontrol('units','normalized','position',[0.82, 0.15, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','enable','off');
d33_chopper_time_distance_handles.c2_phase = uicontrol('units','normalized','position',[0.92, 0.15, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','callback','d33_chopper_time_distance_callbacks(''chopper2_phase'');');

%Chopper1
uicontrol('units','normalized','position',[0.65, 0.1, 0.06, 0.02],'horizontalalignment','right','style','text','string','Chopper1: ','backgroundcolor',background_color,'foregroundcolor',foreground_color);
d33_chopper_time_distance_handles.c1_multiply = uicontrol('units','normalized','position',[0.72, 0.1, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','enable','off');
d33_chopper_time_distance_handles.c1_rpm = uicontrol('units','normalized','position',[0.82, 0.1, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','enable','off');
d33_chopper_time_distance_handles.c1_phase = uicontrol('units','normalized','position',[0.92, 0.1, 0.05, 0.02],'horizontalalignment','right','style','edit','string','xxxx','callback','d33_chopper_time_distance_callbacks(''chopper1_phase'');');


% %Generate time-distance diagram
% uicontrol('units','normalized','position',[0.73, 0.1, 0.15, 0.05],'horizontalalignment','center','style','pushbutton','string','Generate Figure');


%Refresh
d33_chopper_time_distance_callbacks('re_calculate_chopper_parameters');






