function [skels,mots] = readKinectData(file)

    rawdata = importdata(file);
    if ~isempty(rawdata)
    timestamps = rawdata(:,1);
    skelids    = rawdata(:,2);
    skeldata   = rawdata(:,3:end);
    
    diffskelids = unique(skelids);
    numskels    = numel(diffskelids);
    
    mots    = cell(numskels,1);
    skels   = cell(numskels,1);
    nframes = zeros(numskels,1);
    
    for cs = 1:numskels
       mots{cs}  = emptyMotion();
       skels{cs} = emptySkeleton();
      
       mots{cs}.nframes    = sum(skelids==diffskelids(cs));
       mots{cs}.filename   = [file '_skel_' num2str(diffskelids(cs))];
       mots{cs}.timestamps = timestamps(skelids==diffskelids(cs));
       
       mots{cs}.jointTrajectories = skeldata(skelids==diffskelids(cs),:)'*100;
       mots{cs}.jointTrajectories = mat2cell(mots{cs}.jointTrajectories, ...
                                             3*ones(20,1),mots{cs}.nframes);
       
      [skels{cs},mots{cs}] = setKinectDefaultValues(skels{cs},mots{cs});

    end
    else
        skels=[];
        mots=[];
    end
    
    
    

end

function [skel,mot] = setKinectDefaultValues(skel,mot)
% Hardcoded properties of kinect skeleton ...
mot.njoints = 20;
mot.jointNames = {'HIP_CENTER', ...
                  'SPINE', ...
                  'SHOULDER_CENTER', ...
                  'HEAD', ...
                  'SHOULDER_LEFT', ...
                  'ELBOW_LEFT', ...
                  'WRIST_LEFT', ...
                  'HAND_LEFT', ...
                  'SHOULDER_RIGHT', ...
                  'ELBOW_RIGHT', ...
                  'WRIST_RIGHT', ...
                  'HAND_RIGHT', ...
                  'HIP_LEFT', ...
                  'KNEE_LEFT', ...
                  'ANKLE_LEFT',...
                  'FOOT_LEFT',...
                  'HIP_RIGHT',...
                  'KNEE_RIGHT',...
                  'ANKLE_RIGHT',...
                  'FOOT_RIGHT'}';
              
mot.boneNames = mot.jointNames;
mot.animated = 1:20;

skel.njoints   = mot.njoints;
skel.animated  = mot.animated;
skel.boneNames = mot.boneNames;
skel.filename  = mot.filename;
skel.nameMap   = mot.boneNames;

end