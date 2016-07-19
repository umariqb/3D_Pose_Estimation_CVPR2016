function mot = addLocalAccToMot(skel,mot)

if ~isfield(mot,'jointAccelerations');
    mot = addAccToMot(mot);
end
if ~isfield(mot,'localSystems');
    mot     = computeLocalSystems(skel,mot);
end

mot.localJointAccelerations = cell(size(mot.jointAccelerations));
gravMatrix = [zeros(1,mot.nframes);9.81*ones(1,mot.nframes);zeros(1,mot.nframes)];
for i=1:mot.njoints
    mot.localJointAccelerations{i} = ...
        C_quatrot(mot.jointAccelerations{i}+gravMatrix,...
        C_quatinv(mot.localSystems{i}));
end