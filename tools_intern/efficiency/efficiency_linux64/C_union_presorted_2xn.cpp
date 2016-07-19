#include "mex.h"
#include <memory.h>
#include <stdio.h>
#include <float.h>
#pragma warning (disable:4786)
#include <map>

typedef std::pair<double,double> DoublePair;

int C_union_presorted(const mxArray* lists, double *output, int m_lists, int *cell_lengths)
{
  mxArray	*cell;
  int		i,
			num_out = 0,
			idx;
  bool		done = false;
  double	**pointers, 
			**end_pointers;
  DoublePair min_val;

  std::multimap<DoublePair,int>::iterator iter_end, iter;
  std::multimap<DoublePair,int> min_map; // this map will hold indices into the pointers array, sorted by the list entry value to which they pertain


// Initialize pointer arrays and min map. Each entry points at beginning/one behind the end of its list, respectively.
  pointers = (double**)mxCalloc(m_lists, sizeof(double*));
  end_pointers = (double**)mxCalloc(m_lists, sizeof(double*));
  for (i = 0; i < m_lists; i++) 
  {
	cell = mxGetCell(lists,i);
	if (cell_lengths[i]>0) 
	{
		pointers[i] = (double*)(mxGetData(cell));
		end_pointers[i] = (double*)(mxGetData(cell))+2*cell_lengths[i];
		min_map.insert(std::pair<DoublePair,int>(DoublePair(*(pointers[i]),*(pointers[i]+1)),i));
	}
	else // ignore empty cells
		end_pointers[i] = NULL;
  }

  while (!min_map.empty())
  {
// find last entry in min_map with the key min_val (the skipped entries correspond to duplicates in the sets that are being joined)
	  done = true;
	  iter_end = min_map.end();
	  min_val = min_map.begin()->first;

// now, fast forward the list pointers of all lists which are currently at a value of min_val
	  for (iter = min_map.begin(); iter!=iter_end && iter->first<=min_val;) // iterator incrementation will be done below
	  {
		idx = iter->second; 
		while (pointers[idx] < end_pointers[idx] && DoublePair(*(pointers[idx]),*(pointers[idx]+1))<=min_val)
			pointers[idx]+=2;

// erase the entry that has just been processed, 
//		iter = min_map.erase(iter);
		min_map.erase(iter++);

		if (pointers[idx]<end_pointers[idx]) // this list hasn't hit the end yet
// insert new entry for the new pointer position into min_map
			min_map.insert(std::pair<DoublePair,int>(DoublePair(*(pointers[idx]),*(pointers[idx]+1)),idx));
	  }

// append min_val to the output
	  output[2*num_out] = min_val.first;
	  output[2*num_out+1] = min_val.second;
	  num_out++;
  }
  
  mxFree(pointers);
  mxFree(end_pointers);
  return num_out;
}


/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double *output;
  mxArray *cell;
  const mxArray *lists;
  int i,
	  m_lists,
	  n_lists,
	  m,
	  n,
	  max_output_length=0,
	  output_length,
	  *cell_lengths;
  
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

	if (mxIsComplex(cell) || !mxIsDouble(cell) || (m != 2))
		mexErrMsgTxt("Each cell array entry must be a 2 x n real double array.");
	
	max_output_length += n;	  
	cell_lengths[i] = n;
  }
		  
  /* Set the output pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(2,max_output_length, mxREAL);
  
  /* Create a C pointer to a copy of the output matrix. */
  output = mxGetPr(plhs[0]);

  /* Call the C subroutine. */
  output_length = C_union_presorted(lists,output,m_lists,cell_lengths);

  /* Resize output array to required size. */
  output = (double*)mxRealloc(output,2*output_length*sizeof(double));
  mxSetPr(plhs[0], output);
  mxSetN(plhs[0], output_length);

  mxFree(cell_lengths);
}
