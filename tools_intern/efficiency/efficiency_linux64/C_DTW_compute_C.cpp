#include "mex.h"
#include <float.h>

#define vC(i,j) (*(pC + n*(j) + (i)))		// Matlab stores arrays columnwise
#define vVd(i,j) (*(pVd + n*(j) + (i)))
#define vWd(i,j) (*(pWd + m*(j) + (i)))
#define vVb(i,j) (*(pVb + n*(j) + (i)))
#define vWb(i,j) (*(pWb + m*(j) + (i)))

void C_DTW_compute_C_double(double* pVd, double* pWd, double* pC, int n, int p, int m)
// V has n rows, p columns
// W has m rows, p columns
// C has n rows, m columns
{
	int i, j, k;

	for (i=0; i<n; i++)
		for (j=0; j<m; j++)
			for (k=0; k<p; k++)
		        if (_isnan(vVd(i,k)))
					vC(i,j) = vVd(i,k);
				else
				{
					if (_isnan(vWd(j,k)))
						vC(i,j) = vWd(j,k);
					else
						vC(i,j) += ((double)((vVd(i,k) != vWd(j,k)) && (vVd(i,k)!=0.5) && (vWd(j,k)!=0.5)))/p;
				}
}

void C_DTW_compute_C_bool(bool* pVb, bool* pWb, double* pC, int n, int p, int m)
// V has n rows, p columns
// W has m rows, p columns
// C has n rows, m columns
{
	int i, j, k;

	for (i=0; i<n; i++)
		for (j=0; j<m; j++)
			for (k=0; k<p; k++)
		        if (_isnan(vVb(i,k)))
					vC(i,j) = vVb(i,k);
				else
				{
					if (_isnan(vWb(j,k)))
						vC(i,j) = vWb(j,k);
					else
						vC(i,j) += ((double)((vVb(i,k) != vWb(j,k))))/p;
				}
}

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double			*pC,
					*pVd,
					*pWd;
  bool				*pVb,
					*pWb;
  
  const mxArray *V, *W;

  int m, n, p, q;

  /*  Check for proper number of arguments. */
  if (nrhs < 2) 
    mexErrMsgTxt("Two inputs required.");
  
  if (nlhs < 1) 
    mexErrMsgTxt("One output required.");

  V = prhs[0];
  W = prhs[1];
  
  if (mxIsEmpty(V) || mxIsEmpty(W))
  {
	plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
	return;
  }
  
  /* Check to make sure the input arguments are real double or logical arrays. */
  bool VRealDouble = !mxIsComplex(V) && mxIsDouble(V);
  bool WRealDouble = !mxIsComplex(W) && mxIsDouble(W);
  bool VLogical = mxIsLogical(V);
  bool WLogical = mxIsLogical(W);
  if (!((VRealDouble && WRealDouble) || (VLogical && WLogical)))
    mexErrMsgTxt("Inputs must be either both real double or both logical arrays.");

  /* Get the dimensions of the input arrays. */
  n = mxGetM(V); p = mxGetN(V); m = mxGetM(W); q = mxGetN(W);
  if (q != p)
    mexErrMsgTxt("Number of columns must be the same for both inputs.");

  plhs[0] = mxCreateDoubleMatrix(n, m, mxREAL);
  /* Create a C pointer to the output matrix. */
  pC = (double*)mxGetPr(plhs[0]);

  if (mxIsLogical(V))
  {
	pVb = (bool*)mxGetPr(V);
	pWb = (bool*)mxGetPr(W);
    /* Call the C subroutine. */
	C_DTW_compute_C_bool(pVb, pWb, pC, n, p, m);
  }
  else // mxIsDouble(V)
  {
	pVd = (double*)mxGetPr(V);
	pWd = (double*)mxGetPr(W);
    /* Call the C subroutine. */
	C_DTW_compute_C_double(pVd, pWd, pC, n, p, m);
  }
}
