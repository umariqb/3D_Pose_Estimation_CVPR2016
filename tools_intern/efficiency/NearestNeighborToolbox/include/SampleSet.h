#ifndef __SAMPLESET_H
#define __SAMPLESET_H

#include "Sample.h"
#include "KDTree.h"
#include "mex.h"
//#include "vector.h"

#include "SampleSetHashing.h"

#include <map>


template<typename ValueType, typename AttributeType>
class SampleSet : public Persistent
{
public:
	typedef Sample<ValueType,AttributeType> _SampleType;

	SampleSet();
	SampleSet(const SampleSet& other);
	SampleSet( _SampleType& sample);
	SampleSet( _SampleType* samples, unsigned int numSamples);
	SampleSet( unsigned int numSamples, unsigned int valueDim,double* timeStamps,ValueType* values,AttributeType* attributes);
	SampleSet( std::vector<SampleSet<ValueType,AttributeType>*> SampleSets);
	~SampleSet();

	virtual ClassType getClassType(){return ct_SampleSet;}

	unsigned int getNumSamples() const {return m_num_samples;}
	unsigned int getValueDim() const {return m_value_dim;}

	void getValues(ValueType* values) const;
	ValueType* getValue(unsigned int i) const;
	void setValues(const ValueType* values);

	void getTimeStamps(double* timeStamps) const;
	void setTimeStamps(const double* timeStamps);

	void getAttributes(AttributeType* attributes) const;
	void setAttributes(const AttributeType* attributes);
	void getAttributes(AttributeType* attributes,const unsigned int* indices,unsigned int count) const;
	
	unsigned int getnUniqueSampleSets(){return nUniqueSampleSets;}

	void getNNTrajectories_inclusive(SampleSetWeight<ValueType,AttributeType>*& sortedByWeights,unsigned int* sizes, unsigned int k1 , const SampleSet<ValueType,AttributeType>& query);
	void getNNTrajectories_exclusive(SampleSetWeight<ValueType,AttributeType>*& sortedByWeights,unsigned int* sizes, unsigned int k1 , const SampleSet<ValueType,AttributeType>& query);

	void getNNTrajectoriesRange_exclusive(SampleSetWeightRange<ValueType,AttributeType>*& sortedByWeights,unsigned int* sizes, unsigned int k1 , unsigned int k2, const SampleSet<ValueType,AttributeType>& query);

	SampleSet operator+ (const SampleSet& other) const;
	const SampleSet& operator= (const SampleSet& other);

	unsigned int getHashKey(){return hashKey;}

	/* nearest neighbor related stuff */
	void initialize();
	bool isInitialized() const;
	void finalize();
	void findNearestNeighbors(const Sample<ValueType,AttributeType>& query,const int k, int* indices);
	void findNearestNeighbors(const SampleSet<ValueType,AttributeType>& query,const int k, int* indices, double* distances = 0);

	unsigned int countUniqueSampleSets();
	
	unsigned int getSampleSetID(){return m_SampleSetID;}
	void		 setSampleSetID(unsigned int ID){m_SampleSetID=ID;}

private:

	unsigned int   m_value_dim;
	unsigned int   m_num_samples;
	ValueType**    m_values; 
	double*        m_time_stamps;
	AttributeType* m_attributes;
	
	unsigned int   m_SampleSetID;

	// sample sets referenced by samples
	SampleSet<ValueType,AttributeType>**   m_sampleSets;
	// number of unique sample sets referenced by samples
	unsigned int nUniqueSampleSets;

	KDTree* m_kd_tree;

	// for hashing
	unsigned int hashKey;
	static unsigned int hashIndex;
};




template<typename ValueType,typename AttributeType> unsigned int SampleSet<ValueType,AttributeType>::hashIndex = 0;


// empty set
template<typename ValueType,typename AttributeType>
SampleSet<ValueType,AttributeType>::SampleSet()
:
m_value_dim(0),
m_num_samples(0),
m_values(0),
m_time_stamps(0),
m_attributes(0),
m_kd_tree(0),
m_sampleSets(0)
{

}


