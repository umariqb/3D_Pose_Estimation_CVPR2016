function [d]=ldm(t1,r1)
%Dynamic Time Warping Algorithm
%d    is the local distance matrix (LDM)

%Transpose the given Matrices
t1=t1';
r1=r1';

[rows,N]=size(t1);
[rows,M]=size(r1);

d=zeros(N,M);
%Calculation of the LDM:
fprintf('Row:     ');
tic;
for m=1:M
    for n=1:N
        %This calculates the distance per frame only for a 1-dim signal:
        %d(n,m)=eukl_dist1d(t1(n),r1(m));
        %You should replace this by your own distance measure for n-dim signals:
        d(n,m)=highDimDistance(t1(:,n),r1(:,m),rows);
    end
    fprintf('\b\b\b\b');
    fprintf('%4i',m);
end
time=toc;
disp(['Calculated LDM in:' num2str(time) ' seconds']);

% Euclidian distance measure
function [distance]=eukl_dist1d(a1,b1)
    distance=abs((a1-b1));
    
% Add your function for the distance measurement here:
function [distance]=highDimDistance(a1,b1,row)
    %Berechnung des n-Dim. euklidischen Abstandes
    distance=a1-b1;
    distance=distance'*distance;
%     for i=1:row
%         sum=sum+(a1(i)-b1(i))^2;
%     end
%     distance=sum;  