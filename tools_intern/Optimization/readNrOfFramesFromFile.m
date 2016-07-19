% function readNrOfFramesFroMFile
% reads number of frames from specified amc-file
% cf. function readNumFrames

function nrOfFrames = readNrOfFramesFromFile(filename)

fid = fopen(filename,'rt');
found = false; % found last frame number
fseek(fid,-1,'eof'); % jump to end of file
while (ftell(fid) > 0 && ~found) % not at bof AND not found last frame number
    pos = ftell(fid);
    ch = fread(fid,1,'uchar'); % read current character
    if (ch == 10) % line feed
        l = fgetl(fid);
        fseek(fid,pos-1,'bof');
        if (l ~= -1) % no eof encountered
            nrOfFrames = str2double(l);
            if ~isnan(nrOfFrames)
                found = true;
            end
        end
    else
        fseek(fid,-2,'cof'); % jump 2 characters back
    end
end
fclose(fid);