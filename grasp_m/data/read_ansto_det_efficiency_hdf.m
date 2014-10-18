function det_eff = read_ansto_det_efficiency_hdf(fname)

%Read ILL SANS Nexus Format Data (HDF)
warning on
fileinfo=hdf5info(fname);
entryName =  fileinfo.GroupHierarchy.Groups(1).Name; %Root folder in HDF fileed

%Read Efficiency Data


try
    det_eff = hdf5read(fname,strcat(entryName,'/div'));
catch
    det_eff = zeros(192,192);
    
end
