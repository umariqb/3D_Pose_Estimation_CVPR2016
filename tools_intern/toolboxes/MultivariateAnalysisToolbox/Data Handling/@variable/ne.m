function binvar = ne(vr,val)

% NE element-wise logical operator.
% --------------------
% binvar = (vr ~= val)
% --------------------
% Description: Let {vr} be a variable, and let {val} be any numerical
%              value. Then, {binvar} is a binary vector of length
%              {vr.no_samples} with 1's indicating samples for which the
%              value of the variable does not equal {val}.
% Input:       {vr} variable instance.
%              {val} numerical value.
% Output:      {binvar} resulting logical vector.

% © Liran Carmel
% Classification: Operators
% Last revision date: 15-Sep-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vr,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(val,'numeric','scalar',{mfilename,inputname(2),2}));

% return value
binvar = (vr.data ~= val);