function [skel,mot]=constructMotionExtraRoot(Tensor,x,xRoot,varargin)

%dimvec=size(Tensor.core);

% y=x;
% for i=1:size(y,2)
%     tmp=sum(y{i});
%     if(tmp~=0)
%         y{i}=y{i}/(tmp);
%     end
% end


nrOfTechnicalModes=3;
%nrOfNaturalModes=ndims(Tensor.core)-nrOfTechnicalModes;

for i=1:nrOfTechnicalModes
    Tensor.core=modeNproduct(Tensor.core,Tensor.factors{i},i);
end

for i=1:nrOfTechnicalModes-1
    Tensor.rootcore = modeNproduct(Tensor.rootcore,Tensor.rootfactors{i},i);
end

for i=size(x,2):-1:1
    Tensor.core = modeNproduct(Tensor.core,x{i}'*Tensor.factors{nrOfTechnicalModes+i},nrOfTechnicalModes+i);
end

for i=size(xRoot,2):-1:1
    Tensor.rootcore = modeNproduct(Tensor.rootcore,xRoot{i}*Tensor.rootfactors{nrOfTechnicalModes+i-1},nrOfTechnicalModes+i-1);
end

switch nargin
    case 3
       skel = readASF(Tensor.skeletons{1,1});
       data = 'Quat';
    case 4
        if (isstruct(varargin{1}))
            skel=varargin{1};
        else
            skel = readASF(Tensor.skeletons{1,1});
        end
        data = 'Quat';
    case 5
        if (isstruct(varargin{1}))
            skel=varargin{1};
        else
            skel = readASF(Tensor.skeletons{1,1});
        end
        data=varargin{2};
    otherwise
        error('constructMotion: Wrong number of arguments\n');
end


mot=createMotionFromCoreTensor(Tensor,skel,true,true,data);
mot=convert2euler(skel,mot);