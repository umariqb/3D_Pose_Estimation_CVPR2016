function ss = sampleset(varargin)

% SAMPLESET constructor method
% ------------------------------------------------
% (1) ss = sampleset()
% (2) ss = sampleset(no_instances)
% (3) ss = sampleset(ss0)
% (4) ss = sampleset(list);
% (5) ss = sampleset(field_name, field_value, ...)
% ------------------------------------------------
% Description: constructs a sampleset instance.
% Input:       (1) An empty default sampleset is formed, identified by
%                  having zero number of samples.
%              (2) {no_instances} integer. In this case {ss} would be an
%                  empty sampleset vector of length {no_instances}.
%              (2) {ss0} sampleset instance. In this case {ss} would be an
%                  identical copy.
%              (4) {list} cell array or character array. In this case {ss},
%                  the sample names are drawn from {list}.
%              (5) pairs of field names accompanied by their corresponding
%                  values. Supported fields are 'name', 'description',
%                  'source', and 'sample_names'.
% Output:      {ss} an instance of the sampleset class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 30-Oct-2006

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    ss.name = 'unnamed';        % name of the sample set
    ss.description = '';        % description of the sample set
    ss.source = '';             % source of information
    ss.sample_names = {};       % names of samples (empty when unknown)
    ss.no_samples = 0;          % number of samples
    ss = class(ss,'sampleset');
elseif nargin == 1  % cases (2)-(4)
    if isa(varargin{1},'double')        % case (2)
        ss = [];
        for ii = 1:varargin{1}
            ss = [ss sampleset];
            ss(ii).name = sprintf('Sample Set #%d',ii);
        end
    elseif isa(varargin{1},'sampleset') % case (3)
        ss = varargin{1};
    elseif isa(varargin{1},'cell')      % case (4)
        ss = sampleset;
        ss.sample_names = varargin{1};
        ss.no_samples = length(varargin{1});
    elseif isa(varargin{1},'char')      % case (4)
        ss = sampleset;
        ss.sample_names = forcerow(cellstr(varargin{1}));
        ss.no_samples = size(varargin{1},1);
    else
        error('unrecognized input argument');
    end
else        % case (5)
    error(chkvar(nargin,{},'even',{mfilename,'Number of Arguments',0}));
    % initialize a default instance
    ss = sampleset;
    % substitute properties
    for ii = 1:2:nargin
        error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii}));
        errmsg = {mfilename,'',ii+1};
        switch str2keyword(varargin{ii},4)
            case 'name'     % field: name
                error(chkvar(varargin{ii+1},'char','vector',errmsg));
                % do not allow empty name
                if isempty(varargin{ii+1})
                    ss.name = 'unnamed';
                else
                    ss.name = varargin{ii+1};
                end
            case 'desc'     % field: description
                error(chkvar(varargin{ii+1},'char','vector',errmsg));
                ss.description = varargin{ii+1};
            case 'sour'     % field: source
                error(chkvar(varargin{ii+1},'char','vector',errmsg));
                ss.source = varargin{ii+1};
            case 'samp'     % field: sample_names
                samp_names = forcerow(cellstr(varargin{ii+1}));
                error(chkvar(samp_names,'cell','vector',errmsg));
                ss.sample_names = samp_names;
                ss.no_samples = length(samp_names);
            case 'no_s'     % field: no_samples
                error('NO_SAMPLES: field is read-only');
        end
    end
end