function maxDev = analyseMot( mot, bones )
% maxDev = analyseMot( mot, bones )
%
%       bones    : bones to examine (e.g. {{'lsho', 'lelb'}, {'lsho', 'lupa'}}


if nargin < 2

    bones = { {'neck', 'lclavicle'}, {'lclavicle', 'lshoulder'}, {'lshoulder', 'lelbow'}, {'lelbow', 'lwrist'}, {'lwrist', 'lfingers'}, ...
          {'neck', 'rclavicle'}, {'rclavicle', 'rshoulder'}, {'rshoulder', 'relbow'}, {'relbow', 'rwrist'}, {'rwrist', 'rfingers'}, ...
          {'root', 'lhip'}, {'lhip', 'lknee'}, {'lknee', 'lankle'}, {'lankle', 'ltoes'}, ... 
          {'root', 'rhip'}, {'rhip', 'rknee'}, {'rknee', 'rankle'}, {'rankle', 'rtoes'}, ... 
          {'root', 'belly'}, {'belly', 'chest'}, {'chest', 'neck'}, {'neck', 'head'}, {'head', 'headtop'} }; 
end

b = length(bones);
m = double(int32(sqrt(b)));

if m*m ~= b
    m = m + 1;
end

n = double(int32(b/m));

if mod(b,m)~=0
    n = n + 1;
end

maxDev = 0;

warning off;
figure;
for i = 1:length(bones)

    bone = bones{i};
    % determine joint numbers
%     idx1 = strmatch(upper(bone{1}), upper({mot.nameMap{:,1}}), 'exact');
%     idx2 = strmatch(upper(bone{2}), upper({mot.nameMap{:,1}}), 'exact');
    idx1 = trajectoryID(mot, bone{1});
    idx2 = trajectoryID(mot, bone{2});
    
    % error if not found in nameMap
    if isempty(idx1)
        error(['ERROR: Joint name "' bone{1} '" could not be found in mot.nameMap!']);
    end
    if isempty(idx2)
        error(['ERROR: Joint name "' bone{2} '" could not be found in mot.nameMap!']);
    end
    
    % plot graphs
	SUBPLOT(m,n,i);
	diff = mot.jointTrajectories{idx1} - mot.jointTrajectories{idx2};
	diff = sqrt(dot(diff, diff));
    
    maxdiff = max(diff) - min(diff);

    maxDev = max(maxDev, maxdiff);

    plot(diff);
    
    h=title({ ['dist(' bone{1} ', ' bone{2} '),  mean = ' num2str(mean(diff), '%.2f')]; ...
            ['std = ' num2str(std(diff), '%.2f') ' ( ' num2str( 100*std(diff)/mean(diff), '%.2f') '% ) , maxdiff = ' num2str(maxdiff, '%.2f') '( ' num2str(100*maxdiff/mean(diff), '%.2f') '% )']});
    set(h, 'fontsize', 7);
    set(gca, 'fontsize', 7);
    set(gca, 'pos', get(gca, 'pos') - [0 0 0 0.02]);
end
warning on;
