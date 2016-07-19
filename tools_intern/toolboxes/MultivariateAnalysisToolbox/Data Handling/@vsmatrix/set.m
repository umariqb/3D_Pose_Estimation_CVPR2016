function vsm = set(vsm,varargin)

% SET set method
% -------------------------------------------------
% vsm = set(vsm, property_name, property_value,...)
% -------------------------------------------------
% Description: sets field values.
% Input:       {vsm} vsmatrix instance.
%              {property_name},{property_value} legal pairs.
% Output:      {vsm} updated vsmatrix instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Feb-2007

% first argument is assured to be the vsmatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(vsm);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'samp'     % field: sampleset
            ss = varargin{ii+1};
            if isa(ss,'cell')
                ss = sampleset(ss);
            end
            error(chkvar(ss,'sampleset','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vsm(jj).sampleset = ss;
                vsm(jj).datamatrix = setnocols(vsm(jj).datamatrix,...
                    nosamples(ss));
            end
        case 'vari'     % field: variables
            error(chkvar(varargin{ii+1},'variable','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vsm(jj).variables = varargin{ii+1};
                vsm(jj).datamatrix = setnorows(vsm(jj).datamatrix,...
                    length(varargin{ii+1}));
            end
        case 'grou'     % field: groupings
            error(chkvar(varargin{ii+1},'grouping','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vsm(jj).groupings = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                vsm(jj).datamatrix = set(vsm(jj).datamatrix,...
                    varargin{ii},varargin{ii+1});
            end
    end
end

% do not allow for empty sampleset
if novariables(vsm) && ~nosamples(vsm)
    no_samples = nosamples(vsm.variables);
    no_samples = no_samples(1);
    vsm = set(vsm,'sampleset',defsampleset(no_samples));
end