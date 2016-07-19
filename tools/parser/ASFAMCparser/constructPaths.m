function [skel,currentPath] = constructPaths(skel, currentNode_id, currentPath)
% traverse kinematic chain to generate a minimal edge-disjoint path covering used in the rendering process

%%%%%%%%%%%%% append current node to current path
if isempty(skel.paths)
    p = [];
else
    p = skel.paths{currentPath,1};
end
skel.paths{currentPath,1} = [p; currentNode_id];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

childCount = length(skel.nodes(currentNode_id).children);

if (childCount == 0) % this is a childless bone
    if (size(skel.paths,1)==currentPath) % no children at all AND current path nonempty => start new current path
       currentPath = currentPath + 1;
    end
    return;
end

childCount = length(skel.nodes(currentNode_id).children);

for k = 1:childCount
	if (k > 1)  % start a new path at a joint with more than one child
       if (size(skel.paths,1)==currentPath) % current path is nonempty
           currentPath = currentPath + 1;
       end
       skel.paths{currentPath,1}(1) = currentNode_id;
	end
    [skel,currentPath] = constructPaths(skel, skel.nodes(currentNode_id).children(k), currentPath);
end