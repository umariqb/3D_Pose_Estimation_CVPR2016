function [Tensor,mots,skels]=buildTensorStyleActRep(p,varargin)

% T=buildTensorStyleActRep(dir,[maxRep[,dataRep[,Styles]]]);
% example:
% T=buildTensorStyleActRep('R:\HDM05\HDM05_cut_amc',3);
   
switch nargin
    case 1
        maxRep =3;
        dataRep='Quat';
        Styles ={'walk4StepsRstart', ...
                 'walkLeftCircle4StepsRstart', ...
                 'walkRightCircle4StepsRstart'};
    case 2
        maxRep =varargin{1};
        dataRep='Quat';
        Styles ={'walk4StepsRstart', ...
                 'walkLeftCircle4StepsRstart', ...
                 'walkRightCircle4StepsRstart'};

    case 3
        maxRep =varargin{1};
        dataRep=varargin{2};
        Styles ={'walk4StepsRstart', ...
                 'walkLeftCircle4StepsRstart', ...
                 'walkRightCircle4StepsRstart'};
    case 4
        maxRep =varargin{1};
        dataRep=varargin{2};
        Styles =varargin{3};
    otherwise
        error('Wrong number of Args');
end
Tensor.DataRep=dataRep;
    
% define size of representation:
switch dataRep
    case 'Quat'
        dimDataRep=4;               
    case 'Position'
        dimDataRep=3;   
    case 'ExpMap'
        dimDataRep=3;
    case 'Acc'
        dimDataRep=3;
    otherwise 
        error('buildTensorStyleActRep_jt: Wrong Date specified in var: dataRep');
end

% Check if Backslash is included in path and append extension:

if(p(end)~=filesep)
    p=[p filesep];
end
ext='*.amc';

% Check if there is a directory for every style:
numStyles=size(Styles,2);
for s=1:numStyles
    if(~exist([p Styles{1,s}],'dir'))
        error(['buildTensorStyleActRep_jt: Dir for Style ' Styles{1,s} ' does not exist!']);
    end
end
Tensor.styles=Styles;
    
% Get Lists of files:
for s=1:numStyles
    listofFiles{s}=dir([p Styles{1,s} filesep ext]);
end

%% Collect Information about the given files/styles/classes:

% Known Actors: bd,bk,mm,dg,tr
actors{1}='HDM_bd';
actors{2}='HDM_bk';
actors{3}='HDM_dg';
actors{4}='HDM_mm';
actors{5}='HDM_tr';
numActors=size(actors,2);

for s=1:numStyles
    %Count repetitions of each actor
    for a=1:numActors
        reps(a,s)=countActor(listofFiles{s},actors{a});
    end
end   

% Motions to fit by DTW
skelfile=fullfile(p, Styles{1,1}, [actors{1} '.asf']);
motfile =fullfile(p, Styles{1,1}, listofFiles{1}(1).name);

[fitskel,fitmot]=readMocap(skelfile,motfile);
fprintf('Reference Motion: ');
fprintf([listofFiles{1}(1).name '\n'])

fitmot=changeFrameRate(fitskel,fitmot,30);
Tensor.numTechnicalModes    = 3;
Tensor.dimTechnicalModes    = [dimDataRep fitmot.nframes fitmot.njoints];
Tensor.dimNaturalModes      = [numStyles numActors maxRep];
Tensor.dimNaturalModes      = Tensor.dimNaturalModes(Tensor.dimNaturalModes~=1);
Tensor.numNaturalModes      = length(Tensor.dimNaturalModes);

mots    = cell(numStyles,numActors,maxRep);
skels   = cell(numStyles,numActors,maxRep);
Tensor.data=zeros([Tensor.dimTechnicalModes Tensor.dimNaturalModes]);

for s=1:numStyles
    file=1;
    for a=1:numActors
        for r=1:max(maxRep,reps(a,s))
            if (r<=maxRep)
                fprintf('Fitting motion %i%i%i - ',s,a,r);
                skelfile    = fullfile(p, Styles{1,s}, [actors{a} '.asf']);
                motfile     = fullfile(p, Styles{1,s}, listofFiles{s}(file).name);
                Tensor.motions{s,a,r}   = motfile;
                Tensor.skeletons{s,a,r} = skelfile;
                [skel,mot]  = readMocap(skelfile,motfile);      
                mot         = changeFrameRate(skel,mot,30);
                mot         = fitMotion(skel,mot);
                [D,w]       = pointCloudDTW(fitmot,mot,'pos',1:31,1);
                mot         = warpMotion(w,skel,mot);
                
                Tensor.rootdata(:,:,s,a,r)  = mot.rootTranslation;
                
                for joint=1:mot.njoints
%                     Tensor.joints{joint,s,a,r}=mot.jointNames{joint};
                    switch dataRep
                        case 'Quat'
                            if(~isempty(mot.rotationQuat{joint}))
                                % align all quaternions
                                mot.rotationQuat{joint}(:,dot(mot.rotationQuat{joint},fitmot.rotationQuat{joint})<0)...
                                    =-mot.rotationQuat{joint}(:,dot(mot.rotationQuat{joint},fitmot.rotationQuat{joint})<0);
                                Tensor.data(:,:,joint,s,a,r)=mot.rotationQuat{joint};
                            else
                                Tensor.data(1,:,joint,s,a,r)  =1;
                                Tensor.data(2:4,:,joint,s,a,r)=0;
                            end
                        case 'Position'
                            if(~isempty(mot.jointTrajectories{joint}))
                                Tensor.data(:,:,joint,s,a,r)=mot.jointTrajectories{joint};
                            else
                                Tensor.data(:,:,joint,s,a,r)=0;
                            end
                        case 'ExpMap'
                            if(~isempty(mot.rotationQuat{joint}))
                                Tensor.data(:,:,joint,s,a,r)=quatlog(mot.rotationQuat{joint});
                            else
                                Tensor.data(:,:,joint,s,a,r)=0;
                            end
                        case 'Acc'
                            mot = addAccToMot(mot);
                            if(~isempty(mot.jointAccelerations{joint}))
                                Tensor.data(:,:,joint,s,a,r)=mot.jointAccelerations{joint};
                            else
                                Tensor.data(:,:,joint,s,a,r)=0;
                            end
                        otherwise 
                            error('buildTensorStyleActRep_jt: Wrong Type specified in var: dataRep\n');
                    end
                end
                [mots{s,a,r},skels{s,a,r}]=deal(mot,skel);
            end
            if (r<reps(a,s)||r==max(maxRep,reps(a,s)))
                file=file+1;
            end
        end
    end
end
Tensor.data=squeeze(Tensor.data);
Tensor.rootdata=squeeze(Tensor.rootdata);
Tensor=HOSVDv2(Tensor);
end

function num=countActor(files,actor)
    LoFN=[files(:).name];
    tmp=size(strfind(LoFN,actor));
    num=tmp(2);
end