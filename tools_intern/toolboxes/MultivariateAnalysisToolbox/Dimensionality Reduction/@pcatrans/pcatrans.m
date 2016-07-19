function pt = pcatrans(varargin)

% PCATRANS constructor method
% ----------------------------------------------
% (1) pt = pcatrans()
% (2) pt = pcatrans(no_instances)
% (3) pt = pcatrans(pt0)
% (4) pt = pcatrans(vsm, opt_name, opt_val, ...)
% (5) pt = pcatrans(cvm, opt_name, opt_val, ...)
% ----------------------------------------------
% Description: constructs a PCATRANS instance.
% Input:       (1) An empty default pcatrans is formed.
%              (2) {no_instances} integer. In this case {pt} would be an
%                  empty pcatrans vector of length {no_instances}.
%              (3) {pt0} PCATRANS instance. In this case {pt} would be an
%                  identical copy.
%              (4) {vsm} VSMATRIX instance.
%                  <{opt_name},{opt_val}> pairs of options that modify the
%                       algorithm. Available options are
%                       'algorithm' - used to compute the PCs, either 'cov'
%                           (def), 'svd' or 'svds'.
%                       'constraints' - here {opt_val} is a matrix of {p}
%                           vectors v1,v2,...,vp arranged columnwise. The
%                           PCA is then required to be orthogonal to
%                           span(v1,v2,...,vp), and is denoted
%                           orthogonal-PCA (oPCA). By default no
%                           constraints are used.
%                       'preprocess' - If X is the data matrix, the PCs are
%                           the eigenvectors of XX'. If 'preprocess' is
%                           'center' (default), then X is centered and XX'
%                           is proportional to the covariance matrix. If it
%                           is 'standardize', then XX' is proportional to
%                           the correlation matrix. Otherwise, 'preprocess'
%                           should be 'none'.
%              (5) {cvm} COVMATRIX instance.
%                  <{opt_name},{opt_val}> pairs of options that modify the
%                       algorithm. Available options are
%                       'constraints' - here {opt_val} is a matrix of {p}
%                           vectors v1,v2,...,vp arranged columnwise. The
%                           PCA is then required to be orthogonal to
%                           span(v1,v2,...,vp), and is denoted
%                           orthogonal-PCA (oPCA). By default no
%                           constraints are used.
% Output:      {pt} instance(s) of the pcatrans class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 06-Dec-2006

% switch on number of input arguments
if nargin == 0      % case (1)
    lt = lintrans;                      % lintrans object
    lt = set(lt,'type','PCA');          % change type to 'PCA'
    pt.algorithm = [];                  % implementation details
    pt.ortho_constraints = [];          % orthogonality constraints
    pt = class(pt,'pcatrans',lt);
elseif isa(varargin{1},'pcatrans')  % case (3)
    error(nargchk(1,1,nargin));
    pt = varargin{1};
elseif isa(varargin{1},'double')    % case (2)
    error(nargchk(1,1,nargin));
    pt = [];
    for ii = 1:varargin{1}
        pt = [pt pcatrans];
    end
elseif isa(varargin{1},'vsmatrix')  % case (4)
    error(nargchk(1,3,nargin));
    % initialize
    pt = pcatrans;
    % first input argument is always the vsmatrix
    dm = varargin{1};
    error(chkvar(dm,'vsmatrix','scalar',{mfilename,'',1}));
    % defaults
    V = [];
    algorithm = 'cov';
    preprocess = 'center';
    for ii = 2:2:nargin
        errmsg = {mfilename,inputname(ii+1),ii+1};
        switch str2keyword(varargin{ii},3)
            case 'alg'   % option: algorithm
                error(chkvar(varargin{ii+1},'char',...
                    {'vector',{'match',{'cov','svd','svds'}}},errmsg));
                algorithm = varargin{ii+1};
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
    % type of transformation
    if isempty(V)
        type = 'PCA';
    else
        type = 'Orthogonal PCA';
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
    [U e_vals] = pca_engin(data_reduced,'rectangular',algorithm);
    U = [V trans*U];
    for ii = 1:dim_reduced
        e_vals = [U(:,ii)'*data*data'*U(:,ii) / (size(data,2)-1) ; e_vals];
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
    for ii = dim_reduced+1:length(e_vals)
        list = [list {sprintf('Principal Component #%d',ii-dim_reduced)}];
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
    if isempty(dm.description)
        desc = '';
    else
        desc = sprintf('data description: %s',dm.description);
    end
    dm = set(dm,'name',name,'description',desc,'variables',vars,...
        'sampleset',dm.sampleset,'groupings',dm.groupings);
    % substitute everything in the class
    pt = set(pt,'type',type,'U',U,'eigvals',e_vals,...
        'f_eigvals',unit(e_vals,1),'factorset',factorset,...
        'variableset',variableset,'no_samples',size(data,2),...
        'scores',dm,'algorithm',algorithm,'ortho_constraints',V,...
        'preprocess',prep);
else                % case (5)
    error(nargchk(1,2,nargin));
    % initialize
    pt = pcatrans;
    % first input argument is always the covmatrix
    cvm = varargin{1};
    error(chkvar(cvm,'covmatrix','scalar',{mfilename,'',1}));
    % defaults
    V = [];
    for ii = 2:2:nargin
        errmsg = {mfilename,inputname(ii+1),ii+1};
        switch str2keyword(varargin{ii},3)
            case 'con'  % option: constraints
                V = varargin{ii+1};
                if ~isempty(V)
                    error(chkvar(V,'numeric',...
                        {'matrix',{'no_rows',get(cvm,'no_rows')}},errmsg));
                end
        end
    end
    % type of transformation
    if isempty(V)
        type = 'PCA';
    else
        type = 'Orthogonal PCA';
    end
    % reduce the dimensions of the problem
    dim_reduced = size(V,2);
    data = cvm(:,:);
    [data_reduced trans] = reduce2subspace(data,V,'vector');
    % find principal components and project back to full space
    [U e_vals] = pca_engin(data_reduced,'square','cov');
    U = [V trans*U];
    for ii = 1:dim_reduced
        e_vals = [U(:,ii)'*data*U(:,ii) ; e_vals];
    end
    % prepare names of principal components
    list = [];
    for ii = 1:dim_reduced
        list = [list {sprintf('Orthogonal Constraint #%d',ii)}];
    end
    for ii = dim_reduced+1:size(data,1)
        list = [list {sprintf('Principal Component #%d',ii-dim_reduced)}];
    end
    factorset = sampleset(list);
    factorset = set(factorset,'name','Principal Components',...
        'description','Names of principal components');
    % prepare names of original variables
    variableset = cvm.sampleset;
    variableset = set(variableset,'name','Variables','description',...
        'Names of original variables');
    % substitute everything in the class
    pt = set(pt,'type',type,'U',U,'eigvals',e_vals,...
        'f_eigvals',unit(e_vals,1),'factorset',factorset,...
        'variableset',variableset,'no_samples',get(cvm,'no_samples'),...
        'algorithm','cov','ortho_constraints',V);
end