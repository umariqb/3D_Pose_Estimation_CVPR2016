/* Search within a matrix of neighbours for similar segments
 *
 * author: Bjoern Krueger (kruegerb@cs.uni-bonn.de)
 *
 * example (Matlab) call:
 * res = C_findPathsTrellisGlobalOptimization(ind,dist,max(ind(:)));
 */

#include "mex.h"
#include <float.h>
#include <cmath>
#include <limits>

#include "path.h"
// #include "TrellisTree.h"
#include "SimpleHashUnsafe.h"

/******* included for boost library *******/
#include <boost/config.hpp>
#include <iostream>
#include <fstream>

#include <boost/graph/graph_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/dijkstra_shortest_paths.hpp>

using namespace boost;
/******* included for boost library *******/

#define getSub(i,j)   (iFrames*(j)+(i))
#define vuiInd(i,j)   (*(puiInd + iNeigh*(j) + (i)))
#define  vfDis(i,j)   (*( pfDis + iNeigh*(j) + (i)))

class BKNode{
    public:
    unsigned int	 frame;
    unsigned int	 neighbour;
    unsigned int     value;
    double           distance;
    std::vector<unsigned int> childs;

    BKNode(unsigned int f,unsigned int n,unsigned int v, double d)
    {
        frame     = f;
        neighbour = n;
        value     = v;
        distance  = d;
    }
    
    ~BKNode(){}
    
    void addChild(int childNode){
        childs.push_back(childNode);
//         mexPrintf("\naddChild: %i -> %i\n", value, childNode);
    }
    
    void writeNode(){
        mexPrintf("\nNode: frame=%i neigh=%i value=%i dist=%f", frame,neighbour,value,distance);
    }
};



// Bin Seek search:
int binsuch(unsigned int* feld,unsigned int l,unsigned int zusuchen )
{
//     mexPrintf("\n");
//   for(int b=0;b<l;b++)  
//       mexPrintf(" %i",feld[b]);
    
  if( l<1 )
  {
    // leeres Feld? Nichts gefunden!
//        mexPrintf("leer");
    return -1000000000;
  }
  else if( l==1 )
  {
    // nur ein Element; vergleichen und ggf. zurückgeben:
//      mexPrintf("eins");
    return ( feld[0]==zusuchen ? 0 : -100000000 );
  }
  else
  {
    // Mehr als ein Element
    // Mitte suchen, und ggf. links oder rechts suchen:
    int index_Mitte = l/2;
    if( feld[index_Mitte]==zusuchen )
    {
      // Zufällig getroffen!
      return index_Mitte;
    }
    else if( feld[index_Mitte]>zusuchen )
    {
//          mexPrintf(" >%i ",index_Mitte);
//          mexPrintf("\n l=%i",l);
      // Mitte ist zu groß, also links weitersuchen
      return binsuch( feld, index_Mitte, zusuchen );
    }
    else
    {
      // Mitte zu klein, also in rechter Hälfte suchen:
//         mexPrintf(" <%i ",index_Mitte);
//         mexPrintf("\n l=%i",l);
      return binsuch( &feld[index_Mitte+1], l - index_Mitte - 1, zusuchen )+index_Mitte+1;
    }
  }

} // int *binsuch( int feld[], size_t l, int zusuchen )


