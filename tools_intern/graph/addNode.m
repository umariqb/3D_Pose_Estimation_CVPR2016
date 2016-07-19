function graph=addNode(graph,node)

graph.numNodes=graph.numNodes+1;
node.index=graph.numNodes;
graph.Nodes(graph.numNodes)=node;