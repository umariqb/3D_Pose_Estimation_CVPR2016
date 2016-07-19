function res = PermsRep(v,k)
%  PERMSREP Permutations with replacement.
%  
%  PermsRep(v, k) lists all possible ways to permute k elements out of 
%  the vector v, with replacement.

if nargin<1 || isempty(v)    
    error('v must be non-empty')
else
    n = length(v);
end
 
if nargin<2 || isempty(k)
    k = n;
end

v = v(:).'; %Ensure v is a row vector
for i = k:-1:1
    tmp = repmat(v,n^(k-i),n^(i-1));
    res(:,i) = tmp(:);
end



