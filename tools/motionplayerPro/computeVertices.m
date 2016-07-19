function mot = computeVertices(skel,mot,scale_factor,bonestype)

if isfield(mot,'rotationQuat')
    if ~iscell(mot.rotationQuat)
        if ~isempty(mot.rotationQuat)
            rotQuats = mat2cell(mot.rotationQuat,4*ones(1,numel(mot.animated)));
            mot.rotationQuat = cell(mot.njoints,1);
            mot.rotationQuat(mot.animated)=rotQuats;
        end
    end
else
    mot.rotationQuat  = [];
    mot.rotationEuler = [];
end

if (isempty(mot.rotationQuat)  || all(cellfun(@(x) isempty(x),mot.rotationQuat)))...
        && (isempty(mot.rotationEuler) || all(cellfun(@(x) isempty(x),mot.rotationEuler)))
    if isempty(mot.jointTrajectories)
        error('No data available to compute mot.vertices!');
    else
        mot.faces = [1 2 3;1 3 4;1 4 5;1 5 2;2 3 6;3 4 6;4 5 6;5 2 6];
        mot.rotDataAvailable = false;
        mot.vertices = cell(mot.njoints,1);
        marker_edge_length = 2*scale_factor;
        for i=1:mot.njoints
            mot.jointTrajectories{i}  = mot.jointTrajectories{i} * scale_factor;
            mot.vertices{i}           = repmat(mot.jointTrajectories{i},6,1);
            mot.vertices{i}(2,:)      = mot.vertices{i}(2,:)+marker_edge_length;
            mot.vertices{i}(6,:)      = mot.vertices{i}(6,:)-marker_edge_length;
            mot.vertices{i}(7,:)      = mot.vertices{i}(7,:)-marker_edge_length;
            mot.vertices{i}(12,:)     = mot.vertices{i}(12,:)+marker_edge_length;
            mot.vertices{i}(13,:)     = mot.vertices{i}(13,:)+marker_edge_length;
            mot.vertices{i}(17,:)     = mot.vertices{i}(17,:)-marker_edge_length;
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%hashim 
%           [mot.jointTrajectories,mot.vertices,mot.faces] = iterativeForwKinematics_local(skel,mot,bonestype);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%hashim     
        
    end
else
    if isempty(mot.rotationQuat)
        mot = convert2quat(skel,mot);
    end
    mot.rotDataAvailable = true;
    mot.rotationQuat(mot.unanimated)={[ones(1,mot.nframes);zeros(3,mot.nframes)]};
    
    [mot.jointTrajectories,mot.vertices,mot.faces] = iterativeForwKinematics_local(skel,mot,bonestype);
    
    %         mot.vertices = recursive_forwardKinematicsQuat_local(skel,mot,1,...
    %             [zeros(15,mot.nframes); mot.rootTranslation],...
    %             C_quatmult(repmat(skel.rootRotationalOffsetQuat,1,mot.nframes),mot.rotationQuat{1}));
    
    %         mot.jointTrajectories = cellfun(@(x) x(end-2:end,:), mot.vertices,'UniformOutput',0);
    
end

end

function [jointTrajectories,vertices,faces] = H_iterativeForwKinematics_local(skel,mot,bonestype)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%hashim  
  localSystems         = cell(skel.njoints,1);
jointTrajectories    = cell(skel.njoints,1);

jointTrajectories{1} = mot.rootTranslation;
vertices             = cell(skel.njoints,1);
 for i=1:size(skel.paths,1)
     for j=2:numel(skel.paths{i})
         joint = skel.paths{i}(j);
         pred  = skel.paths{i}(j-1);
         
             localSystems{joint,1} = localSystems{pred};
          
         jointTrajectories{joint} = mot.jointTrajectories{pred};
         
         [v,faces,nrOfV] = computeVertices_local(skel.nodes(joint).offset,bonestype);
         v           = reshape(v,3,nrOfV);
         
         vertices{joint} = zeros(nrOfV*3,mot.nframes);
         for k=1:nrOfV
             vertices{joint}(k*3-2:k*3,:) = mot.jointTrajectories{pred};
         end
     end
 end 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%hashim
