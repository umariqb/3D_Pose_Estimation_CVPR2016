#include "mex.h"
#include "math.h"

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double	*pEuler,
		*pQuat;

  const mxArray *Euler;
 
  unsigned int nPoints;

  /*  Check for proper number of arguments. */
  if (nrhs != 1) 
    mexErrMsgTxt("One input required.");

  if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

  Euler   = prhs[0];

  if (mxIsEmpty(Euler))
  {
	plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
  }

  /* Check to make sure the input argument is a real double array. */
  if ((mxIsComplex(Euler) || !mxIsDouble(Euler)))
  {
    mexErrMsgTxt("Input must be a real double array.");
  }

  /* Get the dimensions of the input array. */
  nPoints = mxGetN(Euler);

  plhs[0] = mxCreateDoubleMatrix(4, nPoints, mxREAL);

  pEuler = (double*)mxGetPr(Euler);
  pQuat  = (double*)mxGetPr(plhs[0]);

  double ex, ey, ez;
  double qr, qi, qj, qk;

  for(int i=1;i<nPoints+1;i++){
	ex=*pEuler; pEuler++;
	ey=*pEuler; pEuler++;
	ez=*pEuler; pEuler++;

	double sx = sin(ex * 0.5f);
	double cx = cos(ex * 0.5f);

	double sy = sin(ey  * 0.5f);
	double cy = cos(ey  * 0.5f);
	
	double sz = sin(ez * 0.5f);
	double cz = cos(ez * 0.5f);
	//'zxy'
// 	qr = (cx * cy * cz) - (sx * sy * sz);
// 	qi = (cx * sy * cz) - (sx * cy * sz);
// 	qj = (cx * cy * sz) + (sx * sy * cz);
// 	qk = (cx * sy * sz) + (sx * cy * cz);

	//'zyx'
	qr =  (cx * cy * cz) + (sx * sy * sz);
	qi =  (cx * cy * sz) - (sx * sy * cz);
	qj =  (cx * sy * cz) + (sx * cy * sz);
	qk =  (sx * cy * cz) - (cx * sy * sz);

	*pQuat = qr; pQuat++;
	*pQuat = qi; pQuat++;
	*pQuat = qj; pQuat++;
	*pQuat = qk; pQuat++;
  }
//   mxSetData(plhs[0], Quat);
}
