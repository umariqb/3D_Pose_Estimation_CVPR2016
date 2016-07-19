function [result,skel] = readRoot(skel,fid)

global currentPath;

currentPath = 1;

[result,skel,newnode_id] = readJoint(skel,0,fid);
if ~result
    error('Error while parsing root.');
end
