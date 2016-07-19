#ifndef __SAMPLE_H
#define __SAMPLE_H

#include <exception>
#ifdef _DEBUG
	#include <assert.h>
#else
	#define assert(a)
#endif 

#include "Persistent.h"

template<typename ValueType, typename AttributeType> class SampleSet;

template<typename ValueType, typename AttributeType>
class Sample : public Persistent
{
public:
	Sample();
	Sample(const Sample& other);
	Sample(unsigned int valueDim);
	Sample(double timeStamp,unsigned int valueDim, SampleSet<ValueType,AttributeType>* ss ,const ValueType* values,const AttributeType& attributes);
	virtual ~Sample();

	virtual ClassType getClassType(){return ct_Sample;}

	const ValueType& getValue(unsigned int index) const;
	void setValue(unsigned int index,const ValueType& value);
	void getValues(ValueType* values) const;
	void setValues(const ValueType* values);

	unsigned int getValueDim() const {return m_value_dim;}
	void setValueDim(const unsigned int dim);

	const double& getTimeStamp() const {return m_time_stamp;}
	void setTimeStamp(const double& timeStamp){m_time_stamp = timeStamp;}

	const AttributeType& getAttributes() const {return m_attributes;}
	void setAttributes(const AttributeType& attributes){m_attributes = attributes;}

	SampleSet<ValueType,AttributeType>* getSampleSet() const {return m_sampleSet;}
	void setSampleSet(SampleSet<ValueType,AttributeType>* ss) {m_sampleSet=ss;}

	inline double l1Distance(Sample& s)
	{
		if (s.getValueDim() != m_value_dim) return -1.0;
		double result = 0.0;
		for (unsigned int i=0;i<m_value_dim;i++) result += fabs((double)(getValue(i) - s.getValue(i)));
		return result;
	};

	const Sample& operator= (const Sample& other);

		  Sample  operator* (const double scalar) const;
	const Sample& operator*=(const double scalar);

		  Sample  operator+ (const Sample& other) const;
	const Sample& operator+=(const Sample& other);

private:
	

	unsigned int m_value_dim;
	ValueType*   m_values;

	AttributeType m_attributes;
	double        m_time_stamp;

	SampleSet<ValueType,AttributeType>* m_sampleSet;
};

template<typename ValueType, typename AttributeType>
Sample<ValueType,AttributeType>::Sample()
:
	m_value_dim(0),
	m_values(0),
	m_attributes(),
	m_time_stamp(0),
	m_sampleSet(0)
{

}

template<typename ValueType, typename AttributeType>
Sample<ValueType,AttributeType>::Sample(
	unsigned int         valueDim)
:
	m_value_dim(valueDim),
	m_values(new ValueType[valueDim]),
	m_attributes(),
	m_time_stamp(0),
	m_sampleSet(0)
{

}

template<typename ValueType, typename AttributeType>
Sample<ValueType,AttributeType>::Sample(const Sample<ValueType,AttributeType>& other)
:
	m_value_dim(other.m_value_dim),
	m_values(new ValueType[other.m_value_dim]),
	m_attributes(other.m_attributes),
	m_time_stamp(other.m_time_stamp),
	m_sampleSet(other.m_sampleSet)
{
	for (unsigned int i = 0; i < m_value_dim; i++)
	{
		m_values[i] = other.m_values[i];
	}
}

template<typename ValueType, typename AttributeType>
Sample<ValueType,AttributeType>::Sample(
	double               timeStamp,
	unsigned int         valueDim,
	SampleSet<ValueType,AttributeType>* ss,
	const ValueType*     values,
	const AttributeType& attributes)
:
	m_value_dim(valueDim),
	m_values(new ValueType[valueDim]),
	m_attributes(attributes),
	m_time_stamp(timeStamp),
	m_sampleSet(ss)
{

}

template<typename ValueType, typename AttributeType>
Sample<ValueType,AttributeType>::~Sample()
{
	if (m_values)
		delete[] m_values;
}

template<typename ValueType, typename AttributeType>
const ValueType& Sample<ValueType,AttributeType>::getValue(unsigned int index) const
{
	if (m_values && index < m_value_dim)
	{
		return m_values[index];
	}
	else
	{
		return ValueType();
	}
}


template<typename ValueType, typename AttributeType>
void Sample<ValueType,AttributeType>::setValue(unsigned int index,const ValueType& value)
{
	if (m_values && index < m_value_dim)
		m_values[index] = value;
}

template<typename ValueType, typename AttributeType>
void Sample<ValueType,AttributeType>::getValues(ValueType* values) const
{
	for (unsigned int i = 0; i < m_value_dim; i++)
		values[i] = m_values[i];
}

template<typename ValueType, typename AttributeType>
void Sample<ValueType,AttributeType>::setValues(const ValueType* values)
{
	for (unsigned int i = 0; i < m_value_dim; i++)
		m_values[i] = values[i];
}

template<typename ValueType, typename AttributeType>
void Sample<ValueType,AttributeType>::setValueDim(const unsigned int dim)
{
	if (dim != m_value_dim)
	{
		if (m_values)
			delete[] m_values;

		m_values = new ValueType[dim];

		m_value_dim = dim;
	}
}

template<typename ValueType, typename AttributeType>
const Sample<ValueType,AttributeType>& Sample<ValueType,AttributeType>::operator=(const Sample<ValueType,AttributeType>& other)
{
	if (m_value_dim != other.m_value_dim)
	{
		if (m_values)
			delete[] m_values;

		m_values = new ValueType[other.m_value_dim];

		m_value_dim = other.m_value_dim;
	}

	m_time_stamp = other.m_time_stamp;

	for (unsigned int i = 0; i < m_value_dim; i++)
	{
		m_values[i] = other.m_values[i];
	}

	m_attributes = other.m_attributes;

	m_sampleSet= other.m_sampleSet;

	return *this;
}

template<typename ValueType, typename AttributeType>
Sample<ValueType,AttributeType> Sample<ValueType,AttributeType>::operator* (const double scalar) const
{
	Sample<ValueType,AttributeType> result(*this);
	result *= scalar;
	return result;
}

template<typename ValueType, typename AttributeType>
const Sample<ValueType,AttributeType>& Sample<ValueType,AttributeType>::operator*=(const double scalar)
{
	for (unsigned int i = 0; i < m_value_dim; i++)
	{
		m_values[i] *= scalar;
	}

	m_time_stamp *= scalar;
	m_attributes *= scalar;

	return *this;
}

template<typename ValueType, typename AttributeType>
Sample<ValueType,AttributeType>  Sample<ValueType,AttributeType>::operator+ (const Sample<ValueType,AttributeType>& other) const
{
	Sample<ValueType,AttributeType> result(*this);
	result += other;
	return result;
}

template<typename ValueType, typename AttributeType>
const Sample<ValueType,AttributeType>& Sample<ValueType,AttributeType>::operator+=(const Sample<ValueType,AttributeType>& other)
{
	assert(m_value_dim == other.m_value_dim);

	for (unsigned int i = 0; i < m_value_dim; i++)
	{
		m_values[i] += other.m_values[i];
	}

	m_time_stamp += other.m_time_stamp;
	m_attributes += other.m_attributes;

	return *this;
}

#endif /* __SAMPLE_H */
