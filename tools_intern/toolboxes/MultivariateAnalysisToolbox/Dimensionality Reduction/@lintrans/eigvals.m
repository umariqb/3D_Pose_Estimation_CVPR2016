function e_vals = eigvals(lt, factors)

% EIGVALS retrieves the eigenvalues of the linear transformation.
% -----------------------------
% e_vals = eigvals(lt, factors)
% -----------------------------
% Description: retrieves the eigenvalues of the linear transformation.
% Input:       {lt} LINTRANS instance.
%              <{factors}> indicates which factors to take. If absent, all
%                   factors are taken.
% Output:      {e_vals} eigenvalues of {factors}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 17-Jan-2005

% parse input arguments
error(chkvar(lt,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    factors = 1:nofactors(lt);
else
    error(chkvar(factors,'integer',...
        {'vector',{'greaterthan',0},{'eqlower',nofactors(lt)}},...
        {mfilename,inputname(2),2}));
end

% retrieve eigenvalues
e_vals = get(lt,'eigvals')';
e_vals = e_vals(factors);
e_vals = e_vals(:);