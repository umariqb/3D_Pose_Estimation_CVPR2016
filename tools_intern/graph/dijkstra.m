function [graph,list]=dijkstra(graph,start,goal)
%%
% /*
%  * Der eigentliche Algorithmus von Dijkstra
%  * -----------------------------------------
%  * G: Zu untersuchender Graph
%  * s: Startknoten
%  * g: Der Zielknoten
%  * w: Gewichtsfunktion zum Berechnen der Kosten für eine Kante
%  * Q: Prioritätswarteschlange der Knoten, aufsteigend nach d-Werten sortiert
%  */
%    Dijkstra (s, g, w, G) {
% 01      initialize(G, s);
% 02      Q := V[G]; // Füge alle Knoten aus dem Graph in die Warteschlange ein
% 03      while not isEmpty(Q) {
% 04         // Betrachte Knoten mit dem geringsten Abstand zum Startknoten
% 05         u := pop(Q);
% 06        if (u == g) then
% 07           return reconstructShortestPath(g);
% 08        else {
% 09            // Betrachte alle vom aktuellen Knoten u aus erreichbaren Knoten (Nachfolger)
% 10            forall v := successors(u) do {
% 11               // relaxiere die Kante zwischen u und seinem Nachfolger
% 12               relax(u, v, w);
% 13            }
% 14         }
% 15      }
% 16      // Es konnte kein Pfad gefunden werden
% 17      return fail;
% 18 }
%      dist=zeros(graph.numNodes,graph.numNodes);
     graph=dijkstraInitialize(graph,start);
     Queue=1:graph.numNodes;
     [Queue]=sortQueue(Queue,graph);
     pis=0;
     fprintf('Elements in Queue:     ');
     while(~isempty(Queue))
         u     = Queue(1);
         sQ    = size(Queue);
         Queue = Queue(2:sQ(2));
%          [Queue]=sortQueue(Queue,graph);
        % Print distances
        fprintf('\b\b\b\b');
        fprintf('%4i',sQ(2)-1);
%        disp([num2str(sQ(2)-1) 'elements in Queue']);
%         for node=1:graph.numNodes
%             disp(['Node' num2str(node) ' distance: ' num2str(graph.Nodes(node).distance)]);
%         end

         if(u==goal)
             list=dijkstraRecPath(start,pis,goal);
             break;
         else
             out=size(graph.Nodes(u).outEdges);
             for n=1:out(1)
                 [graph,pis]=dijkstraRelax(graph,pis,u,graph.Nodes(u).outEdges(n,3),graph.Nodes(u).outEdges(n,2));
             end
         end 
%          for node=1:graph.numNodes
%              dist(node,sQ(2))=graph.Nodes(node).distance;
%          end
     end
     fprintf('\n');
%      figure; imagesc(dist); colormap hot; colorbar;
     plotDistances(graph);
end

%%
function [Queue]=sortQueue(Queue,graph)
     sQ=size(Queue);
     distance=zeros(sQ);
     for n=1:sQ(2)
         distance(n)=graph.Nodes(n).distance;
     end
     [distance,index]=sortrows(distance');
     for n=1:sQ(2)
        Q(n)=Queue(index(n));
     end
     Queue=Q;
end

%%
% /*
%  * Algorithmus zum Relaxieren einer Kante
%  * --------------------------------------
%  * u: Knoten, der gerade expandiert wurde
%  * v: Aktuell betrachteter Nachfolger von u
%  * w: Gewichtsfunktion zum Berechnen der Kosten für eine Kante
%  * d: Funktion zum Berechnen des Abstandes eines Knotens zum Startknoten
%  */
% relax(u,v,w)
% {
%    // Prüfe, ob der Weg über u zu v kürzer ist als der aktuelle
%    if d[v] > d[u] + w(u,v) {
%       // Neuer Weg kürzer als bisher gefundener Weg
%       // Aktualisiere geschätzte restliche Weglänge
%       d[v] := d[u] + w(u,v);
%       // Aktualisiere Vorgänger in kürzestem Pfad
%       ?[v] := u;
%    }
%    else
%       ; // Ändere nichts, da bereits besserer Pfad bekannt
% }

function [graph,pis]=dijkstraRelax(graph,pis,u,v,w)
    if(graph.Nodes(v).distance>graph.Nodes(u).distance+w)
        graph.Nodes(v).distance=graph.Nodes(u).distance+w;
        pis(v)=u;
    end
end


%%
% /*
%  * Algorithmus zum Initialisieren des Graphen
%  * ------------------------------------------
%  * G: Zu untersuchender Graph
%  * s: Startknoten
%  */
% initialize(G, s)
% {
%    // Setze die Entfernung zu allen Knoten auf unendlich
%    forall v do
%       d[v] := ?
%    d[s] := 0;
% }
function graph=dijkstraInitialize(graph,start)
    for node=1:graph.numNodes
        graph.Nodes(node).distance=inf;
    end
    graph.Nodes(start).distance=0;
end


%%
% /*
%  * Algorithmus zur Rekonstruktion des kürzesten Pfades
%  * ---------------------------------------------------
%  * p: berechneter kürzester Pfad
%  * n: Zielknoten
%  */
% reconstructShortestPath (n, p)
% {
%    // Prüfe ob schon wieder beim Startknoten angekommen
%    while (?(n) != NIL))
%    {
%       push(n, p); // Füge Knoten dem Pfad hinzu
%       n := ?(n); // Mache dasselbe für den Vorgängerknoten
%    }
%    return p; // Liefere den gefundenen Pfad zurück
% }
function list=dijkstraRecPath(start,pis,goal)

tSize=size(pis);

new=pis(tSize(2));
list(1)=goal;
p=2;
while(new~=start)
    list(p)=new;
    new=pis(new);
    p=p+1;
end
list(p)=start;
tmp=list;
dim=size(tmp);
for a=1:dim(2)
    list(a)=tmp(dim(2)-a+1);
end

end

