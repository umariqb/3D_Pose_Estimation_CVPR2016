function R = rotmatrix(alpha,axis)
% R = rotmatrix(alpha,axis)
% Returns a rotation matrix describing a rotation about one of the basis axes
%
% Input:    alpha, the rotation angle in radians.
%           axis, a string, either 'x', 'y', or 'z' denoting the axis of rotation
%
% Output:   R, corresponding rotation matrix

calpha = cos(alpha);
salpha = sin(alpha);

axis = lower(axis);
switch(axis)
case 'x'
    R = [1 0 0; 0 calpha -salpha; 0 salpha calpha];
case 'y'
    R = [calpha 0 salpha; 0 1 0; -salpha 0 calpha];
case 'z'
    R = [calpha -salpha 0; salpha calpha 0; 0 0 1];
otherwise
    error('Axis must be either x, y or z!')
end