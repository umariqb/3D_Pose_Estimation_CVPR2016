function [q,Q] = sphericalAverage_incremental_approx(P,varargin)

w = 1/(size(P,2))*ones(1,size(P,2));
if (nargin>1)
    w = varargin{1};
end

if (size(P,1)~=4)
    error('P must be a 4xn array!');
end
n = size(P,2);
if (size(w,1)~=1)
    error('Weights must be a row vector!');
end
if (size(w,2)~=n)
    error('#quaternions = #weights required!');
end
if (abs(sum(w)-1)>1000*eps)
    error('Sum of weights must be 1!');
end

Q = zeros(4,n);
Q(:,1) = P(:,1);

w_sum = w(1);
for i = 2:n
    w_sum = w_sum+w(i);
    v = w(i)/w_sum;    
    Q(:,i) = quatmult(Q(:,i-1),quatexp((1-v)*quatlog(quatmult(quatinv(Q(:,i-1)),P(:,i)))));
    %Q(:,i) = quatexp((1-v)*quatlog(Q(:,i-1)) + v*quatlog(P(:,i)));
end

q = Q(:,n);