template<typename ValueType,typename AttributeType>
SampleSet<ValueType,AttributeType>::SampleSet(const SampleSet& other)
:
m_value_dim(other.m_value_dim),
m_num_samples(other.m_num_samples),
m_values((other.m_num_samples) ? new ValueType*[other.m_num_samples] : 0),
m_time_stamps((other.m_num_samples) ? new double[other.m_num_samples] : 0),
m_sampleSets((other.m_num_samples) ? new SampleSet<ValueType,AttributeType>* [other.m_num_samples] : 0),
m_attributes((other.m_num_samples) ? new AttributeType[other.m_num_samples] : 0),
m_kd_tree(0)
{
	hashKey = hashIndex;
	++hashIndex;

	for (unsigned int i = 0; i < m_num_samples; i++)
	{
		m_values[i] = new ValueType[m_value_dim];

		for (unsigned int d = 0; d < m_value_dim; d++)
		{
			m_values[i][d] = other.m_values[i][d];
		}

		m_time_stamps[i] = other.m_time_stamps[i];

		m_sampleSets[i] = other.m_sampleSets[i];

		m_attributes[i] = other.m_attributes[i];
	}
}


template<typename ValueType,typename AttributeType>
SampleSet<ValueType,AttributeType>::SampleSet( _SampleType& sample)
:
m_value_dim(0),
m_num_samples(1),
m_values(new ValueType*[1]),
m_time_stamps(new double[1]),
m_attributes(new AttributeType[1]),
m_sampleSets(new SampleSet<ValueType,AttributeType>*[1]),
m_kd_tree(0)
{
	hashKey = hashIndex;
	++hashIndex;

	m_value_dim = sample.getValueDim();

	if (m_value_dim)
	{
		m_values[1] = new ValueType[m_value_dim];

		for (unsigned int d = 0; d < m_value_dim; d++)
		{
			m_values[1][d] =  sample.getValue(d);
		}

	}
	m_time_stamps[1] = sample.getTimeStamp();
	
	if (sample.getSampleSet() != 0) m_sampleSets[1] = sample.getSampleSet();

	else  m_sampleSets[1] = this;
	m_attributes[1] = sample.getAttributes();
}


template<typename ValueType,typename AttributeType>
SampleSet<ValueType,AttributeType>::SampleSet( _SampleType* samples, unsigned int numSamples)
:
m_value_dim(0),
m_num_samples(numSamples),
m_values((numSamples) ? new ValueType*[numSamples] : 0),
m_time_stamps((numSamples) ? new double[numSamples] : 0),
m_sampleSets((numSamples) ? new SampleSet<ValueType,AttributeType>* [numSamples] : 0),
m_attributes((numSamples) ? new AttributeType[numSamples] : 0),
m_kd_tree(0)
{
	hashKey = hashIndex;
	++hashIndex;

	for (unsigned int i = 0; i < m_num_samples; i++)
	{
		unsigned int dim = samples[i].getValueDim();

		if (m_value_dim == 0)
		{
			m_value_dim = dim;
		}

		assert (m_value_dim == dim);

		m_values[i] = new ValueType[m_value_dim];

		for (unsigned int d = 0; d < m_value_dim; d++)
		{
			m_values[i][d] = samples[i].getValue(d);
		}

		m_time_stamps[i] = samples[i].getTimeStamp();

		if (samples[i].getSampleSet() != 0) m_sampleSets[i] = samples[i].getSampleSet();
		else  m_sampleSets[i] = this;

		m_attributes[i] = samples[i].getAttributes();
	}
}

template<typename ValueType,typename AttributeType>
SampleSet<ValueType,AttributeType>::SampleSet(
	const unsigned int numSamples,
	const unsigned int valueDim,
	double* timeStamps,
	ValueType* values,
	AttributeType* attributes)
	:
m_value_dim(valueDim),
m_num_samples(numSamples),
m_values((numSamples) ? new ValueType*[numSamples] : 0),
m_time_stamps((numSamples) ? new double[numSamples] : 0),
m_sampleSets((numSamples) ? new SampleSet<ValueType,AttributeType>*[numSamples] : 0),
m_attributes((numSamples) ? new AttributeType[numSamples] : 0),
m_kd_tree(0)	
{
	hashKey = hashIndex;
	++hashIndex;

//	mexPrintf("nNumSamples = %i\n",numSamples);

	for (unsigned int sample = 0; sample < numSamples; sample++)
	{ 
		m_time_stamps[sample] = timeStamps[sample];
		m_attributes[sample] = attributes[sample];
		m_sampleSets[sample] = this;
		m_values[sample] = new ValueType[valueDim];

		for (unsigned int d = 0; d < valueDim; d++)
			m_values[sample][d] = values[sample*valueDim+d];
	}
}


