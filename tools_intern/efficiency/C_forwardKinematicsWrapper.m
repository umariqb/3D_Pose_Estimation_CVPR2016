function [jointTrajectories,skel] = C_forwardKinematicsWrapper(skel,rootTranslation,rotationQuat)

    if nargin == 1

       if ~isfield(skel,'parents')
          skel.parents = computeParentsLocal(skel);
       end

       if ~isfield(skel,'bones')
          skel.bones = computeBonesLocal(skel);
       end
       jointTrajectories = 0;
    else
        
        nframes = size(rootTranslation,2);
        
        if ~isfield(skel,'parents')
            skel.parents = computeParentsLocal(skel);
        end

        if ~isfield(skel,'bones')
            skel.bones = computeBonesLocal(skel);
        end
       
        if iscell(rotationQuat)
            if ~isempty(skel.unanimated)
                if isempty(rotationQuat{skel.unanimated(1)})
                    rotationQuat(skel.unanimated) = {[ ones(1,nframes); ...
                        zeros(3,nframes)]};
                end
            end
            rotationQuat = cell2mat(rotationQuat);
            
        end

       if size(rotationQuat,1)<skel.njoints*4

          rotationQuat = [rotationQuat(1:4,:); ...
                           ones(1,nframes); ...
                          zeros(3,nframes); ...
                          rotationQuat(5:20,:);...
                           ones(1,nframes); ...
                          zeros(3,nframes); ...
                          rotationQuat(21:end,:)];

       end

       jointTrajectories = C_forwardKinematics(skel.parents,skel.bones,rootTranslation,rotationQuat);
       
    end
end

function bones = computeBonesLocal(skel)

   bones = zeros(3,skel.njoints);
   
   for i=1:skel.njoints
      
      bones(:,i) = skel.nodes(i,1).offset;
      
   end

end

function parents = computeParentsLocal(skel)

   parents = zeros(1,skel.njoints);

   for i=1:skel.njoints
      
      parents(:,i) = skel.nodes(i,1).parentID;
      
   end

end