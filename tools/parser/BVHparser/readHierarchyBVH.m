function [result,skel] = readHierarchy(skel,fid)

[result, line] = findKeyword(fid,'HIERARCHY');
if ~result
    error(['BVH section HIERARCHY not found in file ' skel.filename '!']);
    return;
end
           
tic;
[result, skel] = readRootBVH(skel,fid);
t=toc;
disp(['Read skeleton data from ' skel.filename ' in ' num2str(t) ' seconds.']);


%%%%%%%%% fill in joint names, bone names and animated/unanimated arrays
skel.jointNames = cell(skel.njoints,1);
skel.boneNames = cell(skel.njoints,1); 
for k=1:length(skel.nodes)
    if ~isempty(skel.nodes(k).DOF{1}) 
       skel.animated = [skel.animated; k];
    else
       skel.unanimated = [skel.unanimated; k];
    end
    
    skel.jointNames{k,1} = skel.nodes(k).jointName;
    skel.boneNames{k,1} = skel.nodes(k).boneName; 
end

skel.nameMap = constructNameMap(skel);