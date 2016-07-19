function A = randorder(A)

% RANDORDER randomly permutes the elements of any array.
% ----------------
% A = randorder(A)
% ----------------
% Description: randomly permutes the elements of any array.
% Input:       {A} any array.
% Output:      {A} reordered array.

% © Liran Carmel
% Classification: Random numbers
% Last revision date: 14-Mar-2006

A = A(randperm(numel(A)));