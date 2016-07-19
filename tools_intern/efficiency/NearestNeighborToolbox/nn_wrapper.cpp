#include "mex.h"

#include<vector>

#include "DynMatrix.h" 
#include "Sample.h"
#include "SampleSet.h"
#include "Trajectory.h"
#include "TrajectorySet.h"

typedef DynMatrix<double>                    _AttributeType;
typedef Sample<double,_AttributeType>        _SampleType;
typedef SampleSet<double,_AttributeType>     _SampleSetType;
typedef Trajectory<double,_AttributeType>    _TrajectoryType;
typedef TrajectorySet<double,_AttributeType> _TrajectorySetType;

std::vector<Persistent*> m_persistent_objects;

/**
 *
 */
Persistent* getObject(unsigned int index)
{
	if (index > 0 && index <= m_persistent_objects.size() && m_persistent_objects[index-1])
	{
		return m_persistent_objects[index-1];
	}

	mexErrMsgTxt("There is no object with the given address!");

	return 0;
}
/**
 *
 */
unsigned int addObject(Persistent* obj)
{
	for (unsigned int i = 0; i < m_persistent_objects.size(); i++)
	{
		if (m_persistent_objects[i] == 0)
		{
			m_persistent_objects[i] = obj;
			return i+1;
		}
	}

	m_persistent_objects.push_back(obj);
	return m_persistent_objects.size();
}
/**
 *
 */
void deleteObject(const unsigned int index)
{
	if (index > 0 && index <= m_persistent_objects.size() && m_persistent_objects[index-1])
	{
		delete m_persistent_objects[index-1];
		m_persistent_objects[index-1] = 0;
	}
}
/**
 *
 */
