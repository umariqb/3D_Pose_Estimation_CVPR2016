function n = readNumFramesBIN(fid)

numDOF = [];        % auxiliary array containing the respective numbers of DOFs
while (~feof(fid))
	token = fscanf(fid,'%s ',1); % read bone label
    h = fscanf(fid,'%d\n',1); % read nDOF and newline
    if (~isnan(str2double(token))) % reached beginning of frame data!
        break;
    end
	numDOF = [numDOF; h];    
end

totalNumDOF = sum(numDOF);
pos1 = ftell(fid);
fseek(fid,0,'eof');
pos2 = ftell(fid);
fclose(fid);

n = (pos2 - pos1 + 1)/(8*totalNumDOF);