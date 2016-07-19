function mot = convert2quat(skel,mot)

if ~isfield(skel.nodes,'DOFIDs')
    skel = addDOFIDsToSkel(skel);
end

switch lower(mot.angleUnit)
    case 'deg'
        conversion_factor = pi/180;
    case 'rad'
        conversion_factor = 1;
    otherwise
        error(['Unknown angle unit: ' mot.angleUnit]);
end
nTraj = size(mot.rotationEuler,1);
for k = 1:nTraj
    node = skel.nodes(k);
    
    % Update node.ID. Otherwise the node.ID might not fit the order in
    % mot.rotationEuler
    [~,eulerIndex] = ismember(node.boneName,skel.boneNames);
    
    completeEulers                  = zeros(3,mot.nframes);
    if ~isempty(mot.rotationEuler{eulerIndex})
        completeEulers(node.DOFIDs,:)   = mot.rotationEuler{eulerIndex}*conversion_factor;
    end
    
    if (node.ID == 1) % root node? => special case for determination of rotation order (node.rotationOrder only concerns the global rotational offset in this case)
        mot.rotationQuat{eulerIndex,1} = euler2quat(flipud(completeEulers),'zyx'); % ASF specs use opposite multiplication order as we do, hence fliplr() and flipud()!
    else 
        axis_quat = euler2quat(flipud(node.axis)*conversion_factor,'zyx');
        axis_quat = axis_quat(:,ones(1,mot.nframes)); 
        mot.rotationQuat{eulerIndex,1} = quatmult(axis_quat,quatmult(euler2quat(flipud(completeEulers),'zyx'),quatinv(axis_quat))); % ASF specs use opposite multiplication order as we do, hence fliplr() and flipud()!
    end
end
