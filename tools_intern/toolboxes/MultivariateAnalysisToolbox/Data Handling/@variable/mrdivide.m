function vr = mrdivide(vr,a)

% MRDIVIDE divides a variable by a scalar
% -----------
% vr = vr / a
% -----------
% Description: Let {vr} be a variable, and let {a} be any numerical scalar.
%              Then vr / a is just like vr(1:end) / a.
% Input:       {vr} variable instance.
%              {a} numerical scalar.
% Output:      {vr} output variable instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 13-Dec-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vr,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(a,'numerical','scalar',{mfilename,inputname(2),2}));
if isnominal(vr)
    error('division is not defined for nominal variables');
end

% compute result
vr = set(vr,'data',vr.data/a);