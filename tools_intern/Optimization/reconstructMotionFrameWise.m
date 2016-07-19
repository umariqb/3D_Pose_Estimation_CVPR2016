function result = reconstructMotionFrameWise(T,skel,mot,varargin)

startFrame  = 1;
endFrame    = mot.nframes;
set         = defaultSet();

switch nargin
    case 4 
        startFrame=varargin{1}(1);
        if size(varargin{1},2)>1
            endFrame=varargin{1}(2);
        end
    case 5
        startFrame=varargin{1}(1);
        if size(varargin{1},2)>1
            endFrame=varargin{1}(2);
        end
        set.startValue=varargin{2};
end

for i=1:length(T.form)
    if strcmpi(T.form{i},'frames')
        frameModeID=i;
        break;
    end
end

set.optimVar        = 'y';
set.modesToOptimize = union(T.numTechnicalModes+(1:T.numNaturalModes),frameModeID);
set.lowerBounds     = -1;
set.upperBounds     = 2;
set.regardedJoints  = [4,9,22,29];

if strcmpi(T.DataRep,'acc')||strcmpi(T.DataRep,'acc')
    if strcmpi(T.DataRep,'acc')
        mot=addAccToMot(mot);
    elseif strcmpi(T.DataRep,'vel')
        mot=addVelToMot(mot);
    end
    TensorForReconstruction.DataRep='';
    while sum(ismember({'quat','euler','expmap'},lower(TensorForReconstruction.DataRep)))==0
        expression=input('Choose Tensor for reconstruction: ','s');
        TensorForReconstruction=evalin('base', expression);
    end
    fprintf('\nReconstructing frame %i (1/%i)...\n',startFrame,endFrame-startFrame+1);
    res = reconstructMotion(T,skel,cutMotion(mot,startFrame,startFrame),'set',set);
    [xx,newmot]=constructMotion(TensorForReconstruction,res.X,skel);
    
    for i=startFrame+1:endFrame

        set.startValue=res.X;
        result.X{i-startFrame}=res.X;
        
        fprintf('\nReconstructing frame %i (%i/%i)...\n',i,i-startFrame+1,endFrame-startFrame+1);
        res = reconstructMotion(T,skel,cutMotion(mot,i,i),'set',set);
        [xx,frame]=constructMotion(TensorForReconstruction,res.X,skel);
        newmot = addFrame2Motion(newmot,frame);   
    end
else
    set.trajectories='pos';
    fprintf('\nReconstructing frame %i (1/%i)...\n',startFrame,endFrame-startFrame+1);
    res = reconstructMotion(T,skel,cutMotion(mot,startFrame,startFrame),'set',set);
    newmot=res.motRec;
    
    for i=startFrame+1:endFrame

        set.startValue=res.X;
        result.X{i-startFrame}=res.X;
        
        fprintf('\nReconstructing frame %i (%i/%i)...\n',i,i-startFrame+1,endFrame-startFrame+1);
        res = reconstructMotion(T,skel,cutMotion(mot,i,i),'set',set);
        newmot = addFrame2Motion(newmot,res.motRec);   
    end
end

result.X{endFrame-startFrame+1}=res.X;

mot = cutMotion(mot,startFrame,endFrame);

result.motOrig  = mot;
result.motRec   = newmot;

newmot.rootTranslation   = mot.rootTranslation;
newmot.rotationQuat{1}   = mot.rotationQuat{1};
newmot.jointTrajectories = forwardKinematicsQuat(skel,newmot);
newmot.boundingBox       = computeBoundingBox(newmot);

result.motRecRootAdopted = newmot;