end

function [jointTrajectories,vertices,faces] = iterativeForwKinematics_local(skel,mot,bonestype)

localSystems         = cell(skel.njoints,1);
localSystems{1}      = mot.rotationQuat{1};
jointTrajectories    = cell(skel.njoints,1);

jointTrajectories{1} = mot.rootTranslation;
vertices             = cell(skel.njoints,1);

for i=1:size(skel.paths,1)
    for j=2:numel(skel.paths{i})
        joint = skel.paths{i}(j);
        pred  = skel.paths{i}(j-1);
        
        if isempty(mot.rotationQuat{joint})
            localSystems{joint,1} = localSystems{pred};
        else
            localSystems{joint,1} = C_quatmult(double(real(localSystems{pred})),double(real(mot.rotationQuat{joint})));
        end
        
        jointTrajectories{joint} = jointTrajectories{pred}...
            + C_quatrot(skel.nodes(joint).offset,localSystems{joint});
        
        [v,faces,nrOfV] = computeVertices_local(skel.nodes(joint).offset,bonestype);
        v           = reshape(v,3,nrOfV);
        
        vertices{joint} = zeros(nrOfV*3,mot.nframes);
        for k=1:nrOfV
            vertices{joint}(k*3-2:k*3,:) = jointTrajectories{pred}...
                + C_quatrot(v(:,k),localSystems{joint});
        end
    end
end



end

% % function trajectories = recursive_forwardKinematicsQuat_local(skel, mot, node_id, current_position, current_rotation,trajectories)
% %
% %     trajectories{node_id,1} = current_position;
% %     vertices_mot            = zeros(18,mot.nframes);
% %
% %     for child_id = skel.nodes(node_id).children'
% %
% %         child           = skel.nodes(child_id);
% %         if (~isempty(mot.rotationQuat{child_id}))
% %             child_rotation = quatmult(current_rotation,mot.rotationQuat{child_id});
% %         else
% %             child_rotation = current_rotation;
% %         end
% %
% % %         child_rotation  = quatmult(current_rotation,mot.rotationQuat{child_id});
% %         mot.vertices        = computeVertices_local(child.offset);
% %
% %         c=1;
% %         for i=1:size(mot.vertices,2)
% %             vertices_mot(c:c+2,:) = C_quatrot(mot.vertices(:,i),child_rotation);
% %             c=c+3;
% %         end
% %
% %         child_position  = vertices_mot + repmat(current_position(16:18,:),6,1);
% %         trajectories    = recursive_forwardKinematicsQuat_local(skel, mot, child_id, child_position, child_rotation, trajectories);
% %     end
% %
% % end

function [vertices,faces,nrOfVertices] = computeVertices_local(child_offset,bonestype)

