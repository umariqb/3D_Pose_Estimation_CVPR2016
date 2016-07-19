function varargout = hist(first,second,varargin)

% HIST computes and plots the histogram of a variable.
% -------------------------
% [N X] = hist(ax, vr, M/X)
% -------------------------
% Description: computes and plots the histogram of a variable.
% Input:       see HIST, except that {vr} replaces {Y}.
% Output:      see HIST.

% © Liran Carmel
% Classification: Characteristics of variable
% Last revision date: 05-Oct-2004

% discriminate between HIST(ax,...) and HIST(Y,...)
switch class(first)
    case 'double'
        % switch between number of output parameters
        switch nargout
            case 0
                hist(first,second.data,varargin{:});
            case 1
                varargout{1} = hist(first,second.data,varargin{:});
            case 2
                [varargout{1} varargout{2}] = ...
                    hist(first,second.data,varargin{:});
        end
    case 'variable'
        % switch between number of output parameters
        switch nargout
            case 0
                if nargin == 1
                    hist(first.data);
                else
                    hist(first.data,second,varargin{:});
                end
            case 1
                if nargin == 1
                    varargout{1} = hist(first.data);
                else
                    varargout{1} = hist(first.data,second,varargin{:});
                end
            case 2
                if nargin == 1
                    [varargout{1} varargout{2}] = hist(first.data);
                else
                    [varargout{1} varargout{2}] = ...
                        hist(first.data,second,varargin{:});
                end 
        end
    otherwise
        error('%s: Unrecognized type of the first variable',class(first));
end