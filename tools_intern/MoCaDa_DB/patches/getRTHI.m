function RTHI = getRTHI( mot )

range = [1:min(50, mot.nframes)];

RFWT = [strmatch('RFWT', mot.nameMap(:,1), 'exact') strmatch('rfwt', mot.nameMap(:,1), 'exact')];
RKNE = [strmatch('RKNE', mot.nameMap(:,1), 'exact') strmatch('rkne', mot.nameMap(:,1), 'exact')];

if isempty(RFWT) || isempty(RKNE)
    error('The markers RFWT and/or RKNE could not be found in the nameMap.');
    return;
end

% find the trajectory that is between RFWT and RKNE
goal = 0.3*mot.jointTrajectories{RFWT} + 0.7*mot.jointTrajectories{RKNE};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, RTHI] = min(len);
