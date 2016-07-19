function [result,skel] = readUnits(skel,fid)

[result,lin]  = findNextASFSection(fid);
if (~result)
    error(['Could not find DOCUMENTATION in ' skel.filename '!']);
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'DOCUMENTATION')
    error(['Expected DOCUMENTATION in ' skel.filename '!']);
end

k = 1;
while (~feof(fid)) 
    pos = ftell(fid);
    lin = fgetl(fid);
    if (beginsWithColon(eatWhitespace(lin)))
        break;
    end

    skel.documentation{k,1} = lin;
    k = k+1;
end
fseek(fid,pos,'bof');
