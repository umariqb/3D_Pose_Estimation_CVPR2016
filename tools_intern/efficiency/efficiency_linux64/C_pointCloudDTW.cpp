#include "mex.h"
#include "math.h"

double pointCloudDist(double xP, double y1, double zP, double xQ, double y2, double zQ){
	double K = 1;
	
	double xPc=xP;
	double zPc=zP;
	double xQc=xQ;
	double zQc=zQ;

	double N = dot(xP/K,zQ) - dot(xQ/K,zP) - (xPc*zQc - zPc*xQc);
	double D = dot(xP/K,xQ) + dot(zQ/K,zP) - (xPc*xQc + zPc*zQc);
	
	double theta = atan2(N,D);
	
	double x0 = xPc - xQc*cos(theta) - zQc*sin(theta);
	double z0 = zPc + xQc*sin(theta) - zQc*cos(theta);



%Rotationsteil der Matrix
Rot_y = [ cos(theta) 0 sin(theta); ...
             0      1     0    ; ...
         -sin(theta) 0 cos(theta) ];

% Translationsteil der Matrix inklusive Rotationsteil
T(1,:) = [ Rot_y(1,:) x];
T(2,:) = [ Rot_y(2,:) 0 ];
T(3,:) = [ Rot_y(3,:) z ];
T(4,4) = 1;



// return sqrt( pow(x1-x2,2)+pow(y1-y2,2)+pow(z1-z2,2));
}

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double	*pS1,
		*pS2,
		*pSr;

  const mxArray *S1;
  const mxArray *S2;
	
  unsigned int 	nS1,
  		nS2,
		mS1,
		mS2;

  /*  Check for proper number of arguments. */
  if (nrhs != 2) 
    mexErrMsgTxt("Two inputs required.");

  if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

  S1 = prhs[0];
  S2 = prhs[1];

//   if (mxIsEmpty(Quat))
//   {
// 	plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
//   }

  /* Check to make sure the input argument is a real double array. */
  if ((mxIsComplex(S1) || !mxIsDouble(S1) || mxIsComplex(S2) || !mxIsDouble(S2)))
  {
    mexErrMsgTxt("Input must be a real double array.");
  }

  /* Get the dimensions of the input array. */
  nS1  = mxGetN(S1);
  nS2  = mxGetN(S2);

  mS1  = mxGetM(S1);
  mS2  = mxGetM(S2);

  if(mS1!=3 || mS2!=3)
	mexErrMsgTxt("Number of rows should be 3!");

  plhs[0] = mxCreateDoubleMatrix(nS1, nS2, mxREAL);

  pS1     = (double*)mxGetPr(S1);
  pS2     = (double*)mxGetPr(S2);
  pSr	  = (double*)mxGetPr(plhs[0]);

  double x1,y1,z1;
  double x2,y2,z2;

  for(int i=0;i<nS1;i++){
	
	x1=*pS1; pS1++;
	y1=*pS1; pS1++;
	z1=*pS1; pS1++;
	for(int j=0;j<nS2;j++){

		x2=*pS2; pS2++;
		y2=*pS2; pS2++;
		z2=*pS2; pS2++;

		*pSr=pointCloudDist(x1,y1,z1,x2,y2,z2);
		 pSr++;

	}
	pS2     = (double*)mxGetPr(S2);
   }

}
