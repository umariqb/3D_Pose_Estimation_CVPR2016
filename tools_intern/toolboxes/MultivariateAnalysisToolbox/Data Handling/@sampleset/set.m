function ss = set(ss,varargin)

% SET set method
% -----------------------------------------------
% ss = set(ss, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values. If {ss} is not a scalar, the same
%              property values are substituted for all instances.
% Input:       {ss} SAMPLESET instance(s).
%              {property_name},{property_value} legal pairs.
% Output:      {ss} updated SAMPLESET instance(s).

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 11-Jan-2005

% first argument is assured to be the SAMPLESET. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(ss);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'name'     % field: name
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                % do not allow empty name
                if isempty(varargin{ii+1})
                    ss(jj).name = 'unnamed';
                else
                    ss(jj).name = varargin{ii+1};
                end
            end
        case 'desc'     % field: description
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ss(jj).description = varargin{ii+1};
            end
        case 'sour'     % field: source
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ss(jj).source = varargin{ii+1};
            end
        case 'samp'     % field: sample_names
            samp_names = cellstr(varargin{ii+1});
            error(chkvar(samp_names,'cell','vector',errmsg));
            no_samp = length(samp_names);
            % loop on instances
            for jj = 1:no_instances
                ss(jj).sample_names = samp_names;
                ss(jj).no_samples = no_samp;
            end
        case 'no_s'     % field: no_samples
            error('NO_SAMPLES: field is read-only');
        otherwise
            error('%s: not a field of SAMPLESET',varargin{ii});
    end
end