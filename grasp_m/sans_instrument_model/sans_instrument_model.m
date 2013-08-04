function sans_instrument_model(inst)

global inst_config
global inst_component
global d33_handles
global inst_model_params
global sample_config
global background_config
global cadmium_config

if nargin ==0;
    inst = 'ILL_d33';
end

set(0,'defaultfigurepapertype','a4');
colordef black; %Window bacground


sample_config.model_number = 1; %Default Sample Model
%***** Sample Scattering Models *****
model = 0;

model=model+1;
sample_config.model(model).name = '<None>';
sample_config.model(model).pnames = [];
sample_config.model(model).structname = [];
sample_config.model(model).fn_eval = '0';

model=model+1;
sample_config.model(model).name = 'Sphere';
sample_config.model(model).pnames = [{'Radius [A]:'} {'Poly [%FWHM]:'} {'Contrast [A-2]:'} {'Scale:'} {'Background [cm-1]:'}];
sample_config.model(model).structname = [{'radius'} {'poly_fwhm'} {'contrast'} {'scale'} {'background'}];
sample_config.model(model).fn_eval = ['ff_sphere(q, sample_config.model(' num2str(model) ').radius, sample_config.model(' num2str(model) ').poly_fwhm, sample_config.model(' num2str(model) ').contrast, sample_config.model(' num2str(model) ').scale, sample_config.model(' num2str(model) ').background)'];
sample_config.model(model).radius = 60; %Angs
sample_config.model(model).poly_fwhm = 10;
sample_config.model(model).contrast = 6e-6; %A-2    6e-6 is roughly H Surfactant in D2O
sample_config.model(model).scale = 0.01; %Concentration
sample_config.model(model).background = 0; %D20

model=model+1;
sample_config.model(model).name = 'Guinier';
sample_config.model(model).pnames = [{'Radius RG [A]'} {'I0:'} {'Background [cm-1]'}];
sample_config.model(model).structname = [{'rg'} {'i0'} {'background'}];
sample_config.model(model).fn_eval = ['ff_guinier(q, sample_config.model(' num2str(model) ').rg, sample_config.model(' num2str(model) ').i0, sample_config.model(' num2str(model) ').background)'];
sample_config.model(model).rg = 60; %Angs
sample_config.model(model).i0 = 1;
sample_config.model(model).background = 0;

model=model+1;
sample_config.model(model).name = 'Porod';
sample_config.model(model).pnames = [{'Spec. Surf. [A^2]'} {'Contrast [A-2]:'} {'Background [cm-1]'}];
sample_config.model(model).structname = [{'surf'} {'contrast'} {'background'}];
sample_config.model(model).fn_eval = ['ff_porod(q, sample_config.model(' num2str(model) ').surf, sample_config.model(' num2str(model) ').contrast, sample_config.model(' num2str(model) ').background)'];
sample_config.model(model).surf = 1; %Angs
sample_config.model(model).contrast = 1e-6;
sample_config.model(model).background = 0;

model=model+1;
sample_config.model(model).name = 'Flux Line Bragg Peak';
sample_config.model(model).pnames = [{'Magnetic Field [G]'} {'Rocking Width [degs]'} {'Az Correlation [microns]'} {'Rad Correlation [microns]'} {'Lambda_L [A]'} {'San [degs]'} {'Phi [degs]'} {'Orientation [degs]'}];
sample_config.model(model).structname = [{'field'} {'width'} {'az_cor'} {'rad_cor'} {'pen_depth'} {'san'} {'phi'} {'rot'}];
sample_config.model(model).fn_eval = ['ff_vortex(real_q_matrix, wav_matrix, sample_config.model(' num2str(model) ').field, sample_config.model(' num2str(model) ').width, sample_config.model(' num2str(model) ').az_cor, sample_config.model(' num2str(model) ').rad_cor, sample_config.model(' num2str(model) ').pen_depth, sample_config.model(' num2str(model) ').san, sample_config.model(' num2str(model) ').phi, sample_config.model(' num2str(model) ').rot)'];
%sample_config.model(4).pnames = [{'Magnetic Field [G]'} {'Rocking Width [degs]'} {'Az Correlation [micron]'} {'Rad Correlation [micron]'} {'Reflectivity [%]'} {'Q4 Background [%]'} {'Q4 ref. q [A-1]'} {'Inc. Background [%]'} {'San [degs]'} {'Phi [degs]'} {'Orientation [degs]'}];
%sample_config.model(4).structname = [{'field'} {'width'} {'az_cor'} {'rad_cor'} {'ref'} {'q4_background'} {'q4_ref_q'} {'inc_background'} {'san'} {'phi'} {'rot'}];
%sample_config.model(4).fn_eval = 'ff_vortex(real_q_matrix, sample_config.model(4).field, sample_config.model(4).width, sample_config.model(4).az_cor, sample_config.model(4).rad_cor, sample_config.model(4).ref, sample_config.model(4).q4_background, sample_config.model(4).q4_ref_q, sample_config.model(4).inc_background, sample_config.model(4).san, sample_config.model(4).phi, sample_config.model(4).rot)';
sample_config.model(model).field = 1000; %gauss
sample_config.model(model).width = 0.5; %degrees
sample_config.model(model).az_cor = 0.5; %microns
sample_config.model(model).rad_cor = 1; %microns
sample_config.model(model).pen_depth = 1000; % Penetration Depth A
%sample_config.model(4).q4_background = 1e-8; % Percent of main beam at q reference
%sample_config.model(4).q4_ref_q = 0.001; 
%sample_config.model(4).inc_background = 1; % Percent of main beam
sample_config.model(model).san = 0; %San rocking angle
sample_config.model(model).phi = 0; %Phi rocking angle
sample_config.model(model).rot = 0; %FLL orientation

