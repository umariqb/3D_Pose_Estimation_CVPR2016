function [X,S,M] = playCoefficient(Tensor,index1)

dim=size(size(Tensor.core),2);
dimvec=size(Tensor.core);

% [skel,mot]=reconstructMotionT(Tensor,[2 2]);
[skel,mot]=constructMotion(Tensor,{[0 1 0 0 0 ] [0 1 0]});
% Determine type of tensor, i.e. number of technical modes
nrOfTechnicalModes=3;
nrOfNaturalModes=2;

% for i=1:nrOfTechnicalModes
%     Tensor.core=modeNproduct(Tensor.core,Tensor.factors{i},i);
% end

n=sum(dimvec(nrOfTechnicalModes+1:dim));

x0=zeros(1,n);
x0(7)=1;
x0(2)=1;

vals=80;

% Compute mode-n-product of core tensor and all matrices related to
% technical modes
for i=1:nrOfTechnicalModes
    Tensor.core=modeNproduct(Tensor.core,Tensor.factors{i},i);
end


% Set lower and upper bounds for optimization variable x
dimvec=size(Tensor.core);

X=zeros(1,vals);

fprintf('i:             ');
for i=1:vals
    if(x0(index1)<0)
        fprintf('\b\b\b\b\b\b\b\b\b\b\b\b');
    else
        fprintf('\b\b\b\b\b\b\b\b\b\b\b');
    end
    fprintf('%2i',i);
    x0(index1)=(i/10-(vals/2)/10);
    fprintf(' x: %2.3f',x0(index1));

    tmp=objfun(x0,Tensor,mot,nrOfNaturalModes,nrOfTechnicalModes,dimvec,skel);
    X(i)=sum(tmp(:).*tmp(:));
end
fprintf('\n');