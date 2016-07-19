function gs = groupsize(gr,h_level)

% GROUPSIZE finds the size (no. elements) of each group.
% ---------------------------
% gs = groupsize(gr, h_level)
% ---------------------------
% Description: finds the size (no. elements) of each group.
% Input:       {gr} a group instance.
%              <{h_level}> hierarchy level (def = 1).
% Output:      {gs} vector of all gruop sizes.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 16-Jun-2004

% parse input line
error(nargchk(1,2,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    h_level = 1;
end

% calculate the size of each group
no_grp = nogroups(gr,h_level);
gs = zeros(1,no_grp);
gcn2gid = gr.gcn2gid{h_level};
for ii = 1:no_grp
    gs(ii) = length(grp2samp(gr,gcn2gid(ii),h_level));
end