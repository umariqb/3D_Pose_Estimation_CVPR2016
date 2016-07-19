function [ResultX,ResultY,ResultXRoot,OptYRoot,optc,stepsSA,optSA] = ...
                    findCoefficientsCombinedStrategyColumnExtraRoot  ...
                    (Tensor,newMot,varargin)

switch nargin
    case 2
      DataRep='ExpMap';
      remindSteps=true;
      alpha=0.996;
      skel=0;
    case 3
      DataRep=varargin{1};
      remindSteps=false;
      alpha=0.996;      
      skel=0;
    case 4
      DataRep=varargin{1};
      remindSteps=varargin{2};
      alpha=0.996; 
      skel=0;
    case 5
      DataRep=varargin{1};
      remindSteps=varargin{2};
      alpha=varargin{3};
      skel=0;
    case 6
      DataRep=varargin{1};
      remindSteps=varargin{2};
      alpha=varargin{3};
      skel=varargin{4};  
    otherwise
        error('findCoefficientsCombinedStrategy: Wrong number of args.');
end

% optc=inf;
% count=1;
startx=0;

dim= size(Tensor.core);
dim= dim(Tensor.numTechnicalModes+1:size(dim,2));


    [OptX,OptY,optc,stepsSA,optSA] = findCoefficientsSimulatedAnnealingColumn ...
                        (Tensor,newMot,DataRep,500,startx,remindSteps,alpha,skel);
  


% if remindSteps
%     plotSimAnnPath(optSA,stepsSA,1,2,3);
%     drawnow;
% end

[X_ML] = findCoefficientsColumn(Tensor,newMot,DataRep, OptX, skel);


[OptXRoot,OptYRoot]        = findCoefficientsColumnRoot ...
                             (Tensor,newMot,DataRep);
% [OptXRoot,OptYRoot,optc] = findCoefficientsSimulatedAnnealingColumnRoot ...
%                            (Tensor,newMot,DataRep,20000,0,remindSteps,0.992);



ResultX=vectorToCellArray(X_ML,dim);
ResultY=getRowCoefficients(Tensor,X_ML);

ResultXRoot=vectorToCellArray(OptXRoot,dim);

for i=1:Tensor.numNaturalModes
    fprintf('\n Result{%i}\n',i);
    disp(ResultX{i}');
end

for i=1:Tensor.numNaturalModes
    fprintf('\n Result{%i}\n',i);
    disp(ResultY{i});
end


