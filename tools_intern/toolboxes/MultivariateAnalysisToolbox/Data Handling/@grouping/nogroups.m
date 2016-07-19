function no_groups = nogroups(gr,h_level)

% NOGROUPS finds number of groups.
% ---------------------------------
% no_groups = nogroups(gr, h_level)
% ---------------------------------
% Description: finds number of groups in a GROUPING instance.
% Input:       {gr} a group instance.
%              <{h_level}> where to find the number of groups. If [] or
%                   'all', all hierarchies are taken (def = 'all').
% Output:      {no_groups} number of groups.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% parse input line
error(nargchk(1,2,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    h_level = 'all';
end
if (ischar(h_level) && strcmp(h_level,'all')) || isempty(h_level)
    h_level = 1:gr.no_hierarchies;
end

no_groups = gr.no_groups(h_level);