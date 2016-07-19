/*

Fast K-means clustering algorithm (mex-interface modified from the original yael package https://gforge.inria.fr/projects/yael)


Usage
------

[centroids, dis, assign] = yael_kmeans(X , options);


Inputs
-------

X                              Input data matrix (d x N) in single format 

options 
       K                       Number of centroid  (default K = 1)
	   nt                      Number of threads   (default nt = 1)
	   niter                   Number of iteration (default nite = 50)
       scale                   Multi-Scale vector (1 x nscale) (default scale = 1) where scale(i) = s is the size's factor to apply to each 9 blocks
       redo                    Restart K-means (default redo = 1)
	   verbose                 Verbose level = {0,1,2,3} (default verbose = 0)


Outputs
-------


centroids                      Centroids matrix (d x K) in single format 
dis                            Distance of each xi to the closest centroid, i = 1,...,N in single format
assign                         Index of closest centroid to xi, i = 1,...,N in UINT32 format


Example 1
---------

clear

d             = 128;                   % dimensionality of the vectors
N             = 100000;                % number of vectors

X             = randn(d, N , 'single'); % random set of vectors 

options.K     = 100;
options.nt    = 2;
options.niter = 30;

tic,[centroids, dis, assign] = yael_kmeans(X , options);,toc



To compile
----------

1) For Linux system

mex  yael_kmeans.c kmeans.c binheap.c machinedeps.c nn.c sorting.c vector.c vlad.c -lmwblas

or with GOTOblas

mex  yael_kmeans.c kmeans.c binheap.c machinedeps.c nn.c sorting.c vector.c vlad.c -lgoto2


If you meet some compilation problem, please download the last yeal package at https://gforge.inria.fr/projects/yael and replace yeal_means.c by this one.

2) For windows system. 

A little bit more complicated since yeal use pthreads.h which is not directly available for windows. 
3 basics steps : 

   a) Download the last release of pthread32 : ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-2-8-0-release.tar.gz
   b) Untar the archive
   c) Open your msvc command line (tested with msvc 2005, 2008, 2010)


    - If you want pthreads compiled dynamically (tested with win32 & win64), type: "nmake clean VC". 
	
	Then compile the mex-files as:

    mex  yael_kmeans.c kmeans.c binheap.c machinedeps.c nn.c sorting.c vector.c vlad.c pthreadVC2.lib "C:\Program Files\MATLAB\R2009b\extern\lib\win32\microsoft\libmwblas.lib"

	In this case, yael_kmeans.mexw32 will requiered pthreadVC2.dll in the path


    - If you want pthreads compiled statically (tested with win32, problem with win64 if nt>1), 
	     * for win32 system, type directly: nmake clean VC-static. 
		 * for win64 system, edit "Makefile", search lines beginning by:

		 $(STATIC_STAMPS): $(DLL_INLINED_OBJS)
		 if exist $*.lib del $*.lib
         lib $(DLL_INLINED_OBJS) /out:$*.lib

		 and replace by

         $(STATIC_STAMPS): $(DLL_INLINED_OBJS)
         if exist $*.lib del $*.lib
         lib $(DLL_INLINED_OBJS) /machine:x64 /out:$*.lib

     Then compile the mex-files as:

	 mex  -DPTW32_STATIC_LIB OPTIMFLAGS="$OPTIMFLAGS /MD" yael_kmeans.c kmeans.c binheap.c machinedeps.c nn.c sorting.c vector.c vlad.c pthreadVC2.lib "C:\Program Files\MATLAB\R2009b\extern\lib\win32\microsoft\libmwblas.lib"

    IMPORTANT, for static case, be sure to compile the mex-file with the /MD flag in your mexopts.bat file



Reference  [1] Hervé Jégou, Matthijs Douze and Cordelia Schmid, Product quantization for nearest neighbor search,
---------      IEEE Transactions on Pattern Analysis and Machine Intelligence




Author : Sébastien PARIS : sebastien.paris@lsis.org
-------  Date : 09/06/2010




mex  -g -output yael_kmeans.dll yael_kmeans.c kmeans.c binheap.c machinedeps.c nn.c sorting.c vector.c vlad.c pthreadVC2.lib "C:\Program Files\MATLAB\R2009b\extern\lib\win32\microsoft\libmwblas.lib"

mex  -f mexopts_intel10.bat -output yael_kmeans.dll yael_kmeans.c kmeans.c binheap.c machinedeps.c nn.c sorting.c vector.c vlad.c pthreadVC2.lib "C:\Program Files\MATLAB\R2009b\extern\lib\win32\microsoft\libmwblas.lib"

mex  -DPTW32_STATIC_LIB OPTIMFLAGS="$OPTIMFLAGS /MD"  -f mexopts_intel10.bat -output yael_kmeans.dll yael_kmeans.c kmeans.c binheap.c machinedeps.c nn.c sorting.c vector.c vlad.c pthreadVC2_x32.lib "C:\Program Files\MATLAB\R2009b\extern\lib\win32\microsoft\libmwblas.lib"

mex  -DPTW32_STATIC_LIB OPTIMFLAGS="$OPTIMFLAGS /MD"  -f mexopts_intel10.bat -output yael_kmeans.dll yael_kmeans.c kmeans.c binheap.c machinedeps.c nn.c sorting.c vector.c vlad.c pthreadVC2_x32.lib "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_core.lib" "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_intel_c.lib" "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_intel_thread.lib" "C:\Program Files\Intel\Compiler\11.1\065\lib\ia32\libiomp5md.lib" 

*/

