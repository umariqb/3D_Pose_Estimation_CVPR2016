function [skel,mot] = extractMotion(Tensor,rows,varargin)

switch nargin
    case 2
        DataRep=Tensor.DataRep;
    case 3
        DataRep=varargin{1};
    otherwise
        error('extractMotion: Wrong number of arguments!\n');
end

expr=['Tensor.skeletons{' num2str(rows(1))];
for i=2:length(rows)
    expr=[expr ',' num2str(rows(i))];
end
expr=[expr '}'];
skelFileName=eval(expr);
tmp=strfind(skelFileName,'.mirrored');
if ~isempty(tmp)
    skel = readASF(skelFileName(1:tmp-1));
    skel = mirrorSkel(skel);
else
%     skel=Tensor.addSkel;
    skel = readASF(skelFileName);
end

nrOfNaturalModes    = Tensor.numNaturalModes;
nrOfTechnicalModes  = Tensor.numTechnicalModes;
nrOfDim             = nrOfNaturalModes+nrOfTechnicalModes;

nrOfDimRoot = size(Tensor.rootfactors,2);
nrOfTechnicalModesRoot = nrOfDimRoot-nrOfNaturalModes;
tic;
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
toc
mot=createMotionFromCoreTensor_jt(Tensor.core,Tensor.rootcore,skel,true,true,DataRep);

if isfield(Tensor,'samplingRate');
    mot.samplingRate=Tensor.samplingRate;
    mot.frameTime=1/mot.samplingRate;
end