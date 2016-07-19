
#include <kdtree.h>
#include <mex.h>

#include <string.h>


void mexFunction(int nlhs, mxArray * plhs[], int nrhs,
		 const mxArray * prhs[])
{

  int rangeDim;
  int nRanges = 1;
	KDTree *tree;

  if (nrhs < 2) {
    mexPrintf("Must pass in a tree and a list of ranges\n");
    return;
  }
  
  if(mxIsClass(prhs[0],"kdtree")==0) {
    mexPrintf("First argument must be a kdtree class\n");
    return;
  }
  tree = KDTree::unserialize(mxGetPr(mxGetFieldByNumber(prhs[0],0,0)));
    
  // Verify the point array
  rangeDim = mxGetNumberOfDimensions(prhs[1]);
  if(rangeDim < 2 || rangeDim > 3) {
    mexPrintf("Invalid point array passed in.\n");
    delete tree;
    return;
  }
  if(rangeDim ==2) {
    if ((int)mxGetM(prhs[1]) != tree->ndim || (int)mxGetN(prhs[1]) != 2) {
      mexPrintf("Range input must have size (ndim , 2)\n");
      delete tree;
      return;
    }
    nRanges = 1;
  }
  else {
    int dims[3];
    memcpy(dims,mxGetDimensions(prhs[1]),sizeof(int)*3);
    if(dims[1] != tree->ndim || dims[2] != 2) {
      mexPrintf("Multple range input must have size (N,ndim,2)\n");
      delete tree;
      return;
    }
    nRanges = dims[0];
  }
  

  // Create a cell array of outputs for the 
  // different input ranges, if there are more
  // than 1
  if(nRanges > 1) {
    plhs[0] = mxCreateCellMatrix(nRanges,1);
    if(nlhs > 1)
      plhs[1] = mxCreateCellMatrix(nRanges,1);
  }


  // Allocate memory for the ranges that will
  // be passed into the tree iter function
  Range *ranges = new Range[tree->ndim];
  float *rdata = new float[tree->ndim*2];

  // Set pointers for the array of ranges
  for(int i=0;i<tree->ndim;i++) 
    ranges[i] = rdata+i*2;
	
  // Iterate through all possible ranges
  for(int n=0;n<nRanges;n++) {    
		
    // Extract the appropriate points from the input arrays
    // of ranges -- the indexing is such that the data is in 
    // the "transposed" order from what one would normally 
    // expect in C -- hence the funny indexing
    if (mxIsSingle(prhs[1])) {
      float *tmp = (float *) mxGetPr(prhs[1]);
      for(int i=0;i<tree->ndim;i++) {
				rdata[i]  =  tmp[0*nRanges*tree->ndim + i*nRanges + n];
				rdata[i+1] = tmp[1*nRanges*tree->ndim + i*nRanges + n];
      }
    }
    // The input can be double precision too
    else if (mxIsDouble(prhs[1])) {
      double *tmp = (double *) mxGetPr(prhs[1]);
      for(int i=0;i<tree->ndim;i++) {
				rdata[2*i] = (float)
					tmp[0*nRanges*tree->ndim + i*nRanges + n];
				rdata[2*i+1] = (float)
					tmp[1*nRanges*tree->ndim + i*nRanges + n];
      }
    }
    // Input must be single or double precision
    else {
      mexPrintf("Input ranges must be single or double precision");
      delete tree;
      return;
    }
	 
    // Find the points within the input range
    // This part actually does all the work
		tree->get_points_in_range(ranges);

    // Set the output array -- defaults to double format
    double *outPtr = (double *)0;
    double *outPtr2 = (double *)0;
    mxArray *mxOut=0,*mxOut2=0;
    mxOut = mxCreateDoubleMatrix(1,tree->nPntsInRange, mxREAL);
    outPtr = (double *) mxGetPr(mxOut);
    if(nlhs > 1) {
      mxOut2 = mxCreateDoubleMatrix(tree->nPntsInRange,tree->ndim,mxREAL);
      outPtr2 = (double *)mxGetPr(mxOut2);
    }
    // Populate the MATLAB arrays
    for (int i = 0; i < tree->nPntsInRange; i++) {
      outPtr[i] = (double) tree->pntsInRange[i] + 1;
      if(outPtr2) {
				for (int j = 0; j < tree->ndim; j++) {
					// Take the transpose because MATLAB stores data in 
					// column major format
					outPtr2[j * tree->nPntsInRange + i] = 
						(double) tree->points[tree->pntsInRange[i] * tree->ndim + j];
				}
      }
    }
		
    // Populate the output if there is only one
    // set of input ranges
    if(nRanges == 1) {
      plhs[0] = mxOut;
      if(nlhs > 1)
				plhs[1] = mxOut2;
    }
    // Populate the cell array if there are more than one
    // set of input ranges
    else {
      mxSetCell(plhs[0],n,mxOut);
      if(nlhs > 1)
				mxSetCell(plhs[1],n,mxOut2);
    }
		
  } // end of iterating over ranges
	
  // Free old memory
  if(tree)
    delete tree;

  delete[] ranges;
  delete[] rdata;

  // All done (whew!)
  return;
}
