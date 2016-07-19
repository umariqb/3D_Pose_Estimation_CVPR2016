function newSkel = interpolateSkeletons(varargin)

skelcounter = 0;
weightcounter = 0;
for i=1:nargin
    if isSkel(varargin(i))
        skelcounter = skelcounter + 1;
        skels{skelcounter} = varargin{i};
    elseif isnumeric (varargin{i})
        weightcounter = weightcounter + 1;
        weights(weightcounter) = varargin{i};
    else
        error('Wrong argins!');
    end
end

if skelcounter~=weightcounter
    error('Wrong argins!');
end

newSkel = skels{1};

for j=2:newSkel.njoints
    newSkel.nodes(j).offset = 0;
    for i=1:weightcounter
        newSkel.nodes(j).offset = newSkel.nodes(j).offset + ...
                                  weights(i) * skels{i}.nodes(j).offset;
    end
    newSkel.nodes(j).length = sqrt(sum((newSkel.nodes(j).offset).^2));
    newSkel.nodes(j).direction = newSkel.nodes(j).offset / newSkel.nodes(j).length;
end