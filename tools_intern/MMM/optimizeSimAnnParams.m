function [OptX,optc,steps,opts]=optimizeSimAnnParams(Tensor,mot)
fprintf('\n\n\n                           ')


stepMult=1000;

T_0=1;
i_max =500;
alpha =0.99;

    x0(1)=0.5;%i_max =1000;
    x0(2)=0.5;%alpha =0.99;
    
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
  
  [X,Val] = findCoefficientsSimulatedAnnealingv2( ...
            Tensor,mot,'ExpMap',floor(x0(1)*stepMult),0,false,x0(2));
  
  oldc=Val;
  optc=oldc;
  
  % Initialise number of iterations
  
  i=1;

  % Loop
  fprintf('i = %6i', i);
  while(i<=i_max && optc>0)
    for a=1:6+4+4+8
        fprintf('\b');
    end
    fprintf('i = %6i', i);
    fprintf(' T = %1.5f', T);
%    Pick an arbitrary solution in the neighbourhood
    step=exp(-2+T);
    tmpx0=[0 -1];
%     while (tmpx0(2)<0||tmpx0(2)>1)
        xPlus=(rand(1,n));
        xPlus=(xPlus/sqrt(sum(xPlus.*xPlus)))*step;

        tmpx0=x0+xPlus;
%         fprintf('.');
%     end
    
   steps(i,:)=tmpx0;
    % Calculate the current cost of the circuit
    
    [X,Val] = findCoefficientsSimulatedAnnealingv2(...
                Tensor,mot,'ExpMap',floor(tmpx0(1)*stepMult),0,false,tmpx0(2));
    
    newc=Val;
%     % If this is a better solution, select it
    
    if(newc<=oldc)
        oldc=newc;
        x0=tmpx0;
        
         % If in addition this is the optimal solution found so far
        
        if(newc<=optc)
            optc=newc
            OptX=tmpx0
            fprintf('                        \n\n\n\n\n');
%             fprintf('\n\n\ni = %6i', i);
%             fprintf('T = %2.3f', T);
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