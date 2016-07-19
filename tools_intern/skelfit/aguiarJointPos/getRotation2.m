function [A, t] = getRotation2( points1, points2)

centerOfGravity1 = mean(points1,2);
centerOfGravity2 = mean(points2,2);

points1centered = points1 - repmat(centerOfGravity1, 1, size(points1,2));
points2centered = points2 - repmat(centerOfGravity2, 1, size(points2,2));

[A(:,1), flag] = lsqr(points1centered', points2centered(1,:)');
[A(:,2), flag] = lsqr(points1centered', points2centered(2,:)');
[A(:,3), flag] = lsqr(points1centered', points2centered(3,:)');

A = A';