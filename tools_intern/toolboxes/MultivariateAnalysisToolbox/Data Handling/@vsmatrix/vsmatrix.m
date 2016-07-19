function vsm = vsmatrix(varargin)

% VSMATRIX constructor method
% -------------------------------------------------------------------------
% (1) vsm = vsmatrix()
% (2) vsm = vsmatrix(no_instances)
% (3) vsm = vsmatrix(vsm0)
% (4) vsm = vsmatrix(vr)
% (5) vsm = vsmatrix(field_name, field_value, ...)
% (6) vsm = vsmatrix(ds, variables, samples, preprocess, var_group, lab_group)
% -------------------------------------------------------------------------
% Description: constructs a vsmatrix instance.
% Input:       (1) An empty default vsmatrix is formed, identified by
%                  having no variables.
%              (2) {no_instances} integer. In this case {vsm} would be an
%                  empty vsmatrix vector of length {no_instances}.
%              (3) {vsm0} vsmatrix instance. In this case {vsm} would be an 
%                  identical copy.
%              (4) {vr} vector of variable objects. In this case {vsm} is
%                  comprised of these variables.
%              (5) pairs of field names accompanied by their corresponding
%                  values. Supported fields are 'name', 'description',
%                  'source', 'variables', and 'groupings'.
%              (6) casting from a dataset object.
%                  {ds} dataset instance.
%                  {variables} which variables to take. Can be a list of
%                       indices, or an empty matrix ([]) instructing to
%                       take all variables, or one of the following
%                       keywords:
%                           'all'       - take all variables.
%                           'numeric'   - take only numeric variables.
%                           'numerical' - take only numeric variables.
%                           'nominal'   - take only nominal variables.
%                           'ordinal'   - take only ordinal variables.
%                           'unknown'   - take only unknown variables.
%                       if not contradicting, multiplie verbal instuctions
%                       can be made using cell array, e.g.,
%                       {'numeric','nominal'}.
%                  {samples} which samples to take. Can be a list of
%                       indices, an empty matrix ([]) instructing to take
%                       all samples, the keyword 'all' also instructing to
%                       take all samples, or the keyword 'complete'
%                       insturcting to take the maximal number of samples
%                       allowing for a complete data matrix (in accord with
%                       {variables}). Sometimes, a limited amount of
%                       missing data are allowed. For this purpose, one can
%                       use the the option 'maxmissing',{max_missing}.
%                       Here, all variables with at most {max_missing}
%                       missing entries will be included in {vsm}.
%                   <{preprocess}> data preprocessing to apply. Can take
%                       the values 'none' (def), 'center', or
%                       'standardize'.
%                   <{var_group}> variable(s) from which to generate
%                       grouping. To discriminate from the next argument,
%                       these indices should appear as the regular double
%                       type.
%                   <{lab_group}> grouping to inherit to the vsmatrix
%                       object. To discriminate from the previous argument,
%                       these indices should appear in a cell array, e.g.,
%                       {1,2}.
% Output:      {vsm} instance(s) of the vsmatrix class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 10-Oct-2005

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    dm = datamatrix;
    dm = set(dm,'type','variable-sample');
    dm = set(dm,'row_type','variables','col_type','samples');
    vsm.variables = [];     % vector of variables
    vsm.sampleset = [];     % single instance of sampleset
    vsm.groupings = [];     % vector of groupings
    vsm = class(vsm,'vsmatrix',dm);
elseif nargin == 1
    if isa(varargin{1},'double')        % case (2)
        vsm = [];
        for ii = 1:varargin{1}
            vsm = [vsm vsmatrix];
            set(vsm(ii),'name',sprintf('Matrix #%d',ii));
        end
    elseif isa(varargin{1},'vsmatrix')  % case (3)
        vsm = varargin{1};
    elseif isa(varargin{1},'variable')  % case (4)
        vsm = vsmatrix;
        vsm = vsm + varargin{1};
    else
        error('Unrecognized input argument');
    end
