function dist = feature_detPointPlane(mot,p1_name,p2_name,p3_name,q_name)
p1 = trajectoryID(mot,p1_name);
p2 = trajectoryID(mot,p2_name);
p3 = trajectoryID(mot,p3_name);
q = trajectoryID(mot,q_name);
dist = zeros(mot.nframes,1);
for k = 1:mot.nframes
    M = [mot.jointTrajectories{p1}(:,k) mot.jointTrajectories{p2}(:,k) mot.jointTrajectories{p3}(:,k) mot.jointTrajectories{q}(:,k);  1 1 1 1];
    dist(k) = det(M);
end
