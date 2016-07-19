function vr = transform(varargin)

% TRANSFORM transforms variable data.
% --------------------------------------
% vr = transform(vr, trans_type, params)
% --------------------------------------
% Description: transforms variable data.
% Input:       {vr} VARIABLE instance(s).
%              <{trans_type},p1,p2,...> can be of three basic forms:
%                   1. a string specifying reserved keyword, which can be
%                      any of:
%                           'none' - nothing happens (def). No parameters
%                               should be supplied.
%                           'center' - variable is centered. No parameters
%                               should be supplied. Means are returned in
%                               {params} as a vector of
%                               {no_variables}-by-1.
%                           'standardize' - variable is standardized. No
%                               parameters should be supplied. Means and
%                               stds are returned in {params} as a matrix
%                               of {no_variables}-by-2.
%                           'recenter',mean - used for centering data
%                               when the mean is known to be {mean}, so
%                               that data -> data - mean. {mean} should be
%                               a vector of length {no_variables}.
%                           'restandardize',params - used for standardizing
%                               data when both the mean (params(1)) and the
%                               standard deviation (params(2)) are known,
%                               so that data -> (data - mean)/std. params
%                               should be of size {no_variables}-by-2.
%                   2. an inline function that should be used as
%                      trans_type(data,params), where {data} stands for
%                      the varaible data, and {params} is a double-cell
%                      array that provides optional additional parameters,
%                      such that params{ii}{jj} is the jj'th parameter of
%                      the ii'th variable.
%                   3. a function handle that should be used as
%                      feval(trans_type,data,params), where {data}
%                      stands for the variable data, and {params} is a
%                      double-cell array that provides optional additional
%                      parameters, such that params{ii}{jj} is the jj'th
%                      parameter of the ii'th variable.
% Output:      {vr} updated instance(s).

% © Liran Carmel
% Classification: Transformations
% Last revision date: 07-Mar-2006

% parse input
[vr trans_fun params] = parseInput(varargin{:});

% switch on the type of functin
if isa(trans_fun,'char')                % function = string
    % loop on all instances
    switch str2keyword(trans_fun,4)
        case 'none'
            % do nothing
        case 'cent'
            for ii = 1:numel(vr)
                mu = vr(ii).mean.sample;
                vr(ii).data = vr(ii).data - mu;
                vr(ii).transformations = [vr(ii).transformations ...
                        struct('name','center','parameters',mu)];
                vr(ii).minmax.sample = vr(ii).minmax.sample - mu;
                vr(ii).minmax.population = vr(ii).minmax.population - mu;
                vr(ii).mean.population = vr(ii).mean.population - mu;
                vr(ii).mean.sample = 0;
            end
        case 'stan'
            for ii = 1:numel(vr)
                mu = vr(ii).mean.sample;
                st = sqrt(vr(ii).variance.sample);
                vr(ii).data = (vr(ii).data - mu) / st;
                vr(ii).transformations = [vr(ii).transformations ...
                        struct('name','standardize','parameters',[mu st])];
                vr(ii).minmax.sample = (vr(ii).minmax.sample - mu) / st;
                vr(ii).minmax.population = ...
                    (vr(ii).minmax.population - mu) / st;
                vr(ii).mean.population = ...
                    (vr(ii).mean.population - mu) / st;
                vr(ii).mean.sample = 0;
                vr(ii).variance.population = ...
                    vr(ii).variance.population / vr(ii).variance.sample;
                vr(ii).variance.sample = 1;
            end
        case 'rece'
            for ii = 1:numel(vr)
                mu = params(ii);
                vr(ii).data = vr(ii).data - mu;
                vr(ii).transformations = [vr(ii).transformations ...
                        struct('name','recenter','parameters',mu)];
                vr(ii).minmax.sample = vr(ii).minmax.sample - mu;
                vr(ii).minmax.population = vr(ii).minmax.population - mu;
                vr(ii).mean.population = vr(ii).mean.population - mu;
                vr(ii).mean.sample = vr(ii).mean.sample - mu;
            end
        case 'rest'
            for ii = 1:numel(vr)
                mu = params(ii,1);
                st = params(ii,2);
                vr(ii).data = (vr(ii).data - mu) / st;
                vr(ii).transformations = [vr(ii).transformations ...
                        struct('name','restandardize',...
                        'parameters',params(ii,:))];
                vr(ii).minmax.sample = (vr(ii).minmax.sample - mu) / st;
                vr(ii).minmax.population = ...
                    (vr(ii).minmax.population - mu) / st;
                vr(ii).mean.population = ...
                    (vr(ii).mean.population - mu) / st;
                vr(ii).mean.sample = (vr(ii).mean.sample - mu) / st;
                vr(ii).variance.population = ...
                    vr(ii).variance.population / st^2;
                vr(ii).variance.sample = vr(ii).variance.sample / st^2;
            end
        otherwise
            error('%s: Unfamiliar transformation',trans_fun);
    end
