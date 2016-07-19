function P = quatnormalize(Q)
% input:    Q is a 4xn array of quaternions represented as column vectors
% output:   P(:,i) is a unit quaternion in the direction of Q(:,i), 

if (size(Q,1)~=4)
    error('Input array: number of rows must be 4!');
end

nsq = sqrt(sum(Q.^2));

if nsq ~= 0
    P(1,:)=Q(1,:)./nsq;
    P(2,:)=Q(2,:)./nsq;
    P(3,:)=Q(3,:)./nsq;
    P(4,:)=Q(4,:)./nsq;
else
    P=[ones(1,size(Q,2));zeros(3,size(Q,2))];
end

% nsq = sum(Q.^2);
% P = Q./repmat(sqrt(nsq),4,1);