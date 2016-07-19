function [fixture,n,min_radius] = params_planePointNormal(mot,p1_name,p2_name,p3_name,q_name,d,varargin)
% p1 and p2 define the normal of an oriented plane.
% p3+offset is the fixture point for the plane.
% q is the point that is tested against this plane
% d is the offset distance for the plane in the direction of n.
% optional argument offset is a 3-vector denoting an offset to be added to the fixture point during min_radius calculation
%
% function returns sequence of fixture points and unit normals along with 
% minimum radii that make sense to visualize position of q in relation to the plane.

offset = [0;0;0];
if (nargin>6)
    offset = varargin{1};
end

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

% points = mot.jointTrajectories{p3}+n*d;
% 
% fixture = mot.jointTrajectories{p3}+repmat(offset,1,mot.nframes);
% dist = dot(n,mot.jointTrajectories{q}-fixture);
% q_proj = mot.jointTrajectories{q} - repmat(dist,3,1).*n;
% 
% min_radius = sqrt(sum((fixture-q_proj).^2));

offset = repmat(offset,1,mot.nframes) - repmat(dot(n,repmat(offset,1,mot.nframes)),3,1).*n;
%points = mot.jointTrajectories{p1} + n*d;
fixture = mot.jointTrajectories{p3}+offset  + n*d;

dist_q = dot(n,mot.jointTrajectories{q}-fixture);
dist_p3 = dot(n,mot.jointTrajectories{p3}-fixture);
q_proj = mot.jointTrajectories{q} - repmat(dist_q,3,1).*n;
p3_proj = mot.jointTrajectories{p3} - repmat(dist_p3,3,1).*n;
radius_q = sqrt(sum((fixture-q_proj).^2));
radius_p3 = sqrt(sum((fixture-p3_proj).^2));

min_radius = max([radius_q; radius_p3]);

