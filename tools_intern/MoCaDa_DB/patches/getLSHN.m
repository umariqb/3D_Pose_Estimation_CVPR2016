function LSHN = getLSHN( mot )
 
range = [1:min(50, mot.nframes)];

LKNE = [strmatch('LKNE', mot.nameMap(:,1), 'exact') strmatch('lkne', mot.nameMap(:,1), 'exact')];
LANK = [strmatch('LANK', mot.nameMap(:,1), 'exact') strmatch('lank', mot.nameMap(:,1), 'exact')];

if isempty(LKNE) || isempty(LANK)
    error('The markers LKNE and/or LANK could not be found in the nameMap.');
    return;
end

% find the trajectory that is between LKNE and LANK
goal = 0.5*mot.jointTrajectories{LKNE} + 0.5*mot.jointTrajectories{LANK};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, LSHN] = min(len);
