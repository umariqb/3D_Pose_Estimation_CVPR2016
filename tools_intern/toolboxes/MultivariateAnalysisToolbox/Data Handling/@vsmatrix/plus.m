function vsm = plus(vsm,operand)

% PLUS adds variables and groupings to a vsmatrix
% ------------------
% (1) vsm = vsm + vr
% (2) vsm = vsm + gr
% ------------------
% Description: allows to add a vector of variables or groupings to the
%              already exist datamatrix {vsm}. Checks that the number of
%              samples in {vr} or {gr} is compatible with the number of
%              samples in the datamatrix.
% Input:       (1) {vsm} vsmatrix instance.
%                  {vr} vector of variables.
%              (2) {vsm} vsmatrix instance.
%                  {gr} vector of groupings.
% Output:      {vsm} enlarged vsmatrix instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 05-Jan-2005

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(operand,{'variable','grouping'},'vector',{mfilename,inputname(2),2}));

% check compatibility
no_samp = nosamples(vsm);
if no_samp
    for ii = 1:length(operand)
        inst = instance(operand,num2str(ii));
        if nosamples(inst) ~= no_samp
            str = sprintf('Number of samples in %s',upper(inputname(2)));
            str = sprintf('%s should match the number of samples',str);
            error('%s in %s',str,upper(inputname(1)));
        end
    end
end

% switch according to the operand type
if isa(operand,'variable')
    vsm = set(vsm,'variables',[vsm.variables operand]);
    % do not allow for empty sampleset
    if ~no_samp
        no_samp = nosamples(vsm.variables);
        no_samp = no_samp(1);
        vsm = set(vsm,'sampleset',defsampleset(no_samp));
    end
else
    vsm = set(vsm,'groupings',[vsm.groupings operand]);
end