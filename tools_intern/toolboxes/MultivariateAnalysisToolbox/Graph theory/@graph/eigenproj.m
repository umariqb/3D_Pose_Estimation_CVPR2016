function [coords, eval] = eigenproj(gr,varargin)

% EIGENPROJ computes the eigenprojection of a graph.
% ----------------------------------------------------
% [coords eval] = eigenproj(gr, mass_flag, which_eigs)
% ----------------------------------------------------
% Description: computes the eigenprojection of a graph, by finding the
%              appropriate minimizers of the Hall energy.
% Input:       {gr} GRAPH instance.
%              <{mass_flag}> can be either 'no_masses' or 'masses' to
%                   instruct eigenprojections without of with masses
%                   respectively. By default 'no_masses' is assumed.
%              <{which_eigs}> the indices of requested eigenvectors
%                 (def = [2 3]).
% Output:      {coords} vectors of coordinates arranged row-wise.
%              {eval} are the corresponding (possible generalized)
%                   eigenvalues.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 13-Aug-2005

% check number of arguments
error(nargchk(1,3,nargin));

% first argument is the graph instance
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
lap = laplacian(gr);
no_nodes = gr.no_nodes;

% defaults
mass = eye(no_nodes);
eigvecs = [2 3];

% loop on the rest of the input arguments
for ii = 2:nargin
    [msg1 is_eigs] = chkvar(varargin{ii-1},'integer','vector',...
        {mfilename,'',ii});
    if is_eigs   % which_eigs
        error(chkvar(varargin{ii-1},{},...
            {{'eqlower',gr.no_nodes},{'greaterthan',0}},...
            {mfilename,'',ii}));
        eigvecs = varargin{ii-1};
    else
        [msg2 is_char] = chkvar(varargin{ii-1},'char','vector',...
            {mfilename,'',ii});
        if is_char
            switch str2keyword(varargin{ii-1},4)
                case 'no_m'
                    % do nothing
                case 'mass'
                    mass = diag(gr.node_mass);
                otherwise
                    error('%s: Unfamiliar instruction',varargin{ii-1});
            end
        else
            error('input should match either of:\n%s\n%s',msg1,msg2);
        end
    end
end

% find eigenvalues and eigenvectors of the Laplacian
if issparse(lap)
    [evec eval] = eigs(lap,mass);
else
    [evec eval] = eig(lap,mass);
end
eval = diag(eval);

% extract the requested eigenvectors
[eval idx] = sort(eval);
idx = idx(eigvecs);
coords = evec(:,idx)';
eval = eval(eigvecs);