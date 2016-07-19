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



/* recursive function to expand tree */
void getNextSteps(TrellisTree* Tree,int *pFrameList, unsigned int* puiInd,double* pdDist, SimpleHashUnsafe<unsigned int>* HashTable, int iFrames, int iNeigh, int iTree){
   
    // Build current hash table
    HashTable->reset();
    HashTable->addElements(puiInd + iNeigh*(Tree->curNode->uiFrame+1),iNeigh);
    bool bFoundElement=false;
    
    double weight=0;

    // if leave node: do nothing
    if(Tree->curNode->uiValue>0){
    
        // go through all childs
        for(int i=0;i<Tree->curNode->uiGap;i++){
            
            //compute search element
            unsigned int search=Tree->curNode->uiValue+i;
            
            // if search elment is not part of current tree AND we are not at the end of frames
            if( *(pFrameList+search)==0 && Tree->curNode->uiDepth<iFrames ){ //*(pFrameList+search)==0 && //<iTree

                bFoundElement = HashTable->findElement(&search);
                
                if(bFoundElement){
   
                   *(pFrameList+search)=iTree;

                    Tree->curNode->addChild(search,i,weight);
                    Tree->setDeepNode(Tree->curNode->getChild(i));
                    Tree->setCurNode (Tree->curNode->getChild(i));
                    
                    // recursion: expand tree
                    getNextSteps(Tree,pFrameList,puiInd,pdDist,HashTable,iFrames, iNeigh,iTree);

                    Tree->setCurNode(Tree->curNode->getParent());

                }
                else{ //add leave node
                    Tree->curNode->addChild(0,i);
                }
            }
            else{ //add leave node
                Tree->curNode->addChild(0,i);
            }
        }
    }
}

/* Path finding algorithm */
void getPaths(mxArray* pInd, mxArray* pDis, mxArray* pPaths, int iNeigh, int iFrames, int iDBSize){

    // Some usefull variables
    double        dLengthFac = 0.5;
    unsigned int  uiGap      = 3;
    int           iNumPaths  = 0;
    int           iTreeCount = 1;
    
    // Frame list: stores where a frame occurs
    int          *pFrameList = new int[iDBSize];
    for(int i=0;i<iDBSize;i++) *(pFrameList+i) = 0;

    // Hash Table for searching elements
    SimpleHashUnsafe<unsigned int> *HashTable = new SimpleHashUnsafe<unsigned int>(iNeigh,iNeigh);
    
    for(int iCurFrame=0;iCurFrame<(1-dLengthFac)*iFrames ;iCurFrame++){ // (1-dLengthFac)*iFrames
        for(int iCurNeigh=0;iCurNeigh<iNeigh;iCurNeigh++){ //
// // //     for(int iCurFrame=0;iCurFrame<5 ;iCurFrame++){ // (1-dLengthFac)*iFrames
// // //         for(int iCurNeigh=0;iCurNeigh<10;iCurNeigh++){ //
            // get pointer to Index Matrix
            unsigned int* puiInd           = (unsigned int*)mxGetPr(pInd);
            double*       pdDist           = (double*)      mxGetPr(pDis);
            
            unsigned int   uiSearchElement = vuiInd(iCurNeigh,iCurFrame);
            
            TrellisTree curTree(uiSearchElement, uiGap, (unsigned int)iCurFrame);
            
            //Recursive evaluation of matrix
            getNextSteps(&curTree, pFrameList, puiInd, pdDist, HashTable, iFrames, iNeigh, iTreeCount);
            
            iTreeCount++;
            
            TrellisNode* curNode = curTree.getDeepNode();

            // If longest path is good write it to matrix
			if((curNode->uiDepth)>dLengthFac*iFrames){

                mwSize dims[2];
                dims[0] = (mwSize)2;
                dims[1] = (mwSize)curNode->uiDepth+1;

                mxArray *pSteps=mxCreateNumericArray(2,(const mwSize*)&dims,mxUINT32_CLASS,mxREAL);

                unsigned int* puiSteps=(unsigned int*)mxGetPr(pSteps);

                while(curNode->uiDepth>0){

                   *puiSteps = curNode->uiDepth+iCurFrame+1; puiSteps++;
                   *puiSteps = curNode->uiValue;             puiSteps++;

                    curNode=curNode->getParent();
                }
                
               *puiSteps = curNode->uiDepth+iCurFrame+1; puiSteps++;
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
