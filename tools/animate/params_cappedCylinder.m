function [points1,points2] = params_cappedCylinder(mot,p1_name,p2_name,varargin)
% p1 and p2 define a line segment p1p2.
%
% function returns the two endpoints of the line segment

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

points1 = mot.jointTrajectories{p1};
points2 = mot.jointTrajectories{p2};