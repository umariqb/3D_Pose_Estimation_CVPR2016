function [Result,optc,stepsSA,optSA] = findCoefficientsCombinedStrategyV2(Tensor,newMot,varargin)

switch nargin
    case 2
      DataRep='Quat';
      remindSteps=false;
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

% [OptX,optc,stepsSA,optSA] = findCoefficientsSimulatedAnnealingv2(Tensor,newMot,DataRep,1.5439*1000,0,remindSteps,0.999);
[OptX,optc,stepsSA,optSA] = findCoefficientsSimulatedAnnealingConstrained ...
                        (Tensor,newMot,DataRep,500,0,remindSteps,alpha,skel);

% if remindSteps
%     plotSimAnnPath(optSA,stepsSA,1,2,3);
%     drawnow;
% end

 [X_ML] = findCoefficients6D(Tensor,newMot,DataRep, OptX, skel);

Result=vectorToCellArray(X_ML,Tensor.dimNaturalModes);

for i=1:Tensor.numNaturalModes
    fprintf('\n Result{%i}\n',i);
    disp(Result{i}');
end
