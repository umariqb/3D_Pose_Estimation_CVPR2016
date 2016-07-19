function [F,optProbs]=findCoefficientsFramePCA_Acce(skel,oFrame,PCAmat,optProbs)


optdim=15;

lastOframe=extractFrame(oFrame,oFrame.nframes);

PCAmat.redCoefs  =PCAmat.coefs(:,1:optdim);

% if isempty(optProbs.x)
%     oFrameData=extractFrameData(lastOframe);
%     x0=PCAmat.redCoefs'*(oFrameData-PCAmat.mean);
%       
%     
% else
%     x0=optProbs.x;
% end

if(isempty(optProbs.startValue))
    x0=ones(1,optdim)/optdim;
else
    x0=optProbs.startValue;
end

% PCAmat.redScores=PCAmat.scores(:,1:7);
% PCAmat.redData=redMat*redTime';

%Startwert:

% if(isempty(optProbs.startValue))
%     x0=ones(1,optdim)/optdim;
% else
%     x0=optProbs.startValue;
% end

lb=-inf(1,optdim);
ub= inf(1,optdim);

DataRep=PCAmat.DataRep;

options=optimset('Display',    optProbs.Display, ...
                 'MaxFunEvals',optProbs.FuncEvals,  ...
                 'MaxIter',    optProbs.Iterations, ...
                 'TolFun',     optProbs.TolFun, ...
                 'TolX',    optProbs.TolFunX);

[X,RESNORM,RESIDUAL] = ...
    lsqnonlin(@(x) objfunPCA_Acce(x,PCAmat,oFrame,skel,optProbs) ...
        ,x0,lb,ub,options);


optProbs.startValue=X;
FrameData=PCAmat.redCoefs*X'+PCAmat.mean;
F=reconstructFramePCA(skel,lastOframe,FrameData,DataRep);

optProbs.x=X;

optProbs.x_2=optProbs.x_1;
optProbs.x_1=FrameData;

if(isempty(optProbs.recmot))
    optProbs.recmot=F;
else
    optProbs.recmot=addFrame2Motion(optProbs.recmot,F);
end


