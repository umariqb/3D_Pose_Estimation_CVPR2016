function handle=ann_buildTree(Points,varargin)

%% parse and verify input arguments


% some predicates
is_normal_matrix = @(x) isnumeric(x) && ndims(x) == 2 && isreal(x) && ~issparse(x);
is_posint_scalar = @(x) isnumeric(x) && isscalar(x) && x == fix(x) && x > 0;
is_switch = @(x) islogical(x) && isscalar(x);
is_float_scalar = @(x) isfloat(x) && isscalar(x); 

% Check Points
require_arg(is_normal_matrix(Points), 'Points should be a full numeric real matrix');
        
[d, n] = size(Points);      

% options
opts = struct( ...
    'use_bdtree', false, ...
    'bucket_size', 1, ...
    'split', 'suggest', ...
    'shrink', 'suggest', ...
    'search_sch', 'std', ...
    'eps', 0, ...
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
    'err_bound', opts.eps, ...
    'search_radius', rad2);

[handle] = ann_mex_bk(1, Points, internal_opts);