elseif isa(varargin{1},'char')      % case (5)
    % initialize
    error(chkvar(nargin,{},'even',{mfilename,'Number of Arguments',0}));
    vsm = vsmatrix;
    % read-in fields
    for ii = 1:2:nargin
        error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii}));
        errmsg = {mfilename,'',ii+1};
        switch str2keyword(varargin{ii},4)
            case 'name'
                error(chkvar(varargin{ii+1},'char','vector',errmsg));
                vsm = set(vsm,'name',varargin{ii+1});
            case 'desc'
                error(chkvar(varargin{ii+1},'char','vector',errmsg));
                vsm = set(vsm,'description',varargin{ii+1});
            case 'sour'
                error(chkvar(varargin{ii+1},'char','vector',errmsg));
                vsm = set(vsm,'source',varargin{ii+1});
            case 'vari'
                error(chkvar(varargin{ii+1},'variable','vector',errmsg));
                vsm = set(vsm,'variables',varargin{ii+1});
            case 'samp'
                error(chkvar(varargin{ii+1},'sampleset','scalar',errmsg));
                vsm = set(vsm,'sampleset',varargin{ii+1});
            case 'grou'
                error(chkvar(varargin{ii+1},'grouping','vector',errmsg));
                vsm.groupings = varargin{ii+1};
        end
    end
    % do not allow for empty sampleset
    if novariables(vsm) && isempty(vsm.sampleset)
        no_samples = nosamples(vsm.variables);
        no_samples = no_samples(1);
        vsm = set(vsm,'sampleset',defsampleset(no_samples));
    end
