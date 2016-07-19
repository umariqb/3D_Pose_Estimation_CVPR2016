function R = bisectS3(varargin)
% R = bisectS3(P,Q,tol)
%
% Compute the bisector quaternion between two quaternions on S3.
%
% Input:    * P,Q are sequences of quaternions represented as 4xn matrices.
%             Non-unit quaternions might be normalized prior to
%             interpolation, see next point.
%           * If tol is specified, it denotes the allowable deviation from unit 
%             length for the input quaternions. Deviations less than tol will
%             lead to re-normalization, deviations larger than tol will lead
%             to re-normalization and a warning. If tol is not specified,
%             all deviations larger than the machine precision will lead to
%             an error.
%
% Output:   R, 4xn matrix of quaternions representing the bisectors of (P(:,i),Q(:,i))

switch (nargin)
    case 2
        P = varargin{1};
        Q = varargin{2};
        tol = 10*eps;
        error_on_deviations = true;
    case 3
        P = varargin{1};
        Q = varargin{2};
        tol = varargin{3};
        error_on_deviations = false;
    otherwise
        error('Wrong number of arguments.');
end

if (size(P,1)~=4 || size(Q,1)~=4 || (size(P,2) ~= size(Q,2)))
    error('Input arrays: wrong dimensions.');
end

nsq = sum(P.^2);
deviating = find(abs(nsq - 1)>tol);
if (length(deviating)>0)
    deviating
    if (error_on_deviations)
        error('The input quaternions in P with the above indices are not of unit length!');
    else
        warning('The input quaternions in P with the above indices are not of unit length!');
    end
    P(:,deviating) = P(:,deviating)./repmat(sqrt(nsq(deviating)),4,1); % normalization of deviating quats
end

nsq = sum(Q.^2);
deviating = find(abs(nsq - 1)>tol);
if (length(deviating)>0)
    deviating
    if (error_on_deviations)
        error('The input quaternions with the above indices are not of unit length!');
    else
        warning('The input quaternions with the above indices are not of unit length!');
    end
    Q(:,deviating) = Q(:,deviating)./repmat(sqrt(nsq(deviating)),4,1); % normalization of deviating quats
end

R = (P+Q)./repmat(sqrt(quatnormsq(P+Q)),4,1);