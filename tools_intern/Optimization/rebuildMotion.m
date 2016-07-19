function mot = rebuildMotion(skel,mot)

refFrame = 100;

% -------------------------------------------------------------------------
mot_orig = mot;
% mot                         = fitRootOrientationsFrameWise(skel,mot);
mot                         = rotateMotion(skel,mot,rand(1,1)*pi*2,'y');
% mot.rootTranslation(:,:)    = 0;
mot.jointTrajectories       = forwardKinematicsQuat(skel,mot);

q1 = mot_orig.rotationQuat{1}(:,1:end-1);
q2 = mot_orig.rotationQuat{1}(:,2:end);

deltaRootOri = [[1;0;0;0] C_quatmult(C_quatinv(q1),q2)];

t1 = mot_orig.rootTranslation(:,1:end-1);
t2 = mot_orig.rootTranslation(:,2:end);

deltaRootPos = [[0;0;0] C_quatrot(t2-t1,C_quatinv(mot_orig.rotationQuat{1}(:,2:end)))];

% -------------------------------------------------------------------------

for i=refFrame+1:mot.nframes
    mot.rotationQuat{1}(:,i) = C_quatmult(mot.rotationQuat{1}(:,i-1),deltaRootOri(:,i));
end
for i=refFrame-1:-1:1
    mot.rotationQuat{1}(:,i) = C_quatmult(mot.rotationQuat{1}(:,i+1),C_quatinv(deltaRootOri(:,i+1)));
end

for i=refFrame+1:mot.nframes
    mot.rootTranslation(:,i) = mot.rootTranslation(:,i-1) + C_quatrot(deltaRootPos(:,i),mot.rotationQuat{1}(:,i));
end
for i=refFrame-1:-1:1
    mot.rootTranslation(:,i) = mot.rootTranslation(:,i+1) - C_quatrot(deltaRootPos(:,i+1),mot.rotationQuat{1}(:,i+1));
end

mot.jointTrajectories   = forwardKinematicsQuat(skel,mot);
mot.boundingBox         = computeBoundingBox(mot);

motionplayerPro('skel',skel,'mot',{mot_orig,mot});