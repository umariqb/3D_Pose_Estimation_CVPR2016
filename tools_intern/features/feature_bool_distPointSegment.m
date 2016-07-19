function [feature,d] = feature_bool_distPointSegment(mot,p1_name,p2_name,q_name,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if point q is within distance thresh from the line segment defined by p1 and p2.
%
% Feature value 0: q is not within distance r_lengths*thresh from line segment.
% Feature value 1: q is within distance r_lengths*thresh from line segment.
%
% Parameters:
% thresh..... distance threshold, measured relative to length of line segment p1p2. default is 0.2.
% use_balls.. boolean 2-vector indicating how to deal with distance calculation at segment ends. 
 %            Example: [1 1] means that both ends are to be capped with balls of radius r_lengths*thresh.

thresh = 0.2;
use_balls = [1 1];

if (nargin>5)
    use_balls = varargin{2};
end
if (nargin>4)
    thresh = varargin{1};
end

if (isnumeric(p1_name))
    p1 = p1_name;
else
    p1 = mot.jointTrajectories{trajectoryID(mot,p1_name)};
end
if (isnumeric(p2_name))
    p2 = p2_name;
else
    p2 = mot.jointTrajectories{trajectoryID(mot,p2_name)};
end
if (isnumeric(q_name))
    q = q_name;
else
    q = mot.jointTrajectories{trajectoryID(mot,q_name)};
end

r = p2 - p1;
r_lengths = sqrt(sum(r.^2));
r = r ./ repmat(r_lengths,3,1);

d = sqrt(sum(cross(q - p1,r,1).^2));

ind_before_p1 = find(dot(r, q - p1, 1) < 0);
ind_behind_p2 = find(dot(r, q - p2, 1) > 0);

if (use_balls(1))
    d(ind_before_p1) = sqrt(sum((q(:,ind_before_p1) - p1(:,ind_before_p1)).^2));
else
    d(ind_before_p1) = inf;
end
if (use_balls(2))
    d(ind_behind_p2) = sqrt(sum((q(:,ind_behind_p2) - p2(:,ind_behind_p2)).^2));
else
    d(ind_behind_p2) = inf;
end

feature = (d <= r_lengths*thresh);

%plot(feature); hold;
%plot(d,'red');
%plot(r_lengths*thresh,'black');