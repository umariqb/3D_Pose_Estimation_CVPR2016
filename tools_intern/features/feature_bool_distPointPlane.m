function dist = feature_bool_distPointPlane(mot,p1_name,p2_name,p3_name,q_name,varargin)
% Feature value 0: point q is behind the oriented plane spanned by points (p1,p2,p3)
% Feature value 1: point q is in front of the oriented plane spanned by points (p1,p2,p3)

if (nargin<=5)
    thresh = 0;
else
    thresh = varargin{1};
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

d1 = mot.jointTrajectories{p1} - mot.jointTrajectories{p3};
d2 = mot.jointTrajectories{p2} - mot.jointTrajectories{p3}; 

n = cross(d1,d2);
n = n./repmat(sqrt(sum(n.^2)),3,1);
dist = dot(n,mot.jointTrajectories{q}-mot.jointTrajectories{p3}) >= thresh;
