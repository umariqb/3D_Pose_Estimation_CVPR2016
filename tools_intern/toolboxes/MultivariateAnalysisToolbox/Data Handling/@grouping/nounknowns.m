function no_unknowns = nounknowns(gr,h_level)

% NOUNKNOWNS finds the number of samples whos grouping is unknown.
% -------------------------------------
% no_unknowns = nounknowns(gr, h_level)
% -------------------------------------
% Description: finds the number of samples whos grouping is unknown.
% Input:       {gr} a group instance.
%              <{h_level}> hierarchy level.
% Output:      {no_unknowns} number of unknown samples.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 14-Jun-2004

% determine {h_level}
if nargin == 1
    h_level = 1;
else
    error(chkvar(h_level,'integer',...
        {{'greaterthan',0},{'eqlower',gr.no_hierarchies}},...
        {mfilename,inputname(2),2}));
end

% calculate number of unknowns
no_unknowns = length(find(isnan(gr.assignment(h_level,:))));