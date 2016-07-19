function [Dist,D,k,w,d]=dtw(varargin)
%Dynamic Time Warping Algorithm
%Dist is unnormalized distance between t1 and r1
%D    is the accumulated distance matrix (GDM)
%k    is the normalizing factor
%w    is the optimal path
%d    is the local distance matrix (LDM)
%t1   is the vector you are testing against
%r1   is the vector you are testing


switch nargin
    case 1
        d = varargin{1};
        N = size(d,1);
        M = size(d,2);
    case 2
        %Transpose the given Matrices
        t1 = varargin{1}';
        r1 = varargin{2}';


        [rows,N] = size(t1);
        [rows,M] = size(r1);

        d = zeros(N,M);
        %Calculation of the LDM:
        for m=1:M
            for n=1:N
                %This calculates the distance per frame only for a 1-dim signal:
                %d(n,m)=eukl_dist1d(t1(n),r1(m));
                %You should replace this by your own distance measure for n-dim signals:
                d(n,m)=highDimDistance(t1(:,n),r1(:,m));
        %           d(n,m)=winDist(t1(:,n-9:n+9),r1(:,m-9:m+9));
            end
        end

    otherwise 
        error('Wrong num of args!\n');
        
end

%Calculation of the GDM:
D=inf(size(d));
D(1,1)=d(1,1);

for n=2:N
    D(n,1)=d(n,1)+D(n-1,1);
%     D(n,2)=d(n,2)+D(n-1,2);
end
for m=2:M
    D(1,m)=d(1,m)+D(1,m-1);
%     D(2,m)=d(2,m)+D(2,m-1);
end
for n=2:N
    for m=2:M 
        D(n,m)=d(n,m)+min([D(n-1,m-1),D(n-1,m),D(n,m-1)]);
%         D(n,m)=d(n,m)+min([D(n-1,m-2),D(n-1,m-1),D(n-2,m-1)]);
    end
end

%Search of the optimal path on the given matrix:
Dist=D(N,M);
n=N;
m=M;
k=1;
w=[];
w(1,:)=[N,M];
while ((n+m)~=2)
    if (n-1)==0
        m=m-1;
    elseif (m-1)==0
        n=n-1;
    else 
      [values,number]=min([D(n-1,m-1),D(n-1,m),D(n,m-1)]);
      switch number
      case 2
        n=n-1;
      case 3
        m=m-1;
      case 1
        n=n-1;
        m=m-1;
      end
    end
    k=k+1;
    w=cat(1,w,[n,m]);
end

%End of DTW Algorithm


% Euclidian distance measure
function [distance]=eukl_dist1d(a1,b1)
    distance=abs((a1-b1));
    
% Add your function for the distance measurement here:
function [distance]=highDimDistance(a1,b1)
%     sum=0;
    tmp=a1-b1;
    distance=sqrt(sum(tmp.^2));
    %Berechnung des n-Dim. euklidischen Abstandes

   
function [dist]=dotDist(a,b)
        dist=1-dot(a/sqrt(sum(a.*a)),b/sqrt(sum(b.*b)));
        
function [dist]=winDist(a,b)
        a=sum(a,2);
        b=sum(b,2);
        dist=1-dot(a/sqrt(sum(a.*a)),b/sqrt(sum(b.*b)));