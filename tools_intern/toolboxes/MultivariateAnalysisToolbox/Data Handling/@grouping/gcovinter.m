function cov_int = gcovinter(varargin)

% GCOVINTER computes the inter-group covariance matrix.
% --------------------------------------
% cov_int = gcovinter(gr, data, h_level)
% --------------------------------------
% Description: computes the average inter-group covariance matrix.
%              Currently, only ML estimator is available.
% Input:       {gr} grouping instance.
%              {data} to apply covarince to. Can be either a collection of
%                   variable objects, or a variables-by-samples matrix.
%              <{h_level}> hierarchy level (def=1).
% Output:      {cov_int} variables-by-variables average intra_group
%                   covariance matrix. 

% © Liran Carmel
% Classification: Computations on groups
% Last revision date: 02-Jul-2004

% parse input line
[gr data h_level] = parse_input(varargin{:});

% get group means
means = gmean(gr,data,h_level);

% extract magnitudes that characterize the grouping
no_grp = nogroups(gr,h_level);
grp_size = groupsize(gr,h_level);
no_samp = nosamples(gr);

% compute ML estimator of the average inter-group covariance
cov_int = 0;
for ii = 1:no_grp
    cov_int = cov_int + grp_size(ii)*means(:,ii)*means(:,ii).';
end
cov_int = cov_int / no_samp;

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