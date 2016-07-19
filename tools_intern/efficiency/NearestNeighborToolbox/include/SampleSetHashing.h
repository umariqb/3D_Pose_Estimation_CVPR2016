/*		(c) 2008,2009 GfaR GmbH			*/

/* A simple hash table					*/

#ifndef _SampleSetHashing_h
#define _SampleSetHashing_h

#include <algorithm>

template<typename ValueType, typename AttributeType> class SampleSet;

template<typename ValueType, typename AttributeType>
struct SampleSetWeight
{
public:

	double weight;
	SampleSet<ValueType,AttributeType>* sampleSet;
	
	SampleSetWeight<ValueType,AttributeType>(SampleSet<ValueType,AttributeType>* SS,double w){
		weight=w;
		sampleSet=SS;
	}
	
	SampleSetWeight<ValueType,AttributeType>(){	}

	inline bool operator < (const SampleSetWeight<ValueType,AttributeType>& n) const 
	{
		return weight < n.weight;
	};

};

template<typename ValueType, typename AttributeType>
struct SampleSetWeightRange
{
public:

	double weight;
	int indices[2];
	SampleSet<ValueType,AttributeType>* sampleSet;
	
	SampleSetWeightRange<ValueType,AttributeType>(SampleSet<ValueType,AttributeType>* SS,double w, int i0, int i1)
	{
		indices[0] = i0;
		indices[1] = i1;
		weight=w;
		sampleSet=SS;
	};
	
	SampleSetWeightRange<ValueType,AttributeType>()
	{	
	
	};

	inline bool operator < (const SampleSetWeightRange<ValueType,AttributeType>& n) const 
	{
		return weight < n.weight;
	};

};

template<typename ValueType, typename AttributeType>
class SampleSetWHashNode
{
public:

	SampleSetWHashNode<ValueType,AttributeType>()
	{
		nextElem = 0;
	};

	SampleSetWHashNode<ValueType,AttributeType>(SampleSetWeight<ValueType,AttributeType>* ssw)
	{
		sampleSetW(ssw);
		nextElem = 0;
	};

	SampleSetWeight<ValueType,AttributeType> sampleSetW;
	SampleSetWHashNode* nextElem;

};


template<typename ValueType, typename AttributeType>
class SampleSetWRHashNode
{
public:

	SampleSetWRHashNode<ValueType,AttributeType>()
	{
		nextElem = 0;
	};

	SampleSetWRHashNode<ValueType,AttributeType>(SampleSetWeightRange<ValueType,AttributeType>* ssw)
	{
		sampleSetW(ssw);
		nextElem = 0;
	};

	SampleSetWeightRange<ValueType,AttributeType> sampleSetWR;
	SampleSetWRHashNode* nextElem;

};

template<typename ValueType, typename AttributeType>
class SampleSetHashNode
{
public:

	SampleSetHashNode<ValueType,AttributeType>()
	{
		nextElem = 0;
	};

	SampleSetHashNode<ValueType,AttributeType>(SampleSet<ValueType,AttributeType>* ss)
	{
		sampleSet = (*ss);
		nextElem = 0;
	};

	SampleSet<ValueType,AttributeType>* sampleSet;
	SampleSetHashNode* nextElem;
};



template<typename ValueType, typename AttributeType>
class SampleSetWHashing
{
public:

	// hashTableSize: size of the hashTable
	// nMaxElements: max number of elements to be stored in the hash table
	// Example: SimpleHashUnsafe(nMaxElements,nMaxElements)
	SampleSetWHashing(unsigned int hashTableSize, unsigned int nMaxElements)
	{
		tabSize = hashTableSize;
		bufferSize = nMaxElements - 1;
		totalBufferSize =  tabSize + bufferSize;
		nextFree = tabSize-1; 
		currentId = 1;
		hashTab = (SampleSetWHashNode<ValueType,AttributeType>*)malloc(sizeof(SampleSetWHashNode<ValueType,AttributeType>)*totalBufferSize);
		linkTab = (SampleSetWHashNode<ValueType,AttributeType>**)malloc(sizeof(SampleSetWHashNode<ValueType,AttributeType>*)*tabSize);
		visitedIDs = (unsigned int*)malloc(sizeof(unsigned int)*tabSize);
		memset(hashTab,0,tabSize*sizeof(SampleSetWHashNode<ValueType,AttributeType>));
		memset(visitedIDs,0,tabSize*sizeof(unsigned int));
		nextLink = 0;
		nElements = 0;
	};
	
