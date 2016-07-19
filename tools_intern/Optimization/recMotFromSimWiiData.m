function res = recMotFromSimWiiData(ttQuats,ttRootPos,skel,mot,joints)

mot     = fitMotion(skel,mot);
refMot  = extractMotFromTTensor(skel,ttQuats,ttRootPos,[1,1,1]);
[D,w]   = pointCloudDTW_pos(refMot,mot,2);
mot     = warpMotion(w,skel,mot);

res.skel    = skel;
res.origmot = mot;
res.joints  = joints;

optimStruct.TensorInfo.jointModeID = 3;
optimStruct.TensorInfo.frameModeID = 2;
optimStruct.TensorInfo.dofModeID = 1;
optimStruct.TensorInfo.modesForOpt = [4,5,6];

optimStruct.ttQuatsFact = tucker_als(ttQuats,ttQuats.size);
optimStruct.ttRootPosFact = tucker_als(ttRootPos,ttRootPos.size);

% simulate local accelerations
res.noise = 1;

optimStruct.simWiiData = cell(mot.njoints,1);
for j=joints
    optimStruct.simWiiData{j} = simulateLocalAccs(skel,mot,j,res.noise);
end

% ttQuats_prepared = ttm(ttQuats_factorized.core,...
%                       ttQuats_factorized.U(1:Tensor.numTechnicalModes),...
%                       1:Tensor.numTechnicalModes);   
% ttRootPos_prepared = ttm(ttRootPos_factorized.core,...
%                       ttRootPos_factorized.U(1:Tensor.numTechnicalModes-1),...
%                       1:Tensor.numTechnicalModes-1);   
                
optimStruct.skel            = skel;
optimStruct.origmot         = res.origmot;
optimStruct.joints          = joints;
optimStruct.ttQuats         = ttQuats;
optimStruct.ttRootPos       = ttRootPos;
% optimStruct.ttQuats_prepared = ttQuats_prepared;
% optimStruct.ttRootPos_prepared = ttRootPos_prepared;

% optimization options ----------------------------------------------------
options = optimset( 'Display','iter',...
                    'MaxFunEvals',100000,...
                    'MaxIter',100,...
                    'TolFun',0.001,...
                    'PlotFcns', @optimplotx);
                
optimStruct.dimQuats          = ttQuats.size;

startValue = buildStartValue(optimStruct.dimQuats(optimStruct.TensorInfo.modesForOpt));
              
lb = -0.2 * ones(1,length(startValue));
ub = 1.2  * ones(1,length(startValue));
% -------------------------------------------------------------------------

coeffs = lsqnonlin(@(x) objfunWii(x,optimStruct),startValue,lb,ub,options);

res.coeffs = mat2cell(coeffs,1,optimStruct.dimQuats(optimStruct.TensorInfo.modesForOpt))';
                 
res.recmot = ttensor2mot(optimStruct.ttQuatsFact,optimStruct.ttRootPosFact,optimStruct.skel,res.coeffs,optimStruct.TensorInfo,optimStruct.origmot);

res.recmot.boundingBox = computeBoundingBox(res.recmot);
end
%% 

function f = objfunWii(x,optimStruct)

X = mat2cell(x,1,optimStruct.dimQuats(optimStruct.TensorInfo.modesForOpt))';

motRec      = ttensor2mot(optimStruct.ttQuatsFact,optimStruct.ttRootPosFact,optimStruct.skel,X,optimStruct.TensorInfo,optimStruct.origmot);
                        
motRec      = addAccToMot(motRec);
motRec      = computeLocalSystems(optimStruct.skel,motRec); 

f= [];

for i=optimStruct.joints
    
    recData     = motRec.jointAccelerations{i};
    recData(2,:)= recData(2,:)+9.81;

    P = C_quatrot(recData,C_quatinv(motRec.localSystems{i}));
    Q = optimStruct.simWiiData{i};

    T = findOptimalPCtransformation(P,Q);
    
    f = [f;T.pc1_new - Q];
end

end
