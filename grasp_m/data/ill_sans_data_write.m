function ill_sans_data_write(data,params,parsub,numor,directory,flag)

if nargin == 5; flag = 0; end

if nargin == 3;
   
   global grasp_env
   %Open text file for output
   fname = '*.*';
   %Directory Path
   directory = grasp_env.path.project_dir;
   start_string = [directory fname];
   [fname_in, directory] = uiputfile(start_string,'Export Data');
   flag = 0; %i.e. data, not error - this only effects the filename extension
else
   fname_in = num2str(numor);
end

if fname_in ~= 0 %Check the save dialog was'nt canceled
   username = 'Grasp';
	data_size = size(data);
 
   a = length(fname_in);
   if a ==1; addzeros = '00000';
   elseif a==2; addzeros = '0000';
   elseif a==3; addzeros = '000';
   elseif a==4; addzeros = '00';
   elseif a==5; addzeros = '0';
   elseif a==6; addzeros = ''; end
   fname_in = [addzeros fname_in];
   numor = str2num(fname_in);
   
   grasp_env.path.project_dir = directory;
   disp(['Writing ILL format 2D SANS data NUMOR : ' fname_in]);
   if flag ~=0
       fname = [directory fname_in '.err'];
   else
       fname = [directory fname_in];
   end
   
   %Pad parsub out to correct length
   while length(parsub) <20
       parsub = [parsub char(32)];
   end
   user = 'GRASP User';
   while length(user) <60
       user = [user char(32)];
   end
   
   
   
   fid=fopen(fname,'w');
   
   %***** RRR Block *****
   textstring = 'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
   fprintf(fid,'%s \n',textstring);
   numtext = [numor, 0, 1];
   fprintf(fid,'%8d %8d %8d\n',numtext);
   
   %***** AAA Block *****
   textstring = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
   fprintf(fid,'%s \n',textstring);
   numtext = [80];
   fprintf(fid,'%8d\n',numtext);
   d = now; dstr = datestr(d,0);
   l = size(username);
   textstring = [username blanks(14-l(2)) dstr];
   l = size(textstring); textstring = [textstring blanks(80-l(2))];
   fprintf(fid,'%s \n',textstring);
   
   %***** III Block *****
   textstring = 'IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII';
   fprintf(fid,'%s \n',textstring);
   fprintf(fid,'%8d\n',156);
   numtext = zeros(1,156);
   numtext(1) = 1; numtext(2) = data_size(1)*data_size(2); 
   numtext(3:8) = [1,24,2,128,3,256];
   fprintf(fid,'%8d %8d %8d %8d %8d %8d\n',numtext);
   
   %***** AAA Block *****
   textstring = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
   fprintf(fid,'%s \n',textstring);
   fprintf(fid,'%8d\n',512);
   fprintf(fid,'%s \n',[user parsub]);
   fprintf(fid,'%s \n',blanks(80));
   fprintf(fid,'%s \n',blanks(80));
   fprintf(fid,'%s \n',blanks(80));
   fprintf(fid,'%s \n',blanks(80));
   fprintf(fid,'%s \n',blanks(80));
   fprintf(fid,'%s \n',blanks(80));
   
   %***** FFF Block *****
   textstring = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF';
   fprintf(fid,'%s \n',textstring);
   fprintf(fid,'%8d %8d \n',[128,0]);
   fprintf(fid,'%8e %8e %8e %8e\n',params);
   
   %***** III Block *****
   textstring = 'IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII';
   fprintf(fid,'%s \n',textstring);
   fprintf(fid,'%8d\n',128);
   fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',zeros(1,128));
   
   %***** SSS Block *****
   textstring = 'SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
   fprintf(fid,'%s \n',textstring);
   fprintf(fid,'%8d %8d %8d %8d\n',[1,0,1,numor]);

	%***** III Block *****   
   textstring = 'IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII';
   fprintf(fid,'%s \n',textstring);
   fprintf(fid,'%8d\n',data_size(1)*data_size(2));
   fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',flipud(rot90((data))));
   
   %***** Close File *****
   fclose(fid);
end
