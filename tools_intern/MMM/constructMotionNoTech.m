function [skel,mot]=constructMotionNoTech(Tensor,x,varargin)

%dimvec=size(Tensor.core);

nrOfTechnicalModes=Tensor.numTechnicalModes;
%nrOfNaturalModes=ndims(Tensor.core)-nrOfTechnicalModes;
% 
% for i=1:nrOfTechnicalModes
%     Tensor.core=modeNproduct(Tensor.core,Tensor.factors{i},i);
% end
% 
% for i=1:nrOfTechnicalModes-1
%     Tensor.rootcore = modeNproduct(Tensor.rootcore,Tensor.rootfactors{i},i);
% end

for i=size(x,2):-1:1
    Tensor.core = modeNproduct( ...
                    Tensor.core, ...
                    sum(diag(x{i})*Tensor.factors{nrOfTechnicalModes+i}), ...
                    nrOfTechnicalModes+i ...
                  );
end

for i=size(x,2):-1:1
    ii=nrOfTechnicalModes+i-1;
    Tensor.rootcore = modeNproduct( ...
                        Tensor.rootcore, ...
                        sum(diag(x{i})*Tensor.rootfactors{ii}), ...
                        ii ...
                      );
end

switch nargin
    case 2
        skel = readASF(Tensor.skeletons{1,1});
        DataRep='Quat';
    case 3
        skel=varargin{1};
        DataRep='Quat';
    case 4
        skel=varargin{1};
        DataRep=varargin{2};
    otherwise
        disp('Wrong number of arguments');
end


mot=createMotionFromCoreTensor(Tensor,skel,true,true,DataRep);

% animate(skel,mot)