unsigned int createNew(const char* type,int nrhs, const mxArray *prhs[])
{
	if (strcmp("Sample",type) == 0)
	{
		//Sample();
		//Sample(const Sample& other);
		//Sample(unsigned int valueDim);
		//Sample(double timeStamp,unsigned int valueDim,const ValueType* values,const AttributeType& attributes);
		if (nrhs == 0)
		{
			m_persistent_objects.push_back(new _SampleType());
			return m_persistent_objects.size();
		}
		else if(nrhs == 1)
		{
			if (!mxIsClass(prhs[0],"uint32"))
				mexErrMsgTxt("Constructor Sample(uint32(1x1) dimension) argument type mismatch!");

			unsigned int dimension = *reinterpret_cast<unsigned int*>(mxGetPr(prhs[0]));
			return addObject(new _SampleType(dimension));
		}
		else if(nrhs == 3)
		{
			if (!mxIsClass(prhs[0],"double") || 
				!mxIsClass(prhs[1],"double") || mxGetN(prhs[1]) != 1 || 
				!mxIsClass(prhs[2],"double") || mxGetN(prhs[2]) != 1)
				mexErrMsgTxt("Constructor Sample(double(1x1) timeStamp, double(Mx1) values, double(Px1) attributes) argument type mismatch!");

			unsigned int m = mxGetM(prhs[1]);
			unsigned int p = mxGetM(prhs[2]);
			double* values = mxGetPr(prhs[1]);
			double ts = *mxGetPr(prhs[0]);

			return addObject(new _SampleType(ts,m,0,values,_AttributeType(p,1,mxGetPr(prhs[2]))));
		}
		else
		{
			mexErrMsgTxt("No constructor with matching aruments found!");
		}
	}
	if (strcmp("SampleSet",type) == 0)
	{
		//SampleSet();
		if (nrhs == 0)
		{
			return addObject(new _SampleSetType());
		}
		else if(nrhs == 1)
		{
			if (!mxIsClass(prhs[0],"uint32") || mxGetN(prhs[0]) != 1 || mxGetM(prhs[0]) != 1)
				mexErrMsgTxt("Constructor Sample(uint32(1x1) pointer) argument type mismatch!");

			unsigned int ptr = *reinterpret_cast<unsigned int*>(mxGetPr(prhs[0]));

			Persistent* obj = getObject(ptr);

			//SampleSet(const _SampleType& sample);
			if (obj->getClassType() == ct_Sample)
			{
				_SampleType* sample = dynamic_cast<_SampleType*>(obj);
				if (sample)
				{
					return addObject(new _SampleSetType(*sample));
				}
			}
			//SampleSet(const SampleSet& other);
			else if (obj->getClassType() == ct_SampleSet)
			{
				_SampleSetType* sample_set = dynamic_cast<_SampleSetType*>(obj);
				if (sample_set)
				{
					return addObject(new _SampleSetType(*sample_set));
				}
			}

		}
		//	SampleSet(const unsigned int numSamples,
		//            const unsigned int valueDim,
		//            double* timeStamps,
		//            ValueType* values,
		//            AttributeType* attributes);
		else if(nrhs == 5)
		{
			if (!mxIsClass(prhs[2],"double") || 
				!mxIsClass(prhs[3],"double") || 
				!mxIsClass(prhs[4],"double"))
				mexErrMsgTxt("Constructor Sample(double(1xN) timeStamps, double(MxN) values, double(PxN) attributes) argument type mismatch!");

			if ( mxGetN(prhs[2]) != mxGetN(prhs[3]) ||
				 mxGetN(prhs[3]) != mxGetN(prhs[4]))
				mexErrMsgTxt("Constructor Sample(double(1xN) timeStamps, double(MxN) values, double(PxN) attributes) argument dimension mismatch!");

			unsigned int n = mxGetN(prhs[2]);
			unsigned int m = mxGetM(prhs[3]);
			unsigned int p = mxGetM(prhs[4]);

			double* timeStamps = mxGetPr(prhs[2]);
			double* values = mxGetPr(prhs[3]);
			double* attribute_values = mxGetPr(prhs[4]);
			_AttributeType* attributes = new _AttributeType[n];

			for (unsigned int i = 0; i < n; i++)
			{
				attributes[i] = _AttributeType(p,1,attribute_values+i*p);
			}

			Persistent* obj = new _SampleSetType(n,m,timeStamps,values,attributes);

			delete[] attributes;
			unsigned int ID=addObject(obj);
			dynamic_cast<_SampleSetType*>(obj)->setSampleSetID(ID);

			return ID;
		}
		
		
		//SampleSet(const _SampleType* samples,const unsigned int numSamples);

	}
	else if (strcmp("Trajectory",type) == 0)
	{
		
	/***** Copy Paste from add SampleSet  *****************************************************************/	
	
		if (nrhs == 0)
		{
			return addObject(new _TrajectoryType());
		}
		else if(nrhs == 1)
		{
			if (!mxIsClass(prhs[0],"uint32") || mxGetN(prhs[0]) != 1 || mxGetM(prhs[0]) != 1)
				mexErrMsgTxt("Constructor Sample(uint32(1x1) pointer) argument type mismatch!");

			unsigned int ptr = *reinterpret_cast<unsigned int*>(mxGetPr(prhs[0]));

			Persistent* obj = getObject(ptr);

			//SampleSet(const _SampleType& sample);
			if (obj->getClassType() == ct_Sample)
			{
				_SampleType* sample = dynamic_cast<_SampleType*>(obj);
				if (sample)
				{
					return addObject(new _TrajectoryType(*sample));
				}
			}

			else if (obj->getClassType() == ct_Trajectory)
			{
				_TrajectoryType* trajectory = dynamic_cast<_TrajectoryType*>(obj);
				if (trajectory)
				{
					return addObject(new _TrajectoryType(*trajectory));
				}
			}

		}

		else if(nrhs == 5)
		{
			if (!mxIsClass(prhs[2],"double") || 
				!mxIsClass(prhs[3],"double") || 
				!mxIsClass(prhs[4],"double"))
				mexErrMsgTxt("Constructor Sample(double(1xN) timeStamps, double(MxN) values, double(PxN) attributes) argument type mismatch!");

			if ( mxGetN(prhs[2]) != mxGetN(prhs[3]) ||
				 mxGetN(prhs[3]) != mxGetN(prhs[4]))
				mexErrMsgTxt("Constructor Sample(double(1xN) timeStamps, double(MxN) values, double(PxN) attributes) argument dimension mismatch!");

			unsigned int n = mxGetN(prhs[2]);
			unsigned int m = mxGetM(prhs[3]);
			unsigned int p = mxGetM(prhs[4]);

			double* timeStamps = mxGetPr(prhs[2]);
			double* values = mxGetPr(prhs[3]);
			double* attribute_values = mxGetPr(prhs[4]);
			_AttributeType* attributes = new _AttributeType[n];

			for (unsigned int i = 0; i < n; i++)
			{
				attributes[i] = _AttributeType(p,1,attribute_values+i*p);
			}

			Persistent* obj = new _TrajectoryType(n,m,timeStamps,values,attributes);

			delete[] attributes;
			return addObject(obj);
		}

		//SampleSet(const _SampleType* samples,const unsigned int numSamples);

	/**********************************************************************************************************/		

		//m_persistent_objects.push_back(new _TrajectoryType());

	} 
	else if (strcmp("TrajectorySet",type) == 0)
	{
		
		if (nrhs == 0)
		{
			return addObject(new _TrajectorySetType);
		}
		else{
			// Empty Trajectory Set
			_TrajectorySetType newTrajSet;
			
			// Now i expect numbers from repo ( m_persistant_objects) indicating trajectories.
			for(int curObj=0;curObj<nrhs;curObj++){
				// is argument curObj a uint32? Skip otherwise
				if(mxIsClass(prhs[curObj],"uint32")){
					// is CurObj of type trajectory? Skip otherwise
					if(m_persistent_objects[curObj]->getClassType() == ct_Trajectory){
#if defined(_DEBUG) | defined(_VERBOSE)
						mexPrintf("add Trajectory %i\n",curObj);
#endif
						newTrajSet = newTrajSet + dynamic_cast<_TrajectoryType*>(m_persistent_objects[curObj]);
					}
					// is CurObj another Set? Skip otherwise
					if(m_persistent_objects[curObj]->getClassType() == ct_TrajectorySet){
#if defined(_DEBUG) | defined(_VERBOSE)
						mexPrintf("add TrajectorySet %i\n",curObj);
#endif
						newTrajSet = newTrajSet + dynamic_cast<_TrajectorySetType*>(m_persistent_objects[curObj]);
					}
					
				} 
			}
			
			return addObject(&newTrajSet);
		}
		//m_persistent_objects.push_back(new _TrajectorySetType());
	}
	else
	{
		mexErrMsgTxt("The type was not recognized!");
	}
	return 0;
}
/**
 *
 */
