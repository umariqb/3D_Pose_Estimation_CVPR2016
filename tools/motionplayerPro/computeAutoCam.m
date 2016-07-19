function computeAutoCam(varargin)

global SCENE;

    if ~isfield(SCENE,'camPosition')

        % get 1st mot

        nframes = SCENE.mots{1}.nframes;

        % compute trajectory camera will follow

        if ~isempty(SCENE.mots{1}.rootTranslation)
            trajectoryRoot = SCENE.mots{1}.rootTranslation;
        else
            trajectoryRoot = SCENE.mots{1}.jointTrajectories{14};
        end
        oldts = 1:30:nframes;
        if oldts(end)~=nframes
            oldts = [oldts nframes];
        end
        trajectoryRoot = spline(oldts ,trajectoryRoot(:,oldts),1:nframes);

        %%%% kleiner Hack (wie die ganze auto cam) um zu rotieren wenn die
        %%%% motions gespreaded sind.
        if SCENE.status.spread == true
           trajectoryRoot      = trajectoryRoot([3 2 1],:);
           trajectoryRoot(3,:) = -1*trajectoryRoot(3,:);
        end
        %%%%

        % get current camera data
        camPos = get(gca,'CameraPosition');
        % compute camera trajectories

        % write to scene


          SCENE.camPosition= repmat(camPos,nframes,1)';
          SCENE.camTarget  = trajectoryRoot;
    else
        rmfield(SCENE,'camPosition');
        rmfield(SCENE,'camTarget');
    end
    
end