	~SampleSetWHashing()
	{
		if (hashTab != 0) free(hashTab);
		if (visitedIDs != 0) free(visitedIDs);
		if (linkTab != 0) free(linkTab);
	};

	void reset()
	{
		++currentId;
		nextLink = 0;
		nElements = 0;
		nextFree = tabSize-1; 
	};


inline bool addElementInclusive(SampleSetWeight<ValueType,AttributeType>& ssw)
	{
		unsigned int bucket = (ssw.sampleSet->getHashKey())%tabSize; 
		SampleSetWHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

		if (visitedIDs[bucket] != currentId)
		{
			linkTab[nextLink] = hashNode;
			++nextLink;
			hashNode->sampleSetW = ssw;
			hashNode->nextElem = 0;
			visitedIDs[bucket] = currentId;
			++nElements;
			return true;
		}
	
		else
		{	
				if ( hashNode->sampleSetW.sampleSet == ssw.sampleSet) 
				{
					hashNode->sampleSetW.weight += ssw.weight; 
					return true;
				}
			
			while (hashNode->nextElem != 0)
			{
				// update weights if index was found
				if ( hashNode->sampleSetW.sampleSet == ssw.sampleSet) 
				{
					hashNode->sampleSetW.weight += ssw.weight; 
					return true;
				}
				hashNode = hashNode->nextElem;	
			}
			
			// create new element otherwise
			++nextFree;
			if (nextFree < totalBufferSize)
			{
				++nElements;
				hashTab[nextFree].nextElem = 0;
				hashTab[nextFree].sampleSetW = ssw;
				hashNode->nextElem = hashTab+nextFree;
				return true;
			}
			else 
			{
				--nextFree;
				return false;
			}
		}
};


inline bool addElementExistingInclusive(SampleSetWeight<ValueType,AttributeType>& ssw)
{
	unsigned int bucket = (ssw.sampleSet->getHashKey())%tabSize; 
	SampleSetWHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

	if (visitedIDs[bucket] != currentId) return false;
	else
	{	
		if ( hashNode->sampleSetW.sampleSet == ssw.sampleSet) 
		{
			hashNode->sampleSetW.weight += ssw.weight; 
			return true;
		}
		while (hashNode->nextElem != 0)
		{
			// update weights if index was found
			if ( hashNode->sampleSetW.sampleSet == ssw.sampleSet) 
			{
				hashNode->sampleSetW.weight += ssw.weight; 
				return true;
			}
			hashNode = hashNode->nextElem;	
		}
		return false;
	}
};


inline bool addElementExclusive(SampleSetWeight<ValueType,AttributeType>& ssw)
{
	unsigned int bucket = (ssw.sampleSet->getHashKey())%tabSize; 
	SampleSetWHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

		if (visitedIDs[bucket] != currentId)
		{
			linkTab[nextLink] = hashNode;
			++nextLink;
			hashNode->sampleSetW = ssw;
			hashNode->nextElem = 0;
			visitedIDs[bucket] = currentId;
			++nElements;
			return true;
		}
	
		else
		{	
				if ( hashNode->sampleSetW.sampleSet == ssw.sampleSet) 
				{
					if (ssw.weight > hashNode->sampleSetW.weight) hashNode->sampleSetW.weight = ssw.weight; 
					return true;
				}
			
			while (hashNode->nextElem != 0)
			{
				// update weights if index was found
				if ( hashNode->sampleSetW.sampleSet == ssw.sampleSet) 
				{
					if (ssw.weight > hashNode->sampleSetW.weight) hashNode->sampleSetW.weight = ssw.weight; 
					return true;
				}
				hashNode = hashNode->nextElem;	
			}
			
			// create new element otherwise
			++nextFree;
			if (nextFree < totalBufferSize)
			{
				++nElements;
				hashTab[nextFree].nextElem = 0;
				hashTab[nextFree].sampleSetW = ssw;
				hashNode->nextElem = hashTab+nextFree;
				return true;
			}
			else 
			{
				--nextFree;
				return false;
			}
		}
	};