void getValues(Persistent* object, mxArray *plhs[])
{
	if (object->getClassType() == ct_Sample)
	{
		_SampleType* sample = dynamic_cast<_SampleType*>(object);

		unsigned int m = sample->getValueDim();
		plhs[0] = mxCreateDoubleMatrix(m,1,mxREAL);
		sample->getValues(mxGetPr(plhs[0]));

		return;
	}
	else if (object->getClassType() == ct_SampleSet)
	{
		_SampleSetType* sample_set = dynamic_cast<_SampleSetType*>(object);

		unsigned int m = sample_set->getValueDim();
		unsigned int n = sample_set->getNumSamples();
		plhs[0] = mxCreateDoubleMatrix(m,n,mxREAL);
		sample_set->getValues(mxGetPr(plhs[0]));
		return;
	}
	else
	{
		mexErrMsgTxt("Method getValues not implemented for this type!");
	}
}
/**
 *
 */
void setValues(Persistent* object,int nrhs, const mxArray *prhs[])
{
	if (nrhs < 1)
		mexErrMsgTxt("No value matrix is provided!");

	if (object->getClassType() == ct_Sample)
	{
		_SampleType* sample = dynamic_cast<_SampleType*>(object);

		if (!mxIsDouble(prhs[0]) || mxGetN(prhs[0]) != 1)
			mexErrMsgTxt("Provided value is no matrix of type double(Mx1)!");

		unsigned int m = mxGetM(prhs[0]);
		sample->setValueDim(m);

		sample->setValues(mxGetPr(prhs[0]));
		return;
	}
	else if (object->getClassType() == ct_SampleSet)
	{
		_SampleSetType* sample_set = dynamic_cast<_SampleSetType*>(object);

		if (!mxIsDouble(prhs[0]))
			mexErrMsgTxt("Provided value is no matrix of type double(MxN)!");

		unsigned int m = mxGetM(prhs[0]);
		unsigned int n = mxGetN(prhs[0]);
		if (m != sample_set->getValueDim() || n != sample_set->getNumSamples())
			mexErrMsgTxt("Provided matrix is not of correct size!");

		sample_set->setValues(mxGetPr(prhs[0]));
		return;
	}
}
/**
 *
 */
