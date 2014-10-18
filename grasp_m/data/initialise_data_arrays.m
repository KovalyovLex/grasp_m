function initialise_data_arrays(specific_wks_type, specific_wks_nmbr)

%Initialises all the raw and screen data storage arrays

global grasp_data
global inst_params
global grasp_env

%***** Worksheet types *****
% 1 = sample scattering
% 2 = sample background
% 3 = sample cadmium
% 4 = sample transmission
% 5 = sample empty transmission
% 6 = sample empty beam transmission
% 7 = sample mask
% 8 = I0 Beam Intensity
% 99 = detector efficiency map
% 10 = FR Trans Check
% 11,12,13,14 = PA Sample Scattering ++ -+ -- +-
% 15, 16, 17, 18 = PA Background Scattering
% 19 2D fit result
% 20 2D fit result residual


%***** Worksheet Descriptions *****
worksheet = {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20};
wks_name = {'Sample' 'Empty Cell' 'Blocked Beam' 'Trans Sample' 'Trans Empty Cell' 'Trans Empty Beam' 'I0 Beam Intensity' 'Masks' 'Detector Eff' 'FR Trans Check','PA ++ Sample','PA -+ Sample','PA -- Sample','PA +- Sample','PA ++ Background','PA -+ Background','PA -- Background','PA +- Background', '2D Fit result', '2D Fit Residual'};
wks_type = {1 2 3 4 5 6 8 7 99 10 11 12 13 14 15 16 17 18 19 20};
wks_visibility = {1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1};
n = grasp_env.worksheet.worksheets;
wks_nmbr = {n n n n n n n n 1 1 n n n n n n n n n n};
wks_dpth = {1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1};
n = grasp_env.worksheet.depth_max;
wks_dpthmax = {n n n n n n n n 1 n n n n n n n n n 1 1};
wks_sum_allowed = {1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 0 0}; %determines whether SUM is allowed and whether depth can exist
wks_allowed = {[1,2,3] [1,2,3] [1,2,3] [4,5,6] [4,5,6] [6] [8] [7] [99] [10] [11,15] [12,16] [13,17] [14,18] [15] [16] [17] [18] [19] [20]};
wks_last_disp = {[2, 3] [1, 3] [0, 0] [5, 0] [6, 0] [0,0] [0, 0] [0, 0] [0, 0] [0, 0] [15,0] [16,0] [17,0] [18,0] [0,0] [0,0] [0,0] [0,0] [0,0] [0,0]}; %Zero means do not display selector at all

%Test whether to do complete initialisation or re-initialise single worksheets
if nargin <1; %Do a complete (re)initialisation of all worksheets
    disp(['Initialising Data Arrays']);
    grasp_data = [];
    wks_start = 1; wks_end = length(worksheet);
else %Do a partial initialisation of single worksheet number
    wks_start = data_index(specific_wks_type); wks_end = wks_start;
end


