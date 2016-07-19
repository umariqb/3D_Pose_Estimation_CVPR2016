#include "mex.h"
#include "ngraph.h"

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double			*pC,
					*pD;
  unsigned char  	*pE;

  const mxArray *C;
  const mxArray *maxDist;
  
  unsigned int dim, nPoints;

  /*  Check for proper number of arguments. */
  if (nrhs != 2) 
    mexErrMsgTxt("Two inputs required.");
  
  if (nlhs != 2) 
    mexErrMsgTxt("Two outputs required.");

  
  C       = prhs[0];
  maxDist = prhs[1];
  
  
  if (mxIsEmpty(C))
  {
	plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
	if (nlhs > 1) 
		plhs[1] = mxCreateNumericMatrix(0, 0, mxUINT8_CLASS, mxREAL);
	return;
  }
  
  /* Check to make sure the input argument is a real double array. */
  if ((mxIsComplex(C) || !mxIsDouble(C)))
  {
    mexErrMsgTxt("Input must be a real double array.");
  }

  /* Get the dimensions of the input array. */
  dim = mxGetM(C);  nPoints = mxGetN(C);
  
  pC = (double*)mxGetPr(C);

 
  NGraph* ngraph;
  ngraph = new NGraph(dim, nPoints, pC,*mxGetPr(maxDist));
  
  plhs[0] = mxCreateNumericMatrix(1,ngraph->nAdj,       mxUINT32_CLASS, mxREAL);
  plhs[1] = mxCreateNumericMatrix(1,ngraph->nPoints,    mxUINT32_CLASS, mxREAL);
 
  mxSetData(plhs[0], ngraph->adjGraph);
  mxSetData(plhs[1], ngraph->adjIndex);
}

