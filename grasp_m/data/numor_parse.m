function [numor_list, depth_list] = numor_parse(numors_str_in)

%[numor_list, depth_list] = numor_parse(numors_str_in)
%Parses the numor_string and produces a list of file numors (numeric) and
%the depth into which they should go

numor_list = []; depth_list = [];
depth = 1;

%***** Comma block loop *****
numors_str = numors_str_in;
while not(isempty(numors_str))
    [numors_block, numors_str] = strtok(numors_str,',');
    
    %***** Check for : separator within comma block *****
    %Only one type of separator can be used within each comma block
    separator_list = {'>',':',',','+','(','{'}; %Find Next separator in Block
    for separator = 1:length(separator_list);
        separator_str = separator_list{separator};
        separator_pos = findstr(numors_block,separator_str);
        if not(isempty(separator_pos)); break;
        else separator_str = []; end
    end
    
    %***** Prepare numors & depth data depending on separator string *****

    %No Seprator - Single Numor
    if isempty(separator_str);
       numor = str2num(numors_block);
       if not(isempty(numor));
           numor_list = [numor_list; numor];
           depth_list = [depth_list; depth];
           depth = depth +1;
       end
    end

    %'+'  Add numors together
    if strcmp(separator_str,'+')
        separator_list = [0, separator_pos, length(numors_block)+1];
        for n =1:length(separator_list)-1;
            numor = str2num(numors_block(separator_list(n)+1:separator_list(n+1)-1));
            numor_list = [numor_list; numor];
            depth_list = [depth_list; depth];
        end
        depth = depth+1;
    end
    
    
    
    %'(n;s)'  Cumulative sum of n numors, skipping s
    if strcmp(separator_str,'(')
        numor_start_str = numors_block(1:separator_pos(1)-1);
        bracket1 = findstr(numors_block,'('); bracket2 = findstr(numors_block,')');
        between_brackets = numors_block(bracket1+1:bracket2-1);
        %find the number and skip 
        [number_str,skip_str] = strtok(between_brackets,';');
        number = str2num(number_str);
        skip = str2num(skip_str(2:length(skip_str)));
        if isempty(skip); skip = 1; end
        
        %Build the load numor list
        numor = str2num(numor_start_str);
        for n = 1:number
            numor_list = [numor_list; numor];
            depth_list = [depth_list; depth];
            numor = numor + skip;
        end
        depth = depth+1;
    end
    
    
    %'{n;s}'  Depth load of n numors, skipping s
    if strcmp(separator_str,'{')
        numor_start_str = numors_block(1:separator_pos(1)-1);
        bracket1 = findstr(numors_block,'{'); bracket2 = findstr(numors_block,'}');
        between_brackets = numors_block(bracket1+1:bracket2-1);
        %find the number and skip
        [number_str,skip_str] = strtok(between_brackets,';');
        number = str2num(number_str);
        skip = str2num(skip_str(2:length(skip_str)));
        if isempty(skip); skip = 1; end
        
        %Build the load numor list
        numor = str2num(numor_start_str);
        for n = 1:number
            numor_list = [numor_list; numor];
            depth_list = [depth_list; depth];
            numor = numor + skip;
            depth = depth +1;
        end
    end
    
    
    %'>>>'  Sum between numor range skipping every n
    if strcmp(separator_str,'>')
        numor_start_str = numors_block(1:separator_pos(1)-1);
        numor_end_str = numors_block(separator_pos(length(separator_pos))+1:length(numors_block));
        numor_start = str2num(numor_start_str); numor_end = str2num(numor_end_str);
        skip = length(separator_pos);
        if not(isempty(numor_start)) && not(isempty(numor_end))
            
            for numor = numor_start:skip:numor_end
                numor_list = [numor_list; numor];
                depth_list = [depth_list; depth];
            end
            
        else
            return
        end
        depth = depth+1;
    end
    
    
    %':::' Depth load between numor range skipping every n
    if strcmp(separator_str,':')
        numor_start_str = numors_block(1:separator_pos(1)-1);
        numor_end_str = numors_block(separator_pos(length(separator_pos))+1:length(numors_block));
        numor_start = str2num(numor_start_str); numor_end = str2num(numor_end_str);
        skip = length(separator_pos);
        if not(isempty(numor_start)) && not(isempty(numor_end))
            for numor = numor_start:skip:numor_end
                numor_list = [numor_list; numor];
                depth_list = [depth_list; depth];
                depth = depth+1;
            end
        else
            return
        end
    end

end


