function gr = set(gr,varargin)

% SET set method
% -----------------------------------------------
% gr = set(gr, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values. If {gr} is not a scalar, the same
%              property values are substituted for all instances.
% Input:       {gr} GROUPING instance(s).
%              {property_name},{property_value} legal pairs.
% Output:      {gr} updated GROUPING instance(s).

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 25-Jul-2006

% first argument is assured to be the GROUPING. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(gr);
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
                    gr(jj).name = 'unnamed';
                else
                    gr(jj).name = varargin{ii+1};
                end
            end
        case 'desc'     % field: description
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).description = varargin{ii+1};
            end
        case 'sour'     % field: source
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).source = varargin{ii+1};
            end
        case 'no_s'     % field: no_samples
            error('NO_SAMPLES: field is read-only');
        case 'no_h'     % field: no_hierarchies
            error('NO_HIERARCHIES: field is read-only');
        case 'no_g'     % field: no_groups
            error('NO_GROUPS: field is read-only');
        case 'assi'     % field: assignment
            % previously, there was a FORCEROW command here. I don't know
            % why, and it does not work well when I try to substitute a
            % multi-hierarchy assignment
            assignment = varargin{ii+1};
            error(chkvar(assignment(~isnan(assignment)),'integer','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                % compute some read-only fields
                [no_groups is_consistent gid2gcn] = ...
                    processassignment(assignment);
                idx = sorthierarchies(assignment,no_groups);
                % substitute in {gr}
                gr(jj).assignment = assignment(idx,:);
                gr(jj).no_samples = size(assignment,2);
                gr(jj).no_groups = no_groups(idx);
                gr(jj).is_consistent = is_consistent(idx);
                gr(jj).gid2gcn = gid2gcn(idx);
                gr(jj).no_hierarchies = length(idx);
                gcn2gid = cell(1,gr(jj).no_hierarchies);
                for kk = 1:gr(jj).no_hierarchies
                    gcn2gid{kk} = find(~isnan(gr(jj).gid2gcn{kk}));
                end
                gr(jj).gcn2gid = gcn2gid;
            end
        case 'nami'     % field: naming
            naming = varargin{ii+1};
            error(chkvar(varargin{ii+1},'cell','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).naming = naming;
            end
        case 'is_c'     % field: is_consistent
            error('IS_CONSISTENT: field is read-only');
        case 'gid2'     % field: gid2gcn
            error('GID2GCN: field is read-only');
        case 'gcn2'     % field: gcn2gid
            error('GCN2GID: field is read-only');
        otherwise
            error('%s: not a field of GROUPING',varargin{ii});
    end
end

% see if assignment was provided and no names were assigned
if exist('assignment','var')
    if ~exist('naming','var') || isempty(naming)    % names are empty
        for jj = 1:no_instances
            for hh = 1:gr(jj).no_hierarchies
                gr(jj).naming{hh} = defnames(gr(jj).no_groups(hh));
            end
        end
    else    % names were set too
        % make it a nested array
        if ~iscell(naming{1})
            naming = {naming};
        end
        for jj = 1:no_instances
            gr(jj).naming = naming(idx);
        end
    end
end