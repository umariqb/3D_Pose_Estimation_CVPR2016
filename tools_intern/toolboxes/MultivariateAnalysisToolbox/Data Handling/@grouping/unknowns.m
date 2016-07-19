function idx = unknowns(gr,h_level)

% UNKNOWNS list the indices of those samples whose grouping is unknown.
% ---------------------------
% idx = unknowns(gr, h_level)
% ---------------------------
% Description: list the indices of those samples whose grouping is unknown.
% Input:       {gr} a group instance.
%              <{h_level}> hierarchy level.
% Output:      {idx} list of indices.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 06-Dec-2004

% determine {h_level}
if nargin == 1
    h_level = 1;
else
    error(chkvar(h_level,'integer',...
        {{'greaterthan',0},{'eqlower',gr.no_hierarchies}},...
        {mfilename,inputname(2),2}));
end

% find list of unknowns
idx = find(isnan(gr.assignment(h_level,:)));