function B = gramschmidt(A)
n = size(A,1);
if (size(A,2) ~= n)
    return;
end;
B = zeros(n,n);

B(:,1) = (1/norm(A(:,1)))*A(:,1);

for i=2:n
    v = A(:,i);
    U = B(:,1:i-1); % subspace basis which has already been orthonormalized
    pc = transpose(U)*v; % orthogonal projection coefficients of v onto U
    p = U * pc; % orthogonal projection vector of v onto U
    v = v - p;
    if (norm(v)<eps) % vectors are not linearly independent!
        return;
    end;
    v = v/norm(v);
    B(:,i) = v;
end;