function C = distMatrix_QuaternionDistance(P,Q,downsampling_fac,varargin)

njoints = size(P,1)/4;
N = size(P,2);
M = size(Q,2);
N_ds = ceil(N/downsampling_fac);
M_ds = ceil(M/downsampling_fac);

w = ones(1,njoints)/njoints;
dist_measure = 'cosine';
if (nargin>4)
    w = varargin{2};
end
if (nargin>3)
    dist_measure = varargin{1};
end

C = zeros(N_ds,M_ds);

fprintf('Computing quaternion cost matrix (%5i joints): %5i',njoints,0);
for k=1:njoints
    fprintf('\b\b\b\b\b');fprintf('%5i',k);
    if (w(k)<=0)
        continue;
    end
    ip = P(4*(k-1)+1:4*k,1:downsampling_fac:end)'*Q(4*(k-1)+1:4*k,1:downsampling_fac:end);
    switch (lower(dist_measure))
        case 'geodesic'
            C = C + real(w(k)*(2/pi*acos(abs(ip)))); % real() because acos() might yield epsilon imaginary parts due to numerical errors
        case 'cosine'
            C = C + w(k)*(1 - abs(ip));
    end
end
fprintf('\n');
