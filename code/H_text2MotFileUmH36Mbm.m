function [matFileName] =  H_text2MotFileUmH36Mbm(dataName, strPath, savePath)
%% options to set
subject = 11;
activityName = 'Activity_All';

%% get activity info from textfile and frame number
strName = [strPath dataName];
impData = importdata(strName);
%% getting 2D info from for all joints
motIn            = H_emptyMotion2D;
motIn.inputDB    = 'Human36Mbm';
motIn.inFeatType = 'pgUmar';
motIn.njoints    = 14;
motIn.nframes    = size(impData.data,1);

cn = 1;
for cs = 8:35
    f2dc = char(impData.textdata{:,cs});
    f2d = str2num(f2dc);
    feat2d(cn,:) = f2d;
    cn = cn + 1;
end
i = 1;
for k = 1:motIn.njoints
    motIn.jointTrajectories2D{k,1}(:,:) = feat2d(i:i+1,:);
    i = i + 2;
end
%--------------------------------------------------------------------------
act = 1;
motIn.activityName{1,1} = '';
for f = 1:size(impData.textdata,1)
    token   = textscan(impData.textdata{f}, '%s', 'delimiter', '/');
    tNum = textscan(token{1}{end}, '%s', 'delimiter', '.');
    framNum = textscan(tNum{1}{1}, '%s', 'delimiter', '_');
    %
    motIn.activityName{f,1} = framNum{1}{1}; 
    if (f ~= 1)    
        if(~strcmp(motIn.activityName{f,1},motIn.activityName{f-1,1}))
            act = act + 1;           
        end
    end
    motIn.activityFrNum(f,1) = act;
    motIn.activityFrNum(f,2) = str2double(framNum{1}{end});
    motIn.activityFrNum(f,3) = str2double(framNum{1}{end});
    clear tNum;
    clear framNum;
end

%%
motIn.jointNames  = {'Head'; 'Neck'; 'Left Shoulder'; 'Right Shoulder'; 'Left Hip'; 'Right Hip'; 'Left Elbow';
    'Left Wrist';'Right Elbow';'Right Wrist';'Left Knee'; 'Left Ankle';
    'Right Knee'; 'Right Ankle'}; % as it is

% motIn.jointNames  = {'Head';'Chin'; 'Neck'; 'Left Shoulder'; 'Right Shoulder'; 'Abdomen'; 'Root'; 'Left Hip'; 'Right Hip'; 'Left Elbow'; 
%     'Left Wrist';'Right Elbow';'Right Wrist';'Left Knee'; 'Left Ankle'; 
%     'Right Knee'; 'Right Ankle'};% change left 2 right

motIn.samplingRate      = 200;
motIn.frameTime         = 1/motIn.samplingRate;
motIn.subject           = ['S' num2str(subject)];
motIn.action            = activityName;
motIn.filename          = dataName;
motIn.vidStartFrame     = 1;
motIn.vidEndFrame       = size(impData.textdata,1);
motIn.mocStartFrame     = 1;
motIn.mocEndFrame       = size(impData.textdata,1);
motIn.frameNumbers(1,:) = 1:size(impData.textdata,1);
motIn.frameNumbers(2,:) = 1:size(impData.textdata,1);
motIn.dimData           = '2D';
for i = 1:length(motIn.markerNames)
    motIn.nameMap{i,1} = char(motIn.markerNames(i));
    motIn.nameMap{i,2} = 0;
    motIn.nameMap{i,3} = i;
end

%%
act = 1; subact = 1; camera = 2;
Sequence         = H36MSequence(subject, act, subact, camera,1);
motIn.camera     = Sequence.getCamera();
motIn.comments   = {'1: The joints name order is according to provided file by PG.';
                  '2: Frame numbers for each activity is provided in ativityFrNum.'};
%%
strn = ['motIn_S' num2str(subject) '_'  activityName  '_C' num2str(camera)];

if(isempty(savePath))
    save(fullfile(strPath,[strn '.mat']),'motIn','-v7.3');
else
    save(fullfile(savePath, [strn '.mat']), 'motIn','-v7.3');
end

matFileName = [strn '.mat'];

end

