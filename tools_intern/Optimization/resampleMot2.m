%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function resampleMot2
% for doc see "resampleMot"
% resampleMot2 uses arbitrary interpolation method instead of linear interpolation
% Note: resampleMot is faster, but resampleMot2 is nicer!
%
% author: Jochen Tautges (tautges@cs.uni-bonn.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [resmot,newSamp,oldSamp] = resampleMot2(skel,mot,varargin)

rootTranslation          = mot.rootTranslation;
mot.rootTranslation(:,:) = 0;
mot.jointTrajectories    = C_forwardKinematicsQuat(skel,mot);

switch nargin
    case 2
        numberOfSamples = mot.nframes;
        joints          = 1:mot.njoints;
        method          = 'spline';
    case 3
        numberOfSamples = varargin{1};
        joints          = 1:mot.njoints;
        method          = 'spline';
    case 4
        numberOfSamples = varargin{1};
        joints          = varargin{2};
        method          = 'spline';
    case 5
        numberOfSamples = varargin{1};
        joints          = varargin{2};
        method          = varargin{3};
    otherwise
        help resampleMot;
        error('Wrong number of argins!');
end

data                = cell2mat(mot.jointTrajectories(joints));

dists               = sqrt(sum(diff(data,1,2).^2));
delta               = sum(dists)/(numberOfSamples-1);
dists               = [0 cumsum(dists)];

oldSamp             = 1:mot.nframes;

newSamp             = zeros(1,numberOfSamples);
newSamp(1)          = 1;
newSamp(end)        = mot.nframes;

c=1;
i=2;
d = delta;
while i<=size(dists,2)
    if dists(i)>delta
        c=c+1;
        r=dists(i)-dists(i-1);
        p=delta-dists(i-1);
        newSamp(c) = i-1+p/r;
        delta = delta+d;
    else 
        i=i+1;
    end
end

dofs = getDOFsFromSkel(skel);

resmot              = emptyMotion(mot);
resmot.nframes      = numberOfSamples;

rotationQuat        = cell2mat(mot.rotationQuat(mot.animated));
% rotationQuat        = spline(oldSamp,rotationQuat,newSamp);
rotationQuat        = interp1(oldSamp,rotationQuat',newSamp,method)';
resmot.rotationQuat = mat2cell(rotationQuat,dofs.quat,numberOfSamples);
resmot.rotationQuat = cellfun(@(x) normalizeColumns(x),resmot.rotationQuat,'UniformOutput',0);
                           
resmot.rootTranslation = spline(oldSamp,rootTranslation,newSamp);

if isfield(mot,'jointAccelerations')
    jointAccelerations          = cell2mat(mot.jointAccelerations);
    jointAccelerations          = spline(oldSamp,jointAccelerations,newSamp);
    resmot.jointAccelerations   = mat2cell(jointAccelerations,dofs.pos,numberOfSamples);
end
if isfield(mot,'jointVelocities')
    jointVelocities             = cell2mat(mot.jointVelocities);
    jointVelocities             = spline(oldSamp,jointVelocities,newSamp);
    resmot.jointVelocities      = mat2cell(jointVelocities,dofs.pos,numberOfSamples);
end

resmot.jointTrajectories    = C_forwardKinematicsQuat(skel,resmot);
resmot.boundingBox          = computeBoundingBox(resmot);

resmot.rotationEuler        = [];

resmot.documentation           = 'resampled';
