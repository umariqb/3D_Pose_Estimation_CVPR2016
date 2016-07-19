function y = proj2hyperplane(n,c,x)
dim = size(x,1);

i = find(n); % find first nonzero component of n
if (size(i) == 0)
    return;
end;
i = i(1);

B = zeros(dim,dim);
B(1:dim,1) = n;

E = eye(dim);
B(:,2:dim) = [E(:,1:i-1) E(:,i+1:dim)]; 
B = gramschmidt(B);
x = B * x; % change of basis such that n = e1

% projection of x onto (affine) plane defined by n
y = x(setdiff([1:dim],i),:);
