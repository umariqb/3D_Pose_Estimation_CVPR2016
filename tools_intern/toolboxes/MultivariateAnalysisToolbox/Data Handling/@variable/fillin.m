function vr = fillin(varargin)

% FILLIN fills missing data.
% ----------------------------------
% vr = fillin(vr, algorithm, params)
% ----------------------------------
% Description: fills missing data.
% Input:       {vr} VARIABLE instance.
%              {algorithm, params} is a pair of the algorithm name and its
%                   parameters. can be either
%                   1. 'mean' - fills in the mean of the variable. No
%                       additional parameter are needed.
%                   2. 'median' - fills in the median of the variable. No
%                       additional parameter are needed.
% Output:      {vr} filled VARIABLE.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 10-Oct-2005

% parse input line
[vr alg pp] = parse_input(varargin{:});

% swithc on the algorithm
switch str2keyword(alg,3)
    case 'mea'
        if isscalar(vr)
            val = mean(vr);
            if isnan(val)
                warning('The variable %s contains only missing data',...
                    vr.name);
            end
            vr = fillinval(vr,val);
        else
            val = mean(vr);
            for ii = 1:length(val)
                if isnan(val(ii))
                    warning('The variable %s contains only missing data',...
                        vr(ii).name);
                end
                vr(ii) = fillinval(vr(ii),val(ii));
            end
        end
    case 'med'
        if isscalar(vr)
            val = median(vr);
            if isnan(val)
                warning('The variable %s contains only missing data',...
                    vr.name);
            end
            vr = fillinval(vr,val);
        else
            val = median(vr);
            for ii = 1:length(val)
                if isnan(val(ii))
                    warning('The variable %s contains only missing data',...
                        vr(ii).name);
                end
                vr(ii) = fillinval(vr(ii),val(ii));
            end
        end
end

% #########################################################################
function [vr, alg, pp] = parse_input(varargin)

% PARSE_INPUT parses input line.
% -----------------------------------
% [vr alg pp] = parse_input(varargin)
% -----------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {vr} VARIABLE instance.
%              {alg} type of algorithm.
%              {pp} parameters of the algorithm.

% verify number of arguments
error(nargchk(2,3,nargin));

% first argument is always the variable(s)
vr = varargin{1};

% second argument is always the algorithm
alg = varargin{2};
error(chkvar(alg,'char',...
    {'vector',{'match',{'mean','median'}}},{mfilename,'',2}));

% third argument is not mandatory and currently inactive.
pp = [];

% #########################################################################
function vr = fillinval(vr,val)

% FILLINVAL fills in a certain value in a scalar variable.
% -----------------------
% vr = fillinval(vr, val)
% -----------------------
% Description: fills in a certain value in a scalar variable.
% Input:       {vr} variable with (potentially) missing data.
%              {val} val to put instead of missing data.
% Output:      {vr} filled VARIABLE.

vec = vr.data;
vec(isnan(vec)) = val;
vr = set(vr,'data',vec);