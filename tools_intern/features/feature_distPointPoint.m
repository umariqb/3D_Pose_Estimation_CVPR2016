function dist = feature_distPointPoint(skel,mot,p_name,q_name)
p = trajectoryID(skel,p_name);
q = trajectoryID(skel,q_name);

d = mot.jointTrajectories{p}-mot.jointTrajectories{q};
dist = sqrt(sum(d.^2));
