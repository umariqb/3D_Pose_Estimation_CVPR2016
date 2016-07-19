function graph=buildMGSingleFrames(skel,mot,data)

dims=size(data);

[LDist]=ldm(data(1:dims(1),:),data(1:dims(1),:));
figure; imagesc(LDist); colorbar; colormap hot;

list=analyzeLDM(LDist);
list1=list(1:30,:);

graph=createGraph();
dim=size(list1);
disp('Calculated Distances')
for newnode=1:dim(2)
    node=createNode(newnode);
    graph=addNode(graph,node);
end
disp('Added Nodes')
fprintf('Adding Edges for Node:     ');
for node=1:dim(2)
    for edge=1:dim(1)
        graph=addEdge(graph,node,LDist(edge,node),list1(edge,node));
    end
    fprintf('\b\b\b\b');
    fprintf('%4i',node);
end
disp('Added Edges')

        
