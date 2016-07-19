%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function resampleMot
% resamples a motion to create homogeneous point cloud trajectories
%
% resmot = resampleMot(skel,mot[,joints[,numberOfSamples]])
%
% input:
% - skel:               skeleton (required for forward kinematics)
% - mot:                motion to be resampled
% - joints:             joint IDs of regarded joints
% - numberOfSamples:    new number of samples (== resmot.nframes)
%
% output:
% - resmot:             resampled motion
%
% original motion:
% oo-o--o----o------o-----------o----------------o------------------------o
% resampled motion:
% x--------x--------x--------x--------x--------x--------x--------x--------x
% o = old samples, x = new samples
%
% author: Jochen Tautges (tautges@cs.uni-bonn.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function resmot = resampleMot(skel,mot,varargin)

rootTranslation          = mot.rootTranslation;

mot.rootTranslation(:,:) = 0;
mot.jointTrajectories    = C_forwardKinematicsQuat(skel,mot);

switch nargin
    case 2
        numberOfSamples = mot.nframes;
        joints = 1:mot.njoints;
    case 3
        numberOfSamples = varargin{1};
        joints = 1:mot.njoints;
    case 4
        numberOfSamples = varargin{1};
        joints = varargin{2};
    otherwise
        help resampleMot;
        error('Wrong number of argins!');
end

newRootTranslation      = zeros(3,numberOfSamples);
newRootTranslation(:,1) = rootTranslation(:,1);

computeAcc = false;
if isfield(mot,'jointAccelerations')
    computeAcc      = true;
    accs = cell2mat(mot.jointAccelerations);
    accs_new        = zeros(size(accs,1),numberOfSamples);
    accs_new(:,1)   = accs(:,1);
end
computeVel = false;
if isfield(mot,'jointVelocities')
    computeVel      = true;
    vels = cell2mat(mot.jointVelocities);
    vels_new        = zeros(size(vels,1),numberOfSamples);
    vels_new(:,1)   = vels(:,1);
end

pos         = cell2mat(mot.jointTrajectories(joints));
quats       = cell2mat(mot.rotationQuat(mot.animated));
dists       = sqrt(sum(diff(pos,1,2).^2));
delta       = sum(dists)/(numberOfSamples-1);
% delta       = mean(dists);

quats_new       = zeros(size(quats,1),numberOfSamples);
quats_new(:,1)  = quats(:,1);

akk = 0;
tmp = 0;
i=1;

counter=1;
while i<mot.nframes
    step = dists(i)-tmp;
    if akk + step < delta
        tmp = 0;
        akk = akk + step;
        i = i+1;
    else
        counter = counter+1;
        tmp = tmp + delta - akk;
        alpha = tmp / dists(i);
        quats_new(:,counter) = alpha * quats(:,i+1) + (1-alpha) * quats(:,i);
        if computeAcc
            accs_new(:,counter) = alpha * accs(:,i+1) + (1-alpha) * accs(:,i);
        end
        if computeVel
            vels_new(:,counter) = alpha * vels(:,i+1) + (1-alpha) * vels(:,i);
        end
        newRootTranslation(:,counter) = alpha * rootTranslation(:,i+1) + (1-alpha) * rootTranslation(:,i);
        akk = 0;
    end
end
dofs = getDOFsFromSkel(skel);

resmot                      = emptyMotion(mot);
resmot.nframes              = numberOfSamples;
resmot.rootTranslation      = newRootTranslation(:,1:numberOfSamples);

resmot.rotationQuat         = mat2cell(quats_new(:,1:numberOfSamples),dofs.quat,numberOfSamples);
resmot.jointTrajectories    = C_forwardKinematicsQuat(skel,resmot);
if computeAcc
    resmot.jointAccelerations = mat2cell(accs_new(:,1:numberOfSamples),dofs.pos,resmot.nframes);
end
if computeVel
    resmot.jointVelocities  = mat2cell(vels_new(:,1:numberOfSamples),dofs.pos,resmot.nframes);
end
resmot.boundingBox          = computeBoundingBox(resmot);

% if ~isempty(mot.rotationEuler)
%     resmot                  = C_convert2euler(skel,resmot);
% end

mot.documentation = 'resampled';