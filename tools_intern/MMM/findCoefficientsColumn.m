% FUNCTION findCoefficients searches for optimal coefficients to 
% reconstruct a given motion out of a given tensor. It uses the Matlab
% Optimization Toolbox.
% INPUT:
%   Tensor:         struct: containing data, core, matrices.
%   newMot:         struct: the motion that should be reconstructed.
%   varargin{1}:    string: Type of data Representation 'Quat' or 'Position'
%   varargin{2}:    cell of arrays: Start values for optimization values
%                   have to correspond to the number of natural and
%                   technical modes.
%   
% OUTPUT:
%   X:              cell array: coefficients found for best solution
%   Y:              cell array: X normalized to length 1
%   mot:            struct: motion reconstructed with X
%   d:              float: distance, correponding to the used distance
%                   measure between mot and newMot.

function [X] = findCoefficientsColumn(Tensor,newMot,varargin)

% Align first new Motion like all others!
% [skel,fitmot]=reconstructMotionT(Tensor,[1 1 1]);
% skel = readASF(Tensor.skeletons{1,1});
% newMot=fitMotion(skel,newMot);
% Timewarp motion
%[newMot]=SimpleDTW(fitmot,skel,newMot);

nrOfTechnicalModes=Tensor.numTechnicalModes;

nrOfNaturalModes  =Tensor.numNaturalModes;

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

iter=500;
% Set options for optimization
options = optimset('Display','iter','MaxFunEvals',iter*12,'MaxIter',iter,'TolFun',1e-1);


% Set lower and upper bounds for optimization variable x
dimvec=size(core_tmp);
n=sum(dimvec(nrOfTechnicalModes+1:end));
%  lb=-0.5*ones(1,n);
%  ub= 1.5*ones(1,n);

% Define used representation of motion data within the Tensor and
% define starting guess x0 if not set by user (through varargin)
x0=0;
for i=1:nrOfNaturalModes
    for j=1:dimvec(nrOfTechnicalModes+i)
        x0=[x0 1/dimvec(nrOfTechnicalModes+i)];
    end
end
x0=x0(2:end);

setx0=false;
readSkel=true;
switch nargin
    case 2
        DataRep='Quat';
    case 3
        DataRep=varargin{1};
    case 4
        x0=varargin{2};
        setx0=true;
        DataRep=varargin{1};
    case 5
        x0=varargin{2};
        setx0=true;
        DataRep=varargin{1};
        skel=varargin{3};
        readSkel=false;
    otherwise
        disp('Wrong number of arguments');
end

if readSkel
    skel = readASF(Tensor.skeletons{1,1});
end

% if(setx0)
%     lb= min(x0)*ones(1,n);
%     ub= max(x0)*ones(1,n);
% else
    lb=-inf(1,n);
    ub= inf(1,n);
% end
% 
% fprintf('\nlower bound     x0     upper bound\n');
% disp([lb' x0' ub']);

tmpTensor=Tensor;
tmpTensor.core=core_tmp;
tmpTensor.rootcore=root_tmp;

[X,RESNORM,RESIDUAL] = ...
    lsqnonlin(@(x) ...
        objfunCol( x,tmpTensor,newMot, ...
                nrOfNaturalModes,nrOfTechnicalModes,...
                dimvec,skel,DataRep) ...
        ,x0,lb,ub,options);

    
% dim=size(Tensor.core);
% dim= dim(Tensor.numTechnicalModes+1:size(dim,2));
% Y=getRowCoefficients(Tensor,vectorToCellArray(X,dim));


    