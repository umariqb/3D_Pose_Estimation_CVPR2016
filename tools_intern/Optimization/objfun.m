function f = objfun(x,optimStruct)

if ~iscell(x)
    XorY = vectorToCellArray(x,optimStruct.optimDims);
else
    XorY = x;
end
Y    = cell(size(XorY));
X    = cell(size(XorY));

counter = 0;
for i=optimStruct.modesToOptimize
    counter = counter+1;
    if optimStruct.optimVar=='y'
        Y{counter} = XorY{counter};
        X{counter} = Y{counter}/optimStruct.tensor.factors{i};
    elseif optimStruct.optimVar=='x'
        X{counter} = XorY{counter};
        Y{counter} = XorY{counter}*optimStruct.tensor.factors{i};
    end
    optimStruct.preparedCore     = modeNproduct(optimStruct.preparedCore,Y{counter},i);
end

counter = 0;
for i=optimStruct.rootModesToOptimize
    counter = counter+1;
    optimStruct.preparedRootCore = modeNproduct(optimStruct.preparedRootCore,...
        X{counter}*optimStruct.tensor.rootfactors{i},i);
end

motRec  = createMotionFromCoreTensor_jt(optimStruct.preparedCore,...
    optimStruct.preparedRootCore,optimStruct.skel,true,true,optimStruct.tensor.DataRep);

switch optimStruct.trajRep
    case {'p','pos'}
        trajectoriesRec = motRec.jointTrajectories;
    case {'v','vel'}
        motRec          = addVelToMot(motRec);
        trajectoriesRec = motRec.jointVelocities;
    case {'a','acc'}
        if ~(strcmpi(optimStruct.tensor.DataRep,'Acc'))
            motRec      = addAccToMot(motRec);
        end
        trajectoriesRec = motRec.jointAccelerations;
    case {'exp','ExpMap'}
        for j=1:motRec.njoints
            if(~isempty(motRec.rotationQuat{j}))
                motRec.rotationExpMap{1,j}=quatlog(motRec.rotationQuat{j});
            else
                motRec.rotationExpMap{1,j}=zeros(3,motRec.nframes);
            end
        end
        trajectoriesRec = motRec.rotationExpMap;
    case {'quat','Quat'}
        trajectoriesRec = motRec.rotationQuat;
end

% Smoothness (experimental)

% f_s=[0;0;0];
% 
% if optimStruct.currMotion.nframes>2
%     tmp=addFrame2Motion(optimStruct.currMotion, motRec);
%     
%     tmp=addAccToMot(tmp);
%     tmp=addVelToMot(tmp);
% %     f_s=abs(tmp.jointAccelerations{5}(:,tmp.nframes-3)-tmp.jointAccelerations{5}(:,tmp.nframes-2));
%     f_s=abs(tmp.jointVelocities{5}(:,tmp.nframes-3)-tmp.jointVelocities{5}(:,tmp.nframes-2));       
% end

if ~(isempty(optimStruct.jointToPlot))
    subplot(1,4,1); 
        bar(X{1});
        xlabel('Styles');
        axis([0,optimStruct.tensor.dimNaturalModes(1)+1,-0.5,1.5]);
    subplot(1,4,2); 
        bar(X{2});
        set(gca,'XTickLabel',{'BD','BK','DG','MM','TR'});
        xlabel('Actors');
        axis([0,optimStruct.tensor.dimNaturalModes(2)+1,-0.5,1.5]);
    subplot(1,4,3); 
        bar(X{3});
        xlabel('Repetitions');
        axis([0,optimStruct.tensor.dimNaturalModes(3)+1,-0.5,1.5]);
    subplot(1,4,4); 
        plot3(optimStruct.originalTraj{optimStruct.jointToPlot}(1,:),...
            optimStruct.originalTraj{optimStruct.jointToPlot}(2,:),...
            optimStruct.originalTraj{optimStruct.jointToPlot}(3,:),...
            'b',...
            trajectoriesRec{optimStruct.jointToPlot}(1,:),...
            trajectoriesRec{optimStruct.jointToPlot}(2,:),...
            trajectoriesRec{optimStruct.jointToPlot}(3,:),...
            'r');
        axis(optimStruct.axesBoundaries);
        jointName=optimStruct.skel.jointNames{optimStruct.jointToPlot};
        title(jointName,'Interpreter','none');
    drawnow;
end

numFrames=motRec.nframes;

Pt=cell2mat(optimStruct.originalTraj(optimStruct.consideredJoints));
Qt=cell2mat(         trajectoriesRec(optimStruct.consideredJoints));

d_datarep=size(trajectoriesRec{optimStruct.consideredJoints(1)},1);

P=reshape(Pt,d_datarep,size(optimStruct.consideredJoints,2)*numFrames);
Q=reshape(Qt,d_datarep,size(optimStruct.consideredJoints,2)*numFrames);

switch optimStruct.trajRep
    case {'p','pos','v','vel','a','acc'}
        f = pointCloudDist_modified(P,Q,optimStruct.trajRep);
%         f=P-Q;
    case {'quat','Quat'}
        lP=ones(1,size(P,2));
        lQ=ones(1,size(P,2));
        P1=ones(4,size(P,2));
        Q1=ones(4,size(P,2));
        for i=1:size(P,2)
            lP(i)=norm(P(:,i));
            lQ(i)=norm(Q(:,i));
            P1(:,i)=P(:,i)/lP(i);
            Q1(:,i)=Q(:,i)/lQ(i);
        end
        f(1,:)=1-dot(P1,Q1);
        f(2,:)=  abs( 1-lQ);
%         f=P-Q;
    case {'exp','ExpMap'}
%         f=P-Q;
        
        lP=ones(1,size(P,2));
        lQ=ones(1,size(P,2));
        P1=ones(3,size(P,2));
        Q1=ones(3,size(P,2));
        for i=1:size(P,2)
            lP(i)=norm(P(:,i));
            lQ(i)=norm(Q(:,i));
            if(lP(i)~=0)
                P1(:,i)=P(:,i)/lP(i);
            end
            if(lQ(i)~=0)
                Q1(:,i)=Q(:,i)/lQ(i);
            end
        end
        f(1,:)=1-dot(P1,Q1);
        f(2,:)=  abs(lP-lQ);
end 
% f=[f f_s];
end



% f=P-Q;
% f = pointCloudDist_modified(P,Q,optimStruct.trajRep);
% if sum(f(:).^2)<0.01
%     f=0;
% end
