% function removeTranslation
% removes the global translation (root translation) of a motion
% mot = removeTranslation([skel,]mot)
% if skel is specified function uses forward kinematics, otherwise simple
% subtraction of root positions from all joint positions
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function mot = removeTranslation(varargin)

switch nargin
    case 1
        mot=varargin{1};
        mot.jointTrajectories{1}(:,:) = 0;
        for i=2:mot.njoints
            mot.jointTrajectories{i} = mot.jointTrajectories{i}-mot.rootTranslation;
        end 
        mot.rootTranslation = zeros(size(mot.rootTranslation));
    case 2
        if isfield(varargin{1},'jointTrajectories');
            mot=varargin{1};
            skel=varargin{2};
        else
            skel=varargin{1};
            mot=varargin{2};
        end
        mot.rootTranslation   = zeros(size(mot.rootTranslation));
        mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
    otherwise
        error('Wrong number of argins!');
end

mot.boundingBox=computeBoundingBox(mot);

if (isfield(mot,'jointVelocities')&&~isempty(mot.jointVelocities))
    mot=addVelToMot(mot);
end
if (isfield(mot,'jointAccelerations')&&~isempty(mot.jointAccelerations))
    mot=addAccToMot(mot);
end