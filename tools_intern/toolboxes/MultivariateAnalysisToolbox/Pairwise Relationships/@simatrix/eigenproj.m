function [coords, eval] = eigenproj(sim,varargin)

% EIGENPROJ computes the eigenprojection of a similarity matrix.
% -----------------------------------------------------
% [coords eval] = eigenproj(sim, mass_flag, which_eigs)
% -----------------------------------------------------
% Description: computes the eigenprojection of a similarity matrix, by
%              finding the appropriate minimizers of the Hall energy.
% Input:       {sim} SIMATRIX instance.
%              <{mass_flag}> can be either 'no_masses' or 'masses' to
%                   instruct eigenprojections without of with masses
%                   respectively. The mass of a sample is defined as the
%                   sum of its similarity to all other samples. By default
%                   'no_masses' is assumed.
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

% first argument is the SIMATRIX instance
error(chkvar(sim,{},'scalar',{mfilename,inputname(1),1}));
% check that the matrix is square
if ~get(sim,'isroweqcol')
    error('{%s} is not a square matrix',inputname(1));
end
[lap deg] = ssm2lap(sim);
no_samples = get(sim,'no_rows');

% defaults
mass = eye(no_samples);
eigs = [2 3];

% loop on the rest of the input arguments
for ii = 2:nargin
    [msg1 is_eigs] = chkvar(varargin{ii-1},'integer','vector',...
        {mfilename,'',ii});
    if is_eigs   % which_eigs
        error(chkvar(varargin{ii-1},{},...
            {{'eqlower',no_samples},{'greaterthan',0}},...
            {mfilename,'',ii}));
        eigs = varargin{ii-1};
    else        % mass_flag
        [msg2 is_char] = chkvar(varargin{ii-1},'char','vector',...
            {mfilename,'',ii});
        if is_char
            switch str2keyword(varargin{ii-1},4)
                case 'no_m'
                    % do nothing
                case 'mass'
                    mass = deg;
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
    [evec eval] = eigs(lap,mass);   %#ok
else
    [evec eval] = eig(lap,mass);
end
eval = diag(eval);

% extract the requested eigenvectors
[eval idx] = sort(eval);
idx = idx(eigs);
coords = evec(:,idx)';
eval = eval(eigs);