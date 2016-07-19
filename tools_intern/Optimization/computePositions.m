function mot=computePositions(mot)

njoints     = mot.njoints;
nframes     = mot.nframes;
frameTime   = mot.frameTime;

acc         = mot.jointAccelerations;
vel         = cell(njoints,1);
pos         = cell(njoints,1);
velOld      = cell(njoints,1);
velMean     = cell(njoints,1);
posOld      = cell(njoints,1);
posMean     = cell(njoints,1);
cVel        = cell(njoints,1);
cPos        = cell(njoints,1);

for i=1:njoints
    if isfield(mot,'jointVelocities')&&~isempty(mot.jointVelocities)
        cVel{i} = mot.jointVelocities{i}(:,1);
    else
        cVel{i} = 0;
    end
    if isfield(mot,'jointTrajectories')&&~isempty(mot.jointTrajectories)
        cPos{i} = mot.jointTrajectories{i}(:,1) * 2.54 / 100;
    else
        cPos{i} = 0;
    end
end

for i=1:njoints
    
    vel{i}(:,1)   = acc{i}(:,1)*frameTime + cVel{i};
    pos{i}(:,1)   = vel{i}(:,1)*frameTime + cPos{i};
    
    for frame = 1:nframes-1
        vel{i}(:,frame+1)       = acc{i}(:,frame+1)*frameTime + vel{i}(:,frame);
        velOld{i}(:,frame)      = vel{i}(:,frame+1) - acc{i}(:,frame)*frameTime;
        velMean{i}(:,frame)     = 0.5 * (velOld{i}(:,frame) + vel{i}(:,frame));
        vel{i}(:,frame+1)       = acc{i}(:,frame+1)*frameTime + velMean{i}(:,frame);
        
        pos{i}(:,frame+1)       = vel{i}(:,frame+1)*frameTime + pos{i}(:,frame);
        posOld{i}(:,frame)      = pos{i}(:,frame+1) - vel{i}(:,frame)*frameTime;
        posMean{i}(:,frame)     = 0.5 * (posOld{i}(:,frame) + pos{i}(:,frame));
        pos{i}(:,frame+1)       = vel{i}(:,frame+1)*frameTime + posMean{i}(:,frame);
    end
    mot.jointVelocitiesRec{i,1}   = vel{i};
    mot.jointTrajectoriesRec{i,1} = pos{i}*100/2.54;
end