model=model+1;
sample_config.model(model).name = 'Porod + Magnetic Porod';
sample_config.model(model).pnames = [{'Spec. Surf. NonMag [A^2]'} {'Contrast NonMag [A-2]:'} {'Spec. Surf. Magnetic [A^2]'} {'Contrast Magnetic [A-2]:'} {'Background [cm-1]'}];
sample_config.model(model).structname = [{'surf'} {'contrast'} {'magsurf'} {'magcontrast'} {'background'}];
sample_config.model(model).fn_eval = ['ff_mag_porod(q, real_q_matrix, sample_config.model(' num2str(model) ').surf, sample_config.model(' num2str(model) ').contrast, sample_config.model(' num2str(model) ').magsurf, sample_config.model(' num2str(model) ').magcontrast, sample_config.model(' num2str(model) ').background)'];
sample_config.model(model).surf = 1; %Angs
sample_config.model(model).contrast = 1e-6;
sample_config.model(model).magsurf = 1; %Angs
sample_config.model(model).magcontrast = 1e-6;
sample_config.model(model).background = 0;

model=model+1;
sample_config.model(model).name = 'Water';
sample_config.model(model).pnames = [];
sample_config.model(model).structname = [];
sample_config.model(model).fn_eval = 'ff_water(q)';

model=model+1;
sample_config.model(model).name = 'Ribosome';
sample_config.model(model).pnames = [];
sample_config.model(model).structname = [];
sample_config.model(model).fn_eval = 'ff_ribosome(q)';

model=model+1;
sample_config.model(model).name = 'Gabel Protien';
sample_config.model(model).pnames = [];
sample_config.model(model).structname = [];
sample_config.model(model).fn_eval = 'ff_gabel_protien(q)';

model=model+1;
sample_config.model(model).name = 'Empty Cell';
sample_config.model(model).pnames = [];
sample_config.model(model).structname = [];
sample_config.model(model).fn_eval = 'ff_empty_cell(q)';

model=model+1;
sample_config.model(model).name = 'Water + Cell';
sample_config.model(model).pnames = [];
sample_config.model(model).structname = [];
sample_config.model(model).fn_eval = 'ff_water_cell(q)';

model=model+1;
sample_config.model(model).name = 'D2O + Cell';
sample_config.model(model).pnames = [];
sample_config.model(model).structname = [];
sample_config.model(model).fn_eval = 'ff_d2o_cell(q)';


model=model+1;
sample_config.model(model).name = 'Blocked Beam';
sample_config.model(model).pnames = [];
sample_config.model(model).structname = [];
sample_config.model(model).fn_eval = 'ff_cadmium(q)';




%***** Background Scattering Models *****
background_config.model_number = 1;
model=0;

model=model+1;
background_config.model(model).name = '<None>';
background_config.model(model).pnames = [];
background_config.model(model).structname = [];
background_config.model(model).fn_eval = '0';

model=model+1;
background_config.model(model).name = 'Empty Cell';
background_config.model(model).pnames = [];
background_config.model(model).structname = [];
background_config.model(model).fn_eval = 'ff_empty_cell(q)';

model=model+1;
background_config.model(model).name = 'Water + Cell';
background_config.model(model).pnames = [];
background_config.model(model).structname = [];
background_config.model(model).fn_eval = 'ff_water_cell(q)';

model=model+1;
background_config.model(model).name = 'D2O + Cell';
background_config.model(model).pnames = [];
background_config.model(model).structname = [];
background_config.model(model).fn_eval = 'ff_d2o_cell(q)';

model=model+1;
background_config.model(model).name = 'Cryostat Ox7T';
background_config.model(model).pnames = [];
background_config.model(model).structname = [];
background_config.model(model).fn_eval = 'ff_cryostat_ox7t(q)';

model=model+1;
background_config.model(model).name = 'Blocked Beam';
background_config.model(model).pnames = [];
background_config.model(model).structname = [];
background_config.model(model).fn_eval = 'ff_cadmium(q)';



%***** Blocked Beam Scattering Models *****
cadmium_config.model_number = 1;
model=0;

model=model+1;
cadmium_config.model(model).name = '<None>';
cadmium_config.model(model).pnames = [];
cadmium_config.model(model).structname = [];
cadmium_config.model(model).fn_eval = '0';

model=model+1;
cadmium_config.model(model).name = 'Blocked Beam';
cadmium_config.model(model).pnames = [];
cadmium_config.model(model).structname = [];
cadmium_config.model(model).fn_eval = 'ff_cadmium(q)';



%***** Program Parameters *****
inst_model_params.font = 'Arial';
inst_model_params.fontsize = 8;
inst_model_params.background_color = [0.1000    0.2600    0.2100];
inst_model_params.foreground_color = [1 1 1];
inst_model_params.hold_images_check = 0;
inst_model_params.hold_count = 1;
inst_model_params.hold_stagger_plots = 0;
inst_model_params.det_image = 'Detector_Image';
inst_model_params.det_image_log_check = 1;
inst_model_params.det_image_tof_frame = 1;
inst_model_params.col_in_color = [0.2, 0.4, 1];
inst_model_params.col_out_color = [1, 0, 0];
inst_model_params.det_image_tof_frame = 1;
inst_model_params.auto_calculate = 0; %1 = on, 0 = off
inst_model_params.measurement_time = 600; %seconds
inst_model_params.sample_thickness = 0.1; %cm
inst_model_params.sample_area = 1*0.7; %cm^2
inst_model_params.monitor = 0; %Some beam monitor fraction of the incoming beam intensity
inst_model_params.poissonian_noise_check = 1;
inst_model_params.divergence_check = 0;
inst_model_params.delta_lambda_check = 0;
inst_model_params.smearing_pos = 4; %position on the popupmenu
inst_model_params.smearing = 10; %Smearing itterations
inst_model_params.subtitle = 'Sample';
inst_model_params.square_tri_selector_check = 0;

