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

function [X,Y] = findCoefficientsColumnRoot(Tensor,newMot,varargin)

% Align first new Motion like all others!
% [skel,fitmot]=reconstructMotionT(Tensor,[1 1 1]);
skel = readASF(Tensor.skeletons{1,1});
newMot=fitMotion(skel,newMot);
% Timewarp motion
%[newMot]=SimpleDTW(fitmot,skel,newMot);

nrOfTechnicalModes=Tensor.numTechnicalModes-1;

nrOfNaturalModes  =Tensor.numNaturalModes;

for i=1:5%nrOfTechnicalModes-1
    Tensor.rootcore=modeNproduct(Tensor.rootcore,Tensor.rootfactors{i},i);
end
iter=20000;

% Set options for optimization
options = optimset('Display','iter','MaxFunEvals',iter*5,'MaxIter',iter,'TolFun',1e-3);


% Set lower and upper bounds for optimization variable x
dimvec=Tensor.dimNaturalModes;
n=sum(dimvec(nrOfTechnicalModes:end));
%  lb=-0.5*ones(1,n);
%  ub= 1.5*ones(1,n);

% Define used representation of motion data within the Tensor and
% define starting guess x0 if not set by user (through varargin)
x0=0;
for i=1:nrOfNaturalModes
    for j=1:dimvec(i)
        x0=[x0 1/dimvec(i)];
    end
end
x0=x0(2:end);

% x0=[];
%     for i=1:nrOfNaturalModes
%         y0=[];
%         for j=1:dimvec(i)
%             y0=[y0 1/dimvec(i)];
%         end
%         x0=[x0 (Tensor.factors{nrOfTechnicalModes+i}'*y0')'];
%     end



setx0=false;

switch nargin
    case 2
        DataRep='Quat';
    case 3
        DataRep=varargin{1};
    case 4
        x0=varargin{2};
        setx0=true;
        DataRep=varargin{1};
    otherwise
        disp('Wrong number of arguments');
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

%tmpTensor=Tensor;
%tmpTensor.rootcore=root_tmp;

[X,RESNORM,RESIDUAL] = ...
    lsqnonlin(@(x) ...
                    objfunColRoot(  x,Tensor,newMot, ...
                        nrOfNaturalModes, ...
                        nrOfTechnicalModes,...
                        dimvec,skel,DataRep), ...
                    x0,lb,ub,options);

    
dim= size(Tensor.rootcore);
dim= dim (Tensor.numTechnicalModes+1:size(dim,2));
Y=getRowCoefficients(Tensor,X);


    