void getTimeStamps(Persistent* object, mxArray *plhs[])
{
	if (object->getClassType() == ct_Sample)
	{
		_SampleType* sample = dynamic_cast<_SampleType*>(object);

		plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(plhs[0]) = sample->getTimeStamp();

	}
	else if (object->getClassType() == ct_SampleSet)
	{
		_SampleSetType* sample_set = dynamic_cast<_SampleSetType*>(object);

		unsigned int N = sample_set->getNumSamples();

		plhs[0] = mxCreateDoubleMatrix(1,N,mxREAL);
		sample_set->getTimeStamps(mxGetPr(plhs[0]));
	}
}
/**
 *
 */
void setTimeStamps(Persistent* object,int nrhs, const mxArray *prhs[])
{
	if (nrhs < 1)
		mexErrMsgTxt("No time stamp matrix is provided!");

	if (object->getClassType() == ct_Sample)
	{
		_SampleType* sample = dynamic_cast<_SampleType*>(object);

		if (!mxIsDouble(prhs[0]) || mxGetN(prhs[0]) != 1 || mxGetM(prhs[0]) != 1)
				mexErrMsgTxt("Provided time stamp is no matrix of type double(1x1)!");

		sample->setTimeStamp(mxGetScalar(prhs[0]));

	}
	else if (object->getClassType() == ct_SampleSet)
	{
		_SampleSetType* sample_set = dynamic_cast<_SampleSetType*>(object);

		if (!mxIsDouble(prhs[0]) || mxGetN(prhs[0]) != sample_set->getNumSamples() || mxGetM(prhs[0]) != 1)
			mexErrMsgTxt("Provided time stamp is no matrix of type double(1xN)!");

		sample_set->setTimeStamps(mxGetPr(prhs[0]));
	}
}
void getAttributes(Persistent* object, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
	if (object->getClassType() == ct_Sample)
	{
		_SampleType* sample = dynamic_cast<_SampleType*>(object);

		_AttributeType attribute = sample->getAttributes();
		unsigned int p = attribute.getN();
		plhs[0] = mxCreateDoubleMatrix(p,1,mxREAL);
		attribute.getData(mxGetPr(plhs[0]));
		return;
	}
	else if (object->getClassType() == ct_SampleSet)
	{
		_SampleSetType* sample_set = dynamic_cast<_SampleSetType*>(object);

		if (nrhs == 0)
		{

			unsigned int n = sample_set->getNumSamples();

			if (n == 0)
			{
				plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
				return;
			}

			_AttributeType* attributes = new _AttributeType[n];

			sample_set->getAttributes(attributes);

			unsigned int p = attributes[1].getN();

			plhs[0] = mxCreateDoubleMatrix(p,n,mxREAL);

			double* data = mxGetPr(plhs[0]);

			for (unsigned int i = 0; i < n; i++)
			{
				attributes[i].getData(data+i*p);
			}

			delete[] attributes;
		}
		else if (nrhs == 1)
		{
			if (mxGetM(prhs[0])!=1)
				mexErrMsgTxt("Provided index matrix must have ony one row!");

			if (!mxIsClass(prhs[0],"uint32"))
				mexErrMsgTxt("Provided index matrix is not of type uint32!");

			unsigned int k = mxGetN(prhs[0]);
			
			_AttributeType* attributes = new _AttributeType[k];
			unsigned int* indices = new unsigned int[k];

			for (unsigned int i = 0; i < k; i++)
			{
				indices[i] = reinterpret_cast<unsigned int*>(mxGetPr(prhs[0]))[i]-1;
			}

			sample_set->getAttributes(attributes,indices,k);

			delete[] indices;
			unsigned int p = attributes[1].getN();

			plhs[0] = mxCreateDoubleMatrix(p,k,mxREAL);

			double* data = mxGetPr(plhs[0]);

			for (unsigned int i = 0; i < k; i++)
			{
				attributes[i].getData(data+i*p);
			}

			delete[] attributes;
		}
	
	}
}

