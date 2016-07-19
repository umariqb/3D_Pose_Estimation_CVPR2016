function points = params_point(mot,p1_name)

if (ischar(p1_name))
    p1 = trajectoryID(mot,p1_name);
else
    p1 = mot.nameMap{p1_name,3};
end

points = mot.jointTrajectories{p1};