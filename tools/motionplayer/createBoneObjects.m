function bones = createBoneObjects(skel, mot, colorArmature, edgeColorArmature)
% creates the bone objects of to a skeleton
numBones = skel.njoints;
bones = struct('id',[],'parentID',[],'name','','type','',...
    'vertices',[],'vertstream',[],'faces',[],'facecolor',[],'edgecolor',[],...
    'labelHandle',[],'labelStream',[],...
    'objectHandle',[],'headPos',[],'tailPos',[]);
for i = 1:numBones
    bone = skel.nodes(i,1);
    % get the joint trajectories for the positions of the labels
    labelTrajectory = mot.jointTrajectories{i,1};
    % head and tail pos in world coordinates
    headPos = getHeadPos(bone, skel);
    tailPos = (headPos + (bone.direction * bone.length));
    % define the thickness of a bone depending on average length of
    % his childbones or his length if there are no childbones
    if(isempty(bone.children))
        if(bone.length == 0)
            thickness = .1;
        else
            thickness = bone.length/10;
        end
    else
        thickness = .0;
        for b = bone.children'
            thickness = thickness + skel.nodes(b,1).length;
        end
        thickness = thickness / (size((bone.children),1)*10);
    end
    % create bone object and add to bones
    bones(i) = PrimBone(bone.ID, bone.parentID, bone.boneName,...
        headPos', tailPos', thickness, labelTrajectory,...
        colorArmature, edgeColorArmature);
end
% recursive function which returns the head position of a bone in world
% coordinates
    function headPos = getHeadPos(bone, skel)
        % root bone should have no parent
        if (bone.parentID == 0)
            headPos = bone.offset;
        else
            pBone = skel.nodes(bone.parentID,1);
            headPos = pBone.offset + getHeadPos(pBone, skel);
        end
    end
end