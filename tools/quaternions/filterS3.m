function [y,t] = filterS3(varargin)
% y = filterS3(b,quat_data,padding_method)
% Filters a sequence of unit quaternions using an orientation filter
%
% Input:        b, orientation filter constructed via orientationFilter().
%               quat_data, sequence of N unit quaternions represented as a 4xN array.
%               padding_method, string, either 'symmetric' or 'zero'
%
% Output:       y, Input quaternions filtered by the orientation filter b, represented as a 4xN array.
%               t, running time for filter.
%
% Remark:       Angular velocity is computed as omega = log((q_i)^{-1}q_{i+1}), the factor
%               0.5 is omitted.
%
% Reference:    J. Lee and S. Shin: General Construction of Time-Domain Filters for Orientation Data,
%               Trans. IEEE Vis. and Comp. Graph., 2002

switch (nargin)
    case 2
        b = varargin{1};
        quat_data = varargin{2};
        padding_method = 'symmetric';
    case 3
        b = varargin{1};
        quat_data = varargin{2};
        padding_method = varargin{3};
    otherwise
        error('Wrong number of arguments!');
end

N = size(quat_data,2);
k = length(b)/2;
if (2*k>N)
    error('Filter length must not be larger than number of data points!');
end

tic;

quat_data = adjustQuatsForBlending(quat_data);

omega = quatlog(quatmult(quatinv(quat_data(:,1:N-1)),quat_data(:,2:N)),10*eps);

if (strncmp(padding_method,'symmetric',1))
    pre = fliplr(omega(:,1:k));
    post = fliplr(omega(:,N-1-k+1:N-1)); % omega is of length N-1.
elseif (strncmp(padding_method,'zero',1))
    pre = zeros(3,k);
    post = zeros(3,k);
else
    error('Unknown padding option!');
end
omega = [pre omega post];

% omega is of length N-1. We pre- and post-pad it by k zeros/symmetrically, so the resulting sequence
% is of length 2*k + N-1.

y = zeros(4,N);

for i = 1:N
    
    s = zeros(3,1);
    for m = 1:2*k
        s = s + b(m)*omega(:,i+m-1);
    end
    y(:,i) = quatmult(quat_data(:,i),quatexp(s));
    
end
t = toc;