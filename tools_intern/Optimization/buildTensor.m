% function buildTensor
% builds a motion tensor with specified form and order of modes
%
% Use upper cases for Technical Modes, lower cases for Natural Modes!
% Valid characters for Technical Modes:
% I:   (Q)uaternions / (E)uler angles / Exponential (M)aps / (P)ositions /
%      (V)elocities / (A)ccelerations; (necessary)
% II:  (F)rames (necessary)
% III: (J)oints (necessary)
% Valid characters for Natural Modes:
% i:   (a)ctors (necessary)
% ii:  (s)tyles (necessary)
% iii: (r)epetitions (necessary)
% iv:  (m)irrored motions (optional)
% 
% [Tensor,skels,mots] = buildTensor(form)
% example: T = buildTensor('QFJsar');
% author: Jochen Tauges (tautges@cs.uni-bonn.de)

function [T,skels,mots]=buildTensor(form)

home='R:\HDM05\';
   
if         (isempty(strfind(form,'J')))...
        || (isempty(strfind(form,'F')))...
        || (isempty(strfind(form,'a')))...
        || (isempty(strfind(form,'s')))...
        || (isempty(strfind(form,'r')))  
    error('Invalid input!');
end

T.DataRep               = [];
T.numTechnicalModes     = 0;
T.numNaturalModes       = 0;
dimDataRep              = 3;
T.dimTechnicalModes     = [];
T.dimNaturalModes       = [];

nrOfActors              = 0;
nrOfStyles              = 0;
nrOfRepetitions         = 0;
mirroring               = false;

TechOrder               = zeros(1,sum(int8(form)<91));
NatOrder                = zeros(1,sum(int8(form)>97));

for i=1:length(form)
    if length(strfind(form,form(i)))>1
        error('Invalid input!'); 
    end
    switch form(i)
        case 'Q'
            if (T.numNaturalModes>0 || ~isempty(T.DataRep))
                error('Invalid input!'); 
            else
                T.form{i}               = 'QUAT';
                T.DataRep               = 'quat';
                dimDataRep              = 4;
                T.numTechnicalModes     = T.numTechnicalModes+1;
                TechOrder(i)            = 1;
            end
        case 'E'
            if (T.numNaturalModes>0 || ~isempty(T.DataRep))
                error('Invalid input!'); 
            else
                T.form{i}               = 'EULER';
                T.DataRep               = 'euler';
                T.numTechnicalModes     = T.numTechnicalModes+1;
                TechOrder(i)            = 1;
            end
        case 'M'
            if (T.numNaturalModes>0 || ~isempty(T.DataRep))
                error('Invalid input!'); 
            else
                T.form{i}               = 'EXPMAP';
                T.DataRep               = 'expmap';
                T.numTechnicalModes     = T.numTechnicalModes+1;
                TechOrder(i)            = 1;
            end
        case 'P'
            if (T.numNaturalModes>0 || ~isempty(T.DataRep))
                error('Invalid input!'); 
            else
                T.form{i}               = 'POS';
                T.DataRep               = 'pos';
                T.numTechnicalModes     = T.numTechnicalModes+1;
                TechOrder(i)            = 1;
            end
        case 'V'
            if (T.numNaturalModes>0 || ~isempty(T.DataRep))
                error('Invalid input!'); 
            else
                T.form{i}               = 'VEL';
                T.DataRep               = 'vel';
                T.numTechnicalModes     = T.numTechnicalModes+1;
                TechOrder(i)            = 1;
            end
        case 'A'
            if (T.numNaturalModes>0 || ~isempty(T.DataRep))
                error('Invalid input!'); 
            else
                T.form{i}               = 'ACC';
                T.DataRep               = 'acc';
                T.numTechnicalModes     = T.numTechnicalModes+1;
                TechOrder(i)            = 1;
            end
        case 'F'
            if (T.numNaturalModes>0)
                error('Invalid input!'); 
            else
                T.form{i}               = 'FRAMES';
                T.numTechnicalModes     = T.numTechnicalModes+1;
                TechOrder(i)            = 2;
            end
        case 'J'
            if (T.numNaturalModes>0)
                error('Invalid input!'); 
            else
                T.form{i}               = 'JOINTS';
                T.numTechnicalModes     = T.numTechnicalModes+1;
                TechOrder(i)            = 3;
            end
            jointModeID                 = i;
        case 's'
            T.form{i}                   = 'styles';
            NatOrder(i-T.numTechnicalModes) = 4;
            T.numNaturalModes           = T.numNaturalModes+1;
        case 'a'
            T.form{i}                   = 'actors';
            NatOrder(i-T.numTechnicalModes) = 5;
            T.numNaturalModes           = T.numNaturalModes+1;
        case 'r'
            T.form{i}                   = 'repetitions';
            NatOrder(i-T.numTechnicalModes) = 6;
            T.numNaturalModes           = T.numNaturalModes+1;
            while nrOfRepetitions<=0
                nrOfRepetitions = input('How many repetitions of each motion do you want to store? ');
            end
            fprintf('Size of repetition mode: %i\n',nrOfRepetitions);
        case 'm'
            T.form{i}                   = 'mirrors';
            mirroring                   = true;
            NatOrder(i-T.numTechnicalModes) = 7;
            T.numNaturalModes           = T.numNaturalModes+1;
        otherwise
            help buildTensor;
            error('Invalid character: ''%c''!',form(i));
    end
