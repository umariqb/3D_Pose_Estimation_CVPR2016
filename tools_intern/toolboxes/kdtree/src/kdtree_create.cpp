 
#include <mex.h>
#include <kdtree.h>
#include <string.h>

static const char *fieldNames[] = {"tree"};

// This makes a kdtree class out of an input 
// structure
static void make_class(mxArray **out, const mxArray *in)
{
  const mxArray *prhs[2];  
  prhs[0] = in;
  prhs[1] = mxCreateString("kdtree");
  mexCallMATLAB(1,out,2,(mxArray **)prhs,"class");   
  return;
} // end of make_class

void mexFunction(int nlhs, mxArray * plhs[],
		 int nrhs, const mxArray * prhs[])
{
  // Type checking on the input
  if (nrhs < 1) {
    // We do this so that MATLAB Can determine the class type
    // when loading a tree from a file without a previous
    // tree to check against.  The class call with no arguments 
    // must return a version of the object so that MATLAB 
    // can load the structure's fields.
    plhs[0] = mxCreateStructMatrix(1,1,1,fieldNames);    
    make_class(plhs,plhs[0]);
    return;
  }

  if (!mxIsNumeric(prhs[0])) {
    if(mxIsStruct(prhs[0])) {
      mxArray *mxTree = mxGetField(prhs[0],0,"tree");
      if(mxTree == 0) {
        mexPrintf("Invalid structure\n");
        return;
      }
      if(mxGetClassID(mxTree) != mxUINT8_CLASS) {
        mexPrintf("Invalid structure\n");
        return;
      }
      make_class(plhs,prhs[0]); 
      return;
    }
    else {
      mexPrintf("Must input a numeric Array.\n");
      return;
    }
  }
  if (mxGetNumberOfDimensions(prhs[0]) != 2) {
    mexPrintf("Input array must be of size (npoints X ndim).\n");
    return;
  }
  // Extract info from the input array    
  int npoints = (int) mxGetM(prhs[0]);
  int ndim = (int) mxGetN(prhs[0]);

  // First, taking the transpose
  mxArray *prhst;
  mexCallMATLAB(1, &prhst, 1, (mxArray **) prhs, "transpose");

  // Convert to single precision if input is not
  // already
  if (!mxIsSingle(prhs[0])) {
    mxArray *ptmp;
    mexCallMATLAB(1, &ptmp, 1, &prhst, "single");
    mxDestroyArray(prhst);
    prhst = ptmp;
  }
  
  // Create the tree
  KDTree *tree = new KDTree;
	mxArray *tmp = mxCreateNumericMatrix(tree->get_serialize_length(npoints,ndim),
																			 1,mxUINT8_CLASS,mxREAL);
	// Create the tree
	tree->create((float *)mxGetPr(prhst),npoints,ndim,mxGetPr(tmp));
	mxDestroyArray(prhst);
 
  // Copy the serialized tree data to a new class
  plhs[0] = mxCreateStructMatrix(1,1,1,fieldNames);
  mxSetFieldByNumber(plhs[0],0,0,tmp);
 
  // Make the structure variable a class 
  make_class(&plhs[0],plhs[0]);
 
	// Delete our current incarnation of the tree
	// (all the relevant data is stored in our serialized tpr variable)
  delete tree;
  
  return;
}				// end of mexFunction
