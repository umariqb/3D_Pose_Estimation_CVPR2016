function stds = gstd(varargin)

% GSTD computes intra-group standard deviations.
% ------------------------------
% stds = gstd(gr, data, h_level)
% ------------------------------
% Description: If a dataset contains {g} groups in the {h_level} hierarchy,
%              then this function computes the {g} intra-group standard
%              deviations.
% Input:       {gr} grouping instance.
%              {data} to apply mean to. Can be either a collection of
%                   variable objects, or a variables-by-samples matrix.
%              <{h_level}> hierarchy level (def=1).
% Output:      {stds} variables-by-number_of_groups computed standard
%                   deviations.

% © Liran Carmel
% Classification: Computations on groups
% Last revision date: 02-Jun-2005

% parse input line
[gr data h_level] = parse_input(varargin{:});

% initialize
no_vars = size(data,1);
no_groups = nogroups(gr,h_level);
stds = zeros(no_vars,no_groups);
for ii = 1:no_groups
    stds(:,ii) = ...
        std(data(:,grp2samp(gr,gr.gcn2gid{h_level}(ii),h_level)),0,2);
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
err_msg = {mfilename,'',2};
if isa(varargin{2},'numeric')
    data = varargin{2};
elseif isa(varargin{2},'variable')
    data = [];
    for ii = 1:length(varargin{2})
        vrii = instance(varargin{2},num2str(ii));
        data = [data; vrii(1:end)];
    end
elseif isa(varargin{2},'vsmatrix')
    data = varargin{2}(:,:);
else
    err_msg = '2nd argument should be eigher VSMATRIX, VARIABLE or';
    err_msg = sprintf('%s NUMERICAL matrix',err_msg);
    error(err_msg);
end

% check consistency
error(chkvar(data,{},{'matrix',{'no_cols',nosamples(gr)}},err_msg));

% third argument is optional
h_level = 1;
if nargin == 3
    h_level = varargin{3};
    error(chkvar(h_level,'integer',{'scalar',{'eqlower',gr.no_hierarchies}},...
        {mfilename,'',3}));
end