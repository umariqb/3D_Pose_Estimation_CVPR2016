function [msg, indicator_scalar, indicator_fullsize] = chkvar(var, class_list, attr_list, var_id)

% CHKVAR verifies class and attributes of a variable.
% --------------------------------------------------------------------------------------
% [msg indicator_scalar indicator_fullsize] = chkvar(var, class_list, attr_list, var_id) 
% --------------------------------------------------------------------------------------
% Description: verifies class and attributes of a variable.
% Input:       {var} any variable.
%              {class_list} cell array of allowed classes. Can be any
%                 user-defined class, Matlab class, or the keywords
%                    'numeric' - the collection of {'double', 'single',
%                                'uint8', 'int8', 'uint16', 'int16',
%                                'uint32', 'int32','logical'}.
%                    'integer' - the collection of {'uint8', 'int8',
%                                'uint16', 'int16', 'uint32', 'int32',
%                                'logical'}.
%                    'binary'  - either a logical variable or a 0/1
%                                integer.
%              {attr_list} cell array of attributes. Can be any of the
%                 following keywords
%                    'even'   - checks for even numbers.
%                    'odd'    - checks for odd numbers.
%                    'vector' - checks that the variable is a vector. A
%                               scalar is considered as a vector. An empty
%                               variable is considered as a vector. If the
%                               variable is a multidimensional array, it is
%                               still considered as vector if only one of
%                               the dimensions is larger than 1. The next
%                               item in {attr_list} may be the required
%                               length of the vector.
%                    'scalar' - checks that the variable is a scalar. An
%                               empty variable is considered a scalar. If
%                               the variable is a multidimensional array,
%                               it is still considered as scalar if all the
%                               dimensions are exactly 1.
%                    'match',list  - checks that the variable equals
%                               one the entries in {list}.
%                    'sumto',1 - check that the sum of elements along
%                               columns is 1. 
%                    'symmetric' - check that a matrix is symmetric.
%                    'length',len - checks that the variable is a vector of
%                               of a certain length.
%                    'maxlength',len - checks that the variable is a vector
%                               of maximal length {len}.
%                    'minlength',len - checks that the variable is a vector
%                               of minimal length {len}.
%                    'size',sz - checks that the variable is of a certain
%                               size.
%                    'no_rows',rows - checks that the variable has a
%                               certain number of rows.
%                    'no_cols',cols - checks that the variable has a
%                               certain number of columns.
%                    'eqlower',val - all elements are equal to or lower
%                               than {val}.
%                    'eqgreater',val - all elements are equal to or greater
%                               than {val}.
%                    'greaterthan',val - all elements are greater than
%                               {val}.
%              <{var_id}> a three-element cell array used for a formatted
%                 error message, comprising of {func_name, var_name,
%                 var_location}. {func_name} is the name of the m-file
%                 where the variable was checked, {var_name} is the name of
%                 the inspected variable, and {var_location} is the
%                 location of the variable in the input line. If
%                 {func_name} of {var_name} are irrelevant, '' can be used,
%                 and if {var_location} is irrelevant, 0 can be used.
% Output:      {msg} a formatted error message.
%              {indicator_scalar} logical scalar variable (when true/flase
%                 answer is required).
%              {indicator_fullsize} logical variable of the same size as
%                 {var}, with 1 where {var} has all the attributes and 0
%                 otherwise.

% © Liran Carmel
% Classification: Variable verification
% Last revision date: 02-Jun-2005

% check number of variables
error(nargchk(3,4,nargin));

% default {var_id}
if nargin == 3
    var_id = {'','',0};
end
func_name = var_id{1};
var_name = var_id{2};
var_location = var_id{3};
% determine {var_name} which would be either "VARIABLE_NAME", or
% "VARIABLE_NAME (4th variable)" or just "4th variable".
if isempty(var_name)
    switch var_location
        case 0
            % do nothing
        case 1
            var_name = '1st variable';
        case 2
            var_name = '2nd variable';
        otherwise
            var_name = [num2str(var_location) 'th variable'];
    end
else
    switch var_location
        case 0
            % do nothing
        case 1
            var_name = sprintf('%s (1st variable)',upper(var_name));
        case 2
            var_name = sprintf('%s (2nd variable)',upper(var_name));
        case 3
            var_name = sprintf('%s (3rd variable)',upper(var_name));
        otherwise
            var_name = sprintf('%s (%dth variable)',upper(var_name),var_location);
    end
end

% make the variables cell arrays
if ~iscell(class_list)
    class_list = {class_list};
end
if ~iscell(attr_list)
    attr_list = {attr_list};
end

% check class
[msg indicator_scalar] = chkclass(var,class_list,func_name,var_name);

% check attributes
[attr_msg indicator indicator_fullsize] = ...
    chkattr(var,attr_list,func_name,var_name);

