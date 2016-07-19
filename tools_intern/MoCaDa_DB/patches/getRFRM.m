function RFRM = getRFRM( mot )
 
range = [1:min(50, mot.nframes)];

RELB = [strmatch('RELB', mot.nameMap(:,1), 'exact') strmatch('relb', mot.nameMap(:,1), 'exact')];
RWRB = [strmatch('RWRB', mot.nameMap(:,1), 'exact') strmatch('rwrb', mot.nameMap(:,1), 'exact')];

if isempty(RELB) || isempty(RWRB)
    error('The markers RELB and/or RWRB could not be found in the nameMap.');
    return;
end

% find the trajectory that is between RFWT and RWRB
goal = 0.5*mot.jointTrajectories{RELB} + 0.5*mot.jointTrajectories{RWRB};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, RFRM] = min(len);
