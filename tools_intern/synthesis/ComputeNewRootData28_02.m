function [mot3] = ComputeNewRootData28_02(skel,mot,mot2)

mot.jointTrajectories  = forwardKinematicsQuat(skel,mot);
mot2.jointTrajectories = forwardKinematicsQuat(skel,mot2);

MatRotate=generateTranslationMatrix(mot.nframes,mot,1,mot2,ones(31,1));

Tq = matrix2quat(MatRotate(1:3,1:3));

% MatRotate=diag(ones(3,1));

%      x = mot2.rootTranslation(1,1);
%      y = mot2.rootTranslation(2,1);
%      z = mot2.rootTranslation(3,1);
%      vector = [x,y,z]';

% MR2 = MatRotate;
% MR2 = [ MatRotate(1,1),MatRotate(1,2),MatRotate(1,3); ... 
%         MatRotate(2,1),MatRotate(2,2),MatRotate(2,3); ... 
%         MatRotate(3,1),MatRotate(3,2),MatRotate(3,3)];
      
for i=1:mot2.nframes  
   
     v = mot2.rotationQuat{1}(:,i);
     mot2.rotationQuat{1}(:,i) = quatmult(v, Tq);
%     
%      x = mot2.rootTranslation(1,i);
%      y = mot2.rootTranslation(2,i);
%      z = mot2.rootTranslation(3,i);
     
     vector=mot2.rootTranslation(:,i);
     
     vector = [vector; 1];
     test= MatRotate*(vector); 
%      vector= test;
%     
      mot2.rootTranslation(:,i)=test(1:3);
%     mot2.rootTranslation(2,i)=vector(2);
%     mot2.rootTranslation(3,i)=vector(3);
end;
     
      
    
      
      
% end;
mot3= mot2;
mot3.jointTrajectories = forwardKinematicsQuat(skel,mot3);
mot3.boundingBox= computeBoundingBox(mot3);
mot3=convert2quat(skel,mot3);


