function     [OptX,optc,steps,opts] ...
            =findCoefficientsSimulatedAnnealingConstrainedSQ(Tensor,newMot,varargin)
    
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
    x0=x0(2:end);
    
    i_max =1000;
    alpha =0.999;
    T_0   =1;   
    
    switch nargin
        case 2
            DataRep='Quat';  
            remSteps=false;            
        case 3
            DataRep=varargin{1};  
            remSteps=false;            
        case 4
            i_max=varargin{2};
            DataRep=varargin{1};
            remSteps=false;            
        case 5
            i_max=varargin{2};
            DataRep=varargin{1};
            if(varargin{3}~=0)
                x0 =varargin{3};
            end
            remSteps=false;
        case 6
            i_max=varargin{2};
            DataRep=varargin{1};
            if(varargin{3}~=0)
                x0 =varargin{3};
            end
            remSteps=varargin{4};
        case 7
            i_max=varargin{2};
            DataRep=varargin{1};
            if(varargin{3}~=0)
                x0 =varargin{3};
            end
            remSteps=varargin{4};            
            alpha=varargin{5};
        otherwise
            disp('Wrong number of arguments');
    end
    
    tmpTensor=Tensor;
    tmpTensor.core=core_tmp;
    tmpTensor.rootcore=root_tmp;

    
    fprintf('Iterations: %i \n',i_max);

        
  % Initialise temperature
  T=T_0;
  
  % Initialise logging vectors
  
     E=zeros(1,i_max);
  optE=zeros(1,i_max);
     c=zeros(1,i_max);
  
  % Get the length of x, that is, the dimension of the problem
  
  n=length(x0);
  
  % Initially, let the optimal X be equal to the 
  % initial estimate of x
  
  OptX=x0;
  
  % Now calculate the cost of the initial tour.  This is
  % our initial old cost and our initial optimal cost.
  
  tmp=objfun(  x0,tmpTensor,newMot, ...
                nrOfNaturalModes, ...
                nrOfTechnicalModes,...
                dimvec,skel,DataRep);
  oldc=sum(tmp(:).*tmp(:));
  optc=oldc;
  
  % Initialise number of iterations
  
  i=1;

  % Loop
   fprintf('i = %6i', i);
  while(i<=i_max && optc>0.01)
    for a=1:6+4+4+8
        fprintf('\b');
    end
    fprintf('i = %6i', i);
    fprintf(' T = %1.5f', T);
    % Pick an arbitrary solution in the neighbourhood
    step=exp(-4+T*4);
    tmpx0=x0;
    tmpx0(1)=-1;
%     tmpTensor.numNaturalModes
%     tmpTensor.dimNaturalModes
    lowBound=0.6;
    upBound=1.4;

    %Look for size of natural modes:
    
    sty =       Tensor.dimNaturalModes(1);
    act = sty + Tensor.dimNaturalModes(2);
    rep = act + Tensor.dimNaturalModes(3);
    
    % Constrained Steps: Just take a step on (near) eliptic  subspace
    count=0;
    while (     min(tmpx0)<0 ...
           || ( ...
                  ( sqrt(sum(tmpx0(1    :sty).*tmpx0(1    :sty)))<lowBound || sqrt(sum(tmpx0(1    :sty).*tmpx0(1    :sty)))>upBound ) ...
               || ( sqrt(sum(tmpx0(sty+1:act).*tmpx0(sty+1:act)))<lowBound || sqrt(sum(tmpx0(sty+1:act).*tmpx0(sty+1:act)))>upBound ) ...
               || ( sqrt(sum(tmpx0(act+1:rep).*tmpx0(act+1:rep)))<lowBound || sqrt(sum(tmpx0(act+1:rep).*tmpx0(act+1:rep)))>upBound ) ...
           ) ...
           && count<10 ...
          )

        xPlus=(rand(1,n)-0.5);
        xPlus=(xPlus/sqrt(sum(xPlus.*xPlus)))*step;

        tmpx0=abs(x0+xPlus);
        count=count+1;
%         fprintf('X=');
%         for a=1:act
%             fprintf(' (%i)=%f',a,tmpx0(a));
%         end
%         fprintf('\n');
    end
%     tmpx0=tmpx0/(sqrt(sum(tmpx0.*tmpx0)));

    if(remSteps)
        steps(i,:)=tmpx0;
    else
        steps=0;
    end
      
    % Calculate the current cost of the circuit
    
    tmp=objfun(tmpx0,tmpTensor,newMot, ...
                nrOfNaturalModes, ...
                nrOfTechnicalModes,...
                dimvec,skel,DataRep);
    newc=sum(tmp(:).*tmp(:));
    % If this is a better solution, select it
    
    if(newc<=oldc)
        oldc=newc;
        x0=tmpx0;
        
         % If in addition this is the optimal solution found so far
        
        if(newc<=optc)
            fprintf('\n\n\ni = %6i', i);
            fprintf('T = %2.3f', T);
            optc=newc
            OptX=tmpx0
            fprintf('\n\n\ni = %6i', i);
            fprintf('T = %2.3f', T);
        end

    % If this is an inferior solution, select it with a certain
    % probability
    
    else
      r=rand;
      if(r<exp((oldc-newc)/T))
          oldc=newc;
          x0=tmpx0;
          c(i)=1;
      end
    end
    
    opts(i,:)=OptX;
    
    % Log current status
    
%     E(i)=oldc;
%     optE(i)=optc;
    
    % Update temperatur
    
    T=alpha*T;
    
    % Now increment i
    
    i=i+1;
    
    % Thats all  
  end
  
end
