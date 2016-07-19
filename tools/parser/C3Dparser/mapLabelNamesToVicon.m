function newLabelNames = mapLabelNamesToVicon( oldLabelNames, caseSensitive )
% tries to map the given label names to standard Vicon-names.
% The vicon names are:
% 'LFHD'    'RFHD'    'LBHD'    'RBHD'    'C7'      'T10'     'CLAV'
% 'STRN'    'RBAC'    'LSHO'    'LUPA'    'LELB'    'LFRM'    'LWRA'
% 'LWRB'    'LFIN'    'RSHO'    'RUPA'    'RELB'    'RFRM'    'RWRA'
% 'RWRB'    'RFIN'    'LFWT'    'RFWT'    'LBWT'    'RBWT'    'LTHI'
% 'LKNE'    'LSHN'    'LANK'    'LHEE'    'LTOE'    'LMT5'    'RTHI'
% 'RKNE'    'RSHN'    'RANK'    'RHEE'    'RTOE'    'RMT5'
  
mapping = { { {'Left Forehead', 'LeftFhd'},    'LFHD'}; 
            { {'Right Forehead', 'RightFhd'},  'RFHD'};
            { {'LARM'},                        'LFRM'};
            { {'RARM'},                        'RFRM'};
            { {'RLEG'},                        'RSHN'};
            { {'LLEG'},                        'LSHN'};
            { {'R10'},                         'RBAC'};
            % etc.
        };

newLabelNames = oldLabelNames;

for i = 1:size(oldLabelNames,2)
    for j = 1:size(mapping, 1)
        if caseSensitive
            idx = strmatch(oldLabelNames{i}, mapping{j}{1});
        else
            idx = strmatch(upper(oldLabelNames{i}), upper(mapping{j}{1}));
        end
        
        if not(isempty(idx))
            newLabelNames{i} = mapping{j}{2};
        end
    end
end
