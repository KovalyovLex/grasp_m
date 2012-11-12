function binned_array = rebin(array,bin_edges,weighting)
%array is a n x m array.  Data is re binned relative to the first column.
%where m >4.
%Second column is value
%Third column is error in value
%Forth, fifth, sixth ..etc.  colum is another parameter rebinned averaged in the same way as the second column - used her for the delta_q resolution
%delta_q_lambda, delta_q_theta etc.
%The last column is the number of elements that went into each bin
%bin_edges is a list of the bin edges. There are bin_edges - 1 bins in total.
%weighting is an optional parameter (cell array) and describes either a straightforward
%average or a weighted average for columns 4 onwards {'none', 'weight2', 'ratio32'},
%where 'weight2' means weighted by the value in column2;
%where 'ratio32' means weighted by the ratio of column3/column2'

nargin

if nargin <3;
    n_cols = size(array);
    n_cols = n_cols(2);
    for n = 1:n_cols-3;
        weighting{n} = 'none';
    end
end

temp=size(array);
if temp(2)<4;
    array(:,4) = zeros(temp(1),1);
end

number_bins = length(bin_edges);

weighting

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
            if findstr(weighting{column-3},'weight');
                %disp('weight')
                col_ref = str2num(strtok(weighting{column-3},'weight'));
                
                binned_array(m,column) = sum(array(temp,column).*array(temp,col_ref)) / sum(array(temp,col_ref));
            elseif findstr(weighting{column-3},'ratio');
                %disp('ratio')
                cols = strtok(weighting{column-3},'ratio');
                col_ref1 = str2num(cols(1));
                col_ref2 = str2num(cols(2));
                binned_array(m,column) = sum(array(temp,column).*(array(temp,col_ref1)./array(temp,col_ref2))) / sum((array(temp,col_ref1)./array(temp,col_ref2)));
            else
                %disp('none')
                binned_array(m,column) = sum(array(temp,column)) / number_elements;
            end
        end
        binned_array(m,temp2+1) = bin_resolution(n); %Bin resolution FWHM TOPHAT
        binned_array(m,temp2+2) = number_elements; %Nu. elements used in averaging
        m = m+1;
    end
end
warning on


