% example: skel=linearCombinationOfSkeletons({skel1,skel2},[0.5 0.5]);

function skel=linearCombinationOfSkeletons(skels,weights)

numSkeletons=length(skels);
if numSkeletons~=length(weights)
    error('Error: Number of skeletons must equal number of weights!');
end

% Initialization
skel=skels{1};
skel.filename='synthesizedSkeleton';
skel.version=[];
skel.name=[];

for i=1:skel.njoints
    skel.nodes(i).length    = skel.nodes(i).length*weights(1);
    skel.nodes(i).direction = skel.nodes(i).direction*weights(1);
    for j=2:numSkeletons
        skel.nodes(i).length    = skel.nodes(i).length+weights(j)*skels{j}.nodes(i).length;
        skel.nodes(i).direction = skel.nodes(i).direction+weights(j)*skels{j}.nodes(i).direction;
    end
    skel.nodes(i).direction = skel.nodes(i).direction/normOfColumns(skel.nodes(i).direction);
    skel.nodes(i).offset    = skel.nodes(i).direction*skel.nodes(i).length;
end
    