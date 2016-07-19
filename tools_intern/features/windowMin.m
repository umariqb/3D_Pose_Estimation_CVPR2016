function out = windowMin(in,winlen)

n = length(in);
if (winlen > n)
    out = in;
    return;
end

M = inf*ones(winlen,n+winlen-1);
for k = 1:winlen
    M(k,k:k+n-1) = in;
end
out = min(M);

s = floor(winlen/2);
out = out(s+1:s+n);