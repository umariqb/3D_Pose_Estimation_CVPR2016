function [result,newnode] = readOffset(newnode,fid)

[result, lin] = findKeyword(fid,'OFFSET');
if ~result
    error(['BVH section OFFSET not found for node ' newnode.name '!']);
    return;
end
lin = deblank(lin(8:size(lin,2))); % remove 'OFFSET' at beginning of line, trim
newnode.offset = sscanf(lin,'%f%f%f');
newnode.length = norm(newnode.offset);
if (newnode.length > eps)
    newnode.direction = (1/newnode.length)*newnode.offset;
end
