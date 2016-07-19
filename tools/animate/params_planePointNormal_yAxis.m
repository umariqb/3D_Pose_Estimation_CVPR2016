function [points,n,min_radius] = params_planePointNormal_yAxis(mot,p3_name,q_name,d)
% The plane is defined as follows: 
% The normal n is the y axis
% p3 is the fixture point for the plane.
% q is the point that is tested against this plane
% d is the offset distance for the plane in the direction of n.
%
% function returns sequence of fixture points and unit normals along with 
% minimum radii that make sense to visualize position of q in relation to the plane.

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

n = repmat([0;1;0],1,mot.nframes);

points = mot.jointTrajectories{p3} + n*d;

min_radius = sqrt(sum((mot.jointTrajectories{p3}+n*d-mot.jointTrajectories{q}).^2));
