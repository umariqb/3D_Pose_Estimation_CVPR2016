function e = quat2euler(varargin)
% e = quat2euler(q)
% Converts quaternions to euler angles.
% 
% Input:    * q, a 4xn array of quaternions
%             Example: e = quat2euler(q)
%           
%           * optional string denoting rotation order, where the reference
%             coordinate system for successive basic rotations are assumed to
%             be attached to the rotating object => rotation matrices are
%             multiplied from left to right (unlike basis rotations expressed in 
%             the static world frame). All coordinate systems are
%             right-handed.
%             Example: q = quat2euler(q, 'xyz'). 
%             Default is 'zxy'.
% 
% Output:   3xn array of corresponding euler angles
%
% Reference: Shoemake(1985)
%
% Remark:   Shoemake uses the quaternion rotation formula x' = q^{-1}xq.
%           We use the more common convention x' = qxq^{-1}. This leads to
%           transposed matrices (opposed to Shoemake's formulas), or,
%           equivalently, inverted quaternion representations.
%
%           Here is OUR quat->matrix conversion:
%
%                       ( 1 - 2y^2 - 2z^2     2xy - 2wz        2xz + 2wy    )
%           R(w,x,y,z)= (    2xy + 2wz     1 - 2x^2 - 2z^2     2yz - 2wx    )
%                       (    2xz - 2wy        2yz + 2wx     1 - 2x^2 - 2y^2 )

switch nargin
    case 1
        q = varargin{1};
        rotation_order = 'zxy';
    case 2
        q = varargin{1};
        rotation_order = varargin{2};
    otherwise
        error('Wrong number of arguments.');
end

q = quatnormalize(q); % normalization

w = q(1,:);
x = q(2,:);
y = q(3,:);
z = q(4,:);

switch (lower(rotation_order))
    case 'zyx'
	% zyx rotation order:            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % z axis -> first angle (sf,cf)
    % y axis -> second angle (ss,cs)
    % x axis -> third angle (st,ct)
    %
	%      ( cf*cs   -sf*ct+cf*ss*st   sf*st+cf*ss*ct )
	% R =  ( sf*cs   cf*ct+sf*ss*st   -cf*st+sf*ss*ct )
	%      ( -ss         cs*st         cs*ct          )
	%
        sinsecond_angle = -(2*x.*z - 2*w.*y); % minus pos (3,1) in quat->matrix conversion
		cossecond_angle_sq = 1 - sinsecond_angle.^2;
		
		i = find(abs(cossecond_angle_sq)>=10*eps);
		if (length(i)>0)
            scthird_angle(i) = 2*y(i).*z(i) + 2*w(i).*x(i); % pos (3,2) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*x(i).^2 - 2*y(i).^2); % pos (3,3) in quat->matrix conversion
            scfirst_angle(i) = 2*x(i).*y(i) + 2*w(i).*z(i); % pos (2,1) in quat->matrix conversion
            ccfirst_angle(i) = (1 - 2*y(i).^2 - 2*z(i).^2); % pos (1,1) in quat->matrix conversion
		end
		
		i = find(abs(cossecond_angle_sq)<10*eps);
		if (length(i)>0)
            scthird_angle(i) = 2*x(i).*y(i) - 2*w(i).*z(i); % pos (1,2) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*x(i).^2 - 2*z(i).^2); % pos (2,2) in quat->matrix conversion
            scfirst_angle(i) = 0;
            ccfirst_angle(i) = 1;
		end
		
		e = zeros(3,size(q,2));
		e(1,:) = atan2(scfirst_angle,ccfirst_angle);
		e(2,:) = asin(sinsecond_angle);
		e(3,:) = atan2(scthird_angle,ccthird_angle);
        
    case 'xzy'
	% xzy rotation order:            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % x axis -> first angle (sf,cf)
    % z axis -> second angle (ss,cs)
    % y axis -> third angle (st,ct)
    %
	%      ( cs*ct              -ss             cs*st     )
	% R =  ( sf*st+cf*ss*ct    cf*cs      -sf*ct+cf*ss*st )
	%      ( -cs*st+sf*ss*ct   sf*cs       cf*ct+sf*ss*st )
	%
        sinsecond_angle = -(2*x.*y - 2*w.*z); % minus pos (1,2) in quat->matrix conversion
		cossecond_angle_sq = 1 - sinsecond_angle.^2;
		
		i = find(abs(cossecond_angle_sq)>=10*eps);
		if (length(i)>0)
            scthird_angle(i) = 2*x(i).*z(i) + 2*w(i).*y(i); % pos (1,3) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*y(i).^2 - 2*z(i).^2); % pos (1,1) in quat->matrix conversion
            scfirst_angle(i) = 2*y(i).*z(i) + 2*w(i).*x(i); % pos (3,2) in quat->matrix conversion
            ccfirst_angle(i) = (1 - 2*x(i).^2 - 2*z(i).^2); % pos (2,2) in quat->matrix conversion
		end
		
		i = find(abs(cossecond_angle_sq)<10*eps);
		if (length(i)>0)
            scthird_angle(i) = 2*y(i).*z(i) - 2*w(i).*x(i); % pos (2,3) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*x(i).^2 - 2*y(i).^2); % pos (3,3) in quat->matrix conversion
            scfirst_angle(i) = 0;
            ccfirst_angle(i) = 1;
		end
		
		e = zeros(3,size(q,2));
		e(1,:) = atan2(scfirst_angle,ccfirst_angle);
		e(2,:) = asin(sinsecond_angle);
		e(3,:) = atan2(scthird_angle,ccthird_angle);
        
    case 'yxz'
	% yxz rotation order:            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % y axis -> first angle (sf,cf)
    % x axis -> second angle (ss,cs)
    % z axis -> third angle (st,ct)
    %
	%      ( cf*ct+sf*ss*st     -cs*st+sf*ss*ct      sf*cs )
	% R =  ( cs*st             cs*ct                 -ss   )
	%      ( -sf*ct+cf*ss*st   sf*st+cf*ss*ct        cf*cs )
	%
        sinsecond_angle = -(2*y.*z - 2*w.*x); % minus pos (2,3) in quat->matrix conversion
		cossecond_angle_sq = 1 - sinsecond_angle.^2;
		
		i = find(abs(cossecond_angle_sq)>=10*eps);
		if (length(i)>0)
            scthird_angle(i) = 2*x(i).*y(i) + 2*w(i).*z(i); % pos (2,1) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*x(i).^2 - 2*z(i).^2); % pos (2,2) in quat->matrix conversion
            scfirst_angle(i) = 2*x(i).*z(i) + 2*w(i).*y(i); % pos (1,3) in quat->matrix conversion
            ccfirst_angle(i) = (1 - 2*x(i).^2 - 2*y(i).^2); % pos (3,3) in quat->matrix conversion
		end
		
		i = find(abs(cossecond_angle_sq)<10*eps);
		if (length(i)>0)
            scthird_angle(i) = 2*x(i).*z(i) - 2*w(i).*y(i); % pos (3,1) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*y(i).^2 - 2*z(i).^2); % pos (1,1) in quat->matrix conversion
            scfirst_angle(i) = 0;
            ccfirst_angle(i) = 1;
		end
		
		e = zeros(3,size(q,2));
		e(1,:) = atan2(scfirst_angle,ccfirst_angle);
		e(2,:) = asin(sinsecond_angle);
		e(3,:) = atan2(scthird_angle,ccthird_angle);
        
    case 'zxy'
	% zxy rotation order:            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % z axis -> first angle (sf,cf)
    % x axis -> second angle (ss,cs)
    % y axis -> third angle (st,ct)
    %
	%      ( cf*ct-sf*ss*st   -sf*cs   cf*st+sf*ss*ct )
	% R =  ( sf*ct+cf*ss*st    cf*cs   sf*st-cf*ss*ct )
	%      ( -cs*st            ss      cs*ct          )
	%
		sinsecond_angle = (2*y.*z + 2*w.*x); % pos (3,2) in quat->matrix conversion
		cossecond_angle_sq = 1 - sinsecond_angle.^2;
		
		i = find(abs(cossecond_angle_sq)>=10*eps);
		if (length(i)>0)
            scthird_angle(i) = -(2*x(i).*z(i) - 2*w(i).*y(i)); % minus pos (3,1) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*x(i).^2 - 2*y(i).^2); % pos (3,3) in quat->matrix conversion
            scfirst_angle(i) = -(2*x(i).*y(i) - 2*w(i).*z(i)); % minus pos (1,2) in quat->matrix conversion
            ccfirst_angle(i) = (1 - 2*x(i).^2 - 2*z(i).^2); % pos (2,2) in quat->matrix conversion
		end
		
		i = find(abs(cossecond_angle_sq)<10*eps);
		if (length(i)>0)
            scthird_angle(i) = -(1 - 2*y(i).^2 - 2*z(i).^2); % minus pos (1,1) in quat->matrix conversion
            ccthird_angle(i) = 2*x(i).*y(i) + 2*w(i).*z(i); % pos (2,1) in quat->matrix conversion
            scfirst_angle(i) = 0;
            ccfirst_angle(i) = 1;
		end
		
		e = zeros(3,size(q,2));
		e(1,:) = atan2(scfirst_angle,ccfirst_angle);
		e(2,:) = asin(sinsecond_angle);
		e(3,:) = atan2(scthird_angle,ccthird_angle);
        
    case 'yzx'
	% yzx rotation order:            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % y axis -> first angle (sf,cf)
    % z axis -> second angle (ss,cs)
    % x axis -> third angle (st,ct)
    %
   	%      (  cf*cs    sf*st-cf*ss*ct   sf*ct+cf*ss*st )
	% R =  (  ss           cs*ct          -cs*st       )
	%      ( -sf*cs    cf*st+sf*ss*ct   cf*ct-sf*ss*st )
	%
		sinsecond_angle = (2*x.*y + 2*w.*z); % pos (2,1) in quat->matrix conversion
		cossecond_angle_sq = 1 - sinsecond_angle.^2;
		
		i = find(abs(cossecond_angle_sq)>=10*eps);
		if (length(i)>0)
            scthird_angle(i) = -(2*y(i).*z(i) - 2*w(i).*x(i)); % minus pos (2,3) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*x(i).^2 - 2*z(i).^2); % pos (2,2) in quat->matrix conversion
            scfirst_angle(i) = -(2*x(i).*z(i) - 2*w(i).*y(i)); % minus pos (3,1) in quat->matrix conversion
            ccfirst_angle(i) = (1 - 2*y(i).^2 - 2*z(i).^2); % pos (1,1) in quat->matrix conversion
		end
		
		i = find(abs(cossecond_angle_sq)<10*eps);
		if (length(i)>0)
            scthird_angle(i) = 2*y(i).*z(i) + 2*w(i).*x(i); % pos (3,2) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*x(i).^2 - 2*y(i).^2); % pos (3,3) in quat->matrix conversion
            scfirst_angle(i) = 0;
            ccfirst_angle(i) = 1;
		end
		
		e = zeros(3,size(q,2));
		e(1,:) = atan2(scfirst_angle,ccfirst_angle);
		e(2,:) = asin(sinsecond_angle);
		e(3,:) = atan2(scthird_angle,ccthird_angle);
        
    case 'xyz'
	% xyz rotation order:            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % x axis -> first angle (sf,cf)
    % y axis -> second angle (ss,cs)
    % z axis -> third angle (st,ct)
    %
   	%      (    cs*ct             -cs*st          ss   )
	% R =  ( cf*st+sf*ss*ct    cf*ct-sf*ss*st   -sf*cs )
	%      ( sf*st-cf*ss*ct    sf*ct+cf*ss*st   cf*cs  )
	%
    
		sinsecond_angle = (2*x.*z + 2*w.*y); % pos (1,3) in quat->matrix conversion
		cossecond_angle_sq = 1 - sinsecond_angle.^2;
		
		i = find(abs(cossecond_angle_sq)>=10*eps);
		if (length(i)>0)
            scthird_angle(i) = -(2*x(i).*y(i) - 2*w(i).*z(i)); % minus pos (1,2) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*y(i).^2 - 2*z(i).^2); % pos (1,1) in quat->matrix conversion
            scfirst_angle(i) = -(2*y(i).*z(i) - 2*w(i).*x(i)); % minus pos (2,3) in quat->matrix conversion
            ccfirst_angle(i) = (1 - 2*x(i).^2 - 2*y(i).^2); % pos (3,3) in quat->matrix conversion
		end
		
		i = find(abs(cossecond_angle_sq)<10*eps);
		if (length(i)>0)
            scthird_angle(i) = 2*x(i).*y(i) + 2*w(i).*z(i); % pos (2,1) in quat->matrix conversion
            ccthird_angle(i) = (1 - 2*x(i).^2 - 2*z(i).^2); % pos (2,2) in quat->matrix conversion
            scfirst_angle(i) = 0;
            ccfirst_angle(i) = 1;
		end
		
		e = zeros(3,size(q,2));
		e(1,:) = atan2(scfirst_angle,ccfirst_angle);
		e(2,:) = asin(sinsecond_angle);
		e(3,:) = atan2(scthird_angle,ccthird_angle);
        
%     case 'xyx'
%                       ( 1 - 2y^2 - 2z^2     2xy - 2wz        2xz + 2wy    )
%           R(w,x,y,z)= (    2xy + 2wz     1 - 2x^2 - 2z^2     2yz - 2wx    )
%                       (    2xz - 2wy        2yz + 2wx     1 - 2x^2 - 2y^2 )
%     case 'yxy'
%     case 'xzx'
%     case 'zxz'
%     case 'yzy'
%     case 'zyz'
        
    otherwise
        error('Invalid or so far unimplemented rotation order!');
end