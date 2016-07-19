/* Search within a matrix of neighbours for similar segments
 *
 * author: Bjoern Krueger (kruegerb@cs.uni-bonn.de)
 *
 * example (Matlab) call:
 * res = C_findPathsTrellis(ind,dist,max(ind(:)));
 */

#include "mex.h"
#include <float.h>
#include <cmath>
#include <limits>

#include "path.h"
#include "TrellisTree.h"
#include "SimpleHashUnsafe.h"

#define getSub(i,j) (iFrames*(j)+(i))
#define vuiInd(i,j)   (*(puiInd + iNeigh*(j) + (i)))



// Bin Seek search:

int binsuch(unsigned int* feld,unsigned int l,unsigned int zusuchen )
{
/*    mexPrintf("\n");
  for(int b=0;b<l;b++)  
      mexPrintf(" %f",feld[b]);
    */
  if( l<1 )
  {
    // leeres Feld? Nichts gefunden!
    return NULL;
  }
  else if( l==1 )
  {
    // nur ein Element; vergleichen und ggf. zurückgeben:
    //  mexPrintf(" =%i ",feld[0]==zusuchen ? &feld[0] : NULL);
    return ( feld[0]==zusuchen ? 0 : -10000000 );
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
      //   mexPrintf(" >%i ",index_Mitte);
      // Mitte ist zu groß, also links weitersuchen
      return binsuch( feld, index_Mitte, zusuchen );
    }
    else
    {
      // Mitte zu klein, also in rechter Hälfte suchen:
      //  mexPrintf(" <%i ",index_Mitte);
      return binsuch( &feld[index_Mitte+1], l - index_Mitte - 1, zusuchen )+index_Mitte+1;
    }
  }

} // int *binsuch( int feld[], size_t l, int zusuchen )








/* recursive function to expand tree */
void getNextSteps(TrellisTree* Tree,int *pFrameList, unsigned int* puiInd,double* pdDist, int iFrames, int iNeigh, int iTree,int iDBSize ){
   
    int bFoundElement=0;
    
    double weight=0;

    // if leave node: do nothing
    if(Tree->curNode->uiValue>0){
    
        // go through all childs
        for(int i=0;i<Tree->curNode->uiGap;i++){
            
            //compute search element
            unsigned int search;
            if(i==0)
                search=Tree->curNode->uiValue+1;
            else
                search=Tree->curNode->uiValue+i-1;
            
// //             mexPrintf("Search: %i i=%i\n",search,i);
// //             mexPrintf("FrameListEntry: %i\n",*(pFrameList+search-1));
// //             mexPrintf("Tree->curNode->uiDepth=%i\n",Tree->curNode->uiDepth);
            
            // if search elment is not part of current tree AND we are not at the end of frames
            if( *(pFrameList+search-1)==0 && Tree->curNode->uiFrame<iFrames && search<= iDBSize){ //*(pFrameList+search)==0 && //<iTree //*(pFrameList+search)==0 && 

                // Search. Take correct col
                unsigned int deltaF=1;
                if(i==0)     deltaF=0;

                bFoundElement = binsuch(puiInd + iNeigh*(Tree->curNode->uiFrame+deltaF-1),iNeigh,search);

                if(bFoundElement>=0){
//                     mexPrintf("Position = %i\n",bFoundElement);
//                     mexPrintf("Frame = %i\n",Tree->curNode->uiFrame+deltaF-1);
                    weight = *(pdDist + iNeigh*(Tree->curNode->uiFrame+deltaF-1)+bFoundElement);
                    
//                     for(int t=0;t<iNeigh;t++) mexPrintf("%i: %f  ",t,*(pdDist + iNeigh*(Tree->curNode->uiFrame+deltaF)+t));
                    
//                     mexPrintf("Weight = %f\n",weight);
                    Tree->curNode->addChild(search,i,weight,deltaF);
// //                     mexPrintf("addChild(%i,%i,%f,%i)\n",search,i,weight,deltaF);

                }
                else{ //add leave node
                    Tree->curNode->addChild(0,i,1000000,0);
                }
            }
            else{ //add leave node
                Tree->curNode->addChild(0,i,1000000,0);
            }
        }

        int deepChild=0;
        double depth,minDepth=1000000;
        
        for(int n=0;n<Tree->curNode->uiGap;n++){
            depth=Tree->curNode->getChild(n)->dAccWeight;
            
            if(depth<minDepth){
                minDepth=depth;
                deepChild=n;
            }
        }
        
        if(Tree->curNode->getChild(deepChild)->uiValue!=0 && Tree->curNode->getChild(deepChild)->uiDepth<1000000){ 
// //             mexPrintf("DeepChild=%i\n",deepChild);
            
            Tree->setDeepNode(Tree->curNode->getChild(deepChild));
            Tree->setCurNode(Tree->getDeepNode());

            if(Tree->curNode->uiValue!=0){
                getNextSteps(Tree,pFrameList,puiInd,pdDist,iFrames, iNeigh,iTree,iDBSize);
                *(pFrameList+Tree->curNode->uiValue-1)=iTree;
            }
            
            Tree->setCurNode(Tree->curNode->getParent());  
        }
    }
    
}

