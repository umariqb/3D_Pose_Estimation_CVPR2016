function [X,Y,Z] = coordsGridDiscNormal(n, x0, radius, nlongitude, nlatitude, offset)
% [X,Y,Z] = coordsGridDiscNormal(n, x0, radius, nlongitude, offset)
%
% creates the coordinates of nlongitude equally spaced concentric regular nlongitude-gons in 3-space within a plane specified by n and x0, max radius "radius"
% n....... normal vector, must be 3 x 1
% x0...... fixture point, must be 3 x 1
% radius.. scalar
% nlongitude.. integer, specifies number of vertices per concentric nstep-gon
% offset.. constant offset to x0, 3 x 1. Will be projected onto plane.
% X,Y and Z are vectors of length nlongitude

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

t = [0:(2*pi)/nlongitude:2*pi-(1/nlongitude)];
C = zeros(3,nlatitude*nlongitude);
% create concentric circles with nlatitude latitude and nlongitude longitude lines
k=1;
for r = radius:-radius/nlatitude:radius/nlatitude
    C(:,(k-1)*nlongitude+1:k*nlongitude) = [zeros(1,nlongitude); r*cos(t); r*sin(t)];
    k=k+1;
end

midpoint = x0+offset_proj;
C = R * C + repmat(midpoint,1,nlatitude*nlongitude);
X = [C(1,:)'; midpoint(1)];
Y = [C(2,:)'; midpoint(2)];
Z = [C(3,:)'; midpoint(3)];