function q = rotquat(alpha,axis)
% q = rotquat(alpha,axis)
% Returns a quaternion describing a rotation about one of the basis axes
%
% Input:    alpha, the rotation angle in radians.
%           axis, a string, either 'x', 'y', or 'z' denoting the axis of rotation
%
% Output:   q, corresponding quaternion

calpha = cos(alpha/2);
salpha = sin(alpha/2);
n = length(alpha);

axis = lower(axis);
switch(axis)
case 'x'
    q = [calpha;salpha;zeros(1,n);zeros(1,n)];
case 'y'
    q = [calpha;zeros(1,n);salpha;zeros(1,n)];
case 'z'
    q = [calpha;zeros(1,n);zeros(1,n);salpha];
otherwise
    error('Axis must be either x, y or z!')
end