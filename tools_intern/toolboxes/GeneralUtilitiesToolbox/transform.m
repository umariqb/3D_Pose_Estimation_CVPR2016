function data = transform(varargin)

% TRANSFORM transforms multivariate data.
% ------------------------------------------
% data = transform(data, trans_type, params)
% ------------------------------------------
% Description: transforms multivariate data.
% Input:       {data} variables-by-samples matrix.
%              <{trans_type}> can be of three basic forms:
%                   1. a string specifying reserved keyword, which can be
%                      any of 'none' (def), 'center', and 'standardize'.
%                   2. an inline function that should be used as
%                      trans_type(data,params), where {data} stands for the
%                      varaible data, and {params} are optional additional
%                      parameters.
%                   3. a function handle that should be used as
%                      feval(trans_type,data,params), where {data} stands
%                      for the variable data, and {params} are optinoal
%                      additional parameters.
%              <{params}> any number of additional parameters.
% Output:      {data} transformed data.

% © Liran Carmel
% Classification: Data manipulations
% Last revision date: 13-Dec-2006

% parse input
[data trans_fun params] = parse_input(varargin{:});
[no_vars no_samp] = size(data);

% switch on the type of function
if isa(trans_fun,'char')                % function = string
    % loop on all instances
    switch str2keyword(trans_fun,4)
        case 'none'
            % do nothing
        case 'cent'
            data = data - repmat(mean(data,2),1,no_samp);
        case 'stan'
            warning off MATLAB:divideByZero
            data = (data - repmat(mean(data,2),1,no_samp)) ./ ...
                repmat(std(data,0,2),1,no_samp);
            warning on MATLAB:divideByZero
            data(isnan(data)) = 0;
        otherwise
            error('%s: Unfamiliar transformation',upper(keyword));
    end
elseif isa(trans_fun,'inline')          % function = inline
    for ii = 1:no_vars
        if isempty(params)
            data(ii,:) = trans_fun(data(ii,:));
        else
            data(ii,:) = trans_fun(data(ii,:),params);
        end
    end
else                                    % function = function_handle
    for ii = 1:no_vars
        if isempty(params)
            data(ii,:) = feval(trans_fun,data(ii,:));
        else
            data(ii,:) = feval(trans_fun,data(ii,:),params);
        end
    end
end

% #########################################################################
function [data, trans_fun, params] = parse_input(varargin)

% PARSE_INPUT parses input line.
% -----------------------------------------------
% [data trans_fun params] = parse_input(varargin)
% -----------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {data} multivariate matrix.
%              {trans_fun} transformation inline function.
%              {params} parameters for the inline function.

% first argument is always a matrix
error(chkvar(varargin{1},'numerical','matrix',{mfilename,'',1}));
data = varargin{1};

% second argument is, if exists, the transformation function
trans_fun = [];
if nargin > 1
    error(chkvar(varargin{2},{'inline','function_handle','char'},'vector',...
        {mfilename,'',2}));
    trans_fun = varargin{2};
end

% next arguments, if exist, are the parameters of the transformation
% function
params = [];
for ii = 3:nargin
    params = [params {varargin{ii}}];
end