end

extension='*.amc';
if exist(home,'dir');
    AMCfolder=home;
else
    AMCfolder='';
end

% Hack for tensor construction EG08 ;-)
AMCfolder='/data/HDM/HDM05_EG08/HDM05_EG08_cut_amc_training/';

%reading the .asf-files:
FilterIndex=1;
while (FilterIndex~=0 || nrOfActors==0)
    fprintf('\nSpecify asf-file(s)! ');
    [ASFfile,ASFPathName,FilterIndex] = uigetfile(fullfile(AMCfolder,'*.asf'),'MultiSelect','on');
    if iscell(ASFfile)
        for j=1:length(ASFfile)
            fprintf('%s ',ASFfile{j});
            nrOfActors                      = nrOfActors+1;
            actors{nrOfActors}              = ASFfile{j};
            actorsFullFile{nrOfActors}      = fullfile(ASFPathName, ASFfile{j});
        end
    else 
        if FilterIndex~=0
            fprintf('%s ',ASFfile);
            nrOfActors                      = nrOfActors+1;
            actors{nrOfActors}              = ASFfile;
            actorsFullFile{nrOfActors}      = fullfile(ASFPathName, ASFfile);
        elseif nrOfActors>0
            fprintf('\nSize of actors mode: %i\n',nrOfActors);
        end
    end
end

%reading the .amc files
%file names have to match the .asf file names!
while (ischar(AMCfolder) || nrOfStyles==0)
    dialog_title=['Specify folder of amc-files for style ' num2str(nrOfStyles+1) '!'];
    fprintf('\n%s ',dialog_title);
    if AMCfolder==0
        AMCfolder='';
    end
    AMCfolder = uigetdir(AMCfolder,dialog_title);
    if (AMCfolder~=0)
        nrOfStyles                  = nrOfStyles+1;
        for a=1:nrOfActors
            actorString{a}          = actors{a}(1:end-4);
            
            listOfAMCFiles_tmp  = dir(fullfile(AMCfolder,['*',actorString{a},'*',extension]));
            listOfAMCFiles{nrOfStyles,a}  = listOfAMCFiles_tmp;
            reps(a,nrOfStyles)  = size(listOfAMCFiles{nrOfStyles,a},1);
        end
        AMCpaths{nrOfStyles}    = AMCfolder;
        T.styles{nrOfStyles}    = fliplr(strtok(fliplr(AMCfolder),filesep));
    else
        fprintf('\nSize of style mode: %i\n',nrOfStyles);
    end
end 

refMotFileName          = fullfile(AMCpaths{1},listOfAMCFiles{1,1}(1).name);

