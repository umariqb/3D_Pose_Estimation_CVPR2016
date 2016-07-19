function jointID = jointName2ID(mot, s_jointName, s_rotORtraj)
% jointID = jointName2ID(mot, jointName, rotation_or_trajectory)
%
% Converts a joint name into a joint ID that refers to the standard
% skeleton's name map.
% 
% INPUT 
%   mot ...................... (struct) motion information (from readMocapAMC)
%   jointName ................ (string) name of the joint
%   rotation_or_trajectory ... (string), 'rotation' or 'trajectory'
%                              'rotation'   => index goes into rotation parameters
%                              'trajectory' => index goes into trajectories?
%
% OUTPUT
%   jointID .................. the joint's ID into standard skeleton name map
%
% EXAMPLE
%   jointID = jointName2ID('root', 'trajectory')
%

nameMap_cell = mot.nameMap;

i = strmatch(lower(s_jointName), lower(nameMap_cell(:,1)),'exact');

if (isempty(i))
     error(['*** Unknown standard joint ID "' s_jointName '"!']);
end

if (length(i)>1)
     error(['Ambiguous standard joint ID "' s_jointName '"!']);
end

switch lower(s_rotORtraj)
    case {'rotation', 'rot'}
        warn = '(rotation)';
        jointID = nameMap_cell{i,2};
    case {'trajectory', 'traj'}
        warn = '(trajectory)';
        jointID = nameMap_cell{i,3};
    otherwise
        error(['*** Unknown parameter "', s_rotORtraj, '"!']);
end

