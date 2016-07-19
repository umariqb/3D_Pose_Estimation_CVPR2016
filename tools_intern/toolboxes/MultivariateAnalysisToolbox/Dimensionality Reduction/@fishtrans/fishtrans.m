function ft = fishtrans(varargin)

% FISHTRANS constructor method
% ----------------------------------------------------------
% (1) ft = fishtrans()
% (2) ft = fishtrans(no_instances)
% (3) ft = fishtrans(ft0)
% (4) ft = fishtrans(vsm, which_grp, opt_name, opt_val, ...)
% ----------------------------------------------------------
% Description: constructs a FISHTRANS instance.
% Input:       (1) An empty default fishtrans is formed.
%              (2) {ft0} fishtrans instance. In this case {ft} would be an
%                  identical copy.
%              (3) {no_instances} integer. In this case {ft} would be an
%                  empty fishtrans vector of length {no_instances}.
%              (4) {vsm} vsmatrix instance.
%                  {which_grp} determines the grouping in {dm} that should
%                       be used. See grouping/isolate for further help.
%                  <{opt_name},{opt_val}> pairs of options that modify the
%                       algorithm. Available options are
%                       'ratio' - the kind of ratio to take in the
%                           optimization process, either 'Sb/Sw' (def) or
%                           'Sb/St'.
%                       'constraints' - here {opt_val} is a matrix of {p}
%                           vectors v1,v2,...,vp arranged columnwise. The
%                           FISHTRANS is then required to be orthogonal to
%                           span(v1,v2,...,vp), and is denoted
%                           orthogonal-Fisher (oFisher). By default no
%                           constraints are used.
%                       'preprocess' - Let X be the data matrix. If
%                           'preprocess' is 'center' (default), then X is
%                           centered. If it is 'standardize', then X is
%                           standardized. Otherwise, 'preprocess' should be
%                           'none'.
% Output:      {ft} instance(s) of the FISHTRANS class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 06-Dec-2006

% switch on number of input arguments
if nargin == 0    % case (1)
    lt = lintrans;                      % lintrans object
    lt = set(lt,'type','Fisher');       % change type to 'Fisher'
    ft.ratio = 'Sb/Sw';                 % either 'Sb/Sw' or 'Sb/St'
    ft.ortho_constraints = [];          % orthogonality constraints
    ft = class(ft,'fishtrans',lt);
elseif isa(varargin{1},'fishtrans')     % case (3)
    error(nargchk(1,1,nargin));
    ft = varargin{1};
elseif isa(varargin{1},'double')        % case (2)
    error(nargchk(1,1,nargin));
    ft = [];
    for ii = 1:varargin{1}
        ft = [ft fishtrans];
    end
else                                    % case (4)
    error(nargchk(2,5,nargin));
    % initialize
    ft = fishtrans;
    % first input argument
    dm = varargin{1};
    error(chkvar(dm,'vsmatrix','scalar',{mfilename,'',1}));
    % second input argument
    gr = isolate(dm.groupings,varargin{2});
    % defaults
    ratio = 'Sb/Sw';
    preprocess = 'center';
    V = [];
    for ii = 3:2:nargin
        errmsg = {mfilename,inputname(ii+1),ii+1};
        switch str2keyword(varargin{ii},3)
            case 'rat'   % option: ratio
                error(chkvar(varargin{ii+1},'char',...
                    {'vector',{'match',{'Sb/Sw','Sb/St'}}},errmsg));
                ratio = varargin{ii+1};
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
        type = 'Fisher';
    else
        type = 'Orthogonal Fisher';
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
    % find discriminant vectors and project back to full space
    [U e_vals] = fish_engin(data_reduced,gr,1,ratio);
    U = [V trans*U];
    e_vals = [zeros(dim_reduced,1) ; e_vals];
    % prepare names of original variables
    variableset = sampleset(dm.variables(:).name);
    variableset = set(variableset,'name','Variables','description',...
        'Names of original variables');
    % prepare names of discriminant vectors
    list = [];
    for ii = 1:dim_reduced
        list = [list {sprintf('Orthogonal Constraint #%d',ii)}];
    end
    for ii = dim_reduced+1:length(e_vals)
        list = [list {sprintf('Discriminant Vector #%d',ii-dim_reduced)}];
    end
    factorset = sampleset(list);
    factorset = set(factorset,'name','Discriminant Vectors',...
        'description','Names of discriminant vectors');
    % prepare scores as vsmatrix
    vars = variable(U.'*data);
    for ii = 1:length(vars)
        vrii = instance(vars,num2str(ii));
        vrii = set(vrii,'name',list{ii},'level','numerical');
        vars(ii) = vrii;
    end
    if isempty(dm.name)
        name = sprintf('%s',type);
    else
        name = sprintf('%s of %s datamatrix',type,dm.name);
    end
    if isempty(dm.description)
        desc = [];
    else
        desc = sprintf('data description: %s',dm.description);
    end
    dm = set(dm,'name',name,'description',desc,'variables',vars,...
        'sampleset',dm.sampleset,'groupings',dm.groupings);
    % substitute everything in the class
    ft = set(ft,'type',type,'U',U,'eigvals',e_vals,...
        'f_eigvals',unit(e_vals,1),'factorset',factorset,...
        'variableset',variableset,'no_samples',size(data,2),...
        'scores',dm,'ratio',ratio,'ortho_constraints',V,...
        'preprocess',prep);
end