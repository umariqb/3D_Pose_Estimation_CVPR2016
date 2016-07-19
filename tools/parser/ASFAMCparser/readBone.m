function [result,bone] = readBone(skel,fid)

[result, lin] = findKeyword(fid,'begin');
if ~result
    error('ASF: Expected BEGIN while reading bones!');
end

bone = emptySkeletonNode;
while (~feof(fid)) 
    pos = ftell(fid);
    lin = eatWhitespace(fgetl(fid));
    if (length(lin)<1)
        continue;
    end
    if (strcmpi(lin(1:3),'end'))
        break; % passed end of bone!
    end

    bone.ID = skel.njoints+1; % ID is an optional field in ASF files... this choice is a good default value for a unique ID.
    [token,lin] = strtok(lin);
    lin = eatWhitespace(lin);
    switch (upper(token))
        case 'ID'
            [token2,lin] = strtok(lin);
            bone.ID = str2num(token2) + 1; % "+ 1" because we want root node (which is not treated as a separate node in ASF) to occupy ID 1
        case 'NAME'
            [token2,lin] = strtok(lin);
            bone.boneName = token2;
        case 'DIRECTION'
            bone.direction = sscanf(lin,'%f %f %f');
        case 'LENGTH'
            bone.length = sscanf(lin,'%f') / skel.lengthUnit;
        case 'AXIS'
            [bone.axis,count,errmsg,nextindex] = sscanf(lin,'%f %f %f');
            lin = lin(nextindex:end);
            [token2,lin] = strtok(lin);
            bone.rotationOrder = token2;
        case 'DOF'
            k = 1;
            while length(eatWhitespace(lin))>0
                [dof,lin] = strtok(lin);
                bone.DOF{k,1} = dof;
                k = k+1;
            end
        case 'LIMITS'
            nDOF = size(bone.DOF,1);
            bone.limits = zeros(nDOF,2);
            bone.limits(1,:) = transpose(sscanf(lin,'(%f %f)'));
            for n = 2:nDOF
                lin = eatWhitespace(fgetl(fid));
                bone.limits(n,:) = transpose(sscanf(lin,'(%f %f)'));
            end
        case 'BODYMASS'
        case 'COFMASS'
        otherwise
            warning(['ASF: Unknown bone property: ' token '!']);
    end
end
if (norm(bone.direction) > 0)
    bone.offset = bone.direction/norm(bone.direction) * bone.length;
end

fseek(fid,pos,'bof');


[result, lin] = findKeyword(fid,'end');
if ~result
    error('ASF: Expected END while reading bones!');
end
