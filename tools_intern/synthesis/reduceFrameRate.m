function resmot=reduceFrameRate(skel,mot)

resmot=emptyMotion();
resmot.njoints=mot.njoints;
resmot.frameTime=mot.frameTime*4;
resmot.samplingRate=mot.samplingRate/4;

resmot.rootTranslation=mot.rootTranslation(:,1:4:mot.nframes);
for joint=1:mot.njoints
    % joint Trajectories
%     if(~isempty(mot.jointTrajectories{joint}))
%         resmot.jointTrajectories{joint}=mot.jointTrajectories{joint}(:,1:4:mot.nframes);
%     end
    % rot Euler
    if(~isempty(mot.rotationEuler{joint}))
        resmot.rotationEuler{joint}=mot.rotationEuler{joint}(:,1:4:mot.nframes);
    end
    % rot Quat
    if(~isempty(mot.rotationQuat{joint}))
        resmot.rotationQuat{joint}=mot.rotationQuat{joint}(:,1:4:mot.nframes);
    end
end 

resmot.rotationQuat=resmot.rotationQuat';
resmot.rotationEuler=resmot.rotationEuler';

resmot.nframes=size(resmot.rootTranslation,2);
resmot.jointNames=mot.jointNames;
resmot.boneNames=mot.boneNames;
resmot.nameMap=mot.nameMap;
resmot.animated=mot.animated;
resmot.unanimated=mot.unanimated;

resmot.jointTrajectories = forwardKinematicsQuat(skel,resmot);
resmot.boundingBox=computeBoundingBox(resmot);