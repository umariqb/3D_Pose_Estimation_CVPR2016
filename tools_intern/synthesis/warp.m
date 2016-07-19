function [retSignal1]=warp(path,signal1)
%Warping Algorithm
%Warps the given Signal corresponding to the given path
%The resulting signal is given back in retSignal

signal1=signal1';
%Get length of the warping path and original Signal
[pathLength,tmp]=size(path);
[rows,signalLength]=size(signal1);

%Some ints counting the positions:
signalPosition=1;
returnPosition=1;
vstep=0;
hstep=0;

diagonalstepcounter=0;
horizontalstepcounter=0;
verticalstepcounter=0;
stepcontrol=0;

n=pathLength;

retSignal1(:,1)=signal1(:,1);

while n>2
   %Search warping step given at this point
   %Three possibilitys:
   
   % 1st: diagonal step
    if (path(n,1)<path(n-1,1))&&(path(n,2)<path(n-1,2))
        stepcontrol=cat(1,stepcontrol,1);
        diagonalstepcounter=diagonalstepcounter+1;
        %Write Signal from signalPosition to retSignal at resultPosition
        returnPosition=returnPosition+1;
        signalPosition=signalPosition+1;
        retSignal1(:,returnPosition)=signal1(:,signalPosition);
        n=n-1;

   % 2nd: horizontal step
    elseif (path(n,1)==path(n-1,1))&&(path(n,2)<path(n-1,2))
        stepcontrol=cat(1,stepcontrol,2);
        horizontalstepcounter=horizontalstepcounter+1;
        %Check size of this warping step
        m=n;
        while path(m,1)==path(n-1,1)&&n>2
            n=n-1;
            hstep=hstep+1;
            signalPosition=signalPosition+1;
        end

        retSignal1(:,returnPosition)=signal1(:,signalPosition);
        hstep=0; 
            
   % 3rd: vertical step
    elseif (path(n,1)<path(n-1,1))&&(path(n,2)==path(n-1,2))
        stepcontrol=cat(1,stepcontrol,3);
        verticalstepcounter=verticalstepcounter+1;
        m=n;
        while path(m,2)==path(n-1,2)&&n>2
            vstep=vstep+1;
            n=n-1;
        end
        height(1:rows)=0;
        if signalPosition<signalLength
            for r=1:rows
                height(r)=(signal1(r,signalPosition)-signal1(r,signalPosition+1))/vstep;
            end
        end
        for i=1:vstep
            for r=1:rows
                retSignal1(r,returnPosition+i)=signal1(r,signalPosition)-height(r)*i;            
            end
        end
        returnPosition=returnPosition+vstep;
        vstep=0;
   % If we arrive here, the Path is not continous. The Result will be strange!     
    else
        fprintf('ERROR: Unexpected Path Segment: %i\n',n);
        n=n-1;
    end 
end

if (path(n,1)<path(n-1,1))&&(path(n,2)<path(n-1,2))
    stepcontrol=cat(1,stepcontrol,1);
    diagonalstepcounter=diagonalstepcounter+1;
    %Write Signal from signalPosition to retSignal at resultPosition
    returnPosition=returnPosition+1;
    signalPosition=signalPosition+1;
    retSignal1(:,returnPosition)=signal1(:,signalPosition);
elseif (path(n,1)==path(n-1,1))&&(path(n,2)<path(n-1,2))
    stepcontrol=cat(1,stepcontrol,2);
    horizontalstepcounter=horizontalstepcounter+1;
    n=n-1;
    hstep=hstep+1;
    signalPosition=signalPosition+1;
    retSignal1(:,returnPosition)=signal1(:,signalPosition);
    hstep=0; 
elseif (path(n,1)<path(n-1,1))&&(path(n,2)==path(n-1,2))
    stepcontrol=cat(1,stepcontrol,3);
    verticalstepcounter=verticalstepcounter+1;
    vstep=vstep+1;
    n=n-1;
    height(1:rows)=0;
    if signalPosition<signalLength
        for r=1:rows
            height(r)=(signal1(r,signalPosition)-signal1(r,signalPosition+1))/vstep;
        end
    end
    for i=1:vstep
        for r=1:rows
            retSignal1(r,returnPosition+i)=signal1(r,signalPosition)-height(r)*i;            
        end
    end
    returnPosition=returnPosition+vstep;
    vstep=0;
end

retSignal1=retSignal1';



