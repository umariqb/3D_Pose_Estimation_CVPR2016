function vars = vareigvals(varargin)

% VAREIGVALS computes the variance of the PCA eigenvalues.
% ------------------------------
% vars = vareigvals(pc, factors)
% ------------------------------
% Description: computes the variance of the PCA eigenvalues,
%              based on the asymptotic theory of PCA (assuming data are
%              normal, and large number of samples). According to this
%              theory, $\hat{lam}_j ~ N(lam_j,2*lam_j^2/n$ where $n$ is the
%              number of samples.
% Input:       {pc} PCATRANS instance.
%              <{factors}> indicates which factors to take. If absent, all
%                   factors are taken.
% Output:      {vars} variances of eigenvalues.

% © Liran Carmel
% Classification: Inference
% Last revision date: 18-Jan-2005

% compute {e_vals}, where input parsing is already done
e_vals = eigvals(varargin{:});

% compute {vars}
vars = 2 * e_vals.^2 / nosamples(varargin{1});