/* Path finding algorithm */
void getPaths(mxArray* pInd, mxArray* pDis, mxArray* pPaths, int iNeigh, int iFrames, int iDBSize, mxArray* pathDists){

    // Some usefull variables
    double        dLengthFac = 0.75;
    unsigned int  uiGap      = 2;
    int           iNumPaths  = 0;
    int           iTreeCount = 1;
    
    // Frame list: stores where a frame occurs
//     int          *pFrameList = new int[iDBSize];

    unsigned int* puiInd     = (unsigned int*)mxGetPr(pInd);
    double*       pfDis      = (double*)      mxGetPr(pDis);
    double*       pfPathDist = (double*)      mxGetPr(pathDists);
    
    // Lookup table: Which neighbours correspond to which node?
    unsigned int* lookup=new unsigned int[iNeigh*iFrames];

    for(int j =0;j<iFrames;j++)
        for(int i=0;i<iNeigh;i++)
            lookup[j*iNeigh + i]=100000000;
    
    typedef adjacency_list < listS, vecS, directedS, no_property, property < edge_weight_t, int > > graph_t;
    typedef graph_traits < graph_t >::vertex_descriptor vertex_descriptor;
    typedef graph_traits < graph_t >::edge_descriptor edge_descriptor;
    typedef std::pair<int, int> Edge;
    
   
    // Find out number of nodes and create them.
    int numNodes=0;
    int numEdges=0;
    
    std::vector<BKNode> Nodes;
    
    mexPrintf("\nInit done.\n");


    
    for(int j=0;j<iFrames;j++){
         //mexPrintf("Neigh=%i",j);
        for(int i=0;i<iNeigh;i++){
             //mexPrintf("Frame=%i",i);
            if(vuiInd(i,j)!=0){
                numNodes++;
                BKNode newNode(j,i,vuiInd(i,j),vfDis(i,j));
                Nodes.push_back(newNode);
                
                lookup[j*iNeigh + i]=Nodes.size()-1;
                //mexPrintf("%i ",numNodes);
            }
        }
    }
    /*
	 mexPrintf("\nDebug Lookup:\n");
     for(int i=0;i<iNeigh;i++){
         mexPrintf("\n");
         for(int j=0;j<iFrames;j++)
             mexPrintf(" %i",lookup[j*iNeigh + i]);
     }*/
    
    mexPrintf("\nNodes built!");
//     mexPrintf("\nSearch Edges:");
    
    for(int curNode=0;curNode<Nodes.size();curNode++){
         //mexPrintf("\nNode %i: Frame = %i, Neigh = %i, Value = %i",curNode,Nodes[curNode].frame,Nodes[curNode].neighbour,Nodes[curNode].value);
        int position = -1;
        
      /*  mexPrintf("\n");
        for(int i=0;i<iNeigh;i++)
            mexPrintf(" %i ",*(puiInd + iNeigh*(Nodes[curNode].frame+1) + i));
      */  
        
        position = binsuch(puiInd + iNeigh*(Nodes[curNode].frame+1),iNeigh,Nodes[curNode].value+1);
        if(position>-1){
            if(lookup[position+iNeigh*(Nodes[curNode].frame+1)]!=100000000){
                Nodes[curNode].addChild(lookup[position+iNeigh*(Nodes[curNode].frame+1)]);
                numEdges++;
                //mexPrintf("\n   \\ %i %i Value=%i Node=%i",position,Nodes[curNode].frame+1,Nodes[curNode].value+1,lookup[position+iNeigh*(Nodes[curNode].frame+1)]);
            }
        }

        // Vert
        position = -1;
        position = binsuch(puiInd + iNeigh*(Nodes[curNode].frame+1),iNeigh,Nodes[curNode].value);
        if(position>-1){
            if(lookup[position+iNeigh*(Nodes[curNode].frame+1)]!=100000000){
                Nodes[curNode].addChild(lookup[position+iNeigh*(Nodes[curNode].frame+1)]);
                numEdges++;
                 //mexPrintf("\n   - %i %i Value=%i Node=%i",position,Nodes[curNode].frame+1,Nodes[curNode].value,lookup[position+iNeigh*(Nodes[curNode].frame+1)]);
            }
        }
        // Horz
        position = -1;
        position = binsuch(puiInd + iNeigh*(Nodes[curNode].frame),iNeigh,Nodes[curNode].value+1);
        if(position>-1){
            if(lookup[position+iNeigh*Nodes[curNode].frame]!=100000000){
                Nodes[curNode].addChild(lookup[position+iNeigh*Nodes[curNode].frame]);
                numEdges++;
                 //mexPrintf("\n   | %i %i Value=%i Node=%i",position,Nodes[curNode].frame,Nodes[curNode].value+1,lookup[position+iNeigh*Nodes[curNode].frame]);
            }
        }
    }
    /*
    mexPrintf("\nNeighbours found!");
    */
    mexPrintf("\nnumEdges = %i\n",numEdges);
    
    Edge*   edge_array=new Edge[numEdges+iNeigh];//
//     double     weights[numEdges+iNeigh];
    int*       weights=new int[numEdges+iNeigh];
    
    int curEdge=0;
    
    for(int node=0;node<Nodes.size();node++){
        
//          mexPrintf(".");
        
        for(int edge=0;edge<Nodes[node].childs.size();edge++){
             //mexPrintf("\n Edge = %i", curEdge);
            edge_array[curEdge] = Edge(node,Nodes[node].childs[edge]);
//             mexPrintf(" : %i --> %i",      node       ,      Nodes[node].childs[edge]       );
//             mexPrintf(" : %i,%i --> %i,%i = %i",Nodes[node].value,Nodes[node].frame,Nodes[Nodes[node].childs[edge]].value, Nodes[Nodes[node].childs[edge]].frame,(int) (Nodes[Nodes[node].childs[edge]].distance*1000+Nodes[node].distance*1000));
//             mexPrintf("\nDist Check: Node.dist=%f Node->child.dist=%f",Nodes[node].distance,Nodes[Nodes[node].childs[edge]].distance);
            weights   [curEdge] = (int) (Nodes[node].distance*1000);
            curEdge++;
        }
        if(Nodes[node].frame==iFrames-1){
             //mexPrintf("\n Edge = %i", curEdge);
            edge_array[curEdge] = Edge(node,numNodes);
             //mexPrintf(" : %i --> TARGET",Nodes[node].value);
            weights   [curEdge] = (int) 0;//(Nodes[node].distance*1000);
            curEdge++;
        }
    }
//     mexPrintf("\nEdege Array constructed");
//     for(int ew=0;ew<curEdge;ew++) mexPrintf("\nw(%i)=%i",ew,weights[ew]);
    
//     mexPrintf("\nNumNodes = %i\n",numNodes);
    
//     mexPrintf("\n\nNumNodes = %i\n",numNodes);
    
    
     mexPrintf("Edges built\n");
    // Create edges
//     Edge edge_array[] = {Edge(1,2),Edge(2,3),Edge(3,4),Edge(1,5),Edge(3,6),Edge(6,4),Edge(4,9)};
    //int weih[] = { 1, 2, 1, 2, 7, 3, 1, 1, 2, 1, 2, 7, 3, 1};
    int num_arcs = curEdge;//sizeof(edge_array) / sizeof(Edge);
    
    graph_t g(edge_array, edge_array + num_arcs, weights, numNodes+1);
    property_map<graph_t, edge_weight_t>::type weightmap = get(edge_weight, g);
    
    
// //     graph_t g(numNodes+1);
// //     property_map<graph_t, edge_weight_t>::type weightmap = get(edge_weight, g);
// //     for (std::size_t j = 0; j < num_arcs; ++j) {
// //         edge_descriptor e; 
// //         bool inserted;
// //         
// //         mexPrintf("\nedge_array.first=%i edge_array.second%i",edge_array[j].first,edge_array[j].second);
// //         
// //         tie(e, inserted) = add_edge(edge_array[j].first, edge_array[j].second, g);
// //         weightmap[e] = weights[j];
// //     }

    std::vector<vertex_descriptor>  p(num_vertices(g));
    std::vector<int>                d(num_vertices(g));
    
// 	mexPrintf("size(d) = %i\n",d.size());

    for(int startNode=0;startNode<iNeigh;startNode++){
    
//         mexPrintf(".");

        vertex_descriptor s = vertex(startNode, g);

        dijkstra_shortest_paths(g, s, predecessor_map(&p[0]).distance_map(&d[0]));


        

//          mexPrintf("distances and parents:\n");
        graph_traits < graph_t >::vertex_iterator vi, vend;
        int* parents=new int[numNodes+1];
        int* dists  =new int[numNodes+1];
        
        for (tie(vi, vend) = vertices(g); vi != vend; ++vi) {
//              mexPrintf("distance(%i) = %i Parent = %i \n",*vi,d[*vi],p[*vi]);
            parents[*vi]=p[*vi];
              dists[*vi]=d[*vi];
        }

        int depth=1;
        int curNode=numNodes;
        
        *pfPathDist =(double) dists[curNode];
         pfPathDist++;
        
        while(parents[curNode]!=startNode && parents[curNode] < numNodes && parents[curNode] > 0){
            depth++;
            curNode=parents[curNode];
        }

//          mexPrintf("PathDepth = %i",depth);

        mwSize dims[2];
        dims[0] = (mwSize)2;
        dims[1] = (mwSize)depth;

        mxArray *pSteps=mxCreateNumericArray(2,(const mwSize*)&dims,mxUINT32_CLASS,mxREAL);
        unsigned int* puiSteps=(unsigned int*)mxGetPr(pSteps);  

        curNode=parents[numNodes];
        while(parents[curNode]!=startNode && parents[curNode] < numNodes && parents[curNode] > 0){

            *puiSteps = Nodes[curNode].frame+1; puiSteps++;
            *puiSteps = Nodes[curNode].value;   puiSteps++;

            curNode=parents[curNode];
        }

		

        *puiSteps = Nodes[curNode].frame+1; puiSteps++;
        *puiSteps = Nodes[curNode].value;   puiSteps++;
        curNode=parents[curNode];
//          mexPrintf("\nPING\n");
        *puiSteps = Nodes[curNode].frame+1; puiSteps++;
        *puiSteps = Nodes[curNode].value;   puiSteps++;
        curNode=parents[curNode];

//         mexPrintf("C");
        
        mxSetCell(pPaths, (mwIndex)getSub(startNode,0), pSteps);
        
        delete parents;
        delete dists  ;
// 		mexPrintf("D");
    }
    mexPrintf("Search Done");

	delete lookup;
	delete edge_array;
	delete weights;
    

//     mexPrintf("\nDone!");
}

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    
    double    *pDis;

    int   	  *pInd,
              *pDBSize;

    unsigned int iNeigh,
                 iFrames;

    /*  Check for proper number of arguments. */
    if (nrhs != 3) 
    mexErrMsgTxt("Three inputs required.");

    if (nlhs != 2) 
    mexErrMsgTxt("Two outputs required.");

    /* Get Pointers to input arguments */
    pInd     = (int*)    mxGetPr(prhs[0]);
    pDis     = (double*) mxGetPr(prhs[1]);
    pDBSize  = (int*)    mxGetPr(prhs[2]);

    /* Get the dimensions of the input array. */
    iNeigh   = mxGetM(prhs[0]);
    iFrames  = mxGetN(prhs[0]);

    /* Create output cell array */
    mwSize pDims[2];
    pDims[0] = (mwSize)1;
    pDims[1] = (mwSize)iNeigh; // max Number of possible paths

    plhs[0]  = mxCreateCellArray(2, (const mwSize*)pDims);
    plhs[1]  = mxCreateDoubleMatrix(1, iNeigh, mxREAL);

    /* Call Path finding algorithm */
    getPaths((mxArray*)prhs[0], (mxArray*)prhs[1], plhs[0], iNeigh, iFrames, *pDBSize, plhs[1]);

}