#include "mex.h"
#include "math.h"

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double	*pQ1,
            *pQ2,
            *pQr;

  const mxArray *Q1;
  const mxArray *Q2;
	
  unsigned int 	nQ1,
                nQ2,
                mQ1,
                mQ2,
                maxD;

  /*  Check for proper number of arguments. */
  if (nrhs != 2) 
    mexErrMsgTxt("Two inputs required.");

  if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

  Q1 = prhs[0];
  Q2 = prhs[1];

//   if (mxIsEmpty(Quat))
//   {
// 	plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
//   }

  /* Check to make sure the input argument is a real double array. */
  if ((mxIsComplex(Q1) || !mxIsDouble(Q1) || mxIsComplex(Q2) || !mxIsDouble(Q2)))
  {
    mexErrMsgTxt("Input must be a real double array.");
  }

  /* Get the dimensions of the input array. */
  nQ1  = mxGetN(Q1);
  nQ2  = mxGetN(Q2);
  mQ1  = mxGetM(Q1);
  mQ2  = mxGetM(Q2);

  if(nQ1!=nQ2 )
  {
     if(nQ1!=1 && nQ2!=1)
     {
     	mexErrMsgTxt("Input Dimension missmatch");
     }
  }
  
  if(nQ1==0)
      mexErrMsgTxt("Q1 is empty!");
  
  if(nQ2==0)
      mexErrMsgTxt("Q2 is empty!");
  
  if(mQ1!=4)
      mexErrMsgTxt("Q1 has not 4 Dimensions!");
  
  if(mQ2!=4)
      mexErrMsgTxt("Q2 has not 4 Dimensions!");

  if(nQ1>nQ2) maxD=nQ1;
  else maxD=nQ2;

  plhs[0] = mxCreateDoubleMatrix(4, maxD, mxREAL);

  pQ1     = (double*)mxGetPr(Q1);
  pQ2     = (double*)mxGetPr(Q2);
  pQr	  = (double*)mxGetPr(plhs[0]);

  double q1r, q1i, q1j, q1k;
  double q2r, q2i, q2j, q2k;
  double qrr, qri, qrj, qrk;

  for(int i=1;i<maxD+1;i++){

	if( (i>1 && nQ1>1) || i==1){
		q1r=*pQ1; pQ1++;
		q1i=*pQ1; pQ1++;
		q1j=*pQ1; pQ1++;
		q1k=*pQ1; pQ1++;
	}

	if( (i>1 && nQ2>1) || i==1){
		q2r=*pQ2; pQ2++;
		q2i=*pQ2; pQ2++;
		q2j=*pQ2; pQ2++;
		q2k=*pQ2; pQ2++;
	}

	qrr = q1r*q2r - q1i*q2i - q1j*q2j - q1k*q2k;
	qri = q1r*q2i + q1i*q2r + q1j*q2k - q1k*q2j;
	qrj = q1r*q2j - q1i*q2k + q1j*q2r + q1k*q2i;
	qrk = q1r*q2k + q1i*q2j - q1j*q2i + q1k*q2r;

	*pQr = qrr; pQr++;
	*pQr = qri; pQr++;
	*pQr = qrj; pQr++;
	*pQr = qrk; pQr++;
  }

}