#include <stdio.h>
#include <string.h>


#include <assert.h>
#include <math.h>
#include <time.h>

#include "kmeans.h"
#include "mex.h"


struct opts
{
	int    K;
	int    niter;
	int    nt;
	int    redo;
	int    verbose;
};

/* 
compile with yael4matlab.sh
*/

/* ------------------------------------------------------------------------------------------------------------------------------------ */

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
	int d,N,i;
	float *v , *centroids , *dis;
	int *assign;

	struct opts options = {10 , 50 , 1 , 1 , 0};
	mxArray *mxtemp;
	double *tmp;
	int tempint;

	if (nrhs < 2 || nrhs % 2 != 0) 
		mexErrMsgTxt("even nb of input arguments required.");

	d = mxGetM(prhs[0]);
	N = mxGetN(prhs[0]);

	if(mxGetClassID(prhs[0])!=mxSINGLE_CLASS)
	{
		mexErrMsgTxt("need single precision array.");
	}

	v = (float*) mxGetPr (prhs[0]);


	if ((nrhs > 1) && !mxIsEmpty(prhs[1]) )
	{
		mxtemp                            = mxGetField(prhs[1] , 0 , "K");
		if(mxtemp != NULL)
		{
			tmp                           = mxGetPr(mxtemp);
			tempint                       = (int) tmp[0];

			if( (tempint < 0))
			{
				mexPrintf("K must be > 0, force to 10\n");	
				options.K                 = 0;
			}
			else
			{
				options.K                 = tempint;
			}
		}

		mxtemp                            = mxGetField(prhs[1] , 0 , "niter");
		if(mxtemp != NULL)
		{
			tmp                           = mxGetPr(mxtemp);
			tempint                       = (int) tmp[0];
			if( (tempint < 0))
			{
				mexPrintf("niter must be > 0, force to 50\n");	
				options.niter             = 50;
			}
			else
			{
				options.niter             = tempint;
			}
		}

		mxtemp                            = mxGetField(prhs[1] , 0 , "nt");
		if(mxtemp != NULL)
		{
			tmp                           = mxGetPr(mxtemp);
			tempint                       = (int) tmp[0];

			if( (tempint < 0))
			{
				mexPrintf("nt must be > 0, force to 1\n");	
				options.nt                = 1;
			}
			else
			{
				options.nt                = tempint;
			}
		}

		mxtemp                            = mxGetField(prhs[1] , 0 , "redo");
		if(mxtemp != NULL)
		{
			tmp                           = mxGetPr(mxtemp);
			tempint                       = (int) tmp[0];

			if( (tempint < 0) || (tempint > 1))
			{
				mexPrintf("redo must be ={0,1}, force to 1\n");	
				options.redo              = 1;
			}
			else
			{
				options.redo              = tempint;
			}
		}

		mxtemp                            = mxGetField(prhs[1] , 0 , "verbose");
		if(mxtemp != NULL)
		{
			tmp                           = mxGetPr(mxtemp);
			tempint                       = (int) tmp[0];

			if( (tempint < 0) || (tempint > 3))
			{
				mexPrintf("verbose must be ={0,1,2,3}, force to 0\n");	
				options.verbose              = 0;
			}
			else
			{
				options.verbose              = tempint;
			}
		}
	}

	/*  printf("input array of %d*%d k=%d niter=%d nt=%d ar=[%g %g ... ; %g %g... ]\n", N, d, options.K, options.niter, options.nt, v[0], v[d], v[1], v[d+1]);  */

	if(N < options.K) 
	{
		mexErrMsgTxt("fewer points than centroids");    
	}

	/* ouptut: centroids, assignment, distances */

	plhs[0]   = mxCreateNumericMatrix (d , options.K, mxSINGLE_CLASS, mxREAL);  
	centroids = (float*)mxGetPr(plhs[0]);

	plhs[1]   = mxCreateNumericMatrix (1, N , mxSINGLE_CLASS, mxREAL);
	dis       = (float*) mxGetPr (plhs[1]);

	plhs[2]   = mxCreateNumericMatrix (1, N , mxINT32_CLASS, mxREAL);
	assign    = (int*) mxGetPr (plhs[2]);

	kmeans(d , N , options.K, options.niter, v, options.nt, 0, options.redo, options.verbose , centroids, dis, assign, NULL);

	for (i = 0 ; i < N ; i++)
	{
		assign[i]++;
	}

}
