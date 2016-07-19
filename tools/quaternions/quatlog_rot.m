function P = quatlog_rot(varargin)
% P = quatlog_rot(Q, tol)
% Implementation according to Grassia (1998)
%
% input:    Q is a 4xn array of quaternions represented as column vectors.
%           If tol is specified, it denotes the allowable deviation from unit 
%           length for the input quaternions. Deviations less than tol will
%           lead to re-normalization, deviations larger than tol will lead
%           to re-normalization and a warning. If tol is not specified,
%           all deviations larger than the machine precision will lead to
%           an error.
%
% output:   P(:,i) is a 3-vector, the quaternionic logarithm of the
%           quaternion Q(:,i)

switch (nargin)
    case 1
        Q = varargin{1};
        tol = 10*eps;
        error_on_deviations = true;
    case 2
        Q = varargin{1};
        tol = varargin{2};
        error_on_deviations = false;
    otherwise
        error('Wrong number of arguments.');
end

if (size(Q,1)~=4)
    error('Input array: number of rows must be 4!');
end
n = size(Q,2);

nsq = sqrt(sum(Q.^2));
deviating = find(abs(nsq - 1)>tol);
if (~isempty(deviating))
%     deviating
    if (error_on_deviations)
        error('The input quaternions with the above indices are not of unit length!');
    else
        warning('The input quaternions with the above indices are not of unit length!');
    end
    Q(:,deviating) = Q(:,deviating)./repmat(sqrt(nsq(deviating)),4,1); % normalization of deviating quats
end

cos_theta_over_two = Q(1,:); % quaternion real part = cos(theta/2)

theta = 2*acos(cos_theta_over_two);

zero = find(theta<eps^(1/4)); num_zero = length(zero); % identify near-zero thetas
nonzero = find(theta>=eps^(1/4)); % identify nonzero thetas
twopi = find(abs(theta-2*pi)<eps); % identify thetas near 2*pi
zero = setdiff(zero,twopi);               % thetas near 2*pi are masked out of the other cases
nonzero = setdiff(nonzero,twopi);      % thetas near 2*pi are masked out of the other cases

P = zeros(3,n);
if ~isempty(zero>0)
    P(:,zero) = Q(2:4,zero) ./ repmat((0.5 + (1/48)*theta(zero).^2),3,1); % use first two terms of sinc taylor expansion
end
if ~isempty(nonzero>0)
    P(:,nonzero) = Q(2:4,nonzero) ./ repmat(sin(0.5*theta(nonzero)),3,1).*repmat(theta(nonzero),3,1);
end
if ~isempty(twopi>0)
%     twopi
    warning('The input quaternions with the above indices are at the south pole => log undefined!');
    P(:,twopi) = NaN;
end