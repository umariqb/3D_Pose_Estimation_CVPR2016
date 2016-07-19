% function recMotFromAcc
%
% db.acc
% db.quat
% 
% open questions concerning db:
% - coordinate frame transformation
% - resampling
% - sensor/joint offsets
% - flips that screw up accelerations
%
% more unsolved problems
% - initialization (t-pose)
% - choice of skeleton (optimization?)

function res = recMotFromAcc(db,skel,mot)

%% optional settings --------------------------------------------------------
nrOfNN          = 1;
eps             = 0.1;
% radius          = 5;
res.joints      = [5,10,21,28];

acc_direction   = 'xyz';

newFrameRate    = db.frameRate;
startFrame      = 1;
endFrame        = mot.nframes;

res.windowSize  = 16;

%% preprocessing ----------------------------------------------------------
fprintf('Preprocessing:\n');
res.joints  = sort(res.joints);
idx         = jointIDsToMatrixIndices(res.joints);
nrOfJoints  = numel(res.joints);

acc_idx = [];
if sum(acc_direction=='x')~=0, acc_idx=[acc_idx 1:3:nrOfJoints*3]; end
if sum(acc_direction=='y')~=0, acc_idx=[acc_idx 2:3:nrOfJoints*3]; end
if sum(acc_direction=='z')~=0, acc_idx=[acc_idx 3:3:nrOfJoints*3]; end
acc_idx = sort(acc_idx);

% % modification of original motion
% fprintf('Modification of original motion started...'); tic;
% mot                         = cutMotion(mot,startFrame,endFrame);
% mot                         = changeFrameRate(skel,mot,newFrameRate);
% res.origmot                 = mot;
% mot.rootTranslation(:,:)    = 0;
% mot                         = fitRootOrientationsFrameWise(skel,mot);
% if ~isfield(mot,'jointAcceleration');
%     mot                     = addAccToMot(mot);
% end
% mot.boundingBox             = computeBoundingBox(mot);
% res.origmot_mod             = mot;
% fprintf(' finished in %.2f seconds.\n',toc);

mot                 = cutMotion(mot,startFrame,endFrame);
mot                 = changeFrameRate(skel,mot,newFrameRate);
res.origmot_mod     = mot;

% tree construction
treeData = zeros(nrOfJoints*res.windowSize*length(acc_direction),size(db.pos,2)-res.windowSize+1);
fprintf('kd-tree construction started (#frames = %i, #dims = %i = %i joints x %i accs x %i frames)...\n',...
    size(treeData'), nrOfJoints,length(acc_direction),res.windowSize); tic;
% treeHandle      = ann_buildTree(double(db.acc(idx.pos,:)));
for i=1:size(db.acc,2)-res.windowSize+1
    tmp             = db.acc(idx.pos(acc_idx),i:i+res.windowSize-1)';
    treeData(:,i)   = tmp(:);
end
treeHandle      = ann_buildTree(treeData);
fprintf('finished in %.2f seconds.\n',toc);

% treeQuery       = cell2mat(mot.jointAccelerations(res.joints));
ma       = cell2mat(mot.jointAccelerations(res.joints));
ma       = ma(acc_idx,:);
treeQuery = zeros(nrOfJoints*res.windowSize*length(acc_direction),floor(mot.nframes/res.windowSize));
for i=1:res.windowSize:mot.nframes-res.windowSize+1
    tmp = ma(:,i:i+res.windowSize-1)';
    treeQuery(:,(i-1)/res.windowSize+1) = tmp(:);
end

fprintf('nn-search started (#frames = %i, #neighbours = %i)...',mot.nframes,nrOfNN);tic;
% [nnidx,nndists] = ann_queryTree(treeHandle,treeQuery,nrOfNN,'eps',eps,'search_sch','fr','radius',radius);
[res.nnidx,res.nndists] = ann_queryTree(treeHandle,treeQuery,nrOfNN,'eps',eps);
fprintf(' finished in %.2f seconds.\n',toc);

%% reconstruction ---------------------------------------------------------
fprintf('Reconstruction:\n');
hit = 1;
fprintf('Concatenating hits of rank %i and length %i...', hit, res.windowSize);
res.recmot                      = buildMotFromRotData(db.quat(:,res.nnidx(hit,1):res.nnidx(hit,1)+res.windowSize-1),skel);
res.recmot.samplingRate         = 30;
res.recmot.frameTime            = 1/30;
res.recmot.jointAccelerations   = mat2cell(db.acc(:,res.nnidx(hit,1):res.nnidx(hit,1)+res.windowSize-1),3*ones(1,31),res.windowSize);
% res.recmot              = addAccToMot(res.recmot);
for i=2:size(res.nnidx,2)
    tmp_mot                 = buildMotFromRotData(db.quat(:,res.nnidx(hit,i):res.nnidx(hit,i)+res.windowSize-1),skel);
    tmp_mot.samplingRate    = 30;
    tmp_mot.frameTime       = 1/30;
    tmp_mot.jointAccelerations = mat2cell(db.acc(:,res.nnidx(hit,i):res.nnidx(hit,i)+res.windowSize-1),3*ones(1,31),res.windowSize);
%     tmp_mot                 = addAccToMot(tmp_mot);
    res.recmot              = addFrame2Motion(res.recmot,tmp_mot);
end
fprintf(' finished in %.2f seconds.\n',toc);

%% postprocessing ---------------------------------------------------------
fprintf('Postprocessing:\n');
tic;
ann_cleanup;
fprintf('\b in %.2f seconds.\n',toc);
