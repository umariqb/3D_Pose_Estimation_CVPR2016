function mot = addAngVelToMot(mot)

q = quatrot(repmat([1;0;0],1,mot.nframes),mot.rotationQuat{1});
% projection onto xz-plane
u = q([1,3],2:end);
% 
v = q([1,3],1:end-1);

u_length = sqrt(sum(u.^2));
v_length = sqrt(sum(v.^2));

angles = real(acosd(dot(u,v)./(u_length.*v_length)));

mot.rootAngularVelocities = angles / mot.frameTime;