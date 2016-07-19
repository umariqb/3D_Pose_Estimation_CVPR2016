function subs = tt_ind2sub(siz,idx)
%TT_IND2SUB Multiple subscripts from linear indices.
%
%   See also TT_SUB2IND, IND2SUB.
%
%MATLAB Tensor Toolbox.
%Copyright 2007, Sandia Corporation. 

% This is the MATLAB Tensor Toolbox by Brett Bader and Tamara Kolda. 
% http://csmr.ca.sandia.gov/~tgkolda/TensorToolbox.
% Copyright (2007) Sandia Corporation. Under the terms of Contract
% DE-AC04-94AL85000, there is a non-exclusive license for use of this
% work by or on behalf of the U.S. Government. Export of this data may
% require a license from the United States Government.
% The full license terms can be found in tensor_toolbox/LICENSE.txt
% $Id: tt_ind2sub.m,v 1.6 2007/01/10 01:27:30 bwbader Exp $

k = [1 cumprod(siz(1:end-1))];
n = length(siz);
idx = idx - 1;
for i = n : -1 : 1
    subs(:,i) = floor(idx / k(i)) + 1;
    idx = rem(idx,k(i));
end
