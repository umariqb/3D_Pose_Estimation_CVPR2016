#ifndef __TRAJECTORYSET_H
#define __TRAJECTORYSET_H

#include "Trajectory.h"
#include "SampleSet.h"
#include "Sample.h"
#include <vector>

template<typename ValueType,typename AttributeType>
class TrajectorySet : public Persistent
{
	
public:	
	TrajectorySet();
	TrajectorySet(const Trajectory<ValueType,AttributeType>* trajectory);
	TrajectorySet(const Trajectory<ValueType,AttributeType>* trajectories, unsigned int num_trajectories);

	Trajectory<ValueType,AttributeType> getTrajectory(unsigned int num);

	TrajectorySet operator+( TrajectorySet<ValueType,AttributeType>& other);
	TrajectorySet operator+( TrajectorySet<ValueType,AttributeType>* other);
	TrajectorySet operator+( Trajectory   <ValueType,AttributeType>* other);

	virtual ClassType getClassType(){return ct_TrajectorySet;}
	unsigned int getNumTrajectories(){return m_numTrajectories;};

private:

	unsigned int   m_numTrajectories;
	std::vector< Trajectory<ValueType,AttributeType> > m_vecTrajectories;
	
};


// empty TrajectorySet
template<typename ValueType, typename AttributeType>
TrajectorySet<ValueType,AttributeType>::TrajectorySet()
{
	m_numTrajectories = 0;
}

template<typename ValueType, typename AttributeType>
TrajectorySet<ValueType,AttributeType>::TrajectorySet(const Trajectory<ValueType,AttributeType>* trajectory)
{
	
	m_vecTrajectories.push_back(*trajectory);
	m_numTrajectories = m_vecTrajectories.size();
	
}

template<typename ValueType, typename AttributeType>
Trajectory<ValueType,AttributeType> TrajectorySet<ValueType,AttributeType>::getTrajectory(unsigned int num){
	
	if(num < m_numTrajectories)
		return m_vecTrajectories[num];
	else
		return 0;
}

template<typename ValueType,typename AttributeType>
TrajectorySet<ValueType,AttributeType> TrajectorySet<ValueType,AttributeType>::operator+(TrajectorySet<ValueType,AttributeType>& other)
{
	
	m_vecTrajectories.reserve(other.getNumTrajectories());
	
	for(unsigned int element=0; element < other.getNumTrajectories(); element++)
		m_vecTrajectories.push_back(other.m_vecTrajectories[element]);
	
	m_numTrajectories = m_vecTrajectories.size();
	return *this;
}


template<typename ValueType,typename AttributeType>
TrajectorySet<ValueType,AttributeType> TrajectorySet<ValueType,AttributeType>::operator+(TrajectorySet<ValueType,AttributeType>* other)
{

	m_vecTrajectories.reserve(other->getNumTrajectories()); 
	
	for(unsigned int element=0; element < other->getNumTrajectories(); element++)
		m_vecTrajectories.push_back(other->m_vecTrajectories[element]);
	
	m_numTrajectories = m_vecTrajectories.size();
	return *this;
}

template<typename ValueType,typename AttributeType>
TrajectorySet<ValueType,AttributeType> TrajectorySet<ValueType,AttributeType>::operator+(Trajectory<ValueType,AttributeType>* other)
{
	m_vecTrajectories.push_back(*other);
	m_numTrajectories = m_vecTrajectories.size();
	
	return *this;
}

#endif /* __TRAJECTORYSET_H */
