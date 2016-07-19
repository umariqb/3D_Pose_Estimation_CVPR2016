function dsm = dissimatrix(varargin)

% DISSIMATRIX constructor method
% -----------------------------------
% (1) dsm = dissimatrix()
% (2) dsm = dissimatrix(no_instances)
% (3) dsm = dissimatrix(dsm0)
% -----------------------------------
% Description: constructs a dissimatrix instance.
% Input:       (1) An empty default dissimatrix is formed.
%              (2) {no_instances} integer. In this case {dsm} would be an
%                  empty dissimatrix vector of length {no_instances}.
%              (3) {dsm0} dissimatrix instance. In this case {dsm} would be
%                  an identical copy.
% Output:      {dsm} instance(s) of the dissimatrix class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 03-Sep-2004

% decide on which kind of constructor should be used
error(nargchk(0,1,nargin));
if nargin == 0      % case (1)
    ssm = ssmatrix;                 % parent class
    ssm = set(ssm,'type','dissimilarity');
    dsm.dissim_type = [];           % type of dissimilarity
    dsm.no_variables = 0;           % number of variables
    dsm = class(dsm,'dissimatrix',ssm);
else
    if isa(varargin{1},'double')            % case (2)
        dsm = [];
        for ii = 1:varargin{1}
            dsm = [dsm dissimatrix];
            dsm(ii).name = sprintf('Dissimilarity Matrix #%d',ii);
        end
    elseif isa(varargin{1},'dissimatrix')   % case (3)
        dsm = varargin{1};
    else
        error('Unrecognized input argument');
    end
end