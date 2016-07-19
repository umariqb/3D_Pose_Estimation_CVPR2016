function compareYdist( jointName, mot1, mot2, mot3, mot4 )
% compareYdist( jointName, mot1, mot2, mot3, mot4 )


if nargin < 1
    help compareYdist
    return
end

nframes = size(mot1.jointTrajectories{1},2);
range = [1:nframes];

if nargin > 1
    idx1 = strmatch(jointName, mot1.nameMap(:,1), 'exact');
end
if nargin > 2
    idx2 = strmatch(jointName, mot2.nameMap(:,1), 'exact');
end
if nargin > 3
    idx3 = strmatch(jointName, mot3.nameMap(:,1), 'exact');
end
if nargin > 4
    idx4 = strmatch(jointName, mot4.nameMap(:,1), 'exact');
end

figure;

if nargin < 3
    plot( range, mot1.jointTrajectories{idx1}(2,:), 'r-');
    leg = legend(inputname(2));
elseif nargin < 4
    plot( range, mot1.jointTrajectories{idx1}(2,:), 'r-', ...
          range, mot2.jointTrajectories{idx2}(2,:), 'b-');
    leg = legend(inputname(2),inputname(3));
elseif nargin < 5
    plot( range, mot1.jointTrajectories{idx1}(2,:), 'r-', ...
          range, mot2.jointTrajectories{idx2}(2,:), 'b-', ...
          range, mot3.jointTrajectories{idx3}(2,:), 'g-');
    leg = legend(inputname(2),inputname(3),inputname(4));
else
    plot( range, mot1.jointTrajectories{idx1}(2,:), 'r-', ...
          range, mot2.jointTrajectories{idx2}(2,:), 'b-', ...
          range, mot3.jointTrajectories{idx3}(2,:), 'g-', ...
          range, mot4.jointTrajectories{idx4}(2,:), 'c-');
    leg = legend(inputname(2),inputname(3),inputname(4),inputname(5));
end

title(['y-coordinates of ''' jointName ''' joint'],'Interpreter','none');