switch bonestype
    case 'diamonds'
        child_length = sqrt(sum(child_offset.^2));
        
        dir1 = cross(child_offset,[0;1;0]);
        dir1 = dir1/sqrt(sum(dir1.^2));
        
        dir2 = cross(child_offset,dir1);
        dir2 = dir2/sqrt(sum(dir2.^2));
        
        off1 = dir1*child_length/10;
        off2 = dir2*child_length/10;
        
        centerOfBone = child_offset/4;
        
        vertices = [[0;0;0],...
            centerOfBone+off1,...
            centerOfBone+off2,...
            centerOfBone-off1,...
            centerOfBone-off2,...
            child_offset];
        
        faces = [1 2 3;1 3 4;1 4 5;1 5 2;2 3 6;3 4 6;4 5 6;5 2 6];
        nrOfVertices = 6;
    case 'sticks'
        sidelength = 3;
        dir1 = cross(child_offset,[0;1;0])/2*sidelength;
        if ~any(dir1)
            dir1=[1;0;0];
        else
            dir1 = dir1/sqrt(sum(dir1.^2))/2*sidelength;
        end
        
        dir2 = cross(child_offset,dir1)/2*sidelength;
        if ~any(dir2)
            dir2=[1;0;0];
        else
            dir2 = dir2/sqrt(sum(dir2.^2))/2*sidelength;
        end
        
        vertices = [dir1+dir2;...
            -dir1+dir2;...
            -dir1-dir2;...
            dir1-dir2;...
            dir1+dir2+child_offset;...
            -dir1+dir2+child_offset;...
            -dir1-dir2+child_offset;...
            dir1-dir2+child_offset];
        
        nrOfVertices = 8;
        faces = [1 2 3 4;1 2 6 5;2 3 7 6;3 4 8 7;1 4 8 5; 5 6 7 8];
    case 'tubes'
        sidelength = 3;
        spheresize = 5;
        
        child_offset_n=child_offset/sqrt(sum(child_offset.^2));
        
        rotaxis  = cross([0 0 1],child_offset_n);
        rotangle = acos(dot(child_offset_n,[0 0 1]));
        
        if child_offset_n(3)==1%~any(rotaxis)
            rotaxis=[0;0;1];
            rotangle = 0;
        end
        
        nn=16;
        l = norm(child_offset);
        [s.x,s.y,s.z] = cylinder(sidelength,nn);
        s.z(2,:)=s.z(2,:)*l;
        s.x=s.x(:);
        s.y=s.y(:);
        s.z=s.z(:);
        
        vertices = zeros((nn+1)*2*3,1);
        vertices(1:3:end) = s.x;
        vertices(2:3:end) = s.y;
        vertices(3:3:end) = s.z;
        
        sina = sin(rotangle/2);
        q = [cos(rotangle/2);rotaxis(1)*sina;rotaxis(2)*sina;rotaxis(3)*sina];
        
        vertices = reshape(vertices,3,(nn+1)*2);
        
        vertices = quatrot(vertices,q);
        
        vertices = reshape(vertices,1,(nn+1)*2*3);
        
        
        faces = zeros(nn,4);
        for f=1:nn
            ul = f*2-1;
            faces(f,:)=[ul ul+2 ul+3 ul+1];
        end
        
        [s.x,s.y,s.z] = sphere(nn);
        svertices = zeros((nn+1)*(nn+1)*3,1);
        svertices(1:3:end) = s.x(:)*spheresize;
        svertices(2:3:end) = s.y(:)*spheresize;
        svertices(3:3:end) = s.z(:)*spheresize;
        
        sfaces = zeros((nn)*(nn),4);
        for c = 1:nn
            for r = 1:nn
                ul = r+(nn+1)*(c-1);
                sfaces((c-1)*nn+r,:)=[ul ul+nn+1 ul+nn+2 ul+1];
            end
        end
        
        faces = [faces;sfaces+numel(vertices)/3];
        vertices = [vertices svertices'];
        
        nrOfVertices = numel(vertices)/3;
        
    case 'spheres'
        nn = 16;
        spheresize = 3;
        [s.x,s.y,s.z] = sphere(nn);
        svertices = zeros((nn+1)*(nn+1)*3,1);
        svertices(1:3:end) = s.x(:)*spheresize;
        svertices(2:3:end) = s.y(:)*spheresize;
        svertices(3:3:end) = s.z(:)*spheresize;
        
        sfaces = zeros((nn)*(nn),4);
        for c = 1:nn
            for r = 1:nn
                ul = r+(nn+1)*(c-1);
                sfaces((c-1)*nn+r,:)=[ul ul+nn+1 ul+nn+2 ul+1];
            end
        end
        
        faces = sfaces;
        vertices = svertices';
        
        nrOfVertices = numel(vertices)/3;
        
    otherwise
        error('Unknown type of bones!');
end
end
