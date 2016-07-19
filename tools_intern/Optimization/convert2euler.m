function [motE,motE0] = convert2euler(skel,mot)

motE=mot;
motE0=motE;

if ~isfield(skel.nodes,'DOFIDs')
    skel = addDOFIDsToSkel(skel);
end

if size(skel.animated,2)>1
    skel.animated = skel.animated';
end

for i=skel.animated'
    axis_quat   = repmat(euler2quat(flipud(skel.nodes(i).axis)*pi/180,'zyx'),1,mot.nframes);
    if isempty(mot.rotationQuat{i})
        q       = C_quatmult(C_quatinv(axis_quat),axis_quat);
    else
        q       = C_quatmult(C_quatinv(axis_quat),C_quatmult(mot.rotationQuat{i},axis_quat));
    end
    e           = flipud(quat2euler(q,fliplr(skel.nodes(i).rotationOrder)))*180/pi;
    
    motE.rotationEuler{i,1} = e(skel.nodes(i).DOFIDs,:);
    if nargout>1
        motE0.rotationEuler{i,1}            = zeros(size(e));
        motE0.rotationEuler{i,1}(skel.nodes(i).DOFIDs,:)    = e(skel.nodes(i).DOFIDs,:);
    end
end