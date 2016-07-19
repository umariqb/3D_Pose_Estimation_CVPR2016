#define _LINUX_

//#define DEBUG

#include "mex.h"
#include "matrix.h"
#include <stdio.h>

#if ( defined(_LINUX_) && !defined(_WINDOWS_) )
	#include <algorithm>
	#include <stdlib.h>
	using namespace std;
#endif

void multiply(double* core, double* factors,const int* T_Dims  ,double* result){
    
    int cols=*T_Dims;
    int rows=*T_Dims++;
    
  	result = new double[cols*rows];

	int count = 0;

	int cc = 0;
	int ii;

	for (int c = 0; c < cols; c++)
	{
		for (int r = 0; r < rows; r++)
		{
			result[count] = 0.0;
			ii = 0;
			for (int i = 0; i < cols; i++)
			{
				result[count] += core[r+ii] * factors[i+cc];
				ii+=rows;
			}
			count++;
		}
		cc += rows;
	}
}



void mexFunction(int nlhs,       mxArray *plhs[], 
    		     int nrhs, const mxArray *prhs[] )
{

    if (nrhs!=3)
        mexErrMsgTxt("Wrong number of input arguments!\n");
    else{
        
        mxArray* output;
        
        mwSize   T_NumDim;
        
        const int* T_Dims;
        
        T_Dims   = mxGetDimensions(prhs[0]);
        T_NumDim = mxGetNumberOfDimensions(prhs[0]);
        
        #ifdef DEBUG 
        {
            mexPrintf("Dimension of core Tensor:");
            for(mwIndex i = 0;i<T_NumDim;i++)
                mexPrintf(" %i ", T_Dims[i]);
            
        }
        #endif
              
        double* pOut;
        double* a     = mxGetPr(prhs[0]);
        double* b     = mxGetPr(prhs[1]);
        double* result;

        multiply(a,b,T_Dims,result);

        output = mxCreateDoubleMatrix(*T_Dims,*T_Dims++, mxREAL);

        pOut = mxGetPr(output);

        memcpy(pOut, &result, *T_Dims**T_Dims++*sizeof(double));

        plhs[0]=output;
    }
}

