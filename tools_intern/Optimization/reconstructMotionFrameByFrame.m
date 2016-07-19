function res=reconstructMotionFrameByFrame(Tensor,skel,mot,varargin)

% Reconstructs a given motion frame by frame or window by window if
% window size is larger than zero.
% Window size should be an odd number.
% res=reconstructMotionFrameByFrame(Tensor,skel,mot,windowSize)
% Default windowSize is 3

switch nargin
    case 3
        windowLength    = 2;
    case 4
        windowLength    = varargin{1}-1;
    otherwise
        error('reconstructMotionFrameByFrame: Wrong number of arguments!\n');
end

windowHalf      = floor(windowLength/2);

res.skel        = skel;
res.origmot     = mot;

[fskel,fmot]        = extractMotion(Tensor, Tensor.DTW.refMotID);

[D,w,d,theta,x0,z0] = pointCloudDTW_pos(fmot,res.origmot,0);
res.origmot         = warpMotion(w,skel,res.origmot);

res.recmot  = emptyMotion;
res.recmot2 = emptyMotion;
res.X{1}    = [];

count=1;

for i=windowHalf+1:windowLength+1:res.origmot.nframes-windowLength

    r                   = reconstructFrame(Tensor,skel, ...
                                            res.origmot,i,windowHalf, ...
                                            res.recmot2,res.X{count});
       
    [D,w,d,theta,x0,z0] = pointCloudDTW_pos( ...
                             cutMotion(res.origmot,i-windowHalf,i+windowHalf), ...
                             r.motRec,windowHalf);
    
    tmp                 = rotateMotion(skel,r.motRec,theta(1),'y');
    tmp                 = translateMotion(skel,tmp,x0(1),0,z0(1));
   
    if count==1
        res.recmot      = r.motRec;
        res.recmot2     = tmp;
    else
        res.recmot2     = addFrame2Motion(res.recmot2, tmp);
        res.recmot      = addFrame2Motion(res.recmot , r.motRec);
    end
    
    count=count+1;
    
    res.X{count,1}      = r.X;
    res.m(count,:)      = cell2mat(r.X);
        
end

% recmot.rotationQuat{1}=cutmot.rotationQuat{1};
% recmot.rootTranslation=cutmot.rootTranslation;
% recmot.jointTrajectories=forwardKinematicsQuat(skel,recmot);
% recmot=addAccToMot(recmot);
% motionplayer('skel',[skel,skel],'mot',[cutmot,recmot]);
    