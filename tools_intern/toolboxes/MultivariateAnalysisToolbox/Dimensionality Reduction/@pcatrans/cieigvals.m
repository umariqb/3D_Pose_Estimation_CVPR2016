function [low, high] = cieigvals(varargin)

% CIEIGVALS computes confidence intervals for the eigenvalues.
% ---------------------------------------------------
% [low high] = cieigvals(pc, alpha, factors, ci_type)
% ---------------------------------------------------
% Description: computes confidence intervals for the eigenvalues.
% Input:       {pc} PCATRANS instance.
%              {alpha} 1 - alpha is the significance level (this is the
%                   traditional definition).
%              <{factors}> indicates which factors to take. If absent, all
%                   factors are taken.
%              <{ci_type}> type of CI, either 'symmetric' or 'asymmetric'
%                   (def).
% Output:      {low} lower difference, e.g. low_value = eigen_value - low.
%              {high} upper difference, e.g. high_value = high -
%                   eigen_value.

% © Liran Carmel
% Classification: Inference
% Last revision date: 18-Jan-2005

% parse input
[pc alph factors ci_type] = parse_input(varargin{:});

% retrieve eigenvalues
eigvals = get(pc,'eigvals')';
eigvals = eigvals(factors);

% compute gamma = z_{\alpha/2} * sqrt(2/n)
gam = norminv(alph/2) * sqrt(2 / nosamples(pc));

% compute {low} and {high}
switch ci_type
    case 'asymmetric'
        low = eigvals * gam / (1 + gam);
        high = eigvals * gam / (1 - gam);
    case 'symmetric'
        low = gam * eigvals;
        high = low;
end

% #########################################################################
function [pc, alph, factors, ci_type] = parse_input(varargin)

% PARSE_INPUT parses input line.
% --------------------------------------------------
% [pc alpha factors ci_type] = parse_input(varargin)
% --------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {pc} PCATRANS instance.
%              {alpha} significance level.
%              {factors} which factors to take.
%              {ci_type} type of CI, either 'symmetric' or 'asymmetric'.

% first argument is always a scalar PCATRANS
error(nargchk(2,4,nargin));
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
pc = varargin{1};

% second argument is always the significance level
error(chkvar(varargin{2},'double',...
    {'scalar',{'greaterthan',0},{'lowerthan',1}},{mfilename,'',2}));
alph = 1 - varargin{2};

% defaults
factors = 1:nofactors(pc);
ci_type = 'asymmetric';

% loop on the rest of the variables
for ii = 3:nargin
    errmsg = {mfilename,'',ii};
    if isa(varargin{ii},'double')   % factors
        factors = varargin{ii};
        error(chkvar(factors,'integer',...
            {'vector',{'greaterthan',0},{'eqlower',pc.no_factors}},...
            errmsg));
    elseif isa(varargin{ii},'char')
        ci_type = varargin{ii};
        error(chkvar(ci_type,{},...
            {'vector',{'match',{'symmetric','asymmetric'}}},errmsg));
    else
        error('unrecognized input');
    end
end