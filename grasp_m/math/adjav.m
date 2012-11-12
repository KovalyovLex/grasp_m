function output = adjav(data,w)

%Performs an adjacent average of multi column data
%data - incoming columns of data to be smoothed
%w - half width of the smoothing (adjacent averaging) window

[rows, cols] = size(data);
output = [];
for n = 1:rows;
    %detect and correct for begin and end boundaries
    low = n-w; if low <1; low = 1; end
    high = n+w; if high >rows; high = rows; end
    
    for m = 1:cols;
        output(n,m) = sum(data(low:high,m)) / ((high-low)+1);
    end
end
       
    
