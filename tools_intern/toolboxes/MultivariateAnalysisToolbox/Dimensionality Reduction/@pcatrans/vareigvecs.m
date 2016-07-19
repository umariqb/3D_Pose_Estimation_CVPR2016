function vars = vareigvecs(pc,factors)

% VAREIGVECS computes the variance of the PCA eigenvectors.
% ------------------------------
% vars = vareigvecs(pc, factors)
% ------------------------------
% Description: computes the variance of the PCA eigenvectors,
%              based on the asymptotic theory of PCA (assuming data are
%              normal, and large number of samples), see eq. (6.4) in
%              Flury.
% Input:       {pc} PCATRANS instance.
%              <{factors}> indicates which factors to take. If absent, all
%                   factors are taken.
% Output:      {vars} variances of eigenvectors.

% © Liran Carmel
% Classification: Inference
% Last revision date: 18-Jan-2005

% parse input arguments
error(chkvar(pc,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    factors = 1:nofactors(pc);
else
    error(chkvar(factors,'integer',...
        {'vector',{'greaterthan',0},{'eqlower',nofactors(pc)}},...
        {mfilename,inputname(2),2}));
end

% retrieve PCA information
e_vecs = get(pc,'u');
e_vals = eigvals(pc);
no_factors = nofactors(pc);

% generate matrix {A}, such that A_{ij} = l_i / (l_i - l_j)^2 when i \ne j,
% and A_{ij} = 0 when i = j.
e_vals = eigvals(pc);
e_vals_mat = e_vals * ones(1,no_factors);
warning('off','MATLAB:divideByZero');
A = e_vals_mat ./ (e_vals_mat - e_vals_mat').^2;
A(isinf(A)) = 0;
warning('on','MATLAB:divideByZero');

% now the sum in (6.4) is just a matrix multiplication
vars = e_vecs.^2 * A;

% multiply by l_h / n
vars = 1/nosamples(pc) * e_vals_mat' .* vars;

% take only desired portion
vars = vars(:,factors);