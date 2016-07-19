function [result,skel] = readSkin(skel,fid)

pos = ftell(fid);
[result,lin]  = findNextASFSection(fid);
if (~result)
    return; % SKIN is optional!
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'skin')
    fseek(fid,pos,'bof');
    return; % SKIN is optional!
end

% read first skin filename
n = 1;
[token,lin] = strtok(lin);
if (~isempty(token))
    skel.skin{n,1} = token;
    n = n+1;
end

% read remaining skin filenames
while (~feof(fid)) 
    lin = eatWhitespace(fgetl(fid));
    if (length(lin)<1)
        continue;
    end
    if (beginsWithColon(lin))
        break;
    end
    
    skel.skin{n,1} = lin;
    n = n+1;
end
