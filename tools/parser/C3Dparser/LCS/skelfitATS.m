function mot_new = skelfitATS( mot )
% Enforcing fixed bone lengths of skeleton. Implementation of proposal by
% Aguiar, Theobalt and Seidel in "Automatic Learning of Articulated
% Skeletons from 3D Marker Trajectories".
% 
% mot_new = skelfit( mot )
%
%       mot = motion variable

if nargin < 1
    help skelfitATS
    return
end

skelTree = buildSkelTree(mot.nameMap);
mot_new = mot;

rootIdx = strmatch('root', skelTree(:,1));

if isempty(rootIdx)
    error('Could not find ''root''-joint in mot.nameMap!');
end

mot_new = skelfitATSrek(mot, rootIdx, skelTree, []);
