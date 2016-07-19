function dstm = distmatrix(varargin)

% DISTMATRIX constructor method
% --------------------------------------------------
% (1) dstm = distmatrix()
% (2) dstm = distmatrix(no_instances)
% (3) dstm = distmatrix(dstm0)
% (4) dstm = distmatrix(ssm)
% (5) dstm = distmatrix(vsm, dist_type, P1, P2, ...)
% --------------------------------------------------
% Description: constructs a DISTMATRIX instance.
% Input:       (1) An empty default DISTMATRIX is formed.
%              (2) {no_instances} integer. In this case {dstm} would be an
%                  empty DISTMATRIX vector of length {no_instances}.
%              (3) {dstm0} DISTMATRIX instance. In this case {dstm} would
%                  be an identical copy.
%              (4) {ssm} SSMATRIX instance.
%              (5) {vsm} VSMATRIX instance.
%                  <{dist_type}> Can be a reserved keyword string, or a
%                       handle to a distance function, see details in
%                       PDIST. The default is 'euclidean'.
%                  <{P1, P2}> parameters that are required to compute
%                       {dist_type}, see details in PDIST.
% Output:      {dstm} instance(s) of DISTMATRIX.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 12-Jan-2005

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    ssm = ssmatrix;                 % parent class
    ssm = set(ssm,'type','distance');
    dstm.dist_type = '';
    dstm.no_variables = 0;
    dstm = class(dstm,'distmatrix',ssm);
else
    if isa(varargin{1},'double')    % case (2)
        error(nargchk(1,1,nargin));
        dstm = [];
        for ii = 1:varargin{1}
            dstm = [dstm distmatrix];
            dstm(ii).name = sprintf('Distance Matrix #%d',ii);
        end
    elseif isa(varargin{1},'distmatrix') % case (3)
        error(nargchk(1,1,nargin));
        dstm = varargin{1};
    elseif isa(varargin{1},'ssmatrix')  % case (4)
        error(nargchk(1,1,nargin));
        dstm = distmatrix;
        dstm.ssmatrix = varargin{1};
        dstm = set(dstm,'type','distance');
    elseif isa(varargin{1},'vsmatrix')   % case (5)
        % take complete data only
        vsm = varargin{1};
        error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));
        no_samples = nosamples(vsm);
        no_variables = novariables(vsm);
        samp_to_keep = 1:no_samples;
        for ii = 1:no_variables
            [data idx] = nanless(vsm.variables(ii));    %#ok
            samp_to_keep = intersect(samp_to_keep,idx);
        end
        if length(samp_to_keep) < 2
            error('Less than two samples have all their variables complete');
        end
        samp_to_remove = allbut(samp_to_keep,no_samples);
        if ~isempty(samp_to_remove)
            str = sprintf('some variables are not complete. Taking only');
            str = sprintf('%s %d out of the %d samples',str,...
                length(samp_to_keep),no_samples);
            warning(str)
        end
        data = vsm.variables(:,samp_to_keep)';
        % compute pairwise distances
        dst = pdist(data,varargin{2:end});
        % compute distance matrix
        dist_mat = nan(no_samples);
        dist_mat(samp_to_keep,samp_to_keep) = squareform(dst);
        % find {dist_type}
        dist_type = 'Euclidean';
        if nargin > 1
            if isa(varargin{2},'function_handle')
                dist_type = sprintf('@%s',func2str(varargin{2}));
            else
                dist_type = varargin{2};
            end
        end
        % substitute in DISTMATRIX object
        dstm = distmatrix;
        if ~isempty(vsm.description)
            dstm = set(dstm,'description',...
                sprintf('(data) %s',vsm.description));
        end
        dstm.dist_type = dist_type;
        type = sprintf('%s distance',dist_type);
        dstm = set(dstm,'name',vsm.name,'dist_type',dist_type,...
            'sampleset',vsm.sampleset,'matrix',dist_mat,...
            'no_variables',no_variables,'type',type);
    else
        error('Unrecognized input argument');
    end
end