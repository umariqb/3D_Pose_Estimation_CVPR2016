#include "mex.h"
#include "math.h"

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double	*pEuler,
            *pQuat;

  const mxArray *Quat;
 
  unsigned int nPoints;

  /*  Check for proper number of arguments. */
  if (nrhs != 1) 
    mexErrMsgTxt("One input required.");

  if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

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

  plhs[0] = mxCreateDoubleMatrix(3, nPoints, mxREAL);

  pQuat   = (double*)mxGetPr(Quat);
  pEuler  = (double*)mxGetPr(plhs[0]);

  double ex, ey, ez;
  double w, x, y, z;
  
  double sinsecond_angle,       cossecond_angle_sq,
         scthird_angle, ccthird_angle,
         scfirst_angle, ccfirst_angle,
         length;

  for(int i=1;i<nPoints+1;i++){
      
    w=*pQuat; pQuat++;  
    x=*pQuat; pQuat++;
    y=*pQuat; pQuat++;
	z=*pQuat; pQuat++;
    
    length=w*w+x*x+y*y+z*z;
    w=w/length;
    x=x/length;
    y=y/length;    
    z=z/length;
     
    sinsecond_angle = -(2*x*z - 2*w*y); // minus pos (3,1) in quat->matrix conversion
	cossecond_angle_sq = 1 - sinsecond_angle*sinsecond_angle;

//     mexPrintf("cos2angsq=%f\n",cossecond_angle_sq);
    
    if (cossecond_angle_sq>0.00000001){
            scthird_angle = 2*y*z + 2*w*x;       // pos (3,2) in quat->matrix conversion
            ccthird_angle = (1 - 2*x*x - 2*y*y); // pos (3,3) in quat->matrix conversion
            scfirst_angle = 2*x*y + 2*w*z;       // pos (2,1) in quat->matrix conversion
            ccfirst_angle = (1 - 2*y*y - 2*z*z); // pos (1,1) in quat->matrix conversion
    }
    else{
            scthird_angle = 2*x*y - 2*w*z;       // pos (1,2) in quat->matrix conversion
            ccthird_angle = (1 - 2*x*x - 2*z*z); // pos (2,2) in quat->matrix conversion
            scfirst_angle = 0;
            ccfirst_angle = 1;
    }
    
    ex = atan2(scfirst_angle,ccfirst_angle);
	ey = asin(sinsecond_angle);
	ez = atan2(scthird_angle,ccthird_angle);
    
//     ex = scfirst_angle;
// 	ey = asin(sinsecond_angle);
// 	ez = scthird_angle; 

	*pEuler = ex; pEuler++;
	*pEuler = ey; pEuler++;
	*pEuler = ez; pEuler++;
  }
//   mxSetData(plhs[0], Quat);
}
