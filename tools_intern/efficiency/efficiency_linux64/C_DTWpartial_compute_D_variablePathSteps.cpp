// given a C (cost) matrix, this function computes the D (dynamic programming) and E (predecessor) matrices 
// for a partial match DTW
#include "mex.h"
#include <float.h>
#include <cmath>
#include <memory.h>

inline double min_choice(double* x, int n, unsigned char& choice)
{
	double mn = DBL_MAX;
	unsigned char i;
	choice = 0;

	for (i=0; i<n; i++)
	{
		if ((x[i] < mn) & !isnan(x[i]))
		{
			mn = x[i];
			choice = i;
		}
	}
	if (mn==DBL_MAX) // all numbers in x were NaN
	{
		choice = 0;
		mn = x[0];
	}
	return mn;
}

inline int max(int a, int b)
{
	return (a<b?b:a);
}

	//mexPutVariable("caller", "D", D);
	//mexEvalString("D");

#define vC(i,j) (*(pC + m*(j) + (i)))		// Matlab stores arrays columnwise
#define vD(i,j) (*(pD + (m+max_di)*(j+max_dj) + (max_di) + (i)))
#define vD_temp(i,j) (*(pD + (m+max_di)*(j) + (i)))
#define vE(i,j) (*(pE + m*(j) + (i)))

const unsigned short nan_words[4] = {0x0000, 0x0000, 0x0000, 0x7ff8};
const double* nanW = (double*)nan_words;

void NaN_fill(double* p, int n)
{
	int k;
	for (k=0; k<n; k++)
	{
		p[k] = *nanW;
	}
}


void C_DTWpartial_compute_D_variablePathSteps(double* pC, double* pD, unsigned char* pE, 
											  int m, int n, 
											  int* pdi, int* pdj, double* pdWeights,
											  int num_pathSteps, int max_di, int max_dj)
// C and E have m rows, n columns
// D has m+max_di rows, n+max_di columns, but we only use the portion [max_di:max_di+m,max_dj:max_dj+m]
{
	int i, j, k, pi, pj;
	unsigned char choice;
	double *h;
	
	NaN_fill(pD, max_dj*(m+max_di)); // NaN-pad first max_dj columns
	for (j=max_dj; j<n+max_dj; j++)  // NaN-pad first max_di rows (columnwise due to array representation)
	{
		NaN_fill(pD+(m+max_di)*j, max_di);
	}

	h = (double*)mxMalloc(num_pathSteps*sizeof(double));

//	vD(0,0) = vC(0,0);
	
//	for (i=1; i<m; i++)
//		vD(i,0) = vD(i-1,0) + vC(i,0);

	for (j=0; j<n; j++)
		vD(0,j) = vC(0,j);
		

	if (pE) // pE is NULL if no E matrix was requested as an output
	{
		for (i=1; i<m; i++)
			for (j=0; j<n; j++)
			{
				for (k=0; k<num_pathSteps; k++) // get entries from D matrix that correspond to (di;dj)
				{
					pi = i - pdi[k];
					pj = j - pdj[k];
					h[k] = vD(pi, pj);
				}
				vD(i,j) = min_choice(h, num_pathSteps, choice); 
				vD(i,j) += pdWeights[choice]*vC(i,j);
				vE(i,j) = choice+1; // +1 because of Matlab indexing
			}
	}
	else
	{
		for (i=1; i<m; i++)
			for (j=0; j<n; j++)
			{
				for (k=0; k<num_pathSteps; k++) // get entries from D matrix that correspond to (di;dj)
				{
					pi = i - pdi[k];
					pj = j - pdj[k];
					h[k] = vD(pi, pj);
				}
				vD(i,j) = min_choice(h, num_pathSteps, choice); 
				vD(i,j) += pdWeights[choice]*vC(i,j);
			}
	}
	mxFree(h);
}

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double			*pC,
					*pD,
					*pD_temp,
					*pdWeights;
  int				*pdi,
					*pdj,
					k;
  unsigned char  	*pE;

  const mxArray *C, *di, *dj, *dWeights;
  int m, n, num_pathSteps;

  if (nrhs != 4) 
    mexErrMsgTxt("Four inputs required.");
  
  if (nlhs < 1) 
    mexErrMsgTxt("At least one output required.");

  C = prhs[0];
  di = prhs[1];
  dj = prhs[2];
  dWeights = prhs[3];
  if (mxIsEmpty(C) || mxIsEmpty(di) || mxIsEmpty(dj) || mxIsEmpty(dWeights))
  {
	plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
	if (nlhs > 1) 
		plhs[1] = mxCreateNumericMatrix(0, 0, mxUINT8_CLASS, mxREAL);
	return;
  }
  /* Check to make sure the input argument is a real double array. */
  if ((mxIsComplex(C) || !mxIsDouble(C)) || (mxIsComplex(di) || !mxIsInt32(di)) || 
	  (mxIsComplex(dj) || !mxIsInt32(dj)) || (mxIsComplex(dWeights) || !mxIsDouble(dWeights)))
  {
    mexErrMsgTxt("Inputs one and four must be real double arrays, inputs two and three must be INT32 arrays.");
  }

  /* Get the dimensions of the input arrays. */
  m = mxGetM(C);  n = mxGetN(C);
  num_pathSteps = mxGetNumberOfElements(di);
  
  pC = (double*)mxGetPr(C);
  pdWeights = (double*)mxGetPr(dWeights);
	
  pdi = (int*)mxGetPr(di);
  pdj = (int*)mxGetPr(dj);

  int max_di = 0, max_dj = 0;
  for (k=0; k<num_pathSteps; k++)
  {
		if (pdi[k]>max_di)
			max_di = pdi[k];
		if (pdj[k]>max_dj)
			max_dj = pdj[k];
  }

  pD_temp = (double*)mxMalloc((m+max_di)*(n+max_dj)*sizeof(double));

  if (nlhs > 1) 
  {
	plhs[1] = mxCreateNumericMatrix(m, n, mxUINT8_CLASS, mxREAL);
	pE = (unsigned char*)mxGetPr(plhs[1]);
  }
  else
	  pE = 0;

    /* Call the C subroutine. */
  C_DTWpartial_compute_D_variablePathSteps(pC, pD_temp, pE, m, n, pdi, pdj, pdWeights, num_pathSteps, max_di, max_dj);

  /* Create a C pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
//  plhs[0] = mxCreateDoubleMatrix(m+max_di, n+max_dj, mxREAL);
  pD = (double*)mxGetPr(plhs[0]);

  // copy relevant portion of pD_temp matrix into pD matrix
  int num_bytes_per_output_column = m*sizeof(double);
  double* p_source = pD_temp+(m+max_di)*max_dj+max_di;
  for (k=0; k<n; k++)
  {
	  memcpy(pD,p_source,num_bytes_per_output_column);
	  pD += m; // advance output pointer by one output column length
	  p_source += m+max_di; // advance output pointer by one input column length
  }
  //memcpy(pD,pD_temp,(m+max_di)*(n+max_dj)*sizeof(double));

  mxFree(pD_temp);
}
