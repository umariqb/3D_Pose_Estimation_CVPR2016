function ds = dataset(varargin)

% DATASET constructor method
% ----------------------------------------------
% (1) ds = dataset()
% (2) ds = dataset(no_instances)
% (3) ds = dataset(ds0)
% (4) ds = dataset(field_name, field_value, ...)
% ----------------------------------------------
% Description: constructs a dataset instance.
% Input:       (1) An empty default dataset is formed, identified by
%                  having zero number of samplesets.
%              (2) {no_instances} integer. In this case {ds} would be an
%                  empty dataset vector of length {no_instances}.
%              (3) {ds0} dataset instance. In this case {ds} would be an
%                  identical copy.
%              (4) pairs of field names accompanied by their corresponding
%                  values. Supported fields are 'name', 'description',
%                  'source', 'variables', 'groupings', 'samplesets',
%                  'var2sa', and 'grp2sa'.
% Output:      {ds} instance(s) of the dataset class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 12-Aug-2005

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    ds.name = 'unnamed';                % name of dataset
    ds.description = '';                % short verbal description
    ds.source = '';                     % source of dataset
    ds.variables = [];                  % vector of variable objects
    ds.no_variables = [0 0 0 0 0];      % number of variables [nominal ordinal numeric unknown all]
    ds.groupings = [];                  % vector of grouping objects
    ds.no_groupings = 0;                % number of groupings
    ds.samplesets = [];                 % vector of sampleset objects
    ds.no_samplesets = 0;               % number of samplesets
    ds.var2sampset = [];                % variables to sampleset
    ds.grp2sampset = [];                % groupings to sampleset
    ds.matrix = [];                     % datamatrix object(s)
    ds.no_matrices = 0;                 % number of data matrices
    ds = class(ds,'dataset');
elseif nargin == 1
    if isa(varargin{1},'double')        % case (2)
        ds = [];
        for ii = 1:varargin{1}
            ds = [ds dataset];
            ds(ii).name = sprintf('Dataset #%d',ii);
        end
    elseif isa(varargin{1},'dataset')   % case (3)
        ds = varargin{1};
    else
        error('Unrecognized input argument');
    end
else    % case (4)
    error(chkvar(nargin,{},'even',{mfilename,'Number of Arguments',0}));
    % initialize a default instance
    ds = dataset;
    % substitute properties
    for ii = 1:2:nargin
        error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii}));
        switch str2keyword(varargin{ii},6)
            case 'name  '   % name of dataset, cannot be empty
                error(chkvar(varargin{ii+1},'char','vector',{mfilename,'',ii+1}));
                if isempty(varargin{ii+1})
                    ds.name = 'unnamed';
                else
                    ds.name = varargin{ii+1};
                end
            case 'source'
                error(chkvar(varargin{ii+1},'char','vector',{mfilename,'',ii+1}));
                ds.source = varargin{ii+1};
            case 'descri'
                error(chkvar(varargin{ii+1},'char','vector',{mfilename,'',ii+1}));
                ds.description = varargin{ii+1};
            case 'variab'
                error(chkvar(varargin{ii+1},'variable','vector',{mfilename,'',ii+1}));
                ds.variables = varargin{ii+1};
                for jj = 1:length(ds.variables)
                    switch ds.variables(jj).level
                        case 'nominal'
                            ds.no_variables = ds.no_variables + [1 0 0 0 1];
                        case 'ordinal'
                            ds.no_variables = ds.no_variables + [0 1 0 0 1];
                        case 'numerical'
                            ds.no_variables = ds.no_variables + [0 0 1 0 1];
                        case 'unknown'
                            ds.no_variables = ds.no_variables + [0 0 0 1 1];
                    end
                end
            case 'groupi'
                error(chkvar(varargin{ii+1},'grouping',{},{mfilename,'',ii+1}));
                ds.groupings = varargin{ii+1};
                ds.no_groupings = length(varargin{ii+1});
            case 'sample'
                error(chkvar(varargin{ii+1},'sampleset',{},{mfilename,'',ii+1}));
                ds.samplesets = varargin{ii+1};
                ds.no_samplesets = length(varargin{ii+1});
            case 'var2sa'
                error(chkvar(varargin{ii+1},'integer',{},{mfilename,'',ii+1}));
                ds.var2sampset = varargin{ii+1};
            case 'grp2sa'
                error(chkvar(varargin{ii+1},'integer',{},{mfilename,'',ii+1}));
                ds.grp2sampset = varargin{ii+1};
            otherwise
                error('%s: Unfamiliar field of DATASET',upper(varargin{ii}));
        end
    end
    % if no samplesets are fed, generate default ones
    if ~ds.no_samplesets
        if isempty(ds.variables)
            % groupings must be present
            set_size = unique(nosamples(ds.groupings));
        else
            if isempty(ds.groupings)
                set_size = unique(nosamples(ds.variables));
            else
                set_size = unique([nosamples(ds.variables) ...
                    nosamples(ds.groupings)]);
            end
        end
        ds.no_samplesets = length(set_size);
        ss = [];
        for ii = 1:ds.no_samplesets
            name_list = [];
            for jj = 1:set_size(ii)
                name = sprintf('Sample #%d',jj);
                name_list = [name_list {name}];
            end
            name = sprintf('Sampleset #%d',ii);
            ss = [ss sampleset('name',name,'sample_names',name_list)];
        end
        ds.samplesets = ss;
    end
    % guess var2sampset
    for ii = 1:length(ds)
        no_vars = novariables(ds(ii));
        if no_vars && isempty(ds(ii).var2sampset)
            ds(ii).var2sampset = guessvar2sampset(ds(ii),[]);
        end
    end
    % guess grp2sampset
    for ii = 1:length(ds)
        if ds(ii).no_groupings && isempty(ds(ii).grp2sampset)
            ds(ii).grp2sampset = guessgrp2sampset(ds(ii),[]);
        end
    end
end