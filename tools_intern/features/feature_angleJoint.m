function a = feature_angleJoint(mot,p1_name,p2_name,q_name)
p1 = trajectoryID(mot,p1_name);
p2 = trajectoryID(mot,p2_name);
q = trajectoryID(mot,q_name);
a = zeros(mot.nframes,1);
d1 = mot.jointTrajectories{p1} - mot.jointTrajectories{q};
d1 = d1./repmat(sqrt(sum(d1.^2)),3,1);
d2 = mot.jointTrajectories{p2} - mot.jointTrajectories{q};
d2 = d2./repmat(sqrt(sum(d2.^2)),3,1);
cosalpha = dot(d1,d2);
a = real(acos(cosalpha)*180/pi);
% 150° as threshold for stretched elbow might be a suitable value
