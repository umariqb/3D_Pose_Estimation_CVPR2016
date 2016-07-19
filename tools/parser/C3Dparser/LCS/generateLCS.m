function [ skel_new, mot_new ] = generateLCS( skel, mot, callbackFunctionNames)
% [ skel_new, mot_new ] = generateLCS( skel, mot, callbackFunctionNames)
%
%           callbackFunctionNames is an optional parameter.

if nargin < 1
    help generateLCS;
    return;
end

if nargin < 3
    callbackFunctionNames = generateDefaultFunctionNames;
end

skel_new = skel;
skel_new.nameMap = [];
mot_new = mot;
mot_new.nameMap = [];
mot_new.jointTrajectories = [];
emptyTrajectories = 0;

for i = 1:size(callbackFunctionNames,2)
    traj = feval(char(callbackFunctionNames(2,i)), mot);
    if traj==0
        emptyTrajectories = emptyTrajectories + 1;
    else
        mot_new.jointTrajectories{i - emptyTrajectories,1} = traj;
        mot_new.nameMap{i - emptyTrajectories,1} = char(callbackFunctionNames(1,i));
        mot_new.nameMap{i - emptyTrajectories,2} = 0;
        mot_new.nameMap{i - emptyTrajectories,3} = i - emptyTrajectories;
    end
end

skel_new.njoints = 24 - emptyTrajectories;
mot_new.njoints = 24 - emptyTrajectories;
skel_new.nameMap = mot_new.nameMap;
skel_new.paths = buildSkelPathsFromMot(mot_new);

