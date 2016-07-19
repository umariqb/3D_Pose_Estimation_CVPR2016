function motNew=appendMotions(skel,mot_1,mot_2)

%% Copy motion one.
motNew     =   mot_1;

%% Calculate new number of frames:
motNew.nframes     = mot_1.nframes+mot_2.nframes;

%% Rotate Orientation of root
%Quaternion to use complete Orientation
diffQ=C_quatmult(mot_1.rotationQuat{1}(:,mot_1.nframes),quatconj(mot_2.rotationQuat{1}(:,1)));
diffQ(2)=0;
diffQ(4)=0;
diffQ=quatnormalize(diffQ);

for j=1:mot_2.nframes
     mot_2.rotationQuat{1}(:,j)=C_quatmult(diffQ,mot_2.rotationQuat{1}(:,j));
end

mot_2.rootTranslation=quatrot(mot_2.rootTranslation,diffQ);

%% Translation of root position
diffV=mot_1.rootTranslation(:,mot_1.nframes)-mot_2.rootTranslation(:,1);
diffV(2)=0;
for j=1:mot_2.nframes
    mot_2.rootTranslation(:,j)=mot_2.rootTranslation(:,j)+diffV;
end

for i=1:mot_1.njoints
    if(~isempty(mot_1.rotationQuat{i}))
     motNew.rotationQuat{i}=[mot_1.rotationQuat{i} mot_2.rotationQuat{i}];
    end
end

motNew.rootTranslation=[mot_1.rootTranslation mot_2.rootTranslation];

%% Final clean up of other params
motNew.jointTrajectories = C_forwardKinematicsQuat(skel,motNew);
motNew.boundingBox=computeBoundingBox(motNew);

newMot.filename='synthesized by appendMotions';