	inline void getElementsSorted(SampleSetWeight<ValueType,AttributeType>*& sortedList,unsigned int* size)
	{
		*size = nElements;
		sortedList = new SampleSetWeight<ValueType,AttributeType> [nElements];
		unsigned int j = 0;

		// copy data
		for (unsigned int i=0;i<nextLink;i++)
		{
			SampleSetWHashNode<ValueType,AttributeType>* hashNode = linkTab[i];
			sortedList[j] = hashNode->sampleSetW;
			++j;
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				sortedList[j] = hashNode->sampleSetW;
				++j;
			}
		}

		// sort
		std::sort(sortedList,sortedList+nElements);
		
	
	};

	inline void getElements_1(SampleSetWeight<ValueType,AttributeType>*& list,unsigned int* size)
	{
		*size = nElements;
		list =  new SampleSetWeight<ValueType,AttributeType>* [nElements];
		unsigned int j = 0;

		// copy data
		for (int i=0;i<nextLink;i++)
		{
			SampleSetWHashNode<ValueType,AttributeType>* hashNode = linkTab[i];
			list[j] = hashNode->sampleSetW;
			++j;
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				list[j] = hashNode->sampleSetW;
				++j;
			}
		}
	};

	inline void getElements_2(SampleSetWeight<ValueType,AttributeType>*& list,unsigned int* size)
	{
		*size = nElements;
		unsigned int j = 0;

		// copy data
		for (unsigned int i=0;i<nextLink;i++)
		{
			SampleSetWHashNode<ValueType,AttributeType>* hashNode = linkTab[i];
			list[j] = hashNode->sampleSetW;
			++j;
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				list[j] = hashNode->sampleSetW;
				++j;
			}
		}
	};




	inline bool findElement(SampleSet<ValueType,AttributeType>& ss)
	{
		unsigned int bucket =  (ss.getHashKey())%tabSize; 
		
		if (visitedIDs[bucket] != currentId) return false;
		
		SampleSetWHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

		if (hashNode->sampleSetW.sampleSet == &ss) return true;
		else
		{
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				if (hashNode->sampleSetW.sampleSet == &ss) return true;
			}
			return false;
		}
	};

	unsigned int getnFree()
	{
		return totalBufferSize - nextFree;
	};

	unsigned int getnElements()
	{
		return nElements;
	};

private:

	// pointers to occupied hash buckets
	SampleSetWHashNode<ValueType,AttributeType>** linkTab;
	unsigned int nextLink;

	unsigned int currentId;
	unsigned int tabSize;
	unsigned int bufferSize;
	unsigned int totalBufferSize;
	unsigned int nextFree;

	unsigned int nElements;

	// hash table
	SampleSetWHashNode<ValueType,AttributeType>* hashTab;

	// to check if a bucket was newly created (or is just left from a previous reset)
	unsigned int* visitedIDs;
};


template<typename ValueType, typename AttributeType>
class SampleSetWRHashing
{
public:

	// hashTableSize: size of the hashTable
	// nMaxElements: max number of elements to be stored in the hash table
	// Example: SimpleHashUnsafe(nMaxElements,nMaxElements)
	SampleSetWRHashing(unsigned int hashTableSize, unsigned int nMaxElements)
	{
		tabSize = hashTableSize;
		bufferSize = nMaxElements - 1;
		totalBufferSize =  tabSize + bufferSize;
		nextFree = tabSize-1; 
		currentId = 1;
		hashTab = (SampleSetWRHashNode<ValueType,AttributeType>*)malloc(sizeof(SampleSetWRHashNode<ValueType,AttributeType>)*totalBufferSize);
		linkTab = (SampleSetWRHashNode<ValueType,AttributeType>**)malloc(sizeof(SampleSetWRHashNode<ValueType,AttributeType>*)*tabSize);
		visitedIDs = (unsigned int*)malloc(sizeof(unsigned int)*tabSize);
		memset(hashTab,0,tabSize*sizeof(SampleSetWRHashNode<ValueType,AttributeType>));
		memset(visitedIDs,0,tabSize*sizeof(unsigned int));
		nextLink = 0;
		nElements = 0;
	};
	