% merge results of class checking and attribute checking
indicator_scalar = indicator_scalar & indicator;
if isempty(msg)
    msg = attr_msg;
elseif ~isempty(attr_msg)
    msg = sprintf('%s\n%s',msg,attr_msg);
end

% #########################################################################
function [msg, indicator] = chkclass(var,class_list,func_name,var_name)

% CHKCLASS verifies class of a variable
% ----------------------------------------------------------------
% [msg indicator] = chkclass(var, class_list, func_name, var_name)
% ----------------------------------------------------------------
% Description: verifies class of a variable.
% Input:       {var} any variable.
%              {class_list} cell array of allowed classes (see main help).
%              {func_name} name of m-file where the variable is checked.
%              {var_name} name of variable under inspection.
% Output:      {msg} error message.
%              {indicator} 1 where {var} is of class from {class_list}, 0 
%                 otherwise.

% initialize error message
msg = [];

% do not check anything if {var} is empty
if isempty(var)
    indicator = true;
    return;
end

% do not check anything if {class_list} is empty
if isempty(class_list)
    indicator = true;
    return;
end

% initialize binary indicator
indicator = false;

% return true if {var} belongs to any of the classes in {class_list}
for cls = 1:length(class_list)
    if strcmpi(class_list{cls},'numeric') && ...
            (isa(var,'numeric') || isa(var,'logical'))
        indicator = true;
        break;
    elseif strcmpi(class_list{cls},'numerical') && ...
            (isnumeric(var) || islogical(var))
        indicator = true;
        break;
    elseif strcmpi(class_list{cls},'integer') && ...
            (isinteger(var) || islogical(var))
        indicator = true;
        break;
    elseif strcmpi(class_list{cls},'binary')
        lastwarn('');   % resets last warning
        warning('off','MATLAB:conversionToLogical');  % shuts down warning
        var = logical(var);     %#ok
        if isempty(lastwarn)
            indicator = true;
        else
            indicator = false;
        end
        warning('off','MATLAB:conversionToLogical');  % restores warning
        break;
    elseif isa(var,class_list{cls})
        indicator = true;
        break;
    end
end

% generate error message
if ~indicator
    str_list = class_list{1};
    for ii = 2:length(class_list)
        str_list = sprintf('%s, %s',str_list,class_list{ii});
    end
    msg = cls_error_message(func_name,var_name,str_list);
end

% #########################################################################
function msg = cls_error_message(func_name,var_name,cls_string)

% CLS_ERROR_MESSAGE generates error message for nonmatching class
% --------------------------------------------------------
% msg = cls_error_message(func_name, var_name, cls_string) 
% --------------------------------------------------------
% Description: generates error message for nonmatching class.
% Input:       {func_name} name of m-file where the variable is checked.
%              {var_name} name of variable under inspection.
%              {cls_string} class-specific descriptor.
% Output:      {msg} error message.

% print message
if isempty(func_name)
    msg = 'CHKVAR class failure:';
else
    msg = sprintf('%s: CHKVAR class failure:',func_name);
end
msg = sprintf('%s %s is expected to be of class(es) %s',msg,var_name,cls_string);

% #########################################################################
function flag = isinteger(arg)

% ISINTEGER chekcs if a variable is integer
% ---------------------
% flag = isinteger(arg)
% ---------------------
% Description: chekcs if a variable is integer.
% Input:       {arg} any variable (argument).
% Output:      {flag} 1 if {arg} is integer, 0 otherwise.

% return true if {arg} is integer
switch class(arg)
    case {'double','single'}
        flag = all(floor(arg(:)) == arg(:)) && all(isfinite(arg(:)));
    case {'uint8','int8','uint16','int16','uint32','int32','logical'}
        flag = true;
    otherwise
        flag = false;
end

% #########################################################################
function [msg, indicator_scalar, indicator_fullsize] = ...
    chkattr(var,attr_list,func_name,var_name)

% CHKATTR verifies attributes of a variable
% ---------------------------------------------------------------
% [msg indicator_scalar indicator_fullsize] =
%     chkclass(var, attr_list, func_name, var_name, var_location) 
% ---------------------------------------------------------------
% Description: verifies attributes of a variable.
% Input:       {var} any variable.
%              {attr_list} cell array of known attributes (see main help).
%              {func_name} name of m-file where the variable is checked.
%              {var_name} name of variable under inspection.
% Output:      {msg} error message.
%              {indicator_scalar} logical scalar variable (when true/flase
%                 answer is required).
%              {indicator_fullsize} logical variable of the same size as
%                 {var}, with 1 where {var} has all the attributes and 0
%                 otherwise.

% initialization
msg                = [];
indicator_scalar   = true;
indicator_fullsize = ones(size(var));

% do not check anything if {var} is empty
if isempty(var)
    return;
end

% do not check anything if {attr_list} is empty
if isempty(attr_list)
    return;
