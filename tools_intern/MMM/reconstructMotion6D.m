% function reconstructMotion
% reconstructs/approximates an original motion from a given core tensor of
% arbitrary order and related matrices (obtained by HOSVD)
% recMotion = reconstructMotion(core,factors,rows,varargin)
%
% example:  reconstructMotion(Tensor,[2,2,1]) for 3 natural modes
%
% Remark: Use the tucker function from the n-way toolbox to perform HOSVD
% and to obtain core and factors:
% [factors,core] = tucker(Tensor, [n1 n2 n3 ... n_m]),
% with Tensor being of m-th order
% type "help tucker" for more information

function [skel,mot] = reconstructMotion6D(Tensor,rows,varargin)

skel = readASF(Tensor.skeletons{rows(1),rows(2),1});

nrOfDim = Tensor.numNaturalModes+Tensor.numTechnicalModes;
nrOfNaturalModes = Tensor.numNaturalModes;
nrOfTechnicalModes = Tensor.numTechnicalModes;

nrOfDimRoot = size(Tensor.rootfactors,2);
nrOfTechnicalModesRoot = nrOfDimRoot-nrOfNaturalModes;

for i=1:nrOfTechnicalModes
    Tensor.core = modeNproduct(Tensor.core,Tensor.factors{i},i);
end

for i=1:nrOfTechnicalModesRoot
    Tensor.rootcore = modeNproduct(Tensor.rootcore,Tensor.rootfactors{i},i);
end

for i=nrOfTechnicalModes+1:nrOfDim
    Tensor.core = modeNproduct(Tensor.core,Tensor.factors{i}(rows(i-nrOfTechnicalModes),:),i);
end

for i=nrOfTechnicalModes:nrOfDim-1
    Tensor.rootcore = modeNproduct(Tensor.rootcore,Tensor.rootfactors{i}(rows(i-nrOfTechnicalModesRoot),:),i);
end

mot=createMotionFromCoreTensor(Tensor,skel,true,true,'ExpMap');