template<typename ValueType,typename AttributeType>
SampleSet<ValueType,AttributeType>::SampleSet(std::vector<SampleSet<ValueType,AttributeType>*> SampleSets){
	
	//check size of resulting Sample Set:
	unsigned int resNumSamples=0;
	for(unsigned int set=0;set<SampleSets.size();set++){
		resNumSamples+=SampleSets[set]->m_num_samples;
	//	mexPrintf("samples= %i",SampleSets[set]->m_num_samples);
	}
		
//	mexPrintf("#Sets= %i\n",SampleSets.size());
#if defined(_DEBUG) | defined(_VERBOSE)
	mexPrintf("SampleSet Size= %ix%i\n",resNumSamples,SampleSets[0]->m_value_dim);
#endif
		
	m_value_dim   = SampleSets[0]->m_value_dim;
	
	m_num_samples = resNumSamples;
	m_values      = new ValueType*   [resNumSamples];
	m_time_stamps = new double       [resNumSamples];
	m_attributes  = new AttributeType[resNumSamples];
	m_sampleSets  = new SampleSet<ValueType,AttributeType>* [resNumSamples];
	
	m_kd_tree	  = 0;

	unsigned int offset = 0;
	
	for (unsigned int set=0;set<SampleSets.size();set++){	

		for (unsigned int i = 0; i < SampleSets[set]->m_num_samples; i++)
		{
			m_values[offset+i] = new ValueType[m_value_dim];
			for (unsigned int d = 0; d < m_value_dim; d++)
			{
				m_values[offset+i][d] = SampleSets[set]->m_values[i][d];
			}
			m_time_stamps[offset+i] = SampleSets[set]->m_time_stamps[i];
			m_sampleSets [offset+i] = SampleSets[set]->m_sampleSets [i];
			m_attributes [offset+i] = SampleSets[set]->m_attributes [i];
		}
		offset += SampleSets[set]->m_num_samples;
	}
}




template<typename ValueType,typename AttributeType>
SampleSet<ValueType,AttributeType>::~SampleSet()
{
	for (unsigned int i = 0; i < m_num_samples; i++)
	{
		if (m_values[i])
			delete[] m_values[i];
	}

	if (m_values)
		delete[] m_values;

	if (m_time_stamps)
		delete[] m_time_stamps;

	if (m_attributes)
		delete[] m_attributes;

	if (m_sampleSets)
		delete[] m_sampleSets;

	if (m_kd_tree)
		delete m_kd_tree;
}

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::getAttributes(AttributeType* attributes) const
{
	for (unsigned int s = 0; s < m_num_samples; s++)
	{
		attributes[s] = m_attributes[s];
	}
}

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::getAttributes(AttributeType* attributes,const unsigned int* indices,unsigned int count) const
{
	for (unsigned int i = 0; i < count; i++)
	{
		attributes[i] = m_attributes[indices[i]];
	}
}

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::setAttributes(const AttributeType* attributes)
{
	for (unsigned int s = 0; s < m_num_samples; s++)
	{
		m_attributes[s] = attributes[s];
	}
}

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::getValues(ValueType* values) const
{
	for (unsigned int s = 0; s < m_num_samples; s++)
	{
		for (unsigned int d = 0; d < m_value_dim; d++)
		{
			values[s*m_value_dim+d] = m_values[s][d];
		}
	}
}

template<typename ValueType,typename AttributeType>
ValueType* SampleSet<ValueType,AttributeType>::getValue(unsigned int i) const{

	 return m_values[i];
}


template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::setValues(const ValueType* values)
{
	for (unsigned int s = 0; s < m_num_samples; s++)
	{
		for (unsigned int d = 0; d < m_value_dim; d++)
		{
			m_values[s][d] = values[s*m_value_dim+d];
		}
	}
}

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::getTimeStamps(double* timeStamps) const
{
	for (unsigned int i = 0; i < m_num_samples; i++)
		timeStamps[i] = m_time_stamps[i];
}

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::setTimeStamps(const double* timeStamps)
{
	for (unsigned int i = 0; i < m_num_samples; i++)
		m_time_stamps[i] = timeStamps[i];
}


