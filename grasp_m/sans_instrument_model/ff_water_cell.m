function P = ff_water_cell(q)

%Open a real IvsQ data file and interpolate to find q points;


%Empty Cell Part
fid = fopen('empty_cell.dat');
iq_data = [];
if fid~=-1;
    while not(feof(fid))
        line = fgetl(fid);
        temp = str2num(line);
        if isnumeric(temp);
            iq_data = [iq_data; temp];
        end
        
    end
    fclose(fid);
end
P = interp1(iq_data(:,1),iq_data(:,2),q);

%Water Part
P = P + ones(size(q));
