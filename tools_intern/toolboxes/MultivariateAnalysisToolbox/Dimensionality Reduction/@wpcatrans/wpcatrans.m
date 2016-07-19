function wpt = wpcatrans(varargin)

% WPCATRANS constructor method
% -----------------------------------------------------
% (1) wpt = wpcatrans()
% (2) wpt = wpcatrans(no_instances)
% (3) wpt = wpcatrans(wpt0)
% (4) wpt = wpcatrans(vsm, lap, opt_name, opt_val, ...)
% -----------------------------------------------------
% Description: constructs a WPCATRANS instance.
% Input:       (1) An empty default wpcatrans is formed.
%              (2) {no_instances} integer. In this case {wpt} would be an
%                  empty pcatrans vector of length {no_instances}.
%              (3) {wpt0} wpcatrans instance. In this case {wpt} would be
%                  an identical copy.
%              (4) {vsm} vsmatrix instance.
%                  {lap} Laplacian matrix. Formed automatically if either
%                       of the keyords 'normalized' or 'supervised' are
%                       used. The former generates a Laplacian from the
%                       weights w_{ij} = 1 / d_{ij} for nonzero Euclidean
%                       distances between the samples. The second further
%                       zeros the intra-cluster weights. By default, the
%                       clusters are based on the highest hierarchy of the
%                       first grouping. If this is not the case, the
%                       Laplacian should be manually supplied.
%                  <{opt_name},{opt_val}> pairs of options that modify the
%                       algorithm. Available options are
%                       'constraints' - here {opt_val} is a matrix of {p}
%                           vectors v1,v2,...,vp arranged columnwise. The
%                           wPCA is then required to be orthogonal to
%                           span(v1,v2,...,vp), and is denoted
%                           orthogonal-wPCA (owPCA). By default no
%                           constraints are used.
%                       'preprocess' - Let X be the data matrix. If
%                           'preprocess' is 'center' (default), then X is
%                           centered. If it is 'standardize', then X is
%                           standardized. Otherwise, 'preprocess' should be
%                           'none'.
% Output:      {wpt} instance(s) of the wpcatrans class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 06-Dec-2006

% switch on number of input arguments
if nargin == 0      % case (1)
    lt = lintrans;                      % lintrans object
    lt = set(lt,'type','weighted PCA'); % change type to 'weighted PCA'
    wpt.ortho_constraints = [];         % orthogonality constraints
    wpt = class(wpt,'wpcatrans',lt);
elseif isa(varargin{1},'wpcatrans')  % case (3)
    error(nargchk(1,1,nargin));
    wpt = varargin{1};
elseif isa(varargin{1},'double')    % case (2)
    error(nargchk(1,1,nargin));
    wpt = [];
    for ii = 1:varargin{1}
        wpt = [wpt wpcatrans];
    end
else    % case (4)
    error(nargchk(2,3,nargin));
    % initialize
    wpt = wpcatrans;
    % first input argument is always the vsmatrix
    dm = varargin{1};
    error(chkvar(dm,'vsmatrix','scalar',{mfilename,'',1}));
    % second argument is the laplacian
    if ischar(varargin{2})
        % make weights
        switch str2keyword(varargin{2},4)
            case 'norm'
                wgt = modify(distmatrix(dm,'euclidean'),'invert','safe');
                type = 'normalized PCA';
            case 'supe'
                wgt = modify(distmatrix(dm,'euclidean'),'invert','safe');
                wgt = modify(wgt,'mult_intra',{0,[1 1]});
                type = 'supervised PCA';
            otherwise
                error('%s: Unrecognized Laplacian type',varargin{2});
        end
        % turn weights into Laplacian
        lap = ssm2lap(wgt);
    else
        lap = varargin{2};
        error(chkvar(lap,'numeric',...
            {'matrix',{'size',[get(dm,'no_variables') get(dm,'no_variables')]}},...
            {mfilename,'',2}));
    end
    % defaults
    V = [];
    preprocess = 'center';
    for ii = 3:2:nargin
        errmsg = {mfilename,inputname(ii+1),ii+1};
        switch str2keyword(varargin{ii},3)
            case 'con'  % option: constraints
                V = varargin{ii+1};
                if ~isempty(V)
                    error(chkvar(V,'numeric',...
                        {'matrix',{'no_rows',novariables(dm)}},errmsg));
                end
            case 'pre'  % option: preprocess
                error(chkvar(varargin{ii+1},'char','vector',errmsg));
                switch str2keyword(varargin{ii+1},4)
                    case 'none'
                        preprocess = 'none';
                    case 'cent'
                        preprocess = 'center';
                    case 'stan'
                        preprocess = 'standardize';
                    otherwise
                        error('%s: unrecognized value for ''preprocess''',...
                            lower(varargin{ii+1}));
                end
        end
    end
    % add orthogonality to the type variable
    if ~isempty(V)
        type = ['orthogonal ' type];
    end
    % transform the data and collect parameters
    dm = transform(dm,'all',preprocess);
    prep = [];
    if ~strcmp(preprocess,'none')
        for ii = 1:novariables(dm)
            prep = [prep; dm.variables(ii).transformations(end).parameters];
        end
    end
    prep = struct('name',preprocess,'parameters',prep);
    % reduce the dimensions of the problem
    dim_reduced = size(V,2);
    data = dm.variables(:,:);
    [data_reduced trans] = reduce2subspace(data,V,'vector');
    % find principal components and project back to full space
    [U e_vals] = eig(data_reduced*lap*data_reduced');
    [e_vals idx] = sort(diag(e_vals),'descend');
    U = U(:,idx);
    U = [V trans*U];
    for ii = 1:dim_reduced
        e_vals = [U(:,ii)'*data*data'*U(:,ii) ; e_vals];
    end
    % prepare names of original variables
    variableset = sampleset(dm.variables(:).name);
    variableset = set(variableset,'name','Variables','description',...
        'Names of original variables');
    % prepare names of principal components
    list = [];
    for ii = 1:dim_reduced
        list = [list {sprintf('Orthogonal Constraint #%d',ii)}];
    end
    for ii = dim_reduced+1:size(data,1)
        list = [list {sprintf('weighted Principal Component #%d',ii-dim_reduced)}];
    end
    factorset = sampleset(list);
    factorset = set(factorset,'name','Principal Components',...
        'description','Names of principal components');
    % prepare scores as vsmatrix
    vars = variable(U.'*data);
    for ii = 1:length(vars)
        vars(ii) = set(vars(ii),'name',list{ii},'level','numerical');
    end
    if isempty(dm.name)
        name = sprintf('%s',type);
    else
        name = sprintf('%s of %s datamatrix',type,dm.name);
    end
    desc = '';
    if ~isempty(dm.description)
        desc = sprintf('data description: %s',dm.description);
    end
    orig_vars = dm.variables.name;
    dm = set(dm,'name',name,'description',desc,'variables',vars,...
        'sampleset',dm.sampleset,'groupings',dm.groupings);
    % substitute everything in the class
    wpt = set(wpt,'type',type,'U',U,'eigvals',e_vals,...
        'f_eigvals',unit(e_vals,1),'factorset',factorset,...
        'variableset',variableset,'no_samples',size(data,2),...
        'scores',dm,'ortho_constraints',V,...
        'preprocess',prep);
end