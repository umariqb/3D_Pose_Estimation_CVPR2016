function b = balance(dg)

% BALANCE computes the balance vector of a digraph.
% ---------------
% b = balance(dg)
% ---------------
% Description: computes the balance vector of a digraph.
% Input:       {dg} instance of the DIGRAPH class.
% Output:      {b} balance vector.

% © Liran Carmel
% Classification: Computations
% Last revision date: 02-Sep-2004

% parse input
error(chkvar(dg,{},'scalar',{mfilename,inputname(1),1}));

% compute the balance
b = - diag(get(dg,'weights') * dg.delta);