%***** Initialise Handles *****
d33_handles.iq_plot1 = []; d33_handles.iq_plot2 = []; d33_handles.iq_plot3 = []; d33_handles.iq_plot4 = []; d33_handles.iq_plot5 = [];
d33_handles.q_boundaries1 = []; d33_handles.q_boundaries2 = []; d33_handles.q_boundaries3 = []; d33_handles.q_boundaries4 = []; d33_handles.q_boundaries5 = [];
d33_handles.q_resolution1 = [];d33_handles.q_resolution2 = [];d33_handles.q_resolution3 = [];d33_handles.q_resolution4 = [];d33_handles.q_resolution5 = [];d33_handles.q_resolution6 = [];d33_handles.q_resolution7 = [];d33_handles.q_resolution8 = [];d33_handles.q_resolution9 = [];d33_handles.q_resolution10 = [];d33_handles.q_resolution11 = [];
d33_handles.scattering_model_gui = [];d33_handles.background_model_gui = []; d33_handles.cadmium_model_gui = [];


%***** Load the Instrument Configuration *****
if strcmp(inst,'ILL_d22');
    [inst_config, inst_component] = d22_model_component;
elseif strcmp(inst,'ILL_d11');
    [inst_config, inst_component] = d11_model_component;
elseif strcmp(inst,'SINQ_sans_I');
    [inst_config, inst_component] = sinq_sans1_model_component;
elseif strcmp(inst,'SINQ_sans_II');
    [inst_config, inst_component] = sinq_sans2_model_component;
elseif strcmp(inst,'NIST_ng3');
    [inst_config, inst_component] = nist_ng3_model_component;
elseif strcmp(inst,'NIST_ng7');
    [inst_config, inst_component] = nist_ng7_model_component;
elseif strcmp(inst,'ORNL_cg2');
    [inst_config, inst_component] = ornl_cg2_model_component;
elseif strcmp(inst,'ORNL_cg3');
    [inst_config, inst_component] = ornl_cg3_model_component;
elseif strcmp(inst,'ANSTO_quokka');
    [inst_config, inst_component] = ansto_quokka_model_component;
elseif strcmp(inst,'ESS_SANS');
    [inst_config, inst_component] = ess_model_component;
else %D33
    [inst_config, inst_component] = d33_model_component;
    inst = 'ILL_d33';
    
end
inst_config.inst = inst;


%***** Draw Instrument *****
%Open figure window
d33_handles.detector_model_figure = figure('units','normalized', 'position',[0.05 0.05 0.9 0.8],'color',inst_model_params.background_color,'toolbar','figure','name',['Instrument Configuration:  ' inst]);

%Draw Casemate & Collimation Axes
inst_model_params.collimation_view_axes = [0.0350    0.7456    0.8586    0.2000];
d33_handles.casemate_collimation_view = axes('position',inst_model_params.collimation_view_axes);
%find axis limits
col_xlim = 0;
det_xlim = 0;
for n = 1:length(inst_component);
    if (inst_component(n).position + inst_component(n).length) < col_xlim;
        col_xlim = (inst_component(n).position + inst_component(n).length);
    end
    if strfind(inst_component(n).name,'Detector');
        if inst_component(n).parameters.position_max > det_xlim; det_xlim = 1.1 * inst_component(n).parameters.position_max; end
    end
end
inst_model_params.collimation_axes_limits = [col_xlim, 0, -0.25, +0.25];
axis(d33_handles.casemate_collimation_view,inst_model_params.collimation_axes_limits);

%Draw Detector Side View Axes
inst_model_params.det_side_view_axes = [0.2    0.45    0.6    0.2];
d33_handles.det_side_view = axes('position',inst_model_params.det_side_view_axes);
inst_model_params.det_side_axes_limits = [0, det_xlim, -inst_config.tube_diameter/2, +inst_config.tube_diameter/2];
axis(d33_handles.det_side_view,inst_model_params.det_side_axes_limits);
%Tube boundary
rectangle('position',[0, -inst_config.tube_diameter/2, inst_config.tube_length, inst_config.tube_diameter],'edgecolor','red');

%Draw Detector Front View Axes
inst_model_params.det_front_view = [0    0.45    0.2    0.2];
d33_handles.det_front_view = axes('position',inst_model_params.det_front_view);
inst_model_params.det_front_axes_limits = [-inst_config.tube_diameter/2, +inst_config.tube_diameter/2, -inst_config.tube_diameter/2, +inst_config.tube_diameter/2];
axis(d33_handles.det_front_view,inst_model_params.det_front_axes_limits);
axis square

%Draw Tube boundary
angle = 0:0.1:2*pi;
radius = inst_config.tube_diameter/2;
[x,y] = pol2cart(angle,radius);
axes(d33_handles.det_front_view);
h=line(x,y);
set(h,'color','red');

