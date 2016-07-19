function cvpr(opts, db)
%% Hashim Yasin
%%
% % % Left ankle:
% % % ( -601.893433 474.962067 179.973114 ) = points
% % % ( 554.048401 535.401306 4850.035645 ) = Camera coordinate
% % % Right ankle:
% % % ( -621.902161 96.068077 71.271500 )   = points
% % % ( 181.481949 625.012451 4944.593262 ) = Camera coordinate

%% selecting Options
close all;
usedArgin = -1;

if ~exist(opts.saveResPath,'dir')
    mkdir(opts.saveResPath);
end

% H_sendResLoop(opts)
% er = 0;
% return
%% Loading options, input and skel
[motIn, motInN, opts] = loadnPrepareQMot(opts);

%% Database Reading 
if(~isfield(db, 'pos'))
    % rootP2D = mean(motIn.rootP2D,2); 
    disp('Database Loading ... ')
    dbName = 'db';
    fname  = ['../Data/' dbName '.mat'];
    if(exist(fname,'file'))
        load(fname);
    %    [db, opts] = H_getActorMotIDs(db,opts);
    else
        disp('H_error: File is not exist');
    end

    fprintf('\b done \n');
    fprintf('Database Size: (%i   %i) \n',size(db.pos,1),size(db.pos,2));
end
%% KD-Tree development
motIn  = H_getSkelFitH36M(motIn,db.td2D(:,1:100:db.nrOfFrames),'-1to1');
%        motIn  = getSkelFit(motIn,db.td2D(:,1:100:db.nrOfFrames),'-1to1');
%         sname = ['inp_' opts.subject '_' opts.actName];
%         save(fullfile(opts.pathIn,sname),'motIn','-v7.3');
db.td2D (isnan(db.td2D)) = 0;
db.td2D   = db.td2D(opts.cJidx2,:); % only the selected joints are used during KD tree developement
fprintf('KD-Tree Size: (%i   %i) \n',size(db.td2D,1),size(db.td2D,2));
disp('KD-Tree development: ... ');
tic;
treeHandle  = ann_buildTree(db.td2D);
fprintf('\b done \n');
toc;
db = rmfield(db,'td2D');

%% nearest neighbour retrieval for each of the pose in motIn
retKNN(db,treeHandle,opts,motIn);

clear db;
% clear all;
end



