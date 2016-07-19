function plotDistances(graph)
figure;
for node=1:graph.numNodes
 dist(node)=graph.Nodes(node).distance;
end

plot(dist,'.');