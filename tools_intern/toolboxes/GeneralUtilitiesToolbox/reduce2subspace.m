function [Ar, trans] = reduce2subspace(A,V,entity)

% REDUCE2SUBSPACE reduces vectors or matrices to subspace.
% ------------------------------------------
% [Ar trans] = reduce2subspace(A, V, entity)
% ------------------------------------------
% Description: Finds the representation of a vector/matrix {A} when reduced
%              to a subspace orthogonal to span(v1,v2,...,vp). The vectors
%              v1,v2,...,vp are arranged columnwise in {V}.
% Input:       {A} square matrix or columnwise assortment of vectors.
%              {V} a collection of column vectors v1,v2,...,vp.
%              {entity} either 'vector' or 'matrix'. The former is
%                   transformed {trans}'*{A}, while the latter is
%                   transformed {trans}'*{A}*{trans}.
% Output:      {Ar} the representation of {A} in the orthogonal subspace.
%              {trans} the transformation matrix for reversing the process
%                   (losing, naturally, the elements that have been
%                   projected).
% Example:     Let u=[3;5;7], and let v=[0 0;1 0;0 1]. Then
%                   [ur t] = reduce2subspace(u,v,'vector')
%              gives ur=3 and t=[1;0;0]. Now, t*ur=3. If w=[2;4;6]
%              then t'*w=2.

% © Liran Carmel
% Classification: Linear algebra
% Last revision date: 01-Feb-2005

% parameters of the problem
dim = size(A,1);
p = size(V,2);

% if p==1 solve directly, else call the function separately for each vector
if p == 0
    Ar = A;
    trans = eye(dim);
elseif p == 1
    % make {V} a unit vector
    V = unit(V);
    % build clipping matrix
    C = [zeros(1,dim-1) ; eye(dim-1)];
    % build Houslholder rotation matrix. This rotation matrix is guaranteed
    % to rotate {v} into {e_1}, and thus applying it to the entire data
    % makes their first component to be the projection along {v}.
    u = zeros(dim,1); u(1) = 1;
    u = unit(V - u);
    R = eye(dim) - 2*u*u';
    % build overall transformation matrix, including clipping
    trans = R * C;
    if strcmp(entity,'vector')      % {A} is a (series of) column vector(s)
        Ar = trans' * A;
    elseif strcmp(entity,'matrix')  % {A} is a square matrix
        Ar = trans' * A * trans;
    end
else
    trans = eye(dim);
    for ii = 1:p
        v = V(:,1); V(:,1) = [];                % take the first vector {v}
        [A T] = reduce2subspace(A,v,entity);    % reduce {A} with respect to {v}
        V = T' * V;                             % reduce {V} with respect to {v}
        trans = trans*T;
    end
    Ar = A;
end