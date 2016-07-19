function [U, lamb] = fish_engin(data, gr, h_level, ratio)

% FISH_ENGIN performs Fisher transformation of a grouped dataset.
% -----------------------------------------------
% [U lamb] = fish_engin(data, gr, h_level, ratio)
% -----------------------------------------------
% Description: performs PCA analysis on the data.
% Input:       {data} multivariate data matrix (either coordinate-based or
%                   pairwise-relationships based).
%              {gr} grouping instance.
%              {h_level} hierarchy level.
%              {ratio} either 'Sb/St' or 'Sb/Sw'.
% Output:      {U} the transformation matrix.
%              {lamb} the eigenvalues associated with the principal axes.

% © Liran Carmel
% Classification: Linear transformations
% Last revision date: 13-Jul-2005

% find inter-group covariance matrix
Sb = gcovinter(gr,data,h_level);

% find Fisher vectors
switch ratio
    case 'Sb/St'
        error('unavailable yet');
    case 'Sb/Sw'
        Sw = gcovintra(gr,data,h_level,'ml');
        [U lamb] = eig(Sb,Sw);
end
lamb = diag(lamb);

% avoid negligible imaginary parts
if ~isreal(U)
    warning('Multivariate:FisherComplex',...
        'Complex eigenvalues/eigenvectors. Ignoring imaginary parts')
    lamb = real(lamb);
    U = real(U);
end

% Sort by eigenvalues
no_grp = nogroups(gr,h_level);
[lamb idx] = sort(lamb);
lamb = flipud(lamb);
U = fliplr(U(:,idx));
if length(lamb) > no_grp - 1
    lamb = lamb(1:no_grp-1);
    U = U(:,1:no_grp-1);
end

% normalize eigenvectors
for ii = 1:size(U,2);
    U(:,ii) = unit(U(:,ii));
end