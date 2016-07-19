function gr = shuffle(gr,idx)

% SHUFFLE reorders the assignment vector(s).
% ---------------------
% gr = shuffle(gr, idx)
% ---------------------
% Description: reorders the assignment vector(s).
% Input:       {gr} a grouping instance(s).
%              {idx} new sample order.
% Output:      {gr} suffled grouping instance(s).

% © Liran Carmel
% Classification: Transformations
% Last revision date: 04-Jul-2004

% parse input line
error(nargchk(2,2,nargin));

% shuffle the assignemnts
for ii = 1:length(gr)
    gr(ii).assignment = gr(ii).assignment(:,idx);
end