function [C,theta,x0,z0,xt,zt] = distMatrix_pointCloudDistance_jt(Ptraj,Qtraj,rho)

N = size(Ptraj{1},2);
M = size(Qtraj{1},2);

C = zeros(N,M);
theta = zeros(N,M);
x0 = zeros(N,M);
z0 = zeros(N,M);
xt = zeros(N,M);
zt = zeros(N,M);

fprintf('Computing point cloud cost matrix (%5i rows): %5i',N,0);

for n=1:N
    if (mod(n,10)==0) 
        fprintf('\b\b\b\b\b');
        fprintf('%5i',n); 
    end
    for m=1:M
        [C(n,m),theta(n,m),x0(n,m),z0(n,m),xPc,zPc,xQc,zQc] = pointCloudDistance(Ptraj,Qtraj,n,m,rho);
        xt(n,m) = xQc - xPc;
        zt(n,m) = zQc - zPc;
    end
end

fprintf('\n');
