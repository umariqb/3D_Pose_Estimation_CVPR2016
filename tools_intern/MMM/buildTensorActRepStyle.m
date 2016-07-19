function [Tensor]=buildTensorActRepStyle(p,varargin)
% Creates a motion tensor from a given Directories of our
% MocapDB. Each directory corresponds to one style.
% All motions in a given directories are warped and put into the tensor.
% The reference motion is allways the first motion in the first dir.
% author: Bjoern Krueger (kruegerb@cs.uni-bonn.de)

% R:\HDM05_3style_example\cut_amc
   
    % If there is a maximum of Reps definied us it, otherwise use all
    % motions. ! Can result in a lot of NaN's.
    switch nargin
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
    
    % Define size of Representation
    switch dataRep
    	case 'Quat'
            dimDataRep=4;               
    	case 'Position'
            dimDataRep=3;   
        case 'ExpMap'
            dimDataRep=3;
        otherwise 
        	error('buildTensorActRepStyle: Wrong Date specified in var: dataRep');
    end

    % Check if Backslash is included in path and append extension.
    dim=size(p);
    if(p(dim(2))~='\')
        p=[p '\'];
    end
    ext='*.amc';
    
    % Check if there is a Directory for every Style:
    numStyles=size(Styles,2);
    
    for s=1:numStyles
        if(~exist([p Styles{1,s}],'dir'))
            error(['buildTensorActRepStyle: ' ...
                   'Dir for Style ' ...
                   Styles{1,s} ' does not exist!']);
        end
    end
    
    % Get Lists of files:
    for s=1:numStyles
        listofFiles{s}=dir([p Styles{1,s} '\' ext]);
        numMotions{s} =size(listofFiles{s},1);
    end
    
    dimStyleMode =numStyles;
    dimActorsMode=5;
    dimRepMode   =maxRep;
    
    %% Collect Information about the given
    %% Files/Styles/Classes

    % We need the number of actors, minimum of repetitions
    % This are information about the dimension of the
    % resulting tensor.

    % Known Actors: bd,bk,mm,dg,tr
    actors{1}='HDM_bd';
    actors{2}='HDM_bk';
    actors{3}='HDM_dg';
    actors{4}='HDM_mm';
    actors{5}='HDM_tr';
    
    numActors=size(actors,2);
    
    reps=zeros(numActors,numStyles);
    
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
    fprintf('fitmot: ');
    fprintf([listofFiles{s}(1).name '\n'])
    
    fitmot=reduceFrameRate(fitskel,fitmot);
   
    Tensor.DataRep=dataRep;
    Tensor.numNaturalModes  = 3;
    Tensor.dimNaturalModes  = [dimStyleMode dimActorsMode dimRepMode];
    Tensor.numTechnicalModes= 3;
    Tensor.dimTechnicalModes= [dimDataRep fitmot.nframes fitmot.njoints];
    
    Tensor.styles=Styles;
    
    % Allocate memory for Tensor
    Tensor.data=NaN([Tensor.dimTechnicalModes Tensor.dimNaturalModes]);
    
    for s=1:numStyles
        rep=1;
        actor=1;
        fprintf('    ');
        file=1;
        % Run throgh list of files
        while (file<numMotions{s})
    %     for file=1:dim(1)
            if(actor<=size(actors,2))
                if(rep<=reps(actor,s)&&rep<=maxRep)
                    %Load motion
                    fprintf('\b\b\b\bRead ');
                    skelfile=fullfile(p, Styles{1,s}, [actors{actor} '.asf']);
                    motfile =fullfile(p, Styles{1,s}, listofFiles{s}(file).name);
                    fprintf(listofFiles{s}(file).name);
                    [skel,mot]=readMocap(skelfile,motfile);
                    % Reduce frame rate
                    mot=reduceFrameRate(skel,mot);
                    % fit motion
                    mot=fitMotion(skel,mot);
                    % Timewarp motion
                    for c=1:size(listofFiles{s}(file).name,2)
                        fprintf('\b');
                    end
                    fprintf('\b\b\b\b\bWarp');
                    [mot]=SimpleDTW(fitmot,skel,mot);
                    % Fill warped motion into tensor
                    Tensor.rootdata(:,:,s,actor,rep)=mot.rootTranslation;
                    Tensor.motions{s,actor,rep}=motfile;
                    Tensor.skeletons{s,actor,rep}=skelfile;
                    for joint=1:mot.njoints
                        Tensor.joints{joint,s,actor,rep}=mot.jointNames{joint};
                        switch dataRep
                            case 'Quat'
                                if(~isempty(mot.rotationQuat{joint}))
                                    Tensor.data(:,:,joint,s,actor,rep)=mot.rotationQuat{joint};
                                else
                                    Tensor.data(1,:,joint,s,actor,rep)  =ones (1,mot.nframes);
                                    Tensor.data(2:4,:,joint,s,actor,rep)=zeros(3,mot.nframes);
                                end
                            case 'Position'
                                if(~isempty(mot.jointTrajectories{joint}))
                                    Tensor.data(:,:,joint,s,actor,rep)=mot.jointTrajectories{joint};
                                else
                                    Tensor.data(1:3,:,joint,s,actor,rep)=zeros(3,mot.nframes);
                                end
                            case 'ExpMap'
                                if(~isempty(mot.rotationQuat{joint}))
                                    Tensor.data(:,:,joint,s,actor,rep)=quatlog(mot.rotationQuat{joint});
                                else
                                    Tensor.data(1:3,:,joint,s,actor,rep)=zeros(3,mot.nframes);
                                end
                            otherwise 
                                error('buildTensorActRepStyle: Wrong Type specified in var: dataRep\n');
                        end
                    end
                    rep=rep+1;
                    file=file+1;
                else
                    actor=actor+1;
                    rep=1;
    %                 file=file-1;
                end
            else
                file=file+1;
            end     
        end
        fprintf('\b\b\b\b');
    end
    Tensor=HOSVDv2(Tensor);
end
  
function num=countActor(files,actor)
    LoFN=[files(:).name];
    tmp=size(strfind(LoFN,actor));
    num=tmp(2);
end