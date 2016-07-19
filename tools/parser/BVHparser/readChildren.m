function [result,skel] = readChildren(newnode_id,skel,fid)

global currentPath;

done = false;
childCount = 0;
while ~done  % read children of newnode
% test for end of newnode's children: which comes first, JOINT/End Site or newnode's closing '}'? %%%%%%%%%%%
   fpos = ftell(fid);
   [result, token] = findNextToken(fid);
   fseek(fid,fpos,'bof');

   if (~result) % there should be at least a closing brace following at this point!!!
       error(['BVH: Expected JOINT/End Site or closing } to follow at this point in child list of node ' skel.nodes(newnode_id).jointName '!']);
   end
   if (token(1) == '}')
% closing brace comes first => end of node's children list
       if (childCount == 0) & (size(skel.paths,1)==currentPath) % no children at all AND current path nonempty => start new path
           currentPath = currentPath + 1;
       end
       done = true;
       continue;
   elseif (strcmp(upper(token),'JOINT')==1) | (strcmp(upper(token),'END')==1)
   else
       error(['BVH: Unexpected/illegal token "' token '". Expected JOINT/End Site or closing } in child list of node ' skel.nodes(newnode_id).jointName '!']);
   end
   
   childCount = childCount + 1;
   
   if (childCount > 1)  % start a new path at a joint with more than one child
       if (size(skel.paths,1)==currentPath)
           currentPath = currentPath + 1;
       end
       skel.paths{currentPath,1}(1) = newnode_id;
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   fpos = ftell(fid);
   [result, lin] = findKeyword(fid,'JOINT','End Site');
   fseek(fid,fpos,'bof');

   if strcmp(lin(1:5),'JOINT') == 1
       %%%%%%%%%%%%%% point of recursion
      [result2,skel,newnode_child_id] = readJoint(skel,newnode_id,fid);
       if ~result2
            error(['BVH: error parsing children in node ' skel.nodes(newnode_id).jointName '!']);
       end
      skel.nodes(newnode_id).children = [skel.nodes(newnode_id).children; newnode_child_id];
      skel.nodes(newnode_child_id).parentID = newnode_id;
%%%%%%%%%%%%%%%%%%%%% End Site
   elseif strcmp(lin(1:8),'End Site') == 1 
       [result, lin] = findKeyword(fid,'{');
       if ~result
            warning(['BVH: Opening { not found for End Site in node ' skel.nodes(newnode_id).jointName '!']);
       end

       skel.njoints = skel.njoints + 1;

       end_site_node = emptySkeletonNode;
       end_site_node.ID = skel.njoints;
% BVH: movable joint at the END of a bone
% ASF: movable joint at the BEGINNING of a bone
% BVH-style joints are converted into ASF-style bones by copying the DOF data for a non-forked joint to the joint's
% child joint. At forked joints, the child joints have no DOFs associated with them, i.e., they become stiff dummy bones.
       end_site_node.jointName = skel.nodes(newnode_id).jointName;
       end_site_node.boneName = [skel.nodes(newnode_id).jointName '___' skel.nodes(newnode_id).jointName '.EndSite'];
       end_site_node.DOF = skel.nodes(newnode_id).DOF;
       end_site_node.rotationOrder = skel.nodes(newnode_id).rotationOrder;
                          
%%%%%%%%%%%%% update path data structure
	   if isempty(skel.paths)
            p = [];
	   else
            p = skel.paths{currentPath,1};
       end
	   skel.paths{currentPath,1} = [p; end_site_node.ID];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                          
       %%%%%%%%%%%%%% read offset for End Site
       [result,end_site_node] = readOffset(end_site_node,fid);
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       skel.nodes(newnode_id).children = [skel.nodes(newnode_id).children; end_site_node.ID];
       end_site_node.parentID = newnode_id;
      
       [result, lin] = findKeyword(fid,'}');
       if ~result
            warning(['BVH: Closing } not found for End Site in node ' skel.nodes(newnode_id).jointName '!']);
%                   return;
       end

       skel.nodes = [skel.nodes; end_site_node];
   else
        error(['BVH: Unknown keyword "' lin '" in node ' skel.nodes(newnode_id).jointName '!']);
        return;
   end
end % while ~done
