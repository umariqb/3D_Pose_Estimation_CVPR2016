#include "mex.h"
#include <memory.h>
#include <stdio.h>
// function result_list = concat_lists(lists)
// result_list is a double vector
// lists is a cell array of double vectors

void C_concat_lists(const mxArray* lists, double *output, int m_lists, int *cell_lengths)
{
  mxArray *cell;
  void *vals;
  int i,pos = 0;
  
  for (i = 0; i < m_lists; i++) 
  {
/*	printf("List %d: %d entries... ",i+1,cell_lengths[i]);
	for (j=0; j<cell_lengths[i]; j++)
		printf("%f ",((double*)vals)[j]);
	printf("\n");*/
	if (cell_lengths[i]>0)
	{
		cell = mxGetCell(lists,i);
		vals = mxGetData(cell);
		memcpy((void*)(&(output[pos])), vals, cell_lengths[i]*sizeof(double));
		pos += cell_lengths[i];
	}
  }
}


/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double *output;
  mxArray *cell;
  const mxArray *lists;
  int i,m_lists,n_lists,m,n,output_length=0,*cell_lengths;
  
  /*  Check for proper number of arguments. */
  /* NOTE: You do not need an else statement when using
     mexErrMsgTxt within an if statement. It will never
     get to the else statement if mexErrMsgTxt is executed.
     (mexErrMsgTxt breaks you out of the MEX-file.) 
  */
  if (nrhs != 1) 
    mexErrMsgTxt("One input required.");
//  if (nlhs != 1) 
//    mexErrMsgTxt("One output required.");
  
  /* Check to make sure the first input argument is a cell array. */
  if (!mxIsCell(prhs[0]))
  {
    mexErrMsgTxt("Input must be a cell array.");
  }
  
/* Get the cell array lists. */
  lists = prhs[0];

  if (mxIsEmpty(lists))
  {
	plhs[0] = mxCreateDoubleMatrix(0,1,mxREAL);	
	return;
  }

  /* Get the dimensions of the cell array. */
  m_lists = mxGetM(lists);
  n_lists = mxGetN(lists);

  if (m_lists != 1 && n_lists != 1)
	mexErrMsgTxt("Cell array input must be 1 x n or m x 1.");
  else
	m_lists = (m_lists>n_lists?m_lists:n_lists);
  
  
  cell_lengths = (int*)mxCalloc(m_lists, sizeof(int));
  // Compute output length and cell entry lengths
  for (i=0; i<m_lists; i++)
  {
	cell = mxGetCell(lists,i);
	if (cell == NULL || mxIsEmpty(cell))
	{
		cell_lengths[i] = 0;
		continue;
	}
	m = mxGetM(cell);
	n = mxGetN(cell);

	if (mxIsComplex(cell) || !mxIsDouble(cell) || (m != 1 && n != 1))
		mexErrMsgTxt("Each cell array entry must be a 1 x n or m x 1 real double array.");
	else
		m = (m>n?m:n);
	output_length += m;	  
	cell_lengths[i] = m;
  }
		  
  /* Set the output pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(1,output_length, mxREAL);
  
  /* Create a C pointer to a copy of the output matrix. */
  output = mxGetPr(plhs[0]);
  
  /* Call the C subroutine. */
  C_concat_lists(lists,output,m_lists,cell_lengths);
  mxFree(cell_lengths);
}
