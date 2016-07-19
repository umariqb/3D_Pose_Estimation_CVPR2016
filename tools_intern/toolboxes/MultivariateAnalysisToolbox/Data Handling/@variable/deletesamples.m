function vr = deletesamples(vr,to_remove)

% DELETESAMPLES eliminate samples from a variable instance(s).
% ---------------------------------
% vr = deletesamples(vr, to_remove)
% ---------------------------------
% Description: eliminate samples from a variable instance(s).
% Input:       {vr} variable instance(s).
%              {to_remove} samples to delete.
% Output:      {vr} updated variable instance(s).

% © Liran Carmel
% Classification: Operators
% Last revision date: 20-Sep-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vr,{},'vector',{mfilename,inputname(1),1}));
error(chkvar(to_remove,'integer','vector',{mfilename,inputname(2),2}));

% delete samples
for ii = 1:length(vr)
    vrii = instance(vr,num2str(ii));
    % special procedure if lut exists
    if ~isempty(vrii.lut)
        lut = vrii.lut;
        data = vrii.data;
        % delete gaps in variable indexing
        data = data - min(data) + 1;
        idx = 2;
        mx = max(data);
        while idx < mx
            if ~isempty(find(data==idx,1))
                idx = idx + 1;
            else
                ind = find(data>idx);
                data(ind) = data(ind) - 1;
                mx = mx - 1;
            end
        end
        data(to_remove) = [];
        data(isnan(data)) = [];
        luts_to_remove = allbut(unique(data),mx);
        lut(luts_to_remove) = [];
        vrii.lut = lut;
    end
    vrii.data(to_remove) = [];
    vrii.no_samples = vrii.no_samples - length(to_remove);
    % update sample properties
    vrii.minmax.sample = computeminmax(vrii);
    vrii.mean.sample = computemean(vrii);
    vrii.variance.sample = computevariance(vrii);
    vrii.no_missing = computemissing(vrii);
    % resubstitute
    vr(ii) = vrii;
end