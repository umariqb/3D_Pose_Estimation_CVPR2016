function res = recMotNG(skel,mot,priorKnowledge)

% setting variables ----------------------------------------------
dataRep             = 'euler'; % quat is bad for prior

controlJoints       = [4,9,17,18,20,25,27]; % joints for simulated control signal
selectedJoints      = [4,9,19,20,26,27];%[3,4,8,9,12:17,19,20,26,27];%[4,9,20,27,3,8,19,26]; % joints for prior term
k                   = 25; % number of nearest neighbours
nrOfPrinComps       = []; % number of principal components

startFrame          = 1;
endFrame            = 10;%mot.nframes;
% ----------------------------------------------------------------


% preprocessing data ---------------------------------------------
selectedJointsIndices       = jointIDsToMatrixIndices(skel,selectedJoints);

posData = priorKnowledge.mat_pos;
nGraph  = priorKnowledge.nGraph;

mot.rootTranslation         = zeros(3,mot.nframes);
% mot.rotationQuat{1}         = [ones(1,mot.nframes);zeros(3,mot.nframes)];
% mot                         = convert2euler(skel,mot);
% mot.jointTrajectories       = forwardKinematicsQuat(skel,mot);
% mot.boundingBox             = computeBoundingBox(mot);
mot                         = fitRootOrientationsFrameWise(skel,mot);

mot                         = cutMotion(mot,startFrame,endFrame);
skel                        = addDOFIDsToSkel(skel);

res.origmot                 = mot;
optimStruct.origmot         = mot;

posData                     = mat2cell(posData,3*ones(1,size(posData,1)/3),size(posData,2));
posData                     = cell2mat(posData(controlJoints));

switch dataRep
    case 'quat'
        rotData = priorKnowledge.mat_quat;
        optimStruct.selectedJointsIndices = selectedJointsIndices.quats;
        rotations = zeros(size(cell2mat(mot.rotationQuat(mot.animated))));
    case 'euler'
        rotData = priorKnowledge.mat_euler;
        optimStruct.selectedJointsIndices = selectedJointsIndices.euler;
        rotations = zeros(size(cell2mat(mot.rotationEuler(mot.animated))));
end

controlSignal               = cell2mat(mot.jointTrajectories(controlJoints));

optimStruct.skel            = skel;

if isempty(nrOfPrinComps)
    nrOfPrinComps = size(rotData,1);
end

optimStruct.nrOfPrinComps   = nrOfPrinComps;
optimStruct.qlastlast       = [];
optimStruct.qlast           = [];
optimStruct.controlJoints   = controlJoints;

% quats = cell2mat(mot.rotationQuat(mot.animated));
% optimStruct.qlastlast       = quats(:,1);
% optimStruct.qlast           = quats(:,2);

% ----------------------------------------------------------------


% setting options for optimization -------------------------------
options = optimset( 'Display','iter',...
                    'MaxFunEvals',100000,...
                    'MaxIter',100,...
                    'TolFun',0.001,...
                    'PlotFcns', @optimplotx);

%                     'LargeScale','off',...%);%,...
                    
lb = [];
ub = [];
% ---------------------------------------------------------------


% estimating nearest neighbours of 0th frame --------------------
distances = sum(abs(posData-repmat(controlSignal(:,1),1,size(posData,2))));
[distancesSorted,indicesSorted] = sort(distances);
NNlast                          = indicesSorted(1:k); % indices of NN of last synthesized pose
% ---------------------------------------------------------------

for i=startFrame:endFrame
    
    counter = i-startFrame+1;
    fprintf('\nReconstructing frame %i (%i/%i)...\n',i,counter,endFrame-startFrame+1);
    
    optimStruct.controlSignal = controlSignal(:,counter);
    
    NNcandidates        = getNeighboursNGraph(nGraph,NNlast);
    fprintf('Number of NN-candidates: %i\n',length(NNcandidates));
    rotData_tmp         = rotData(:,NNcandidates);
    posData_tmp         = posData(:,NNcandidates);
    indicesSorted       = sortByQueryMetric(rotData_tmp,posData_tmp,optimStruct.qlast,optimStruct.qlastlast,optimStruct.controlSignal);
    NNlast              = NNcandidates(indicesSorted(1:k));
        
    optimStruct.localModel_rot      = rotData(:,NNlast)';
