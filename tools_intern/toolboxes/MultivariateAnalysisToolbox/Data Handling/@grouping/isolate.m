function gr = isolate(gr,which_grp)

% ISOLATE extracts a single 1-level grouping.
% ---------------------------
% gr = isolate(gr, which_grp)
% ---------------------------
% Description: extracts a single 1-level grouping.
% Input:       {gr} grouping instance(s).
%              {which_grp} instructs the function which grouping to
%                   isolate. It is a 2-vector [grp_num h_level], where
%                   {grp_num} indicates which of the grouping instances to
%                   take (if {gr} is a vector of grouping objects), and
%                   {h_level} indicates what hierarchy level is the
%                   relevant. If {gr} consists of only one grouping
%                   instance, {which_grp} may be a scalar indicating
%                   {h_level}, or empty [] indicating to take the first
%                   hierarchy. In all other circumstances, {which_grp} is
%                   not allowed to be a scalar or empty.
% Output:      {gr} 1-level single grouping instance.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 04-Jul-2004

% parse input line
error(nargchk(2,2,nargin));

% distinguish between scalar input grouping and non-scalar input grouping
if length(gr) > 1
    error(chkvar(which_grp,'integer',...
        {'vector',{'length',2},{'greaterthan',0},},...
        {mfilename,inputname(2),2}));
    gr = subgrouping(instance(gr,num2str(which_grp(1))),which_grp(2));
elseif length(gr) == 1
    error(chkvar(which_grp,'integer',...
        {'vector',{'maxlength',2},{'greaterthan',0}},...
        {mfilename,inputname(2),2}));
    if isempty(which_grp)
        gr = subgrouping(gr,1);
    elseif length(which_grp) == 1
        gr = subgrouping(gr,which_grp);
    else
        if which_grp(1) ~= 1
            error('there is only one grouping instance in train');
        end
        gr = subgrouping(gr,which_grp(2));
    end
else
    error('train data do not include grouping information')
end