function P = quatmult(Q1, Q2)
% input:    Q1, Q2 are 4xn arrays of quaternions represented as column vectors
% output:   P(:,i) is the quaternion product of Q1(:,i) and Q2(:,i)

if (size(Q1,1)~=4 || size(Q2,1)~=4 || (size(Q1,2) ~= size(Q2,2)))
    error('Input arrays: wrong dimensions.');
end

w1 = Q1(1,:); w2 = Q2(1,:);
x1 = Q1(2,:); x2 = Q2(2,:);
y1 = Q1(3,:); y2 = Q2(3,:);
z1 = Q1(4,:); z2 = Q2(4,:);

P = [w1.*w2 - x1.*x2 - y1.*y2 - z1.*z2;
     w1.*x2 + x1.*w2 + y1.*z2 - z1.*y2;
     w1.*y2 + y1.*w2 + z1.*x2 - x1.*z2;
     w1.*z2 + z1.*w2 + x1.*y2 - y1.*x2];