function [d,theta,x0,z0,dist] = compareMotionsPointCloudDist_modified(mot1,mot2,varargin)

if mot1.nframes~=mot2.nframes
    error('Different number of frames!');
end

switch nargin
    case 2
        traj1=mot1.jointTrajectories;
        traj2=mot2.jointTrajectories;
        consideredJoints=1:mot1.njoints;
    case 3
        switch lower(varargin{1})
            case 'acc'
                traj1=mot1.jointAccelerations;
                traj2=mot2.jointAccelerations;
            case 'pos'
                traj1=mot1.jointTrajectories;
                traj2=mot2.jointTrajectories;
            case 'vel'
                traj1=mot1.jointVelocities;
                traj2=mot2.jointVelocities;
            otherwise
                error('Unknown trajectory: Choose "pos", "vel" or "acc"!');
        end
        consideredJoints=1:mot1.njoints;
    case 4
        switch lower(varargin{1})
            case 'acc'
                traj1=mot1.jointAccelerations;
                traj2=mot2.jointAccelerations;
            case 'pos'
                traj1=mot1.jointTrajectories;
                traj2=mot2.jointTrajectories;
            case 'vel'
                traj1=mot1.jointVelocities;
                traj2=mot2.jointVelocities;
            otherwise
                error('Unknown trajectory: Choose "pos", "vel" or "acc"!');
        end
        consideredJoints=varargin{2};
    otherwise
        error('Wrong number of arguments!');
end

numFrames=mot1.nframes;
numJoints=length(consideredJoints);

% P=zeros(3,numJoints*numFrames);
% Q=zeros(3,numJoints*numFrames);
% 
% counter=1;
% for j=consideredJoints
%     P(:,counter:counter+numFrames-1)    = traj1{j};
%     Q(:,counter:counter+numFrames-1)    = traj2{j};
%     counter                             = counter+numFrames;
% end

P = reshape(cell2mat(traj1(consideredJoints)),3,numJoints*numFrames);
Q = reshape(cell2mat(traj2(consideredJoints)),3,numJoints*numFrames);

[d,theta,x0,z0] = pointCloudDist_modified(P,Q);

dist = mean(sqrt(sum((d*2.54).^2)));