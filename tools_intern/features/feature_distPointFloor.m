function dist = feature_distPointFloor(mot,p_name)
p = trajectoryID(mot,p_name);

y_min = mot.boundingBox(3);

dist =  mot.jointTrajectories{p}(2,:) - y_min;

