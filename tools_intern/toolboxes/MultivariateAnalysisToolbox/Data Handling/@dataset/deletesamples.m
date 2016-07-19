function ds = deletesamples(varargin)

% DELETESAMPLES eliminate samples from a dataset instance.
% -------------------------------------
% ds = deletesamples(ds, ss, to_remove)
% -------------------------------------
% Description: eliminate samples from a specific sampleset, and from all
%              corresponding variables and groupings.
% Input:       {ds} dataset instance.
%              <{ss}> index of sample set (def=1).
%              {to_remove} samples to delete.
% Output:      {ds} updated dataset instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 29-Nov-2004

% parse input line
[ds ss to_remove] = parse_input(varargin{:});

% delete samples from variables, groupings and samplesets
vars = find(ds.var2sampset==ss);
if ~isempty(vars)
    ds.variables(vars) = deletesamples(ds.variables(vars),to_remove);
end
grps = find(ds.grp2sampset==ss);
if ~isempty(grps)
    ds.groupings(grps) = deletesamples(ds.groupings(grps),to_remove);
end
if nosamplesets(ds) == 1
    ds.samplesets = deletesamples(ds.samplesets,to_remove);
else
    ds.samplesets(ss) = deletesamples(ds.samplesets(ss),to_remove);
end

% #########################################################################
function [ds, ss, to_remove] = parse_input(varargin)

% PARSE_INPUT parses input line.
% -----------------------------------------
% [ds ss to_remove] = parse_input(varargin)
% -----------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {ds} dataset object
%              {ss} index of sampleset.
%              {to_remove} indices to remove.

% verify number of arguments
error(nargchk(2,3,nargin));

% first argument is always dataset
ds = varargin{1};
error(chkvar(ds,{},'scalar',{mfilename,'',1}));

% the rest of the arguments
if nargin == 2  % if only two arguments are input
    ss = 1;
    to_remove = varargin{2};
else            % if three arguments are input
    [msg1 is_char] = chkvar(varargin{2},'char','vector',{mfilename,'',2});
    if is_char
        ss = ssname2ssidx(ds,varargin{2});
    else
        [msg2 is_num] = chkvar(varargin{2},'integer',...
            {'scalar',{'eqlower',ds.no_samplesets}},{mfilename,'',2});
        if is_num
            ss = varargin{2};
        else
            error('%s\n%s',msg1,msg2);
        end
    end
    to_remove = varargin{3};
end

% check consistency of {to_remove}
error(chkvar(to_remove,'integer',...
    {'vector',{'greaterthan',0},{'eqlower',ds.samplesets(ss).no_samples}},...
    {mfilename,'to_remove',0}));