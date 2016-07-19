function skel = constructAuxiliaryArrays(skel, currentNode_id)
% traverse kinematic chain filling in skel's "name" and "animated/unanimated" arrays

if (size(skel.nodes(currentNode_id).DOF)>0)
    skel.animated = [skel.animated; currentNode_id];
else
    skel.unanimated = [skel.unanimated; currentNode_id];
end

if (currentNode_id>1) % leave the root alone!
    skel.nodes(currentNode_id).jointName = [skel.nodes(skel.nodes(currentNode_id).parentID).boneName '_@_' skel.nodes(currentNode_id).boneName];
end

childCount = size(skel.nodes(currentNode_id).children,1);
if (childCount <= 0) % for childless nodes, simply copy the existing joint/bone names into name arrays
    skel.jointNames{currentNode_id,1} = skel.nodes(currentNode_id).jointName;
    skel.boneNames{currentNode_id,1} = skel.nodes(currentNode_id).boneName;
    return;
end

for k = 1:childCount
    skel = constructAuxiliaryArrays(skel, skel.nodes(currentNode_id).children(k));
end

skel.jointNames{currentNode_id,1} = skel.nodes(currentNode_id).jointName;
skel.boneNames{currentNode_id,1} = skel.nodes(currentNode_id).boneName;
