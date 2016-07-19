/*		(c) 2008,2009 GfaR GmbH			*/

/* A simple hash table					*/

#ifndef _SimpleHashUnsafe_h
#define _SimpleHashUnsafe_h

#include "string.h"

template <class T>
class HashNode
{
public:

	HashNode()
	{
		data = 0;
		nextElem = 0;
	};

	HashNode(T* d)
	{
		data = d;
		nextElem = 0;
	};

	T* data;
	HashNode<T>* nextElem;
};


template <class T>
class SimpleHashUnsafe
{
public:

	// hashTableSize: size of the hashTable
	// nMaxElements: max number of elements to be stored in the hash table
	// getHashKey: optional user defined hash function; if no function is given (null pointer) a simple Modulo hash key is used
	// Example: SimpleHashUnsafe(nMaxElements,nMaxElements)
	SimpleHashUnsafe(unsigned int hashTableSize, unsigned int nMaxElements, unsigned int (*getHashKey)(T*)=0)
	{
		hashKey = getHashKey;
#ifdef _LightTool_DEBUG
		collisions = 0;
#endif
		tabSize = hashTableSize;
		bufferSize = nMaxElements - 1;
		totalBufferSize =  tabSize + bufferSize;
		nextFree = tabSize-1; 
		currentId = 1;
		hashTab = (HashNode<T>*)malloc(sizeof(HashNode<T>)*totalBufferSize);
		visitedIDs = (unsigned int*)malloc(sizeof(unsigned int)*tabSize);
		memset(hashTab,0,tabSize*sizeof(HashNode<T>));
		memset(visitedIDs,0,tabSize*sizeof(unsigned int));
	};
	
	~SimpleHashUnsafe()
	{
		if (hashTab != 0) free(hashTab);
		if (visitedIDs != 0) free(visitedIDs);

	};

	void reset()
	{
		++currentId;
#ifdef _LightTool_DEBUG
		collisions = 0;
#endif
		nextFree = tabSize-1; 
	};


	// use addElement if duplicates are not very likely
	inline bool addElement(T* e)
	{
		unsigned int bucket;
		if (hashKey == 0) bucket = ((unsigned int)*e)%tabSize; 
		else bucket = ((*hashKey)(e))%tabSize;

		HashNode<T>* hashNode = hashTab + bucket;
		if (visitedIDs[bucket] != currentId)
		{
			hashNode->data = e;
			hashNode->nextElem = 0;
			visitedIDs[bucket] = currentId;
			return true;
		}
		else
		{
#ifdef _LightTool_DEBUG
			++collisions;
#endif
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;	
			}
			++nextFree;
			if (nextFree < totalBufferSize)
			{
				hashTab[nextFree].data = e;
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

	// use addElement if duplicates are likely
	inline bool addElementD(T* e)
	{
		unsigned int bucket;
		if (hashKey == 0) bucket = ((unsigned int)*e)%tabSize; 
		else bucket = (*hashKey)(e)%tabSize;
 
		HashNode<T>* hashNode = hashTab+bucket;

		if (visitedIDs[bucket] != currentId)
		{
			hashNode->data = e;
			hashNode->nextElem = 0;
			visitedIDs[bucket] = currentId;
			return true;
		}
	
		else
		{
#ifdef _LightTool_DEBUG
			++collisions;
#endif
			while (hashNode->nextElem != 0) 
			{
				// check for duplicates
				if (*(hashNode->data) == *e) return true;
				hashNode = hashNode->nextElem;	
			}

			++nextFree;
			if (nextFree < totalBufferSize)
			{
				hashTab[nextFree].data = e;
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

	// see addElements
	bool addElements(T* e, unsigned int n)
	{
		for (unsigned int i=0;i<n;i++)
		{
			if (addElement(e)==false) return false;
			++e;
		}
		return true;
	};

	// see addElementsD
	bool addElementsD(T* e, unsigned int n)
	{
		for (unsigned int i=0;i<n;i++)
		{
			if (addElementD(e)==false) return false;
			++e;
		}
		return true;
	};

	
	inline bool findElement(T* e)
	{
		unsigned int bucket;
		if (hashKey == 0) bucket = ((unsigned int)*e)%tabSize; 
		else bucket = (*hashKey)(e)%tabSize;

		HashNode<T>* hashNode = hashTab+bucket;
		if (visitedIDs[bucket] != currentId) return false;

		if (*(hashNode->data) == *e) return true;
		else
		{
			while (hashNode->nextElem != 0) 
			{
				hashNode = hashNode->nextElem;
				if (*(hashNode->data) == *e) return true;
			}
			return false;
		}
	};


	unsigned int getFree()
	{
		return totalBufferSize - nextFree;
	};


#ifdef _LightTool_DEBUG
	inline unsigned int getnCollisions() {return collisions;}
#endif
	

private:

#ifdef _LightTool_DEBUG
	unsigned int collisions;
#endif

	unsigned int (*hashKey)(T*);

	unsigned int currentId;
	unsigned int tabSize;
	unsigned int bufferSize;
	unsigned int totalBufferSize;
	unsigned int nextFree;

	HashNode<T>* hashTab;
	// to check if a bucket was newly created (or is just left from a previous reset)
	unsigned int* visitedIDs;
};











#endif
