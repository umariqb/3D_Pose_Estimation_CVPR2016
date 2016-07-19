function [feature,d] = feature_bool_distPointPoint(mot,p_name,q_name,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if points p and q are within distance thresh.
%
% Feature value 0: q is not within distance thresh from p.
% Feature value 1: q is within distance thresh from p.
%
% Parameters:
% thresh .... distance threshold, measured relative to length of lfemur. default is 0.2.

if (nargin<=1)
    thresh = 0.2;
else
    thresh = varargin{1};
end

if (isnumeric(p1_name))
    p = p_name;
else
    p = mot.jointTrajectories{trajectoryID(mot,p_name)};
end
if (isnumeric(q_name))
    q = q_name;
else
    q = mot.jointTrajectories{trajectoryID(mot,q_name)};
end

femur_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1)).^2));

d = sqrt(sum((q - p).^2));

feature = (d <= femur_length*thresh);

%plot(feature); hold;
%plot(d,'red');
%plot(femur_length*thresh,'black');