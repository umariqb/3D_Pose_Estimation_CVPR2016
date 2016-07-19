function skel = emptySkeleton
skel = struct('njoints',0,...                           % number of joints
              'rootRotationalOffsetEuler',[0;0;0],...   % global (constant) rotation of root in world system, Euler angles.
              'rootRotationalOffsetQuat',[1;0;0;0],...  % global (constant) rotation of root in world system, quaternion.
              'nodes',struct([]),...                    % struct array containing nodes of skeleton tree data structure
              'paths',cell(1,1),...                     % contains a set of edge-disjoint paths the union of which represents the whole tree; represented as cell array of joint ID vectors
              'jointNames',cell(1,1),...                % cell array of joint names: maps joint ID to joint name
              'boneNames',cell(1,1),...                 % cell array of bone names: maps bone ID to node name. ID 1 is the root.
              'nameMap',cell(1,1),...                   % cell array mapping standard joint names to DOF IDs and trajectory IDs
              'animated',[],...                         % vector of IDs for animated joints/bones
              'unanimated',[],...                       % vector of IDs for unanimated joints/bones
              'filename','',...                         % source filename
              'version','',...                          % file format version
              'name','',...                             % name for this skeleton
              'massUnit',1,...                          % unit divisor for mass
              'lengthUnit',1,...                        % unit divisor for lengths
              'angleUnit','deg',...                     % angle unit (deg or rad)
              'documentation','',...                    % documentation from source file   
              'fileType','',...                         % file type (BVH / ASF)
              'skin',cell(1,1));                        % cell array of skin filenames for this skeleton