elseif isa(trans_fun,'inline')          % function = inline
    for ii = 1:numel(vr)
        if isempty(params)
            vr(ii).data = trans_fun(vr(ii).data);
            vr(ii).minmax.sample = trans_fun(vr(ii).minmax.sample);
            vr(ii).minmax.population = trans_fun(vr(ii).minmax.population);
        else
            vr(ii).data = trans_fun(vr(ii).data,params{ii}{:});
            vr(ii).minmax.sample = ...
                trans_fun(vr(ii).minmax.sample,params{ii}{:});
            vr(ii).minmax.population = ...
                trans_fun(vr(ii).minmax.population,params{ii}{:});
        end
        vr(ii).transformations = [vr(ii).transformations ...
                struct('name',char(trans_fun),'parameters',{params{ii}})];
        vr(ii).mean.population = NaN;
        vr(ii).mean.sample = computemean(vr(ii));
        vr(ii).variance.population = NaN;
        vr(ii).variance.sample = computevariance(vr(ii));
    end
else                                    % function = function_handle
    for ii = 1:numel(vr)
        if isempty(params)
            vr(ii).data = feval(trans_fun,vr(ii).data);
            vr(ii).minmax.sample = feval(trans_fun,vr(ii).minmax.sample);
            vr(ii).minmax.population = ...
                feval(trans_fun,vr(ii).minmax.population);
            vr(ii).transformations = [vr(ii).transformations ...
                struct('name',func2str(trans_fun),'parameters',[])];
        else
            vr(ii).data = feval(trans_fun,vr(ii).data,params{ii});
            vr(ii).minmax.sample = ...
                feval(trans_fun,vr(ii).minmax.sample,params{ii});
            vr(ii).minmax.population = ...
                feval(trans_fun,vr(ii).minmax.population,params{ii});
            vr(ii).transformations = [vr(ii).transformations ...
                struct('name',func2str(trans_fun),...
                'parameters',{params{ii}})];
        end
        vr(ii).mean.population = NaN;
        vr(ii).mean.sample = computemean(vr(ii));
        vr(ii).variance.population = NaN;
        vr(ii).variance.sample = computevariance(vr(ii));
    end
end

% #########################################################################
function [vr, trans_fun, params] = parseInput(varargin)

% PARSEINPUT parses input line.
% --------------------------------------------
% [vr trans_fun params] = parseInput(varargin)
% --------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {vr} variable instance.
%              {trans_fun} transformation inline function.
%              {params} parameters for the inline function.

% first argument is always a VARIABLE
vr = varargin{1};

% second argument is, if exists, the transformation function
trans_fun = 'none';
if nargin > 1
    error(chkvar(varargin{2},{'inline','function_handle','char'},...
        'vector',{mfilename,'',2}));
    trans_fun = varargin{2};
end

% next arguments, if exist, are the parameters of the transformation
% function
params = [];
no_vars = numel(vr);
if isa(trans_fun,'char')    % function is a reserved string
    switch str2keyword(trans_fun,4)
        case {'none','cent','stan'}     % no parameters provided
        case 'rece'     % recenter
            error(nargchk(3,3,nargin));
            error(chkvar(varargin{3},'double',...
                {'vector',{'length',no_vars}},{mfilename,'',3}));
            params = varargin{3};
        case 'rest'     % restandardize
            error(nargchk(3,3,nargin));
            error(chkvar(varargin{3},'double',...
                {'matrix',{'size',[no_vars 2]}},{mfilename,'',3}));
            params = varargin{3};
    end
else    % function is function_handle or inline
    if nargin > 2
        error(chkvar(varargin{3},'cell',{'vector',{'length',no_vars}},...
            {mfilename,'',3}));
        params = varargin{3};
        for ii = 1:no_vars'
            error(chkvar(params{ii},'cell',{},...
                {mfilename,'parameter list of each variable',0}));
        end        
    end
end