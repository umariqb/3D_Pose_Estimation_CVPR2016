function [result,skel] = constructSkeleton(skel, currentNode_id, hierarchy, currentHierarchyIndex)

result = false;

k = 2; % in an ASF file, k = 1 should be referring to currentNode, the parent of the child nodes to be inserted
while ((k<=size(hierarchy,2)) & (~isempty(hierarchy{currentHierarchyIndex,k}))) % insert all child nodes
    childBoneName = hierarchy{currentHierarchyIndex,k};
	childBoneIndex = strmatch(upper(childBoneName),upper({skel.nodes.boneName}),'exact');
	if (length(childBoneIndex)>1)
        error(['ASF: Bone name "' childBoneName '" is not unique!']);
	end
	if (length(childBoneIndex)<1)
        error(['ASF: Unknown bone "' childBoneName '"!']);
	end

    skel.nodes(currentNode_id).children = [skel.nodes(currentNode_id).children; childBoneIndex];
    skel.nodes(childBoneIndex).parentID = currentNode_id;

    % in which lines of the hierarchy data does the current child appear as a parent?
    childHierarchyIndex = strmatch(upper(childBoneName),upper({hierarchy{:,1}}),'exact'); 
    
	if (length(childHierarchyIndex)>=1) % found one or more lines where current child appears as a parent.
        for m = 1:length(childHierarchyIndex)
            [result,skel] = constructSkeleton(skel,childBoneIndex,hierarchy,childHierarchyIndex(m));
        end
    end        

    k = k + 1;
end

result = true;