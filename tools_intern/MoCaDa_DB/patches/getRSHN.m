function RSHN = getRSHN( mot )
 
range = [1:min(50, mot.nframes)];

RKNE = [strmatch('RKNE', mot.nameMap(:,1), 'exact') strmatch('rkne', mot.nameMap(:,1), 'exact')];
RANK = [strmatch('RANK', mot.nameMap(:,1), 'exact') strmatch('rank', mot.nameMap(:,1), 'exact')];

if isempty(RKNE) || isempty(RANK)
    error('The markers RKNE and/or RANK could not be found in the nameMap.');
    return;
end

% find the trajectory that is between RKNE and RANK
goal = 0.5*mot.jointTrajectories{RKNE} + 0.5*mot.jointTrajectories{RANK};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, RSHN] = min(len);
