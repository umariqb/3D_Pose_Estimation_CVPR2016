function [result,skel] = readUnits(skel,fid)

pos = ftell(fid);
[result,lin]  = findNextASFSection(fid);
if (~result)
    return; % UNITS are optional!
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'units')
    fseek(fid,pos,'bof');
    return; % UNITS are optional!
end

while (~feof(fid)) 
    pos = ftell(fid);
    lin = eatWhitespace(fgetl(fid));
    if (length(lin)<1)
        continue;
    end
    if (beginsWithColon(lin))
        break;
    end
    
    [token,lin] = strtok(lin);
    [token2,lin] = strtok(lin);
    switch (upper(token))
        case 'MASS'
            skel.massUnit = str2num(token2);
        case 'LENGTH'
            skel.lengthUnit = str2num(token2);
        case 'ANGLE'
            skel.angleUnit = token2;
        otherwise
            warning(['Unknown UNIT: ' token '!']);
    end
end
fseek(fid,pos,'bof');
