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

function [X] = findCoefficients(Tensor,newMot,varargin)

% Align first new Motion like all others!
[skel,fitmot]=reconstructMotionT(Tensor,[1 1]);
skel = readASF(Tensor.skeletons{1,1});
newMot=fitMotion(skel,newMot);
% Timewarp motion
[newMot]=SimpleDTW(fitmot,skel,newMot);

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

% Set options for optimization
options = optimset('Display','iter','MaxFunEvals',2500,'MaxIter',500);


% Set lower and upper bounds for optimization variable x
dimvec=size(core_tmp);
n=sum(dimvec(nrOfTechnicalModes+1:end));
lb=-0.5*ones(1,n);
ub= 1.5*ones(1,n);

% Define used representation of motion data within the Tensor and
% define starting guess x0 if not set by user (through varargin)
x0=0;
for i=1:nrOfNaturalModes
    for j=1:dimvec(nrOfTechnicalModes+i)
        x0=[x0 1/dimvec(nrOfTechnicalModes+i)];
    end
end
x0=x0(2:end);

switch nargin
    case 2
        DataRep='Quat';
    case 3
        DataRep=varargin{1};
    case 4
        x0=varargin{2};
        DataRep=varargin{1};
    otherwise
        disp('Wrong number of arguments');
end

fprintf('\nlower bound     x0     upper bound\n');
disp([lb' x0' ub']);

tmpTensor=Tensor;
tmpTensor.core=core_tmp;
tmpTensor.rootcore=root_tmp;

[Y,RESNORM,RESIDUAL] = ...
    lsqnonlin(@(x) ...
        objfun( x,tmpTensor,newMot, ...
                nrOfNaturalModes,nrOfTechnicalModes,...
                dimvec,skel,DataRep) ...
        ,x0,lb,ub,options);
    
 % Show computed coefficients
for i=1:nrOfNaturalModes
    X{i}=Y(1:dimvec(i+nrOfTechnicalModes));
%     X2{i}=round(X{i});
    Y=Y(dimvec(i+nrOfTechnicalModes)+1:size(Y,2));
end

% Construct motion with computed coefficients and compute mean error
% [skel ,mot] =constructMotion(Tensor,X,skel,DataRep);
% [skel2,mot2]=constructMotion(Tensor,X2);

% d =compareMotions(mot, newMot,DataRep);
% d2=compareMotions(mot2,newMot);

% if d2<d
%     X=X2;
%     d=d2;
%     mot=mot2;
% end

for i=1:nrOfNaturalModes
    fprintf('\n X{%i}\n',i);
    disp(X{i}');
end
% fprintf('Mean error of joint orientations: E = %.3f degrees.\n',d);

    