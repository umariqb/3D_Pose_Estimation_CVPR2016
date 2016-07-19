function [t, z] = nom2num(varargin)

% NOM2NUM assigns numerical values to categories (labeling).
% -------------------------------------------
% [t, z] = nom2num(gr, data, h_level, method)
% -------------------------------------------
% Description: Let us have a numerical variable for which we know the
%              values of {n} samples x_1,...,x_n. Let us have {g} groups.
%              We would like to assign a number {t_i} to each group, and to
%              construct a vector z_1,...,z_n such  that {z_i}={t_j} if
%              sample {i} belongs to the {j}'th group. If we use the 'mean'
%              method, we find the numbers {t_i} such that the linear
%              correlation between {x} and {z} is maximal, under the
%              constraints that {z} has zero mean and unit variance. If we
%              use the 'median' method, the result may not be optimal, but
%              may be better as an approximate to the vector {z} that gives
%              a maximal Spearman correlation.
% Input:       {gr} grouping instance.
%              {data} any number, {no_variables}, of vectors x_1,...,x_n,
%                   either in the form of a vector of variable objects, or
%                   in the form of a variables-by-samples matrix.
%              <{h_level}> which hierarchy to consider (def=1).
%              <{method}> can be chosen from among:
%                   'mean'   - based on the intra-group means (def).
%                   'median' - based on the intra-group medians.
% Output:      {t} a {no_variables}-by-{g} matrix of the (t_1,...,t_g)'s.
%              {z} a {no_variables}-by-{n} matrix of the (z_1,...,z_n)'s.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 04-Jul-2004

% parse input line
[gr data h_level method] = parse_input(varargin{:});

% initialize
[no_variables no_samples] = size(data);
no_groups = nogroups(gr,h_level);
t = zeros(no_variables,no_groups);
z = zeros(no_variables,no_samples);

% switch on methods
switch method
    case 'mean'
        % work variable by variable
        for ii = 1:no_variables
            % find means and sizes
            mu_data = gmean(gr,data(ii,:),h_level);
            grp_size = groupsize(gr,h_level);
            % assign t's
            fact = 1 / sqrt(sum(grp_size.*mu_data.^2) / (no_samples-1));
            t(ii,:) = fact * mu_data;
            % assign z's
            for jj = 1:no_groups
                z(ii,grp2samp(gr,gr.gcn2gid{h_level}(jj),h_level)) = t(ii,jj);
            end
        end
    case 'median'
        % work variable by variable
        for ii = 1:no_variables
            % find medians and sizes
            med_data = gmedian(gr,data(ii,:),h_level);
            grp_size = groupsize(gr,h_level);
            % assign t's
            mn = grp_size * med_data' / no_samples;
            med_data = med_data - mn;
            st = sqrt(grp_size * (med_data.^2)');
            if st
                t(ii,:) = med_data / st;
            else
                t(ii,:) = 0;
            end
            % assign z's
            for jj = no_groups
                z(ii,grp2samp(gr,gr.gcn2gid{h_level}(jj),h_level)) = t(ii,jj);
            end
        end
end

% #########################################################################
function [gr, data, h_level, method] = parse_input(varargin)

% PARSE_INPUT parses input line.
% ------------------------------------------------
% [gr data h_level method] = parse_input(varargin)
% ------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {gr} grouping instance.
%              {data} variables-by-samples standardized data matrix.
%              {h_level} hierarchy level.

% verify number of arguments
error(nargchk(2,4,nargin));

% first argument is the grouping
gr = varargin{1};
error(chkvar(gr,{},'scalar',{mfilename,'',1}));

% second argument is the data
[msg1 is_num] = chkvar(varargin{2},'numeric',{},{mfilename,'',2});
if is_num
    data = varargin{2};
    no_samples = nosamples(gr);
    error(chkvar(data,{},{'matrix',{'no_cols',no_samples}},{mfilename,'',2}));
    % normalize data
    data = (data - mean(data,2)*ones(1,no_samples)) ./ ...
        (std(data,0,2)*ones(1,no_samples));
else
    [msg2 is_var] = chkvar(varargin{2},'variable',{},{mfilename,'',2});
    if is_var
        vr = transform(varargin{2},'standardize');
        data = [];
        for ii = 1:length(vr)
            vrii = instance(vr,num2str(ii));
            data = [data ; vrii(1:end)];
        end
    else
        error('%s\n%s',msg1,msg2);
    end
end

% additional arguments are optional
h_level = 1;
method = 'mean';
for ii = 3:nargin
    [msg1 is_num] = chkvar(varargin{ii},'numeric',{},{mfilename,'',ii});
    if is_num
        error(chkvar(varargin{ii},'integer',...
            {'scalar',{'eqlower',gr.no_hierarchies},{'greaterthan',0}},...
            {mfilename,'',ii}));
        h_level = varargin{ii};
    else
        [msg2 is_char] = chkvar(varargin{ii},'char',{},{mfilename,'',ii});
        if is_char
            error(chkvar(varargin{ii},{},{{'match',{'mean','median'}}},...
                {mfilename,'',ii}));
            method = varargin{ii};
        else
            error('%s\n%s',msg1,msg2);
        end
    end
end