function area = feature_areaTriangle(mot,p1_name,p2_name,p3_name)
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

d1 = mot.jointTrajectories{p1} - mot.jointTrajectories{p3};
d2 = mot.jointTrajectories{p2} - mot.jointTrajectories{p3}; 

area = sqrt(sum(cross(d1,d2).^2)) / 2;
