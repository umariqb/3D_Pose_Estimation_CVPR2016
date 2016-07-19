function motFit = fitMotFrameWise(skel,refmot,mot)

if refmot.nframes~=mot.nframes
    error('Different number of frames!');
end

data    = cell2mat(mot.jointTrajectories);
refdata = cell2mat(refmot.jointTrajectories);

motFit = mot;

for i=1:refmot.nframes
    
    P   = reshape(refdata(:,i),3,refmot.njoints);
    Q   = reshape(data(:,i),3,mot.njoints);

    [f,theta,x0,z0] = pointCloudDist_modified(P,Q,'pos');
    
    quat = rotquat(theta,'y');

    motFit.rootTranslation(:,i) = quatrot(motFit.rootTranslation(:,i),quat)...
                                    + [x0;0;z0];
    motFit.rotationQuat{1}(:,i) = quatmult(quat,motFit.rotationQuat{1}(:,i));
end

motFit.jointTrajectories = forwardKinematicsQuat(skel,motFit);
motFit.boundingBox       = computeBoundingBox(motFit);

if ~(isempty(motFit.rotationEuler))
    motFit               = convert2euler(skel,motFit);
end
if (isfield(motFit,'jointVelocities') && ~isempty(motFit.jointVelocities))
    motFit = addVelToMot(motFit);
end
if (isfield(motFit,'jointAccelerations') && ~isempty(motFit.jointAccelerations))
    motFit = addAccToMot(motFit);
end