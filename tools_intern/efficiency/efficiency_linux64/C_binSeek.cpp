#include "mex.h"
#include "math.h"

int binsuch( double *feld, size_t l, double zusuchen )
{
/*    mexPrintf("\n");
  for(int b=0;b<l;b++)  
      mexPrintf(" %f",feld[b]);
    */
  if( l<1 )
  {
    // leeres Feld? Nichts gefunden!
    return NULL;
  }
  else if( l==1 )
  {
    // nur ein Element; vergleichen und ggf. zurückgeben:
    //  mexPrintf(" =%i ",feld[0]==zusuchen ? &feld[0] : NULL);
    return ( feld[0]==zusuchen ? 0 : -10000000 );
  }
  else
  {
    // Mehr als ein Element
    // Mitte suchen, und ggf. links oder rechts suchen:
    int index_Mitte = l/2;
    if( feld[index_Mitte]==zusuchen )
    {
      // Zufällig getroffen!
      return index_Mitte;
    }
    else if( feld[index_Mitte]>zusuchen )
    {
      //   mexPrintf(" >%i ",index_Mitte);
      // Mitte ist zu groß, also links weitersuchen
      return binsuch( feld, index_Mitte, zusuchen );
    }
    else
    {
      // Mitte zu klein, also in rechter Hälfte suchen:
      //  mexPrintf(" <%i ",index_Mitte);
      return binsuch( &feld[index_Mitte+1], l - index_Mitte - 1, zusuchen )+index_Mitte+1;
    }
  }

} // int *binsuch( int feld[], size_t l, int zusuchen )


/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double	*pVec,
            *pVal;
  

  const mxArray *Vec;
  const mxArray *Val;
 
  unsigned int nPoints;

  /*  Check for proper number of arguments. */
  if (nrhs != 2) 
    mexErrMsgTxt("Two inputs required.");

  if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

  Vec   = prhs[0];
  Val   = prhs[1];

  pVec = (double*)mxGetPr(prhs[0]);
  /* Check to make sure the input argument is a real double array. */
//   if ((mxIsComplex(Vec) || !mxIsDouble(Vec)))
//   {
//     mexErrMsgTxt("Input must be a real double array.");
//   }

  /* Get the dimensions of the input array. */
  nPoints = mxGetN(Vec);
  
  plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
  
  double* pRes = (double*)mxGetPr(plhs[0]);
  pVal = (double*)mxGetPr(Val);
  double*   a1;
  a1=(double*)pVec;
  const size_t a1l = nPoints; // Feldlänge

  int result = binsuch( a1, a1l, *pVal )+1;
  //mexPrintf("\nres=%i",result);

  *pRes =(double) result;
}
