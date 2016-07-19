#ifndef __TRAJECTORY_H
#define __TRAJECTORY_H

#include "Sample.h"
#include "SampleSet.h"

template<typename ValueType,typename AttributeType>
class Trajectory : public SampleSet<ValueType,AttributeType>
{

public:

	Trajectory();
	Trajectory(const SampleSet<ValueType,AttributeType>& other);
	Trajectory(const unsigned int numSamples,const unsigned int valueDim,double* timeStamps,ValueType* values,AttributeType* attributes);

	virtual ClassType getClassType(){return ct_Trajectory;}
	
};

template<typename ValueType,typename AttributeType>
Trajectory<ValueType,AttributeType>::Trajectory()
:
	SampleSet<ValueType,AttributeType>()
{

}

template<typename ValueType,typename AttributeType>
Trajectory<ValueType,AttributeType>::Trajectory(const SampleSet<ValueType,AttributeType>& other)
:
	SampleSet<ValueType,AttributeType>(other)
{
	
}

template<typename ValueType,typename AttributeType>
Trajectory<ValueType,AttributeType>::Trajectory(const unsigned int numSamples,const unsigned int valueDim,double* timeStamps,ValueType* values,AttributeType* attributes)
{
	SampleSet<ValueType,AttributeType>(numSamples, valueDim, timeStamps, values, attributes);
}

#endif /* __TRAJECTORY_H */
