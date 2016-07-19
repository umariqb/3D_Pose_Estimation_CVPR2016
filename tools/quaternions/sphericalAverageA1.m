function [q,iterations] = sphericalAverageA1(varargin)
% q = sphericalAverageA1(P,w,max_error,max_iterations)
% Computes the spherical weighted average of n unit quaternions using
% algorithm A1 from Buss/Fillmore (2001)
%
% Input:        P, 4xn array of unit quaternions.
%               w, weight array of length n, sum(w)=1.
%               max_error, error bound for loop termination, default = 1000*eps.
%               max_iterations, maximum number of iterations
%
% Output:       q, spherical average of the quaternions in q.
%               iterations, number of iterations.
%
% Reference: S. Buss, J. Fillmore: Spherical Averages and Applications to
% Spherical Splines and Interpolation, ACM Trans. Graphics 20 (2001):
% 95--126

switch(nargin)
    case 1
        P = varargin{1};
        w = (1/size(P,2))*ones(1,size(P,2));
        max_error = 1000*eps;
        max_iterations = inf;
    case 2
        P = varargin{1};
        w = varargin{2};
        max_error = 1000*eps;
        max_iterations = inf;
    case 3
        P = varargin{1};
        w = varargin{2};
        max_error = varargin{3};
        max_iterations = inf;
    case 4
        P = varargin{1};
        w = varargin{2};
        max_error = varargin{3};
        max_iterations = varargin{4};
    otherwise
        error('Wrong number of arguments.');
end

if (size(P,1)~=4)
    error('P must be a 4xn array!');
end
n = size(P,2);
if (size(w,1)~=1)
    error('Weights must be a row vector!');
end
if (size(w,2)~=n)
    error('#quaternions = #weights required!');
end
if (abs(sum(w)-1)>1000*eps)
    error('Sum of weights must be 1!');
end


q = sum(repmat(w,4,1).*P,2);
q = q/sqrt(quatnormsq(q));

norm_u = inf;
iterations = 0;
while (norm_u>max_error && iterations < max_iterations)
    Pstar = quatlog(quatmult(repmat(quatinv(q),1,n),P),max_error);
    u = sum(repmat(w,3,1).*Pstar,2);
%    disp(norm(u));
    q = quatmult(q,quatexp(u));
    iterations = iterations+1;
    norm_u = norm(u);
end

if (iterations==max_iterations)
    warning('Maximum number of iterations reached.');
end