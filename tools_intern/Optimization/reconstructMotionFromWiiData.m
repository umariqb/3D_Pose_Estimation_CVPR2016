function res = reconstructMotionFromWiiData(Tensor,skel,wii_output,motOrig)

joint = input('Choose jointID for wii output: ');

% wii_output = wii_output(:,9:11)';
% wii_output(3,:) = -9.81 * wii_output(3,:);

% wii_output = wii_output(:,1:3)';
% wii_output(3,:) = -wii_output(3,:);

X0 = cell(1,Tensor.numNaturalModes);
x0 = [];

% X0{1}=[0 1 0];
% X0{2}=[1 0 0 0 0];
% X0{3}=[1 0 0];

for i=1:Tensor.numNaturalModes
    X0{i} = ones(1,Tensor.dimNaturalModes(i))/Tensor.dimNaturalModes(i);
    x0    = [x0 X0{i}];
end

% x0 = [1 0 0 1 0 0 0 0 1 0 0];


% [xx,refMot] = constructMotion(Tensor,X0,skel);
% refMot = addAccToMot(refMot);
% refdata = refMot.jointAccelerations{joint};
% % refdata=mean{joint};
% refdata(2,:) = refdata(2,:) + 9.81;

% % framerate
% oldRate = 50;
% newRate = 30;
% wii_output = changeSamplingRate(wii_output,oldRate,newRate);

% wii_output = filterTimeline(wii_output,2,'bin');

% wiiData = cutWiiData(wii_output,refdata);

% wiiData = resample(wii_output',floor(86/length(wii_output)*1000),1000)';

wiiData = wii_output;

% DTW

options = optimset( 'Display','iter',...
                    'MaxFunEvals',100000,...
                    'MaxIter',100,...
                    'TolFun',0.001,...
                    'PlotFcns', @optimplotx);

core = Tensor.core;
rootcore = Tensor.rootcore;

for i=1:Tensor.numTechnicalModes
    core        = modeNproduct(core,Tensor.factors{i},i);
end
for i=1:Tensor.numTechnicalModes-1
    rootcore    = modeNproduct(rootcore,Tensor.rootfactors{i},i);
end

optimStruct.motOrig = motOrig;
optimStruct.wiiData = wiiData;
optimStruct.joint = joint;
optimStruct.tensor = Tensor;
optimStruct.preparedCore = core;
optimStruct.preparedRootCore = rootcore;
optimStruct.skel = skel;

lb = -0.1 * ones(1,length(x0));
ub = 1.1  * ones(1,length(x0));

coeffs = lsqnonlin(@(x) objfunWii(x,optimStruct),x0,lb,ub,options);

res.coeffs = mat2cell(coeffs,1,Tensor.dimNaturalModes)';

for i=1:Tensor.numNaturalModes
    core    = modeNproduct(core,...
                res.coeffs{i}*Tensor.factors{i+Tensor.numTechnicalModes},...
                i+Tensor.numTechnicalModes);
end

for i=1:Tensor.numNaturalModes
    rootcore    = modeNproduct(rootcore,...
                res.coeffs{i}/sum(res.coeffs{i})*...
                Tensor.rootfactors{i+Tensor.numTechnicalModes-1},i+Tensor.numTechnicalModes-1);
end

res.motRec = createMotionFromCoreTensor_jt(core,rootcore,skel,true,true,Tensor.DataRep);

end
%% 

function f = objfunWii(x,optimStruct)

X = mat2cell(x,1,optimStruct.tensor.dimNaturalModes)';

for i=1:optimStruct.tensor.numNaturalModes
    optimStruct.preparedCore     = modeNproduct(optimStruct.preparedCore,...
                                    X{i}*optimStruct.tensor.factors{i+optimStruct.tensor.numTechnicalModes},...
                                    i+optimStruct.tensor.numTechnicalModes);
    optimStruct.preparedRootCore = modeNproduct(optimStruct.preparedRootCore,...
                                    X{i}*optimStruct.tensor.rootfactors{i+optimStruct.tensor.numTechnicalModes-1},...
                                    i+optimStruct.tensor.numTechnicalModes-1);
end

motRec = createMotionFromCoreTensor_jt(optimStruct.preparedCore,...
    optimStruct.preparedRootCore,...
    optimStruct.skel,...
    true,...
    true,...
    optimStruct.tensor.DataRep);

motRec = addAccToMot(motRec);

recData = motRec.jointAccelerations{optimStruct.joint};
recData(2,:)=recData(2,:)+9.81;

motRec = computeLocalSystems(optimStruct.skel,motRec); 

P = C_quatrot(recData,C_quatinv(motRec.localSystems{optimStruct.joint}));
Q = optimStruct.wiiData;

% [R,T] = icp(P,Q);

T = findOptimalPCtransformation(P,Q);

f = T.pc1_new - Q;

end

%%
function wii_cut = cutWiiData(wiidata,refdata)

    wiiNorm = normOfColumns(wiidata);
    refNorm = normOfColumns(refdata);
    
    mindist = inf;
    for i=1:length(wiiNorm)-length(refNorm)+1
        
        T = findOptimalPCtransformation(wiidata(:,i:i+length(refdata)-1),refdata);
        dist = sqrt(sum((T.pc1_new - refdata).^2));
%         fprintf('%i\n',sum(dist));
        if sum(dist)<mindist 
            mindist=sum(dist);
            strt=i;
        end
    end
    wii_cut = wiidata(:,strt:strt+length(refNorm)-1);
    fprintf('\nstart frame: %i, end frame: %i\n',strt,strt+length(refNorm)-1);
    plot(wiiNorm(:,strt:strt+length(refNorm)-1));
    hold all;
    plot(refNorm);
    drawnow();
end

%% 
function newdata = changeSamplingRate(data,oldRate,newRate)

oldSampling=1:length(data);
newSampling=1:oldRate/newRate:length(data);
newdata = spline(oldSampling,data,newSampling);

end