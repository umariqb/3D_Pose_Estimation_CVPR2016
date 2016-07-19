function vr = set(vr,varargin)

% SET set method
% -----------------------------------------------
% vr = set(vr, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values. If {vr} is not a scalar, the same
%              property values are substituted for all instances.
% Input:       {vr} VARIABLE instance.
%              {property_name},{property_value} legal pairs.
% Output:      {vr} updated VARIABLE instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Mar-2006

% first argument is assured to be the VARIABLE. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(vr);
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
                    vr(jj).name = 'unnamed';
                else
                    vr(jj).name = varargin{ii+1};
                end
            end
        case 'desc'     % field: description
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).description = varargin{ii+1};
            end
        case 'sour'     % field: source
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).source = varargin{ii+1};
            end
        case 'data'     % field: data
            error(chkvar(varargin{ii+1},'numeric','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).data = varargin{ii+1};
                vr(jj).no_samples = length(vr.data);
                vr(jj).minmax.sample = computeminmax(vr);
                vr(jj).mean.sample = computemean(vr);
                vr(jj).variance.sample = computevariance(vr);
                vr(jj).no_missing = computemissing(vr);
            end
        case 'unit'     % field: units
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).units = varargin{ii+1};
            end
        case 'no_s'     % field: no_samples
            error('NO_SAMPLES: field is read-only');
        case 'no_m'     % field: no_missing
            error('NO_MISSING: field is read-only');
        case 'leve'     % field: level
            error(chkvar(varargin{ii+1},'char',{{'match',...
                {'nominal','ordinal','numeric','numerical','unknown'}}},...
                errmsg));
            if strcmp(varargin{ii+1},'numeric')
                varargin{ii+1} = 'numerical';
            end
            % loop on instances
            for jj = 1:no_instances
                vr(jj).level = varargin{ii+1};
            end
        case 'lut '     % field: lut
            error(chkvar(varargin{ii+1},'cell','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).lut = varargin{ii+1};
            end
        case 'tran'     % field: transformations
            error('TRANSFORMATIONS: field is read-only');
        case 'minm'     % field: minmax
            error(chkvar(varargin{ii+1},'numeric',{'vector',...
                {'length',2}},errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).minmax.population = varargin{ii+1};
            end
        case 'mean'     % field: mean
            error(chkvar(varargin{ii+1},'numeric','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).mean.population = varargin{ii+1};
            end
        case 'vari'     % field: variance
            error(chkvar(varargin{ii+1},'numeric','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).variance.population = varargin{ii+1};
            end
        case 'dist'     % field: distribution
            error(chkvar(varargin{ii+1},'struct',{},errmsg));
            error(chkvar(varargin{ii+1}.name,'char',...
                {{'match',{'unknown'}}},errmsg));
            % loop on instances
            for jj = 1:no_instances
                vr(jj).distribution.name = varargin{ii+1}.name;
                switch str2keyword(vr(jj).distribution.name,4)
                    case 'unkn'
                        error(chkvar(varargin{ii+1}.parameters,...
                            'numeric',{'vector',{'size',0}},errmsg));
                        vr(jj).distribution.parameters = ...
                            varargin{ii+1}.parameters;
                end
            end
        otherwise
            error('%s: not a field of VARIABLE',upper(varargin{ii}));
    end
end