template<typename ValueType,typename AttributeType>
SampleSet<ValueType,AttributeType> SampleSet<ValueType,AttributeType>::operator+(const SampleSet& other) const
{
	SampleSet<ValueType,AttributeType> result;

	result.m_num_samples = this->m_num_samples + other.m_num_samples;
	result.m_values      = new ValueType*   [result.m_num_samples];
	result.m_time_stamps = new double       [result.m_num_samples];
	result.m_attributes  = new AttributeType[result.m_num_samples];
	result.m_sampleSets  = new SampleSet<ValueType,AttributeType>* [result.m_num_samples];

	assert(this->m_value_dim == other.m_value_dim);

	result.m_value_dim = this->m_value_dim; 

	unsigned int offset = 0;

	// copy this elements
	for (unsigned int i = 0; i < this->m_num_samples; i++)
	{
		result.m_values[offset+i] = new ValueType[result.m_value_dim];

		for (unsigned int d = 0; d < result.m_value_dim; d++)
		{
			result.m_values[offset+i][d] = this->m_values[i][d];
		}

		result.m_time_stamps[offset+i] = this->m_time_stamps[i];
		result.m_sampleSets [offset+i] = this->m_sampleSets [i];
		result.m_attributes [offset+i] = this->m_attributes [i];
	}

	offset = this->m_num_samples;

	// copy other elements
	for (unsigned int i = 0; i < other.m_num_samples; i++)
	{
		result.m_values[offset+i] = new ValueType[result.m_value_dim];

		for (unsigned int d = 0; d < result.m_value_dim; d++)
		{
			result.m_values[offset+i][d] = other.m_values[i][d];
		}

		result.m_time_stamps[offset+i] = other.m_time_stamps[i];
		result.m_sampleSets [offset+i] = other.m_sampleSets [i];
		result.m_attributes [offset+i] = other.m_attributes [i];
	}

	return result;
}

template<typename ValueType,typename AttributeType>
const SampleSet<ValueType,AttributeType>& SampleSet<ValueType,AttributeType>::operator=(const SampleSet& other)
{
	for (unsigned int i = 0; i < m_num_samples; i++)
	{
		if (m_values[i])
			delete[] m_values[i];
	}

	if (m_values)
		delete[] m_values;

	if (m_time_stamps)
		delete[] m_time_stamps;

	if (m_attributes)
		delete[] m_attributes;

	if (m_sampleSets)
		delete[] m_sampleSets;

	if (m_kd_tree)
		delete m_kd_tree;

	m_value_dim   = other.m_value_dim;
	m_num_samples = other.m_num_samples;
	m_values      = new ValueType*[other.m_num_samples];
	m_time_stamps = new double[other.m_num_samples];
	m_attributes  = new AttributeType[other.m_num_samples];
	m_sampleSets = new SampleSet<ValueType,AttributeType>* [other.m_num_samples];

	for (unsigned int i = 0; i < m_num_samples; i++)
	{
		m_values[i] = new ValueType[m_value_dim];

		for (unsigned int d = 0; d < m_value_dim; d++)
		{
			m_values[i][d] = other.m_values[i][d];
		}

		m_time_stamps[i] = other.m_time_stamps[i];
		m_sampleSets[i] = other.m_sampleSets[i];

		m_attributes[i] = other.m_attributes[i];
	}

	return *this;
}

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::initialize()
{
	if (isInitialized()==true) return;
	finalize();
#if defined(_DEBUG) | defined(_VERBOSE)
	mexPrintf("[");
	mexPrintf("dim: %ix%i", m_num_samples, m_value_dim);
#endif
	m_kd_tree = new KDTree(m_values,m_num_samples,m_value_dim);
#if defined(_DEBUG) | defined(_VERBOSE)
	mexPrintf("]");
#endif
}


template<typename ValueType,typename AttributeType>
bool SampleSet<ValueType,AttributeType>::isInitialized() const
{
	return m_kd_tree != 0;
}


template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::finalize()
{
	nUniqueSampleSets = countUniqueSampleSets();
	if (isInitialized()) 
		delete m_kd_tree;
}


