function [norm] = normOfColumns(A)

norm    = sqrt(sum((A.^2),1));