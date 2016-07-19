function     [OptX,optc,steps,opts] ...
            =findCoefficientsSimulatedAnnealingX(set,optimStruct)
    
    draw=false;
    
    nrOfTechnicalModes=optimStruct.tensor.numTechnicalModes;

    nrOfNaturalModes=optimStruct.tensor.numNaturalModes;

    % Compute mode-n-product of core tensor and all matrices related to 
    % technical modes
    core_tmp=optimStruct.tensor.core;
    for i=1:nrOfTechnicalModes
        core_tmp=modeNproduct(core_tmp,optimStruct.tensor.factors{i},i);
    end

    root_tmp=optimStruct.tensor.rootcore;
    for i=1:nrOfTechnicalModes-1
        root_tmp=modeNproduct(root_tmp,optimStruct.tensor.rootfactors{i},i);
    end
    dimvec=size(core_tmp);
    % Define used representation of motion data within the Tensor and
    % define starting guess x0 if not set by user (through varargin)
    
    x0=set.startValue;
%     for i=1:nrOfNaturalModes
%         for j=1:dimvec(nrOfTechnicalModes+i)
%             x0=[x0 0];%1/dimvec(nrOfTechnicalModes+i)];
%         end
%     end
%     x0=x0(2:end);
    
    i_max =1000;
    alpha =0.992;
    T_0   =1;  
     
    tmpTensor=optimStruct.tensor;
    tmpTensor.core=core_tmp;
    tmpTensor.rootcore=root_tmp;

    fprintf('Iterations for Simulated Annealing: %i \n            ',i_max);

        
  % Initialise temperature
  T=T_0;
  
  % Initialise logging vectors

  c=zeros(1,i_max);
  
  % Get the length of x, that is, the dimension of the problem
  
  n=length(x0);
  
  % Initially, let the optimal X be equal to the 
  % initial estimate of x
  
  OptX=x0;
  
  % Now calculate the cost of the initial tour.  This is
  % our initial old cost and our initial optimal cost.
  
  tmp=objfun(x0,optimStruct);
  
  oldc=sum(tmp(:).*tmp(:));
  optc=oldc;
  
  % Initialise number of iterations
  
  i=1;
  
  if draw
      figure();
      hold on;
      grid on;
  end

  % Loop
  fprintf('i = %6i', i);
  while(i<=i_max && optc>1)
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
    lowBound=0.7;
    upBound=1.3;

    %Look for size of natural modes:
    
    sty =       optimStruct.tensor.dimNaturalModes(1);
    act = sty + optimStruct.tensor.dimNaturalModes(2);
    rep = act + optimStruct.tensor.dimNaturalModes(3);
    
    count=1;
    
%     Constrained Steps: Just take a step on (near) eliptic  subspace
%     while (min(tmpx0)<0 ...
%            || ... 
%            (  ( sum(tmpx0(1    :sty))<lowBound || sum(tmpx0(    1:sty))>upBound ) ...
%            || ( sum(tmpx0(sty+1:act))<lowBound || sum(tmpx0(sty+1:act))>upBound ) ...
%            || ( sum(tmpx0(act+1:rep))<lowBound || sum(tmpx0(act+1:rep))>upBound )) ...
%            && (count < 100) ...
%          )
        xPlus=(rand(1,n)-0.5);
        xPlus=(xPlus/sqrt(sum(xPlus.*xPlus)))*step;
        
        tmpx0=x0+xPlus;
        count=count+1;
%         fprintf('.'); 
%     end
    tmpx0=tmpx0/(sqrt(sum(tmpx0.*tmpx0))); 
         
    % Calculate the current cost of the circuit
    
    tmp=objfun(tmpx0,optimStruct);
    
    newc=sum(tmp(:).*tmp(:));
    % If this is a better solution, select it
    
    if(newc<=oldc)
        oldc=newc;
        x0=tmpx0;
        
         % If in addition this is the optimal solution found so far
        
        if(newc<=optc)

            if(draw)
                plot3(tmpx0(1),tmpx0(2),tmpx0(3),'*','color','red');
                drawnow();
            end
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
         if(draw)
            plot3(tmpx0(1),tmpx0(2),tmpx0(3),'.');
            drawnow();
         end
    end
    
    opts(i,:)=OptX;

    % Update temperatur
    
    T=alpha*T;
    
    % Now increment i
    
    i=i+1;
    
    % Thats all  
  end
  
end
