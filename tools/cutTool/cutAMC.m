function cutAMC(fullFileNameIn, fullFileNameOut, frameFrom, frameTo)
%
% cutAMC(fullFileNameIn, fullFileNameOut, frameFrom, frameTo)
%

fromStr = int2str(frameFrom);
toStr   = int2str(frameTo+1);

if strcmp(fullFileNameIn, fullFileNameOut)
    h=errordlg('Identical input and output file is not possible.','application error');
    uiwait(h)
    return
end

% open files
fin  = fopen(fullFileNameIn,'r'); 
fout  = fopen(fullFileNameOut,'w'); 

if fin==-1
    h=errordlg(['File: ',fullFileNameIn,' could not be opened'],'application error');
    uiwait(h)
    return
end

if fout==-1
    h=errordlg(['File: ',fullFileNameOut,' could not be opened'],'application error');
    uiwait(h)
    return
end

% copy header (everything up to frame 1)
line = fgets(fin);
while ( isempty(str2num(line)) )
    fwrite(fout, line);
    dataStart = ftell(fin);
    line = fgets(fin);
end

% check fragment length
line = fgets(fin);
blockLength = 0;
while ( isempty(str2num(line)) )
    line = fgets(fin);
    blockLength = blockLength + 1;
end

% rewind to beginning of data
fseek(fin, dataStart, 'bof');
line = fgets(fin);

% skip everything till frameFrom
idx = strfind(line, fromStr);
while ( isempty(idx) || idx(1) ~= 1 )
    for i=1:blockLength
        fgets(fin);
    end
    line = fgets(fin);
    idx = strfind(line, fromStr);    
end

% copy desired frames
idx = strfind(line, toStr);
while ( not(feof(fin)) && (isempty(idx) || idx(1) ~= 1 ) )

    newLine = int2str(str2num(line) - frameFrom + 1);
    fprintf(fout, [newLine '\n']);
    
    for i=1:(blockLength)
        line = fgets(fin);
        fwrite(fout, line);
    end

    line = fgets(fin);
    idx = strfind(line, toStr);    
end

% close files
fclose(fin);
fclose(fout);