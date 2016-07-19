function [mot,varargout] = buildMotFromRotData(angles_curr,skel,varargin)

mot = emptyMotion();

if isempty(angles_curr)
    error('angles_curr are empty!');
end
    mot                      = emptyMotion;
    mot.njoints              = skel.njoints;% 31;
    mot.animated             = skel.animated;%[1 3:6 8:31];
    mot.unanimated           = skel.unanimated;%[2 7];
    mot.nframes              = size(angles_curr,2);
    mot.rootTranslation      = zeros(3,mot.nframes);
    
    if nargin==3
        dofs = varargin{1};
    else
        dofs = getDOFsFromSkel(skel);
    end
    
    switch size(angles_curr,1)
        case 1
            mot.rotationEuler       = mat2cell(angles_curr(ones(1,sum(dofs.euler)),:),dofs.euler);
            mot                     = C_convert2quat(skel,mot);
            mot.jointTrajectories   = C_forwardKinematicsWrapper(skel,mot.rootTranslation,mot.rotationQuat);
        case sum(dofs.euler)
            mot.rotationEuler       = mat2cell(angles_curr,dofs.euler);
            mot                     = C_convert2quat(skel,mot);
            mot.jointTrajectories   = C_forwardKinematicsWrapper(skel,mot.rootTranslation,mot.rotationQuat);
        case sum(dofs.quat) 
%             mot.rotationQuat        = mat2cell(angles_curr,dofs.quat);
%             mot.rotationQuat(mot.unanimated) = {[ones(1,mot.nframes);zeros(3,mot.nframes)]};
            mot.rotationQuat = angles_curr;
            mot.jointTrajectories   = C_forwardKinematicsWrapper(skel,mot.rootTranslation,double(angles_curr));
    %         mot                     = convert2euler(skel,mot);
        otherwise
            error('Unknown format!');
    end
    
    switch nargout
        case 2
            [mot.jointTrajectories,varargout{1}] = iterativeForwKinematics(skel,mot);
        case 1
             mot.jointTrajectories    = C_forwardKinematicsWrapper(skel,mot.rootTranslation,mot.rotationQuat);
        otherwise
            error('Wrong number of output arguments!');
    end

%     mot.boundingBox          = computeBoundingBox(mot);
end