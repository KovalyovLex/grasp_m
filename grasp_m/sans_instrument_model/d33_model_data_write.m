function d33_model_data_write(file_numor_path,data)

data

disp(['Writing D33 Model Data to file : ' file_numor_path]);

fid=fopen(file_numor_path,'w');

textstring = '<Numor>';
fprintf(fid,'%s \n',textstring);
fprintf(fid,'%8i\n',data.numor);

textstring = '<nFrames>';
fprintf(fid,'%s \n',textstring);
fprintf(fid,'%8i\n',data.n_frames);

textstring = '<Start>';
fprintf(fid,'%s \n',textstring);
fprintf(fid,'%s\n',data.start_date_time);

textstring = '<End>';
fprintf(fid,'%s \n',textstring);
fprintf(fid,'%s\n',data.end_date_time);

textstring = '<Subtitle>';
fprintf(fid,'%s \n',textstring);
fprintf(fid,'%s \n',data.subtitle);

for frame = 1:data.n_frames
    
    
    fprintf(fid,'%s \n','');
    
    textstring = '<Frame>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8i\n',frame);
    
    textstring = '<Parameters1>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8e %8e %8e %8e\n',data.params1(:,frame));
    
    textstring = '<Detector1>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',data.data1(:,:,frame));
    
    textstring = '<Parameters2>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8e %8e %8e %8e\n',data.params2(:,frame));
    
    textstring = '<Detector2>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',data.data2(:,:,frame));
    
    textstring = '<Parameters3>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8e %8e %8e %8e\n',data.params3(:,frame));
    
    textstring = '<Detector3>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',data.data3(:,:,frame));
    
    textstring = '<Parameters4>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8e %8e %8e %8e\n',data.params4(:,frame));
    
    textstring = '<Detector4>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',data.data4(:,:,frame));
    
    textstring = '<Parameters5>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8e %8e %8e %8e\n',data.params5(:,frame));
    
    textstring = '<Detector5>';
    fprintf(fid,'%s \n',textstring);
    fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',data.data5(:,:,frame));

    fprintf(fid,'%s \n','');
end



%***** Close File *****
fclose(fid);




% %***** RRR Block *****
% textstring = 'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
% fprintf(fid,'%s \n',textstring);
% numtext = [numor, 0, 1];
% fprintf(fid,'%8d %8d %8d\n',numtext);
% 
% %***** AAA Block *****
% textstring = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
% fprintf(fid,'%s \n',textstring);
% numtext = [80];
% fprintf(fid,'%8d\n',numtext);
% d = now; dstr = datestr(d,0);
% l = size(username);
% textstring = [username blanks(14-l(2)) dstr];
% l = size(textstring); textstring = [textstring blanks(80-l(2))];
% fprintf(fid,'%s \n',textstring);
% 
% %***** III Block *****
% textstring = 'IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII';
% fprintf(fid,'%s \n',textstring);
% fprintf(fid,'%8d\n',156);
% numtext = zeros(1,156);
% numtext(1) = 1; numtext(2) = data_size(1)*data_size(2);
% numtext(3:8) = [1,24,2,128,3,256];
% fprintf(fid,'%8d %8d %8d %8d %8d %8d\n',numtext);
% 
% %***** AAA Block *****
% textstring = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
% fprintf(fid,'%s \n',textstring);
% fprintf(fid,'%8d\n',512);
% fprintf(fid,'%s \n',rot90(parsub));
% fprintf(fid,'%s \n',blanks(80));
% fprintf(fid,'%s \n',blanks(80));
% fprintf(fid,'%s \n',blanks(80));
% fprintf(fid,'%s \n',blanks(80));
% fprintf(fid,'%s \n',blanks(80));
% fprintf(fid,'%s \n',blanks(80));
% 
% %***** FFF Block *****
% textstring = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF';
% fprintf(fid,'%s \n',textstring);
% fprintf(fid,'%8d %8d \n',[128,0]);
% fprintf(fid,'%8e %8e %8e %8e\n',params);
% 
% %***** III Block *****
% textstring = 'IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII';
% fprintf(fid,'%s \n',textstring);
% fprintf(fid,'%8d\n',128);
% fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',zeros(1,128));
% 
% %***** SSS Block *****
% textstring = 'SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
% fprintf(fid,'%s \n',textstring);
% fprintf(fid,'%8d %8d %8d %8d\n',[1,0,1,numor]);
% 
% %***** III Block *****
% textstring = 'IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII';
% fprintf(fid,'%s \n',textstring);
% fprintf(fid,'%8d\n',data_size(1)*data_size(2));
% fprintf(fid,'%8d %8d %8d %8d %8d %8d %8d %8d\n',flipud(rot90((data))));
% 
% %***** Close File *****
% fclose(fid);
% end
