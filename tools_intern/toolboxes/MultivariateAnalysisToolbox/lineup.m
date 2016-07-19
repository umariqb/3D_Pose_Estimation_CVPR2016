function Aranked = lineup(A,direc)

% LINEUP ranks a vector in increasing order.
% --------------------------
% Aranked = lineup(A, direc)
% --------------------------
% Description: Let {A} be a vector of length {n}. Then, {Aranked} is a
%              vector of the integers 1,...,n such that {Aranked(i)} is the
%              position of A(i) in B, if we have sorted it in increasing
%              order. For example, [3 2 1] = lineup([21 15 10]). By
%              conventions, tied values are all given the same rank, called
%              midrank, which is the average they would have had if their
%              values had been distinct. For example [2.5 1 4 2.5] =
%              lineup([20 11 35 20])
% Input:       {A} any numeric array. If {A} has more than one-dimension
%                   (i.e., a matrix, 3-array, etc.), it is ranked along one
%                   of its directions, see {direc}.
%              <{direc}> the direction along which we rank (def = first
%                   nontrivial direction).
% Output:      {Aranked} ranked indices of {A}.

% © Liran Carmel
% Classification: Data manipulations
% Last revision date: 29-Sep-2004

% low-level input parsing
error(nargchk(1,2,nargin));
if nargin == 1
    direc = find((size(A)-1) ~= 0);
    direc = direc(1);
end

% We are not intersted in ties that are resolved due to numerical roundoff
% error. Therefore, a threshold is used
THRESH = 1e-8;

% rearrange data dimensions such that the dimension {direc} is the first
% and the entire data is two-dimensional
A = shiftdim(A,direc-1);
sz = size(A); szp = sz; szp(1) = [];
A = reshape(A,sz(1),prod(szp));

% sort {A} according to requested direction
[A sidx] = sort(A,1);
[idx Aranked] = sort(sidx,1);   %#ok

% take differences to find ties and work column by column
df = diff(A);
for col = 1:size(A,2)
    vec = df(:,col);
    % calculate ties
    ties = find(vec<THRESH);
    while ~isempty(ties)
        idx_beg = ties(1);
        idx_fin = ties(1) + 1;
        ties(1) = [];
        while ~isempty(ties) && (ties(1) == idx_fin)
            idx_fin = idx_fin + 1;
            ties(1) = [];
        end
        Aranked(sidx(idx_beg:idx_fin,col),col) = ...
            0.5*(Aranked(sidx(idx_beg,col),col) + ...
            Aranked(sidx(idx_fin,col),col));
    end
end

% rearrange the dimensions back
Aranked = reshape(Aranked,sz);
Aranked = shiftdim(Aranked,length(sz)-direc+1);