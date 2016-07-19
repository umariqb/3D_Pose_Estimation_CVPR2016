function [X,Y,Z] = coordsDiscNormal(n, x0, radius, nsteps, offset)
% [X,Y,Z] = coordsDiscNormal(n, x0, radius, nsteps, offset)
%
% creates the coordinates of a regular nsteps-gon in 3-space within a plane specified by n and x0
% n....... normal vector, must be 3 x 1
% x0...... fixture point, must be 3 x 1
% radius.. scalar
% nsteps.. integer, specifies number of vertices
% offset.. constant offset to x0, 3 x 1. Will be projected onto plane.
% X,Y and Z are vectors of length nsteps

d = length(n);
i = find(abs(n)>eps); % find first nonzero component of n
% a new basis {e_1,...,e_{i-1},n,e_{i+1},...,e_d},
% where e_i was replaced by n, will still span the whole space IR^d,
% since e_i appears in the expansion of n with a nonzero coefficient.
if (size(i) == 0) % in this case the normal was near zero... useless!
    return;
end;
i = i(1);

P = eye(d); % construct permutation matrix that swaps rows 1 and i
z = P(:,i);
P(:,i) = P(:,1);
P(:,1) = z;
%line([x0(1);x0(1)+n(1)],[x0(2);x0(2)+n(2)],[x0(3);x0(3)+n(3)]);

offset_proj = offset - dot(n,offset) * n;

n = P * n; % don't forget to change the representation of our normal!

R = zeros(d,d);
R(:,1) = n; % "basis vector e_1 will map to n"; replace e_1 (the former e_i) by n.

R(2:d,2:d) = eye(d-1);
R = gramschmidt(R); % R now contains an orthonormal basis where the first basis vector is n.
R = R * P; % permute back: R now contains an orthonormal basis where the ith basis vector is n.

t = [0:(2*pi)/nsteps:2*pi-(1/nsteps)];
M = [zeros(1,nsteps); radius*cos(t); radius*sin(t)];
midpoint = x0+offset_proj;
M = R * M + repmat(midpoint,1,nsteps);
X = [M(1,:)'; midpoint(1)];
Y = [M(2,:)'; midpoint(2)];
Z = [M(3,:)'; midpoint(3)];