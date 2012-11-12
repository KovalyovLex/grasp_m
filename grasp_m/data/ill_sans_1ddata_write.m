function ill_sans_1ddata_write(export_data,params,parsub,numor,directory,additional_text);

%export_data is columns of xye (real)
%params is the 128 instrument raw data params (yes, I know you don't like this Ron!) (real)
%parsub - 80 characters of text 
%numor (integer) file numor
%directory - directory path string.
%aditional text - padded 80 chatacter lines of text.

global inst

%Check if additional footer text exists.
if nargin < 6 
   no_text_lines = 0;
else
   no_text_lines = length(additional_text);
end

%***** Build Output file name *****
numor_str = num2str(numor);
a = length(numor_str);
if a ==1; addzeros = '00000';
elseif a==2; addzeros = '0000';
elseif a==3; addzeros = '000';
elseif a==4; addzeros = '00';
elseif a==5; addzeros = '0';
elseif a==6; addzeros = ''; end
ext_no = 100; %Use extension g******.100 - then you know it came from Grasp
fname = [directory 'g' addzeros numor_str '.' num2str(ext_no)];

%***** Open the file *****   
fid=fopen(fname,'w');

%***** Title Line *****
fprintf(fid,'%s \n',rot90(parsub,3));

%***** Key Line *****
textstring = ['ILL SANS ' inst];
fprintf(fid,'%s \n',textstring);

%***** Indexing1 *****
pdh_lines = 3; param_lines = 15;
numtext = [numor, ext_no, length(export_data), 1, (pdh_lines+param_lines+2), (param_lines+2)];
fprintf(fid,'%10d %9d %9d %9d %9d %9d\n',numtext);
%***** Indexing2 *****
numtext = [1, 0, param_lines, 0, pdh_lines, 1];
fprintf(fid,'%10d %9d %9d %9d %9d %9d\n',numtext);

%***** Program & Date *****
d = now; dstr = datestr(d,0);
textstring = ['GRASP Export: ' dstr];
fprintf(fid,'%s \n',textstring);

%***** Parameters *****
numstr = num2str(0,'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! Theta-0 Detector offset angle']; fprintf(fid,'%s \n',textstring);
numstr = num2str(0,'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! X0 cms Beam centre']; fprintf(fid,'%s \n',textstring);
numstr = num2str(0,'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! Y0 cms Beam centre']; fprintf(fid,'%s \n',textstring);
numstr = num2str(0,'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! Delta-R pxl regrouping step']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(26),'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! SD m Sample-detector distance (calc)']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(53),'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! Angstroms incident wavelength']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(54),'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! % wavelength spread']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(58),'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! m collimation distance']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(55),'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! mm detector x pixel size']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(56),'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! mm detector y pixel size']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(65),'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! sample rot (San)']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(31),'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! K sample temperature']; fprintf(fid,'%s \n',textstring);
numstr = num2str(0,'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! sample transmission']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(3)/10,'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! counting time secs']; fprintf(fid,'%s \n',textstring);
numstr = num2str(params(65)/10,'%10.4f'); l = size(numstr);
textstring = [blanks(10-l(2)) numstr ' ! Sample Rot (San)']; fprintf(fid,'%s \n',textstring);
%**********

%***** PDH Parameters *****
numtext = [length(export_data), 0, 0, 0, 0, 0, 0, 0];
fprintf(fid,'%10d %9d %9d %9d %9d %9d %9d %9d\n',numtext);
numtext = [0, params(26), 0, 0, params(53)];
fprintf(fid,'%14.6e %14.6e %14.6e %14.6e %14.6e\n',numtext);
numtext = [0, 0, 0];
fprintf(fid,'%14.6e %14.6e %14.6e\n',numtext);
%**********

%***** Export Data *****
fprintf(fid,'%14.6e %14.6e %14.6e\n',flipud(rot90(export_data)));


% %***** Add aditional lines of text here *****
% fprintf(fid,'%s \n','');
% fprintf(fid,'%s \n','');
% if no_text_lines ~=0
%    for n = 1:no_text_lines
%       fprintf(fid,'%s \n',additional_text{n});
%    end
% end
% %**********




%***** Close File *****
fclose(fid);



