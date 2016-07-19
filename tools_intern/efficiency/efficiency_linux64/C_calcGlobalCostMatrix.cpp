







void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    
    double    *pDis;

    int   	  *pInd,
              *pDBSize;

    unsigned int iNeigh,
               iFrames;

    /*  Check for proper number of arguments. */
    if (nrhs != 3) 
    mexErrMsgTxt("Three inputs required.");

    if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

    /* Get Pointers to input arguments */
    pInd     = (int*)    mxGetPr(prhs[0]);
    pDis     = (double*) mxGetPr(prhs[1]);
    pDBSize  = (int*)    mxGetPr(prhs[2]);

    /* Get the dimensions of the input array. */
    iNeigh   = mxGetM(prhs[0]);
    iFrames  = mxGetN(prhs[0]);

    /* Create output cell array */
    mwSize pDims[2];
    pDims[0] = (mwSize)1;
    pDims[1] = (mwSize)iNeigh*10; // max Number of possible paths

    plhs[0]  = mxCreateCellArray(2, (const mwSize*)pDims);

    /* Call Path finding algorithm */
    getPaths((mxArray*)prhs[0], (mxArray*)prhs[1], plhs[0], iNeigh, iFrames, *pDBSize);

}