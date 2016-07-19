function [mu, Lam, Psi, llike] = fa_engin(data, no_factors, algorithm)

% FA_ENGIN performs factor analysis on the data.
% -----------------------------------------------------
% [mu Lam Psi ll] = fa_engin(data, no_factors, algorithm)
% -----------------------------------------------------
% Description: performs factor analysis on the data.
% Input:       {data} multivariate (coordinate-based) data matrix.
%              {no_factors} number of latent variables.
%              {algorithm} either 'em'.
% Output:      {mu} estimate of Mu.
%              {Lam} estimate of Lambda.
%              {Psi} estimate of Psi.
%              {ll} log-likelihood as function of the iteration.

% © Liran Carmel
% Classification: Linear transformations
% Last revision date: 30-Sep-2004

% important information
no_samples = size(data,2);

% decide between algorithms
switch algorithm
    case 'em'
        %% hard-coded parameters
        tol = 1e-3;
        I = eye(no_factors);
        
        %% Initialization:
        % inference on {mu}
        mu = mean(data,2);
        % center the data
        data = data - repmat(mu,1,no_samples);
        %{
        % perfrom PCA, remove redundent factors from the transformation
        % matrix, and verify unit variance of the scores
        [Lam eigs] = pca_engin(data,'rectangular','cov');
        Lam = Lam(:,1:no_factors);
        eigs = eigs(1:no_factors);
        Lam = Lam * diag(sqrt((no_samples-1)./eigs));
        LLT = Lam * Lam';
        % now compute the data explained by the factors. Remember that the
        % (unit variance) scores are just Lam'*data, and the data explained
        % by them is just Lam*scores, so that data_explained = LLT*data.
        data_exp = LLT * data;
        Psi = var(data_exp-data,0,2);
        %}
        [Lam Psi]=factoran(data',2,'scores','regr');
        
        %% Compute initial log-likelihood and auxiliary matrices.
        iPsi = diag(1./Psi);
        auxMat1 = I + Lam'*iPsi*Lam;
        auxMat2 = inv(auxMat1);
        auxMat3 = auxMat2*Lam'*iPsi;
        auxMat4 = iPsi - iPsi*Lam*auxMat3;
        auxDet = prod(Psi)*det(auxMat1);
        ll = -no_samples*log(auxDet);
        for ii = 1:no_samples
            ll = ll - data(:,ii)' * auxMat4 * data(:,ii);
        end
        llike = ll;
        
        %% start iterations
        ll_prev = ll/(1-2*tol);
        while (ll_prev-ll)/ll_prev > tol
            % update previous log-likelihood
            ll_prev = ll;
            % E-step
            Ex = auxMat3*data;
            SExxt = no_samples*auxMat2;
            for ii = 1:no_samples
                SExxt = SExxt + Ex(:,ii)*Ex(:,ii)';
            end
            % M-step
            term1 = 0;
            for ii = 1:no_samples
                term1 = term1 + data(:,ii)*Ex(:,ii)';
            end
            Lam = term1 * inv(SExxt);
            term1 = 0;
            term2 = 0;
            for ii = 1:no_samples
                term1 = term1 + data(:,ii)*data(:,ii)';
                term2 = term2 + Ex(:,ii)*data(:,ii)';
            end
            Psi = 1/no_samples * diag(term1 - Lam*term2);
            % recompute the auxiliary matrices and the likelihood
            iPsi = diag(1./Psi);
            auxMat1 = I + Lam'*iPsi*Lam;
            auxMat2 = inv(auxMat1);
            auxMat3 = auxMat2*Lam'*iPsi;
            auxMat4 = iPsi - iPsi*Lam*auxMat3;
            auxDet = prod(Psi)*det(auxMat1);
            ll = -no_samples*log(auxDet);
            for ii = 1:no_samples
                ll = ll - data(:,ii)' * auxMat4 * data(:,ii);
            end
            llike = [llike ll];
        end
end