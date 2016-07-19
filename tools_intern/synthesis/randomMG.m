function resmot=randomMG(skel,mot,data,num)

dims=size(data);
segments=1:5:dims(1);
graph=buildMGSegments(skel,mot,data,segments);

resmot=cutMot(skel,mot,1,5);

startF=1;

%for it=1:num
    endF=100;%round(rand()*dims(1));
    
%    [graph,t]=dijkstra(graph,startF,endF);
    t=1:200;
    t=createFrameListFromPath(graph,t);
    newmot=createMotFromFrameList(skel,mot,t);
    resmot=appendAndBlend(skel,resmot,newmot,1);
    startF=endF;
%end