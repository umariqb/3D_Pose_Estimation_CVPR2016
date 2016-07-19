function mot=createMotionFromCoreTensor(Tensor,skel,varargin)

switch nargin
    case 2
        quatNorm=true(1);
        fwdKin  =true(1);
        DataRep ='Quat';
    case 3
        quatNorm=true(1);
        fwdKin  =varargin{1};
        DataRep ='Quat';
    case 4
        quatNorm=varargin{2};
        fwdKin  =varargin{1};
        DataRep ='Quat';
    case 5
        quatNorm=varargin{2};
        fwdKin  =varargin{1};
        DataRep =varargin{3};   
    otherwise
        error('createMotionFromCoreTensor: Wrong number of args!\n');
end

dims=size(Tensor.core);
mot = emptyMotion;

mot.njoints=dims(3);
mot.nframes=dims(2);

mot.rootTranslation=Tensor.rootcore(:,:);
% mot.rootTranslation=zeros(3,dims(2));
for joint=1:mot.njoints
    switch DataRep
        case 'Quat'
            mot.rotationQuat{1,joint}=Tensor.core(:,:,joint);
            if(~isempty(mot.rotationQuat{joint}))
                for i=1:mot.nframes
                    if( mot.rotationQuat{joint}(1,i)==0 && ...
                        mot.rotationQuat{joint}(2,i)==0 && ... 
                        mot.rotationQuat{joint}(3,i)==0 && ...
                        mot.rotationQuat{joint}(4,i)==0 )
                        mot.rotationQuat{joint}(1,i)=1; 
                    end
        %             if(mot.rotationQuat{joint}(1,i)<0)
        %               mot.rotationQuat{joint}(2:4,i)=mot.rotationQuat{joint}(2:4,i)*-1;
        %             end
                end
            end
            if(quatNorm)
                mot.rotationQuat{joint} =quatnormalize(mot.rotationQuat{joint});
        %         mot.rotationEuler{joint}=quat2euler(mot.rotationQuat{joint});
            end
        case 'Position'
            mot.jointTrajectories{1,joint}=Tensor.core(:,:,joint);    
            fwdKin=false;
        case 'ExpMap'
            mot.rotationQuat{joint}=quatexp(Tensor.core(:,:,joint));
%             mot.rotationQuat{joint}=quatnormalize(mot.rotationQuat{joint});
%             if(~isempty(mot.rotationQuat{joint}))
%                 for i=1:mot.nframes
% %                     if( mot.rotationQuat{joint}(1,i)==0 && ...
% %                         mot.rotationQuat{joint}(2,i)==0 && ... 
% %                         mot.rotationQuat{joint}(3,i)==0 && ...
% %                         mot.rotationQuat{joint}(4,i)==0 )
% %                         mot.rotationQuat{joint}(1,i)=1; 
% %                     end
%             if(mot.rotationQuat{joint}(1,i)<0)
%               mot.rotationQuat{joint}(2:4,i)=mot.rotationQuat{joint}(2:4,i)*-1;
%             end
%                 end
%             end
        otherwise
            error('createMotionFromCoreTensor: Wrong type specified in var: DataRep\n');
    end
end

mot.rotationQuat=mot.rotationQuat';

mot.samplingRate=30;
mot.frameTime=1/30;

mot.jointNames=skel.jointNames;
mot.boneNames=skel.boneNames;
mot.nameMap=skel.nameMap;
mot.animated=skel.animated;
mot.unanimated=skel.unanimated;


if(fwdKin)
    mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
    mot.boundingBox = computeBoundingBox(mot);
end

% animate(skel,mot);