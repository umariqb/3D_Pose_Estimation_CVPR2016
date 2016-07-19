function d = distS3(varargin)
% Q = distS3(q1,q2,tol)
% Computes the spherical distance between q1 and q2.
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

nsq = sum(q1.^2);
deviating = find(abs(nsq - 1)>tol);
if (length(deviating)>0)
    deviating;
    if (error_on_deviations)
        error('The input quaternions in q1 with the above indices are not of unit length!');
    else
%         warning('The input quaternions in q1 with the above indices are not of unit length!');
    end
    q1(:,deviating) = q1(:,deviating)./repmat(sqrt(nsq(deviating)),4,1); % normalization of deviating quats
end

nsq = sum(q2.^2);
deviating = find(abs(nsq - 1)>tol);
if (length(deviating)>0)
    deviating;
    if (error_on_deviations)
        error('The input quaternions in q2 with the above indices are not of unit length!');
    else
%         warning('The input quaternions in q2 with the above indices are not of unit length!');
    end
    q2(:,deviating) = q2(:,deviating)./repmat(sqrt(nsq(deviating)),4,1); % normalization of deviating quats
end

if (size(q1,1)~=4 || size(q2,1)~=4 || (size(q1,2) ~= size(q2,2)))
    error('Input arrays: wrong dimensions.');
end

d = acos(dot(q1,q2));

