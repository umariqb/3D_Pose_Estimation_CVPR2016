function [result,skel] = readName(skel,fid)

[result,lin]  = findNextASFSection(fid);
if (~result)
    error(['Could not find NAME in ' skel.filename '!']);
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'name')
    error(['Expected NAME in ' skel.filename '!']);
end

[token,lin] = strtok(lin);
skel.name = token;