fprintf('\nSelect reference motion for DTW (Cancel for default)!\n ');
[refFileName,refPathName,FilterIndex] = uigetfile(fullfile(AMCpaths{1},'*.amc'));
if FilterIndex~=0
    refMotFileName=fullfile(refPathName,refFileName);
end
refSkelFileName=[];
for a=1:nrOfActors
    if size(strfind(refMotFileName,actorString{a}))>0
        refSkelFileName=actorsFullFile{a};
        break;
    end
end

if isempty(refSkelFileName)
    [refFileName,refSkelPathName,FilterIndex] = uigetfile(fullfile(ASFPathName,'*.asf'), 'Choose ASF file for reference motion!');
    if FilterIndex~=0
        refSkelFileName=fullfile(refSkelPathName,refFileName);
    end
end

[fitskel,fitmot]    = readMocap(refSkelFileName,refMotFileName);

%%% Vorsicht: readMocap liest samplingRate nicht korrekt ein! default=120
% fitmot.samplingRate = 30;
% fitmot.frametime = 1/30;

T.samplingRate = input('\nSpecify frame rate for all motions: ');
fitmot      = changeFrameRate(fitskel,fitmot,T.samplingRate);
fitmot      = fitMotion(fitskel,fitmot);

T.DTW.refMot = fliplr(strtok(fliplr(fitmot.filename),filesep));

for i=1:length(form)
    switch form(i)
        case {'Q','E','M','P','V','A'}    
            T.dimTechnicalModes = [T.dimTechnicalModes dimDataRep];
        case 'F'
            T.dimTechnicalModes = [T.dimTechnicalModes fitmot.nframes];
        case 'J'
            T.dimTechnicalModes = [T.dimTechnicalModes fitmot.njoints];
        case 'a'
            T.dimNaturalModes   = [T.dimNaturalModes nrOfActors];
        case 's'
            T.dimNaturalModes   = [T.dimNaturalModes nrOfStyles];
        case 'r'
            T.dimNaturalModes   = [T.dimNaturalModes nrOfRepetitions];
        case 'm'
            T.dimNaturalModes   = [T.dimNaturalModes 2];
    end
end 

T.form              = T.form([(T.dimTechnicalModes>1) (T.dimNaturalModes>1)]);
T.dimTechnicalModes = T.dimTechnicalModes(T.dimTechnicalModes>1);
T.dimNaturalModes   = T.dimNaturalModes(T.dimNaturalModes>1);
T.numNaturalModes   = length(T.dimNaturalModes);
T.numTechnicalModes = length(T.dimTechnicalModes);

if mirroring
    mots        = cell(nrOfStyles,nrOfActors,nrOfRepetitions,2);
    skels       = cell(nrOfStyles,nrOfActors,nrOfRepetitions,2);
    T.motions   = cell(nrOfStyles,nrOfActors,nrOfRepetitions,2);
    T.skeletons = cell(nrOfStyles,nrOfActors,nrOfRepetitions,2);
else
    mots        = cell(nrOfStyles,nrOfActors,nrOfRepetitions); 
    skels       = cell(nrOfStyles,nrOfActors,nrOfRepetitions);
    T.motions   = cell(nrOfStyles,nrOfActors,nrOfRepetitions);
    T.skeletons = cell(nrOfStyles,nrOfActors,nrOfRepetitions);
end

motfile_tmp = '';
T.numMissingMots = 0;
T.DTW.warpingCosts = 0;

