function f = objfunY(x,optimStruct)

Y = vectorToCellArray(x,optimStruct.optimDims);

counter = 0;
for i=optimStruct.modesToOptimize
    counter = counter+1;
    optimStruct.preparedCore     = modeNproduct(optimStruct.preparedCore,Y{counter},i);
    X{counter} = Y{counter}/optimStruct.tensor.factors{i};
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
end

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
numJoints=length(optimStruct.consideredJoints);

P=zeros(3,numJoints*numFrames);
Q=zeros(3,numJoints*numFrames);

counter=1;
for j=optimStruct.consideredJoints
    P(:,counter:counter+numFrames-1)    = optimStruct.originalTraj{j};
    Q(:,counter:counter+numFrames-1)    = trajectoriesRec{j};
    counter                             = counter+numFrames;
end

f = pointCloudDist_modified(P,Q,optimStruct.trajRep);