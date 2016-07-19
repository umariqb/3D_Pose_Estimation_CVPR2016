function vsm = transform(vsm,vars,varargin)

% TRANSFORM transforms vsmatrix data.
% ---------------------------------------------------
% vsm = transform(vsm, vars, trans_type, p1, p2, ...)
% ---------------------------------------------------
% Description: transforms variables in a coordinate-based matrix.
% Input:       {vsm} instance(s) of the vsmatrix class.
%              {vars} which variables to transform. [] or 'all' designate
%                   to operate on all variables.
%              <{trans_type},{p1,p2,...}> are identical to the arguments
%                   with the same name in VARIABLE/TRANSFORM and are passes
%                   as are to this function. Look there for further help.
% Output:      {vsm} updated instance(s).

% © Liran Carmel
% Classification: Transformations
% Last revision date: 19-Jan-2005

% parse input line
error(nargchk(2,Inf,nargin));
error(chkvar(vsm,'vsmatrix','vector',{mfilename,inputname(1),1}));
[msg1 is_char] = chkvar(vars,'char',{'vector',{'match',{'all'}}},...
    {mfilename,inputname(2),2});
if is_char
    vars = 1:novariables(vsm);
else
    [msg2 is_int] = chkvar(vars,'integer','vector',{mfilename,inputname(2),2});
    if is_int
        if isempty(vars)
            vars = 1:get(vsm,'no_variables');
        else
            error(chkvar(vars,{},{{'eqlower',novariables(vsm)}},...
                {mfilename,inputname(2),2}));
        end
    else
        error('%s\n%s',msg1,msg2);
    end
end

% loop on all instances
for ii = 1:length(vsm)
    % extract variables
    vr = vsm(ii).variables;
    if length(vr) == 1      % a single variable
        vr = transform(vr,varargin{:});
    else
        vr(vars) = transform(vr(vars),varargin{:});
    end
    vsm(ii) = set(vsm(ii),'variables',vr);
end