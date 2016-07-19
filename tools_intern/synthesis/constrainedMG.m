function resmot=constrainedMG(skel,mot,data,C)

dims=size(data);
graph=buildMG(skel,mot,data);

resmot=cutMot(skel,mot,1,5);

startF=1;

for it=1:num
    endF=round(rand()*dims(1));
    
    [graph,t]=dijkstra(graph,startF,endF);
    newmot=createMotFromFrameList(skel,mot,t);
    resmot=appendAndBlend(skel,resmot,newmot,1);
    startF=endF;
end