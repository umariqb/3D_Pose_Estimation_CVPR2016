function q = euler2quat(varargin)
% R = euler2quat(varargin)
% Converts Euler angles to quaternions.
% 
% Input:    * vectors "first_angle", "second_angle", "third_angle" of identical length, denoting euler angles
%             specified in radians. 
%             Example: R = euler2quat(first_angle,second_angle,third_angle)
%           * alternatively, 3xn matrix of euler angles specified in radians. 
%             Example: R = euler2quat(angle_data)
%           
%           * optional string denoting rotation order, where the reference
%             coordinate system for successive basic rotations are assumed to
%             be attached to the rotating object => rotation matrices are
%             multiplied from left to right (unlike basis rotations expressed in 
%             the static world frame). All coordinate systems are
%             right-handed.
%             Example: R = euler2quat(angle_data, 'xyz'). 
%             Default is 'zxy'.
% 
% Output:   4xn array of corresponding quaternions
%
% Reference: Shoemake(1985)
%
% Remark:   Shoemake uses the quaternion rotation formula x' = q^{-1}xq.
%           We use the more common convention x' = qxq^{-1}. This leads to
%           transposed matrices (opposed to Shoemake's formulas), or,
%           equivalently, inverted quaternion representations.
%
%           Here is our quat->matrix conversion:
%
%                       ( 1 - 2y^2 - 2z^2     2xy - 2wz        2xz + 2wy    )
%           R(w,x,y,z)= (    2zy + 2wz     1 - 2x^2 - 2z^2     2yz - 2wx    )
%                       (    2xz - 2wy        2yz + 2wx     1 - 2x^2 - 2y^2 )

switch nargin
    case 1
        M = varargin{1};
        first_angle = M(1,:);
        second_angle = M(2,:);
        third_angle =  M(3,:);
        rotation_order = 'zxy';
    case 2
        M = varargin{1};
        first_angle = M(1,:);
        second_angle = M(2,:);
        third_angle =  M(3,:);
        rotation_order = lower(varargin{2});
    case 3
        first_angle = varargin{1};
        second_angle = varargin{2};
        third_angle = varargin{3};
        rotation_order = 'zxy';
    case 4
        first_angle = varargin{1};
        second_angle = varargin{2};
        third_angle = varargin{3};
        rotation_order = lower(varargin{4});
    otherwise
        error('Wrong number of arguments.');
end

n = size(first_angle,2);
q = zeros(4,n);

% q = matrix2quat(euler2matrix(first_angle,second_angle,third_angle,rotation_order)); 

switch rotation_order
    case 'zyx'
        q = quatmult(quatmult(rotquat(first_angle,'z'),rotquat(second_angle,'y')),rotquat(third_angle,'x'));
    case 'xzy'
        q = quatmult(quatmult(rotquat(first_angle,'x'),rotquat(second_angle,'z')),rotquat(third_angle,'y'));
    case 'yxz'
        q = quatmult(quatmult(rotquat(first_angle,'y'),rotquat(second_angle,'x')),rotquat(third_angle,'z'));
    case 'zxy'
        q = quatmult(quatmult(rotquat(first_angle,'z'),rotquat(second_angle,'x')),rotquat(third_angle,'y'));
    case 'yzx'
        q = quatmult(quatmult(rotquat(first_angle,'y'),rotquat(second_angle,'z')),rotquat(third_angle,'x'));
    case 'xyz'
        q = quatmult(quatmult(rotquat(first_angle,'x'),rotquat(second_angle,'y')),rotquat(third_angle,'z'));
    case 'xyx'
        q = quatmult(quatmult(rotquat(first_angle,'x'),rotquat(second_angle,'y')),rotquat(third_angle,'x'));
    case 'yxy'
        q = quatmult(quatmult(rotquat(first_angle,'y'),rotquat(second_angle,'x')),rotquat(third_angle,'y'));
    case 'xzx'
        q = quatmult(quatmult(rotquat(first_angle,'x'),rotquat(second_angle,'z')),rotquat(third_angle,'x'));
    case 'zxz'
        q = quatmult(quatmult(rotquat(first_angle,'z'),rotquat(second_angle,'x')),rotquat(third_angle,'z'));
    case 'yzy'
        q = quatmult(quatmult(rotquat(first_angle,'y'),rotquat(second_angle,'z')),rotquat(third_angle,'y'));
    case 'zyz'
        q = quatmult(quatmult(rotquat(first_angle,'z'),rotquat(second_angle,'y')),rotquat(third_angle,'z'));
    otherwise
        error('Invalid rotation order!');
end

% remove discontinuities in quaternion path
sg = ones(1,n);
s = 1;
for i=2:n
    q1 = q(:,i-1);
    q2 = q(:,i);
    if (quatnormsq(q2-q1)>quatnormsq(-q2-q1))
        s = -s;
    end
    sg(i)=s;
end
q = repmat(sg,4,1).*q;