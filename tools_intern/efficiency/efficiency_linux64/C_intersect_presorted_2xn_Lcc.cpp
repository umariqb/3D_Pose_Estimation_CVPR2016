#include "mex.h"
#include <memory.h>
#include <stdio.h>

/*	printf("List %d: %d entries... ",i+1,cell_lengths[i]);
	for (j=0; j<cell_lengths[i]; j++)
		printf("%f ",((double*)vals)[j]);
	printf("\n");*/

int less(double* pA, int iA, double* pB, int iB)
{
	if (pA[iA]<pB[iB])
		return true;
	if (pA[iA]==pB[iB])
		if (pA[iA+1]<pB[iB+1])
			return true;
	return false;
}

int greater(double* pA, int iA, double* pB, int iB)
{
	if (pA[iA]>pB[iB])
		return true;
	if (pA[iA]==pB[iB])
		if (pA[iA+1]>pB[iB+1])
			return true;
	return false;
}

int equals(double* pA, int iA, double v[2])
{
	if (pA[iA]==v[0] && pA[iA+1]==v[1])
			return true;
	return false;
}

int C_intersect_presorted_2xn(double* list_out, double* pA, double* pB, int nlist_out, int nA, int nB, double* pIA, double* pIB, int* nIA, int* nIB)
{
	int		nOut = 0,
			iA = 0,
			iB = 0;
	double  v[2];

	while ((iA>>1)<nA && (iB>>1)<nB)
	{
		if (less(pA,iA,pB,iB))
		{
			iA+=2;
		}
		else 
		{
			if (greater(pA,iA,pB,iB))
			{
				iB+=2;
			}
			else // (pA[iA] == pB[iB])
			{
				v[0] = pA[iA]; v[1] = pA[iA+1];
				*list_out = v[0]; *(list_out+1) = v[1];
				list_out+=2;

				nOut++;
				while (equals(pA,iA,v) && (iA>>1)<nA) // fast forward through occurences of v
					iA+=2;			   
				while (equals(pB,iB,v) && (iB>>1)<nB) // (duplicate elimination!!)
					iB+=2;
				if (pIA != NULL) // record indices AFTER previous incrementations because of Matlab indexing!!
				{
					*(pIA++) = iA>>1;
					(*nIA)++;
				}
				if (pIB != NULL)
				{
					*(pIB++) = iB>>1;
					(*nIB)++;
				}
			}
		}

	}
	return nOut;
}

// [list_out, IA, IB] = C_intersect_presorted_2xn(A,B)

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
	plhs[0] = mxCreateDoubleMatrix(2,0,mxREAL);
	if (return_IA)
		plhs[1] = mxCreateDoubleMatrix(2,0,mxREAL);
	if (return_IB)
		plhs[2] = mxCreateDoubleMatrix(2,0,mxREAL);
	return;
  }

  pA = (double*)mxGetPr(A);
  pB = (double*)mxGetPr(B);

  /* Get the dimensions of the input arrays. */
  mA = mxGetM(A);  nA = mxGetN(A);
  mB = mxGetM(B);  nB = mxGetN(B);

  /* Check to make sure the two input arguments are real double 2 x n arrays. */
  if ((mxIsComplex(A) || !mxIsDouble(A) || (mA != 2)) ||
	  (mxIsComplex(B) || !mxIsDouble(B) || (mB != 2)))
  {
    mexErrMsgTxt("Inputs must be real double 2 x n arrays.");
  }

  max_list_out_length = (nA<nB?nA:nB);	  // min(nA,nB)

  /* Create a C pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(2, max_list_out_length, mxREAL);
  list_out = (double*)mxGetPr(plhs[0]);

  if (return_IA)
  {
	  plhs[1] = mxCreateDoubleMatrix(1, nA, mxREAL);
	  pIA = (double*)mxGetPr(plhs[1]);
  }
  if (return_IB)
  {
	  plhs[2] = mxCreateDoubleMatrix(1, nB, mxREAL);
	  pIB = (double*)mxGetPr(plhs[2]);
  }

  /* Call the C subroutine. */
  list_out_length = C_intersect_presorted_2xn(list_out,pA,pB,max_list_out_length,nA,nB,pIA,pIB,&nIA,&nIB);

  /* Resize output arrays to required sizes. */
  list_out = (double*)mxRealloc(list_out,2*list_out_length*sizeof(double));
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
