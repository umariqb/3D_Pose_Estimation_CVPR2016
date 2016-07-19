function angle = feature_angleVectorNormalPlane(mot,p1_name,p2_name,v)

p1 = trajectoryID(mot,p1_name);
p2 = trajectoryID(mot,p2_name);

d = mot.jointTrajectories{p2} - mot.jointTrajectories{p1};
d = d./repmat(sqrt(sum(d.^2)),3,1);
angle = real(acos(dot(d,repmat(v,1,mot.nframes)))*180/pi);
