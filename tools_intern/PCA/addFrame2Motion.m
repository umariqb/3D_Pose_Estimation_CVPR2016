function mot=addFrame2Motion(mot,Frame)

    mot.nframes=mot.nframes+Frame.nframes;

    for j=1:mot.njoints
        if ~(isempty(mot.jointTrajectories))&&~(isempty(Frame.jointTrajectories))
            mot.jointTrajectories{j}    = [mot.jointTrajectories{j} Frame.jointTrajectories{j}];
        end
        if ~(isempty(mot.rotationQuat))&&~(isempty(Frame.rotationQuat))
            if(~isempty(mot.rotationQuat{j}) && ~isempty(Frame.rotationQuat{j}))
                mot.rotationQuat{j}         = [mot.rotationQuat{j} Frame.rotationQuat{j}];
            end
        end
        if ~(isempty(mot.rotationEuler))&&~(isempty(Frame.rotationEuler))
            mot.rotationEuler{j}        = [mot.rotationEuler{j} Frame.rotationEuler{j}];
        end
        if isfield(mot,'jointVelocities') && isfield(Frame,'jointVelocities') && ...
          ~(isempty(mot.jointVelocities)) && ~(isempty(Frame.jointVelocities))
            mot.jointVelocities{j}      = [mot.jointVelocities{j} Frame.jointVelocities{j}];
        end
        if isfield(mot,'jointAccelerations') && isfield(Frame,'jointAccelerations') && ...
                ~(isempty(mot.jointAccelerations))&&~(isempty(Frame.jointAccelerations))
            mot.jointAccelerations{j}   = [mot.jointAccelerations{j} Frame.jointAccelerations{j}];
        end
    end

    mot.rootTranslation=[mot.rootTranslation Frame.rootTranslation];
    if ~isempty(mot.jointTrajectories)
        mot.boundingBox=computeBoundingBox(mot);
    end
end