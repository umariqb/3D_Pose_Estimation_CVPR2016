function Matrix=extractPCAMatForWindow(sframe,eframe,PCAMat)

AllFrames=size(PCAMat.data,2);

a=sframe;
b=eframe;

cutFrames=[];

while (AllFrames>a&&AllFrames>b)
    cutFrames=[cutFrames a:b];
    
    a=a+PCAMat.nframes;
    b=b+PCAMat.nframes;
end

Matrix.data=PCAMat.data(:,cutFrames);
    
% Calculate interesting stuff ...

% [Matrix.rootcoefs,Matrix.rootscores,Matrix.rootvariances,Matrix.roott2]...
%                = princomp(Matrix.rootdata');
           
[Matrix.coefs,Matrix.scores,Matrix.variances,Matrix.t2] ...
               = princomp(Matrix.data');

Matrix.mean    =mean(Matrix.data,2);
% Matrix.rootmean=mean(Matrix.rootdata,2);

Matrix.cov     =cov(Matrix.data');
% Matrix.rootCov =cov(Matrix.rootdata');

Matrix.inv     =pinv(Matrix.cov');
% Matrix.rootInv =pinv(Matrix.rootCov');

Matrix.DataRep=PCAMat.DataRep;

end