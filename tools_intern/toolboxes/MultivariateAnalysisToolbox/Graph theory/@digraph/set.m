function dg = set(dg,varargin)

% SET set method
% -----------------------------------------------
% dg = set(dg, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values.
% Input:       {dg} digraph instance.
%              {property_name},{property_value} legal pairs.
% Output:      {dg} updated digraph instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 03-Dec-2004

% first argument is assured to be the digraph. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(dg);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'weig'     % field: weights
            error(chkvar(varargin{ii+1},'numeric',{'matrix','square'},errmsg));
            % loop on instances
            for jj = 1:no_instances
                dg(jj).graph = set(dg(jj).graph,'weights',varargin{ii+1});
                no_edges = computenoedges(varargin{ii+1},dg(jj).thd);
                dg(jj).graph = setnoedges(dg(jj).graph,no_edges);
            end
        case 'thd '
            error(chkvar(varargin{ii+1},'numeric',{'matrix','square'},errmsg));
            % loop on instances
            for jj = 1:no_instances
                dg(jj).thd = varargin{ii+1};
                no_edges = computenoedges(get(dg(jj).graph,'weights'),...
                    varargin{ii+1});
                dg(jj).graph = setnoedges(dg(jj).graph,no_edges);
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                dg(jj).graph = set(dg(jj).graph,varargin{ii},varargin{ii+1});
            end
    end
end