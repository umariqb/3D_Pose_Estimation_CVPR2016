function mot=moveToOrigin(skel,mot)

trans=mot.rootTranslation(:,1)
for i=1:mot.nframes
    mot.rootTranslation(:,i)=mot.rootTranslation(:,i)-trans(:);
end
mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
    