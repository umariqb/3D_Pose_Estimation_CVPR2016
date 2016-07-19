function [C,theta,x0,z0,xt,zt] = distVector_pointCloudDistance(Ptraj,Qtraj,rho)

N = size(Ptraj{1},2);
M = size(Qtraj{1},2);

if M~=N
    disp('Dimensions error.');
else
    %fprintf('Computing point cloud cost matrix (%5i rows): %5i',N,0);
    for n=1:N
%         if (mod(n,10)==0) fprintf('\b\b\b\b\b');
%             fprintf('%5i',n); 
%         end;    
        [C(n),theta(n),x0(n),z0(n),xPc,zPc,xQc,zQc] = pointCloudDistance(Ptraj,Qtraj,n,n,rho);
        xt(n) = xQc - xPc;
        zt(n) = zQc - zPc;
    end
%     fprintf('\n');
end
