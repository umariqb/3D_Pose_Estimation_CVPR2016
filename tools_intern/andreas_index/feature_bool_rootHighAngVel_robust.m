function feature = feature_bool_rootHighAngVel_robust(mot)

%humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

q = quatrot(repmat([1;0;0],1,mot.nframes),mot.rotationQuat{1});
% projection onto xz-plane
u = q([1,3],2:end);
% 
v = q([1,3],1:end-1);

u_length = sqrt(sum(u.^2));
v_length = sqrt(sum(v.^2));

angVelRoot = real(acosd(dot(u,v)./(u_length.*v_length)))/mot.frameTime;
angVelRoot(end+1) = 0;
% angular velocity in degrees per second.


thresh1 = 50.0; 
thresh2 = 100.0;

f1 = angVelRoot >= thresh1;%*humerus_length;
f2 = angVelRoot >= thresh2;%*humerus_length;

feature = features_combine_robust(f1,f2);