	~SampleSetWRHashing()
	{
		if (hashTab != 0) free(hashTab);
		if (visitedIDs != 0) free(visitedIDs);
		if (linkTab != 0) free(linkTab);
	};

	void reset()
	{
		++currentId;
		nextLink = 0;
		nElements = 0;
		nextFree = tabSize-1; 
	};


inline bool addElementInclusive(SampleSetWeightRange<ValueType,AttributeType>& ssw)
	{
		unsigned int bucket = (ssw.sampleSet->getHashKey())%tabSize; 
		SampleSetWRHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

		if (visitedIDs[bucket] != currentId)
		{
			linkTab[nextLink] = hashNode;
			++nextLink;
			hashNode->sampleSetWR = ssw;
			hashNode->nextElem = 0;
			visitedIDs[bucket] = currentId;
			++nElements;
			return true;
		}

		else
		{	
			if ( hashNode->sampleSetWR.sampleSet == ssw.sampleSet) 
			{
				hashNode->sampleSetWR.weight += ssw.weight; 
				return true;
			}

			while (hashNode->nextElem != 0)
			{
				// update weights if index was found
				if ( hashNode->sampleSetWR.sampleSet == ssw.sampleSet) 
				{
					hashNode->sampleSetWR.weight += ssw.weight; 
					return true;
				}
				hashNode = hashNode->nextElem;	
			}

			// create new element otherwise
			++nextFree;
			if (nextFree < totalBufferSize)
			{
				++nElements;
				hashTab[nextFree].nextElem = 0;
				hashTab[nextFree].sampleSetWR = ssw;
				hashNode->nextElem = hashTab+nextFree;
				return true;
			}
			else 
			{
				--nextFree;
				return false;
			}
		}
};


inline bool addElementExistingInclusive(SampleSetWeightRange<ValueType,AttributeType>& ssw)
{
	unsigned int bucket = (ssw.sampleSet->getHashKey())%tabSize; 

	if (visitedIDs[bucket] != currentId) return false;
	else
	{	
		SampleSetWRHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

		if ( hashNode->sampleSetWR.sampleSet == ssw.sampleSet) 
		{
			hashNode->sampleSetWR.weight += ssw.weight;
			if (ssw.indices[0] > -1) hashNode->sampleSetWR.indices[0] = ssw.indices[0];
			if (ssw.indices[1] > -1) hashNode->sampleSetWR.indices[1] = ssw.indices[1];
			return true;
		}

		while (hashNode->nextElem != 0)
		{
			hashNode = hashNode->nextElem;	

			// update weights if index was found
			if ( hashNode->sampleSetWR.sampleSet == ssw.sampleSet) 
			{
				hashNode->sampleSetWR.weight += ssw.weight; 
				if (ssw.indices[0] > -1) hashNode->sampleSetWR.indices[0] = ssw.indices[0];
				if (ssw.indices[1] > -1) hashNode->sampleSetWR.indices[1] = ssw.indices[1];
				return true;
			}

		}
		return false;
	}
};


inline bool addElementExclusive(SampleSetWeightRange<ValueType,AttributeType>& ssw)
{
	unsigned int bucket = (ssw.sampleSet->getHashKey())%tabSize; 
	SampleSetWRHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

	if (visitedIDs[bucket] != currentId)
	{
		linkTab[nextLink] = hashNode;
		++nextLink;
		hashNode->sampleSetWR.sampleSet = ssw.sampleSet;
		hashNode->sampleSetWR.weight = ssw.weight;
		hashNode->sampleSetWR.indices[0] = ssw.indices[0];
		hashNode->sampleSetWR.indices[1] = ssw.indices[1];
		
		hashNode->nextElem = 0;
		visitedIDs[bucket] = currentId;
		++nElements;
		return true;
	}

	else
	{	
		if ( hashNode->sampleSetWR.sampleSet == ssw.sampleSet) 
		{
			if (ssw.weight > hashNode->sampleSetWR.weight) 
			{
				hashNode->sampleSetWR.indices[0] = ssw.indices[0];
				hashNode->sampleSetWR.indices[1] = ssw.indices[1];
		
				hashNode->sampleSetWR.weight = ssw.weight; 
			}
			return true;
		}

		while (hashNode->nextElem != 0)
		{

			hashNode = hashNode->nextElem;


			// update weights if index was found
			if ( hashNode->sampleSetWR.sampleSet == ssw.sampleSet) 
			{
				if (ssw.weight > hashNode->sampleSetWR.weight) 
				{
					hashNode->sampleSetWR.indices[0] = ssw.indices[0];
					hashNode->sampleSetWR.indices[1] = ssw.indices[1];
				
					hashNode->sampleSetWR.weight = ssw.weight; 
				}
				return true;
			}	

			
		}

		// create new element otherwise
		++nextFree;
		if (nextFree < totalBufferSize)
		{
			++nElements;
			hashTab[nextFree].sampleSetWR.sampleSet = ssw.sampleSet;
			hashTab[nextFree].sampleSetWR.weight = ssw.weight;
		
			 hashTab[nextFree].sampleSetWR.indices[0] = ssw.indices[0];
			hashTab[nextFree].sampleSetWR.indices[1] = ssw.indices[1];
			hashTab[nextFree].nextElem = 0;
			hashNode->nextElem = hashTab+nextFree;
			return true;
		}
		else 
		{
			--nextFree;
			return false;
		}
	}
};



inline void getElementsSorted(SampleSetWeightRange<ValueType,AttributeType>*& sortedList,unsigned int* size)
{
	
		sortedList = new SampleSetWeightRange<ValueType,AttributeType> [nElements];
		unsigned int j = 0;

		// copy data
		for (unsigned int i=0;i<nextLink;i++)
		{
			SampleSetWRHashNode<ValueType,AttributeType>* hashNode = linkTab[i];
			if (hashNode->sampleSetWR.indices[1] > 0)
			{
			sortedList[j] = hashNode->sampleSetWR;
			//if (hashNode->sampleSetWR.sampleSet == 0) mexPrintf("1----------------> null\n");
			++j;
			}
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				if (hashNode->sampleSetWR.indices[1] > 0)
				{
				
				sortedList[j] = hashNode->sampleSetWR;
				++j;
				}
			}
		}
		
