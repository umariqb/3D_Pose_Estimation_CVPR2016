function [result,skel,newnode_id] = readJoint(skel,parent_id,fid)
% - assumes fid specifies an open BVH file, file pointer 
%   at the BVH node to be read.

global currentPath;

skel.njoints = skel.njoints + 1;

newnode = emptySkeletonNode;
newnode.ID = skel.njoints;
newnode_id = newnode.ID;

%%%%%%%%%%%%%% read JOINT or ROOT together with node name
[result, lin] = findKeyword(fid,'JOINT','ROOT');
if ~result
   error(['BVH section JOINT or ROOT not found in file ' skel.filename ' for node ID ' num2str(currentID) '!']);
   return;
end
[keyword,lin] = strtok(lin); % remove 'JOINT' or 'ROOT' at beginning of line
lin = strtok(lin);
if size(lin,2)==0
   error(['Name of node not found in file' skel.filename '!']);
   return;
end

newnode.jointName = lin;

if (parent_id == 0) % this is the ROOT!
    newnode.boneName = lin;
else
    newnode.boneName = [skel.nodes(parent_id).jointName '___' lin];
end

%%%%%%%%%%%%% update path data structure
if isempty(skel.paths)
    p = [];
else
    p = skel.paths{currentPath,1};
end
skel.paths{currentPath,1} = [p; newnode.ID];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% read opening brace of this node
[result, lin] = findKeyword(fid,'{'); 
if ~result
    error(['BVH: Opening { not found at beginning of node ' newnode.jointName '!']);
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% read OFFSET
[result, newnode] = readOffset(newnode,fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% read CHANNELS
[result, newnode, is_animated] = readChannels(newnode,fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

skel.nodes = [skel.nodes; newnode];

%%%%%%%%%%%%%%%%%% read children
[result, skel] = readChildren(newnode.ID,skel,fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BVH: movable joint at the END of a bone
% ASF: movable joint at the BEGINNING of a bone
% BVH-style joints are converted into ASF-style bones by copying the DOF data for a non-forked joint to the joint's
% child joint. At forked joints, the child joints have no DOFs associated with them, i.e., they become stiff dummy bones.
% In order for these dummy bones to be (collectively) movable at their base joint, a dummy joint / dummy bone of length 0
% is inserted at each fork. Only the root joint is an exception since it is movable anyway.
if (length(skel.nodes(newnode.ID).children)==1) % exactly one child
    % move DOFs and jointName to child
    skel.nodes(skel.nodes(newnode.ID).children).DOF = skel.nodes(newnode.ID).DOF;
    skel.nodes(skel.nodes(newnode.ID).children).jointName = skel.nodes(newnode.ID).jointName;
    skel.nodes(skel.nodes(newnode.ID).children).rotationOrder = skel.nodes(newnode.ID).rotationOrder;
elseif (length(skel.nodes(newnode.ID).children)>1) % more than one child
    for k = 1:length(skel.nodes(newnode.ID).children)
        skel.nodes(skel.nodes(newnode.ID).children(k)).jointName = [skel.nodes(skel.nodes(newnode.ID).children(k)).jointName '_DUMMY'];
        skel.nodes(skel.nodes(newnode.ID).children(k)).boneName = [skel.nodes(skel.nodes(newnode.ID).children(k)).boneName '_DUMMY'];
        skel.nodes(skel.nodes(newnode.ID).children(k)).DOF = cell(1,1);
        skel.nodes(skel.nodes(newnode.ID).children(k)).rotationOrder = '';
    end
    if (newnode.ID > 1) % NOT AT ROOT!
        % insert dummy joint / dummy bone of length 0
        dummy_node = emptySkeletonNode;
        dummy_node.jointName = [skel.nodes(newnode.ID).jointName '_EXTRAJOINT'];
        dummy_node.boneName = [skel.nodes(newnode.ID).jointName '_EXTRAJOINT'];
        skel.njoints = skel.njoints + 1;
        dummy_node.ID = skel.njoints;
        dummy_node.parentID = newnode.ID;
        dummy_node.children = skel.nodes(newnode.ID).children;
        dummy_node.rotationOrder = skel.nodes(newnode.ID).rotationOrder;
        dummy_node.DOF = skel.nodes(newnode.ID).DOF;    
        skel.nodes = [skel.nodes; dummy_node];
        skel.nodes(newnode.ID).children = dummy_node.ID;
    end
end

%%%%%%%%%%%%%%%%% read closing brace of this node
[result, lin] = findKeyword(fid,'}'); 
if ~result
    warning(['BVH: Closing } not found at end of node ' newnode.jointName '!']);
    %return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
