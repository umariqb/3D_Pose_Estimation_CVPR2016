function [X]=findCoefficientsModeSA(Tensor,newMot)

% Prepare Data for optimization:

    % Align first new Motion like all others!
    [skel,fitmot]=reconstructMotionT(Tensor,[1 1 1]);
    skel = readASF(Tensor.skeletons{1,1});
    newMot=fitMotion(skel,newMot);
    % Timewarp motion
    [newMot]=SimpleDTW(fitmot,skel,newMot);

    nrOfTechnicalModes=Tensor.numTechnicalModes;

    nrOfNaturalModes=Tensor.numNaturalModes;

    % Compute mode-n-product of core tensor and all matrices related to 
    % technical modes
    core_tmp=Tensor.core;
    for i=1:nrOfTechnicalModes
        core_tmp=modeNproduct(core_tmp,Tensor.factors{i},i);
    end

    root_tmp=Tensor.rootcore;
    for i=1:nrOfTechnicalModes-1
        root_tmp=modeNproduct(root_tmp,Tensor.rootfactors{i},i);
    end
    dimvec=size(core_tmp);
    % Define used representation of motion data within the Tensor and
    % define starting guess x0 if not set by user (through varargin)
    
    x0=0;
    for i=1:nrOfNaturalModes
        for j=1:dimvec(nrOfTechnicalModes+i)
            x0=[x0 1/dimvec(nrOfTechnicalModes+i)];
        end
    end
    x0=x0(2:end)
    
    X=Array2Cell(x0,nrOfNaturalModes,nrOfTechnicalModes);
    
    
D=inf;
time=0;

tic;

while((D>0.1)&&(time<30))
        D=rand(1,1);
        time=toc;
end


end

function [X]=Array2Cell(x0,nat,tec)
    for i=1:nat
        X{i}=x0(1:dimvec(i+tec));
        x0=x0(dimvec(i+tec)+1:size(x0,2));
    end
end