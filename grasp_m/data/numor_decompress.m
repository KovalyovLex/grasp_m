function file_name_path = numor_decompress(file_name_path)

%Remove any compression extension from the extension
temp = length(file_name_path);
if strcmp(file_name_path(temp-1:temp),'.z');
    file_name_path = file_name_path(1:temp-2);
elseif strcmp(file_name_path(temp-1:temp),'.Z');
    file_name_path = file_name_path(1:temp-2);
elseif strcmp(file_name_path(temp-2:temp),'.gz');
    file_name_path = file_name_path(1:temp-3);
elseif strcmp(file_name_path(temp-2:temp),'.GZ');
    file_name_path = file_name_path(1:temp-3);
end


%Test for decompression, decompress to temporary directory
%Firstly as a non-compressed file
flag = 0; %Indicates success of all attempts to load data
fid = fopen(file_name_path);

if fid ~= -1;
    flag = 1; fclose(fid); compress = 'off'; %filename is fine as it is
else
    %Then compressed formats
    fid = fopen([file_name_path '.gz']);
    if fid ~= -1; compress = '.gz'; flag = 1; fclose(fid); end
    fid = fopen([file_name_path '.z']);
    if fid ~= -1; compress = '.z'; flag = 1;  fclose(fid); end
    fid = fopen([file_name_path '.GZ']);
    if fid ~= -1; compress = '.GZ'; flag = 1; fclose(fid); end
    fid = fopen([file_name_path '.Z']);
    if fid ~= -1; compress = '.Z'; flag = 1; fclose(fid); end
end

if flag == 0
    disp('Can''t find file:  Check Data Directory is Set and File exists');
    file_name_path = [];
    return
end

%Uncompress and re-direct fname to the temporary directory
if not(strcmp(compress,'off'));
    %Copy compressed File to temporay local location and Uncompress
    %Requires gunzip to be in the current dos path
    disp('Uncompressing Data');
    if isunix
        eval(['!cp "' file_name_path compress '" ' tempdir 'grasp_temp' compress]);
    else
        %copyfile([fname compress],[tempdir addzeros numorstr compress]); %Use This for General Purpose Matlab Code
        eval(['!copy ' '"' file_name_path compress '"' ' ' tempdir 'grasp_temp' compress]); %Use this for Compiled PC code
    end
    
    eval(['!gzip -f -d -q ' tempdir 'grasp_temp' compress]);
    file_name_path = [tempdir 'grasp_temp'];
end
