function P = quatnormsq(Q)
% input:    Q is a 4xn array of quaternions represented as column vectors
% output:   P(i) is the squared magnitude of the quaternion Q(:,i), 

if (size(Q,1)~=4)
    error('Input array: number of rows must be 4!');
end

P = sum(Q.^2);