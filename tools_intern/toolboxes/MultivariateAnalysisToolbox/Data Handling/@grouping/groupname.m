function names = groupname(gr,h_level,samples)

% GROUPNAME retrieves the group names of desired samples.
% ---------------------------------------
% names = groupname(gr, h_level, samples)
% ---------------------------------------
% Description: retrieves the group names of desired samples.
% Input:       {gr} a group instance.
%              <{h_level}> hierarchy level.
%              {samples} indices of desired samples.
% Output:      {names} cell array of list of names.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 06-Dec-2004

% determine {h_level}
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 2
    samples = h_level;
    h_level = 1;
else
    error(chkvar(h_level,'integer',...
        {{'greaterthan',0},{'eqlower',gr.no_hierarchies}},...
        {mfilename,inputname(2),2}));
end
error(chkvar(samples,'integer',...
    {'vector',{'greaterthan',0},{'eqlower',gr.no_samples}},...
    {mfilename,inputname(nargin),nargin}));

% find list of unknowns
names = gr.naming{h_level}(gr.gid2gcn{h_level}(gr.assignment(h_level,samples)));