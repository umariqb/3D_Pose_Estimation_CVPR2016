function P = quatlog(varargin)
% P = quatlog(Q, tol)
% Quaternionic logarithm, without (Grassia's) scaling factor of 2.
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
        tol = 10 * eps;
    case 2
        Q = varargin{1};
        tol = varargin{2};
    otherwise
        error('Wrong number of arguments.');
end

P = quatlog_rot(Q,tol)/2;