function mot = readSamplesPerSecond(mot,fid)

pos = ftell(fid);
[result,lin]  = findNextASFSection(fid);
if (~result)
    return; % SAMPLES-PER-SECOND is optional!
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'SAMPLES-PER-SECOND')
    fseek(fid,pos,'bof');
    return; % UNITS are optional!
end

[token,lin] = strtok(lin);
mot.samplingRate = str2num(token);
mot.frameTime = 1/mot.samplingRate;

fseek(fid,pos,'bof');