function [result,skel] = readVersion(skel,fid)

[result,lin]  = findNextASFSection(fid);
if (~result)
    error(['Could not find VERSION in ' skel.filename '!']);
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'version')
    error(['Expected VERSION in ' skel.filename '!']);
end

[token,lin] = strtok(lin);
skel.version = token;

