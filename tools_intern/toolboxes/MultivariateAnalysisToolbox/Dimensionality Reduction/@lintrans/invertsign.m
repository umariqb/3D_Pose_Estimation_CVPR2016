function lt = invertsign(lt,which_factors)

% INVERTSIGN inverts the signs of selected factors.
% ----------------------------------
% lt = invertsign(lt, which_factors)
% ----------------------------------
% Description: inverts the signs of selected factors.
% Input:       {lt} LINTRANS instance.
%              {which_factors} indices of factors to invert.
% Output:      {lt} updated LINTRANS instance.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 13-Jan-2005

% parse input arguments
error(chkvar(lt,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(which_factors,'integer',...
    {'vector',{'greaterthan',0},{'eqlower',lt.no_factors}},...
    {mfilename,inputname(2),2}));

% invert 'U'
u = get(lt,'u');
u(:,which_factors) = -u(:,which_factors);

% invert 'scores'
sc = get(lt,'scores');
vr = sc.variables;
for ii = which_factors
    vrii = instance(vr,num2str(ii));
    data = get(vrii,'data');
    vrii = set(vrii,'data',-data);
    vr(ii) = vrii;
end
sc = set(sc,'variables',vr);

% substitute back
lt = set(lt,'u',u,'scores',sc);