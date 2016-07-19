function [mot_new] = appendAndBlend(skel,mot_1,mot_2,overlap,varargin)

switch nargin
    case 4
       calcFast  =true(1);
       calcFwdKin=true(1);
    case 5
       calcFast=varargin{1};
       calcFwdKin=true(1);
    case 6
       calcFast=varargin{1};
       calcFwdKin=varargin{2};
    otherwise
        disp('Wrong number of arguments');
end

%% Start time measurement
tic;

%% Copy motion one.
mot_new     =   mot_1;

%% reduce overlap if beyond nframes:
if (overlap >= min(mot_1.nframes,mot_2.nframes))
    overlap = min(mot_1.nframes,mot_2.nframes) - 1;
    fprintf('Reducing overlap to %g',overlap);
end

%% Calculate new number of frames:
mot_new.nframes     = mot_1.nframes+mot_2.nframes-overlap;

%% Rotate Orientation of root
%Quaternion to use complete Orientation
diffQ=quatmult(mot_1.rotationQuat{1}(:,mot_1.nframes-overlap),quatconj(mot_2.rotationQuat{1}(:,1)));
% diffQ(2)=0;
% diffQ(4)=0;
diffQ=quatnormalize(diffQ);

for j=1:mot_2.nframes
     mot_2.rotationQuat{1}(:,j)=quatmult(diffQ,mot_2.rotationQuat{1}(:,j));
end

mot_2.rootTranslation=quatrot(mot_2.rootTranslation,diffQ);

%% Translation of root position
diffV=mot_1.rootTranslation(:,mot_1.nframes-overlap)-mot_2.rootTranslation(:,1);
% diffV(2)=0;
for j=1:mot_2.nframes
    mot_2.rootTranslation(:,j)=mot_2.rootTranslation(:,j)+diffV;
end

%% Interpolation of rotational part in overlapping window
for i=1:mot_1.njoints
    scale=(1:overlap+1)/(overlap+1);
    for frame=1:overlap
        % Q = slerp(q1,q2,u,tol)
       if(~isempty(mot_1.rotationQuat{i}))
           q1=mot_1.rotationQuat{i}(:,mot_1.nframes-overlap+frame);
           q2=mot_2.rotationQuat{i}(:,frame);
           if((q1(1)<0&&q2(1)>0)||(q1(1)<0&&q2(1)>0))
                q2=q2*-1;
           end
           if(calcFast)
               RotTMP.rotationQuat{i}(:,frame)=q1*(1-scale(frame))+q2*scale(frame);%Linear interpolation instead of slerp (fast)
           else
                q1=quatnormalize(q1);           
                q2=quatnormalize(q2);
                RotTMP.rotationQuat{i}(:,frame)=slerp(q1,q2,scale(frame)); %Slerp(slow) Debug?
           end
       end
    end
end

%% Concatenation of the rotational part
for i=1:mot_1.njoints
    if(~isempty(mot_1.rotationQuat{i}))
        if overlap>0
         mot_new.rotationQuat{i}=[mot_1.rotationQuat{i}(:,1:mot_1.nframes-overlap) RotTMP.rotationQuat{i} mot_2.rotationQuat{i}(:,overlap+1:mot_2.nframes)];
        else
         mot_new.rotationQuat{i}=[mot_1.rotationQuat{i}(:,1:mot_1.nframes) mot_2.rotationQuat{i}(:,1:mot_2.nframes)];
        end
    end
end

%% This window has to be interpolated (Translation):
scale=(1:overlap+1)/(overlap+1);
for frame=1:overlap
   TransTMP(:,frame)=mot_1.rootTranslation(:,mot_1.nframes-overlap+frame)*(1-scale(frame))+mot_2.rootTranslation(:,frame)*scale(frame);
end

%% The other frames can be concateneted (Translation).
if overlap>0
    mot_new.rootTranslation=[mot_1.rootTranslation(:,1:mot_1.nframes-overlap) TransTMP mot_2.rootTranslation(:,overlap+1:mot_2.nframes)];
else
    mot_new.rootTranslation=[mot_1.rootTranslation(:,1:mot_1.nframes) mot_2.rootTranslation(:,1:mot_2.nframes)];
end
ex=exist('mot_new.orgFrames');
if(ex~=0)
    mot_new.orgFrames=[mot_1.orgFrames(1:mot_1.nframes-overlap) mot_2.orgFrames(1:mot_2.nframes)];
end

%% Final clean up of other params
if (calcFwdKin)
    mot_new.jointTrajectories = forwardKinematicsQuat(skel,mot_new);
    mot_new.boundingBox=computeBoundingBox(mot_new);
end
%% Display time:
time=toc;
% disp(['Generated motion in:            ' num2str(time) ' seconds']);