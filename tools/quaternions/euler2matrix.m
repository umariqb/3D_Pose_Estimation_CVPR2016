function R = euler2matrix(varargin)
% R = euler2matrix(varargin)
% 
% Input:    * vectors "first_angle", "second_angle", "third_angle" of identical length, denoting euler angles
%             specified in radians. 
%             Example: R = euler2matrix(first_angle,second_angle,third_angle)
%           * alternatively, 3xn matrix of euler angles specified in radians. 
%             Example: R = euler2matrix(angle_data)
%           
%           * optional string denoting rotation order, where the reference
%             coordinate system for successive basic rotations are assumed to
%             be attached to the rotating object => rotation matrices are
%             multiplied from left to right (unlike basis rotations expressed in 
%             the static world frame). All coordinate systems are
%             right-handed.
%             Example: R = euler2matrix(angle_data, 'xyz'). 
%             Default is 'zxy'.
% 
% Output:   3x3xn array of corresponding rotation matrices

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
R = zeros(3,3,n);

switch rotation_order
    case 'zyx'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'z')*rotmatrix(second_angle(i),'y')*rotmatrix(third_angle(i),'x');
        end
    case 'xzy'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'x')*rotmatrix(second_angle(i),'z')*rotmatrix(third_angle(i),'y');
        end
    case 'yxz'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'y')*rotmatrix(second_angle(i),'x')*rotmatrix(third_angle(i),'z');
        end
    case 'zxy'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'z')*rotmatrix(second_angle(i),'x')*rotmatrix(third_angle(i),'y');
        end
    case 'yzx'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'y')*rotmatrix(second_angle(i),'z')*rotmatrix(third_angle(i),'x');
        end
    case 'xyz'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'x')*rotmatrix(second_angle(i),'y')*rotmatrix(third_angle(i),'z');
        end
    case 'xyx'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'x')*rotmatrix(second_angle(i),'y')*rotmatrix(third_angle(i),'x');
        end
    case 'yxy'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'y')*rotmatrix(second_angle(i),'x')*rotmatrix(third_angle(i),'y');
        end
    case 'xzx'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'x')*rotmatrix(second_angle(i),'z')*rotmatrix(third_angle(i),'x');
        end
    case 'zxz'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'z')*rotmatrix(second_angle(i),'x')*rotmatrix(third_angle(i),'z');
        end
    case 'yzy'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'y')*rotmatrix(second_angle(i),'z')*rotmatrix(third_angle(i),'y');
        end
    case 'zyz'
        for i=1:n
            R(:,:,i) = rotmatrix(first_angle(i),'z')*rotmatrix(second_angle(i),'y')*rotmatrix(third_angle(i),'z');
        end
    otherwise
        error('Invalid rotation order!');
end