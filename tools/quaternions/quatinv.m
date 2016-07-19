function P = quatinv(Q)
% input:    Q is a 4xn array of quaternions represented as column vectors
% output:   P(:,i) is the inverse quaternion of invertible Q(:,i), else repmat(NaN,4,1)

if (size(Q,1)~=4)
    error('Input array: number of rows must be 4!');
end

P = quatconj(Q)./repmat(quatnormsq(Q),4,1);