end

% return true if {var} is characterized by all attributes in {attr_list}
for attr = 1:length(attr_list)
    if ischar(attr_list{attr})   % attribute is a string
        switch str2keyword(attr_list{attr},4)
            case 'even'
                indctr = ~rem(var,2);
                if ~all(indctr)
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,'even'));      %#ok
                end
                indicator_fullsize = indicator_fullsize & indctr;
            case 'odd '
                indctr = rem(var,2);
                if ~all(indctr)
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,'odd'));   %#ok
                end
                indicator_fullsize = indicator_fullsize & indctr;
            case 'vect'
                indctr = ( numel(var)==max(size(var)) );
                if ~indctr
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,'a vector'));      %#ok
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'scal'
                indctr = (numel(var) == 1);
                if ~indctr
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,'a scalar'));  %#ok
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'symm'
                warning('off','MATLAB:divideByZero');
                indctr = all(all(((var-var')./var) < 1e-6));
                warning('on','MATLAB:divideByZero');
                if ~indctr
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,'a symmetric matrix'));
                end
                indicator_scalar = indicator_scalar & indctr;
        end
    else    % attribute is in itself a cell-array
        switch str2keyword(attr_list{attr}{1},4)
            case 'matc'
                list = attr_list{attr}{2};
                if iscellstr(list)
                    list = char(list);
                    indctr = false;
                    attr_name = 'identical to ';
                    for ii = 1:size(list,1)
                        if strcmp(deblank(list(ii,:)),var)
                            indctr = true;
                            break;
                        end
                        attr_name = ...
                            sprintf('%s%s/',attr_name,upper(deblank(list(ii,:))));
                    end
                    attr_name(end) = [];
                else
                    indctr = zeros(size(var));
                    attr_name = 'equal';
                    for ii = 1:length(list)
                        indctr = indctr | (var==list{ii});
                        attr_name = sprintf('%s %f,',attr_name,list{ii});
                    end
                    indctr = all(indctr);
                    attr_name(end) = [];
                end
                if ~indctr
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'sumt'
                indctr = all(abs(sum(var,2)-attr_list{attr}{2})<1e-8);
                if ~indctr
                    attr_name = sprintf('sum to %f',attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'size'
                indctr = all(size(var)==attr_list{attr}{2});
                if ~indctr
                    attr_name = sprintf('of size [%d',attr_list{attr}{2}(1));
                    for ii = 1:(length(attr_list{attr}{2})-1)
                        attr_name = sprintf('%s-by-%d',attr_name,...
                            attr_list{attr}{2}(ii));
                    end
                    attr_name = sprintf('%s]',attr_name);
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'no_r'
                indctr = (size(var,1)==attr_list{attr}{2});
                if ~indctr
                    attr_name = sprintf('of %d rows',attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'no_c'
                indctr = (size(var,2)==attr_list{attr}{2});
                if ~indctr
                    attr_name = sprintf('of %d columns',attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'leng'
                indctr = (length(var) == attr_list{attr}{2});
                if ~indctr
                    attr_name = sprintf('of length %d',attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'maxl'
                indctr = (length(var) <= attr_list{attr}{2});
                if ~indctr
                    attr_name = sprintf('of length lower or equal to %d',...
                        attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'minl'
                indctr = (length(var) >= attr_list{attr}{2});
                if ~indctr
                    attr_name = sprintf('of length greater or equal to %d',...
                        attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'eqlo'
                indctr = (all(var <= attr_list{attr}{2}));
                if ~indctr
                    attr_name = sprintf('lower or equal to %d',attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'eqgr'
                indctr = (all(var >= attr_list{attr}{2}));
                if ~indctr
                    attr_name = sprintf('greater or equal to %d',attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
            case 'grea'
                indctr = (all(var > attr_list{attr}{2}));
                if ~indctr
                    attr_name = sprintf('greater than %f',attr_list{attr}{2});
                    msg = strvcat(msg,attr_error_message(func_name,...
                        var_name,attr_name));
                end
                indicator_scalar = indicator_scalar & indctr;
        end
    end
end

% #########################################################################
function msg = attr_error_message(func_name,var_name,attr_string)

% ATTR_ERROR_MESSAGE generates error message for nonmatching attributes
% ----------------------------------------------------------
% msg = attr_error_message(func_name, var_name, attr_string) 
% ----------------------------------------------------------
% Description: generates error message for nonmatching attributes.
% Input:       {func_name} name of m-file where the variable is checked.
%              {var_name} name of variable under inspection.
%              {attr_string} attribute-specific descriptor.
% Output:      {msg} error message.

% print message
if isempty(func_name)
    msg = 'CHKVAR attribute failure:';
else
    msg = sprintf('%s: CHKVAR attribute failure:',func_name);
end
msg = sprintf('%s %s is expected to be %s',msg,var_name,attr_string);