/* Path finding algorithm */
void getPaths(mxArray* pInd, mxArray* pDis, mxArray* pPaths, int iNeigh, int iFrames, int iDBSize){

    // Some usefull variables
    double        dLengthFac = 0.75;
    unsigned int  uiGap      = 3;
    int           iNumPaths  = 0;
    int           iTreeCount = 1;
    
    // Frame list: stores where a frame occurs
    int          *pFrameList = new int[iDBSize];
    for(int i=0;i<iDBSize;i++) *(pFrameList+i) = 0;
    
//     mexPrintf("DBSize = %i",iDBSize);
//     for(int i=0;i<iDBSize;i++) mexPrintf("*(pFrameList+%i) = %i\n",i,*(pFrameList+i));
    // Hash Table for searching elements
//     SimpleHashUnsafe<unsigned int> *HashTable = new SimpleHashUnsafe<unsigned int>(iNeigh,iNeigh);
    
    for(int iCurFrame=0;iCurFrame<(1-dLengthFac)*iFrames ;iCurFrame++){ // (1-dLengthFac)*iFrames
        for(int iCurNeigh=0;iCurNeigh<iNeigh;iCurNeigh++){ //
            
//             mexPrintf("\n Next Start!\n\n");
 
//Debug Schleifen
// // //     for(int iCurFrame=0;iCurFrame<5 ;iCurFrame++){ // (1-dLengthFac)*iFrames
// // //         for(int iCurNeigh=0;iCurNeigh<10;iCurNeigh++){ //
            
            // get pointer to Index Matrix
            unsigned int* puiInd           = (unsigned int*)mxGetPr(pInd);
            double*       pdDist           = (double*)      mxGetPr(pDis);
            
            unsigned int   uiSearchElement = vuiInd(iCurNeigh,iCurFrame);
            
            if(uiSearchElement!=0){
            
                TrellisTree curTree(uiSearchElement, uiGap, (unsigned int)iCurFrame+1);

                //Recursive evaluation of matrix
                getNextSteps(&curTree, pFrameList, puiInd, pdDist, iFrames, iNeigh, iTreeCount,iDBSize);

                iTreeCount++;

                TrellisNode* curNode = curTree.getDeepNode();

                // If longest path is good write it to matrix
                if((curNode->uiDepth)>3){

                    mwSize dims[2];
                    dims[0] = (mwSize)2;
                    dims[1] = (mwSize)curNode->uiDepth+1;

                    mxArray *pSteps=mxCreateNumericArray(2,(const mwSize*)&dims,mxUINT32_CLASS,mxREAL);

                    unsigned int* puiSteps=(unsigned int*)mxGetPr(pSteps);

                    while(curNode->uiDepth>0){

                       *puiSteps = curNode->uiFrame;   puiSteps++;
                       *puiSteps = curNode->uiValue;   puiSteps++;

    //                    mexPrintf("accw= %f\n",curNode->dAccWeight);

                        curNode=curNode->getParent();
                    }

                   *puiSteps = curNode->uiFrame; puiSteps++;
                   *puiSteps = curNode->uiValue; puiSteps++;

                   // Put matrix to output cell array
                   mxSetCell(pPaths, (mwIndex)getSub(iNumPaths,0), pSteps);

                   iNumPaths++;

                   // if we found more path the we can store in cell array
                   if(iNumPaths>=iNeigh*10)
                       return;
                }

            }

        }
    }
    delete[] pFrameList;
    
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

    if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

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
    pDims[1] = (mwSize)iNeigh*10; // max Number of possible paths

    plhs[0]  = mxCreateCellArray(2, (const mwSize*)pDims);

    /* Call Path finding algorithm */
    getPaths((mxArray*)prhs[0], (mxArray*)prhs[1], plhs[0], iNeigh, iFrames, *pDBSize);

}
