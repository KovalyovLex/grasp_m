function display_params

global displayimage
global grasp_env
global inst_params
global status_flags

%Shortcut variable
vectors = inst_params.vectors;
inst = grasp_env.inst;

%Display Relavent Params
disp(' ');
disp(' ');


if sum(displayimage.params1) == 0
    disp('***** Params are empty *****');
else
    disp('***** Numor Parameter Summary *****');
    disp(['Loaded Numor(s) = ' displayimage.load_string{1} '  : Current = ' num2str(displayimage.params1(vectors.numor))]); %Numors
    if isfield(displayimage.info,'user'); disp(['User:  "' displayimage.info.user '"']); end
    disp(['Subtitle:  "' displayimage.subtitle '"']);
    disp(['Start: ' displayimage.info.start_time ' ' displayimage.info.start_date '  End: ' displayimage.info.end_time ' ' displayimage.info.end_date]);
    disp(' ')
    disp(['Col '  num2str(displayimage.params1(vectors.col)) ' (m)']);
    
    selector_str = [];
    if isfield(vectors,'sel_rpm'); selector_str = ['Selector RPM = ' num2str(displayimage.params1(vectors.sel_rpm))]; end
    
    disp(['Wav ' num2str(displayimage.params1(vectors.wav)) ' (Å), DeltaWav ' num2str(displayimage.params1(vectors.deltawav)*100) ' (%), ' selector_str]);
    disp(['Beam Stop:  BX  ' num2str(displayimage.params1(vectors.bx)) ',  BY  ' num2str(displayimage.params1(vectors.by))]);
    
    
    %attenuator
    if isfield(inst_params.vectors,'att_status')
        if displayimage.params1(vectors.att_status) == 0;
            status = 'OUT'; att_str = '1';
        elseif displayimage.params1(vectors.att_status) == 1;
            if displayimage.params1(vectors.att_type) >= 1 & displayimage.params1(vectors.att_type) <=3
                att_str =  num2str(displayimage.attenuation);
            else
                att_str = [ num2str(displayimage.attenuation) ' (Entrance Apperture)'];
            end
            status = 'IN';
        else
            status = 'UNKNOWN'; att_str = '';
        end
    else
        status = 'IN';
        att_str = num2str(displayimage.attenuation);
    end
    if isfield(vectors,'attr'); extra_str = ['Attr ' num2str(displayimage.params1(vectors.attr)) ' [mm]']; else extra_str = []; end
    disp(['Attenuator ' num2str(displayimage.params1(vectors.att_type)) ' ' status ' : Approx Attenuation = ' att_str '    ' extra_str]);
    disp(['Auto Attenuator correction is ' status_flags.normalization.auto_atten])
    
    if isfield(inst_params.vectors,'att2');
        if displayimage.params1(vectors.att2) >1;  status = 'In'; else status = 'Out'; end
        disp(['Attenuator2 (chopper) is ' status ', Attenuation = ' num2str(displayimage.params1(vectors.att2))]);
    end
    disp(' ');

    
    %Detectors
    for det = 1:inst_params.detectors
        params = displayimage.(['params' num2str(det)]);

        %DET:  Check if to use Det or DetCalc (m)
        det_dist = params(vectors.det); %Default, unless otherwise
        if strcmp(status_flags.q.det,'detcalc');
            if isfield(vectors,'detcalc')
                if not(isempty(vectors.detcalc));
                    det_dist = params(vectors.detcalc);
                end
            end
        end
        
        if strcmp(grasp_env.inst,'ILL_d33') %D33 specific
            if strcmp(grasp_env.inst_option,'D33_Model_Data')
                %D33 inst model params
                if isfield(vectors,'det'); det_str = ['  DET: ' num2str(params(vectors.det))]; else det_str = []; end
                if isfield(vectors,'detcalc'); det_calc_str = ['  DET_CALC: ' num2str(params(vectors.detcalc))]; else det_calc_str = []; end
                if isfield(vectors,'det_pannel'); det_pannel_str = ['  DET_PANNEL: ' num2str(params(vectors.det_pannel))]; else det_pannel_str = []; end
                if isfield(vectors,'ox'); det_pannel_ox_str = ['  OX (Horz) Opening: ' num2str(params(vectors.ox))]; else det_pannel_ox_str = []; end
                if isfield(vectors,'oy'); det_pannel_oy_str = ['  OY (Horz) Opening: ' num2str(params(vectors.oy))]; else det_pannel_oy_str = []; end
                disp(['Detector: ' num2str(det) ' Parameters:']);
                disp([det_str det_calc_str det_pannel_str det_pannel_ox_str det_pannel_oy_str]);
                
            elseif strcmp(grasp_env.inst_option,'D33_Instrument_Comissioning')
                if isfield(vectors,'det'); det_str = ['  DET: ' num2str(params(vectors.det))]; else det_str = []; end
                if isfield(vectors,'detcalc'); det_calc_str = ['  DET_CALC: ' num2str(params(vectors.detcalc))]; else det_calc_str = []; end
                disp(['Detector: ' num2str(det) ' : ' det_str det_calc_str]);
                
            elseif strcmp(grasp_env.inst_option,'D33')
                
                if det==1; %Only do it once and do all at one time.
                    if isfield(vectors,'det1'); det1_str = [num2str(params(vectors.det1)) ' [m]']; det1_dist = params(vectors.det1); else det1_str = []; end
                    if isfield(vectors,'detcalc1'); det1_calc_str = ['  DET_CALC1: ' num2str(params(vectors.detcalc1)) ' [m]']; det1_dist = params(vectors.detcalc1); else det1_calc_str = []; end
                    disp(['Detector1 : ' det1_str det1_calc_str]);
                    %Panel properties
                    panel_str = [];
                    if isfield(vectors,'oxl'); panel_str = [panel_str 'OXL: ' num2str(params(vectors.oxl)) ' [mm]  ']; end
                    if isfield(vectors,'oxr'); panel_str = [panel_str 'OXR: ' num2str(params(vectors.oxr)) ' [mm]  ']; end
                    if isfield(vectors,'oyt'); panel_str = [panel_str 'OYT: ' num2str(params(vectors.oyt)) ' [mm]  ']; end
                    if isfield(vectors,'oyb'); panel_str = [panel_str 'OYB: ' num2str(params(vectors.oyb)) ' [mm]  ']; end
                    disp(['Panel Openings: ' panel_str]);
                    if isfield(vectors,'det1_panel_offset'); panel_offset = params(vectors.det1_panel_offset); else panel_offset = 0; end
                    disp(['Panel Offset : ' num2str(panel_offset)]);
                    disp(['Panel Distance: OYT : ' num2str(det1_dist) ' [m]  OYB : ' num2str(det1_dist) ' [m]  OXL : ' num2str(det1_dist+panel_offset) ' [m]  OXR : ' num2str(det1_dist+panel_offset) ' [m]  ']);
                        
                        
                    
                    
                    if isfield(vectors,'det2'); det2_str = [num2str(params(vectors.det2)) ' [m]']; else det_str = []; end
                    if isfield(vectors,'detcalc2'); det2_calc_str = ['  DET_CALC2: ' num2str(params(vectors.detcalc2))]; else det2_calc_str = []; end
                    disp(['Detector2 : ' det2_str det2_calc_str]);
                    
                end
            end
            
        else %All other instruments
            
            if isfield(vectors,'det'); det_str = ['  DET: ' num2str(params(vectors.det))]; else det_str = []; end
            if isfield(vectors,'detcalc'); det_calc_str = ['  DET_CALC: ' num2str(params(vectors.detcalc))]; else det_calc_str = []; end
        
            disp(['Detector: ' num2str(det) ' Parameters:']);
            disp([det_str det_calc_str]);
            
        end
        
        
        %D33 real params
        if isfield(vectors,'oxl'); det_pannel_oxl_str = ['  OxL Opening: ' num2str(params(vectors.oxl))]; else det_pannel_oxl_str = []; end
        if isfield(vectors,'oxr'); det_pannel_oxr_str = ['  OxR Opening: ' num2str(params(vectors.oxr))]; else det_pannel_oxr_str = []; end
        if isfield(vectors,'oyt'); det_pannel_oyt_str = ['  OyT Opening: ' num2str(params(vectors.oyt))]; else det_pannel_oyt_str = []; end
        if isfield(vectors,'oyb'); det_pannel_oyb_str = ['  OyB Opening: ' num2str(params(vectors.oyb))]; else det_pannel_oyb_str = []; end
        
        
        if isfield(vectors,'dtr'); dtr_str = ['  DTR: ' num2str(params(vectors.dtr))]; else dtr_str = []; end
        if isfield(vectors,'dan'); dan_str = ['  DAN: ' num2str(params(vectors.dan))]; else dan_str = []; end
        

        
    end
    disp(' ')
    
    
    %Collimation Motors
    if isfield(vectors,'col1') && isfield(vectors,'dia1'); col_str = ['Dia1 ' num2str(params(vectors.dia1)) ' Col1 ' num2str(params(vectors.col1)) char (10)]; else col_str = [];end
    if isfield(vectors,'col2') && isfield(vectors,'dia2'); col_str = [col_str 'Dia2 ' num2str(params(vectors.dia2)) ' Col2 ' num2str(params(vectors.col2)) char(10)]; end
    if isfield(vectors,'col3') && isfield(vectors,'dia3'); col_str = [col_str 'Dia3 ' num2str(params(vectors.dia3)) ' Col3 ' num2str(params(vectors.col3)) char(10)]; end
    if isfield(vectors,'col4') && isfield(vectors,'dia4'); col_str = [col_str 'Dia4 ' num2str(params(vectors.dia4)) ' Col4 ' num2str(params(vectors.col4)) char(10)]; end
    if isfield(vectors,'dia5'); col_str = [col_str 'Dia5 ' num2str(params(vectors.dia5))]; else col_str = [];end
    disp(col_str); disp(' ');
        
    %Choppers
    if isfield(vectors,'chopper1_speed') && isfield(vectors,'chopper1_phase'); chop_str = ['Chopper #1 : ' num2str(params(vectors.chopper1_speed)) ' [RPM]  '  num2str(params(vectors.chopper1_phase)) ' [degs]' char(10)]; else chop_str =[]; end
    if isfield(vectors,'chopper2_speed') && isfield(vectors,'chopper2_phase'); chop_str = [chop_str 'Chopper #2 : ' num2str(params(vectors.chopper2_speed)) ' [RPM]  '  num2str(params(vectors.chopper2_phase)) ' [degs]' char(10)]; end
    if isfield(vectors,'chopper3_speed') && isfield(vectors,'chopper3_phase'); chop_str = [chop_str 'Chopper #3 : ' num2str(params(vectors.chopper3_speed)) ' [RPM]  '  num2str(params(vectors.chopper3_phase)) ' [degs]' char(10)]; end
    if isfield(vectors,'chopper4_speed') && isfield(vectors,'chopper4_phase'); chop_str = [chop_str 'Chopper #4 : ' num2str(params(vectors.chopper4_speed)) ' [RPM]  '  num2str(params(vectors.chopper4_phase)) ' [degs]' char(10)]; end
    disp(chop_str); disp(' ');
            

    
    
    %Sample Motors
    motors_str = [];
    if isfield(vectors,'san'); motors_str = [motors_str 'SAN: ' num2str(displayimage.params1(vectors.san)) '   '];end
    if isfield(vectors,'phi'); motors_str = [motors_str 'PHI: ' num2str(displayimage.params1(vectors.phi)) '   '];end
    if isfield(vectors,'trs'); motors_str = [motors_str 'TRS: ' num2str(displayimage.params1(vectors.trs)) '   ']; end
    if isfield(vectors,'sdi'); motors_str = [motors_str 'SDI: ' num2str(displayimage.params1(vectors.sdi)) '   ']; end
    if isfield(vectors,'sdi2'); motors_str = [motors_str 'SDI2: ' num2str(displayimage.params1(vectors.sdi2)) '   ']; end
    if isfield(vectors,'sht'); motors_str = [motors_str 'SHT: ' num2str(displayimage.params1(vectors.sht)) '    ']; end
    if isfield(vectors,'omega'); motors_str = [motors_str 'Omega: ' num2str(displayimage.params1(vectors.omega)) '    ']; end
    disp(motors_str);

    changer_str = [];
    if isfield(vectors,'chpos'); changer_str = [changer_str 'Changer Pos: ' num2str(displayimage.params1(vectors.chpos)) '   ']; end
    if isfield(vectors,'str'); changer_str = [changer_str 'STR: ' num2str(displayimage.params1(vectors.str)) '   ']; end
    disp(changer_str);

    
    disp(' ')
    disp(['T_set = ' num2str(displayimage.params1(vectors.tset)) '; T_reg = ' num2str(displayimage.params1(vectors.treg)) '; T_sample = ' num2str(displayimage.params1(vectors.temp))]);
    
    if isfield(vectors,'field'); disp(['Magnetic Field = ' num2str(displayimage.params1(vectors.field))]); end
    
    %Power Supplies
    if isfield(vectors,'ps1_i'); ps1_i_str = num2str(displayimage.params1(vectors.ps1_i)); else ps1_i_str = 'N/A'; end
    if isfield(vectors,'ps1_v'); ps1_v_str = num2str(displayimage.params1(vectors.ps1_v)); else ps1_v_str = 'N/A'; end
    if isfield(vectors,'ps2_i'); ps2_i_str = num2str(displayimage.params1(vectors.ps2_i)); else ps2_i_str = 'N/A'; end
    if isfield(vectors,'ps2_v'); ps2_v_str = num2str(displayimage.params1(vectors.ps2_v)); else ps2_v_str = 'N/A'; end
    if isfield(vectors,'ps3_i'); ps3_i_str = num2str(displayimage.params1(vectors.ps3_i)); else ps3_i_str = 'N/A'; end
    if isfield(vectors,'ps3_v'); ps3_v_str = num2str(displayimage.params1(vectors.ps3_v)); else ps3_v_str = 'N/A'; end
    disp(' ');
    disp(['Power Supplies :  PS1 ' num2str(ps1_i_str) ' [A]  ' num2str(ps1_v_str) ' [V] :  PS2 ' num2str(ps2_i_str) ' [A]  ' num2str(ps2_v_str) ' [V] :  PS3 ' num2str(ps3_i_str) ' [A]  ' num2str(ps3_v_str) ' [V]  ']);
        
    
    
    
    disp(' ');
    %disp(['Total Det Counts (params)  ' num2str(displayimage.params(vectors.counts)) ' Over ' num2str(displayimage.params(vectors.time)/10) 'secs (~' num2str(round(displayimage.params(vectors.counts)/(displayimage.params(vectors.time)/10))) ' cps)']);
    if isfield(inst_params.vectors,'aq_time');
        aq_time = displayimage.params1(vectors.aq_time);
    else
        aq_time = displayimage.params1(vectors.time);
    end
    disp(['Acquisition Time = ' num2str(aq_time) ' (s) ']);
    for det = 1:inst_params.detectors
        disp(['Total Det Counts [Det:' num2str(det) '] ' num2str(displayimage.(['params' num2str(det)])(vectors.array_counts)) ' Over ' num2str(aq_time) 'secs (~' num2str(round(displayimage.(['params' num2str(det)])(vectors.array_counts)/(aq_time))) ' cps)']);
    end
    text_string = [];
    if isfield(inst_params.vectors,'slice_time');
        text_string = [text_string 'Slice Time = ' num2str(displayimage.params1(inst_params.vectors.slice_time)) ' (s)'];
    end
    if isfield(inst_params.vectors,'pickups');
        text_string = [text_string ' x  #Pickups = ' num2str(displayimage.params1(inst_params.vectors.pickups))];
    end
    if isfield(inst_params.vectors,'time');
        text_string = [text_string '   Exposure time = ' num2str(num2str(displayimage.params1(vectors.time))) ' (s)'];
    end
    disp(text_string);

    %disp(['Total Det Counts (array) / Monitor (x1000) ' num2str((displayimage.params(vectors.array_counts))*1000/displayimage.params(vectors.monitor))]);
    disp(['Total Monitor1 Counts  ' num2str(displayimage.params1(vectors.monitor)) ' Over ' num2str(displayimage.params1(vectors.time)) 'secs (~' num2str(round(displayimage.params1(vectors.monitor)/(displayimage.params1(vectors.time)))) ' cps)']);
    if isfield(vectors,'monitor2') & displayimage.params1(vectors.monitor2) ~= 0;
        disp(['Total Monitor2 Counts  ' num2str(displayimage.params1(vectors.monitor2)) ' Over ' num2str(displayimage.params1(vectors.time)) 'secs (~' num2str(round(displayimage.params1(vectors.monitor2)/(displayimage.params1(vectors.time)))) ' cps)']);
    end
    if isfield(vectors,'reactor_power')
        disp(['Reactor Power = ' num2str(displayimage.params1(vectors.reactor_power)) ' MW']);
    end
    
    
end
disp(' ');
disp(' ');
disp(' ');

warning on
