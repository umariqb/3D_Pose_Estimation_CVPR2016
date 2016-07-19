
#include "mex.h"

#ifndef PATH
#define PATH

#define vStepsT(i,j)   (*(pStepsT + 2*(j) + (i)))

class Path
{
    public:
    unsigned int  iSteps;
    mxArray      *pSteps;
    double        dDist;
    
    int          *dims;
    
    Path(unsigned int uiSize)
    {
        iSteps = 0;
        dDist  = 0;
        
        int dims[2];
        dims[0] = 2; 
        dims[1] = uiSize;
        
        pSteps = mxCreateNumericArray(2,(const mwSize*)dims,mxUINT32_CLASS,mxREAL);
        unsigned int *pStepsT=(unsigned int*)mxGetPr(pSteps);
        vStepsT(0,0) = 0;
        vStepsT(1,0) = 0;
        
    };
    
    Path(unsigned int iStepsG, mxArray *pStepsG, double dDistG){
        
        iSteps = iStepsG;
        dDist  = dDistG;
        
        dims    = new int[2];
        dims[0] = 2;
        dims[1] = iStepsG;
        
        pSteps = pStepsG;
        
    };
    
    ~Path()
    {
//         mexPrintf("D");
    };
    
// // //     void resize(int size){
// // //         
// // //         mexPrintf("\n-- resize --\n");
// // //         
// // //         dims[0] = 2; 
// // //         dims[1] = size;
// // //         mexPrintf(" A ");
// // //         mxArray *pNewSteps;
// // //         mexPrintf(" B ");
// // //         pNewSteps = mxCreateNumericArray(2,(const mwSize*)dims,mxUINT32_CLASS,mxREAL);
// // //         // Copy Content
// // //         
// // //         mexPrintf(" C ");
// // //         
// // //         // delete old Matrix
// // //         mxDestroyArray(pSteps);
// // //         
// // //         mexPrintf(" D ");
// // //         pSteps=pNewSteps;
// // //         mexPrintf(" E ");
// // //     }
    
    void addStep(unsigned int f, unsigned int c, double d){
        
        dDist = dDist + d;
        
        unsigned int *pStepsT=(unsigned int*)mxGetPr(pSteps);
        
        vStepsT(0,iSteps) = f;
        vStepsT(1,iSteps) = c;
        
        iSteps++;
        
//         mexPrintf("added Step %i: %i , %i\n",iSteps,vStepsT(0,iSteps),vStepsT(1,iSteps));

    }
    
    int getNumSteps(){
        return iSteps;
    }
    
    double getDistance(){
        return dDist;
    }
    
    int getLastFrame(){
        int *pStepsT=(int*)mxGetPr(pSteps);
        return vStepsT(1,iSteps-1);
    }
    
    void printPath(){
        unsigned int *pStepsT=(unsigned int*)mxGetPr(pSteps);
        mexPrintf("-PATH------\n");

        for(int i=0;i<iSteps;i++){
            mexPrintf("%i : %i\n",vStepsT(0,i),vStepsT(1,i));
            pStepsT=pStepsT+2;
        }
        mexPrintf("-----------\n");
        
    }
    
   
};

#endif
