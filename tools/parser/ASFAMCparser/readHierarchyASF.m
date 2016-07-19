function [result,hierarchy] = readHierarchy(fid)

[result,lin]  = findNextASFSection(fid);
if (~result)
    error(['ASF: Could not find HIERARCHY in ' skel.filename '!']);
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'HIERARCHY')
    error(['ASF: Expected HIERARCHY in ' skel.filename '!']);
end

[result, lin] = findKeyword(fid,'begin');
if ~result
    error('ASF: Expected BEGIN while reading hierarchy!');
end

hierarchy = cell(1,1);
k = 1;
while (~feof(fid)) 
    pos = ftell(fid);
    lin = eatWhitespace(fgetl(fid));
    if (length(lin)<1)
        continue;
    end
    if (strcmpi(lin(1:3),'end'))
        break; % passed end of hierarchy!
    end

    n = 1;
    while ~isempty(lin)
        [token,lin] = strtok(lin);
        hierarchy{k,n} = token;
        n = n+1;
    end
    k = k+1;
end
fseek(fid,pos,'bof');

[result, lin] = findKeyword(fid,'end');
if ~result
    error('ASF: Expected END while reading hierarchy!');
end
