% function [D,w,d]=pointCloudDTW(motRef,motToWarp[,traj,joints,rho])
%
% Output:
% D = GDM (Global Distance Matrix)
% w = warping path
% d = LDM (Local Distance Matrix)
%
% Required Input:
% motref:       reference motion
% motToWarp:    motion which is to warp
%
% Optional input:
% traj:         'jointTrajectories' (default), 'jointVelocities' or 
%               'jointAccelerations' 
% joints:       joints for which the trajectories are to be compared 
%               (for joint IDs see the skel structure, default: [1:31])
% rho:          windowsize for point cloud distance (default: 1)

function [D,w,d]=pointCloudDTW(motRef,motToWarp,varargin)

% default values
trajField='jointTrajectories';
joints=(1:31);
rho=0;

switch nargin
    case 3
        trajField=varargin{1};
    case 4
        trajField=varargin{1};
        joints=varargin{2};
    case 5
        trajField=varargin{1};
        joints=varargin{2};
        rho = varargin{3};
end

TrajectoriesRef     = cell(length(joints),1);
TrajectoriesToWarp  = cell(length(joints),1);

% if ~(isfield(motRef,'jointAccelerations'))
%     motRef=addAccToMot(motRef);
% end
% if ~(isfield(motToWarp,'jointAccelerations'))
%     motToWarp=addAccToMot(motToWarp);
% end

for i=1:length(joints)
    switch trajField
        case {'jointAccelerations','a','acc','A','Acc','accelerations','Accelerations'}
            TrajectoriesRef{i}      = motRef.jointAccelerations{joints(i)};
            TrajectoriesToWarp{i}   = motToWarp.jointAccelerations{joints(i)};
        case {'jointVelocities','v','vel','V','Vel','velocities','Velocities'}
            TrajectoriesRef{i}      = motRef.jointVelocities{joints(i)};
            TrajectoriesToWarp{i}   = motToWarp.jointVelocities{joints(i)};
        case {'jointTrajectories','p','pos','P','Pos','positions','Positions'}
            TrajectoriesRef{i}      = motRef.jointTrajectories{joints(i)};
            TrajectoriesToWarp{i}   = motToWarp.jointTrajectories{joints(i)};
        otherwise
            fprintf('\nNo valid trajectory specification: %s\n\n', trajField);
            [D,w,d]=deal([],[],[]);
            help pointCloudDTW_jt
            return
    end
end

N = size(TrajectoriesRef{1},2);
M = size(TrajectoriesToWarp{1},2);

% Calculation of the LDM:
d = distMatrix_pointCloudDistance_jt(TrajectoriesRef,TrajectoriesToWarp,rho);

% Calculation of the GDM:
D = inf(size(d));
D(1,:) = cumsum(d(1,:));
D(:,1) = cumsum(d(:,1));

for n=2:N
    for m=2:M 
        D(n,m) = d(n,m)+min([D(n-1,m-1),D(n-1,m),D(n,m-1)]);
    end
end

% Search for the optimal path on the GDM:
n=N;
m=M;
w=[];
w(1,:)=[N,M];
while (n~=1 && m~=1)
    [values,number]=min([D(n-1,m-1),D(n-1,m),D(n,m-1)]);
    switch number
        case 2
            n=n-1;
        case 3
            m=m-1;
        case 1
            n=n-1;
            m=m-1;
    end
    w=[w;[n,m]];
end
if (n==1 && m>1)
    w=[w;[ones(m-1,1),(m-1:-1:1)']];
elseif (m==1 && n>1)
    w=[w;[(n-1:-1:1)',ones(n-1,1)]];
end
% plotDTWpath(d,w);
