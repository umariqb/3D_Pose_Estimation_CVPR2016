function retKNN(db,treeHandle,opts,motIn)
% String Name and Path Name Handling
sFrame       = opts.sFrame;
eFrame       = opts.eFrame;
allJoints    = opts.allJoints;
cJoints      = opts.cJoints;
knnJoints    = opts.allJoints;            % Retrieved joints
%% Visualizing Neighbourhood
obj.database = opts.database;
obj.type     = 'dot';
switch opts.database
    case {'Human80K','Human36Mbm','CMU_H36M'}
        obj.samplingRate = 200;
    case {'HumanEva_regFit','HumanEva','HDM05_c3d','CMU_c3d'}
        obj.samplingRate = db.samplingRate;
    case {'HDM05_amc','CMU_amc'}
        obj.samplingRate = db.frameRate;
    otherwise
        obj.samplingRate = 120;
end
obj.color        = 'green';
obj.knnJoints    = opts.allJoints;
obj.knn          = opts.knn;
obj.data         = zeros(3*numel(knnJoints)*obj.knn,motIn.nframes);
obj.bodyType     = opts.bodyType;
if(isfield(db,'rootP'))
    opts.mnRoot  = mean(db.rootP,2);
end
%%
queryData2D = cell2mat(motIn.jointTrajectories2DN);
inStartFr = motIn.vidStartFrame;
%%
disp('Getting indices and positions ... ');
tic
for countFrame = sFrame : eFrame
    idxFr = countFrame - sFrame + 1;
    fprintf('%5d ', idxFr);
    switch opts.method
        case '3D'
            countHEva = countFrame - inStartFr + 1;
            treeQuery = queryData(1:3*length(cJoints),countHEva);
        case '2Dsyn'
            countHEva = countFrame - inStartFr + 1;
            treeQuery = queryData2D(1:2*length(cJoints),countHEva);
        case '2Dvideo'
            if (strcmp(opts.algo, 'PG'))
                countHEva = countFrame - inStartFr + 1;
                treeQuery = queryData2D(opts.cJidx2,countHEva);
            end
    end
    [nnidxOrig(:,idxFr),nndistsOrig(:,idxFr)] = ann_queryTree(treeHandle,treeQuery,opts.qknn,{'eps',0.1});
     if (strcmp(opts.method,'2Dsyn') || strcmp(opts.method,'2Dvideo') ) % for syn input data
        nnidxTmp   = mod(int32(nnidxOrig(:,idxFr)),int32(db.nrOfFrames));
    end
    nnidxTmp( nnidxTmp == 0) = db.nrOfFrames;
    nnidx(:,idxFr)    = nnidxTmp;
    fprintf('\b\b\b\b\b\b');
end
toc
ann_cleanup;


%% Get Indices
[nnidx2, nndists2]   = H_getUnique(nnidx,nndistsOrig,opts.knn);
nnidx    = nnidx2(1:opts.knn,:);       % double check

%% Get Positions
% knnPos   = nan(3*length(knnJoints),obj.knn,motIn.nframes);
for f=1:motIn.nframes
    switch opts.database
        case {'HumanEva_regFit','CMU_30','HumanEva_H36M','CMU_H36M','Human36Mbm','Human80K','HumanEva','HDM05_c3d','CMU_c3d', 'CMU_amc_regFit','CMU_c3d_regFit'}
            knnPos (:,:,f) = cast(db.pos(:,nnidx(:,f))','double')';
            tmp            = knnPos (:,:,f);
            obj.data(:,f)  = tmp(:);  
        case {'HDM05_amc','CMU_amc'}           
            knnPos (:,:,f) = cast(db.pos(opts.controlIDX.pos,nnidx(:,f))','double')';
            tmp            = knnPos (:,:,f);
            obj.data(:,f)  = tmp(:);
        otherwise
            disp('H_error: H_retKNN:- Database is not mentioned in getting indices and positions');
    end
end
fprintf('\b done \n');


%% Optimization

objRt   = optimTransObj2MotInPerspSep(opts,obj,motIn,'all','yes');

%% obj manipulation
switch opts.inputDB
    case 'Human36Mbm'
        obj.data(1:3:end,:)   = -obj.data(1:3:end,:);
        if(strcmp(opts.database,'CMU_H36M'))
            %objRt.data(1:3:end,:) = -objRt.data(1:3:end,:);
        end
    case {'LeedSports', 'JHMDB'}
        obj.data(3:3:end,:)   = -obj.data(3:3:end,:);
        objRt.data(3:3:end,:) = -objRt.data(3:3:end,:);
end
oName   = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' opts.bodyType '_obj.mat'];
save(fullfile(opts.saveResPath,oName),'obj','-v7.3');
orName  = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' opts.bodyType '_objRt.mat'];
save(fullfile(opts.saveResPath,orName),'objRt','-v7.3');
sendRes(opts,objRt);

end



