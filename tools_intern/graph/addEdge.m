function [graph]=addEdge(graph,sNode,prob,gNode)

edge=[sNode prob gNode];

out=size(graph.Nodes(sNode).outEdges);
graph.Nodes(sNode).outEdges(out(1)+1,:)=edge;

in=size(graph.Nodes(gNode).inEdges);
graph.Nodes(gNode).inEdges(in(1)+1,:)=edge;