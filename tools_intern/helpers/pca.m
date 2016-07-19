function [signals,PC,V] = pca(data)
[M,N] = size(data);
% M = num dimensions
% N = num data points

mn = mean(data,2);
data = data - repmat(mn,1,N);

Y = data / sqrt(N-1);

[u,S,PC] = svd(Y*Y');

S = diag(S);
V = S .* S;

signals = PC' * data;