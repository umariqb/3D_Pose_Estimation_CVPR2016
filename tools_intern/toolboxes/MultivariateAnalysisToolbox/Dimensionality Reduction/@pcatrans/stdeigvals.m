function stds = stdeigvals(varargin)

% STDEIGVALS computes the standard deviations of the PCA eigenvalues.
% ------------------------------
% stds = stdeigvals(pc, factors)
% ------------------------------
% Description: computes the standard deviations of the PCA eigenvalues,
%              based on the asymptotic theory of PCA (assuming data are
%              normal, and large number of samples). According to this
%              theory, $\hat{lam}_j ~ N(lam_j,2*lam_j^2/n$ where $n$ is the
%              number of samples.
% Input:       {pc} PCATRANS instance.
%              <{factors}> indicates which factors to take. If absent, all
%                   factors are taken.
% Output:      {stds} standard deviations of eigenvalues.

% © Liran Carmel
% Classification: Inference
% Last revision date: 18-Jan-2005

% all parsing is done in VAREIGVALS
stds = sqrt(vareigvals(varargin{:}));