void setAttributes(Persistent* object,int nrhs, const mxArray *prhs[])
{
	if (nrhs < 1)
		mexErrMsgTxt("No attribute matrix is provided!");

	if (object->getClassType() == ct_Sample)
	{
		_SampleType* sample = dynamic_cast<_SampleType*>(object);

		if (!mxIsDouble(prhs[0]) || mxGetN(prhs[0]) != 1)
			mexErrMsgTxt("Provided attribute is no matrix of type double(Px1)!");

		unsigned int p = mxGetM(prhs[0]);
		sample->setAttributes(_AttributeType(p,1,mxGetPr(prhs[0])));
	}
	else if (object->getClassType() == ct_SampleSet)
	{
		_SampleSetType* sample_set = dynamic_cast<_SampleSetType*>(object);

		if (!mxIsDouble(prhs[0]))
			mexErrMsgTxt("Provided attributes are no matrix of type double(PxN)!");

		unsigned int n = mxGetN(prhs[0]);
		unsigned int p = mxGetM(prhs[0]);

		double* data = mxGetPr(prhs[0]);

		_AttributeType* attributes = new _AttributeType[n];

		for (unsigned int i = 0; i < n; i++)
		{
			attributes[i] = _AttributeType(p,1,data+i*p);
		}

		sample_set->setAttributes(attributes);

		delete[] attributes;	
	}
}
/**
 *
 */
