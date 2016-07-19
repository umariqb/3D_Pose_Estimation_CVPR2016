function [U, lamb] = pca_engin(data, matrix_type, algorithm)

% PCA_ENGIN performs PCA analysis on the data.
% --------------------------------------------------
% [U lamb] = pca_engin(data, matrix_type, algorithm)
% --------------------------------------------------
% Description: performs PCA analysis on the data.
% Input:       {data} multivariate data matrix (either coordinate-based or
%                   pairwise-relationships based).
%              {matrix_type} either 'rectangular' or 'square' to
%                   discriminate between coordinate-based matrices and
%                   pairwise-relationships ones.
%              {algorithm} either 'svd', 'svds' or 'cov'. 'cov' uses the
%                   eigenvectors of the covariance matrix, 'svd' and 'svds'
%                   use SVD of the original data matrix, and therefore can
%                   be used only when {matrix_type} is rectangular. 'svds'
%                   finds the PCs consecutively up to MIN(# variables, #
%                   samples - 1). This option is useful when the # samples 
%                   is much smaller than the # variables.
% Output:      {U} the transformation matrix.
%              {lamb} the eigenvalues of the covariance matrix.

% © Liran Carmel
% Classification: Linear transformations
% Last revision date: 28-Nov-2005

% find principal components
switch algorithm
    case 'svd'
        [U lamb V] = svd(data);
        lamb = diag(lamb).^2;	   % from singular values to eigenvalues
        lamb = lamb / (size(data,2)-1);
    case 'svds'
        [no_variables no_samples] = size(data);
        [U lamb V] = svds(data,min(no_variables,no_samples-1));
        lamb = diag(lamb).^2;	   % from singular values to eigenvalues
        lamb = lamb / (no_samples - 1);
    case 'cov'
        switch matrix_type
            case 'rectangular'
                [U lamb] = eig(data*data');
                [lamb idx] = sort(diag(lamb),'descend');
                lamb = lamb / (size(data,2)-1);
                U = U(:,idx);
            case 'square'
                [U lamb] = eig(data);
                [lamb idx] = sort(diag(lamb),'descend');
                U = U(:,idx);
        end
end