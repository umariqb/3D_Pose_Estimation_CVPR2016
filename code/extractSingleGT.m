function [motGT] = extractSingleGT(motGTIN, pos)
motGT                   = motGTIN;
motGT.nframes           = 1;

% Extract single frame from joint trajectories
jointTrajectories = motGT.jointTrajectories;
for i=1:size(jointTrajectories,1)
    tmp = jointTrajectories{i};
    tmp = tmp(:,pos);
    motGT.jointTrajectories{i} = tmp;
end

% Extract activity name
activityName            = motGT.activityName{pos};
motGT.activityName      = cell(1,1);
motGt.activityName{1}   = activityName;

activityFrNum           = motGT.activityFrNum(pos,:);
motGT.activityFrNum     = activityFrNum;

% Extract single frame from joint trajectories 2D
jointTrajectories2D = motGT.jointTrajectories2D;
for i=1:size(jointTrajectories2D,1)
    tmp = jointTrajectories2D{i};
    tmp = tmp(:,pos);
    motGT.jointTrajectories2D{i} = tmp;
end

% Extract Frame Numbers
frameNumbers            = motGT.frameNumbers;
motGT.frameNumbers      = frameNumbers(:,pos);

motGT.vidStartFrame     = pos;
motGT.vidEndFrame       = pos;

motGT.mocStartFrame     = pos;
motGT.mocEndFrame       = pos;

% Extract single frame from joint trajectories 2DF
jointTrajectories2DF = motGT.jointTrajectories2DF;
for i=1:size(jointTrajectories2DF,1)
    tmp = jointTrajectories2DF{i};
    tmp = tmp(:,pos);
    motGT.jointTrajectories2DF{i} = tmp;
end