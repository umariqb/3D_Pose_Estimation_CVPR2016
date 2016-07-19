global VARS_GLOBAL

fid = fopen('D.txt','wt');

for k=1:length(VARS_GLOBAL.D)
    fprintf(fid,'%4d   %s\n',k,[VARS_GLOBAL.D(k).path_name VARS_GLOBAL.D(k).file_name]);
end

fclose(fid);