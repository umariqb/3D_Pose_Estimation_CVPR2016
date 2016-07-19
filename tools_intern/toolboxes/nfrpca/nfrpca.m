function [scores,loads]=nfrpca(x,LV,method)
% Nonlinear fuzzy robust PCA algorithm from article:
%P. Luukka, 'A New Nonlinear Fuzzy Robust PCA Algorithm and Similarity
%classifier in classification of medical data sets', 
%International Journal of Fuzzy Systems, Vol. 13, No. 3, September 2011
%pp. 153-162.
%
%Function call: [scores,loads]=nfrpca(x,LV,method)
%
%
%INPUTS:
%1)x: your data matrix samples in rows and variables in columns
%2)LV: How many variables to use from data, if not specified all variables are used.
%3)method: which  method to use 
% 'nfrpca1' means  Nonlinear fuzzy robust PCA algorithm from article above.
%In current version only this one is implemented and will be selected
%automatically.
% 
%
%OUTPUTS:
%
%scores:    The principal component scores; that is, the representation of X in the principal component space. 
%           Rows of score correspond to observations, columns to components.
%loads:     principal component coefficients also known as loadings.


x=x';
[m,n]=size(x);
if nargin<3
   method='nfrpca1'
elseif nargin<2
   LV=min(m,n);
end

scores=[]; loads=[];
a=10;     % parameter value in function y=tanh(a*x)
ALFA0=1; % learning coefficient (0,1]
ETA=.1;  % soft threshold, a small positive number
EXPO=1.5;  % fuzziness variable

if strcmpi(method,'nfrpca1')==1
   for lv=1:LV   
      alfa0=ALFA0; % learning coefficient (0,1]
      eta=ETA;  % soft threshold, a small positive number
      expo=EXPO;  % fuzziness variable
      t=1;     % iteration count
      T=100;   % iteration bound
      [tt,s,pp] = svds(x',1); w=pp; % initialize loadings
      %w=rand(m,1); % initialize loadings
      wold=5*ones(size(w));
      crit=sum((w-wold).^2);
      while t<T % do not add '=' sign
         alfat=alfa0*(1-t/T);
         sigma=0; i=1;
         wold=w;
         while i<=n
            y=w'*x(:,i); 
            g=tanh(a*y);           %Now implemented for function tanh(ax)
            gder=a/cosh(a*y)^2;      %Derivative of the function
            e3x=(x(:,i)-g*w)'*(x(:,i)-g*w);
            beta=(1/(1+(e3x)/eta)^(1/(expo-1)))^expo;
            apu1=x(:,i)-w*g;
            F=gder;
            w=w+alfat*beta*(x(:,i)*apu1'*w*F+apu1*g);
            w=w/norm(w);
            sigma=sigma+e3x;
            i=i+1;
         end
         eta=sigma/n;
         t=t+1;
         crit=[crit,sum((w-wold).^2)/m];
         if sum((w-wold).^2)/m<1e-8
            break
         end
      end
      scores=[scores x'*w];
      loads=[loads w];
      x=x';
      x=x-x*w*w';
      x=x';
   end
end

function Y=meanw(X,W)
% MEANW : Weighted Mean
%
% Y=meanw(X,W)
% 
% Y is the mean of X weighted by W.
%
if(size(X)~=size(W)), error('Must be 1:1 corrospondence between weights and samples'); end;
Y = sum(W.*X)./sum(W);

function Y=stdw(X,W)
% STDW : Weighted Standard Deviation
%
% Y=stdw(X,W)
% 
% Y is the standard deviation of X weighted by W.
%
if(size(X)~=size(W)), error('Must be 1:1 corrospondence between weights and samples'); end;
Y = sqrt( (sum(W.*X.*X)./sum(W)) - (sum(W.*X)./sum(W)).^2);


