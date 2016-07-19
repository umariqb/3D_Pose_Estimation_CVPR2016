function [F,optProbs]=findCoefficientsFramePCA(skel,oFrame,PCAmat,optProbs)


optdim=11;

PCAmat.redCoefs =PCAmat.coefs(:,1:optdim);
% PCAmat.redScores=PCAmat.scores(:,1:7);
% PCAmat.redData=redMat*redTime';

%Startwert:

% if(isempty(optProbs.startValue))
    x0=ones(1,optdim)/optdim;
% else
%     x0=optProbs.startValue;
% end

lb=-inf(1,optdim);
ub= inf(1,optdim);

DataRep=PCAmat.DataRep;

options=optimset('Display',    optProbs.Display, ...
                 'MaxFunEvals',optProbs.FuncEvals,  ...
                 'MaxIter',    optProbs.Iterations, ...
                 'TolFun',     optProbs.TolFun);


[X,RESNORM,RESIDUAL] = ...
    lsqnonlin(@(x) objfunPCA(x,PCAmat,oFrame,skel,DataRep,optProbs) ...
        ,x0,lb,ub,options);


optProbs.startValue=X;
FrameData=PCAmat.redCoefs*X'+PCAmat.mean;

F=reconstructFramePCA(skel,oFrame,FrameData,DataRep);
optProbs.x_2=optProbs.x_1;
optProbs.x_1=FrameData;