%***** Build Worksheets *****
for wks = wks_start:wks_end; %Worksheets loop, fore, back, cad, etc.
    grasp_data(wks).number = wks;
    grasp_data(wks).name = wks_name{wks};
    grasp_data(wks).type = wks_type{wks};
    grasp_data(wks).allowed_types = wks_allowed{wks};
    grasp_data(wks).sum_allow = wks_sum_allowed{wks};
    grasp_data(wks).last_displayed = wks_last_disp{wks};
    grasp_data(wks).visible = wks_visibility{wks};

    dpth = wks_dpth{wks};  %Number of Depths reserved by default (usually 1).  These can be expanded during operation
    dpth_max = wks_dpthmax{wks};
    
    if nargin<1; %Do a complete (re)initalisation of all worksheets
        wks_nmbr_start = 1; wks_nmbr_end = wks_nmbr{wks};
        grasp_data(wks).nmbr = wks_nmbr{wks};

    else %Do a partial initialisation fo a single worksheet number
        wks_nmbr_start = specific_wks_nmbr; wks_nmbr_end = specific_wks_nmbr;
        %Check if adding worksheet
        if specific_wks_nmbr > wks_nmbr{wks}
            grasp_data(wks).nmbr = specific_wks_nmbr;
        end
    end
    
    
    %Loop though number of Worksheet_Numbers
    for n = wks_nmbr_start:wks_nmbr_end
        
        grasp_data(wks).dpth{n} = dpth;
        grasp_data(wks).dpth_max{n} = dpth_max;
        grasp_data(wks).thickness{n} = ones(dpth,1)*0.1; %cm
        grasp_data(wks).trans{n} = [ones(dpth,1), zeros(dpth,1)]; %Trans, Err_trans
        grasp_data(wks).data_type{n} = 'single frame'; 

        for m = 1:dpth
        grasp_data(wks).info{n}.start_date{m} = ['00-Jan-2000']; %Start Date
        grasp_data(wks).info{n}.start_time{m} = ['00:00:00']; %Start Time
        grasp_data(wks).info{n}.end_date{m} = ['00-Jan-2000']; %End Date
        grasp_data(wks).info{n}.end_time{m} = ['00:00:00']; %End Time
        grasp_data(wks).info{n}.user{m} = [' ']; %User Name
        end
        

        
        %Loop though number of detectors
        dets = inst_params.detectors;
        for det = 1:dets
            %Get detector parameters
            det_params = inst_params.(['detector' num2str(det)]);
            
            if wks_type{wks} == 99; %Detector efficiency
                if strcmp(grasp_env.inst,'ANSTO_quokka');
                    eff_fname = ['detector_efficiency_det' num2str(det) '_' grasp_env.inst grasp_env.inst_option '.hdf'];
                    disp(['Looking for Detector Efficiency Map: ' eff_fname]);
                    fid = fopen([eff_fname]);
                    if fid ~=-1
                        fclose(fid);
                        disp(['Loading Default Detector Efficiency Map for Detector: ' num2str(det) ' : ' eff_fname])
                        data = read_ansto_det_efficiency_hdf(eff_fname);
                        error = zeros(size(data));
                    else
                        disp(['WARNING:  No Default Detector Efficiency Map Found for Detector: ' num2str(det) ' - Use Water to define']);
                        data = ones(det_params.pixels(2), det_params.pixels(1));
                        error = zeros(det_params.pixels(2), det_params.pixels(1));
                    end
                else
                
                %Load Default Detector Efficiency if exists, variable is called eff_data
                %Check if efficiency file exists
                eff_fname = ['detector_efficiency_det' num2str(det) '_' grasp_env.inst grasp_env.inst_option '.mat'];
                fid = fopen([eff_fname]);
                disp(['Looking for Detector Efficiency Map: ' eff_fname]);
                if fid ~= -1; %File exists
                    fclose(fid);
                    disp(['Loading Default Detector Efficiency Map for Detector: ' num2str(det) ' : ' eff_fname])
                    eff_data = load([eff_fname]);
                    data = eff_data.eff_data;
                    error = eff_data.eff_err_data;
                else
                    disp(['WARNING:  No Default Detector Efficiency Map Found for Detector: ' num2str(det) ' - Use Water to define']);
                    data = ones(det_params.pixels(2), det_params.pixels(1));
                    error = zeros(det_params.pixels(2), det_params.pixels(1));
                end
                grasp_data(wks).(['mean_intensity' num2str(det)]){n} = 1;
                grasp_data(wks).(['mean_intensity_units' num2str(det)]){n} = 'N/A';
                grasp_data(wks).calibration_xsection{n} = 1;
                end
                
            elseif wks_type{wks} == 7; %Masks
                data = ones(det_params.pixels(2), det_params.pixels(1),dpth);
                error = zeros(det_params.pixels(2), det_params.pixels(1),dpth);
                
            else %Normal Scattering or Transmission Data
                data = zeros(det_params.pixels(2), det_params.pixels(1),dpth);
                error = zeros(det_params.pixels(2), det_params.pixels(1),dpth);
            end
            %Allocate a beam centre and detector translation to every type of worksheet
            cm.cm_pixels(1:dpth,1) = det_params.nominal_beam_centre(1);
            cm.cm_pixels(1:dpth,2) = det_params.nominal_beam_centre(2);
            cm.cm_translation(1:dpth,1) = det_params.nominal_det_translation(1); %This is the translation in mm to tell where the pannel is relative to the direct beam measurement
            cm.cm_translation(1:dpth,2) = det_params.nominal_det_translation(2);
            
            %Allocate data and error values to the grasp_data structure
            grasp_data(wks).(['params' num2str(det)]){n} = zeros(128,dpth);
            grasp_data(wks).(['cm' num2str(det)]){n} = cm;
            grasp_data(wks).(['data' num2str(det)]){n} = data;
            grasp_data(wks).(['error' num2str(det)]){n} = error;
        end
        
        
        if wks_type{wks} == 99; %Detector efficiency
            grasp_data(wks).subtitle{n}{1} = ['Detector Efficiency Map'];
            grasp_data(wks).load_string{n}{1} = ['Detector Efficiency Map'];
            
        elseif wks_type{wks} == 7; %Masks
            grasp_data(wks).subtitle{n}{1} = ['Mask'];
            grasp_data(wks).load_string{n}{1} = ['Mask'];
            
        else %Normal Scattering or Transmission Data
            grasp_data(wks).load_string{n}{1} = ['<Numors>'];
            grasp_data(wks).subtitle{n}{1} = ['Empty Space'];
        end
        
    end
end

