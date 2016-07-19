#include "mex.h"
#include "math.h"

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double	*pQuat,
		*pQuatInv;

  const mxArray *Quat;

  unsigned int nPoints;

  /*  Check for proper number of arguments. */
  if (nrhs != 1) 
    mexErrMsgTxt("One inputs required.");

  if (nlhs != 1) 
    mexErrMsgTxt("One outputs required.");

  Quat   = prhs[0];

  if (mxIsEmpty(Quat))
  {
	plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
  }

  /* Check to make sure the input argument is a real double array. */
  if ((mxIsComplex(Quat) || !mxIsDouble(Quat)))
  {
    mexErrMsgTxt("Input must be a real double array.");
  }

  /* Get the dimensions of the input array. */
  nPoints = mxGetN(Quat);

  plhs[0] = mxCreateDoubleMatrix(4, nPoints, mxREAL);

  pQuat     = (double*)mxGetPr(Quat);
  pQuatInv  = (double*)mxGetPr(plhs[0]);

  double qr, qi, qj, qk;
  double ir, ii, ij, ik;
  double length=1;

  for(int i=1;i<nPoints+1;i++){
	qr=*pQuat; pQuat++;
	qi=*pQuat; pQuat++;
	qj=*pQuat; pQuat++;
	qk=*pQuat; pQuat++;

	length=qr*qr+qi*qi+qj*qj+qk*qk;

	ir= qr/length;
	ii=-qi/length;
	ij=-qj/length;
	ik=-qk/length;

	*pQuatInv = ir; pQuatInv++;
	*pQuatInv = ii; pQuatInv++;
	*pQuatInv = ij; pQuatInv++;
	*pQuatInv = ik; pQuatInv++;
  }
//   mxSetData(plhs[0], Quat);
}
