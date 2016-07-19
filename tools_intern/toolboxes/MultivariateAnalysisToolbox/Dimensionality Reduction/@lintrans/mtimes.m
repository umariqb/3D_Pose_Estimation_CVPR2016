function vsm = mtimes(lt,vsm)

% MTIMES operating with the linear transformation
% ---------------------
% vsm_out = lt * vsm_in
% ---------------------
% Description: Given a vsmatrix {vsm_in}, it is linearly transformed
%              using {lt}, giving a transformed vsmatrix {vsm_out}.
% Input:       {lt} LINTRANS instance.
%              {vsm} VSMATRIX instance.
% Output:      {vsm} transformed VSMTRIX.

% © Liran Carmel
% Classification: Operators
% Last revision date: 05-Feb-2005

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(lt,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(vsm,'vsmatrix','scalar',{mfilename,inputname(2),2}));
if novariables(lt) ~= novariables(vsm)
    error('%s and %s do not reside in the same dimension',...
        inputname(1),inputname(2));
end

% preprocess
switch lt.preprocess.name
    case 'none'
        % do nothing
    case 'center'
        vsm = transform(vsm,'all','recenter',lt.preprocess.parameters);
    case 'standardize'
        vsm = transform(vsm,'all','restandardize',lt.preprocess.parameters);
end

% transform
vr = variable(lt.U' * vsm(:,:));
for ii = 1:nofactors(lt)
    vrii = instance(vr,num2str(ii));
    vrii = set(vrii,'name',char(lt.factorset(ii)));
    vr(ii) = vrii;
end
vsm = set(vsm,'variables',vr);