template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::findNearestNeighbors(const Sample<ValueType,AttributeType>& query, const int k, int* indices)
{
	if (!isInitialized()) initialize();
	m_kd_tree->searchNearestNeigbors(query.getValue(),k,indices);
}

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::findNearestNeighbors(
	const SampleSet<ValueType,AttributeType>& query,
	const int k,
	int* indices,
	double* distances)
{
	if (!isInitialized()) initialize();

	if (distances)
	{
		for (unsigned int i = 0; i < query.m_num_samples; i++)
		{
			m_kd_tree->searchNearestNeigbors(query.m_values[i],k,&(indices[i*k]),&(distances[i*k]));
		}
	}
	else
	{
		for (unsigned int i = 0; i < query.m_num_samples; i++)
		{
			m_kd_tree->searchNearestNeigbors(query.m_values[i],k,&(indices[i*k]));
		}
	}
}

template<typename ValueType,typename AttributeType> 
unsigned int SampleSet<ValueType,AttributeType>::countUniqueSampleSets()
{
	unsigned int hashTabSize = getNumSamples() >> 2;
	unsigned int nHashElements = getNumSamples();
	
	SampleSetHashing<ValueType,AttributeType>* hashTab = new SampleSetHashing<ValueType,AttributeType>(hashTabSize,nHashElements);

	for (unsigned int i=0; i < getNumSamples(); i++)
	{
		hashTab->addElement(*(m_sampleSets[i]));
	}

	return hashTab->getnElements();
};

template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::getNNTrajectories_inclusive(SampleSetWeight<ValueType,AttributeType>*& sortedByWeights,unsigned int* sizes, unsigned int k , const SampleSet<ValueType,AttributeType>& query)
{
	unsigned int sizeq = query.getNumSamples();
	unsigned int nHashElements = sizeq*k;
	
	if (nHashElements > nUniqueSampleSets) nHashElements = nUniqueSampleSets;
	unsigned int hashTabSize = nHashElements >> 2;
	if (hashTabSize < 1) hashTabSize = 1; 

	SampleSetWHashing<ValueType,AttributeType>* hashTab = new SampleSetWHashing<ValueType,AttributeType>(hashTabSize,nHashElements);

	int* indices = new int[k];

	for (int i=0;i < sizeq;i++)
	{
		m_kd_tree->searchNearestNeigbors(query.m_values[i],k,indices);

		double maxDistance = 0.0;
		for (unsigned int s = 0; s < m_value_dim; s++) 
		{
			double delta = (double)(m_values[indices[k-1]][s] - query.m_values[i][s]);
			maxDistance += delta*delta;
		}
		maxDistance = sqrt(maxDistance);

		for (int j=0;j<k;j++)
		{
			double weight = 0.0;
			for (unsigned int s = 0; s < m_value_dim; s++) 
			{
				double delta = (double)(m_values[indices[j]][s] - query.m_values[i][s]);
				weight += delta*delta;
			}
			weight = maxDistance - sqrt(weight);

			hashTab->addElementInclusive(SampleSetWeight<ValueType,AttributeType>(m_sampleSets[indices[j]],weight));
		}
	}

	hashTab->getElementsSorted(sortedByWeights,sizes);

	delete [] indices;
	delete hashTab;
};


template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::getNNTrajectories_exclusive(SampleSetWeight<ValueType,AttributeType>*& sortedByWeights,unsigned int* sizes, unsigned int k , const SampleSet<ValueType,AttributeType>& query)
{
	unsigned int sizeq = query.getNumSamples();
	unsigned int nHashElements = sizeq*k;

	if (nHashElements > nUniqueSampleSets) nHashElements = nUniqueSampleSets;
	unsigned int hashTabSize = nHashElements >> 2;
	if (hashTabSize < 1) hashTabSize = 1; 

	SampleSetWHashing<ValueType,AttributeType>* hashTab = new SampleSetWHashing<ValueType,AttributeType>(hashTabSize,nHashElements);

	int* indices = new int[k];

	nHashElements = k;
	if (nHashElements > nUniqueSampleSets) nHashElements = nUniqueSampleSets;
	hashTabSize   = k;

	SampleSetWHashing<ValueType,AttributeType>* hashTab2 = new SampleSetWHashing<ValueType,AttributeType>(hashTabSize,nHashElements);

	SampleSetWeight  <ValueType,AttributeType>* list     = new SampleSetWeight  <ValueType,AttributeType>[k];

	unsigned int kk;

	for (unsigned int i=0;i < sizeq;i++)
	{

		m_kd_tree->searchNearestNeigbors(query.m_values[i],k,indices);

		double maxDistance = 0.0;
		for (unsigned int s = 0; s < m_value_dim; s++) 
		{
			double delta = (double)(m_values[indices[k-1]][s] - query.m_values[i][s]);
			maxDistance += delta*delta;
		}
		maxDistance = sqrt(maxDistance);

		for (unsigned int j=0;j<k;j++)
		{
			double weight = 0.0;
			for (unsigned int s = 0; s < m_value_dim; s++) 
			{
				double delta = (double)(m_values[indices[j]][s] - query.m_values[i][s]);
				weight += delta*delta;
			}
			weight = maxDistance - sqrt(weight);

			SampleSetWeight<ValueType,AttributeType> tmp(m_sampleSets[indices[j]],weight);
			hashTab2->addElementExclusive(tmp);
		}

		hashTab2->getElements_2(list,&kk);
		hashTab2->reset();

		for (unsigned int j=0;j<kk;j++)
		{
			hashTab->addElementInclusive(list[j]);

		}
	}

	hashTab->getElementsSorted(sortedByWeights,sizes);

	delete [] indices;
	delete [] list;
	delete hashTab;
	delete hashTab2;
};




