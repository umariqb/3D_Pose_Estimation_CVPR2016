function I = emutualentropy(vr,alphabet)

% EMUTUALENTROPY estimates pairwise mutual entropy
% --------------------------------
% I = emutualentropy(vr, alphabet)
% --------------------------------
% Description: computes mutual entropy for all pairs of variables.
% Input:       {vr} an array of VARIABLE objects.
%              {alphabet} a vector of alphabet upon which the variables are
%                   defined. If the alphabet is different for different
%                   variables, this should be a cell with the alphabet
%                   determined separately for each variable.
% Output:      {I} matrix of pairwise mutual entropies.

% © Liran Carmel
% Last revision date: 09-Jan-2008

% use the generic EMUTUALENTROPY
I = emutualentropy(vr(:,:),alphabet);