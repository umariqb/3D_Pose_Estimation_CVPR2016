function lt = exclude(lt,exclude)

% EXCLUDE excludes certain factors from LINTRANS.
% -------------------------------
% lt = exclude(lt, which_factors)
% -------------------------------
% Description: excludes certain factors from LINTRANS.
% Input:       {lt} LINTRANS instance.
%              {which_factors} factors to exclude.
% Output:      {lt} modified LINTRANS.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 07-Feb-2005

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(lt,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(exclude,'integer',...
    {'vector',{'eqgreater',0},{'lowerthan',nofactors(lt)}},...
    {mfilename,inputname(2),2}));

% exclude
keep = allbut(exclude,nofactors(lt));
factorset = lt.factorset;
factorset = deletesamples(lt.factorset,exclude);
lt = set(lt,'U',lt.U(:,keep),'eigvals',lt.eigvals(keep),...
    'f_eigvals',lt.f_eigvals(keep),'factorset',factorset);
if ~isempty(lt.scores)
    sc = deletevariables(lt.scores,exclude);
    lt = set(lt,'scores',sc);
end