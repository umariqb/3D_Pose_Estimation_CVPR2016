function [skel,mot]=constructMotion(Tensor,x,varargin)

% y=x;
% for i=1:size(y,2)
%     tmp=sum(y{i});
%     if(tmp~=0)
%         y{i}=y{i}/(tmp);
%     end
% end

% numModes=Tensor.numTechnicalModes+Tensor.numNaturalModes;
% counter=length(x);
% 
% for i=numModes:-1:1
%     if (counter>0) && (size(x{counter},2)==size(Tensor.factors{i},1))
%         % optimized mode
%         Tensor.core = modeNproduct(Tensor.core,x{counter}*Tensor.factors{i},i);
%         counter = counter-1;
%     else
%         % not optimized mode
%         Tensor.core=modeNproduct(Tensor.core,Tensor.factors{i},i);
%     end
% end

for i=1:Tensor.numTechnicalModes
    Tensor.core=modeNproduct(Tensor.core,Tensor.factors{i},i);
end

for i=1:Tensor.numTechnicalModes-1
    Tensor.rootcore = modeNproduct(Tensor.rootcore,Tensor.rootfactors{i},i);
end

for i=1:Tensor.numNaturalModes
    Tensor.core = modeNproduct(Tensor.core,x{i}*Tensor.factors{Tensor.numTechnicalModes+i},Tensor.numTechnicalModes+i);
end

for i=1:Tensor.numNaturalModes
    Tensor.rootcore = modeNproduct(Tensor.rootcore,...
        x{i}/(sum(x{i}))*Tensor.rootfactors{Tensor.numTechnicalModes-1+i},Tensor.numTechnicalModes-1+i);
end

switch nargin
    case 2
       skel = readASF(Tensor.skeletons{1,1});
    case 3
        if (isstruct(varargin{1}))
            skel=varargin{1};
        else
            skel = readASF(Tensor.skeletons{1,1});
        end
    otherwise
        error('constructMotion: Wrong number of arguments\n');
end

mot=createMotionFromCoreTensor_jt(Tensor.core,Tensor.rootcore,skel,true,true,Tensor.DataRep);

