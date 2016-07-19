function [Matrix] = buildPCAMatrixFromDir(p,varargin)

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

Matrix.DataRep=dataRep;

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
        error('buildPCAMatrixFromDir: Wrong Date specified in var: dataRep');
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

% Get Lists of files:
for s=1:numStyles
    listofFiles{s}=dir([p Styles{1,s} filesep ext]);
end

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

Matrix.data     =[];
Matrix.rootdata =[];


for s=1:numStyles
    file=1;
    for a=1:numActors
        for r=1:max(maxRep,reps(a,s))
            if (r<=maxRep)
                fprintf('Loading motion %i%i%i - ',s,a,r);
                skelfile    = fullfile(p, Styles{1,s}, [actors{a} '.asf']);
                motfile     = fullfile(p, Styles{1,s}, listofFiles{s}(file).name);
                [skel,mot]  = readMocap(skelfile,motfile);      
                mot         = changeFrameRate(skel,mot,30);
                mot         = fitMotion(skel,mot);
                
                Matrix.rootdata  = [Matrix.rootdata mot.rootTranslation];
                
                mot=addAccToMot(mot);
                
                tmpMatrix=zeros(mot.njoints*dimDataRep,mot.nframes);
                for joint=1:mot.njoints
%                     Tensor.joints{joint,s,a,r}=mot.jointNames{joint};
                    switch dataRep
                        case 'Quat'
                            if(~isempty(mot.rotationQuat{joint}))
                                tmpMatrix(joint*4-3:joint*4,:)=mot.rotationQuat{joint};
                            else
                                tmpMatrix(joint*4-3,:)        = ones(1,mot.nframes);
                                tmpMatrix(joint*4-2:joint*4,:)=zeros(3,mot.nframes);
                            end
                        case 'Position'
                            error('Not implemented');
                        case 'ExpMap'
                            if(~isempty(mot.rotationQuat{joint}))
                                tmpMatrix(joint*3-2:joint*3,:)=quatlog(mot.rotationQuat{joint});
                            else
                                tmpMatrix(joint*3-2:joint*3,:)=zeros(3,mot.nframes);
                            end
                        case 'Acc'
                            tmpMatrix(joint*3-2:joint*3,:)=mot.jointAccelerations{joint};     
                        otherwise 
                            error('buildTensorStyleActRep_jt: Wrong Type specified in var: dataRep\n');
                    end
                end
                
                Matrix.data=[Matrix.data tmpMatrix];
            end
            if (r<reps(a,s)||r==max(maxRep,reps(a,s)))
                file=file+1;
            end
        end
    end
end
[Matrix.rootcoefs,Matrix.rootscores,Matrix.rootvariances,Matrix.roott2] = princomp(Matrix.rootdata');
[Matrix.coefs,Matrix.scores,Matrix.variances,Matrix.t2] = princomp(Matrix.data');

Matrix.mean    =mean(Matrix.data,2);
Matrix.rootmean=mean(Matrix.rootdata,2);

Matrix.cov     =cov(Matrix.data');
Matrix.rootCov =cov(Matrix.rootdata);

Matrix.inv     =pinv(Matrix.cov');
end


function num=countActor(files,actor)
    LoFN=[files(:).name];
    tmp=size(strfind(LoFN,actor));
    num=tmp(2);
end





