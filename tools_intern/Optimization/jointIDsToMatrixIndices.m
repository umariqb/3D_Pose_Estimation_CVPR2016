function indices = jointIDsToMatrixIndices(varargin)

switch nargin
    case 1
        % no skel specified, dofs hard-coded
        jointIDs = varargin{1};
        dofs.euler  = [3 0 3 1 2 1 0 3 1 2 1 3 3 3 3 3 3 2 3 1 1 2 1 2 2 3 1 1 2 1 2];
        dofs.quat   = [4 0 4 4 4 4 0 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];
        dofs.expmap = [3 0 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3];
    case 2
        % skel specified
        if (isSkel({varargin{1}}))
            dofs = getDOFsFromSkel(varargin{1});
            jointIDs = varargin{2};
        elseif (isSkel({varargin{2}}))
            dofs = getDOFsFromSkel(varargin{2});
            jointIDs = varargin{1};
        else
            error('Wrong input!');
        end
    otherwise
        error('Wrong number of argins!');
end
            
dofs_euler_c = [0 cumsum(dofs.euler)];
dofs_quats_c = [0 cumsum(dofs.quat)];
dofs_pos_c   = [0 cumsum(3*ones(1,length(dofs.euler)))];
dofs_expmap_c = [0 cumsum(dofs.expmap)];

indices.euler = [];
indices.quats = [];
indices.pos   = [];
indices.expmap = [];

for i=jointIDs
    indices.euler = [indices.euler dofs_euler_c(i)+1:dofs_euler_c(i+1)];
    indices.quats = [indices.quats dofs_quats_c(i)+1:dofs_quats_c(i+1)];
    indices.pos   = [indices.pos dofs_pos_c(i)+1:dofs_pos_c(i+1)];
    indices.expmap = [indices.expmap dofs_expmap_c(i)+1:dofs_expmap_c(i+1)];
end
indices.quat = indices.quats;