for s=1:nrOfStyles
    for a=1:nrOfActors
        file=1;
        for r=1:max(nrOfRepetitions,reps(a,s))
            if (r<=nrOfRepetitions)
                skelfile             = actorsFullFile{a};
                motfile              = fullfile(AMCpaths{s},listOfAMCFiles{s,a}(file).name);
                T.motions{s,a,r,1}   = motfile;
                T.skeletons{s,a,r,1} = skelfile;
                
                if strcmp(motfile,refMotFileName)
                    if strcmp(motfile,motfile_tmp)
                        fprintf('\nMotion %i%i%i is not existent and set equal to previous motion.\n',s,a,r);
                    else
                        fprintf('\nMotion %i%i%i is the reference motion of the DTW and does not have to be aligned again.\n',s,a,r);
                        skel                    = fitskel;
                        mot                     = fitmot;
                        if ~isfield(T.DTW,'refMotID')
                            T.DTW.refMotID=[s,a,r,1];
                        end
                    end
                    T.DTW.warpingPaths{s,a,r,1} = repmat((mot.nframes:-1:1)',1,2);
                elseif strcmp(motfile,motfile_tmp)
                    fprintf('\nMotion %i%i%i is not existent and set equal to previous motion.\n',s,a,r);
                    T.DTW.warpingPaths{s,a,r,1} = w;
                    T.DTW.warpingCosts          = [T.DTW.warpingCosts D(fitmot.nframes,mot.nframes)/fitmot.nframes];
                    T.numMissingMots            = T.numMissingMots+1;
                else
                    fprintf('\nFitting motion %i%i%i - ',s,a,r);
                    [skel,mot]                  = readMocap(skelfile,motfile);      
                    mot                         = changeFrameRate(skel,mot,T.samplingRate);
                    mot                         = fitMotion(skel,mot);
                    [D,w]                       = pointCloudDTW_pos(fitmot,mot,2);
                    T.DTW.warpingPaths{s,a,r,1} = w;
                    T.DTW.warpingCosts          = [T.DTW.warpingCosts D(fitmot.nframes,mot.nframes)/fitmot.nframes];
                    mot                         = warpMotion(w,skel,mot);
                    motfile_tmp                 = motfile;
                end
                
                T.rootdata(:,:,s,a,r,1)         = mot.rootTranslation;
                
                for joint=1:mot.njoints
                    switch lower(T.DataRep)
                        case 'quat'
                            if(~isempty(mot.rotationQuat{joint}) && ~isempty(fitmot.rotationQuat{joint}))
                                % align all quaternions
                                mot.rotationQuat{joint}(:,dot(mot.rotationQuat{joint},fitmot.rotationQuat{joint})<0)...
                                    = -mot.rotationQuat{joint}(:,dot(mot.rotationQuat{joint},fitmot.rotationQuat{joint})<0);
                                T.data(:,:,joint,s,a,r,1) = mot.rotationQuat{joint};
                            else
                                T.data(1,:,joint,s,a,r)   = 1;
                                T.data(2:4,:,joint,s,a,r) = 0;
                            end
                        case 'euler'
                            [xxx,mot]=convert2euler(skel,mot);
                            if(~isempty(mot.rotationEuler{joint}))
                                T.data(:,:,joint,s,a,r,1) = mot.rotationEuler{joint};
                            else
                                T.data(:,:,joint,s,a,r,1) = 0;
                            end
                        case 'expmap'
                            if(~isempty(mot.rotationQuat{joint}))
                                T.data(:,:,joint,s,a,r,1) = quatlog(mot.rotationQuat{joint});
                            else
                                T.data(:,:,joint,s,a,r,1) = 0;
                            end
                        case 'pos'
                            if(~isempty(mot.jointTrajectories{joint}))
                                T.data(:,:,joint,s,a,r,1) = mot.jointTrajectories{joint};
                            else
                                T.data(:,:,joint,s,a,r,1) = 0;
                            end
                        case 'vel'
                            mot = addVelToMot(mot);
                            if(~isempty(mot.jointVelocities{joint}))
                                T.data(:,:,joint,s,a,r,1) = mot.jointVelocities{joint};
                            else
                                T.data(:,:,joint,s,a,r,1) = 0;
                            end
                        case 'acc'
                            mot = addAccToMot(mot);
                            if(~isempty(mot.jointAccelerations{joint}))
                                T.data(:,:,joint,s,a,r,1) = mot.jointAccelerations{joint};
                            else
                                T.data(:,:,joint,s,a,r,1) = 0;
                            end
                    end % (switch lower(T.DataRep))
                end % (for joint=1:motM.njoints)
                
                [skels{s,a,r,1},mots{s,a,r,1}]  = deal(skel,mot);
                
                if mirroring
                    [skelM,motM]                    = mirrorMot(skel,mot);
                    motM                            = fitMotion(skelM,motM);
                    [skels{s,a,r,2},mots{s,a,r,2}]  = deal(skelM,motM);
                    T.motions{s,a,r,2}              = [motfile '.mirrored'];
                    T.skeletons{s,a,r,2}            = [skelfile '.mirrored'];
                    T.DTW.warpingPaths{s,a,r,2}     = T.DTW.warpingPaths{s,a,r,1};
                    T.rootdata(:,:,s,a,r,2)         = motM.rootTranslation;
                    
                    for joint=1:motM.njoints
                        switch lower(T.DataRep)
                            case 'quat'
                                if(~isempty(motM.rotationQuat{joint}))
                                    % aligning not necessary anymore
                                    T.data(:,:,joint,s,a,r,2) = motM.rotationQuat{joint};
                                else
                                    T.data(1,:,joint,s,a,r,2)   = 1;
                                    T.data(2:4,:,joint,s,a,r,2) = 0;
                                end
                            case 'euler'
                                [xxx,motM]=convert2euler(skelM,motM);
                                if(~isempty(motM.rotationEuler{joint}))
                                    T.data(:,:,joint,s,a,r,2) = motM.rotationEuler{joint};
                                else
                                    T.data(:,:,joint,s,a,r,2) = 0;
                                end
                            case 'expmap'
                                if(~isempty(motM.rotationQuat{joint}))
                                    T.data(:,:,joint,s,a,r,2) = quatlog(motM.rotationQuat{joint});
                                else
                                    T.data(:,:,joint,s,a,r,2) = 0;
                                end
                            case 'pos'
                                if(~isempty(motM.jointTrajectories{joint}))
                                    T.data(:,:,joint,s,a,r,2) = motM.jointTrajectories{joint};
                                else
                                    T.data(:,:,joint,s,a,r,2) = 0;
                                end
                            case 'vel'
                                motM = addVelToMot(motM);
                                if(~isempty(motM.jointVelocities{joint}))
                                    T.data(:,:,joint,s,a,r,2) = motM.jointVelocities{joint};
                                else
                                    T.data(:,:,joint,s,a,r,2) = 0;
                                end
                            case 'acc'
                                motM = addAccToMot(motM);
                                if(~isempty(motM.jointAccelerations{joint}))
                                    T.data(:,:,joint,s,a,r,2) = motM.jointAccelerations{joint};
                                else
                                    T.data(:,:,joint,s,a,r,2) = 0;
                                end
                        end % (switch lower(T.DataRep))
                    end % (for joint=1:motM.njoints)
                end % (if mirroring)
            end % (if (r<=nrOfRepetitions))
            
            if (r<reps(a,s)||r==max(nrOfRepetitions,reps(a,s)))
                file=file+1;
            end
        end
    end
end

dataOrder           = [TechOrder NatOrder];
rootdataOrder       = dataOrder(dataOrder~=jointModeID);
rootdataOrder(rootdataOrder>jointModeID)=...
    rootdataOrder(rootdataOrder>jointModeID)-1;

order               = NatOrder-T.numTechnicalModes;
T.data              = squeeze(permute(T.data,dataOrder));
T.rootdata          = squeeze(permute(T.rootdata,rootdataOrder));
T.motions           = squeeze(permute(T.motions,order));
T.skeletons         = squeeze(permute(T.skeletons,order));
T.DTW.warpingPaths  = squeeze(permute(T.DTW.warpingPaths,order));
skels               = squeeze(permute(skels,order));
mots                = squeeze(permute(mots,order));
if isfield(T.DTW,'refMotID')
    T.DTW.refMotID      = T.DTW.refMotID(order);
    T.DTW.refMotID      = T.DTW.refMotID(T.dimNaturalModes>1);
end
T                   = HOSVDv2(T);

end

function num=countActor(files,actor)
    LoFN=[files(:).name];
    tmp=size(strfind(LoFN,actor));
    num=tmp(2);
end