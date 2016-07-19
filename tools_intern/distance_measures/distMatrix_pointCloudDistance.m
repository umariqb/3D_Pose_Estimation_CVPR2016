function [C,theta,x0,z0,xt,zt] = distMatrix_pointCloudDistance(Ptraj,Qtraj,downsampling_fac,rho,varargin)

symmetrize = true;
if (nargin>4)
    symmetrize = varargin{1};
end

N = size(Ptraj{1},2);
M = size(Qtraj{1},2);
N_ds = ceil(N/downsampling_fac);
M_ds = ceil(M/downsampling_fac);

C = zeros(N_ds,M_ds);
theta = zeros(N_ds,M_ds);
x0 = zeros(N_ds,M_ds);
z0 = zeros(N_ds,M_ds);
xt = zeros(N_ds,M_ds);
zt = zeros(N_ds,M_ds);

fprintf('Computing point cloud cost matrix (%5i rows): %5i',N_ds,0);
if (symmetrize)
    for n=1:downsampling_fac:N
        if (mod(ceil(n/downsampling_fac),10)==0) fprintf('\b\b\b\b\b');fprintf('%5i',ceil(n/downsampling_fac)); end;    
        for m=n:downsampling_fac:M
            n_ds = ceil(n/downsampling_fac);
            m_ds = ceil(m/downsampling_fac);
            [C(n_ds,m_ds),theta(n_ds,m_ds),x0(n_ds,m_ds),z0(n_ds,m_ds)] = pointCloudDistance(Ptraj,Qtraj,n,m,rho);
            C(m_ds,n_ds) = C(n_ds,m_ds);
%            theta(m_ds,n_ds) = -theta(n_ds,m_ds);
%            x0(m_ds,n_ds) = - (x0(n_ds,m_ds)*cos(theta(n_ds,m_ds)) - z0(n_ds,m_ds)*sin(theta(n_ds,m_ds)));
%            z0(m_ds,n_ds) = - (x0(n_ds,m_ds)*sin(theta(n_ds,m_ds)) + z0(n_ds,m_ds)*cos(theta(n_ds,m_ds)));
        end
    end
else
    for n=1:downsampling_fac:N
        if (mod(ceil(n/downsampling_fac),10)==0) fprintf('\b\b\b\b\b');fprintf('%5i',ceil(n/downsampling_fac)); end;    
        for m=1:downsampling_fac:M
            n_ds = ceil(n/downsampling_fac);
            m_ds = ceil(m/downsampling_fac);
            [C(n_ds,m_ds),theta(n_ds,m_ds),x0(n_ds,m_ds),z0(n_ds,m_ds),xPc,zPc,xQc,zQc] = pointCloudDistance(Ptraj,Qtraj,n,m,rho);
            xt(n_ds,m_ds) = xQc - xPc;
            zt(n_ds,m_ds) = zQc - zPc;
        end
    end
end
fprintf('\n');
