function [xStart]=testTrivialCases(Tensor,mot,DataRep)

[skel,fitmot]=reconstructMotionT(Tensor,[1 1]);
[mot]=SimpleDTW(fitmot,skel,mot);

nrOfTechnicalModes=3;
nrOfNaturalModes=ndims(Tensor.core)-nrOfTechnicalModes;

% Compute mode-n-product of core tensor and all matrices related to 
% technical modes
core_tmp=Tensor.core;
for i=1:nrOfTechnicalModes
    core_tmp=modeNproduct(core_tmp,Tensor.factors{i},i);
end

root_tmp=Tensor.rootcore;
for i=1:nrOfTechnicalModes-1
    root_tmp=modeNproduct(root_tmp,Tensor.rootfactors{i},i);
end

tmpTensor=Tensor;
tmpTensor.core=core_tmp;
tmpTensor.rootcore=root_tmp;

dimvec=size(core_tmp);

Xbest=inf;
aBest=0;
rBest=0;

for actor=1:5
    for rep=1:3
       x0=zeros(1,8);
       x0(actor)=1;
       x0(5+rep)=1;
       tmp=objfun(  x0,tmpTensor,mot, ...
                    nrOfNaturalModes, ...
                    nrOfTechnicalModes,...
                    dimvec,skel,DataRep);
       tmpS=sum(tmp(:).*tmp(:));
        if(tmpS<Xbest)
            Xbest=tmpS;
            aBest=actor;
            rBest=rep;
        end
        fprintf('actor=%i , rep=%i d=%f \n',actor,rep,tmpS);
    end
end

xStart=zeros(1,8);
xStart(aBest)=1;
xStart(5+rBest)=1