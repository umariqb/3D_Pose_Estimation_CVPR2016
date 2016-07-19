function d = distS3_log(varargin)
% Q = distS3_log(q1,q2,tol)
% Computes the spherical distance between q1 and q2 using the quaternionic logarithm.
%
% Input:    * q1,q2 are sequences of quaternions represented as 4xn matrices.
%             Non-unit quaternions might be normalized prior to
%             interpolation, see next point.
%           * If tol is specified, it denotes the allowable deviation from unit 
%             length for the input quaternions. Deviations less than tol will
%             lead to re-normalization, deviations larger than tol will lead
%             to re-normalization and a warning. If tol is not specified,
%             all deviations larger than the machine precision will lead to
%             an error.
%
% Output:   d is a 1xn vector of distances, where d(i) is the spherical distance 
%           between q1(:,i) and q2(:,i)

switch (nargin)
    case 2
        q1 = varargin{1};
        q2 = varargin{2};
        tol = 10*eps;
        error_on_deviations = true;
    case 3
        q1 = varargin{1};
        q2 = varargin{2};
        tol = varargin{3};
        error_on_deviations = false;
    otherwise
        error('Wrong number of arguments.');
end

if (size(q1,1)~=4 || size(q2,1)~=4 || (size(q1,2) ~= size(q2,2)))
    error('Input arrays: wrong dimensions.');
end

n = size(q1,2);

p = quatmult(quatinv(q1),q2);

%%%%%%%%%%% now compute the log of p, omitting the error message for south pole quats %%%%%%%%%%%%%%%%%%%%
cos_theta_over_two = p(1,:); % quaternion real part = cos(theta/2)

theta = 2*acos(cos_theta_over_two);

zero = find(theta<eps^(1/4)); num_zero = length(zero); % identify near-zero thetas
nonzero = find(theta>=eps^(1/4)); % identify nonzero thetas
twopi = find(abs(theta-2*pi)<eps); % identify thetas near 2*pi
zero = setdiff(zero,twopi);               % thetas near 2*pi are masked out of the other cases
nonzero = setdiff(nonzero,twopi);      % thetas near 2*pi are masked out of the other cases

d = zeros(3,n);
if length(zero>0)
    d(:,zero) = p(2:4,zero) ./ repmat((0.5 + (1/48)*theta(zero).^2),3,1); % use first two terms of sinc taylor expansion
end
if length(nonzero>0)
    d(:,nonzero) = p(2:4,nonzero) ./ repmat(sin(0.5*theta(nonzero)),3,1).*repmat(theta(nonzero),3,1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

d = sqrt(sum(d.*d));
d = d/2; % compensate for angle-doubling effect

if length(twopi>0)
    d(:,twopi) = pi;
end



