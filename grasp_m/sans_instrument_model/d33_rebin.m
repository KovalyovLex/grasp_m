function binned_array = d33_rebin(array,bin_edges)
%array is a n x 3 array.  Data is re binned relative to the first column. Second column is value, Third column is error in value
%bin_edges is a list of the bin edges. There are bin_edges - 1 bins in total.

%NOTE:  20 March 2007.  This much simplified version of rebin is the raw,
%correct but slower version.  It replaces the version by Omar which
%included some tricks in splitting up the 'array' matrix in order to make
%the rebinning of large arrays much (>x10) faster, e.g. D16 data and now
%useful for multi-frame TOF data.  
%Problems came to light during Bob's analysis of small sectors over Bragg
%peaks.  When opening the sector further in any, overlapping points did not
%agree. This simple version of rebin is formally correct and does not show
%such errors.
%Probably will need to work on a new faster rebin routine using similar tricks
%to split the matricies into smaller pieces. 


number_bins = length(bin_edges);

%Pre-allocate memory for the final array
%Columns are Av_x, Av_Y, Av_Err_y, number points used
binned_array = [];
warning off
m = 1;
for n = 1:number_bins-1;
    temp = find((array(:,1) >= bin_edges(n)) &  (array(:,1) < bin_edges(n+1)));
    if not(isempty(temp)) %i.e. values falling between the bin_edges have been found
        number_elements = length(temp);
        binned_array(m,1) = sum(array(temp,1)) / number_elements; %x_position is the average of all x's gone into the bin
        %binned_array(m,1) = (bin_edges(n) + bin_edges(n+1))/2; %x_position is the centre of the bin
        binned_array(m,2) = sum(array(temp,2)) / number_elements;
        binned_array(m,3) = sqrt( sum(array(temp,3).^2)) / number_elements;
        binned_array(m,4) = number_elements;
        m = m+1;
    end
end
warning on


