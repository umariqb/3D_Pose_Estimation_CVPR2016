function sim = simatrix(varargin)

% SIMATRIX constructor method
% ------------------------------------------------
% (1) sim = simatrix()
% (2) sim = simatrix(no_instances)
% (3) sim = simatrix(sim0)
% (4) sim = simatrix(dst0)
% (5) sim = simatrix(field_name, field_value, ...)
% ------------------------------------------------
% Description: constructs a simatrix instance.
% Input:       (1) An empty default simatrix is formed.
%              (2) {no_instances} integer. In this case {sim} would be an
%                  empty simatrix vector of length {no_instances}.
%              (3) {sim0} simatrix instance. In this case {sim} would be
%                  an identical copy.
%              (4) {dst0} distmatrix instance. In this case the fields of
%                  {dst0} will be copied into the fields of {sim}, except
%                  for the obvious 'type' field.
%              (5) pairs of field names accompanied by their corresponding
%                  values.
% Output:      {sim} instance(s) of the simatrix class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 12-Aug-2005

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    ssm = ssmatrix;             % parent class
    ssm = set(ssm,'type','similarity');
    sim.sim_type = '';          % type of similarity
    sim.no_variables = 0;       % number of variables
    sim = class(sim,'simatrix',ssm);
elseif nargin == 1
    if isa(varargin{1},'double')    % case (2)
        sim = [];
        for ii = 1:varargin{1}
            sim = [sim simatrix];
            sim(ii).name = sprintf('Similarity Matrix #%d',ii);
        end
    elseif isa(varargin{1},'simatrix')   % case (3)
        sim = varargin{1};
    elseif isa(varargin{1},'distmatrix')    % case (4)
        sim = simatrix;
        sim.ssmatrix = get(varargin{1},'ssmatrix');
        sim.ssmatrix = set(sim.ssmatrix,'type','similarity');
        sim.no_variables = get(varargin{1},'no_variables');
    else
        error('Unrecognized input argument');
    end
else	% case (5)
    % initialize
    error(chkvar(nargin,{},'even',{mfilename,'Number of Arguments',0}));
    sim = simatrix;
    sim = set(sim,varargin{:});
end