function STRN = getSTRN( mot )

range = [1:min(50, mot.nframes)];

CLAV = [strmatch('CLAV', mot.nameMap(:,1), 'exact') strmatch('clav', mot.nameMap(:,1), 'exact')];
C7   = [strmatch('C7', mot.nameMap(:,1), 'exact') strmatch('c7', mot.nameMap(:,1), 'exact')];
T10  = [strmatch('T10', mot.nameMap(:,1), 'exact') strmatch('t10', mot.nameMap(:,1), 'exact')];

if isempty(CLAV) || isempty(C7) || isempty(T10)
    error('Some of the markers CLAV, T10 and C7 could not be found in the nameMap.');
    return;
end

% determine trajectory that is closest to a possible STRN-trajectory

goal = mot.jointTrajectories{T10} + (mot.jointTrajectories{CLAV} - mot.jointTrajectories{C7});

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(range) - goal(range);
    len(i) = sum(dot(diff, diff));
end


[minElement, STRN] = min(len);
