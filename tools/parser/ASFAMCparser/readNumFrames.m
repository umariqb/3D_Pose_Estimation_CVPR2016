function s = readNumFrames(fid)

%%%%%%%%%% find :DEGREES section
found = false;
while ~found
    [result,lin]  = findNextASFSection(fid);
    if (~result)
        error(['AMC: Could not find DEGREES in ' mot.filename '!']);
    end

    [token,lin] = strtok(lin);
    token = token(2:end); % remove leading colon
    if strcmpi(token,'DEGREES')
        found = true;
    end
end

%%%%%%%%%%%% find out how many frames we are dealing with: seek to end and read backwards till last frame number
found = false; % found last frame number
fseek(fid,-1,'eof'); % jump to end of file
while (ftell(fid) > 0 & ~found) % not at bof AND not found last frame number
    pos = ftell(fid);
    ch = fread(fid,1,'uchar'); % read current character
    if (ch == 10) % line feed
        l = fgetl(fid);
        fseek(fid,pos-1,'bof');
        if (l ~= -1) % no eof encountered
            [frame_num, OK] = str2num(l);
            if (OK)
                found = true;
            end
        end
    else
        fseek(fid,-2,'cof'); % jump 2 characters back
    end
end
if (~found)
   error(['AMC: Could not find last frame number in ' mot.filename '!']);
end
s = frame_num;
