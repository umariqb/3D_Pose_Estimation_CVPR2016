function [nnidx, dists]=ann_queryTree(handle,Points,k,varargin)

% some predicates
is_normal_matrix = @(x) isnumeric(x) && ndims(x) == 2 && isreal(x) && ~issparse(x);
is_posint_scalar = @(x) isnumeric(x) && isscalar(x) && x == fix(x) && x > 0;
is_switch = @(x) islogical(x) && isscalar(x);
is_float_scalar = @(x) isfloat(x) && isscalar(x); 

% Xr and Xq
require_arg(is_normal_matrix(Points), 'Points should be a full numeric real matrix');
        
[d, n] = size(Points);

% options
opts = struct( ...
    'use_bdtree', true, ...
    'bucket_size', 8, ...
    'split', 'suggest', ...
    'shrink', 'suggest', ...
    'search_sch', 'std', ...
    'eps', 0.1, ...
    'radius', 0);

if ~isempty(varargin)
    opts = setopts(opts, varargin{:});
end

require_opt(is_switch(opts.use_bdtree), 'The option use_bdtree should be a logical scalar.');
require_opt(is_posint_scalar(opts.bucket_size), 'The option bucket_size should be a positive integer.');

split_c = get_name_code('splitting rule', opts.split, ...
                        {'std', 'midpt', 'sl_midpt', 'fair', 'sl_fair', 'suggest'});

if opts.use_bdtree                    
    shrink_c = get_name_code('shrinking rule', opts.shrink, ...
                             {'none', 'simple', 'centroid', 'suggest'});
else
    shrink_c = int32(0);
end

ssch_c = get_name_code('search scheme', opts.search_sch, ...
                        {'std', 'pri', 'fr'});

require_opt(is_float_scalar(opts.eps) && opts.eps >= 0, ...
            'The option eps should be a non-negative float scalar.');

use_fix_rad = strcmp(opts.search_sch, 'fr');
if use_fix_rad
    require_opt(is_float_scalar(opts.radius) && opts.radius > 0, ...
                'The option radius should be a positive float scalar in fixed-radius search');
    rad2 = opts.radius  * opts.radius;
else
    rad2 = 0;
end
        
%% main (invoking ann_mex)

internal_opts = struct( ...
    'use_bdtree', opts.use_bdtree, ...
    'bucket_size', int32(opts.bucket_size), ...
    'split', split_c, ...
    'shrink', shrink_c, ...
    'search_sch', ssch_c, ...
    'knn', int32(k), ...
    'err_bound', opts.eps, ...
    'search_radius', rad2);

[nnidx, dists] = ann_mex_bk(2, handle, Points, internal_opts);

nnidx = nnidx + 1;        % from zero-based to one-based        
if nargout >= 2
    dists = sqrt(dists);  % from squared distance to euclidean
    
    if use_fix_rad
        dists(nnidx == 0) = inf;
    end
end