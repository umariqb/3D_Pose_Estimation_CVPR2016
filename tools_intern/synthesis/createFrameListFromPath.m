function res=createFrameListFromPath(graph,t);

res=[];
dim=size(t);
for i=1:dim(2)
    res=[res graph.Nodes(1,t(i)).content];
end
    