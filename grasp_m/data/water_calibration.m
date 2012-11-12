function [foreimage,history] = water_calibration(foreimage,history)

global inst_params
global status_flags
global grasp_data

warning off

%***** Divide by Sample By Volume *****
if  status_flags.calibration.volume_normalize_check ==1;
    volume = status_flags.calibration.sample_area * foreimage.thickness;
    for det = 1:inst_params.detectors
        foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) / volume;
        foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) / volume;
    end
    foreimage.units = [foreimage.units '\\ cm3 '];
    history = [history, {['Data: Divided by Volume ' num2str(volume) ' cm3']}];
end

%***** Divide by pixel solid angle ******
if status_flags.calibration.solid_angle_check ==1;
    for det = 1:inst_params.detectors
        foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) ./ foreimage.(['qmatrix' num2str(det)])(:,:,10);
        foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) ./ foreimage.(['qmatrix' num2str(det)])(:,:,10);
    end
    foreimage.units = [foreimage.units '\\ \Delta\Omega '];
    history = [history, {['Solid Angle Correction:']}];
end

%***** Divide by water mean counts *****
if status_flags.calibration.scalar_check == 1;
    index = data_index(99);
    for det = 1:inst_params.detectors
        mean_intensity = grasp_data(index).(['mean_intensity' num2str(det)]){status_flags.calibration.det_eff_nmbr};
        mean_intensity_units = grasp_data(index).(['mean_intensity_units' num2str(det)]){status_flags.calibration.det_eff_nmbr};
        
        foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) ./ mean_intensity;
        foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) ./ mean_intensity;
    end
    foreimage.units = strrep(foreimage.units, mean_intensity_units, '');
    history = [history,{['Divide by calibration standard mean counts:' num2str(mean_intensity) ' ' mean_intensity_units]}];
end

%***** Multiply by water xsection *****
if status_flags.calibration.xsection_check == 1;
    index = data_index(99);
    for det = 1:inst_params.detectors
        xsection = grasp_data(index).calibration_xsection{status_flags.calibration.det_eff_nmbr};
        
        foreimage.(['data' num2str(det)]) = foreimage.(['data' num2str(det)]) .* xsection;
        foreimage.(['error' num2str(det)]) = foreimage.(['error' num2str(det)]) .* xsection;
    end
    foreimage.units = [foreimage.units 'Calibration Standard Units'];
    history = [history,{['Multipy by calibration standard X-section:' num2str(xsection) ]}];
end

    
%     foreimage.units = strrep(foreimage.units, empty_beam.units, '');
%     temp = findstr(foreimage.units,'\\ cm3');
%     if not(isempty(temp));
%         %Do something simple for the cm units
%         foreimage.units = strrep(foreimage.units, '\\ cm3', 'cm-1');
%     else
%         foreimage.units = ['cm2 ' foreimage.units];
%     end

warning on


