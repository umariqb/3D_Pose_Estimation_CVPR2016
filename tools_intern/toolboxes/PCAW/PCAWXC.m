function [T,P,xmean,expl,SS] = pcawxc(Xmn,W,r,xmean,convg,maxniter,plotopt,saveopt)
%   [T,P,xmean,expl,SS] = pcawxc(Xmn,W,r,xmean,convg,maxniter,plotopt,saveopt)
%
%   Purpose:
%   The next quantity is minimized:
%       min|| W * ( X - D.xmean' - T.P')||
%           over m  (mean center)
%           over T  (scores)
%           over P  (loadings)
%
%   Input: 
%   Xmn     -   (n x m) matrix 
%               Mean Centered Input data.
%
%   W       -   (n x m)  matrix
%               Contains 1/STD for each entry in X
%
%   r       -   scalar
%               Number of principal components.
%
%   xmean   -   Optional    (i x m) matrix.
%               Mean center of data.
%               Default: zeros(1,m) (where i is the number of individuals
%               in the data)
%
%   convg   -   (optional) scalar
%               Convergence criterium.
%               Default: 1e-5
%
%   maxniter-   (optional) scalar
%               Maximum number of iterations.
%               Default: 2000
%
%   plotopt  -  (optional) scalar
%               Plot intermediate results.
%               Default: 0
%       
%   saveopt  -  (optional) scalar
%               Save intermediate results.
%               Default: 0
%       
%   Output:
%   T       -  (n x r) matrix
%               Orthogonal scores on columns
%
%   P       -  (m x r) matrix
%               Orthogonal loadings on columns
%
%   xmean   -   (1 x m) vector
%               Updated mean center of data
%   
%   expl    -   Explained variance of Xmn [percent].
%
%   SS      -   (nniter x 1) vector
%               Weighted sum of squares: ||(Xmn-TP')*W||
%               for each niteration.
%
%   Based on an algorithm and computer program developed by Henk Kiers
%   Psychometrika 62(2) 251-266
%
%   ==========================================================================
%   Copyright 2005 Biosystems Data Analysis Group ; Universiteit van Amsterdam
%   ==========================================================================

global StopPCAW

persistent Isave figNr1 figNr2

%   Check arguments
[n,m]       = size(Xmn);
if ( nargin < 4 ) 
    xmean = zeros(10,m);
end
if ( isempty(xmean) )
    xmean = zeros(10,m);
end

if ( nargin < 5 ) 
    convg = 1e-5;
end
if ( isempty(convg) )
    convg = 1e-5;
end

if ( nargin < 6 ) 
    maxniter = 2000;
end
if ( isempty(maxniter) )
    maxniter = 2000; 
end

if ( nargin < 7 ) 
    plotopt = 0;
end
if ( isempty(plotopt) )
    plotopt = 0;    
end

if ( nargin < 8 ) 
    saveopt = 0;
end

%   Start Code
StopPCAW    = 0;

%   Start with PCA and keep r eigenvectors.
if ( any(isnan( Xmn(:) ) ) )
    %   Replace missing values in X with zeros
    %   in order to get a initial estimate of
    %   loadings and scores matrix.
    ind         = find(isnan(Xmn) );
    Xmn(ind)    = zeros(size(ind));
    W(ind)      = zeros(size(ind));
end

%    initial estimate of scores and loadings. 
%    A unweighted PCA is done on mean centered data.
[T,P]   =   pca(Xmn,0,[],r);
Tpca    =   T;

%   wmax = MAXIMUM weight and thus MINIMUM error variance.
wmax    =   max(W(:).^2);

%   Open temporary file used to stored intermediate results.
if ( saveopt ) 
    if ( isempty(Isave) )
        Isave = 1;
    else        
        Isave = Isave + 1;
    end        
    fid = fopen(['PCAWXtemp',sprintf('%07d',Isave),'.dat'],'w');
    fwrite(fid,n,'uint32');
    fwrite(fid,m,'uint32');
    fwrite(fid,r,'uint32');
end

%   ========= Initialize the majorization loop ============
niter       =   1;

%   SS      is current weighted sum of squares.
SS(niter)   =   ssq( (Xmn-T*P') .* W );

%   SSold   is previous weighted sum of squares, make it always
%   larger than SS to start with.
SSold       =   SS(niter) + 2;
normMAT     =   norm(T * P');

if ( saveopt )
    fwrite(fid,niter,'uint32');
    fwrite(fid,SS(niter),'double');
    fwrite(fid,T(:),'double');
    fwrite(fid,P(:),'double');
    fwrite(fid,xmean(:),'double');
end    

if ( plotopt & isempty(figNr1) )   
    figNr1 = figure('name'    ,'Convergence',...
                    'units'   ,'normalized',...
                    'position',[0.005,0.2,0.49,0.6]);
    figNr2 = figure('name'    ,'Scores',...
                    'units'   ,'normalized',...
                    'position',[0.5,0.2,0.49,0.6]);
    set(figNr1,'keypressfcn','global StopPCAW;StopPCAW=1');
    set(figNr2,'keypressfcn','global StopPCAW;StopPCAW=1');
    Tprev = Tpca;
    
end        
%  ================================================================= 
%   Loop while next condition are all satisfied:
%   1.   relative change in SS is larger than convergence crniterium.
%   2    SS is larger convg * norm of reconstructed X matrix.
%   3.   number of niterations does not exceed maxniter
%   4.   User did not signal to stop niterations.
%   ================================================================
Temp        = zeros(29,10);
TempOne     = ones(29,1);
DesignMat   = [];
for ( i = 1:10 )
    Temp1 = Temp;
    Temp1(:,i) = TempOne;
    DesignMat = [DesignMat;Temp1];
end
Xor     = Xmn + DesignMat * xmean;

while  ( abs(SSold - SS(niter))/SSold > convg & ...
         SS(niter)   > convg * normMAT        & ...
         niter <=maxniter                      & ...
         ~StopPCAW                     )
         
    RelErr  = abs(SSold - SS(niter))/SSold;            
    SSold   =   SS(niter);    
    
    %   Majorization step
    F       =   (W.^2) .* (Xmn - T * P' ) /wmax + T * P';    
    [T,P]   =   pca(F,0,[],r);
    Xup     =   Xor - T * P';
    
    %  Find better estimate of mean.
    if ( rem(niter,2) == 0 )
        F       =  (W.^2) .* (Xup - DesignMat * xmean ) /wmax + DesignMat * xmean;    
        xmean   = inv(DesignMat' * DesignMat) * DesignMat' * F;
        Xmn     = Xor -  DesignMat * xmean;  
    end        
        
    %   Now new T,P and m are found, update crniterion
    niter       = niter + 1;
    SS(niter)   = ssq( (Xmn - T * P') .* W );
    normMAT     = norm(T * P');

    %   Save results in a temporary file every 5 niterations.
    if ( saveopt )   
        fwrite(fid,niter,'uint32');
        fwrite(fid,SS(niter),'double');
        fwrite(fid,T(:),'double');
        fwrite(fid,P(:),'double');
        fwrite(fid,xmean(:),'double');
    end

    if ( plotopt)
    
        figure(figNr1)
        if ( niter > 30 )
            range = niter-29:niter; 
            semilogy(range(1:end-1),abs(diff(SS(range)))./SS(niter-29:niter-1),'r.-')
            axis([niter-29,niter,1e-6,1])
        else
            semilogy(abs(diff(SS))./SS(1:niter-1),'r.-')
            axis([1,niter,convg/10,1])
        end     
        hold on
        hline(convg,'b-');
        title('Convergence crniterion')

        figure(figNr2)
        Tcur = T;
        
        if ( mod(niter,30) )
            hold off
        end
        %   PCAW-scores are made similer to original PCA-scores 
        %   by means of Procrustes Rotation.
        Tcurr = compscores(Tcur,Tpca);
        plot(Tcurr(:,1),Tcurr(:,2),'bo')
        text(Tcurr(:,1),Tcurr(:,2),num2str([1:size(Tcurr,1)]'));
        hold on
        plot(Tpca(:,1),Tpca(:,2),'r.')
        
        scln_1 = [Tcurr(:,1),Tpca(:,1),NaN*ones(size(Tcurr,1),1)]';
        scln_2 = [Tcurr(:,2),Tpca(:,2),NaN*ones(size(Tcurr,1),1)]';
        plot(scln_1(:),scln_2(:),'g-')
            
        Tprev = Tcur;        
        drawnow
        
    end
end

if ( saveopt )
    fclose(fid);
end    
TELLER              = (norm(((Xmn-T*P').*W),'fro')).^2;
NOEMER              = (norm((Xmn .* W),'fro')).^2;
expl                = (1-(TELLER/NOEMER))*100;
return


%----------------------------------------------------------------------
%   Additional Functions

function t = ssq(a)
    %SSQ    SSQ(A) is the sum of squares of the elements of matrix A.
    t = sum(sum(a.^2));
return

function [sc1,sc2,Rot] = compscores(scores1,scores2)
%   [sc1,sc2,Rot] = compscores(scores1,scores2);
%
%   Purpose:
%   Compares scores of two (PCA) models.
%
%   Input
%   scores1     -   (Nobject * Nload1) matrix
%                   Scores on first model.
%                   Nobject = number of objects. 
%                   Nload1  = number of loading vectors
%                   in the model
%                   These scores are rotated.
%
%   scores2     -   (Nobject * Nload2) matrix
%                   Nobject = number of objects. 
%                   Nload2  = number of loading vectors
%                   in the model.
%   Description:
%   Massart part B, page 313

if ( size(scores1,1) ~= size(scores2,1) ) 
    error('Number of objects should be the same');
end

[u,s,v] = svd(scores2'*scores1);

Rot = v * u';

sc1 =  scores1 * Rot;
sc2 = scores2;
return