%     optimStruct.localModel_pos      = posData(:,NNlast)';
    
    [optimStruct.coeffs,optimStruct.score]  = princomp(optimStruct.localModel_rot);
    optimStruct.meanVec                     = mean(optimStruct.localModel_rot,1)';
    
    optimStruct.Delta       = optimStruct.localModel_rot(:,optimStruct.selectedJointsIndices);
    optimStruct.priorFactor = inv(cov(optimStruct.Delta));
    
    % -----------------------------------------------------------
    % Es gilt (modulo Rechenungenauigkeit):
    % optimStruct.localModel_rot == ...
    %               optimStruct.score(:,1:nrOfPrinComps) * optimStruct.coeffs(:,1:nrOfPrinComps)' ...
    %               + repmat(optimStruct.meanVec,nrOfPrinComps,1);
    % -----------------------------------------------------------
    
    % optimization for frame i ----------------------------------
    startValue = (optimStruct.localModel_rot(1,:)-optimStruct.meanVec') / optimStruct.coeffs(:,1:nrOfPrinComps)';
%     startValue = ones(size(optimStruct.meanVec'))/length(optimStruct.meanVec);
    
    X = lsqnonlin(@(x) objfunLocal(x,optimStruct),startValue,lb,ub,options);
    % -----------------------------------------------------------
    
    if ~isempty(optimStruct.qlast)
        optimStruct.qlastlast = optimStruct.qlast;
    end
    
    optimStruct.qlast =  optimStruct.coeffs(:,1:nrOfPrinComps) * X'...
                           + optimStruct.meanVec;
                       
    if ~isempty(optimStruct.qlastlast)
        optimStruct.smoothSummand = - 2*optimStruct.qlast + optimStruct.qlastlast;
    end
    
    rotations(:,counter) = optimStruct.qlast;  
end

res.recmot = buildMotFromRotData(rotations,skel);

end

%% local functions
function f = objfunLocal(x,optimStruct)
    
    rotData_curr    =  optimStruct.coeffs(:,1:optimStruct.nrOfPrinComps) * x'...
                           + optimStruct.meanVec;

    q_curr          = buildMotFromRotData(rotData_curr,optimStruct.skel);
    
    % ------- control term ------------
    
    e_control = cell2mat(q_curr.jointTrajectories(optimStruct.controlJoints))...
                  - optimStruct.controlSignal;
              
    e_control = e_control / sqrt(numel(e_control));
              
%     e_control = sum(e_control.^2);
             
    % ------- smoothness term ---------
    
    if ~isempty(optimStruct.qlastlast)
        e_smooth = rotData_curr + optimStruct.smoothSummand;
    else
        e_smooth = zeros(size(rotData_curr));
    end
    
    e_smooth = e_smooth / sqrt(numel(e_smooth));
    
%     e_smooth = sum(e_smooth.^2);
    
    % ------- prior term ------------
    
    diffVec = (rotData_curr(optimStruct.selectedJointsIndices)-optimStruct.meanVec(optimStruct.selectedJointsIndices));
    e_prior =     diffVec'...
                * optimStruct.priorFactor...
                * diffVec;   
    
    e_prior = e_prior / numel(diffVec);
    % ------- overall error --------
    
%     f = e_prior;
    
    w_control = 1;%0.8;
    w_smooth = 1;%0.2;
    w_prior = 1;%0.5;

    f = [w_control * e_control;... 
         w_smooth  * e_smooth;...
         w_prior   * e_prior];
    
%     b = [sum((w_control*e_control).^2) sum((w_smooth *e_smooth ).^2)];
%     b = [sum((w_control*e_control).^2) sum((w_smooth *e_smooth ).^2) (w_prior*e_prior).^2];

end