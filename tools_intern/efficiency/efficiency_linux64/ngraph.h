
#ifndef NGRAPH 
#define NGRAPH

#include "mex.h"
#include "math.h"
#include "stdio.h"

inline double getDistance(double* p1, double* p2, unsigned int dim)
{
	double distance=0.0;
	for (unsigned int i=0;i<dim;i++)
	{
		distance += fabs(p1[i]-p2[i]);
	}
	return distance;
};


class NGraph
{
    public:
    unsigned int dim;
    unsigned int nPoints;
    double* points;
    
    unsigned int nAdj;
    unsigned int* adjGraph;
	unsigned int* adjIndex;
    unsigned int* nAdjPoints;
    
    double maxDistance;
    
    NGraph()
    {
        nAdj=0;
        adjGraph = 0;
        adjIndex = 0;
        nAdjPoints = 0;
        dim = 0;
        nPoints = 0;
        points =0;
        maxDistance = 0;
    };
    NGraph(unsigned int d, unsigned int np, double* p, double md){
        nAdj=0;
        adjGraph = 0;
        adjIndex = 0;
        nAdjPoints = 0;
        dim = d;
        nPoints = np;
        points = p;
        maxDistance = md;
        createNGraph(maxDistance);
    };
    
    ~NGraph()
    {
        if (adjGraph != 0) delete [] adjGraph;
        if (adjIndex != 0) delete [] adjIndex;
        if (nAdjPoints != 0) delete [] nAdjPoints;
    };


    void createNGraph(double maxDistance){	 
        
    nAdjPoints = (unsigned int*)mxCalloc(nPoints, sizeof(unsigned int));
	for (int i=0;i<nPoints;i++) nAdjPoints[i]=0;

    double distance;
    unsigned int p=0;

    while (p < nPoints-1)
    {
        for (unsigned int i=p+1;i<nPoints;i++)
        {
            distance = getDistance(points + dim*p,points + dim*i,dim);
            if (distance < maxDistance) 
            {
                nAdjPoints[p]++;
                nAdjPoints[i]++;
            }
        }
        p++;
    }

    adjIndex = (unsigned int*)mxCalloc(nPoints, sizeof(unsigned int));
    nAdj = 0;
    
    for (unsigned int i=0;i<nPoints;i++) 
    {
        adjIndex[i]=nAdj;
        nAdj += nAdjPoints[i];
    }

	adjGraph = (unsigned int*)mxCalloc(nAdj, sizeof(unsigned int));
	p=0;
	while (p < nPoints-1)
	{
		for (unsigned int i=p+1;i<nPoints;i++)
		{
			distance = getDistance(points + dim*p,points + dim*i,dim);
            
			if (distance < maxDistance) 
			{
				adjGraph[adjIndex[p]]=i+1;
				adjGraph[adjIndex[i]]=p+1;
				adjIndex[p]++;
				adjIndex[i]++;
			}
		}
		p++;
	}
    
   for (int i=0;i<nPoints;i++)
   {
       adjIndex[i] -= nAdjPoints[i]; 
        adjIndex[i] += 1;

    }
    
 };
    
};

#endif

