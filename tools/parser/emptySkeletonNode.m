function node = emptySkeletonNode

   node = struct('children',[],...            % struct array containing this node's child nodes' indices within "nodes" array of skeleton data structure
                 'jointName','',...           % name of this joint (if it is a joint (BVH))
                 'boneName','',...            % name of this bone (if it is a bone (ASF))
                 'ID',0,...                   % ID number of this joint/bone
                 'parentID',0,...             % parent node ID
                 'offset',[0;0;0],...         % offset vector from the parent of this node to this node
                 'direction',[0;0;0],...      % direction vector for this bone, given in global coordinates
                 'length',0,...               % length of this bone
                 'axis',[0;0;0],...           % axis of rotation for this node
                 'DOF',cell(1,1),...          % degrees of freedom and rotation order for this node, in the form {'tx','ty','tz','rx','ry','rz'} (e.g.)
                 'rotationOrder','',...       % rotation order in string representation (e.g., 'xyz')
                 'limits',[]);                % kx2, kx2 or kx2 matrix of limits for this node's DOFs
