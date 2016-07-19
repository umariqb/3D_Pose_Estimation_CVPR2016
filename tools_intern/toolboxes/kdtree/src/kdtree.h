#ifndef _KDTREE_H_
#define _KDTREE_H_

#pragma pack(1)
struct _Node {
  float key;
  int pntidx;
	int leftIdx;
	int rightIdx;
};
#pragma pack()


typedef float *Range;
typedef int IRange[2];

class KDTree {
public:
  KDTree(float *setpoints, int N, int setndim);
  KDTree();

   virtual ~ KDTree();

  int create(float *setpoints, int setnpoints, int setndim,
						 bool setCopy = false, 
						 struct _Node *setNodeMem = (struct _Node *)0);
	int create(float *setpoints,int setnpoints,int setndim,
						 void *mem);


  int ndim;
  int npoints;
  float *points;

  // Search for the nearest neighbor to pnt and 
  // return its index
  int closest_point(float *pnt, int &idx, bool approx=false);

	int get_points_in_range(Range *range);
	int nPntsInRange;
	int *pntsInRange;
	

  // Return distance squared between points
  // between points
  inline float distsq(float *pnt1, float *pnt2);

	// The following functions allow all the information in the class
  // to be serialized and unserialized.  This is convenient, for example,
  // for writing the tree to a disk or to a MATLAB variable
	static int get_serialize_length(int npoints,int ndim);
						 
						 
  static KDTree *unserialize(void *mem);
	
	int set_verbosity(int v){verbosity=v;return 0;}
	
protected:

  // Do we copy the points or not
  // if we do, this is where they go
   bool copyPoints;

  int check_border_distance(int nodeIdx, int dim,
			    float *pnt, float &dist, int &idx);

	int range_search(int nodeIdx, Range *range, int dim);
  int heapsort(int dim, int *idx, int len);

  int build_kdtree(int **sortidx, int dim, int *pidx, int len);
  
  int *workArr;
	struct _Node *nodeMem;
	int nodeMemCnt;
	bool nodeMemAlloc;
	struct _Node *node_alloc();

	int *intArrMem;
	int  intArrMemCnt;
	int *int_alloc(int len);
  
	static int (*logmsg)(const char *,...);
	int verbosity;
  
};

#endif
