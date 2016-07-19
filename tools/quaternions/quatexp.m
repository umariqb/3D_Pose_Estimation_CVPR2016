function Q = quatexp(V)
% Q = quatexp(V)
% Quaternionic exponential without (Grassia's) scaling factor of 0.5 in the
% argument
%
% input:    V is a 3xn array of 3-vectors
% output:   Q(:,i) is the quaternionic exponential of V(:,i), 

Q = quatexp_rot(2*V);