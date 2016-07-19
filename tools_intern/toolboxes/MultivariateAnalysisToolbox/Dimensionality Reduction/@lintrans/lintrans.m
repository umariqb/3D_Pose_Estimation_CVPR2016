function lt = lintrans(varargin)

% LINTRANS constructor method
% -------------------------------
% (1) lt = lintrans()
% (2) lt = lintrans(no_instances)
% (3) lt = lintrans(lt0)
% -------------------------------
% Description: constructs a LINTRANS instance.
% Input:       (1) An empty default lintrans is formed.
%              (2) {lt0} lintrans instance. In this case {lt} would be an
%                  identical copy.
%              (3) {no_instances} integer. In this case {lt} would be an
%                  empty lintrans vector of length {no_instances}.
% Output:      {lt} an instance of the lintrans class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 01-Feb-2005

% switch on number of input arguments
error(nargchk(0,1,nargin));
if nargin == 0    % case (1)
    lt.type = '';                % type of linear transformation
    lt.U = [];                   % transformation matrix
    lt.eigvals = [];             % eigenvalues used for solution
    lt.f_eigvals = [];           % fractional importance of each eigenvalue
    lt.factorset = [];           % factor names (sampleset)
    lt.no_factors = 0;           % number of new factors
    lt.variableset = [];         % variable names (sampleset)
    lt.no_variables = 0;         % number of old variables
    lt.no_samples = 0;           % number of sample used
    lt.preprocess = [];          % intial data preprocessing
    lt.scores = [];              % data scores
    lt = class(lt,'lintrans');
elseif isa(varargin{1},'lintrans')  % case (3)
    lt = varargin{1};
elseif isa(varargin{1},'double')    % case (2)
    lt = [];
    for ii = 1:varargin{1}
        lt = [lt lintrans];
    end
else
    error('Unrecognized input argument');
end