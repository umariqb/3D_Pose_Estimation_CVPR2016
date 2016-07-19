function vr = variable(varargin)

% VARIABLE constructor method
% -----------------------------------------------
% (1) vr = variable()
% (2) vr = variable(no_instances)
% (3) vr = variable(vr0)
% (4) vr = variable(data);
% (5) vr = variable(field_name, field_value, ...)
% -----------------------------------------------
% Description: constructs variable instance(s).
% Input:       (1) An empty default variable is formed, identified by
%                  having zero number of samples.
%              (2) {no_instances} integer. In this case {vr} would be an
%                  empty variable vector of length {no_instances}.
%              (3) {vr0} variable instance. In this case {vr} would be an
%                  identical copy.
%              (4) {data} variables-by-samples matrix. In this case {vr} is
%                  a vector whose length is the number of rows in {data},
%                  each element is a variable object storing the
%                  corresponding row in {data}.
%              (5) pairs of field names accompanied by their corresponding
%                  values. Supported fields are 'name', 'description',
%                  'source', 'data', 'level', 'lut', 'minmax' (of
%                  population only), 'mean' (of population only),
%                  'variance' (of population only), and 'distribution'.
    % Output:      {vr} instance(s) of VARIABLE.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 07-Mar-2006

% decide on which kind of constructor should be used
switch nargin
    case 0      % case (1)
        vr.name = 'unnamed';    % name of variable
        vr.description = '';    % short verbal description
        vr.source = '';         % source of information
        vr.data = [];           % the actual values
        vr.units = '';          % data units
        vr.no_samples = 0;      % number of samples
        vr.level = 'unknown';   % nominal/ordinal/numerical/unknown
        vr.lut = {};            % used only for nominal variable
        vr.transformations = [];  % keeps track of transformations
        vr.minmax = struct('population',[nan nan],'sample',[nan nan]);
        vr.mean = struct('population',nan,'sample',nan);
        vr.variance = struct('population',nan,'sample',nan);
        vr.distribution = struct('name','unknown','parameters',[]);
        vr.no_missing = 0;        % number of missing values
        vr = class(vr,'variable');
    case 1
        [msg1 is_var] = chkvar(varargin{1},'variable',{},{mfilename,'',1});
        if is_var   % case (3)
            vr = varargin{1};
        else
            [msg2 is_num] = chkvar(varargin{1},'numerical',{},...
                {mfilename,'',1});
            if is_num
                [msg1 is_len] = chkvar(varargin{1},'integer','scalar',...
                    {mfilename,'',1});
                if is_len   % case (2)
                    vr = [];
                    for ii = 1:varargin{1}
                        vr = [vr variable];
                        vr(ii).name = sprintf('Variable #%d',ii);
                    end
                else
                    [msg2 is_mat] = chkvar(varargin{1},{},'matrix',...
                        {mfilename,'',1});
                    if is_mat   % case (4)
                        no_vars = size(varargin{1},1);
                        vr = variable(no_vars);
                        for ii = 1:no_vars
                            vr(ii) = set(vr(ii),'data',varargin{1}(ii,:),...
                                'name',sprintf('Variable #%d',ii));
                        end
                    else
                        error('%s\n%s',msg1,msg2);
                    end
                end
            else
                error('%s\n%s',msg1,msg2);
            end
        end
    otherwise
        error(chkvar(nargin,{},'even',{mfilename,'Number of Arguments',0}));
        % initialize a default instance
        vr = variable;
        % substitute properties
        for ii = 1:2:nargin
            error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii}));
            errmsg = {mfilename,'',ii+1};
            switch str2keyword(varargin{ii},4)
                case 'name'     % field: name
                    error(chkvar(varargin{ii+1},'char','vector',errmsg));
                    % do not allow empty name
                    if isempty(varargin{ii+1})
                        vr.name = 'unnamed';
                    else
                        vr.name = varargin{ii+1};
                    end
                case 'desc'     % field: description
                    error(chkvar(varargin{ii+1},'char','vector',errmsg));
                    vr.description = varargin{ii+1};
                case 'sour'     % field: source
                    error(chkvar(varargin{ii+1},'char','vector',errmsg));
                    vr.source = varargin{ii+1};
                case 'data'     % field: data
                    error(chkvar(varargin{ii+1},'numeric','vector',errmsg));
                    vr.data = varargin{ii+1};
                    vr.no_samples = length(vr.data);
                    vr.minmax.sample = computeminmax(vr);
                    vr.mean.sample = computemean(vr);
                    vr.variance.sample = computevariance(vr);
                    vr.no_missing = computemissing(vr);
                case 'unit'     % field: units
                    error(chkvar(varargin{ii+1},'char','vector',errmsg));
                    vr.units = varargin{ii+1};
                case 'no_s'     % field: no_samples
                    error('NO_SAMPLES: field is read-only');
                case 'no_m'     % field: no_missing
                    error('NO_MISSING: field is read-only');
                case 'leve'     % field: level
                    error(chkvar(varargin{ii+1},'char',{{'match',...
                        {'nominal','ordinal','numerical','unknown','numeric'}}},...
                        errmsg));
                    vr.level = varargin{ii+1};
                case 'lut '     % field: lut
                    error(chkvar(varargin{ii+1},'cell','vector',errmsg));
                    vr.lut = varargin{ii+1};
                case 'tran'     % field: transformations
                    error('TRANSFORMATIONS: field is read-only');
                case 'minm'     % field: minmax
                    error(chkvar(varargin{ii+1},'numeric',...
                        {'vector',{'length',2}},errmsg));
                    vr.minmax.population = varargin{ii+1};
                case 'mean'     % field: mean
                    error(chkvar(varargin{ii+1},'numeric','scalar',errmsg));
                    vr.mean.population = varargin{ii+1};
                case 'vari'     % field: variance
                    error(chkvar(varargin{ii+1},'numeric','scalar',errmsg));
                    vr.variance.population = varargin{ii+1};
                case 'dist'     % field: distribution
                    error(chkvar(varargin{ii+1},'cell',{'vector',{'length',2}},...
                        errmsg));
                    error(chkvar(varargin{ii+1}{1},'char',...
                        {{'match',{'unknown'}}},errmsg));
                    vl.distribution.name = varargin{ii+1}{1};
                    switch str2keyword(val.distribution.name,4)
                        case 'unknown'
                            error(chkvar(varargin{ii+1}{2},'numeric',...
                                {'vector',{'size',0}},{mfilename,'',ii+1}));
                            vl.distribution.parameters = varargin{ii+1}{2};
                    end
                otherwise
                    error('%s: not a field of VARIABLE',varargin{ii});
            end
        end
end