function vvm = vvmatrix(varargin)

% VVMATRIX constructor method
% --------------------------------
% (1) vvm = vvmatrix()
% (2) vvm = vvmatrix(no_instances)
% (3) vvm = vvmatrix(vv0)
% --------------------------------
% Description: constructs a vvmatrix instance.
% Input:       (1) An empty default vvmatrix is formed.
%              (2) {no_instances} integer. In this case {vvm} would be an
%                  empty vvmatrix vector of length {no_instances}.
%              (3) {vvm0} ssmatrix instance. In this case {vvm} would be an
%                  identical copy.
% Output:      {vvm} an instance of the vvmatrix class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 02-Sep-2004

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    dm = datamatrix;
    dm = set(dm,'type','variable-variable');
    dm = set(dm,'row_type','variables','col_type','variables');
    vvm.row_sampleset = [];    % sampleset attached to the rows (variables)
    vvm.col_sampleset = [];    % sampleset attached to the cols (variables)
    vvm.sampleset = [];        % sampleset attached commonly to row and cols
    vvm.matrix = [];           % the data matrix
    vvm.isroweqcol = false;    % 1 if row_variables are identical to col_variables
    vvm = class(vvm,'vvmatrix',dm);
 else
    error(nargchk(1,1,nargin));
    if isa(varargin{1},'double')        % case (2)
        vvm = [];
        for ii = 1:varargin{1}
            vvm = [vvm vvmatrix];
            vvm(ii).name = sprintf('Matrix #%d',ii);
        end
    elseif isa(varargin{1},'vvmatrix')   % case (3)
        vvm = varargin{1};
    else
        error('Unrecognized input argument');
    end
end