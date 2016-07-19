function [motE,motE0] = C_convert2euler(skel,mot)

motE=mot;
motE0=motE;

if ~isfield(skel.nodes,'DOFIDs')
    skel = addDOFIDsToSkel(skel);
end

for i=1:mot.njoints
    axis_quat   = C_euler2quat(flipud(skel.nodes(i).axis)*pi/180);
    if isempty(mot.rotationQuat{i})
        q       = C_quatmult(C_quatinv(axis_quat),axis_quat);
    else
        q       = C_quatmult(C_quatinv(axis_quat),C_quatmult(mot.rotationQuat{i},axis_quat));
    end
    e           = flipud(C_quat2euler(q))*180/pi;

    motE.rotationEuler{i,1} = e(skel.nodes(i).DOFIDs,:);
    if nargout>1
        motE0.rotationEuler{i,1}                            = zeros(size(e));
        motE0.rotationEuler{i,1}(skel.nodes(i).DOFIDs,:)    = e(skel.nodes(i).DOFIDs,:);
    end
end