function [ResultX,ResultY,optc,stepsSA,optSA] = findCoefficientsCombinedStrategyColumn(Tensor,newMot,varargin)

switch nargin
    case 2
      DataRep='ExpMap';
      remindSteps=true;
      alpha=0.996;
    case 3
      DataRep=varargin{1};
      remindSteps=false;
      alpha=0.996;      
    case 4
      DataRep=varargin{1};
      remindSteps=varargin{2};
      alpha=0.996;    
    case 5
      DataRep=varargin{1};
      remindSteps=varargin{2};
      alpha=varargin{3};
    otherwise
        error('findCoefficientsCombinedStrategy: Wrong number of args.');
end

[OptX,OptY,optc,stepsSA,optSA] = findCoefficientsSimulatedAnnealingColumn ...
                        (Tensor,newMot,DataRep,100,0,remindSteps,alpha);

% if remindSteps
%     plotSimAnnPath(optSA,stepsSA,1,2,3);
%     drawnow;
% end

[X_ML] = findCoefficientsColumn(Tensor,newMot,DataRep, OptX);

dim=size(Tensor.core);
dim= dim(Tensor.numTechnicalModes+1:size(dim,2));
ResultX=vectorToCellArray(X_ML,dim);
ResultY=getRowCoefficients(Tensor,X_ML);

for i=1:Tensor.numNaturalModes
    fprintf('\n Result{%i}\n',i);
    disp(ResultX{i}');
end

for i=1:Tensor.numNaturalModes
    fprintf('\n Result{%i}\n',i);
    disp(ResultY{i});
end


