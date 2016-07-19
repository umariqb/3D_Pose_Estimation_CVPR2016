#ifndef __KDTREE_H
#define __KDTREE_H

#include <ANN/ANN.h>

class KDTree : public ANNkd_tree
{
public:
	KDTree(double **points,unsigned int numPoints,unsigned int dimension);

	void searchNearestNeigbors(double* q,const int k, int* indices);
	void searchNearestNeigbors(double* q,const int k, int* indices, double* distances);
    
private:
	KDTree();
	KDTree(const KDTree& other);

};


KDTree::KDTree(double **points,unsigned int numPoints,unsigned int dimension)
:
	ANNkd_tree(points,(int)numPoints,(int)dimension)
{
	
	
}

void KDTree::searchNearestNeigbors(double* q,const int k, int* indices)
{
	double* dd = new double[k];
	annkSearch(q,(const int)k,indices,dd,1.0);
	delete[] dd;
}

void KDTree::searchNearestNeigbors(double* q,const int k, int* indices, double* distances)
{
	annkSearch(q,(const int)k,indices,distances,1.0);
}
	

#endif /* __KDTREE_H */
