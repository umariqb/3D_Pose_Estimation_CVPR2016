function [Tensor]=buildTensorFromDir2(p,varargin)
% Creates a motion tensor from a given Directory of our MocapDB
% All motions in a given directory are warped and put into the tensor.
% The reference motion is allways the first motion in dir.
% author: Bjoern Krueger (kruegerb@cs.uni-bonn.de)
    
    %% Check if Backslash is included in path and append extension.
    dim=size(p);
    if(p(dim(2))~='\')
        p=[p '\'];
    end
    ext='*.amc';
    %% Get List of files
    files=dir([p ext]);
    dim=size(files);

    %% Collect Information about the given Files
    % We need the number of actors, minimum of repetitions
    % This are information about the dimension of the
    % resulting tensor.

    % Known Actors: bd,bk,mm,dg,tr
    actors{1}='HDM_bd';
    actors{2}='HDM_bk';
    actors{3}='HDM_dg';
    actors{4}='HDM_mm';
    actors{5}='HDM_tr';
  
    %Count repetitions of each actor
    reps(1)=countActor(files,actors{1});
    reps(2)=countActor(files,actors{2});
    reps(3)=countActor(files,actors{3});
    reps(4)=countActor(files,actors{4});
    reps(5)=countActor(files,actors{5});
   
    % If there is a maximum of Reps definied us it, otherwise use all
    % motions. ! Can result in a lot of NaN's.
    switch nargin
        case 1
            maxRep =max(reps);
            dataRep='Quat';
        case 2
            maxRep=varargin{1};
            dataRep='Quat';
        case 3
            maxRep=varargin{1};
            dataRep=varargin{2};
        otherwise
            error('Wrong number of Args');
    end
    
    switch dataRep
    	case 'Quat'
            dimDataRep=4;               
    	case 'Position'
            dimDataRep=3;   
        case 'ExpMap'
            dimDataRep=3;
        otherwise 
        	error('buildTensorFromDir2: Wrong Date specified in var: dataRep');
    end
    % Motions to fit by DTW
    skelfile=[p actors{1} '.asf'];
    motfile =[p files(1).name];
    [fitskel,fitmot]=readMocap(skelfile,motfile);
    fprintf('fitmot: ');
    fprintf([files(1).name '\n'])
    fitmot=reduceFrameRate(fitskel,fitmot);
   
    % Allocate memory for Tensor
    Tensor.data=NaN(dimDataRep,fitmot.nframes,fitmot.njoints,size(actors,2),maxRep);
    
    rep=1;
    actor=1;
    fprintf('    ');
    file=1;
    % Run throgh list of files
    while (file<dim(1))
%     for file=1:dim(1)
        if(actor<=size(actors,2))
            if(rep<=reps(actor)&&rep<=maxRep)
                %Load motion
                fprintf('\b\b\b\bRead ');
                skelfile=[p actors{actor} '.asf'];
                 motfile=[p files(file).name];
                fprintf(files(file).name);  
                [skel,mot]=readMocap(skelfile,motfile);
                % Reduce frame rate
                mot=reduceFrameRate(skel,mot);
                % fit motion
                mot=fitMotion(skel,mot);
                % Timewarp motion
                for c=1:size(files(file).name,2)
                    fprintf('\b');
                end
                fprintf('\b\b\b\b\bWarp');
                [mot]=SimpleDTW(fitmot,skel,mot);
                % Fill warped motion into tensor
                Tensor.motions{actor,rep}=motfile;
                Tensor.skeletons{actor,rep}=skelfile;
                Tensor.rootdata(:,:,actor,rep)=mot.rootTranslation;
                for joint=1:mot.njoints
                    Tensor.joints{joint,actor,rep}=mot.jointNames{joint};
                    switch dataRep
                        case 'Quat'
                            if(~isempty(mot.rotationQuat{joint}))
                                Tensor.data(:,:,joint,actor,rep)=mot.rotationQuat{joint};
                            else
                                Tensor.data(1,:,joint,actor,rep)  =ones (1,mot.nframes);
                                Tensor.data(2:4,:,joint,actor,rep)=zeros(3,mot.nframes);
                            end
                        case 'Position'
                            if(~isempty(mot.jointTrajectories{joint}))
                                Tensor.data(:,:,joint,actor,rep)=mot.jointTrajectories{joint};
                            else
                                Tensor.data(1:3,:,joint,actor,rep)=zeros(3,mot.nframes);
                            end
                        case 'ExpMap'
                            if(~isempty(mot.rotationQuat{joint}))
                                Tensor.data(:,:,joint,actor,rep)=quatlog(mot.rotationQuat{joint});
                            else
                                Tensor.data(1:3,:,joint,actor,rep)=zeros(3,mot.nframes);
                            end
                        otherwise 
                            error('buildTensorFromDir2: Wrong Date specified in var: dataRep');
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
  
function num=countActor(files,actor)
    LoFN=[files(:).name];
    tmp=size(strfind(LoFN,actor));
    num=tmp(2);
end