void callMethod(unsigned int addr, const char* methodName, int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	Persistent* per = getObject(addr);

	if      (strcmp("getValues"    ,methodName) == 0) getValues    (per, plhs);
	else if (strcmp("setValues"    ,methodName) == 0) setValues    (per, nrhs, prhs);
	else if (strcmp("getTimeStamps",methodName) == 0) getTimeStamps(per, plhs);
	else if (strcmp("setTimeStamps",methodName) == 0) setTimeStamps(per, nrhs, prhs);
	else if (strcmp("getAttributes",methodName) == 0) getAttributes(per, plhs, nrhs, prhs);
	else if (strcmp("setAttributes",methodName) == 0) setAttributes(per, nrhs, prhs);
	else if (strcmp("findNearestNeighbors",methodName) == 0)
	{
		_SampleSetType* sample_set = dynamic_cast<_SampleSetType*>(per);

		if (sample_set)
		{
			if (!mxIsClass(prhs[0], "uint32"))
				mexErrMsgTxt("Provided address is not of type uint32!");
			
			unsigned int index = *reinterpret_cast<unsigned int*>(mxGetPr(prhs[0]));
			int k = 1;

			if (nrhs > 1 && mxIsNumeric(prhs[1]) && mxGetNumberOfElements(prhs[1]) == 1)
			{
				k = (int) *mxGetPr(prhs[1]);
#if defined(_DEBUG) | defined(_VERBOSE)
				mexPrintf("k=%i \n",k);
#endif
			}


			Persistent* other_object = getObject(index);

			if (other_object->getClassType() == ct_Sample)
			{
				//_SampleType* sample = dynamic_cast<_SampleType*>(other_object);
				//plhs[0] = mxCreateNumericMatrix(k,1,mxINT32_CLASS,mxREAL);
				//int *indices = reinterpret_cast<int*>(mxGetPr(plhs[0]));
				//sample_set->findNearestNeighbors(*sample,k,indices);
				//return;
			}
			else if (other_object->getClassType() == ct_SampleSet)
			{
				_SampleSetType* other_set = dynamic_cast<_SampleSetType*>(other_object);

				const unsigned int n = other_set->getNumSamples();
				
				plhs[0] = mxCreateNumericMatrix(k,n,mxINT32_CLASS,mxREAL);
				int *indices = reinterpret_cast<int*>(mxGetPr(plhs[0]));
				
				if (other_set->getValueDim() != sample_set->getValueDim())
					mexErrMsgTxt("Value dimesions of sample sets do not match!");
				
				double* distances = 0;

				if (nlhs > 1)
				{
					plhs[1] = mxCreateDoubleMatrix(k,n,mxREAL);
					distances = mxGetPr(plhs[1]);
				}
					
				sample_set->findNearestNeighbors(*other_set,k,indices,distances);

				for (unsigned int i = 0; i < k*n; i++)
					++(indices[i]);

				return;
			}
		}


	}
	else if (strcmp("findNearestSampleSets",methodName) == 0)
	{	
		_SampleSetType* dbSampleSet = dynamic_cast<_SampleSetType*>(per);
		
		// Finalize db if not done already
		if(!dbSampleSet->isInitialized()){
#if defined(_DEBUG) | defined(_VERBOSE)
			mexPrintf("Start init ...");
#endif
			dbSampleSet->initialize();
#if defined(_DEBUG) | defined(_VERBOSE)
			mexPrintf(" done\n");
#endif
		}
		
		if (!mxIsClass(prhs[0], "uint32"))
			mexErrMsgTxt("Provided address is not of type uint32!");
		
		unsigned int index = *reinterpret_cast<unsigned int*>(mxGetPr(prhs[0]));
		
		// Get number of neigbours
		int k1 = 1;
		int k2 = 1;
		
		if (nrhs > 1 && mxIsNumeric(prhs[1]) && mxGetNumberOfElements(prhs[1]) == 1)
		{
			k1 = (int) *mxGetPr(prhs[1]);
		}
		
		if (nrhs > 2 && mxIsNumeric(prhs[2]) && mxGetNumberOfElements(prhs[2]) == 1)
		{
			k2 = (int) *mxGetPr(prhs[2]);
		}

		// Get Query SampleSet
		Persistent*     per2           = getObject(index);		
		_SampleSetType* querySampleSet = dynamic_cast<_SampleSetType*>(per2);

		// Array to store results
		SampleSetWeightRange<double,_AttributeType>* sortedByWeights;
		
		// Initialize first output matrix
		plhs[0] = mxCreateNumericMatrix(1,1,mxINT32_CLASS,mxREAL);
		unsigned int *sizes = (unsigned int*)(mxGetPr(plhs[0]));
		
		// Search:
#if defined(_DEBUG) | defined(_VERBOSE)
		mexPrintf("Starting SEARCH ... ");
#endif
		dbSampleSet->getNNTrajectoriesRange_exclusive(sortedByWeights,sizes, k1 ,k2 ,*querySampleSet);
#if defined(_DEBUG) | defined(_VERBOSE)
		mexPrintf("finished!\n");
#endif
		
		// Initialize second output matrix	
		plhs[1] = mxCreateNumericMatrix(1,*sizes  ,mxDOUBLE_CLASS,mxREAL);
		plhs[2] = mxCreateNumericMatrix(1,*sizes  ,mxINT32_CLASS ,mxREAL);
		plhs[3] = mxCreateNumericMatrix(1,*sizes*2,mxINT32_CLASS ,mxREAL);
		
		double       *tmp  = (double*)      (mxGetPr(plhs[1]));
		unsigned int *tmp2 = (unsigned int*)(mxGetPr(plhs[2]));
		         int *tmp3 = (         int*)(mxGetPr(plhs[3]));
		         
		for(unsigned int w=0;w<*sizes;w++){
			tmp [w]     = sortedByWeights[w].weight;
			tmp2[w]     = sortedByWeights[w].sampleSet->getSampleSetID();
			tmp3[w*2]   = sortedByWeights[w].indices[0]+1;
			tmp3[w*2+1] = sortedByWeights[w].indices[1]+1;
		}
		// Cleanup
		delete[] sortedByWeights;
	}	
	else
	{
		mexErrMsgTxt("Method name not recognized!");
	}
}