template<typename ValueType,typename AttributeType>
void SampleSet<ValueType,AttributeType>::getNNTrajectoriesRange_exclusive(SampleSetWeightRange<ValueType,AttributeType>*& sortedByWeights,unsigned int* sizes, unsigned int k1, unsigned int k2 , const SampleSet<ValueType,AttributeType>& query)
{
//	SampleSetWeightRange<ValueType,AttributeType>* sortedByWeights2;


	unsigned int sizeq = query.getNumSamples();
	unsigned int nHashElements = 2*k1;

	if (nHashElements > nUniqueSampleSets) nHashElements = nUniqueSampleSets;
	unsigned int hashTabSize = nHashElements >> 2;
	if (hashTabSize < 1) hashTabSize = 1;

	SampleSetWRHashing<ValueType,AttributeType>* hashTaba = new SampleSetWRHashing<ValueType,AttributeType>(hashTabSize,nHashElements);
	SampleSetWRHashing<ValueType,AttributeType>* hashTabb = new SampleSetWRHashing<ValueType,AttributeType>(hashTabSize,nHashElements);

	nHashElements = k2;
	if (nHashElements > nUniqueSampleSets) nHashElements = nUniqueSampleSets;
	hashTabSize   = k2;
	SampleSetWRHashing<ValueType,AttributeType>* hashTab2 = new SampleSetWRHashing<ValueType,AttributeType>(hashTabSize,nHashElements);

	SampleSetWeightRange  <ValueType,AttributeType>* list;
	int* indices;
	
	if (k1 > k2) 
	{
		indices = new int[k1];
		 list   = new SampleSetWeightRange  <ValueType,AttributeType>[k1];
	}	
	else 
	{
		indices = new int[k2];
		 list   = new SampleSetWeightRange  <ValueType,AttributeType>[k2];
	}
	
	unsigned int kk;

	// first sample of the query
	unsigned int i = 0;
	m_kd_tree->searchNearestNeigbors(query.m_values[i],k1,indices);

//	for (int bla=0;bla<k;bla++)
//		mexPrintf("----- %i --------\n",indices[bla]);

	double maxDistance = 0.0;
	for (unsigned int s = 0; s < m_value_dim; s++) 
	{
		double delta = (double)(m_values[indices[k1-1]][s] - query.m_values[i][s]);
		maxDistance += delta*delta;
	}
	maxDistance = sqrt(maxDistance);

	for (unsigned int j=0;j<k1;j++)
	{
		double weight = 0.0;
		for (unsigned int s = 0; s < m_value_dim; s++) 
		{
			double delta = (double)(m_values[indices[j]][s] - query.m_values[i][s]);
			weight += delta*delta;
		}
		weight = maxDistance - sqrt(weight);

		SampleSetWeightRange<ValueType,AttributeType> tmp(m_sampleSets[indices[j]],weight,indices[j],-1);
		hashTaba->addElementExclusive(tmp);
	}
	
//	hashTaba->getElements_1(sortedByWeights2,sizes);
//	for (unsigned int i=0;i<*sizes;i++) mexPrintf("-------->a)%i %i %f\n",i,sortedByWeights2[i].indices[0],sortedByWeights2[i].weight);
	

	// last sample of the query
	i = sizeq - 1;

	m_kd_tree->searchNearestNeigbors(query.m_values[i],k1,indices);

	maxDistance = 0.0;
	for (unsigned int s = 0; s < m_value_dim; s++) 
	{
		double delta = (double)(m_values[indices[k1-1]][s] - query.m_values[i][s]);
		maxDistance += delta*delta;
	}
	maxDistance = sqrt(maxDistance);

	for (unsigned int j=0;j<k1;j++)
	{
		double weight = 0.0;
		for (unsigned int s = 0; s < m_value_dim; s++) 
		{
			double delta = (double)(m_values[indices[j]][s] - query.m_values[i][s]);
			weight += delta*delta;
		}
		weight = maxDistance - sqrt(weight);

		SampleSetWeightRange<ValueType,AttributeType> tmp(m_sampleSets[indices[j]],weight,-1,indices[j]);
		hashTabb->addElementExclusive(tmp);
	}
	
//	hashTabb->getElements_1(sortedByWeights2,sizes);
//		for (unsigned int i=0;i<*sizes;i++) mexPrintf("-------->b)%i %i %f\n",i,sortedByWeights2[i].indices[1],sortedByWeights2[i].weight);

	hashTabb->getElements_2(list,&kk);

	for (unsigned int j=0;j<kk;j++)
	{
		hashTaba->addElementExistingInclusive(list[j]);
	}
	

	// the rest


	for (unsigned int i=0;i < sizeq;i++)
	{

		m_kd_tree->searchNearestNeigbors(query.m_values[i],k2,indices);

		double maxDistance = 0.0;
		for (unsigned int s = 0; s < m_value_dim; s++) 
		{
			double delta = (double)(m_values[indices[k2-1]][s] - query.m_values[i][s]);
			maxDistance += delta*delta;
		}
		maxDistance = sqrt(maxDistance);

		for (unsigned int j=0;j<k2;j++)
		{
			double weight = 0.0;
			for (unsigned int s = 0; s < m_value_dim; s++) 
			{
				double delta = (double)(m_values[indices[j]][s] - query.m_values[i][s]);
				weight += delta*delta;
			}
			weight = maxDistance - sqrt(weight);

			SampleSetWeightRange<ValueType,AttributeType> tmp(m_sampleSets[indices[j]],weight,-1,-1);
			hashTab2->addElementExclusive(tmp);
		}

		hashTab2->getElements_2(list,&kk);
		hashTab2->reset();

		for (unsigned int j=0;j<kk;j++)
		{
			hashTaba->addElementExistingInclusive(list[j]);

		}
	}

	hashTaba->getElementsSorted(sortedByWeights,sizes);



	delete [] indices;
	delete [] list;
	delete hashTaba;
	delete hashTabb;
	delete hashTab2;
};

