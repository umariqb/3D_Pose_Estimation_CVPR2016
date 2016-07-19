function [X,Y,Z] = coordsCappedCylinder(p1, p2, epsilon, nsteps, varargin)
% [X,Y,Z] = coordsCappedCylinder(p1, p2, epsilon, nsteps, use_caps)
%
% creates the coordinates of half-sphere-capped cylinder around line segment p1p2 in 3-space, of radius epsilon.
% p1...... point 2 defining line segment, must be 3 x 1
% p2...... point 2 defining line segment, must be 3 x 1
% epsilon. scalar
% nsteps.. integer, specifies number of vertices at circular cylinder circumference and number of longitude lines around caps
% use_caps boolean 2-vector indicating whether caps at p1 and p2 are to be included or not
% X,Y and Z are vectors. length: cylinder contributes 2*nsteps entries, each cap contributes (ceil(nsteps/2)-1)*nsteps+1 entries

use_caps = [true true];
if (nargin>4)
    use_caps = varargin{1};
end

n = (p2-p1)/norm(p2-p1);
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
n = P * n; % don't forget to change the representation of our normal!

R = zeros(d,d);
R(:,1) = n; % "basis vector e_1 will map to n"; replace e_1 (the former e_i) by n.

R(2:d,2:d) = eye(d-1);
R = gramschmidt(R); % R now contains an orthonormal basis where the first basis vector is n.
R = R * P; % permute back: R now contains an orthonormal basis where the ith basis vector is n.

t = [0:(2*pi)/nsteps:2*pi-(1/nsteps)];
M = [zeros(1,nsteps); epsilon*cos(t); epsilon*sin(t)];
M1 = R * M + repmat(p1,1,nsteps);
M2 = R * M + repmat(p2,1,nsteps);

X = M1(1,:)';
Y = M1(2,:)';
Z = M1(3,:)';

nlatitude = ceil(nsteps/2);
C = zeros(3,(nlatitude-1)*nsteps);
% create half sphere with nlatitude latitude and nsteps longitude lines
k=1;
for alpha=(pi/2)/nlatitude:(pi/2)/nlatitude:pi/2-(pi/2)/nlatitude
    radius = epsilon * cos(alpha);
    h = epsilon * sin(alpha);
    C(:,(k-1)*nsteps+1:k*nsteps) = [h*ones(1,nsteps); radius*cos(t); radius*sin(t)];
    k=k+1;
end

v = (p2-p1)/norm(p2-p1);
if (use_caps(1))
    Cflip(1,:) = -C(1,:);
    Cflip(2:3,:) = C(2:3,:);
    C1 = R * Cflip + repmat(p1,1,(nlatitude-1)*nsteps);
    X = [X; C1(1,:)'; p1(1)-v(1)*epsilon];
    Y = [Y; C1(2,:)'; p1(2)-v(2)*epsilon];
    Z = [Z; C1(3,:)'; p1(3)-v(3)*epsilon];
else
    Cflat = C;
    Cflat(1,:) = zeros(1,size(C,2));
    C1 = R * Cflat + repmat(p1,1,(nlatitude-1)*nsteps);
    X = [X; C1(1,:)'; p1(1)];
    Y = [Y; C1(2,:)'; p1(2)];
    Z = [Z; C1(3,:)'; p1(3)];
end

X = [X; M2(1,:)'];
Y = [Y; M2(2,:)'];
Z = [Z; M2(3,:)'];
if (use_caps(2))
    C2 = R * C + repmat(p2,1,(nlatitude-1)*nsteps);
    X = [X; C2(1,:)'; p2(1)+v(1)*epsilon];
    Y = [Y; C2(2,:)'; p2(2)+v(2)*epsilon];
    Z = [Z; C2(3,:)'; p2(3)+v(3)*epsilon];
else
    Cflat = C;
    Cflat(1,:) = zeros(1,size(C,2));
    C2 = R * Cflat + repmat(p2,1,(nlatitude-1)*nsteps);
    X = [X; C2(1,:)'; p2(1)];
    Y = [Y; C2(2,:)'; p2(2)];
    Z = [Z; C2(3,:)'; p2(3)];
end