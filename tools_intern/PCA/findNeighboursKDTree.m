function Matrix=findNeighboursKDTree(sample,tree,PCAMat,PCADataRep)

neighbours=0;
dist=0.01;

while neighbours<20

    dist=dist+0.01;
    range(:,1)=sample-0.5*dist;
    range(:,2)=sample+0.5*dist;

    pntidx = kdtree_range(tree,range);

    neighbours=size(pntidx,2);

    fprintf('\n\n Found %i Neighbours!\n\n',neighbours);

end

Matrix.data=PCAMat(:,pntidx);

[Matrix.coefs,Matrix.scores,Matrix.variances,Matrix.t2] ...
               = princomp(Matrix.data');

Matrix.mean    =mean(Matrix.data,2);

Matrix.cov     =cov(Matrix.data');

Matrix.inv     =pinv(Matrix.cov);

Matrix.DataRep =PCADataRep;