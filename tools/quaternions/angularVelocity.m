function [V,V_abs] = angularVelocity(varargin)
% V = angularVelocity(Q,fs,abs_vel)
%
% Compute angular velocities from quaternion data streams.
%
% Input:    * Q: cell array consisting of L 4xN_k matrices. Alternatively, V can be a single 4xN matrix.
%             fs: sampling rate, default = 1.
%             abs_vel: boolean flag indicating whether absolute velocities are to be computed. default: false.
%
% Output:   * V: cell array of L 3x(N_k - 1)-arrays containing angular velocity vectors.
%           * V_abs: empty if abs_vel == false, else cell array of L 1x(N_k - 1)-vectors containing absolute angular velocities.

switch nargin
    case 1
        Q = varargin{1};
        fs = 1;
        abs_vel = false;
    case 2
        Q = varargin{1};
        fs = varargin{2};
        abs_vel = false;
    case 3
        Q = varargin{1};
        fs = varargin{2};
        abs_vel = varargin{3};
    otherwise
        error('Wrong number of arguments!');
end

if (~iscell(Q))
    Q = {Q};
end

L = length(Q); % number of data streams

V = cell(L,1);
if (abs_vel)
    V_abs = cell(L,1);
else
    V_abs = cell(0);
end
for k=1:L
    N = size(Q{k},2);

    %%%%%%%% attention: constant factor of 2 (for correct phyical interpretation) has been neglected
    V{k} = quatlog(quatmult(quatinv(Q{k}(:,1:N-1)),Q{k}(:,2:N)),10*eps) * fs;
    if (abs_vel)
        V_abs{k} = sqrt(sum(V{k}.^2));
    end
end