%Draw Instrument Obejcts
collimation_string = {}; collimation_counter = 0;
chopper_positions_store = [];
for n = 1:length(inst_component);
    x0 = inst_component(n).position;

    if x0<=0;    %Collimation Side
        y0 = inst_component(n).drawcntr(2) - inst_component(n).drawdim(2)/2 ;
        dx = inst_component(n).length;
        if dx ==0; dx = 0.1; end
        dy = inst_component(n).drawdim(2);
        color = inst_component(n).color;
        if dx <0; x0 = x0 + dx; dx = -dx; end

        axes(d33_handles.casemate_collimation_view);
        inst_component(n).handle = rectangle('position',[x0, y0, dx, dy],'facecolor',color);

        %Special Instrument Controls
        %Apertures
        if findstr(inst_component(n).name,'Aperture')
            aperture_string = [];
            %Build Aperture Selector
            for m = 1:length(inst_component(n).xydim); %Build aperture description string for popup
                if length(inst_component(n).xydim{m}) == 1; %Circular
                    aperture_string{m} = [num2str(m) ': ' num2str(inst_component(n).xydim{m}*1000) 'mm Dia'];
                elseif length(inst_component(n).xydim{m}) == 2; %rectangular or square
                    aperture_string{m} = [num2str(m) ': ' num2str(inst_component(n).xydim{m}(1)*1000) 'x' num2str(inst_component(n).xydim{m}(2)*1000) ' mm'];
                end
            end
            %Place Aperture Popup
            position = inst_model_params.collimation_view_axes(1)+inst_model_params.collimation_view_axes(3)+inst_component(n).position*0.9/(inst_model_params.collimation_axes_limits(3)-inst_model_params.collimation_axes_limits(1));
            uicontrol('units','normalized','Position',[position    0.975   0.06    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','Aperture','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
            inst_component(n).ui_handle = uicontrol('units','normalized','Position',[position    0.9522    0.06   0.018],'Style','popupmenu','string',aperture_string,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'value',inst_component(n).value,'userdata',n,'enable','off','callback','sans_instrument_model_callbacks(''app_popup'')');
        end

        if findstr(inst_component(n).name,'Chopper:')
            chopper_positions_store = [chopper_positions_store, inst_component(n).position];
            
            %Number choppers
            chopper_number_str = strtok(inst_component(n).name,'Chopper: ');
            chopper_number = str2num(chopper_number_str);
            text(x0, 0, chopper_number_str,'fontweight','bold','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize)
            %Make blank chopper parameters
            if isodd(chopper_number); y0 = -0.1; else y0 = -0.2; end
            temp = text(x0,y0,'','fontweight','bold','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
            d33_handles = setfield(d33_handles,['chopper' num2str(chopper_number) 'text'],temp);
        end

        %Build Collimation Selector String
        if findstr(inst_component(n).name,'Collimation')
            collimation_counter = collimation_counter + (-inst_component(n).length);
            collimation_string = [collimation_string, {num2str(collimation_counter)}];
        end

    else %Detector side
        if findstr(inst_component(n).name,'Detector')
            for m = 1:inst_component(n).pannels;
                pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]);
                x00 = x0 + pannel_struct.relative_position;
                if strcmp(pannel_struct.name,'Top') || strcmp(pannel_struct.name,'Bottom')
                    y0 = pannel_struct.drawcntr(2) - pannel_struct.drawdim(2)/2 + pannel_struct.parameters.opening(2);
                else
                    y0 = pannel_struct.drawcntr(2) - pannel_struct.drawdim(2)/2;
                end

                dx = pannel_struct.length;
                if dx ==0; dx = 0.1; end
                dy = pannel_struct.drawdim(2);
                color = pannel_struct.color;
                if dx <0; x0 = x0 + dx; dx = -dx; end

                %Plot Detector Side View
                axes(d33_handles.det_side_view);
                pannel_struct.draw_handle_side_view = rectangle('position',[x00, y0, dx, dy],'facecolor',color);

                %Plot Detector Front View
                detector_size = pannel_struct.parameters.pixels.* pannel_struct.parameters.pixel_size;
                axes(d33_handles.det_front_view);
                pannel_struct.draw_handle_front_view = rectangle('position',[-detector_size(1)/2+pannel_struct.parameters.opening(1), -detector_size(2)/2+pannel_struct.parameters.opening(2), detector_size(1), detector_size(2)],'facecolor',pannel_struct.color);

                %Special D33 Pannel moving sliders
                if findstr(pannel_struct.name,'Top')
                    pannel_struct.pannel_slider_handle = uicontrol('units','normalized','Position',[0.17    0.5133    0.0065    0.1372],'Style','slider','Tag','det1_slider','Value',1,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''pannel_slider'')');
                    pannel_struct.pannel_editbox_handle = uicontrol('units','normalized','Position',[0.17    0.6556    0.0200    0.0200],'Style','edit','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''pannel_edit'')');
                    %group opening checkbox
                    inst_component(n).pannel_group_handle = uicontrol('units','normalized','position',[0.0079    0.6589    0.0200    0.0200],'style','checkbox','value',inst_component(n).pannel_group,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''pannel_group_check'');');
                elseif findstr(pannel_struct.name,'Bottom')
                    pannel_struct.pannel_slider_handle = uicontrol('units','normalized','Position',[0.007    0.4477    0.0065    0.1372],'Style','slider','Tag','det1_slider','Value',1,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''pannel_slider'')');
                    pannel_struct.pannel_editbox_handle = uicontrol('units','normalized','Position',[0.007    0.6044    0.0200    0.0200],'Style','edit','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''pannel_edit'')');
                elseif findstr(pannel_struct.name,'Left')
                    pannel_struct.pannel_slider_handle = uicontrol('units','normalized','Position',[0.0350    0.4128    0.0986    0.0100],'Style','slider','Tag','det1_slider','Value',1,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''pannel_slider'')');
                    pannel_struct.pannel_editbox_handle = uicontrol('units','normalized','Position',[0.1379    0.4022    0.0200    0.0200],'Style','edit','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'userdata',[n,m],'callback','sans_instrument_model_callbacks(''pannel_edit'')');
                elseif findstr(pannel_struct.name,'Right')
                    pannel_struct.pannel_slider_handle = uicontrol('units','normalized','Position',[0.0657    0.6594    0.0986    0.0100],'Style','slider','Tag','det1_slider','Value',1,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''pannel_slider'')');
                    pannel_struct.pannel_editbox_handle = uicontrol('units','normalized','Position',[0.04    0.6556    0.0200    0.0200],'Style','edit','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''pannel_edit'')');
                end
                
                %Special D22 Detector Offset
                if findstr(pannel_struct.name,'Rear')
                    if isfield(pannel_struct.parameters,'centre_translation_max');
                    pannel_struct.pannel_slider_handle = uicontrol('units','normalized','Position',[0.0350    0.37   0.0986    0.0100],'Style','slider','Tag','det__offset_slider','Value',0,'userdata',[n, m],'callback','sans_instrument_model_callbacks(''det_offset_slider'')');
                    pannel_struct.pannel_editbox_handle = uicontrol('units','normalized','Position',[0.1379    0.36    0.0200    0.0200],'Style','edit','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'userdata',[n,m],'callback','sans_instrument_model_callbacks(''det_offset_edit'')');
                    end
                end

                %Put the modified pannel structur back into the instrument component
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct);
            end

            %Build Detector Position Slider for Each Detector
            inst_component(n).gui_handle_slider = uicontrol('units','normalized','Position',[ 0.2    0.4-(0.01*(m-1))    0.6    0.01],'Style','slider','Value',1,'userdata',n,'callback','sans_instrument_model_callbacks(''det_slider'')');
            inst_component(n).gui_handle_editbox = uicontrol('units','normalized','Position',[ 0.175   0.4-(0.01*(m-1))    0.02    0.018],'Style','edit','userdata',n,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'callback','sans_instrument_model_callbacks(''det_edit'')');
        end
    end
end

%Build Collimation Selector
uicontrol('units','normalized','Position',[0.5    0.7    0.09    0.0200],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','Collimation Length (m)','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
d33_handles.col_length_popup = uicontrol('units','normalized','Position',[0.6    0.7    0.0350    0.0200],'Style','popupmenu','string',collimation_string,'value',1,'userdata',' ','callback','sans_instrument_model_callbacks(''col_length_popup'')');

%Build Wavelength Selectors, TOF & Edit Boxes
d33_handles.wavelength_mono_tof = uicontrol('units','normalized','Position',[0.005    0.975    0.035    0.018],'Style','popupmenu','string',inst_config.wav_modes,'value',1,'callback','sans_instrument_model_callbacks(''mono_tof'')');

for n = 1:length(inst_config.wav_modes)
    if strfind(inst_config.wav_modes{n},'Mono');
        %Mono Wavelength edit boxs
        d33_handles.wavelength_text1 = uicontrol('units','normalized','Position',[0.05    0.975   0.02    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','l','fontname','symbol','fontsize',inst_model_params.fontsize);
        d33_handles.wavelength_edit = uicontrol('units','normalized','Position',[0.05    0.9522    0.0200    0.018],'Style','edit','string',inst_config.mono_wav,'callback','sans_instrument_model_callbacks(''selector_wavelength'')');
        d33_handles.wavelength_text2 = uicontrol('units','normalized','Position',[0.072    0.975   0.02    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','Dl%','fontname','symbol','fontsize',inst_model_params.fontsize);
        d33_handles.wavelength_res_edit = uicontrol('units','normalized','Position',[0.072    0.9522    0.0200    0.018],'Style','edit','string',inst_config.mono_dwav,'callback','sans_instrument_model_callbacks(''selector_wavelength_res'')');
    end

    if strfind(inst_config.wav_modes{n},'TOF');
        %TOF Wavelength edit boxes
        d33_handles.tof_text1 = uicontrol('units','normalized','Position',[0.05    0.975   0.02    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','Min','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
        d33_handles.tof_min_edit = uicontrol('units','normalized','Position',[0.05    0.9522    0.0200    0.018],'Style','edit','string',inst_config.tof_wav_min,'callback','sans_instrument_model_callbacks(''tof_lambda_min'')');
        d33_handles.tof_text2 = uicontrol('units','normalized','Position',[0.072    0.975   0.02    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','Max','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
        d33_handles.tof_max_edit = uicontrol('units','normalized','Position',[0.072    0.9522    0.0200    0.018],'Style','edit','string',inst_config.tof_wav_max,'callback','sans_instrument_model_callbacks(''tof_lambda_max'')');

        res_string = {'1-4','1-3','1-2','2-4','2-3','3-4'};
        d33_handles.tof_text3 = uicontrol('units','normalized','Position',[0.1    0.975   0.04    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','Resolution','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
        d33_handles.tof_res_popup = uicontrol('units','normalized','Position',[0.1    0.9522    0.04    0.018],'Style','popupmenu','string',res_string,'value',inst_config.tof_resolution_setting,'callback','sans_instrument_model_callbacks(''tof_res'')');
        d33_handles.tof_spacing_text = uicontrol('units','normalized','Position',[0.14    0.95   0.03    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','x','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
        d33_handles.tof_resolution_rear_text = uicontrol('units','normalized','Position',[0.17    0.96   0.06    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','x','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
        d33_handles.tof_resolution_front_text = uicontrol('units','normalized','Position',[0.17    0.945   0.06    0.018],'ForegroundColor',inst_model_params.foreground_color,'BackgroundColor',inst_model_params.background_color,'Style','text','string','x','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);

        %Calculate TOF Parameters
        %For smallest to largest spacing (going backwards)
        temp = sort(abs(diff(chopper_positions_store)),'ascend');
        a = temp(1); b = temp(2); c = temp(3);

        inst_config.chopper_spacing_matrix = [a+b+c,b+c,c,a+b,b,a];
        inst_config.chopper_spacing_offset_matrix = [0,a,b+a,0,a,0];%To take into accout the extra flight path due to the positioning of the choppers and which pair is actually being used
    end
end


%***** Open Scattering Data Plot *****
d33_handles.scatter_data =axes;
set(d33_handles.scatter_data,'units','normalized','position',[0.78  0.058  0.2 0.25]);
set(d33_handles.scatter_data,'yscale','log','xscale','log');
xlabel(d33_handles.scatter_data,'|q| A^-1');
ylabel(d33_handles.scatter_data,'Intensity [AU]');
title(d33_handles.scatter_data,'Model Scattering Data');

%***** Open q range Plot *****
d33_handles.q_boundaries = axes;
set(d33_handles.q_boundaries,'units','normalized','position',[0.20  0.08  0.13  0.22]);
set(d33_handles.q_boundaries,'xscale','log');
xlabel(d33_handles.q_boundaries,'|q| A^-1');
ylabel(d33_handles.q_boundaries,'');
title(d33_handles.q_boundaries,'q-range')

%***** Open q-resolution Plot *****
d33_handles.inst_resolution = axes;
set(d33_handles.inst_resolution,'units','normalized','position',[0.04   0.08  0.13  0.22]);
xlabel(d33_handles.inst_resolution,'|q| A^-1');
ylabel(d33_handles.inst_resolution,'Dq/q, Dl/l, Dth/th');
title('q-resolution')


%**** Open Detector(s) image *****
%Detector image popup
for n = 1:length(inst_component);
    if findstr(inst_component(n).name,'Detector');
        for m = 1:inst_component(n).pannels
            pannel_struct = getfield(inst_component(n),['pannel' num2str(m)]);
            if findstr(pannel_struct.name,'Rear');
                pannel_struct.axis_2d_handle = axes;
                pannel_struct.pcolor_2d_handle = pcolor(rand(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1)));
                pannel_struct.pcolor_context_menu = uicontextmenu;
                pannel_struct.pcolor_context_menu_save_data = uimenu(pannel_struct.pcolor_context_menu,'label','Export Detector Data','callback','sans_instrument_model_callbacks(''export_2d_data'')');
                set(pannel_struct.pcolor_2d_handle,'uicontextmenu',pannel_struct.pcolor_context_menu);
                pannel_struct.pcolor_axes_2d_handle = get(pannel_struct.pcolor_2d_handle,'parent');
                shading interp; axis off;
                axis([0,pannel_struct.parameters.pixels(1),0,pannel_struct.parameters.pixels(2)]);
                set(pannel_struct.pcolor_axes_2d_handle,'units','normalized','position',[0.85, 0.46, 0.10, 0.18]);
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
            if findstr(pannel_struct.name,'Left');
                pannel_struct.axis_2d_handle = axes;
                pannel_struct.pcolor_2d_handle = pcolor(rand(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1)));
                pannel_struct.pcolor_axes_2d_handle = get(pannel_struct.pcolor_2d_handle,'parent');
                shading interp; axis off;
                axis([0,pannel_struct.parameters.pixels(1),0,pannel_struct.parameters.pixels(2)]);
                set(pannel_struct.pcolor_axes_2d_handle,'units','normalized','position',[0.823, 0.46, 0.025, 0.18]);
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
            if findstr(pannel_struct.name,'Right');
                pannel_struct.axis_2d_handle = axes;
                pannel_struct.pcolor_2d_handle = pcolor(rand(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1)));
                pannel_struct.pcolor_axes_2d_handle = get(pannel_struct.pcolor_2d_handle,'parent');
                shading interp; axis off;
                axis([0,pannel_struct.parameters.pixels(1),0,pannel_struct.parameters.pixels(2)]);
                set(pannel_struct.pcolor_axes_2d_handle,'units','normalized','position',[0.952, 0.46, 0.025, 0.18]);
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
            if findstr(pannel_struct.name,'Top');
                pannel_struct.axis_2d_handle = axes;
                pannel_struct.pcolor_2d_handle = pcolor(rand(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1)));
                pannel_struct.pcolor_axes_2d_handle = get(pannel_struct.pcolor_2d_handle,'parent');
                shading interp; axis off;
                axis([0,pannel_struct.parameters.pixels(1),0,pannel_struct.parameters.pixels(2)]);
                set(pannel_struct.pcolor_axes_2d_handle,'units','normalized','position',[0.85, 0.642, 0.10, 0.045]);
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
            if findstr(pannel_struct.name,'Bottom');
                pannel_struct.axis_2d_handle = axes;
                pannel_struct.pcolor_2d_handle = pcolor(rand(pannel_struct.parameters.pixels(2),pannel_struct.parameters.pixels(1)));
                pannel_struct.pcolor_axes_2d_handle = get(pannel_struct.pcolor_2d_handle,'parent');
                shading interp; axis off;
                axis([0,pannel_struct.parameters.pixels(1),0,pannel_struct.parameters.pixels(2)]);
                set(pannel_struct.pcolor_axes_2d_handle,'units','normalized','position',[0.85, 0.413, 0.10, 0.045]);
                inst_component(n) = setfield(inst_component(n),['pannel' num2str(m)], pannel_struct); %Set the modified pannel struct back to the inst_component structure
            end
        end
    end
end


%Build 2D image selector
det_image_string = {'Mod_q' 'q_x' 'q_y' 'q_Angle' 'Solid_Angle' 'Detector_Image' 'Direct_Beam'};
value = find(strcmp(det_image_string,inst_model_params.det_image));
if isempty(value); value = 1; inst_model_params.det_image = 'Mod_q'; end
d33_handles.detector_image_popup = uicontrol('units','normalized','Position',[0.8957    0.3933    0.1000    0.018],'Style','popupmenu','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string',det_image_string,'value',value,'callback','sans_instrument_model_callbacks(''det_image_popup'')');

%Wavelength selector to display
d33_handles.detector_image_tof_wav = uicontrol('units','normalized','Position',[0.8957    0.3533    0.1000    0.018],'Style','popupmenu','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string',' ','value',1,'callback','sans_instrument_model_callbacks(''det_image_tof_wav'')');

%Log detector image checkbox
d33_handles.log_detector_image_check = uicontrol('units','normalized','Position',[0.86    0.3933    0.03    0.018],'Style','checkbox','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string','Log:','value',inst_model_params.det_image_log_check,'callback','sans_instrument_model_callbacks(''det_image_log_check'')');

%Hold Graphs CheckBox
d33_handles.hold_image_check = uicontrol('units','normalized','Position',[0.88    0.01    0.04    0.018],'Style','checkbox','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string','Hold:','value',inst_model_params.hold_images_check,'callback','sans_instrument_model_callbacks(''hold_images_check'')');
if inst_model_params.hold_images_check ==1; enable = 'on';
else enable = 'off'; end

%Plot Stagger checkBox
d33_handles.hold_image_stagger_check = uicontrol('units','normalized','Position',[0.93    0.01    0.05    0.018],'Style','checkbox','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string','Stagger:','value',inst_model_params.hold_stagger_plots,'enable',enable,'callback','sans_instrument_model_callbacks(''hold_images_stagger'')');


%Build Scattering Model List
fns_string = [];
for n = 1:length(sample_config.model)
    fns_string = [fns_string {sample_config.model(n).name}];
end
uicontrol('units','normalized','Position',[0.33   0.33   0.06    0.018],'ForegroundColor',inst_model_params.foreground_color,'HorizontalAlignment','right','BackgroundColor',inst_model_params.background_color,'Style','text','string','Scattering Model:','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
d33_handles.scattering_model = uicontrol('units','normalized','Position',[0.4   0.33    0.05   0.018],'Style','popupmenu','string',fns_string,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'value',sample_config.model_number,'callback','sans_instrument_model_callbacks(''change_scattering_model'')');
sans_instrument_model_callbacks('build_scattering_model');


%Build Background Model List
fns_string = [];
for n = 1:length(background_config.model)
    fns_string = [fns_string {background_config.model(n).name}];
end
uicontrol('units','normalized','Position',[0.46   0.33   0.065    0.018],'ForegroundColor',inst_model_params.foreground_color,'HorizontalAlignment','right','BackgroundColor',inst_model_params.background_color,'Style','text','string','Background Model:','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
d33_handles.background_model = uicontrol('units','normalized','Position',[0.535   0.33    0.05   0.018],'Style','popupmenu','string',fns_string,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'value',background_config.model_number,'callback','sans_instrument_model_callbacks(''change_background_model'')');
sans_instrument_model_callbacks('build_background_model');

%Build Cadmium Model List
fns_string = [];
for n = 1:length(cadmium_config.model)
    fns_string = [fns_string {cadmium_config.model(n).name}];
end
uicontrol('units','normalized','Position',[0.59   0.33   0.065    0.018],'ForegroundColor',inst_model_params.foreground_color,'HorizontalAlignment','right','BackgroundColor',inst_model_params.background_color,'Style','text','string','Blocked Model:','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
d33_handles.cadmium_model = uicontrol('units','normalized','Position',[0.665   0.33    0.05   0.018],'Style','popupmenu','string',fns_string,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'value',cadmium_config.model_number,'callback','sans_instrument_model_callbacks(''change_cadmium_model'')');
sans_instrument_model_callbacks('build_cadmium_model');

%Measurement Subtitle
uicontrol('units','normalized','Position',[0.33   0.03   0.06    0.018],'ForegroundColor',inst_model_params.foreground_color,'HorizontalAlignment','right','BackgroundColor',inst_model_params.background_color,'Style','text','string','Subtitle:','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize);
d33_handles.subtitle = uicontrol('units','normalized','Position',[0.4   0.03    0.05   0.018],'horizontalalignment','right','Style','edit','string',inst_model_params.subtitle,'fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'callback','sans_instrument_model_callbacks(''change_subtitle'')');



%Auto Calculate On/Off Button
d33_handles.auto_calculate_button = uicontrol('units','normalized','Position',[0.92    0.95    0.06    0.018],'Style','pushbutton','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'value',inst_model_params.det_image_log_check,'callback','sans_instrument_model_callbacks(''auto_calculate_button'')');
%Single Shot Calculate Button
d33_handles.single_shot_calculate_button = uicontrol('units','normalized','Position',[0.92    0.922    0.06    0.018],'Style','pushbutton','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string','Calculate','value',inst_model_params.det_image_log_check,'callback','sans_instrument_model_callbacks(''single_shot_calculate'')');
%Smearing Dropdown
d33_handles.smearing_text = uicontrol('units','normalized','Position',[0.895    0.87    0.08    0.018],'Style','text','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'ForegroundColor',inst_model_params.foreground_color,'string','M.C. Itterations (/pixel)');
smearing_string = {'1','2','5','10','25','50','100','250','500','1000'};
d33_handles.smearing_dropdown = uicontrol('units','normalized','Position',[0.975    0.87    0.025    0.018],'Style','popupmenu','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string',smearing_string,'value',inst_model_params.smearing_pos,'userdata',smearing_string,'callback','sans_instrument_model_callbacks(''smearing_itterations'')');
%Measurement Time Edit box
d33_handles.measurement_time_text = uicontrol('units','normalized','Position',[0.895    0.84    0.08    0.018],'Style','text','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'ForegroundColor',inst_model_params.foreground_color,'string','Measurement Time (s)');
d33_handles.measurement_time_edit = uicontrol('units','normalized','Position',[0.975    0.84    0.02    0.018],'Style','edit','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string',num2str(inst_model_params.measurement_time),'callback','sans_instrument_model_callbacks(''measurement_time'')');
%Sample thickness edit box
d33_handles.sample_thickness_text = uicontrol('units','normalized','Position',[0.895    0.81    0.08    0.018],'Style','text','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'ForegroundColor',inst_model_params.foreground_color,'string','Sample Thickness(cm)');
d33_handles.sample_thickness_edit = uicontrol('units','normalized','Position',[0.975    0.81    0.02    0.018],'Style','edit','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string',num2str(inst_model_params.sample_thickness),'callback','sans_instrument_model_callbacks(''sample_thickness'')');
%Sample area edit box
d33_handles.sample_area_text = uicontrol('units','normalized','Position',[0.895    0.78    0.08    0.018],'Style','text','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'ForegroundColor',inst_model_params.foreground_color,'string','Sample Area(cm^2)');
d33_handles.sample_area_edit = uicontrol('units','normalized','Position',[0.975    0.78    0.02    0.018],'Style','edit','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'string',num2str(inst_model_params.sample_area),'callback','sans_instrument_model_callbacks(''sample_area'')');
%Poissonian Noise
d33_handles.poissonian_text = uicontrol('units','normalized','Position',[0.895    0.75    0.08    0.018],'Style','text','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'ForegroundColor',inst_model_params.foreground_color,'string','Add Poissonian Noise');
d33_handles.poissonian_check = uicontrol('units','normalized','Position',[0.975    0.75    0.02    0.018],'Style','checkbox','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'value',inst_model_params.poissonian_noise_check,'callback','sans_instrument_model_callbacks(''poissonian_noise_check'')');
%Switch off divergence
d33_handles.divergence_text = uicontrol('units','normalized','Position',[0.895    0.72    0.08    0.018],'Style','text','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'ForegroundColor',inst_model_params.foreground_color,'string','Divergence OFF');
d33_handles.divergence_check = uicontrol('units','normalized','Position',[0.975    0.72    0.02    0.018],'Style','checkbox','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'value',inst_model_params.divergence_check,'callback','sans_instrument_model_callbacks(''divergence_check'')');
%Switch off delta_lambda
d33_handles.delta_lambda_text = uicontrol('units','normalized','Position',[0.895    0.69    0.08    0.018],'Style','text','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'ForegroundColor',inst_model_params.foreground_color,'string','Delta_Lambda OFF');
d33_handles.delta_lambda_check = uicontrol('units','normalized','Position',[0.975    0.69    0.02    0.018],'Style','checkbox','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'value',inst_model_params.delta_lambda_check,'callback','sans_instrument_model_callbacks(''delta_lambda_check'')');
%Square or Triangle Selector profile
d33_handles.square_tri_selector_text = uicontrol('units','normalized','Position',[0.895    0.66    0.08    0.018],'Style','text','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'ForegroundColor',inst_model_params.foreground_color,'string','Selector: Tri [] or Square [x]');
d33_handles.square_tri_selector_check = uicontrol('units','normalized','Position',[0.975    0.66    0.02    0.018],'Style','checkbox','fontname',inst_model_params.font,'fontsize',inst_model_params.fontsize,'BackgroundColor',inst_model_params.background_color,'value',inst_model_params.delta_lambda_check,'callback','sans_instrument_model_callbacks(''square_tri_selector_check'')');


%Thinking!
d33_handles.thinking = uicontrol('units','normalized','Position',[0.3    0.1   0.4    0.2],'ForegroundColor',[1,0,0],'BackgroundColor',inst_model_params.background_color,'Style','text','string','Thinking!','visible','off','fontname',inst_model_params.font,'fontsize',50);

%Numor!
d33_handles.numor = uicontrol('units','normalized','Position',[0.35    0.1   0.2    0.2],'ForegroundColor',[1,0,0],'BackgroundColor',inst_model_params.background_color,'Style','text','string','000000!','visible','off','fontname',inst_model_params.font,'fontsize',50);

%***** Refresh Model *****
sans_instrument_model_callbacks;
