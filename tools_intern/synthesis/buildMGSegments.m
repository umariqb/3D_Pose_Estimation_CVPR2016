function [graph,LDist]=buildMGSegments(skel,mot,data,segments)


segs=size(segments);

for i=1:segs(2)-1
    segData(i,:)=data(segments(i),:);
end
dims=size(segData);

[LDist]=ldm(segData(1:dims(1),:),segData(1:dims(1),:));
figure; imagesc(LDist); colorbar; colormap hot;

list=analyzeLDM(LDist);
list1=list(1:30,:);

graph=createGraph();
dim=size(list1);



disp('Calculated Distances')
for newnode=1:segs(2)-1
    node=createNode(segments(newnode):segments(newnode+1));
    graph=addNode(graph,node);
end
disp('Added Nodes')
fprintf('Adding Edges for Node:     ');
for node=1:segs(2)-2
    for edge=1:dim(1)
        len=size(graph.Nodes(node).content);
        graph=addEdge(graph,node,LDist(edge,node+1),list1(edge,node));
    end
    fprintf('\b\b\b\b');
    fprintf('%4i',node);
end
disp('Added Edges')

        
