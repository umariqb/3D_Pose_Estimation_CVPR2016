function [d,theta,x0,z0,xPc,zPc,xQc,zQc] = pointCloudDistance(Ptraj,Qtraj,n,m,rho,theta,x0,z0)

N = size(Ptraj{1},2);
M = size(Qtraj{1},2);
njoints = length(Ptraj);

K = njoints*(2*rho+1);
P = zeros(3,K);
Q = zeros(3,K);

out = 1;
if (n<=rho) % check if pre-padding is necessary
    d_pre = rho - n + 1;
    s = 1; 
    e = n + rho;
elseif (n>=N-rho+1) % check if post-padding is necessary
    d_post = rho - (N - n);
    s = n - rho;
    e = N;
else % no padding necessary
    s = n - rho;
    e = n + rho;
end
for j=1:njoints
    if (n<=rho) % pre-pad
        P(:,out:out+d_pre-1) = repmat(Ptraj{j}(:,1),1,d_pre);
        out = out+d_pre;
    end
    
    % copy without padding
    P(:,out:out+e-s) = Ptraj{j}(:,s:e);
    out = out+e-s+1;
    
    if (n>=N-rho+1) % post-pad
        P(:,out:out+d_post-1) = repmat(Ptraj{j}(:,end),1,d_post);
        out = out+d_post;
    end
end

out = 1;
if (m<=rho) % check if pre-padding is necessary
    d_pre = rho - m + 1;
    s = 1; 
    e = m + rho;
elseif (m>=M-rho+1) % check if post-padding is necessary
    d_post = rho - (M - m);
    s = m - rho;
    e = M;
else % no padding necessary
    s = m - rho;
    e = m + rho;
end
for j=1:njoints
    if (m<=rho) % pre-pad
        Q(:,out:out+d_pre-1) = repmat(Qtraj{j}(:,1),1,d_pre);
        out = out+d_pre;
    end
    
    % copy without padding
    Q(:,out:out+e-s) = Qtraj{j}(:,s:e);
    out = out+e-s+1;
    
    if (m>=M-rho+1) % post-pad
        Q(:,out:out+d_post-1) = repmat(Qtraj{j}(:,end),1,d_post);
        out = out+d_post;
    end
end


if (nargin<8) % determine procrustes fit
    [theta_proc,x0_proc,z0,xPc,zPc,xQc,zQc] = procrustes2D(P,Q);
end
if (nargin < 7) % x0 has NOT been specified by the user
    x0 = x0_proc;
end
if (nargin < 6) % theta has NOT been specified by the user
    theta = theta_proc;
end

if (n==5 && m==12)
    disp('');
end
d = (1/K)*norm(P - (rotmatrix(theta,'y')*Q + repmat([x0;0;z0],1,K)),'fro');