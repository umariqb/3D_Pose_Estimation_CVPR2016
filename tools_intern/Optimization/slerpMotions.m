function mot = slerpMotions(skel,mot1,mot2,u)

mot     = mot1;
mot.rotationEuler = [];

dofs1   = cellfun('size',mot1.rotationQuat,1);
dofs2   = cellfun('size',mot2.rotationQuat,1);

quats1  = reshape(cell2mat(mot1.rotationQuat),4,mot1.nframes*sum(dofs1)/4);
quats2  = reshape(cell2mat(mot2.rotationQuat),4,mot2.nframes*sum(dofs2)/4);

% quats1(:,quats1(1,:)<0)=-quats1(:,quats1(1,:)<0);
% quats2(:,quats2(1,:)<0)=-quats2(:,quats2(1,:)<0);

quats2(:,dot(quats1,quats2)<0) = -quats2(:,dot(quats1,quats2)<0);

quats   = slerp(quats1,quats2,u);
quats   = reshape(quats,sum(dofs1),mot1.nframes);
mot.rotationQuat = mat2cell(quats,dofs1,mot1.nframes);

mot.rootTranslation = (1-u) * mot1.rootTranslation + u * mot2.rootTranslation;

% Aufräumarbeiten
mot.jointTrajectories   = forwardKinematicsQuat(skel,mot);
mot.boundingBox         = computeBoundingBox(mot);
mot.filename            = [num2str(1-u) '*' mot1.filename '+' num2str(u) '*' mot2.filename];
if isfield(mot,'csvFile')
    mot.csvFile             = [];
end