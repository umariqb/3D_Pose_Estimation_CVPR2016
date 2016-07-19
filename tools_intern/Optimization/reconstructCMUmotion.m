% res=reconstructCMUmotion(TensorForOptimization,CMUresult[,joints[,TensorForReconstruction]]])

function res = reconstructCMUmotion(TensorForReconstruction,skel,origmot,varargin)

switch nargin
    case 3
        joints      = (1:31);
    case 4
        joints      = varargin{1};
    case 5
        joints      = varargin{1};
        TensorForReconstruction=varargin{2};
    otherwise
        ('Wrong number of argins!');
end

% folder='\\breithorn\shareII\MoCap-Daten\CMU_DB\CMU_D180\AMC\locomotion\walking\';
% 
% asfName             = strcat(folder,CMUresult.asf);
% res.skel            = readASF(asfName);
% amcName             = strcat(folder,CMUresult.amc(max(strfind(CMUresult.amc,'/'))+1:end));
% origmot             = readAMC(amcName,res.skel);

% res.skel            = CMUresult.orgSkel;
% origmot             = CMUresult.orgMot;
res.skel            = skel;
res.origmot         = changeFrameRate(skel,origmot,30);

[mot,angle,x0,z0]   = fitMotion(res.skel,res.origmot);

[s,motRef]          = extractMotion(TensorForReconstruction,[1,1,1]);
[D,warpingPath]     = pointCloudDTW_jt(motRef,mot);
mot                 = warpMotion(warpingPath,res.skel,mot);

set                 = defaultSet;
set.regardedJoints  = joints;
[res.X,recmot]      = reconstructMotion(TensorForReconstruction,res.skel,mot,'set',set);

if nargin==5
    [s,recmot]      = constructMotion(TensorForReconstruction,res.X,res.skel);
end

recmot              = warpMotion(fliplr(warpingPath),res.skel,recmot);
recmot              = rotateMotion(res.skel,recmot,-angle,'y');
res.recmot          = translateMotion(res.skel,recmot,-x0,0,-z0);
% recmot              = removeSkating(skel,recmot);