function [rotationEuler, rotationQuat, curr_data_index] = extractRotation(skel,node_index,data,curr_data_index,rotationEuler,rotationQuat,compute_quats)
switch lower(skel.angleUnit)
    case 'deg'
        conversion_factor = pi/180;
    case 'rad'
        conversion_factor = 1;
end

node = skel.nodes(node_index);
nDOF = size(node.DOF,1); % number of DOFs for this node
if (isempty(node.DOF{1}))
    nDOF = 0;
end

if nDOF > 0
	%%%%%% compute rotation order string and indices of this node's data streams
	rotationOrder = '';
    indices = [];
    rx_missing = true;
    ry_missing = true;
    rz_missing = true;
	for k = 1:nDOF
        switch lower(node.DOF{k})
            case 'rx'
                rotationOrder = [rotationOrder 'x'];
                indices = [indices k];
                rx_missing = false;
            case 'ry'
                rotationOrder = [rotationOrder 'y'];
                indices = [indices k];
                ry_missing = false;
            case 'rz'
                rotationOrder = [rotationOrder 'z'];
                indices = [indices k];
                rz_missing = false;
            case 'tx'
            case 'ty'
            case 'tz'
            otherwise
                warning(['Invalid DOF specification: ' node.DOF{k} '!']);
        end
	end
    nRotDOF = length(indices); % number of rotational DOFs
    
    if nRotDOF > 0
        %%%%%%%% adjust channel indices so as to point at correct location in our data array
        indices = indices + curr_data_index - 1;
	
        %%%%%%%%%% extract Euler information pertaining to this node
        rotationEuler{node.ID,1} = data(indices, :);
                
        %%%%%%%%%% compute quaternion representation
        if rx_missing
            rotationOrder = [rotationOrder 'x'];
        end
        if ry_missing
            rotationOrder = [rotationOrder 'y'];
        end
        if rz_missing
            rotationOrder = [rotationOrder 'z'];
        end
        if (compute_quats)
            switch nRotDOF
                case 3
                    rotationQuat{node.ID,1} = euler2quat(data(indices, :)*conversion_factor,rotationOrder);
                case 2
                    rotationQuat{node.ID,1} = euler2quat([data(indices, :)*conversion_factor;zeros(1,size(data,2))],rotationOrder);
                case 1
                    rotationQuat{node.ID,1} = euler2quat([data(indices, :)*conversion_factor;zeros(2,size(data,2))],rotationOrder);
                otherwise
                    error(['Too many rotational DOFs for node ' node.jointName '!']);
            end
        end
    end
    
    curr_data_index = curr_data_index + nDOF;
end

for k=1:length(node.children)
   [rotationEuler, rotationQuat, curr_data_index] = extractRotation(skel,node.children(k),data,curr_data_index,rotationEuler,rotationQuat,compute_quats);
end