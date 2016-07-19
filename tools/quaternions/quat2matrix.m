function R = quat2matrix(Q)
% R = quat2matrix(Q)
% Converts quaternions to the corresponding rotation matrix
% representations.
%
% Input:    Q, 4xn array of quaterions
%
% Output:   R, 3x3xn array of rotation matrices
%
% Reference: Shoemake(1985)
%
% Remark:   Shoemake uses the quaternion rotation formula x' = q^{-1}xq.
%           We use the more common convention x' = qxq^{-1}. This leads to
%           transposed matrices (opposed to Shoemake's formulas), or,
%           equivalently, inverted quaternion representations.

n = size(Q,2);

Q = quatnormalize(Q);

R = zeros(3,3,n);
w = Q(1,:);
x = Q(2,:);
y = Q(3,:);
z = Q(4,:);

R(1,1,:) = 1 - 2*y.^2 - 2*z.^2;
R(2,1,:) = 2*x.*y + 2*w.*z;
R(3,1,:) = 2*x.*z - 2*w.*y;
R(1,2,:) = 2*x.*y - 2*w.*z;
R(2,2,:) = 1 - 2*x.^2 - 2*z.^2;
R(3,2,:) = 2*y.*z + 2*w.*x;
R(1,3,:) = 2*x.*z + 2*w.*y;
R(2,3,:) = 2*y.*z - 2*w.*x;
R(3,3,:) = 1 - 2*x.^2 - 2*y.^2;