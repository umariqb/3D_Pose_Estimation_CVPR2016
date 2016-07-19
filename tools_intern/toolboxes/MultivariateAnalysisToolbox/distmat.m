function d = distmat(targ, ref)

% DISTMAT calculates distance matrix.
% ----------------------
% d = distmat(targ, ref)
% ----------------------
% Description: calculates the distance matrix between a two sets of
%              vectors.
% Input:       {targ} is the array of ({no_targ}) target vectors arranged
%                 columnwise.
%              <{ref}> is the array of {no_ref} reference vectors arranged
%                 columnwise. If absent, the target vectors are assumed to
%                 be the same as the reference vectors.
% Output:      {d} the Euclidean distance matrix of dimensions
%                 {no_targ}-by-{no_ref} such that {d(i,j)} is the distance
%                 between the i'th target vector to the j'th reference
%                 vector.

% © Liran Carmel
% Classification: Pairwise Relationships
% Last revision date: 21-Jan-2004

% low-level input parsing
error(nargchk(1,2,nargin));
if nargin == 1
   ref = targ;
end
[dim no_targ] = size(targ);
[dim1 no_ref] = size(ref);
if dim ~= dim1
   error('target vectors do not have the same dimensions as reference vectors')
end

% calculate Euclidean distnace
targ_size = diag(targ' * targ) * ones(1,no_ref);
    % {no_targ}-by-{no_ref} matrix of identical columns. The i'th entry of
    % a column is the squared length of the i'th target vector.
ref_size = ones(no_targ,1) * diag(ref' * ref)';
    % {no_targ}-by-{no_ref} matrix of identical rows. The j'th entry of a
    % row is the squared length of the j'th reference vector.
d = sqrt( ref_size + targ_size - 2*targ'*ref );
    % Following the equation d_{ij}^2 = || t_i ||^2 + || r_j ||^2 - 2 t_i^T r_j 