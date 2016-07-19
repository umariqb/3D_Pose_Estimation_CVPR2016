function [X,stepsSA,optSA] = findCoefficientsCombinedStrategy(Tensor,newMot,varargin)

switch nargin
    case 2
      DataRep='Quat';
      remindSteps=false;
    case 3
      DataRep=varargin{1};
      remindSteps=false;
    case 4
      DataRep=varargin{1};
      remindSteps=varargin{2};
    otherwise
        error('findCoefficientsCombinedStrategy: Wrong number of args.');
end

% x0=testTrivialCases(Tensor,newMot,DataRep);

 [OptX,optc,stepsSA,optSA] = findCoefficientsSimulatedAnnealing2(Tensor,newMot,DataRep,2000,0,remindSteps);

[X] = findCoefficients(Tensor,newMot,DataRep, OptX);