function query=getQuerySequence(mot,frames)

%% Start time measurement
tic;

%% Copy original motion
query=mot;
nframes=mot.nframes;

%% Truncate result:
for i=1:query.njoints
    %% jointTrajectories
    if(~isempty(mot.jointTrajectories{i}))
        query.jointTrajectories{i}=mot.jointTrajectories{i}(:,nframes-frames+1:nframes);
    end
    if(~isempty(mot.rotationQuat{i}))
        query.rotationQuat{i}     =mot.rotationQuat{i}     (:,nframes-frames+1:nframes);
    end
end
%% rootTranslation
query.rootTranslation=mot.rootTranslation(:,nframes-frames+1:nframes);

query.nframes=frames;

%% Stop time measurement and print result:
time=toc;
disp(['Extracted new query in:         ' num2str(time) ' seconds']);