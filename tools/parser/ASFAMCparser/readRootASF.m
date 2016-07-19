function [result,skel] = readRoot(skel,fid)

[result,lin]  = findNextASFSection(fid);
if (~result)
    error(['ASF: Could not find ROOT in ' skel.filename '!']);
end

[token,lin] = strtok(lin);
token = token(2:end); % remove leading colon
if ~strcmpi(token,'ROOT')
    error(['ASF: Expected ROOT in ' skel.filename '!']);
end

skel.nodes = emptySkeletonNode;

while (~feof(fid)) 
    pos = ftell(fid);
    lin = eatWhitespace(fgetl(fid));
    if (beginsWithColon(lin))
        break;
    end
    
    [token,lin] = strtok(lin);
    switch (upper(token))
        case 'AXIS'
            [token2,lin] = strtok(lin);
            skel.nodes(1).rotationOrder = token2;
        case 'ORDER'
            k = 1;
            while length(eatWhitespace(lin))>0
                [dof,lin] = strtok(lin);
                skel.nodes(1).DOF{k,1} = dof;
                k = k+1;
            end
        case 'POSITION'
            skel.nodes(1).offset = sscanf(lin,'%f %f %f')  / skel.lengthUnit;
        case 'ORIENTATION'
            skel.rootRotationalOffsetEuler = sscanf(lin,'%f %f %f');
        otherwise
            warning(['ASF: Unknown ROOT property: ' token '!']);
    end
end
fseek(fid,pos,'bof');

skel.nodes(1).jointName = 'root';
skel.nodes(1).boneName = 'root';
skel.nodes(1).ID = 1;

switch skel.angleUnit
    case 'deg'
        skel.rootRotationalOffsetQuat = euler2quat(skel.rootRotationalOffsetEuler*pi/180);
    case 'rad'
        skel.rootRotationalOffsetQuat = euler2quat(skel.rootRotationalOffsetQuat);
end

skel.njoints = 1;