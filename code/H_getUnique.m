function [nnidx2, nndists2] = H_getUnique(nnidx,nndists, knn)
%%
for s = 1:size(nnidx,2)
    try
        [tmpIdx, ia] = unique(nnidx(:,s),'stable');
        nndiststmp = nndists(ia);
        nnidx2(:,s) = tmpIdx(1:knn,:);
        nndists2(:,s) = nndiststmp(1:knn,:);
        tmpIdx      = [];
        nndiststmp= [];
    catch err
        disp('H_error: (H_getUnique) in getting unique indices');
    end
    
end