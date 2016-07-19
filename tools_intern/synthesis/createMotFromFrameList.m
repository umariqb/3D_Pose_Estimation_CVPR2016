function resmot=createMotFromFrameList(skel,mot,list)

dim=size(list);
resmot.njoints=mot.njoints;
resmot.nframes=dim(2);
resmot.frameTime=mot.frameTime;
resmot.samplingRate=mot.samplingRate;

for frame=1:dim(2)
    % Root Translation
    resmot.rootTranslation(:,frame)=zeros(3,1);%mot.rootTranslation(:,list(frame));
    for joint=1:mot.njoints
        % joint Trajectories
        if(~isempty(mot.jointTrajectories{joint}))
            resmot.jointTrajectories{joint}(:,frame)=mot.jointTrajectories{joint}(:,list(frame));
        end
        % rot Euler
        if(~isempty(mot.rotationEuler{joint}))
            resmot.rotationEuler{joint}(:,frame)=mot.rotationEuler{joint}(:,list(frame));
        end
        % rot Quat
        if(~isempty(mot.rotationQuat{joint}))
            resmot.rotationQuat{joint}(:,frame)=mot.rotationQuat{joint}(:,list(frame));
        end
    end 
    if (frame>1)
        % Rotate Orientation of root
        %Quaternion to use complete Orientation
        diffQ=quatmult(resmot.rotationQuat{1}(:,frame-1),quatconj(resmot.rotationQuat{1}(:,frame)));
        resmot.rotationQuat{1}(:,frame)=quatmult(diffQ,resmot.rotationQuat{1}(:,frame));
%        resmot.rootTranslation=quatrot(resmot.rootTranslation,diffQ);
    end
end

resmot.jointNames=mot.jointNames;
resmot.boneNames=mot.boneNames;
resmot.nameMap=mot.nameMap;
resmot.animated=mot.animated;
resmot.unanimated=mot.unanimated;

resmot.jointTrajectories = forwardKinematicsQuat(skel,resmot);
%bounding box
resmot.boundingBox=computeBoundingBox(resmot);

% figure; plot(list,'*');
% figure; animate(skel,resmot);