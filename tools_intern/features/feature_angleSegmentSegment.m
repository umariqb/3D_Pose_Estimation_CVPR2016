function alpha = feature_angleSegmentSegment(mot,p1_name,p2_name,p3_name,p4_name)
% Two directed segments are defined: s1=(p1-p2), s2=(p3-p4), where the direction is towards p1 or p3, respectively.
% The smaller of the enclosed angles between s1 and s2 is returned.

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
if (ischar(p4_name))
    p4 = trajectoryID(mot,p4_name);
else
    p4 = mot.nameMap{p4_name,3};
end

s1 = mot.jointTrajectories{p1} - mot.jointTrajectories{p2};
s2 = mot.jointTrajectories{p3} - mot.jointTrajectories{p4}; 
ns1 = sqrt(sum(s1.^2));
ns2 = sqrt(sum(s2.^2));

cosalpha = dot(s1,s2)./(ns1.*ns2);
alpha = real(acos(cosalpha)*180/pi);
