function vr = loadobj(inp)

% LOADOBJ basic load function.
% ----------------
% vr = loadobj(vr)
% ----------------
% Description: basic load function.
% Input:       {vr} old version of VARIABLE.
% Output:      {vr} new version of VARIABLE.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 07-Mar-2006

% make a special adjustment if the input is not of class VARIABLE
if isa(inp,'variable')
    vr = inp;
else
    vr = variable(numel(inp));
    for ii = 1:numel(inp)
        vr(ii) = set(vr(ii),'name',inp(ii).name,...
            'description',inp(ii).description,...
            'source',inp(ii).source,'data',inp(ii).data,...
            'units','''''','level',inp(ii).level,...
            'lut',inp(ii).lut,...
            'minmax',inp(ii).minmax.population,...
            'mean',inp(ii).mean.population,...
            'variance',inp(ii).variance.population,...
            'distribution',inp(ii).distribution);
    end
end