elseif isa(varargin{1},'dataset')   % case (6)
    % parse input line
    error(nargchk(2,6,nargin));
    % first variable is always {ds}
    error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
    ds = varargin{1};
    % set defaults
    rows = [];
    preprocess = 'none';
    var_group = [];
    lab_group = [];
    % second variable should be {rows}
    [msg1 is_int] = chkvar(varargin{2},'integer','vector',{mfilename,'',2});
    if is_int   % a list of indices was supplied
        rows = varargin{2};
    else        % keywords (string or cell)
        [msg2 is_char] = chkvar(varargin{2},{'char','cell'},{},...
            {mfilename,'',2});
        str = char(varargin{2});
        if is_char
            for ii = 1:size(str,1)
                switch str2keyword(str(ii,:),3)
                    case 'all'
                        rows = [];
                    case 'num'
                        rows = [rows find(isnumeric(ds.variables))];
                    case 'nom'
                        rows = [rows find(isnominal(ds.variables))];
                    case 'ord'
                        rows = [rows find(isordinal(ds.variables))];
                    case 'unk'
                        rows = [rows find(isunknown(ds.variables))];
                    otherwise
                        error('%s: Unfamiliar variables keyword %s',...
                            mfilename,upper(varargin{2}));
                end
            end
        else
            error('%s\n%s',msg1,msg2);
        end
    end
    % fill-in in case that {rows} is empty
    if isempty(rows)
        rows = 1:novariables(ds);
    end
    % make row ordered in case of multiple instructions
    rows = unique(rows);
    % check consistency
    error(chkvar(rows,{},{{'greaterthan',0},{'eqlower',novariables(ds)}},...
        {mfilename,'Variable index',0}));
    vr2ss = ds.var2sampset(rows);
    ss_idx = vr2ss(1);
    if any(vr2ss ~= ss_idx)
        error('variables belong to different samplesets');
    end
    sampset = instance(ds.samplesets,num2str(ss_idx));
    no_samples = nosamples(sampset);
    % third variable should be {cols}
    next_arg = 4;
    [msg1 is_int] = chkvar(varargin{3},'integer','vector',{mfilename,'',3});
    if is_int   % a list of indices was supplied
        cols = varargin{3};
    else        % only a single instruction possible
        [msg2 is_char] = chkvar(varargin{3},'char',{},{mfilename,'',3});
        if is_char
            switch str2keyword(varargin{3},3)
                case 'all'  % all
                    cols = [];
                case 'com'  % complete
                    merge_idx = ones(1,no_samples);
                    for ii = rows
                        idx = find(isnan(ds.variables(ii,:)));
                        merge_idx(idx) = 0;
                    end
                    cols = find(merge_idx==1);
                    if isempty(cols)
                        error('vsmatrix contains zero samples');
                    end
                case 'max'  % maxmissing
                    error(chkvar(varargin{4},'integer','scalar',...
                        {mfilename,'',4}));
                    next_arg = 5;
                    merge_idx = zeros(1,no_samples);
                    for ii = rows
                        idx = find(isnan(ds.variables(ii,:)));
                        merge_idx(idx) = merge_idx(idx) + 1;
                    end
                    cols = find(merge_idx <= varargin{4});
                    if isempty(cols)
                        error('vsmatrix contains zero samples');
                    end
                otherwise
                    error('%s: Unfamiliar samples keyword %s',...
                        mfilename,upper(varargin{3}));
            end
        else
            error('%s\n%s',msg1,msg2);
        end
    end
    % fill-in in case that {cols} is empty
    if isempty(cols)
        cols = 1:no_samples;
    end
    % adapt sampset
    sampset = deletesamples(sampset,allbut(cols,no_samples));
    % check consistency
    error(chkvar(cols,{},{{'greaterthan',0},{'eqlower',no_samples}},...
        {mfilename,'Sample index',0}));
    % check next variables, if exist
    for ii = next_arg:nargin
        [msg1 is_char] = chkvar(varargin{ii},'char','vector',{mfilename,'',ii});
        if is_char
            switch str2keyword(varargin{4},3)
                case 'cen'
                    preprocess = 'center';
                case 'sta'
                    preprocess = 'standardize';
                case 'non'
                    preprocess = 'none';
                otherwise
                    error('%s: Unfamiliar preprocess type',varargin{4});
            end
        else
            [msg2 is_int] = chkvar(varargin{ii},'integer','vector',...
                {mfilename,'',ii});
            if is_int
                var_group = varargin{ii};
                % check consistency
                error(chkvar(var_group,{},{{'eqlower',novariables(ds)}},...
                    {mfilename,'',ii}));
                vr2ss = ds.var2sampset(var_group);
                if any(vr2ss ~= ss_idx)
                    error('grouping variable belongs to a different sampleset');
                end
            else
                [msg3 is_cell] = chkvar(varargin{ii},'cell','vector',...
                    {mfilename,'',ii});
                if is_cell
                    for jj = 1:length(varargin{ii})
                        lab_group = [lab_group varargin{ii}{jj}];
                    end
                    % check consistency
                    error(chkvar(lab_group,'integer',...
                        {'vector',{'eqlower',nogroupings(ds)}},...
                        {mfilename,'',ii}));
                    gr2ss = ds.grp2sampset(lab_group);
                    if any(gr2ss ~= ss_idx)
                        error('groupings belong to a different sampleset');
                    end
                else
                    error('%s\n%s\n%s',msg1,msg2,msg3);
                end
            end
        end
    end
    % initialize vsmatrix
    vsm = vsmatrix;
    % substitute sampleset
    vsm = set(vsm,'sampleset',sampset);
    % substitute variables
    vars = [];
    for ii = 1:length(rows)
        vr = instance(ds.variables,num2str(rows(ii)));
        vr = set(vr,'data',vr(cols));
        vars = [vars vr];
    end
    vars = transform(vars,preprocess);
    vsm = set(vsm,'variables',vars);
    % substitute grouping
    gr = [];
    for ii = 1:length(var_group)
        gr = [gr grouping(ds.variables(var_group(ii)),cols)];
    end
    if ~isempty(lab_group)
        to_delete = allbut(cols,no_samples);
        if length(lab_group) == 1
            gr = [gr deletesamples(ds.groupings,to_delete)];
        else
            for ii = lab_group
                gr = [gr deletesamples(ds.groupings(ii),to_delete)];
            end
        end
    end
    vsm = set(vsm,'grouping',gr);
else
    error('1st input argument is not of recognizable type')
end