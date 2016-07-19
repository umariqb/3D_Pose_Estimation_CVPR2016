function [h, h_rel] = entropy(gr,h_level)

% ENTROPY entropy of the grouping.
% --------------------------------
% [h h_rel] = entropy(gr, h_level)
% --------------------------------
% Description: entropy of the grouping, considering the observed frequency
%              of a group as its probability.
% Input:       {gr} group instance.
%              <{h_level}> which hierarchy to consider (def=1).
% Output:      {h} entropy of the grouping.
%              {h_rel} entropy of the grouping divided by the maximal
%                   entropy possible, which is log2(no_groups).

% © Liran Carmel
% Classification: Characteristics of grouping
% Last revision date: 12-Jul-2004

% parse input line
error(nargchk(1,2,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    h_level = 1;
else
    error(chkvar(h_level,'integer',...
        {'scalar',{'greaterthan',0},{'eqlower',nohierarchies(gr)}},...
        {mfilename,inputname(2),2}));
end

% compute entropy
gs = groupsize(gr,h_level);
h = entropy(unit(gs,1));
h_rel = h / log2(nogroups(gr,h_level));