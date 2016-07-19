function [Tensor]=buildTensorFromDir(p)
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
    
    if (min(reps)==0)
        [numReps,I]=min(reps);
        reps(I)=max(reps);
        numReps=min(reps);
    else
        numReps=min(reps);
    end
    
    %% Start reading information
    rep=1;
    actor=1;
    
    % Motions to fit by DTW
    skelfile=[p actors{1} '.asf'];
    motfile =[p files(1).name];
    [fitskel,fitmot]=readMocap(skelfile,motfile);
    fprintf('fitmot: ');
    fprintf([files(1).name '\n'])
    fitmot=reduceFrameRate(fitskel,fitmot);
   
    Tensor.data=NaN(4,fitmot.nframes,fitmot.njoints,size(actors,2),numReps);
    
    fprintf('Motion    ');
    % Go through all files
    for file=1:dim(1)
 
        fprintf('\b\b\b');
        fprintf('%2i ',file);
        
        % Check if motion has to be read
        if(actor<=size(actors,2))
            correctActor=strfind(files(file).name,actors{actor});
        else
            correctActor=0;
        end
        if(isempty(correctActor))
            correctActor=0;
        end
        if ((rep<=numReps)&&correctActor==1)
            % read motion
            fprintf('Read ');
            skelfile=[p actors{actor} '.asf'];
             motfile=[p files(file).name];
            fprintf(files(file).name);  
            [skel,mot]=readMocap(skelfile,motfile);
            mot=reduceFrameRate(skel,mot);
            % Timewarp motion
            for c=1:size(files(file).name,2)
                fprintf('\b');
            end
            fprintf('\b\b\b\b\bWarp');
            [mot]=SimpleDTW(fitmot,skel,mot);
            % Fill warped motion into tensor
            Tensor.motions{actor,rep}=motfile;
            for joint=1:mot.njoints
                Tensor.joints{joint,actor,rep}=mot.jointNames{joint};
                if(~isempty(mot.rotationQuat{joint}))
                    Tensor.data(:,:,joint,actor,rep)=mot.rotationQuat{joint};
                else
                    Tensor.data(1,:,joint,actor,rep)  =ones (1,mot.nframes);
                    Tensor.data(2:4,:,joint,actor,rep)=zeros(3,mot.nframes);
                end
            end
            rep=rep+1;
            fprintf('\b\b\b\b');
        else
            actor=actor+1;
            rep=1;
        end
    end
    fprintf('\n');
end

function num=countActor(files,actor)
    LoFN=[files(:).name];
    tmp=size(strfind(LoFN,actor));
    num=tmp(2);
end