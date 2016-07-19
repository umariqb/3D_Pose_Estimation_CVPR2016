function [lap, deg] = ssm2lap(ssm)

% SSM2LAP transforms ssmatrix to Laplacian (and Degree).
% ------------------------
% [lap deg] = ssm2lap(ssm)
% ------------------------
% Description: transforms ssmatrix to Laplacian (and Degree).
% Input:       {ssm} ssmatrix instance.
% Output:      {lap} the Laplacian matrix. The diagonal of {ssm} is
%                 zeroed, and the diagonal elements of {lap} are the sum
%                 of the corresponding rows of {ssm}. The off-diagonal
%                 elements are minus the same values in {ssm}. If {ssm} is
%                 not symmetric, {lap} wouldn't be symmetric too.
%              {deg} is the degree matrix (diagonal matrix, with the same
%                 diagonal as the Laplacian).

% © Liran Carmel
% Classification: Conversions
% Last revision date: 02-Sep-2004

% parse input line
error(chkvar(ssm,{},'scalar',{mfilename,inputname(1),1}));

% get weight matrix, zero its diagonal, and create a Laplacian
wgt = ssm.matrix;
wgt = wgt - diag(diag(wgt));
lap = diag(sum(wgt,1)) - wgt;

% create Degree matrix
if nargout > 1
    deg = diag(diag(lap));
end