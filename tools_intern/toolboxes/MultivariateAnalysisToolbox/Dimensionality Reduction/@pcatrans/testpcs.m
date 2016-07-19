function p_val = testpcs(pc,q_factor,U0)

% TESTPCS tests whether the PCs fit a predefined form.
% ---------------------------------
% p_val = testpcs(pc, q_factor, U0)
% ---------------------------------
% Description: tests the hypothesis that PC_1, ..., PC_q have prespecified
%              form {U0}, see eq. (6.11) in Flury.
% Input:       {pc} PCATRANS instance.
%              {q_factor} denotes which is the last factor in the list.
%              {U0} matrix of {no_variables}-by-{q_factor} specifying the
%                   form of the factors.
% Output:      {p_val} p-value of the test.

% © Liran Carmel
% Classification: Inference
% Last revision date: 21-Jan-2005

% parse input
error(nargchk(3,3,nargin));
error(chkvar(pc,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(q_factor,'integer',...
    {'scalar',{'greaterthan',0},{'eqlower',nofactors(pc)}},...
    {mfilename,inputname(2),2}));
error(chkvar(U0,'double',...
    {'matrix',{'size',[novariables(pc) q_factor]}},...
    {mfilename,inputname(3),3}));

% retrive information
p = nofactors(pc);
e_vals = eigvals(pc);
e_vecs = get(pc,'u');

% build the {theta} matrix [see (6.10)]
e_vals_mat = e_vals * ones(1,p);
warning('off','MATLAB:divideByZero');
theta = e_vals_mat .* e_vals_mat' ./ (e_vals_mat - e_vals_mat').^2;
theta(isinf(theta)) = 0;
warning('on','MATLAB:divideByZero');

% build the statistic
stat = 0;
for jj = 1:(q_factor-1)
    for hh = (jj+1):q_factor
        stat = stat + ( e_vecs(:,hh)' * U0(:,jj) - ...
            e_vecs(:,jj)' * U0(:,hh) )^2 / theta(jj,hh);
    end
end
stat = 0.25 * stat;
for jj = 1:q_factor
    for hh = (q_factor+1):p
        stat = stat + (e_vecs(:,hh)' * U0(:,jj))^2 / theta(jj,hh);
    end
end
stat = nosamples(pc) * stat;
    
% find p_value
dof = q_factor * (p - (q_factor+1)/2);
p_val = 1 - chi2cdf(stat,dof);

