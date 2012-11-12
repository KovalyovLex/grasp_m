function binned_array = rebin(array,bin_edges)
%array is a n x m array.  Data is re binned relative to the first column.
%where m >4.
%Second column is value
%Third column is error in value
%Forth, fifth, sixth ..etc.  colum is another parameter rebinned averaged in the same way as the second column - used her for the delta_q resolution
%delta_q_lambda, delta_q_theta etc.
%The last column is the number of elements that went into each bin
%bin_edges is a list of the bin edges. There are bin_edges - 1 bins in total.

temp=size(array);
if temp(2)<4;
    array(:,4) = zeros(temp(1),1);
end

number_bins = length(bin_edges);

%Columns are Av_x, Av_Y, Av_Err_y, Av_col4, number points used
binned_array = [];
warning off
m = 1;
[temp1,temp2] = size(array);
bin_resolution = diff(bin_edges);
for n = 1:number_bins-1;
    temp = find((array(:,1) >= bin_edges(n)) &  (array(:,1) < bin_edges(n+1)));
    if not(isempty(temp)) %i.e. values falling between the bin_edges have been found
        number_elements = length(temp);
        binned_array(m,1) = sum(array(temp,1)) / number_elements; %x_position is the average of all x's gone into the bin
        
        binned_array(m,2) = sum(array(temp,2)) / number_elements;
        
        %Weighted average on statistical quality
        %binned_array(m,2) = sum(array(temp,2).*(array(temp,3)./array(temp,2))) / sum((array(temp,3)./array(temp,2)));
        
        binned_array(m,3) = sqrt( sum(array(temp,3).^2)) / number_elements;
        
        for column = 4:temp2
                binned_array(m,column) = sum(array(temp,column)) / number_elements;
        end
        binned_array(m,temp2+1) = bin_resolution(n); %Bin resolution FWHM TOPHAT
        binned_array(m,temp2+2) = number_elements; %Nu. elements used in averaging
        m = m+1;
    end
end
warning on


