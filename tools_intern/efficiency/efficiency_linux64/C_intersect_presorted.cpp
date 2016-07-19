#include "mex.h"
#include <memory.h>
#include <stdio.h>

/*	printf("List %d: %d entries... ",i+1,cell_lengths[i]);
	for (j=0; j<cell_lengths[i]; j++)
		printf("%f ",((double*)vals)[j]);
	printf("\n");*/


int C_intersect_presorted(double* list_out, double* pA, double* pB, int mA, int mB, double* pIA, double* pIB, int* nIA, int* nIB)
{
	int		nOut = 0,
			iA = 0,
			iB = 0;
	double  v;

	while (iA<mA && iB<mB)
	{
		if (pA[iA] < pB[iB])
		{
			iA++;
		}
		else 
		{
			if (pA[iA] > pB[iB])
			{
				iB++;
			}
			else // (pA[iA] == pB[iB])
			{
				v = pA[iA];
				*(list_out++) = v;
				nOut++;
				while (pA[iA] == v && iA<mA) // fast forward through occurences of v
					iA++;			   
				while (pB[iB] == v && iB<mB) // (duplicate elimination!!)
					iB++;
				if (pIA != NULL) // record indices AFTER previous incrementations because of Matlab indexing!!
				{
					*(pIA++) = iA;
					(*nIA)++;
				}
				if (pIB != NULL)
				{
					*(pIB++) = iB;
					(*nIB)++;
				}
			}
		}

	}
	return nOut;
}

// [list_out, IA, IB] = C_intersect_presorted(A,B)

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double *pA,
	     *pB,
		 *pIA=NULL,
		 *pIB=NULL,
		 *list_out;
  const mxArray *A,*B;
  int mA,
	  nA,
	  mB,
	  nB,
	  nIA=0,
	  nIB=0,
	  max_list_out_length,
	  list_out_length;
  bool return_IA = false,
	   return_IB = false;
  
  /*  Check for proper number of arguments. */
  /* NOTE: You do not need an else statement when using
     mexErrMsgTxt within an if statement. It will never
     get to the else statement if mexErrMsgTxt is executed.
     (mexErrMsgTxt breaks you out of the MEX-file.) 
  */
  if (nrhs != 2) 
    mexErrMsgTxt("Two inputs required.");
  
  if (nlhs>1)
	  return_IA = true;
  if (nlhs>2)
	  return_IB = true;

  A = prhs[0];
  B = prhs[1];

  if (mxIsEmpty(A) || mxIsEmpty(B))
  {
	plhs[0] = mxCreateDoubleMatrix(0,1,mxREAL);
	if (return_IA)
		plhs[1] = mxCreateDoubleMatrix(0,1,mxREAL);
	if (return_IB)
		plhs[2] = mxCreateDoubleMatrix(0,1,mxREAL);
	return;
  }

  pA = (double*)mxGetPr(A);
  pB = (double*)mxGetPr(B);

  /* Get the dimensions of the input arrays. */
  mA = mxGetM(A);  nA = mxGetN(A);
  mB = mxGetM(B);  nB = mxGetN(B);

  /* Check to make sure the two input argument are real double vectors. */
  if ((mxIsComplex(A) || !mxIsDouble(A) || (mA != 1 && nA != 1)) ||
	  (mxIsComplex(B) || !mxIsDouble(B) || (mB != 1 && nB != 1)))
  {
    mexErrMsgTxt("Inputs must be real double vectors.");
  }
  mA = (mA>nA?mA:nA);
  mB = (mB>nB?mB:nB);

  max_list_out_length = (mA<mB?mA:mB);	  

  /* Create a C pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(1,max_list_out_length, mxREAL);
  list_out = (double*)mxGetPr(plhs[0]);

  if (return_IA)
  {
	  plhs[1] = mxCreateDoubleMatrix(1,mA, mxREAL);
	  pIA = (double*)mxGetPr(plhs[1]);
  }
  if (return_IB)
  {
	  plhs[2] = mxCreateDoubleMatrix(1,mB, mxREAL);
	  pIB = (double*)mxGetPr(plhs[2]);
  }

  /* Call the C subroutine. */
  list_out_length = C_intersect_presorted(list_out,pA,pB,mA,mB,pIA,pIB,&nIA,&nIB);

  /* Resize output arrays to required sizes. */
  list_out = (double*)mxRealloc(list_out,list_out_length*sizeof(double));
  mxSetPr(plhs[0], list_out);
  mxSetN(plhs[0], list_out_length);

  if (return_IA)
  {
	  pIA = (double*)mxRealloc(pIA,nIA*sizeof(double));
	  mxSetPr(plhs[1], pIA);
	  mxSetN(plhs[1], nIA);
  }
  if (return_IB)
  {
	  pIB = (double*)mxRealloc(pIB,nIB*sizeof(double));
	  mxSetPr(plhs[2], pIB);
	  mxSetN(plhs[2], nIB);
  }
}
