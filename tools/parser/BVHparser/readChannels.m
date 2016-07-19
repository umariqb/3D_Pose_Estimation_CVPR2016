function [result,newnode,is_animated] = readChannels(newnode,fid)

[result, lin] = findKeyword(fid,'CHANNELS');
if ~result
    error(['BVH section CHANNELS not found for node ' newnode.name '!']);
    return;
end
lin = deblank(lin(10:size(lin,2))); % remove 'CHANNELS' at beginning of line, trim
[str_num_channels,lin] = strtok(lin);
num_channels = sscanf(str_num_channels,'%d');

newnode.DOF = cell(num_channels,1);
for k=1:num_channels
    [channel,lin] = strtok(lin);
    switch upper(channel)
        case 'XROTATION'
            channel = 'rx';
            newnode.rotationOrder = [newnode.rotationOrder 'x'];
        case 'YROTATION'
            channel = 'ry';
            newnode.rotationOrder = [newnode.rotationOrder 'y'];
        case 'ZROTATION'
            channel = 'rz';
            newnode.rotationOrder = [newnode.rotationOrder 'z'];
        case 'XPOSITION'
            channel = 'tx';
        case 'YPOSITION'
            channel = 'ty';
        case 'ZPOSITION'
            channel = 'tz';
        otherwise
            warning(['Invalid DOF specification: ' channel '!']);
    end
    newnode.DOF{k,1} = channel;
end
is_animated = (num_channels > 0);