
#include "mex.h"
#include <float.h>
#include <cmath>
#include <limits>
// // 



// // 

#define vInd(i,j) (*(pInd + kPoints*(j) + (i)))		// Matlab stores arrays columnwise
#define vDis(i,j) (*(pDis + kPoints*(j) + (i)))
#define vGDM(i,j) (*(pGDM + kPoints*(j) + (i)))

double getGDMentry(int* pInd,double* pDis, double* pGDM,int n, int k,int nPoints, int kPoints){
    
//             return vDis(k,n);      
    
            if( vInd(k,n)==0)
                return std::numeric_limits<double>::infinity();
            else
                return vDis(k,n);
            
                
//             
//             
// %             hori = find( ind(n,f) - ind(:,f  ) == 1); % Same column
//             hori = C_binSeek(ind(:,f)', ind(n,f)-1 ); 
//             if hori>0
// %             if ~isempty(hori)
// %                 if GDM(hori,f)==inf(1) && hori>n
// %                     GDM=getGDMentry(ind,dis,GDM,hori,f);
// %                 end
//                 horiDis=GDM(hori,f  );
//             else
//                 horiDis=inf(1);
//             end
//             
//             if f>1
// %                 diag = find( ind(n,f) - ind(:,f-1) == 1); % Prev column
//                 diag = C_binSeek(ind(:,f-1)',ind(n,f)-1);
//                 if diag>0
// %                 if ~isempty(diag)
// %                     if GDM(diag,f-1)==inf(1) && diag>n
// %                         GDM=getGDMentry(ind,dis,GDM,diag,f);
// %                     end
//                     diagDis=GDM(diag,f-1);
//                 else
//                     diagDis=inf(1);
//                 end
//                 
// %                 vert = find( ind(n,f) - ind(:,f-1) == 0);
//                 vert = C_binSeek(ind(:,f-1)',ind(n,f));
//                 if vert>0
// %                 if ~isempty(vert)
// %                     if GDM(vert,f)==inf(1) && vert > n
// %                         GDM=getGDMentry(ind,dis,GDM,vert,f);
// %                     end
//                     vertDis=GDM(vert,f  );
//                 else
//                     vertDis=inf(1);
//                 end
//             else
//                 diagDis = inf(1);
//                 vertDis = inf(1);
//             end
//             
//             dists=[diagDis horiDis vertDis];
//         
//             [a,pos] = min(dists);
//         
//             if a<inf
//             
//                 switch pos
//                     case 1
//                         % diagonal step
//                         GDM(n,f)=GDM(diag,f-1)+dis(n,f);
//                     case 2
//                         GDM(n,f)=GDM(hori,f  )+dis(n,f);
//                     case 3 
//                         GDM(n,f)=GDM(vert,f-1)+dis(n,f);
//                 end
//                 
//             else
//                 if f==1
//                     GDM(n,f)=dis(n,f);
//                 else
//                     GDM(n,f)=max(GDM(:,f-1));
// % %                     vals=GDM(:,f-1);
// % %                     vals=unique(vals);
// % %                     if size(vals,1)>1
// % %                         GDM(n,f)=vals(end-1);
// % %                     else
// % %                         GDM(n,f)=vals(end);
// % %                     end
//                 end
//             end
//             end
// end
//   
//     
    
}



/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    
  int   	*pInd;
  double    *pDis,
            *pGDMs,
            *pGDM;

  const mxArray *Ind;
  const mxArray *Dis;
 
  unsigned int nPoints,
               kPoints;

  /*  Check for proper number of arguments. */
  if (nrhs != 2) 
    mexErrMsgTxt("Two inputs required.");

  if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

  Ind   = prhs[0];
  Dis   = prhs[1];

  pInd =(int*)   mxGetPr(prhs[0]);
  pDis =(double*)mxGetPr(prhs[1]);

  /* Get the dimensions of the input array. */
  nPoints = mxGetN(Ind);
  kPoints = mxGetM(Ind);
  
  plhs[0] = mxCreateDoubleMatrix(kPoints, nPoints, mxREAL);
  
  pGDM  = (double*)mxGetPr(plhs[0]);
  pGDMs = (double*)mxGetPr(plhs[0]);
  
  for(int n=0;n<nPoints;n++){
  	for(int k=0;k<kPoints;k++){
        *pGDM = getGDMentry(pInd,pDis,pGDMs,n,k,nPoints,kPoints);
         pGDM++;
    }
  }

}
