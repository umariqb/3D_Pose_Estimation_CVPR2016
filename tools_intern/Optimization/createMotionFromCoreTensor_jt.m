function mot=createMotionFromCoreTensor_jt(core,rootcore,skel,varargin)

switch nargin
    case 3
        fwdKin      = true;
        quatNorm    = true;
        DataRep     = 'quat';
    case 4
        fwdKin      = varargin{1};
        quatNorm    = true;
        DataRep     = 'quat';
    case 5
        fwdKin      = varargin{1};
        quatNorm    = varargin{2};
        DataRep     = 'quat';
    case 6
        fwdKin      = varargin{1};
        quatNorm    = varargin{2};
        DataRep     = varargin{3};   
    otherwise
        error('createMotionFromCoreTensor_jt: Wrong number of arguments!\n');
end

dims                = size(core);
mot                 = emptyMotion;

mot.njoints         = skel.njoints;
mot.nframes         = dims(2);
mot.rootTranslation = rootcore(:,1:mot.nframes);

switch lower(DataRep)
    case 'quat'
        mot.rotationQuat=squeeze(mat2cell(core,size(core,1),size(core,2),ones(size(core,3),1)));

%             mot.rotationQuat{joint,1}=core(:,:,joint);
%             if(~isempty(mot.rotationQuat{joint,1}))
%                 mot.rotationQuat{joint,1}(1,sum(abs(mot.rotationQuat{joint,1}))==0) = 1;
%                 mot.rotationQuat{joint,1}(:,mot.rotationQuat{joint,1}(1,:)<0)       = ...
%                -mot.rotationQuat{joint,1}(:,mot.rotationQuat{joint,1}(1,:)<0);
%             end
%         if(quatNorm)
%             for joint=1:mot.njoints
%                 mot.rotationQuat{joint,1} = quatnormalize(mot.rotationQuat{joint,1});
%             end
%         end
    case 'pos'
        mot.jointTrajectories=squeeze(mat2cell(core,size(core,1),size(core,2),ones(size(core,3),1)));
%             mot.jointTrajectories{joint,1}=core(:,:,joint);    
        fwdKin=false;
    case 'acc'
        mot.jointAccelerations=squeeze(mat2cell(core,size(core,1),size(core,2),ones(size(core,3),1)));
%             mot.jointAccelerations{joint,1}=core(:,:,joint);
%             fwdKin=false;
    case 'expmap'
        mot.rotationExp=squeeze(mat2cell(core,size(core,1),size(core,2),ones(size(core,3),1)));
        for joint=1:mot.njoints
            mot.rotationQuat{joint,1}=quatexp(mot.rotationExp{joint,1});
        end
%             mot.rotationQuat{joint}=quatnormalize(mot.rotationQuat{joint});
%             if(~isempty(mot.rotationQuat{joint}))
%                 for i=1:mot.nframes
%                         if(mot.rotationQuat{joint}(:,i)==0)
%                             mot.rotationQuat{joint}(1,i)=1; 
%                         end
%             if(mot.rotationQuat{joint}(1,i)<0)
%               mot.rotationQuat{joint}(2:4,i)=mot.rotationQuat{joint}(2:4,i)*-1;
%             end
%                 end
%             end
    otherwise
        error('createMotionFromCoreTensor_jt: Wrong type specified in var: DataRep\n');
end

mot.samplingRate    = 30;
mot.frameTime       = 1/30;

mot.jointNames      = skel.jointNames;
mot.boneNames       = skel.boneNames;
mot.nameMap         = skel.nameMap;
mot.animated        = skel.animated;
mot.unanimated      = skel.unanimated;

if(fwdKin)
    mot.jointTrajectories   = forwardKinematicsQuat(skel,mot);
    mot.boundingBox         = computeBoundingBox(mot);
end