		// sort
		std::sort(sortedList,sortedList+j);
		
		*size = j;
	
	};

	inline void getElements_1(SampleSetWeightRange<ValueType,AttributeType>*& list,unsigned int* size)
	{
		*size = nElements;
		list =  new SampleSetWeightRange<ValueType,AttributeType> [nElements];
		unsigned int j = 0;

		// copy data
		for (int i=0;i<nextLink;i++)
		{
			SampleSetWRHashNode<ValueType,AttributeType>* hashNode = linkTab[i];
			list[j] = hashNode->sampleSetWR;
			++j;
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				list[j] = hashNode->sampleSetWR;
				++j;
			}
		}
	};

	inline void getElements_2(SampleSetWeightRange<ValueType,AttributeType>*& list,unsigned int* size)
	{
		*size = nElements;
		unsigned int j = 0;

		// copy data
		for (unsigned int i=0;i<nextLink;i++)
		{
			SampleSetWRHashNode<ValueType,AttributeType>* hashNode = linkTab[i];
			list[j] = hashNode->sampleSetWR;
			++j;
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				list[j] = hashNode->sampleSetWR;
				++j;
			}
		}
	};




	inline bool findElement(SampleSet<ValueType,AttributeType>& ss)
	{
		unsigned int bucket =  (ss.getHashKey())%tabSize; 
		
		if (visitedIDs[bucket] != currentId) return false;
		
		SampleSetWRHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

		if (hashNode->sampleSetWR.sampleSet == &ss) return true;
		else
		{
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				if (hashNode->sampleSetWR.sampleSet == &ss) return true;
			}
			return false;
		}
	};

	unsigned int getnFree()
	{
		return totalBufferSize - nextFree;
	};

	unsigned int getnElements()
	{
		return nElements;
	};

