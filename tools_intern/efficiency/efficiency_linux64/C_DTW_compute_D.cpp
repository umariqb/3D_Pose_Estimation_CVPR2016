// given a C (cost) matrix, this function computes the D (dynamic programming) and E (predecessor) matrices 
// for a regular DTW

#include "mex.h"
#include <float.h>
#include <cmath>


inline double min_choice(double a, double b, double c, unsigned char& choice)
{
	double mn = DBL_MAX;
	choice = 1;

	if ((a < mn) & !isnan(a))
	{
		mn = a;
	}
	if ((b < mn) & !isnan(b))
	{
		mn = b;
		choice = 2;
	}
	if ((c < mn) & !isnan(c))
	{
		mn = c;
		choice = 3;
	}
	return mn;
}

inline double min(double a, double b, double c)
{
	if (a < b & !isnan(a))
	{
		if (a < c & !isnan(a))
		{
			return a;
		}
		else
		{
			if (b < c & !isnan(b))
				return b;
			else
				return c;
		}
	}
	else
	{
		if (b < c & !isnan(b))
		{
			return b;
		}
		else
		{
			if (a < c & !isnan(a))
				return a;
			else
				return c;
		}
	}
}

	//mexPutVariable("caller", "D", D);
	//mexEvalString("D");

#define vC(i,j) (*(pC + m*(j) + (i)))		// Matlab stores arrays columnwise
#define vD(i,j) (*(pD + m*(j) + (i)))
#define vE(i,j) (*(pE + m*(j) + (i)))
void C_DTW_compute_D(double* pC, double* pD, unsigned char *pE, int m, int n) // , mxArray* D
// C, D and E have m rows, n columns
{
	int i, j;

	vD(0,0) = vC(0,0);
	
	for (i=1; i<m; i++)
		vD(i,0) = vD(i-1,0) + vC(i,0);

	for (j=1; j<n; j++)
		vD(0,j) = vD(0,j-1) + vC(0,j);
		
	if (pE) // pE is non-NULL if an E matrix was requested as an output
	{
		for (i=1; i<m; i++)
			for (j=1; j<n; j++)
				vD(i,j) = min_choice(vD(i-1,j-1), vD(i,j-1), vD(i-1,j), vE(i,j)) + vC(i,j); // 1 = diag, 2 = horz, 3 = vert
	}
	else
	{
		for (i=1; i<m; i++)
			for (j=1; j<n; j++)
				vD(i,j) = min(vD(i-1,j-1), vD(i,j-1), vD(i-1,j)) + vC(i,j); // 1 = diag, 2 = horz, 3 = vert
	}
}

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double			*pC,
					*pD;
  unsigned char  	*pE;

  const mxArray *C;
  int m, n;

  /*  Check for proper number of arguments. */
  /* NOTE: You do not need an else statement when using
     mexErrMsgTxt within an if statement. It will never
     get to the else statement if mexErrMsgTxt is executed.
     (mexErrMsgTxt breaks you out of the MEX-file.) 
  */
  if (nrhs != 1) 
    mexErrMsgTxt("One input required.");
  
  if (nlhs < 1) 
    mexErrMsgTxt("At least one output required.");

  C = prhs[0];
  
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
  m = mxGetM(C);  n = mxGetN(C);
  
  pC = (double*)mxGetPr(C);

  /* Create a C pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
  pD = (double*)mxGetPr(plhs[0]);
  if (nlhs > 1) 
  {
	plhs[1] = mxCreateNumericMatrix(m, n, mxUINT8_CLASS, mxREAL);
	pE = (unsigned char*)mxGetPr(plhs[1]);
  }
  else
	  pE = 0;

    /* Call the C subroutine. */
  C_DTW_compute_D(pC, pD, pE, m, n);
}
