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

function [skel,mot] = reconstructMotionT(Tensor,rows,varargin)

DataRep=Tensor.DataRep;

skel = readASF(Tensor.skeletons{rows(1),rows(2),1});

nrOfDim = size(Tensor.factors,2);
nrOfNaturalModes = size(rows,2);
nrOfTechnicalModes = nrOfDim-nrOfNaturalModes;

nrOfDimRoot = size(Tensor.rootfactors,2);
nrOfTechnicalModesRoot = nrOfDimRoot-nrOfNaturalModes;

for i=1:nrOfTechnicalModes
    Tensor.core = modeNproduct(Tensor.core,Tensor.factors{i},i);
end

for i=1:nrOfTechnicalModesRoot
    Tensor.rootcore = modeNproduct(Tensor.rootcore,Tensor.rootfactors{i},i);
end

for i=nrOfDim:-1:nrOfTechnicalModes+1
    Tensor.data = modeNproduct(Tensor.core,Tensor.factors{i}(rows(i-nrOfTechnicalModes),:),i);
end

for i=nrOfDimRoot:-1:nrOfTechnicalModesRoot+1
    Tensor.rootcore = modeNproduct(Tensor.rootcore,Tensor.rootfactors{i}(rows(i-nrOfTechnicalModesRoot),:),i);
end

mot=createMotionFromCoreTensor(Tensor,skel,true,true,DataRep);

% dims=size(Tensor.core);
% mot = emptyMotion;
% 
% mot.njoints=dims(3);
% mot.nframes=dims(2);
% 
% mot.rootTranslation=Tensor.rootcore(:,:);
% 
% for joint=1:mot.njoints
%     mot.rotationQuat{1,joint}=Tensor.core(:,:,joint);
% end
% 
% mot.samplingRate=30;
% mot.frameTime=1/30;
% mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
% mot.boundingBox = computeBoundingBox(mot);