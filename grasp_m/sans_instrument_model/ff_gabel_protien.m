function P = ff_gabel_protien(q)

%Open a real IvsQ data file and interpolate to find q points;

fid = fopen('gabel_protien.dat');
iq_data = [];
if fid~=-1;
    while not(feof(fid))
        line = fgetl(fid);
        temp = str2num(line);
        if isnumeric(temp);
            iq_data = [iq_data; temp(1:2)];
        end
        
    end
end
fclose(fid);

P = interp1(iq_data(:,1),iq_data(:,2),q);
