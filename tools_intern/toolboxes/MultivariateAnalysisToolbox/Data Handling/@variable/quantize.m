function vr = quantize(varargin)

% QUANTIZE turns a numeric variable into a nominal one.
% ---------------------------------
% vr = quantize(vr, algorithm, lut)
% ---------------------------------
% Description: turns a numeric variable into a nominal one.
% Input:       {vr} instance(s) of the variable class.
%              {algorithm} can be one of the following cell arrays:
%                   {'equal_width',no_bins} divides the data into {no_bins}
%                       bins of equal width.
%                   {'equal_samples',no_bins} divides the data into
%                       {no_bins} bins with approximately the same number
%                       of samples.
%              <{lut}> user-specific alphanumerical description of the
%                   bins. If not supplied, default names are assigned
%                   automatically.
% Output:      {vr} updated variable.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 14-Feb-2005

% parse input line
[vr_orig alg_name alg_parameters lut] = parse_input(varargin{:});

% initialize nominal variable
vr = vr_orig;

% loop on all variables
for ii = 1:length(vr)
    % update some fields
    vr(ii).level = 'nominal';
    vr(ii).transformations = [vr(ii).transformations ...
            struct('name',sprintf('quantize (%s)',alg_name),...
            'parameters',alg_parameters)];
    % recalculate data depending on the binning algorithm
    switch alg_name
        case 'equal_width'
            % compute bins
            no_bins = alg_parameters(1);
            mnmx = vr(ii).minmax.sample;
            width = diff(mnmx) / no_bins;
            % assign default lut
            if isempty(lut)
                lut = cell(1,no_bins);
                for jj = 1:no_bins
                    mn = mnmx(1) + (jj-1)*width;
                    mx = mn + width;
                    lut{jj} = sprintf('%.2f - %.2f',mn,mx);
                end
            end
            % update fields
            vr(ii).minmax.population = [1 no_bins];
            vr(ii).mean.population = NaN;
            vr(ii).variance.population = NaN;
            vr(ii).lut = lut;
            % assign nominal values
            data = vr(ii).data;
            for jj = 1:no_bins
                th = mnmx(1) + jj*width;
                data(data<=th) = jj;
            end
            set(vr(ii),'data',data);
        case 'equal_samples'
            % compute bins
            no_bins = alg_parameters(1);
            no_samples = vr(ii).no_samples;
            width = round(no_samples/no_bins);
            % sort data
            data = vr(ii).data;
            [sdata idx] = sort(data);   %#ok
            % initialization
            vr(ii).mean.population = NaN;
            vr(ii).variance.population = NaN;
            is_lut_given = true;
            if isempty(lut)
                lut = cell(1,no_bins);
                is_lut_given = false;
            end
            % update minmax values
            mnmx = vr(ii).minmax.population;
            if isnan(mnmx(1)) || mnmx(1) < vr(ii).minmax.sample(1)
                mnmx(1) = NaN;
            else
                mnmx(1) = 1;
            end
            if isnan(mnmx(2)) || mnmx(2) > vr(ii).minmax.sample(2)
                mnmx(2) = NaN;
            else
                mnmx(2) = no_bins;
            end
            vr(ii).minmax.population = mnmx;
            % loop on bins (except for last one that may include a
            % different number of samples)
            for jj = 1:no_bins-1
                mn_idx = (jj-1)*width + 1;
                mx_idx = jj*width;
                if ~is_lut_given
                    lut{jj} = sprintf('%.2f - %.2f',data(idx(mn_idx)),...
                        data(idx(mx_idx)));
                end
                data(idx(mn_idx:mx_idx)) = jj;
            end
            % make last bin
            mn_idx = (no_bins-1)*width + 1;
            if ~is_lut_given
                lut{no_bins} = sprintf('%.2f - %.2f',data(idx(mn_idx)),...
                    data(idx(no_samples)));
            end
            data(idx(mn_idx:no_samples)) = no_bins;
            % update fields
            vr(ii).lut = lut;
            vr(ii) = set(vr(ii),'data',data);
    end
end

% #########################################################################
function [vr_orig, alg_name, alg_parameters, lut] = parse_input(varargin)

% PARSE_INPUT parses input line.
% -------------------------------------------------------------
% [vr_orig alg_name alg_parameters lut] = parse_input(varargin)
% -------------------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {vr_orig} original variable instance.
%              {alg_name} name of quantization algorithm.
%              {alg_parameters} parameters required for the algorithm.
%              {lut} lut of the nominal values.

% verify number of arguments
error(nargchk(2,3,nargin));

% first argument is always {vr_orig}
error(chkvar(varargin{1},{},'vector',{mfilename,'',1}));
vr_orig = varargin{1};

% second argument is always the algorithm
error(chkvar(varargin{2},'cell',{},{mfilename,'',2}));
alg = varargin{2};
alg_name = alg{1};
error(chkvar(alg_name,'char',{{'match',{'equal_width','equal_samples'}}},...
    {mfilename,'algorithm name',2}));
alg_parameters = alg{2};

% optional third argument
lut = [];
if nargin == 3
    error(chkvar(varargin{3},'cell',{{'length',alg_parameters(1)}},...
        {mfilename,'',3}));
    lut = varargin{3};
end