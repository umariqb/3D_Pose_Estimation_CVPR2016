function p_val = testredundancy(pc,factors,variables)

% TESTREDUNDANCY tests the redundancy hypothesis.
% ----------------------------------------------
% p_val = testredundancy(pc, factors, variables)
% ----------------------------------------------
% Description: tests the redundancy hypothesis, see eq. (6.23) in Flury.
% Input:       {pc} PCATRANS instance.
%              {factors} factors in which we look for redundancy.
%              <{variables}> variables suspected in redundancy. If absent,
%                   a redundancy test is carried out for each variable
%                   separatly, generating the list of p_values.
% Output:      {p_val} p-value of the test.

% © Liran Carmel
% Classification: Inference
% Last revision date: 18-Jan-2005

% parse input
error(nargchk(2,3,nargin));
error(chkvar(pc,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(factors,'integer',...
    {'vector',{'greaterthan',0},{'eqlower',nofactors(pc)}},...
    {mfilename,inputname(2),2}));
if nargin == 2
    p_val = [];
    for ii = 1:novariables(pc)
        p_val = [p_val testredundancy(pc,factors,ii)];
    end
    return;
else
    error(chkvar(variables,'integer',...
        {'vector',{'greaterthan',0},{'eqlower',novariables(pc)}},...
        {mfilename,inputname(3),3}));
end

% retrive information
e_vals = eigvals(pc);
e_vecs = get(pc,'u');

% build the {theta} matrix [see (6.10)]
not_factors = allbut(factors,nofactors(pc));
l_factors = length(factors);
l_not_factors = length(not_factors);
e_vals_j = e_vals(factors) * ones(1,l_not_factors);
e_vals_h = ones(l_factors,1) * e_vals(not_factors)';
theta = e_vals_j .* e_vals_h ./ (e_vals_j - e_vals_h).^2;

% build the statistic
stat = 0;
for jj = 1:l_factors
    jj_factor = factors(jj);
    tmp = 0;
    for hh = 1:l_not_factors
        hh_factor = not_factors(hh);
        tmp = tmp + theta(jj,hh) * ...
            e_vecs(variables,hh_factor) * e_vecs(variables,hh_factor)';
    end
    stat = stat + e_vecs(variables,jj_factor)' * inv(tmp) * ...
        e_vecs(variables,jj_factor);
end
stat = nosamples(pc) * stat;

% find p_value
p_val = 1 - chi2cdf(stat,l_factors*length(variables));

