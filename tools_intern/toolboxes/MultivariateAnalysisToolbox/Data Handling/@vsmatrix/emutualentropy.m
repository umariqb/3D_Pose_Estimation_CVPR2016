function I = emutualentropy(vsm,alphabet)

% EMUTUALENTROPY estimates pairwise mutual entropy
% ---------------------------------
% I = emutualentropy(vsm, alphabet)
% ---------------------------------
% Description: computes mutual entropy for all pairs of variables.
% Input:       {vsm} an instance of VSMATRIX.
%              {alphabet} a vector of alphabet upon which the variables are
%                   defined. If the alphabet is different for different
%                   variables, this should be a cell with the alphabet
%                   determined separately for each variable.
% Output:      {I} matrix of pairwise mutual entropies.

% © Liran Carmel
% Last revision date: 28-Nov-2007

% use the generic EMUTUALENTROPY
I = emutualentropy(matrix(vsm),alphabet);