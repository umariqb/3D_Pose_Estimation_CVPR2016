function res = correlationScript(data)

res.nrOfFrames  = numel(data.frames);
sizeOfDB        = size(data.pos,2);

% res.nrOfNN  = sizeOfDB;
res.nrOfNN  = 256;
res.nrOfPC  = 12;

%% distance measures
d_e15_jointIDs      = [4,9,17,21,28];
d_e15_matrixIDs     = jointIDsToMatrixIndices(d_e15_jointIDs);

if res.nrOfNN < sizeOfDB
    d_e15_treeHandle    = ann_buildTree(data.pos(d_e15_matrixIDs.pos,:));
    d_pca_treeHandle    = ann_buildTree(data.pos_score(:,1:res.nrOfPC)');
end

cc_e15_pc1      = zeros(1,res.nrOfFrames);
cc_e15_pca      = zeros(1,res.nrOfFrames);
cc_pca_pc1      = zeros(1,res.nrOfFrames);
cc_pca_e15      = zeros(1,res.nrOfFrames);
cc_e15_pc11     = zeros(1,res.nrOfFrames);
cc_pca_pc11     = zeros(1,res.nrOfFrames);

nndists.d_pc1_pca   = zeros(1,res.nrOfNN);
nndists.d_pc1_e15   = zeros(1,res.nrOfNN);
nndists.d_pc11_pca  = zeros(1,res.nrOfNN);
nndists.d_pc11_e15  = zeros(1,res.nrOfNN);

counter2 = 0;
fprintf('\n%4i frames in total\n',res.nrOfFrames);

fprintf('\t\t\t\t\t');
for i=data.frames
    counter     = 0;
    counter2    = counter2 + 1;
    fprintf('\b\b\b\b\b%4i ',counter2);
    
    Q1  = reshape(data.pos(:,i),3,31);
    Q11 = reshape(data.pos(:,i-5:i+5),3,31*11);
    
    if res.nrOfNN < sizeOfDB
        [nnidx.d_e15,nndists.d_e15_e15]  = ann_queryTree(d_e15_treeHandle,data.pos(d_e15_matrixIDs.pos,i),res.nrOfNN,{'eps',0.1});
        [nnidx.d_pca,nndists.d_pca_pca]  = ann_queryTree(d_pca_treeHandle,data.pos_score(i,1:res.nrOfPC)',res.nrOfNN,{'eps',0.1});
    else  
        nnidx.d_e15         = (1:sizeOfDB)';
        nnidx.d_pca         = nnidx.d_e15;
        nndists.d_e15_e15   = sqrt(sum((repmat(data.pos(d_e15_matrixIDs.pos,i),1,res.nrOfNN)-data.pos(d_e15_matrixIDs.pos,:)).^2,1));
        nndists.d_pca_pca   = sqrt(sum((repmat(data.pos_score(i,1:res.nrOfPC),res.nrOfNN,1)-data.pos_score(:,1:res.nrOfPC)).^2,2));
    end
    
%     fprintf('\n\t\t\t\t\t\t\t');
    for j=nnidx.d_e15'
        counter = counter+1;
%         if mod(counter,100)==0
%             fprintf('\b\b\b\b\b\b\b%7i',counter);
%         end
        
        P1  = reshape(data.pos(:,j),3,31);
        d1  = pointCloudDist_modified(P1,Q1,'pos');
        nndists.d_pc1_e15(counter)  = sum(sqrt(sum(d1.^2)));
        
        if isempty(intersect(j-4:j+6,data.motStartIDs))
            P11 = reshape(data.pos(:,j-5:j+5),3,31*11);
            d11 = pointCloudDist_modified(P11,Q11,'pos');
            nndists.d_pc11_e15(counter) = sum(sqrt(sum(d11.^2)));
            %          = (sqrt(sum(d(:).^2)));
            %          = sum(d(:).^2);
        else
            nndists.d_pc11_e15(counter) = -1; 
        end
    end
%     fprintf('%3i ',sum(nndists.d_pc11_e15<0));
%     fprintf('\n');
    
    counter = 0;
%     fprintf('\n\t\t\t\t\t\t\t');
    for j=nnidx.d_pca'
        counter = counter+1;
%         if mod(counter,100)==0
%             fprintf('\b\b\b\b\b\b\b%7i',counter);
%         end
        
        P1  = reshape(data.pos(:,j),3,31);
        d1  = pointCloudDist_modified(P1,Q1,'pos');
        nndists.d_pc1_pca(counter)  = sum(sqrt(sum(d1.^2)));
        
        if isempty(intersect(j-4:j+6,data.motStartIDs))
            P11 = reshape(data.pos(:,j-5:j+5),3,31*11);
            d11 = pointCloudDist_modified(P11,Q11,'pos');
            nndists.d_pc11_pca(counter) = sum(sqrt(sum(d11.^2)));
            %          = (sqrt(sum(d(:).^2)));
            %          = sum(d(:).^2);
        else
            nndists.d_pc11_pca(counter) = -1;
        end
    end
%     fprintf('%3i',sum(nndists.d_pc11_pca<0));
%     fprintf('\n\t\t\t\t\t');
    
    nndists.d_euler_e15 = sum(abs(data.euler(:,nnidx.d_e15)...
                -repmat(data.euler(:,i),1,res.nrOfNN)));
            
    nndists.d_euler_pca = sum(abs(data.euler(:,nnidx.d_pca)...
                -repmat(data.euler(:,i),1,res.nrOfNN)));
    
    nndists.d_pca_e15   = sqrt(sum((data.pos_score(nnidx.d_e15,1:res.nrOfPC)...
                -repmat(data.pos_score(i,1:res.nrOfPC),res.nrOfNN,1)).^2,2))';
            
    nndists.d_e15_pca   = sqrt(sum((data.pos(d_e15_matrixIDs.pos,nnidx.d_pca)...
                -repmat(data.pos(d_e15_matrixIDs.pos,i),1,res.nrOfNN)).^2,1))';
            

    tmp = corrcoef(nndists.d_e15_e15,nndists.d_pc1_e15);
    cc_e15_pc1(counter2) = tmp(2,1);
    
    tmp = corrcoef(nndists.d_e15_e15,nndists.d_pca_e15);
    cc_e15_pca(counter2) = tmp(2,1);
    
    tmp = corrcoef(nndists.d_pca_pca,nndists.d_pc1_pca);
    cc_pca_pc1(counter2) = tmp(2,1);
    
    tmp = corrcoef(nndists.d_pca_pca,nndists.d_e15_pca);
    cc_pca_e15(counter2) = tmp(2,1);
    
    tmp = corrcoef(nndists.d_e15_e15(nndists.d_pc11_e15>0),nndists.d_pc11_e15(nndists.d_pc11_e15>0));
    cc_e15_pc11(counter2) = tmp(2,1);
    
    tmp = corrcoef(nndists.d_pca_pca(nndists.d_pc11_pca>0),nndists.d_pc11_pca(nndists.d_pc11_pca>0));
    cc_pca_pc11(counter2) = tmp(2,1);
    
    tmp = corrcoef(nndists.d_euler_e15,nndists.d_e15_e15);
    cc_euler_e15 = tmp(2,1);
    
    tmp = corrcoef(nndists.d_euler_pca,nndists.d_pca_pca);
    cc_euler_pca = tmp(2,1);
    
end
fprintf('\n');

res.meanCC_e15_pc1      = mean(cc_e15_pc1);
res.meanCC_e15_pca      = mean(cc_e15_pca);
res.meanCC_pca_pc1      = mean(cc_pca_pc1);
res.meanCC_pca_e15      = mean(cc_pca_e15);
res.meanCC_e15_pc11     = mean(cc_e15_pc11);
res.meanCC_pca_pc11     = mean(cc_pca_pc11);
res.meanCC_euler_e15    = mean(cc_euler_e15);
res.meanCC_euler_pca    = mean(cc_euler_pca);

ann_cleanup;