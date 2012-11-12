function P = ff_ribosome(q)

%Open a real IvsQ data file and interpolate to find q points;

fid = fopen('ribosome.dat');
iq_data = [];
if fid~=-1;
    while not(feof(fid))
        line = fgetl(fid);
        temp = str2num(line);
        if isnumeric(temp);
            iq_data = [iq_data; temp];
        end
        
    end
end
fclose(fid);

P = interp1(iq_data(:,1),iq_data(:,2),q);
