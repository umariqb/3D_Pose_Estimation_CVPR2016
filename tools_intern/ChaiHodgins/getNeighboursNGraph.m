function neighbourList = getNeighboursNGraph(nGraph,indexList)

nGraph.offsets = [nGraph.offsets size(nGraph.points,2)+1];
neighbourList = [];
for i=indexList
    neighbourList = [neighbourList nGraph.points(nGraph.offsets(i):nGraph.offsets(i+1)-1)];
end
neighbourList = unique(neighbourList);