function     [OptX,OptY,optc,steps,opts] ...
            =findCoefficientsSimulatedAnnealingConstrainedColumn(Tensor,newMot,varargin)
    
%     % Align first new Motion like all others!
     [skel,fitmot]=reconstructMotionT(Tensor,[1 1 1]);
%     skel = readASF(Tensor.skeletons{1,1});
%     newMot=fitMotion(skel,newMot);
    % Timewarp motion
%     if newMot.samplingRate>30
%         newMot=reduceFrameRate(skel,newMot);
%     end
%     [newMot]=SimpleDTW(fitmot,skel,newMot);

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
    dimvec=Tensor.dimNaturalModes;
    % Define used representation of motion data within the Tensor and
    % define starting guess x0 if not set by user (through varargin)
    
    x0=[];
    for i=1:nrOfNaturalModes
        y0=[]
        for j=1:dimvec(i)
            y0=[y0 1/dimvec(i)];
        end
        x0=[x0 (Tensor.factors{nrOfTechnicalModes+i}'*y0')'];
    end
%     x0=x0(1:end);
        
    i_max =1000;
    alpha =0.99;
    T_0   =1;   
    
    switch nargin
        case 2
            DataRep='ExpMap';  
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
  
  cutdimvec=size(Tensor.core);
  
  tmp=objfunCol(  x0,tmpTensor,newMot, ...
                nrOfNaturalModes, ...
                nrOfTechnicalModes,...
                cutdimvec,skel,DataRep);
  oldc=sum(tmp(:).*tmp(:));
  optc=oldc;
  
  % Initialise number of iterations
  
  i=1;

  % Loop
   fprintf('i = %6i', i);
  while(i<=i_max && optc>0.1)
    for a=1:6+4+4+8
        fprintf('\b');
    end
    fprintf('i = %6i', i);
    fprintf(' T = %1.5f', T);
    % Pick an arbitrary solution in the neighbourhood
    step=exp(-4+T*4);
    tmpx0=x0;
%     tmpx0(1)=-1;
%     tmpTensor.numNaturalModes
%     tmpTensor.dimNaturalModes
%     lowBound=0.7;
%     upBound=1.3;

    %Look for size of natural modes:
%     
%     sty =       Tensor.dimNaturalModes(1);
%     act = sty + Tensor.dimNaturalModes(2);
%     rep = act + Tensor.dimNaturalModes(3);
%     
    % Constrained Steps: Just take a step on (near) eliptic  subspace
%     while (     min(tmpx0)<0 )%...
%            || ( sum(tmpx0(1    :sty))<lowBound || sum(tmpx0(    1:sty))>upBound ) ...
%            || ( sum(tmpx0(sty+1:act))<lowBound || sum(tmpx0(sty+1:act))>upBound ) ...
%            || ( sum(tmpx0(act+1:rep))<lowBound || sum(tmpx0(act+1:rep))>upBound ) ...
%           )
        xPlus=(rand(1,n)-0.5);
        xPlus=(xPlus/sqrt(sum(xPlus.*xPlus)))*step;

        tmpx0=x0+xPlus;
        
%         fprintf('.'); 
%     end
%     tmpx0=tmpx0/(sqrt(sum(tmpx0.*tmpx0)));

%     tmpx0
    
    if(remSteps)
        steps(i,:)=tmpx0;
    else
        steps=0;
    end
      
    % Calculate the current cost of the circuit
    
    tmp=objfunCol(tmpx0,tmpTensor,newMot, ...
                nrOfNaturalModes, ...
                nrOfTechnicalModes,...
                cutdimvec,skel,DataRep);
    newc=sum(tmp(:).*tmp(:));
    % If this is a better solution, select it
    
    if(newc<=oldc)
        oldc=newc;
        x0=tmpx0;
        
         % If in addition this is the optimal solution found so far
        
        if(newc<=optc)
%             fprintf('\n\n\ni = %6i', i);
%             fprintf('T = %2.3f', T);
            optc=newc;
            OptX=tmpx0;
            fprintf(' OptC = %f\n',optc);
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
  
  OptY=getRowCoefficients(Tensor,OptX);
  
end