/*
template<typename ValueType,typename AttributeType>
void getnNNTrajectories(TrajectoryIndexWeight* sortedByWeight,unsigned int* sizes, unsigned int k , const SampleSet<ValueType,AttributeType>& query,unsigned int sizeq)
{

unsigned int nHashElements = nQuery*k;
unsigned int hashTabSize = nHashElements >> 2;
if (hashTabSize < 1) nHashElements = 1; 
TrajectoryHashing* hashTab = new TrajectoryHashing(hashTabSize,nHashElements);
for (unsigned int i=0; i <  
hashTab->addTrajectories(query.m_attributes[i]);
hashTab->getSortedByWeight(sortedByWeight,sizes);
};
*/

//template<typename ValueType,typename AttributeType>
//void SampleSet<ValueType,AttributeType>::findDominatingAttribute(
//	const SampleSet<ValueType,AttributeType>& query,
//	const int k,
//	AttributeType* attributes,
//	const unsigned int amountToReturn,
//	double* percentage)
//{
//	const unsigned int num_samples = query.getNumSamples();
//	int *indices = new int[num_samples*k];
//	std::map<AttributeType,unsigned int> occurences;
//
//	findNearestNeighbors(query,k,indices);
//
//	std::map<AttributeType,unsigned int>::iterator I;
//	for (unsigned int s = 0; s < num_samples; s++)
//	{
//		for (unsigned int i = 0; i < k; i++)
//		{
//			AttributeType att = m_attributes[indices[k*s+i]];
//			I = occurences.find(att);
//			if (I != occurences.end())
//			{
//				++(I->second);
//			}
//			else
//			{
//				occurences[att] = 1;
//			}
//		}
//		
//	}
//
//	delete[] indices;
//}

#endif /* __SAMPLESET_H */
