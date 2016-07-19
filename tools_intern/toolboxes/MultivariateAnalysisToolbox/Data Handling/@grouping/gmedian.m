function meds = gmedian(varargin)

% GMEDIAN computes intra-group medians
% ---------------------------------
% meds = gmedian(gr, data, h_level)
% ---------------------------------
% Description: If a dataset contains {g} groups in the {h_level} hierarchy,
%              then this function computes the {g} intra-group medians.
% Input:       {gr} grouping instance.
%              {data} to apply mean to. Can be either a collection of
%                   variable objects, or a variables-by-samples matrix.
%              <{h_level}> hierarchy level (def=1).
% Output:      {meds} variables-by-number_of_groups computed medians.

% © Liran Carmel
% Classification: Computations on groups
% Last revision date: 21-Jun-2004

% parse input line
[gr data h_level] = parse_input(varargin{:});

% initialize
no_vars = size(data,1);
no_groups = nogroups(gr,h_level);
meds = zeros(no_vars,no_groups);
for ii = 1:no_groups
    meds(:,ii) = median(data(:,grp2samp(gr,gr.gcn2gid{h_level}(ii),h_level)),2);
end

% #########################################################################
function [gr, data, h_level] = parse_input(varargin)

% PARSE_INPUT parses input line.
% -----------------------------------------
% [gr data h_level] = parse_input(varargin)
% -----------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {gr} grouping instance.
%              {data} variables-by-samples data matrix.
%              {h_level} hierarchy level.

% verify number of arguments
error(nargchk(2,3,nargin));

% first argument is the grouping
gr = varargin{1};
error(chkvar(gr,{},'scalar',{mfilename,'',1}));

% second argument is the data
[msg1 is_num] = chkvar(varargin{2},'numeric',{},{mfilename,'',2});
if is_num
    data = varargin{2};
    error(chkvar(data,{},{'matrix',{'no_cols',nosamples(gr)}},{mfilename,'',2}));
else
    [msg2 is_var] = chkvar(varargin{2},'variable',{},{mfilename,'',2});
    if is_var
        data = [];
        for ii = 1:length(varargin{2})
            vrii = instance(varargin{2},num2str(ii));
            data = [data ; vrii(1:end)];
        end
    else
        error('%s\n%s',msg1,msg2);
    end
end

% third argument is optional
h_level = 1;
if nargin == 3
    h_level = varargin{3};
    error(chkvar(h_level,'integer',{'scalar',{'eqlower',gr.no_hierarchies}},...
        {mfilename,'',3}));
end