/**
 *
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs < 1)
        mexErrMsgTxt("You have to provide a command argument!");

	char* command = 0;

	if (mxIsChar(prhs[0]) && mxGetM(prhs[0]) == 1)
    {
		const unsigned int buflen = mxGetNumberOfElements(prhs[0]) + 1;
		command = reinterpret_cast<char*>(mxCalloc(buflen, sizeof(char)));

		if (mxGetString(prhs[0], command, buflen) != 0)
			mexErrMsgTxt("Could not read command argument!");

		//clean whole memory
		if (strcmp("clean",command) == 0)
		{
			std::vector<Persistent*>::iterator I;

			for (I = m_persistent_objects.begin(); I != m_persistent_objects.end(); I++)
				if(*I) delete(*I);

			m_persistent_objects.clear();
		} 

		//show number of persistent objects
		else if (strcmp("count",command) == 0)
		{
			plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
			*mxGetPr(plhs[0]) = m_persistent_objects.size();
		}
		//create new persistent object
		else if (strcmp("new",command) == 0)
		{
			if (nrhs < 2)
				mexErrMsgTxt("The new command requires a least a second argument of type string");

			if (!mxIsChar(prhs[1]))
				mexErrMsgTxt("Second argument is not of type string!");

			
			const unsigned int len = mxGetNumberOfElements(prhs[1]) + 1;
			char* type_string = reinterpret_cast<char*>(mxCalloc(len, sizeof(char)));

			if (mxGetString(prhs[1], type_string, len) != 0)
				mexErrMsgTxt("Could not read type argument!");

			mwSize dims[2] = {1,1};

			plhs[0] = mxCreateNumericArray(2,dims,mxUINT32_CLASS,mxREAL);
			*reinterpret_cast<unsigned int*>(mxGetPr(plhs[0])) = createNew(type_string,nrhs-2, prhs+2);

			mxFree(type_string);	
		}

		else if (strcmp("delete",command) == 0)
		{
			if (nrhs < 2)
				mexErrMsgTxt("The delete command requires a second argument of type uint32");

			if (!mxIsClass(prhs[1], "uint32"))
				mexErrMsgTxt("Second argument is not of type uint32!");

			unsigned int index = *reinterpret_cast<unsigned int*>(mxGetPr(prhs[1]));

			deleteObject(index);
		}

		else if (strcmp("getTypeOf",command) == 0)
		{
			if (nrhs < 2)
				mexErrMsgTxt("The getTypeOf command requires a second argument of type uint32");

			if (!mxIsClass(prhs[1], "uint32"))
				mexErrMsgTxt("Second argument is not of type uint32!");

			unsigned int index = *reinterpret_cast<unsigned int*>(mxGetPr(prhs[1]));

			Persistent* ptr = getObject(index);

			switch(ptr->getClassType())
			{
			case ct_Sample:
				plhs[0] = mxCreateString("Sample");
				break;
			case ct_SampleSet:
				plhs[0] = mxCreateString("SampleSet");
				break;
			case ct_Trajectory:
				plhs[0] = mxCreateString("Trajectory");
				break;
			case ct_TrajectorySet:
				plhs[0] = mxCreateString("TrajectorySet");
				break;
			default:
				mexErrMsgTxt("Type of object is unkown!\n");
			}
		}
		else if (strcmp("call",command) == 0)
		{
			if (nrhs < 3)
				mexErrMsgTxt("The call command needs at least 2 additional parameters (uint32(1x1) address, char(1xS) methodToCall)");
			
			if (!mxIsClass(prhs[1],"uint32") || mxGetM(prhs[1]) != 1 || mxGetN(prhs[1]) != 1 )
				mexErrMsgTxt("Second argument is not of type uint32(1x1)");

			if (!mxIsChar(prhs[2]) || mxGetM(prhs[2]) != 1)
				mexErrMsgTxt("Third argument is not of type char(1xS)");

			unsigned int addr = *reinterpret_cast<unsigned int*>(mxGetPr(prhs[1]));
			unsigned int len = mxGetNumberOfElements(prhs[2])+1;
			char* method_name = new char[len];

			if (mxGetString(prhs[2], method_name, len) != 0)
				mexErrMsgTxt("Could not read methodName argument!");

			callMethod(addr,method_name,nlhs,plhs,nrhs-3,prhs+3);

			delete[] method_name;
		}
		else if (strcmp("union",command) == 0)
		{
			if (!mxIsClass(prhs[1],"uint32") || mxGetM(prhs[1]) != 1 || mxGetN(prhs[1]) != 1 )
				mexErrMsgTxt("Second argument is not of type uint32(1x1)");

			if (!mxIsClass(prhs[2],"uint32") || mxGetM(prhs[2]) != 1 || mxGetN(prhs[2]) != 1 )
				mexErrMsgTxt("Third argument is not of type uint32(1x1)");

			Persistent* first  = getObject(*reinterpret_cast<unsigned int*>(mxGetPr(prhs[1])));
			Persistent* second = getObject(*reinterpret_cast<unsigned int*>(mxGetPr(prhs[2])));

			if (first->getClassType() == ct_SampleSet && second->getClassType() == ct_SampleSet)
			{
				_SampleSetType* result = new _SampleSetType;

				*result = *dynamic_cast<_SampleSetType*>(first) + *dynamic_cast<_SampleSetType*>(second);

				plhs[0] = mxCreateNumericMatrix(1,1,mxUINT32_CLASS,mxREAL);
				unsigned int* addr = (unsigned int*)mxGetPr(plhs[0]);
				
				*addr = addObject(result);
#if defined(_DEBUG) | defined(_VERBOSE)
				mexPrintf("addr: %i\n",addr);
#endif

			}
		}
		else if (strcmp("unionMultiple",command) == 0)
		{
			if (!mxIsClass(prhs[1],"uint32") || mxGetM(prhs[1]) != 1 || !(mxGetN(prhs[1]) > 1) )
				mexErrMsgTxt("Second argument is not of type uint32(1xn)");

			unsigned int*   objects = (unsigned int*) mxGetPr(prhs[1]);
			
			std::vector<_SampleSetType*> SampleSets;
			Persistent* per;
			
			for(unsigned int obj=0;obj<mxGetN(prhs[1]);obj++){
				
				per = getObject(objects[obj]);
				if(per->getClassType()==1){
					SampleSets.push_back(dynamic_cast<_SampleSetType*>(per));	
				}
			}


			_SampleSetType* result = new _SampleSetType(SampleSets);

			plhs[0] = mxCreateNumericMatrix(1,1,mxUINT32_CLASS,mxREAL);
			unsigned int* addr = (unsigned int*)mxGetPr(plhs[0]);
			
			*addr = addObject(result);
		}
		
		else
		{
			mexErrMsgTxt("The command was not recognized!");
		}
		
	}
}