private:

	// pointers to occupied hash buckets
	SampleSetWRHashNode<ValueType,AttributeType>** linkTab;
	unsigned int nextLink;

	unsigned int currentId;
	unsigned int tabSize;
	unsigned int bufferSize;
	unsigned int totalBufferSize;
	unsigned int nextFree;

	unsigned int nElements;

	// hash table
	SampleSetWRHashNode<ValueType,AttributeType>* hashTab;

	// to check if a bucket was newly created (or is just left from a previous reset)
	unsigned int* visitedIDs;
};



template<typename ValueType, typename AttributeType>
class SampleSetHashing
{
public:

	// hashTableSize: size of the hashTable
	// nMaxElements: max number of elements to be stored in the hash table
	// Example: SimpleHashUnsafe(nMaxElements,nMaxElements)
	SampleSetHashing(unsigned int hashTableSize, unsigned int nMaxElements)
	{
		tabSize = hashTableSize;
		bufferSize = nMaxElements - 1;
		totalBufferSize =  tabSize + bufferSize;
		nextFree = tabSize-1; 
		currentId = 1;
		hashTab = (SampleSetHashNode<ValueType,AttributeType>*)malloc(sizeof(SampleSetHashNode<ValueType,AttributeType>)*totalBufferSize);
		visitedIDs = (unsigned int*)malloc(sizeof(unsigned int)*tabSize);
		memset(hashTab,0,tabSize*sizeof(SampleSetHashNode<ValueType,AttributeType>));
		memset(visitedIDs,0,tabSize*sizeof(unsigned int));
		nElements = 0;
	};
	
	~SampleSetHashing()
	{
		if (hashTab != 0) free(hashTab);
		if (visitedIDs != 0) free(visitedIDs);
	};

	void reset()
	{
		++currentId;
		nElements = 0;
		nextFree = tabSize-1; 
	};


	inline bool addElement(SampleSet<ValueType,AttributeType>& ss)
	{
		unsigned int bucket = (ss.getHashKey())%tabSize; 
		SampleSetHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

		if (visitedIDs[bucket] != currentId)
		{
			hashNode->sampleSet = &ss;
			hashNode->nextElem = 0;
			visitedIDs[bucket] = currentId;
			++nElements;
		
			return true;
		}
	
		else
		{
			if(hashNode->sampleSet==&ss) return true;
			
			while (hashNode->nextElem != 0) 
			{
				// index is already in the list
				if ( hashNode->sampleSet == &ss) return true;
				hashNode = hashNode->nextElem;
			}

			// create new element otherwise
			++nextFree;
			if (nextFree < totalBufferSize)
			{
				++nElements;
			
				hashTab[nextFree].sampleSet = &ss;
				hashTab[nextFree].nextElem = 0;
				hashNode->nextElem = hashTab+nextFree;
				return true;
			}
			else 
			{
				--nextFree;
				return false;
			}
		}
	};


	inline bool findElement(SampleSet<ValueType,AttributeType>& ss)
	{
		unsigned int bucket =  (ss->getHashKey())%tabSize; 
		
		if (visitedIDs[bucket] != currentId) return false;
		
		SampleSetHashNode<ValueType,AttributeType>* hashNode = hashTab+bucket;

		if (hashNode->sampleSet == &ss) return true;
		else
		{
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				if (hashNode->sampleSet == &ss) return true;
			}
			return false;
		}
	};

	unsigned int getnFree()
	{
		return totalBufferSize - nextFree;
	};

	unsigned int getnElements()
	{
		return nElements;
	};



private:



	unsigned int currentId;
	unsigned int tabSize;
	unsigned int bufferSize;
	unsigned int totalBufferSize;
	unsigned int nextFree;

	unsigned int nElements;

	// hash table
	SampleSetHashNode<ValueType,AttributeType>* hashTab;

	// to check if a bucket was newly created (or is just left from a previous reset)
	unsigned int* visitedIDs;
};



#endif
