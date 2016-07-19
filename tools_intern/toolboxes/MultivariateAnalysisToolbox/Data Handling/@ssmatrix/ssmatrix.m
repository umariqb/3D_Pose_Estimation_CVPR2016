function ssm = ssmatrix(varargin)

% SSMATRIX constructor method
% --------------------------------
% (1) ssm = ssmatrix()
% (2) ssm = ssmatrix(no_instances)
% (3) ssm = ssmatrix(ssm0)
% --------------------------------
% Description: constructs a ssmatrix instance.
% Input:       (1) An empty default ssmatrix is formed.
%              (2) {no_instances} integer. In this case {ssm} would be an
%                  empty ssmatrix vector of length {no_instances}.
%              (3) {ssm0} ssmatrix instance. In this case {ssm} would be an
%                  identical copy.
% Output:      {ssm} instance(s) of the ssmatrix class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 04-Apr-2006

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    dm = datamatrix;
    dm = set(dm,'type','sample-sample');
    dm = set(dm,'row_type','samples','col_type','samples');
    ssm.row_sampleset = [];    % sampleset attached to the rows (samples)
    ssm.col_sampleset = [];    % sampleset attached to the cols (samples)
    ssm.sampleset = [];        % common sampleset to rows and cols
    ssm.matrix = [];           % the data matrix
    ssm.row_groupings = [];    % groupings associated with the row-samples
    ssm.col_groupings = [];    % groupings associated with the col-samples
    ssm.groupings = [];        % common groupings to rows and cols
    ssm.isroweqcol = false;    % 1 if row_samples are identical to col_samples
    ssm.modifications = [];    % keeps track of modifications
    ssm = class(ssm,'ssmatrix',dm);
else
    error(nargchk(1,1,nargin));
    if isa(varargin{1},'double')        % case (2)
        ssm = [];
        for ii = 1:varargin{1}
            ssm = [ssm ssmatrix];
            ssm(ii) = set(ssm(ii),'name',sprintf('Matrix #%d',ii));
        end
    elseif isa(varargin{1},'ssmatrix')   % case (3)
        ssm = varargin{1};
    else
        error('Unrecognized input argument');
    end
end