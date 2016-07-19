function dist = feature_distPointNormalPlane(mot,p1_name,p2_name,p3_name,q_name)
% p1 and p2 define a normal vector n pointing towards p2
% p3 is the fixture point for the plane defined by n
% point q's oriented distance to this plane is returned.

if (ischar(p1_name))
    p1 = trajectoryID(mot,p1_name);
else
    p1 = mot.nameMap{p1_name,3};
end
if (ischar(p2_name))
    p2 = trajectoryID(mot,p2_name);
else
    p2 = mot.nameMap{p2_name,3};
end
if (ischar(p3_name))
    p3 = trajectoryID(mot,p3_name);
else
    p3 = mot.nameMap{p3_name,3};
end
if (ischar(q_name))
    q = trajectoryID(mot,q_name);
else
    q = mot.nameMap{q_name,3};
end

n = mot.jointTrajectories{p2} - mot.jointTrajectories{p1};
n = n./repmat(sqrt(sum(n.^2)),3,1);
dist = dot(n,mot.jointTrajectories{q}-mot.jointTrajectories{p3});
