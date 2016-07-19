function stds = stdeigvecs(varargin)

% STDEIGVECS computes the standard deviates of the PCA eigenvectors.
% ------------------------------
% stds = stdeigvecs(pc, factors)
% ------------------------------
% Description: computes the standard deviates of the PCA eigenvectors,
%              based on the asymptotic theory of PCA (assuming data are
%              normal, and large number of samples), see eq. (6.4) in
%              Flury.
% Input:       {pc} PCATRANS instance.
%              <{factors}> indicates which factors to take. If absent, all
%                   factors are taken.
% Output:      {stds} standard deviates of the eigenvectors.

% © Liran Carmel
% Classification: Inference
% Last revision date: 18-Jan-2005

stds = sqrt(vareigvecs(varargin{:}));