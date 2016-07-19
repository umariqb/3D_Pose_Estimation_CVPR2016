function H_text2MotFile(dataName, strPath,dimInfo)

motIn      = emptyMotionLocal;

strName  = [strPath dataName];
fid      = fopen(strName);
cSpace   = char('\n');
txtData  = fscanf(fid, ['%f', cSpace]);

token    = textscan(dataName, '%s', 'delimiter', '_');

motIn.njoints = 14;
frmInfo     = 2;                                  % video data and mocap data
incr        = motIn.njoints * dimInfo + frmInfo;
if(mod(length(txtData),incr))
    txtData(1) = [];
end
motIn.nframes       = length(txtData)/incr;
txtData           = reshape(txtData, incr, length(txtData)/incr);
i = 3;
for k = 1:motIn.njoints
    motIn.jointTrajectories{k,1}(:,:) = txtData(i:i+2,:);
    i = i + 3;
end
%%
% mot.jointNames = {'Right Ankle'; 'Right Knee'; 'Right Hip'; 'Left Hip'; 'Left Knee'; 'Left Ankle';...
%     'Right Wrist'; 'Right Elbow'; 'Right Shoulder'; 'Left Shoulder';'Left Elbow';...
%     'Left Wrist'; 'Neck'; 'Head'};
motIn.jointNames  = {'Left Ankle'; 'Left Knee'; 'Left Hip'; 'Right Hip'; 'Right Knee'; 'Right Ankle';...
    'Left Wrist'; 'Left Elbow'; 'Left Shoulder'; 'Right Shoulder';'Right Elbow';...
    'Right Wrist'; 'Neck'; 'Head'};

motIn.markerNames       = {'RTIO'; 'RFEO'; 'RFEP'; 'LFEP'; 'LFEO'; 'LTIO'; 'RRAO'; 'RHUO'; ...
                         'RCLO'; 'LCLO'; 'LHUO'; 'LRAO'; 'TRXO'; 'LFHD'; 'RFHD'};
motIn.samplingRate      = 120;
motIn.frameTime         = 1/motIn.samplingRate;
motIn.subject           = token{1,1}{1,1};
motIn.action            = token{1,1}{2,1};
motIn.trail             = token{1,1}{3,1};
motIn.camera            = strtok(token{1,1}{4,1}, '.');
motIn.filename          = dataName;
motIn.frameNumbers(1,:) = txtData(1,:);
motIn.frameNumbers(2,:) = txtData(2,:);
motIn.vidStartFrame     = txtData(1);
motIn.vidEndFrame       = txtData(1,motIn.nframes);
motIn.mocStartFrame     = txtData(2);
motIn.mocEndFrame       = txtData(2,motIn.nframes);
if(motIn.vidStartFrame == motIn.vidEndFrame)
    motIn.vidEndFrame   = motIn.vidStartFrame + motIn.nframes - 1;
end
if (dimInfo == 2)
    motIn.dimData       = '2D';
else
    motIn.dimData       = '3D';
end
motIn.boundingBox       = computeBoundingBox(motIn);
for i = 1:length(motIn.markerNames)
    motIn.nameMap{i,1} = char(motIn.markerNames(i));
    motIn.nameMap{i,2} = 0;
    motIn.nameMap{i,3} = i;
end
%% filp the left side towards right side
% qy            = rotquat(180,'y');
% for m = 1:mot.njoints
%     mot.jointTrajectories{m}(:,:)  = quatrot(mot.jointTrajectories{m}(:,:),qy);
% end

%%
strRes               = strtok(dataName,  '.');
save(fullfile(strPath,[strRes '.mat']),'motIn','-v7.3');
end

function mot = emptyMotionLocal
%%
mot = struct('name','pgIlya',...  
    'njoints',0,...                            % number of joints
    'nframes',0,...                            % number of frames
    'frameTime',nan,...                      % inverse sampling rate: time per frame (in seconds)
    'samplingRate',nan,...                     % sampling rate (in Hertz) (120 Hertz is Carnegie-Mellon Mocap-DB standard)
    'jointTrajectories',cell(1,1),...          % 3D joint trajectories
    'rootTranslation',[],...                   % global translation data stream of the root
    'rotationEuler',cell(1,1),...              % rotational data streams for all joints, including absolute root rotation at pos. 1, Euler angles
    'rotationQuat',cell(1,1),...               % rotational data streams for all joints, including absolute root rotation at pos. 1, quaternions
    'jointNames',cell(1,1),...                 % cell array of joint names: maps node ID to joint name
    'markerNames',cell(1,1),...                % cell array of marker names:
    'boundingBox',[],...                       % bounding box (given a specific skeleton)
    'filename','');                            % source filename
end

