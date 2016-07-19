function no_variables = novariables(lt)

% NOVARIABLES retrieves the number of original variables in LINTRANS.
% ------------------------------
% no_variables = novariables(lt)
% ------------------------------
% Description: retrieves the number of original variables in LINTRANS.
% Input:       {lt} LINTRANS instance(s).
% Output:      {no_variables} number of original variables in each of the
%                   instances in {lt}. It has the same dimensions as {lt}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 18-jan-2005

% initialize
no_variables = get(lt,'no_variables');