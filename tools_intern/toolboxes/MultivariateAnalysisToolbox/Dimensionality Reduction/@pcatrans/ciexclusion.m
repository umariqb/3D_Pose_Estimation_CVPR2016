function upper_bound = ciexclusion(pc,no_comps,alph)

% CIEXCLUSION computes upper CI for excluding last principal components.
% ---------------------------------------------------------
% upper_bound = ciexclusion(pc, no_comps_to_exclude, alpha)
% ---------------------------------------------------------
% Description: Let {p} be the number of principal components, and let
%              0 < {q} <= {p} integer. The relative contribution of the
%              last {p - q} principal components to the overall scatter can
%              be bounded in [0,upper_bound] for any confidence level
%              {alpha}, see eq. (5.13) in Flury.
% Input:       {pc} PCATRANS instance.
%              {no_comps_to_exclude} number of last principal components
%                   that we want to exclude from the model. If a vector
%                   (say, 2:4) the computation is repeated for each entry
%                   separately (i.e., exclusion of 2, 3, and 4 last PCs).
%                   If [], all possible exclusions (no_factors-1):-1:1 are
%                   considered.
%              {alpha} 1 - alpha is the significance level (this is the
%                   traditional definition).
% Output:      {upper_bound} upper bound of the CI.

% © Liran Carmel
% Classification: Inference
% Last revision date: 05-Feb-2005

% parse input
error(nargchk(2,4,nargin));
error(chkvar(pc,{},'scalar',{mfilename,inputname(1),1}));
% second argument is always the number of components to exclude
if isempty(no_comps)
    no_comps = (nofactors(pc)-1):-1:1;
else
    error(chkvar(no_comps,'integer',...
        {'vector',{'eqgreater',0},{'lowerthan',nofactors(pc)}},...
        {mfilename,inputname(2),2}));
end
% third argument is the significance level
error(chkvar(alph,'double',...
    {'scalar',{'greaterthan',0},{'lowerthan',1}},...
    {mfilename,inputname(3),3}));

% find q,p
p = nofactors(pc);
q = p - no_comps;

% compute upper bound
no_exclusions = length(no_comps);
upper_bound = zeros(1,no_exclusions);
gam = norminv(alph) * sqrt(2 / nosamples(pc));
e_vals = eigvals(pc);
e_vals2 = e_vals.^2;
for ii = 1:no_exclusions
    sum_first = sum(e_vals(1:q(ii)));
    sum_last = sum(e_vals(q(ii)+1:p));
    sum_tot = sum_first + sum_last;
    ub = sum_first^2 * sum(e_vals2(q(ii)+1:p));
    ub = ub + sum_last^2 * sum(e_vals2(1:q(ii)));
    upper_bound(ii) = sum_last/sum_tot - gam * sqrt(ub) / sum_tot^2;
end