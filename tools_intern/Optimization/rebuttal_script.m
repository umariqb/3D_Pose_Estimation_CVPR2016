joints  = [4,9,17,21,28,18,25,19,26,3,8,23,30,6,11,12,13,14,15,16,22,29,5,10,20,27,2,7,24,31];
joints  = sort(joints);

samples = ceil(rand(1,100)*1038388);

searchtime16 = zeros(1,numel(joints));
for i=5:numel(joints)
    ids         = jointIDsToMatrixIndices(joints(1:i));
    treeData    = pos(ids.pos,:);
    treeQuery 	= treeData(:,samples);
    treeHandle  = ann_buildTree(double(treeData));
    
    tic;
    [nnidx,nndists] = ann_queryTree(treeHandle,treeQuery,16,{'eps',0.1});
    t=toc;
    searchtime16(i)=(t/numel(samples))*1000;
    fprintf('nr of joints: %i, time for search %.3f\n',i,searchtime16(i));
    ann_deleteTree(treeHandle);
end

searchtime256 = zeros(1,numel(joints));
for i=5:numel(joints)
    ids         = jointIDsToMatrixIndices(joints(1:i));
    treeData    = pos(ids.pos,:);
    treeQuery 	= treeData(:,samples);
    treeHandle  = ann_buildTree(double(treeData));
    
    tic;
    [nnidx,nndists] = ann_queryTree(treeHandle,treeQuery,256,{'eps',0.1});
    t=toc;
    searchtime256(i)=(t/numel(samples))*1000;
    fprintf('nr of joints: %i, time for search %.3f\n',i,searchtime256(i));
    ann_deleteTree(treeHandle);
end
    