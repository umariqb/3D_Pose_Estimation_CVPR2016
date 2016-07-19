function cvm = covmatrix(varargin)

% COVMATRIX constructor method
% -------------------------------------------------
% (1) cvm = covmatrix()
% (2) cvm = covmatrix(no_instances)
% (3) cvm = covmatrix(cvm0)
% (4) cvm = covmatrix(field_name, field_value, ...)
% -------------------------------------------------
% Description: constructs COVMATRIX instance(s).
% Input:       (1) An empty default COVMATRIX is formed.
%              (2) {no_instances} integer. In this case {cvm} would be an
%                  empty COVMATRIX vector of length {no_instances}.
%              (3) {cvm0} COVMATRIX instance. In this case {cvm} would be
%                  an identical copy.
%              (4) pairs of field names accompanied by their corresponding
%                  values. Supported fields are all write-permission ones.
% Output:      {cvm} COVMATRIX instance(s).

% © Liran Carmel
% Classification: Constructors
% Last revision date: 08-Nov-2006

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    vvm = vvmatrix;                     % parent class
    vvm = set(vvm,'type','Covariance/Correlation');
    cvm.cov_type = '';                  % either covariance or correlation
    cvm.no_samples = [];                 % number of data points
    cvm.hypothesis = '';                % available hypothesis tests
    cvm.p_value = [];                   % p_value of covariance value
    cvm = class(cvm,'covmatrix',vvm);
elseif nargin == 1
    if isa(varargin{1},'double')        % case (2)
        cvm = [];
        for ii = 1:varargin{1}
            cvm = [cvm covmatrix];
            cvm(ii).name = sprintf('Covariance Matrix #%d',ii);
        end
    elseif isa(varargin{1},'covmatrix') % case (3)
        cvm = varargin{1};
    else
        error('Unrecognized input argument');
    end
else    % case (4)
    error(chkvar(nargin,{},'even',{mfilename,'Number of Arguments',0}));
    % initialize a default instance
    cvm = covmatrix;
    % substitute properties
    cvm = set(cvm,varargin{:});
end