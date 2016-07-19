function [result,skel] = readBonedata(skel,fid)

[result,lin]  = findNextASFSection(fid);
if (~result)
    error(['ASF: Could not find BONEDATA in ' skel.filename '!']);
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'BONEDATA')
    error(['ASF: Expected BONEDATA in ' skel.filename '!']);
end

bonedata = emptySkeletonNode;
k = 2;
while (~feof(fid)) 
    pos = ftell(fid);
    lin = eatWhitespace(fgetl(fid));
    if (length(lin)<1)
        continue;
    end
    if (beginsWithColon(lin)) 
        fseek(fid,pos,'bof');
        break; % we have passed the end of the bonedata section
    end
    fseek(fid,pos,'bof');

    [result, skel.nodes(k,1)] = readBone(skel,fid);
    skel.njoints = skel.njoints + 1;
    k = k+1;
end