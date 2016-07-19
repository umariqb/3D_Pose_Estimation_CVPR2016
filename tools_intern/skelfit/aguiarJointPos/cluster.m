function [IDX, A] = cluster( mot, k )

sigma = 1;

A = zeros(mot.njoints, mot.njoints);
for i=1:(mot.njoints-1)
    for j=(i+1):mot.njoints
        d = mot.jointTrajectories{i} - mot.jointTrajectories{j};
        d = sqrt(dot(d,d));
        A(i,j) = exp( -std(d)/2/sigma/sigma );
        A(j,i) = A(i,j);
    end
end

for i=1:mot.njoints
    D(i,i) = sum(A(i,:));
end

L = D^-0.5 * A * D^-0.5;

[eigVec, eigVal] = eig(L);
[I,J] = sort(eig(L));
X = eigVec(:,J(1:k));
for i=1:size(X,1)
    Y(i,:) = X(i,:) / norm(X(i,:));
end

IDX = kmeans(Y,k);